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
import metrics.thejasonengine.com.MetricsCollector;

/**
 * Handler for application metrics endpoints
 */
public class MetricsHandler {
    
    private static final Logger LOGGER = LogManager.getLogger(MetricsHandler.class);
    private final Vertx vertx;
    
    public MetricsHandler(Vertx vertx) {
        this.vertx = vertx;
    }
    
    private MetricsCollector getMetricsCollector() {
        return MetricsCollector.getInstance();
    }
    
    /**
     * Get all application metrics
     */
    public Handler<RoutingContext> getAllMetrics = ctx -> {
        LOGGER.debug("All metrics requested");
        
        JsonObject metrics = getMetricsCollector().getAllMetrics();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(metrics.encodePrettily());
    };
    
    /**
     * Get HTTP request metrics only
     */
    public Handler<RoutingContext> getHttpMetrics = ctx -> {
        LOGGER.debug("HTTP metrics requested");
        
        JsonObject metrics = getMetricsCollector().getHttpMetrics();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(metrics.encodePrettily());
    };
    
    /**
     * Get database performance metrics only
     */
    public Handler<RoutingContext> getDatabaseMetrics = ctx -> {
        LOGGER.debug("Database metrics requested");
        
        JsonObject metrics = getMetricsCollector().getDatabaseMetrics();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(metrics.encodePrettily());
    };
    
    /**
     * Get story execution metrics only
     */
    public Handler<RoutingContext> getStoryMetrics = ctx -> {
        LOGGER.debug("Story metrics requested");
        
        JsonObject metrics = getMetricsCollector().getStoryMetrics();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(metrics.encodePrettily());
    };
    
    /**
     * Get error and exception metrics only
     */
    public Handler<RoutingContext> getErrorMetrics = ctx -> {
        LOGGER.debug("Error metrics requested");
        
        JsonObject metrics = getMetricsCollector().getErrorMetrics();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(metrics.encodePrettily());
    };
    
    /**
     * Reset all metrics (admin only)
     */
    public Handler<RoutingContext> resetMetrics = ctx -> {
        LOGGER.warn("Metrics reset requested");
        
        getMetricsCollector().resetAllMetrics();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("status", "success")
                .put("message", "All metrics have been reset")
                .encodePrettily());
    };
    
    /**
     * Request interceptor to track HTTP metrics
     * Add this as a route handler before your actual handlers
     */
    public Handler<RoutingContext> metricsInterceptor = ctx -> {
        long startTime = System.currentTimeMillis();
        MetricsCollector collector = getMetricsCollector();
        collector.incrementActiveRequests();
        
        // Continue to next handler
        ctx.addBodyEndHandler(v -> {
            long responseTime = System.currentTimeMillis() - startTime;
            int statusCode = ctx.response().getStatusCode();
            String endpoint = ctx.request().path();
            
            collector.recordRequest(endpoint, statusCode, responseTime);
            collector.decrementActiveRequests();
            
            LOGGER.debug("Request to {} completed in {}ms with status {}",
                endpoint, responseTime, statusCode);
        });
        
        ctx.next();
    };
}

