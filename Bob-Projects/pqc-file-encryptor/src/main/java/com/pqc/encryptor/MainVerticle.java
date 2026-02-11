package com.pqc.encryptor;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.http.HttpServer;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.ext.web.handler.StaticHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

/**
 * Main Verticle - Entry point for the PQC File Encryptor application
 */
public class MainVerticle extends AbstractVerticle {
    private static final Logger logger = LoggerFactory.getLogger(MainVerticle.class);
    
    private FileStorageService storageService;
    private Java22PQCCryptoService cryptoService;
    private FileEncryptionService encryptionService;
    private ApiHandler apiHandler;
    
    @Override
    public void start(Promise<Void> startPromise) {
        try {
            // Load configuration
            JsonObject config = loadConfig();
            
            logger.info("Starting PQC File Encryptor...");
            logger.info("Configuration loaded: {}", config.encodePrettily());
            
            // Initialize services
            initializeServices(config);
            
            // Setup HTTP server and routes
            setupServer(config, startPromise);
            
        } catch (Exception e) {
            logger.error("Failed to start application", e);
            startPromise.fail(e);
        }
    }
    
    /**
     * Load configuration from file
     */
    private JsonObject loadConfig() throws Exception {
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("config.json")) {
            if (is == null) {
                throw new RuntimeException("config.json not found in resources");
            }
            String configStr = new String(is.readAllBytes(), StandardCharsets.UTF_8);
            return new JsonObject(configStr);
        }
    }
    
    /**
     * Initialize all services
     */
    private void initializeServices(JsonObject config) {
        logger.info("Initializing services...");
        
        // Initialize file storage service (reliable alternative to database)
        storageService = new FileStorageService(vertx);
        
        // Initialize crypto service (Java 24 native ML-KEM)
        cryptoService = new Java22PQCCryptoService(vertx);
        
        // Initialize file encryption service
        encryptionService = new FileEncryptionService(
                cryptoService,
                storageService,
                config.getJsonObject("encryption")
        );
        
        // Initialize API handler
        apiHandler = new ApiHandler(
                encryptionService,
                storageService,
                config.getJsonObject("encryption").getString("uploadDirectory", "uploads")
        );
        
        logger.info("Services initialized successfully with file-based storage");
    }
    
    /**
     * Setup HTTP server and routes
     */
    private void setupServer(JsonObject config, Promise<Void> startPromise) {
        Router router = Router.router(vertx);
        
        // Enable CORS
        router.route().handler(CorsHandler.create()
                .addOrigin("*")
                .allowedMethod(io.vertx.core.http.HttpMethod.GET)
                .allowedMethod(io.vertx.core.http.HttpMethod.POST)
                .allowedMethod(io.vertx.core.http.HttpMethod.PUT)
                .allowedMethod(io.vertx.core.http.HttpMethod.DELETE)
                .allowedHeader("Content-Type")
                .allowedHeader("Authorization"));
        
        // Body handler for JSON and file uploads
        router.route().handler(BodyHandler.create()
                .setUploadsDirectory("uploads/temp")
                .setDeleteUploadedFilesOnEnd(true));
        
        // API Routes
        router.post("/api/upload").handler(apiHandler.handleFileUpload());
        router.post("/api/encrypt").handler(apiHandler.handleEncrypt());
        router.post("/api/decrypt").handler(apiHandler.handleDecrypt());
        router.get("/api/records").handler(apiHandler.handleGetRecords());
        router.get("/api/records/:id").handler(apiHandler.handleGetRecord());
        router.get("/api/dashboard").handler(apiHandler.handleGetDashboard());
        router.get("/api/key-stats").handler(apiHandler.handleGetKeyStats());
        router.get("/api/size-comparison").handler(apiHandler.handleGetSizeComparison());
        
        // Health check endpoint
        router.get("/api/health").handler(ctx -> {
            ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                            .put("status", "healthy")
                            .put("service", "PQC File Encryptor")
                            .put("timestamp", System.currentTimeMillis())
                            .encode());
        });
        
        // Serve static files (web UI) - must be last route
        router.route("/*").handler(StaticHandler.create("webroot"));
        
        // Create HTTP server
        JsonObject httpConfig = config.getJsonObject("http");
        int port = httpConfig.getInteger("port", 8080);
        String host = httpConfig.getString("host", "0.0.0.0");
        
        HttpServer server = vertx.createHttpServer();
        server.requestHandler(router)
                .listen(port, host)
                .onSuccess(s -> {
                    logger.info("╔════════════════════════════════════════════════════════════╗");
                    logger.info("║  PQC File Encryptor Started Successfully                  ║");
                    logger.info("╠════════════════════════════════════════════════════════════╣");
                    logger.info("║  HTTP Server: http://{}:{} ║", host, port);
                    logger.info("║  Dashboard:   http://{}:{}/ ║", host, port);
                    logger.info("║  API:         http://{}:{}/api/ ║", host, port);
                    logger.info("╚════════════════════════════════════════════════════════════╝");
                    startPromise.complete();
                })
                .onFailure(err -> {
                    logger.error("Failed to start HTTP server", err);
                    startPromise.fail(err);
                });
    }
    
    @Override
    public void stop(Promise<Void> stopPromise) {
        logger.info("Stopping PQC File Encryptor...");
        logger.info("PQC File Encryptor stopped");
        stopPromise.complete();
    }
    
    /**
     * Main method for standalone execution
     */
    public static void main(String[] args) {
        io.vertx.core.Vertx vertx = io.vertx.core.Vertx.vertx();
        vertx.deployVerticle(new MainVerticle())
                .onSuccess(id -> logger.info("MainVerticle deployed successfully - ID: {}", id))
                .onFailure(err -> {
                    logger.error("Failed to deploy MainVerticle", err);
                    System.exit(1);
                });
    }
}

// Made with Bob
