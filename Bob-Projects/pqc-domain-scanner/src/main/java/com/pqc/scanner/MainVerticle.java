package com.pqc.scanner;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.http.HttpServer;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class MainVerticle extends AbstractVerticle {
    
    private static final Logger logger = LoggerFactory.getLogger(MainVerticle.class);
    private PgPool pgPool;
    private DomainScanner domainScanner;
    
    @Override
    public void start(Promise<Void> startPromise) {
        logger.info("=".repeat(60));
        logger.info("Starting PQC Domain Scanner Application");
        logger.info("=".repeat(60));
        
        // Load configuration
        JsonObject config = config();
        if (config.isEmpty()) {
            logger.info("No config provided via launcher, loading default config");
            config = loadDefaultConfig();
        } else {
            logger.info("Using config provided via launcher");
        }
        
        logger.debug("Configuration: {}", config.encodePrettily());
        
        // Initialize database connection
        try {
            logger.info("Initializing database connection...");
            initDatabase(config.getJsonObject("database", new JsonObject()));
            logger.info("✓ Database connection initialized successfully");
        } catch (Exception e) {
            logger.error("✗ Failed to initialize database connection", e);
            startPromise.fail(e);
            return;
        }
        
        // Initialize domain scanner
        try {
            logger.info("Initializing domain scanner...");
            domainScanner = new DomainScanner(vertx, pgPool, config.getJsonObject("scanner", new JsonObject()));
            logger.info("✓ Domain scanner initialized successfully");
        } catch (Exception e) {
            logger.error("✗ Failed to initialize domain scanner", e);
            startPromise.fail(e);
            return;
        }
        
        // Create HTTP server and router
        logger.info("Creating HTTP server and router...");
        HttpServer server = vertx.createHttpServer();
        Router router = createRouter();
        
        int port = config.getJsonObject("http", new JsonObject()).getInteger("port", 8888);
        String host = config.getJsonObject("http", new JsonObject()).getString("host", "0.0.0.0");
        
        logger.info("Starting HTTP server on {}:{}", host, port);
        
        server.requestHandler(router)
            .listen(port, host)
            .onSuccess(s -> {
                logger.info("=".repeat(60));
                logger.info("✓ PQC Domain Scanner started successfully!");
                logger.info("✓ Dashboard: http://localhost:{}", port);
                logger.info("✓ API: http://localhost:{}/api", port);
                logger.info("✓ Health Check: http://localhost:{}/api/health", port);
                logger.info("=".repeat(60));
                startPromise.complete();
            })
            .onFailure(err -> {
                logger.error("✗ Failed to start HTTP server on {}:{}", host, port, err);
                startPromise.fail(err);
            });
    }
    
    private JsonObject loadDefaultConfig() {
        try {
            logger.info("Attempting to load config.json...");
            
            // Try to load from classpath first (for JAR)
            logger.debug("Trying classpath: config.json");
            InputStream is = getClass().getClassLoader().getResourceAsStream("config.json");
            if (is != null) {
                String content = new String(is.readAllBytes(), StandardCharsets.UTF_8);
                logger.info("✓ Config loaded from classpath");
                return new JsonObject(content);
            }
            
            // Fallback to file system (for development)
            logger.debug("Config not in classpath, trying file system");
            if (vertx.fileSystem().existsBlocking("src/main/resources/config.json")) {
                logger.info("✓ Loading config from: src/main/resources/config.json");
                return vertx.fileSystem()
                    .readFileBlocking("src/main/resources/config.json")
                    .toJsonObject();
            }
            
            // Last resort: current directory
            if (vertx.fileSystem().existsBlocking("config.json")) {
                logger.info("✓ Loading config from: config.json");
                return vertx.fileSystem()
                    .readFileBlocking("config.json")
                    .toJsonObject();
            }
            
            logger.warn("⚠ No config file found, using default configuration");
            return getDefaultConfig();
            
        } catch (Exception e) {
            logger.error("✗ Error loading config file, using defaults", e);
            return getDefaultConfig();
        }
    }
    
    private JsonObject getDefaultConfig() {
        logger.info("Using built-in default configuration");
        return new JsonObject()
            .put("http", new JsonObject()
                .put("port", 8080)
                .put("host", "0.0.0.0"))
            .put("database", new JsonObject()
                .put("host", "localhost")
                .put("port", 5432)
                .put("database", "pqc_scanner")
                .put("user", "postgres")
                .put("password", "postgres")
                .put("maxPoolSize", 10))
            .put("scanner", new JsonObject()
                .put("timeout", 10000)
                .put("maxConcurrentScans", 5)
                .put("retryAttempts", 3));
    }
    
    private void initDatabase(JsonObject dbConfig) {
        String host = dbConfig.getString("host", "localhost");
        int port = dbConfig.getInteger("port", 5432);
        String database = dbConfig.getString("database", "pqc_scanner");
        String user = dbConfig.getString("user", "postgres");
        
        logger.info("Database config: {}:{}/{} (user: {})", host, port, database, user);
        
        PgConnectOptions connectOptions = new PgConnectOptions()
            .setHost(host)
            .setPort(port)
            .setDatabase(database)
            .setUser(user)
            .setPassword(dbConfig.getString("password", "postgres"));
        
        PoolOptions poolOptions = new PoolOptions()
            .setMaxSize(dbConfig.getInteger("maxPoolSize", 10));
        
        pgPool = PgPool.pool(vertx, connectOptions, poolOptions);
        logger.info("Database connection pool created (max size: {})", poolOptions.getMaxSize());
    }
    
    private Router createRouter() {
        Router router = Router.router(vertx);
        
        logger.info("Configuring routes...");
        
        // Log all requests (must be first)
        router.route().handler(ctx -> {
            logger.debug("Request: {} {}", ctx.request().method(), ctx.request().path());
            ctx.next();
        });
        
        // Enable body handler for POST requests
        router.route().handler(BodyHandler.create());
        logger.debug("✓ Body handler configured");
        
        // API routes
        ApiHandler apiHandler = new ApiHandler(vertx, pgPool, domainScanner);
        
        router.get("/api/health").handler(apiHandler::health);
        router.get("/api/stats").handler(apiHandler::getStats);
        router.get("/api/domains").handler(apiHandler::getDomains);
        router.post("/api/domains").handler(apiHandler::addDomain);
        router.delete("/api/domains/:id").handler(apiHandler::deleteDomain);
        router.post("/api/scan/:domain").handler(apiHandler::scanDomain);
        router.post("/api/scan-batch").handler(apiHandler::scanBatch);
        router.get("/api/results").handler(apiHandler::getResults);
        router.get("/api/results/:domain").handler(apiHandler::getDomainResults);
        router.get("/api/certificate/:domain").handler(apiHandler::getCertificateDetails);
        router.get("/api/timeline").handler(apiHandler::getTimeline);
        router.get("/api/vulnerability-window").handler(apiHandler::getVulnerabilityWindow);
        
        // New endpoints for risk scoring, trends, and chain analysis
        router.get("/api/risk-distribution").handler(apiHandler::getRiskDistribution);
        router.get("/api/trends").handler(apiHandler::getTrends);
        router.get("/api/certificate-chain/:domain").handler(apiHandler::getCertificateChain);
        
        logger.debug("✓ API routes configured (15 endpoints)");
        
        // Serve static files (HTML, CSS, JS) - must be last
        StaticHandler staticHandler = StaticHandler.create("webapp")
            .setCachingEnabled(false) // Disable caching for development
            .setIndexPage("index.html"); // Explicitly set index page
        router.route("/*").handler(staticHandler);
        logger.debug("✓ Static file handler configured (serving from 'webapp')");
        
        logger.info("✓ Router configured successfully");
        return router;
    }
    
    @Override
    public void stop(Promise<Void> stopPromise) {
        logger.info("Stopping PQC Domain Scanner...");
        if (pgPool != null) {
            pgPool.close()
                .onSuccess(v -> {
                    logger.info("✓ Database connection pool closed");
                    stopPromise.complete();
                })
                .onFailure(err -> {
                    logger.error("✗ Error closing database pool", err);
                    stopPromise.fail(err);
                });
        } else {
            stopPromise.complete();
        }
    }
}

// Made with Bob
