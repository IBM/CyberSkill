package com.pqc.chat;

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
 * Main Verticle for PQC Chat Application
 * Reads configuration from config.json or falls back to default port
 */
public class MainVerticle extends AbstractVerticle {
    private static final Logger logger = LoggerFactory.getLogger(MainVerticle.class);
    
    private static final int DEFAULT_PORT = 8080;
    private static final String CONFIG_FILE = "config.json";
    
    @Override
    public void start(Promise<Void> startPromise) {
        // Load configuration from file
        JsonObject config = loadConfiguration();
        
        ApiHandler apiHandler = new ApiHandler();
        
        // Create router
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
        
        // Body handler for POST requests
        router.route().handler(BodyHandler.create());
        
        // API Routes
        router.get("/api/health").handler(apiHandler::healthCheck);
        router.post("/api/sessions").handler(apiHandler::createSession);
        router.get("/api/sessions").handler(apiHandler::listSessions);
        router.get("/api/sessions/:sessionId").handler(apiHandler::getSessionInfo);
        router.get("/api/sessions/:sessionId/messages").handler(apiHandler::getMessages);
        router.post("/api/sessions/:sessionId/messages").handler(apiHandler::sendMessage);
        
        // Static file handler for web UI
        router.route("/*").handler(StaticHandler.create("webroot"));
        
        // Determine port: config file > Vert.x config > default
        int port = config.getInteger("http.port",
                    config().getInteger("http.port", DEFAULT_PORT));
        
        logger.info("Configuration loaded - Port: {}", port);
        
        HttpServer server = vertx.createHttpServer();
        
        server.requestHandler(router)
            .listen(port)
            .onSuccess(http -> {
                logger.info("PQC Chat Server started successfully on port {}", port);
                logger.info("Access the application at: http://localhost:{}", port);
                startPromise.complete();
            })
            .onFailure(err -> {
                logger.error("Failed to start server on port {}", port, err);
                startPromise.fail(err);
            });
    }
    
    /**
     * Load configuration from config.json file
     * Falls back to empty config if file not found
     */
    private JsonObject loadConfiguration() {
        try {
            InputStream configStream = getClass().getClassLoader()
                .getResourceAsStream(CONFIG_FILE);
            
            if (configStream != null) {
                String configContent = new String(configStream.readAllBytes(),
                    StandardCharsets.UTF_8);
                JsonObject config = new JsonObject(configContent);
                logger.info("Configuration file loaded: {}", CONFIG_FILE);
                return config;
            } else {
                logger.warn("Configuration file not found: {}, using defaults", CONFIG_FILE);
                return new JsonObject();
            }
        } catch (Exception e) {
            logger.error("Error loading configuration file: {}", CONFIG_FILE, e);
            return new JsonObject();
        }
    }
    
    @Override
    public void stop(Promise<Void> stopPromise) {
        logger.info("PQC Chat Server stopping...");
        stopPromise.complete();
    }
}
