package com.pqc.unified;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.http.HttpServer;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;

/**
 * Main Verticle for PQC Unified Platform
 * Combines Domain Scanner, File Encryptor, and Secure Messaging
 */
public class MainVerticle extends AbstractVerticle {
    private static final Logger logger = LoggerFactory.getLogger(MainVerticle.class);
    
    private PgPool dbPool;
    private JsonObject config;
    
    // Service handlers
    private ScannerHandler scannerHandler;
    private FileEncryptorHandler fileHandler;
    private ChatHandler chatHandler;
    
    @Override
    public void start(Promise<Void> startPromise) {
        logger.info("Starting PQC Unified Platform...");
        
        // Load configuration
        loadConfiguration();
        
        // Initialize database pool
        initializeDatabase();
        
        // Initialize service handlers
        initializeHandlers();
        
        // Create HTTP server and router
        HttpServer server = vertx.createHttpServer();
        Router router = createRouter();
        
        // Start server
        int port = config.getInteger("http.port", 8080);
        server.requestHandler(router)
              .listen(port)
              .onSuccess(s -> {
                  logger.info("╔════════════════════════════════════════════════════════════╗");
                  logger.info("║   PQC UNIFIED PLATFORM - Successfully Started              ║");
                  logger.info("╠════════════════════════════════════════════════════════════╣");
                  logger.info("║   Port:              {}                                   ║", port);
                  logger.info("║   URL:               http://localhost:{}                  ║", port);
                  logger.info("╠════════════════════════════════════════════════════════════╣");
                  logger.info("║   Features:                                                ║");
                  logger.info("║   • Domain Scanner    - TLS/PQC certificate analysis       ║");
                  logger.info("║   • File Encryptor    - Quantum-safe file encryption       ║");
                  logger.info("║   • Secure Messaging  - Real-time encrypted chat           ║");
                  logger.info("╠════════════════════════════════════════════════════════════╣");
                  logger.info("║   Cryptography:      ML-KEM-768 + AES-256-GCM              ║");
                  logger.info("║   Java Version:      24 (Native PQC Support)               ║");
                  logger.info("╚════════════════════════════════════════════════════════════╝");
                  startPromise.complete();
              })
              .onFailure(err -> {
                  logger.error("Failed to start server", err);
                  startPromise.fail(err);
              });
    }
    
    private void loadConfiguration() {
        try {
            String configPath = "src/main/resources/config.json";
            if (Files.exists(Paths.get(configPath))) {
                String content = Files.readString(Paths.get(configPath));
                config = new JsonObject(content);
                logger.info("Configuration loaded from: {}", configPath);
            } else {
                config = config();
                logger.info("Using default configuration");
            }
            
            // Ensure upload directories exist
            createDirectories();
            
        } catch (Exception e) {
            logger.warn("Could not load config file, using defaults", e);
            config = new JsonObject()
                .put("http.port", 8080)
                .put("database", new JsonObject()
                    .put("host", "localhost")
                    .put("port", 5432)
                    .put("database", "pqc_unified")
                    .put("user", "postgres")
                    .put("password", "postgres"));
        }
    }
    
    private void createDirectories() {
        try {
            new File("uploads").mkdirs();
            new File("uploads/encrypted").mkdirs();
            new File("logs").mkdirs();
            logger.info("Created required directories");
        } catch (Exception e) {
            logger.error("Failed to create directories", e);
        }
    }
    
    private void initializeDatabase() {
        try {
            JsonObject dbConfig = config.getJsonObject("database");
            
            PgConnectOptions connectOptions = new PgConnectOptions()
                .setHost(dbConfig.getString("host", "localhost"))
                .setPort(dbConfig.getInteger("port", 5432))
                .setDatabase(dbConfig.getString("database", "pqc_unified"))
                .setUser(dbConfig.getString("user", "postgres"))
                .setPassword(dbConfig.getString("password", "postgres"));
            
            PoolOptions poolOptions = new PoolOptions()
                .setMaxSize(dbConfig.getInteger("maxPoolSize", 10));
            
            dbPool = PgPool.pool(vertx, connectOptions, poolOptions);
            logger.info("Database pool initialized");
            
        } catch (Exception e) {
            logger.warn("Database initialization failed (optional for some features)", e);
        }
    }
    
    private void initializeHandlers() {
        scannerHandler = new ScannerHandler(vertx, dbPool, config);
        fileHandler = new FileEncryptorHandler(vertx, config);
        chatHandler = new ChatHandler(vertx, config);
        logger.info("Service handlers initialized");
    }
    
    private Router createRouter() {
        Router router = Router.router(vertx);
        
        // CORS handler
        router.route().handler(CorsHandler.create()
            .addOrigin("*")
            .allowedMethod(io.vertx.core.http.HttpMethod.GET)
            .allowedMethod(io.vertx.core.http.HttpMethod.POST)
            .allowedMethod(io.vertx.core.http.HttpMethod.PUT)
            .allowedMethod(io.vertx.core.http.HttpMethod.DELETE)
            .allowedHeader("Content-Type")
            .allowedHeader("Authorization"));
        
        // Body handler for POST requests
        router.route().handler(BodyHandler.create()
            .setUploadsDirectory("uploads")
            .setDeleteUploadedFilesOnEnd(false));
        
        // Health check
        router.get("/api/health").handler(ctx -> {
            JsonObject health = new JsonObject()
                .put("status", "UP")
                .put("timestamp", System.currentTimeMillis())
                .put("services", new JsonObject()
                    .put("scanner", "available")
                    .put("fileEncryptor", "available")
                    .put("chat", "available"))
                .put("cryptography", new JsonObject()
                    .put("algorithm", "ML-KEM-768")
                    .put("encryption", "AES-256-GCM"));
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(health.encode());
        });
        
        // Domain Scanner API routes
        router.post("/api/scanner/scan").handler(scannerHandler::handleScan);
        router.get("/api/scanner/results").handler(scannerHandler::handleGetResults);
        router.get("/api/scanner/result/:id").handler(scannerHandler::handleGetResult);
        router.get("/api/scanner/stats").handler(scannerHandler::handleGetStats);
        
        // File Encryptor API routes
        router.post("/api/file/encrypt").handler(fileHandler::handleEncrypt);
        router.post("/api/file/decrypt").handler(fileHandler::handleDecrypt);
        router.get("/api/file/list").handler(fileHandler::handleListFiles);
        router.get("/api/file/download/:filename").handler(fileHandler::handleDownload);
        
        // Chat API routes
        router.post("/api/chat/session/create").handler(chatHandler::handleCreateSession);
        router.post("/api/chat/session/join").handler(chatHandler::handleJoinSession);
        router.post("/api/chat/message/send").handler(chatHandler::handleSendMessage);
        router.get("/api/chat/session/:id").handler(chatHandler::handleGetSession);
        router.get("/api/chat/sessions").handler(chatHandler::handleListSessions);
        
        // Static files (frontend)
        router.route("/*").handler(StaticHandler.create("webroot")
            .setIndexPage("index.html")
            .setCachingEnabled(false));
        
        logger.info("Router configured with all API endpoints");
        return router;
    }
    
    @Override
    public void stop(Promise<Void> stopPromise) {
        logger.info("Stopping PQC Unified Platform...");
        
        if (dbPool != null) {
            dbPool.close();
        }
        
        stopPromise.complete();
        logger.info("PQC Unified Platform stopped");
    }
}

// Made with Bob
