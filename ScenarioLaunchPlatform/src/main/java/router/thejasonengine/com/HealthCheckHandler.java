/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package router.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;
import memory.thejasonengine.com.Ram;

import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryUsage;

public class HealthCheckHandler {
    
    private static final Logger LOGGER = LogManager.getLogger(HealthCheckHandler.class);
    private final Vertx vertx;
    
    public HealthCheckHandler(Vertx vertx) {
        this.vertx = vertx;
    }
    
    /**
     * Basic health check endpoint
     */
    public Handler<RoutingContext> healthCheck = ctx -> {
        LOGGER.debug("Health check requested");
        
        JsonObject health = new JsonObject()
            .put("status", "UP")
            .put("timestamp", System.currentTimeMillis())
            .put("application", "ScenarioLaunchPlatform");
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(health.encodePrettily());
    };
    
    /**
     * Detailed health check with database and memory status
     */
    public Handler<RoutingContext> detailedHealthCheck = ctx -> {
        LOGGER.debug("Detailed health check requested");
        
        JsonObject health = new JsonObject()
            .put("status", "UP")
            .put("timestamp", System.currentTimeMillis())
            .put("application", "ScenarioLaunchPlatform");
        
        // Check database health
        checkDatabaseHealth(health, () -> {
            // Add memory information
            addMemoryInfo(health);
            
            // Add system information
            addSystemInfo(health);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(health.encodePrettily());
        });
    };
    
    /**
     * Metrics endpoint for monitoring
     */
    public Handler<RoutingContext> metrics = ctx -> {
        LOGGER.debug("Metrics requested");
        
        JsonObject metrics = new JsonObject();
        
        // Memory metrics
        MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
        MemoryUsage heapUsage = memoryBean.getHeapMemoryUsage();
        MemoryUsage nonHeapUsage = memoryBean.getNonHeapMemoryUsage();
        
        JsonObject memory = new JsonObject()
            .put("heap", new JsonObject()
                .put("used", heapUsage.getUsed())
                .put("max", heapUsage.getMax())
                .put("committed", heapUsage.getCommitted())
                .put("usagePercent", (heapUsage.getUsed() * 100.0) / heapUsage.getMax()))
            .put("nonHeap", new JsonObject()
                .put("used", nonHeapUsage.getUsed())
                .put("max", nonHeapUsage.getMax())
                .put("committed", nonHeapUsage.getCommitted()));
        
        metrics.put("memory", memory);
        
        // System metrics
        Runtime runtime = Runtime.getRuntime();
        JsonObject system = new JsonObject()
            .put("processors", runtime.availableProcessors())
            .put("uptime", ManagementFactory.getRuntimeMXBean().getUptime())
            .put("threads", Thread.activeCount());
        
        metrics.put("system", system);
        
        // Database pool metrics
        Ram ram = new Ram();
        Pool pool = ram.getPostGresSystemPool();
        if (pool != null) {
            JsonObject dbMetrics = new JsonObject()
                .put("poolAvailable", true);
            metrics.put("database", dbMetrics);
        } else {
            metrics.put("database", new JsonObject().put("poolAvailable", false));
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(metrics.encodePrettily());
    };
    
    /**
     * Readiness probe - checks if application is ready to serve traffic
     */
    public Handler<RoutingContext> readiness = ctx -> {
        LOGGER.debug("Readiness check requested");
        
        Ram ram = new Ram();
        Pool pool = ram.getPostGresSystemPool();
        
        if (pool == null) {
            ctx.response()
                .setStatusCode(503)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("status", "NOT_READY")
                    .put("reason", "Database pool not initialized")
                    .encodePrettily());
            return;
        }
        
        // Test database connection
        pool.query("SELECT 1").execute(ar -> {
            if (ar.succeeded()) {
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("status", "READY")
                        .put("timestamp", System.currentTimeMillis())
                        .encodePrettily());
            } else {
                ctx.response()
                    .setStatusCode(503)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("status", "NOT_READY")
                        .put("reason", "Database connection failed")
                        .put("error", ar.cause().getMessage())
                        .encodePrettily());
            }
        });
    };
    
    /**
     * Liveness probe - checks if application is alive
     */
    public Handler<RoutingContext> liveness = ctx -> {
        LOGGER.debug("Liveness check requested");
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("status", "ALIVE")
                .put("timestamp", System.currentTimeMillis())
                .encodePrettily());
    };
    
    private void checkDatabaseHealth(JsonObject health, Runnable callback) {
        Ram ram = new Ram();
        Pool pool = ram.getPostGresSystemPool();
        
        if (pool == null) {
            health.put("database", new JsonObject()
                .put("status", "DOWN")
                .put("reason", "Pool not initialized"));
            callback.run();
            return;
        }
        
        pool.query("SELECT 1").execute(ar -> {
            if (ar.succeeded()) {
                health.put("database", new JsonObject()
                    .put("status", "UP")
                    .put("type", "PostgreSQL"));
            } else {
                health.put("database", new JsonObject()
                    .put("status", "DOWN")
                    .put("error", ar.cause().getMessage()));
                health.put("status", "DEGRADED");
            }
            callback.run();
        });
    }
    
    private void addMemoryInfo(JsonObject health) {
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;
        
        JsonObject memory = new JsonObject()
            .put("max", maxMemory)
            .put("total", totalMemory)
            .put("free", freeMemory)
            .put("used", usedMemory)
            .put("usagePercent", (usedMemory * 100.0) / maxMemory);
        
        health.put("memory", memory);
    }
    
    private void addSystemInfo(JsonObject health) {
        JsonObject system = new JsonObject()
            .put("processors", Runtime.getRuntime().availableProcessors())
            .put("osName", System.getProperty("os.name"))
            .put("osVersion", System.getProperty("os.version"))
            .put("javaVersion", System.getProperty("java.version"))
            .put("uptime", ManagementFactory.getRuntimeMXBean().getUptime());
        
        health.put("system", system);
    }
}

// Made with Bob
