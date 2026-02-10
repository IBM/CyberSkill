/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package metrics.thejasonengine.com;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.json.JsonObject;
import io.vertx.core.json.JsonArray;

/**
 * Centralized metrics collector for the application
 * Tracks HTTP requests, database operations, story executions, and errors
 */
public class MetricsCollector {
    
    private static final Logger LOGGER = LogManager.getLogger(MetricsCollector.class);
    private static MetricsCollector instance;
    
    // HTTP Request Metrics
    private final AtomicLong totalRequests = new AtomicLong(0);
    private final AtomicLong successfulRequests = new AtomicLong(0);
    private final AtomicLong failedRequests = new AtomicLong(0);
    private final ConcurrentHashMap<String, AtomicLong> requestsByEndpoint = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Integer, AtomicLong> requestsByStatusCode = new ConcurrentHashMap<>();
    private final AtomicLong totalResponseTime = new AtomicLong(0);
    private final AtomicInteger activeRequests = new AtomicInteger(0);
    private final long startTime = System.currentTimeMillis();
    
    // Database Performance Metrics
    private final AtomicLong totalQueries = new AtomicLong(0);
    private final AtomicLong successfulQueries = new AtomicLong(0);
    private final AtomicLong failedQueries = new AtomicLong(0);
    private final AtomicLong totalQueryTime = new AtomicLong(0);
    private final AtomicInteger activeConnections = new AtomicInteger(0);
    private final AtomicLong slowQueries = new AtomicLong(0); // > 1 second
    
    // Story Execution Metrics
    private final AtomicLong totalStories = new AtomicLong(0);
    private final AtomicLong successfulStories = new AtomicLong(0);
    private final AtomicLong failedStories = new AtomicLong(0);
    private final AtomicInteger activeStories = new AtomicInteger(0);
    private final AtomicLong totalStoryTime = new AtomicLong(0);
    
    // Error & Exception Metrics
    private final AtomicLong totalErrors = new AtomicLong(0);
    private final ConcurrentHashMap<String, AtomicLong> errorsByType = new ConcurrentHashMap<>();
    private final List<ErrorRecord> recentErrors = Collections.synchronizedList(new ArrayList<>());
    private static final int MAX_RECENT_ERRORS = 100;
    
    // Performance Warning Metrics (Blocked Threads, Slow Operations)
    private final AtomicLong totalBlockedThreadWarnings = new AtomicLong(0);
    private final List<PerformanceWarning> recentWarnings = Collections.synchronizedList(new ArrayList<>());
    private static final int MAX_RECENT_WARNINGS = 50;
    
    private MetricsCollector() {
        LOGGER.info("MetricsCollector initialized");
    }
    
    public static synchronized MetricsCollector getInstance() {
        if (instance == null) {
            instance = new MetricsCollector();
        }
        return instance;
    }
    
    // ==================== HTTP Request Metrics ====================
    
    public void recordRequest(String endpoint, int statusCode, long responseTimeMs) {
        totalRequests.incrementAndGet();
        
        if (statusCode >= 200 && statusCode < 300) {
            successfulRequests.incrementAndGet();
        } else {
            failedRequests.incrementAndGet();
        }
        
        requestsByEndpoint.computeIfAbsent(endpoint, k -> new AtomicLong(0)).incrementAndGet();
        requestsByStatusCode.computeIfAbsent(statusCode, k -> new AtomicLong(0)).incrementAndGet();
        totalResponseTime.addAndGet(responseTimeMs);
    }
    
    public void incrementActiveRequests() {
        activeRequests.incrementAndGet();
    }
    
    public void decrementActiveRequests() {
        activeRequests.decrementAndGet();
    }
    
    public JsonObject getHttpMetrics() {
        long total = totalRequests.get();
        long avgResponseTime = total > 0 ? totalResponseTime.get() / total : 0;
        double successRate = total > 0 ? (successfulRequests.get() * 100.0 / total) : 0;
        
        long uptimeMs = System.currentTimeMillis() - startTime;
        double requestsPerSecond = uptimeMs > 0 ? (total * 1000.0 / uptimeMs) : 0;
        
        JsonObject metrics = new JsonObject()
            .put("totalRequests", total)
            .put("successfulRequests", successfulRequests.get())
            .put("failedRequests", failedRequests.get())
            .put("activeRequests", activeRequests.get())
            .put("averageResponseTimeMs", avgResponseTime)
            .put("successRate", Math.round(successRate * 100.0) / 100.0)
            .put("requestsPerSecond", Math.round(requestsPerSecond * 100.0) / 100.0);
        
        // Top endpoints
        JsonArray topEndpoints = new JsonArray();
        requestsByEndpoint.entrySet().stream()
            .sorted((e1, e2) -> Long.compare(e2.getValue().get(), e1.getValue().get()))
            .limit(10)
            .forEach(entry -> {
                topEndpoints.add(new JsonObject()
                    .put("endpoint", entry.getKey())
                    .put("count", entry.getValue().get()));
            });
        metrics.put("topEndpoints", topEndpoints);
        
        // Status code distribution
        JsonObject statusCodes = new JsonObject();
        requestsByStatusCode.forEach((code, count) -> 
            statusCodes.put(String.valueOf(code), count.get()));
        metrics.put("statusCodeDistribution", statusCodes);
        
        return metrics;
    }
    
    // ==================== Database Performance Metrics ====================
    
    public void recordQuery(boolean success, long queryTimeMs) {
        totalQueries.incrementAndGet();
        
        if (success) {
            successfulQueries.incrementAndGet();
        } else {
            failedQueries.incrementAndGet();
        }
        
        totalQueryTime.addAndGet(queryTimeMs);
        
        if (queryTimeMs > 1000) { // Slow query threshold: 1 second
            slowQueries.incrementAndGet();
        }
    }
    
    public void setActiveConnections(int count) {
        activeConnections.set(count);
    }
    
    public void incrementActiveConnections() {
        activeConnections.incrementAndGet();
    }
    
    public void decrementActiveConnections() {
        activeConnections.decrementAndGet();
    }
    
    public JsonObject getDatabaseMetrics() {
        long total = totalQueries.get();
        long avgQueryTime = total > 0 ? totalQueryTime.get() / total : 0;
        double successRate = total > 0 ? (successfulQueries.get() * 100.0 / total) : 0;
        
        return new JsonObject()
            .put("totalQueries", total)
            .put("successfulQueries", successfulQueries.get())
            .put("failedQueries", failedQueries.get())
            .put("activeConnections", activeConnections.get())
            .put("averageQueryTimeMs", avgQueryTime)
            .put("slowQueries", slowQueries.get())
            .put("successRate", Math.round(successRate * 100.0) / 100.0);
    }
    
    // ==================== Story Execution Metrics ====================
    
    public void recordStory(boolean success, long executionTimeMs) {
        totalStories.incrementAndGet();
        
        if (success) {
            successfulStories.incrementAndGet();
        } else {
            failedStories.incrementAndGet();
        }
        
        totalStoryTime.addAndGet(executionTimeMs);
    }
    
    public void incrementActiveStories() {
        activeStories.incrementAndGet();
    }
    
    public void decrementActiveStories() {
        activeStories.decrementAndGet();
    }
    
    public JsonObject getStoryMetrics() {
        long total = totalStories.get();
        long avgExecutionTime = total > 0 ? totalStoryTime.get() / total : 0;
        double successRate = total > 0 ? (successfulStories.get() * 100.0 / total) : 0;
        
        return new JsonObject()
            .put("totalStories", total)
            .put("successfulStories", successfulStories.get())
            .put("failedStories", failedStories.get())
            .put("activeStories", activeStories.get())
            .put("averageExecutionTimeMs", avgExecutionTime)
            .put("successRate", Math.round(successRate * 100.0) / 100.0);
    }
    
    // ==================== Error & Exception Metrics ====================
    
    public void recordError(String errorType, String message, String stackTrace) {
        totalErrors.incrementAndGet();
        errorsByType.computeIfAbsent(errorType, k -> new AtomicLong(0)).incrementAndGet();
        
        ErrorRecord error = new ErrorRecord(
            System.currentTimeMillis(),
            errorType,
            message,
            stackTrace
        );
        
        synchronized (recentErrors) {
            recentErrors.add(0, error);
            if (recentErrors.size() > MAX_RECENT_ERRORS) {
                recentErrors.remove(recentErrors.size() - 1);
            }
        }
    }
    
    public JsonObject getErrorMetrics() {
        JsonObject metrics = new JsonObject()
            .put("totalErrors", totalErrors.get());
        
        // Errors by type
        JsonObject errorTypes = new JsonObject();
        errorsByType.entrySet().stream()
            .sorted((e1, e2) -> Long.compare(e2.getValue().get(), e1.getValue().get()))
            .forEach(entry -> {
                errorTypes.put(entry.getKey(), entry.getValue().get());
            });
        metrics.put("errorsByType", errorTypes);
        
        // Recent errors (last 10)
        JsonArray recentErrorsArray = new JsonArray();
        synchronized (recentErrors) {
            recentErrors.stream()
                .limit(10)
                .forEach(error -> {
                    recentErrorsArray.add(new JsonObject()
                        .put("timestamp", error.timestamp)
                        .put("type", error.type)
                        .put("message", error.message));
                });
        }
        metrics.put("recentErrors", recentErrorsArray);
        
        return metrics;
    }
    
    // ==================== Performance Warning Metrics ====================
    
    public void recordBlockedThread(String threadName, long blockedTimeMs, String stackTrace) {
        totalBlockedThreadWarnings.incrementAndGet();
        
        PerformanceWarning warning = new PerformanceWarning(
            System.currentTimeMillis(),
            "BlockedThread",
            threadName + " blocked for " + blockedTimeMs + "ms",
            stackTrace
        );
        
        synchronized (recentWarnings) {
            recentWarnings.add(0, warning);
            if (recentWarnings.size() > MAX_RECENT_WARNINGS) {
                recentWarnings.remove(recentWarnings.size() - 1);
            }
        }
        
        // Also record as error for visibility
        recordError("BlockedThread", threadName + " blocked for " + blockedTimeMs + "ms", stackTrace);
    }
    
    public JsonObject getPerformanceWarnings() {
        JsonObject metrics = new JsonObject()
            .put("totalBlockedThreadWarnings", totalBlockedThreadWarnings.get());
        
        // Recent warnings (last 10)
        JsonArray recentWarningsArray = new JsonArray();
        synchronized (recentWarnings) {
            recentWarnings.stream()
                .limit(10)
                .forEach(warning -> {
                    recentWarningsArray.add(new JsonObject()
                        .put("timestamp", warning.timestamp)
                        .put("type", warning.type)
                        .put("message", warning.message));
                });
        }
        metrics.put("recentWarnings", recentWarningsArray);
        
        return metrics;
    }
    
    // ==================== Combined Metrics ====================
    
    public JsonObject getAllMetrics() {
        return new JsonObject()
            .put("http", getHttpMetrics())
            .put("database", getDatabaseMetrics())
            .put("stories", getStoryMetrics())
            .put("errors", getErrorMetrics())
            .put("performance", getPerformanceWarnings())
            .put("collectionStartTime", startTime)
            .put("uptimeMs", System.currentTimeMillis() - startTime);
    }
    
    // ==================== Reset Methods ====================
    
    public void resetAllMetrics() {
        LOGGER.warn("Resetting all metrics");
        
        totalRequests.set(0);
        successfulRequests.set(0);
        failedRequests.set(0);
        requestsByEndpoint.clear();
        requestsByStatusCode.clear();
        totalResponseTime.set(0);
        activeRequests.set(0);
        
        totalQueries.set(0);
        successfulQueries.set(0);
        failedQueries.set(0);
        totalQueryTime.set(0);
        slowQueries.set(0);
        
        totalStories.set(0);
        successfulStories.set(0);
        failedStories.set(0);
        totalStoryTime.set(0);
        
        totalErrors.set(0);
        errorsByType.clear();
        recentErrors.clear();
    }
    
    // ==================== Inner Classes ====================
    
    private static class ErrorRecord {
        final long timestamp;
        final String type;
        final String message;
        final String stackTrace;
        
        ErrorRecord(long timestamp, String type, String message, String stackTrace) {
            this.timestamp = timestamp;
            this.type = type;
            this.message = message;
            this.stackTrace = stackTrace;
        }
    }
    
    private static class PerformanceWarning {
        final long timestamp;
        final String type;
        final String message;
        final String stackTrace;
        
        PerformanceWarning(long timestamp, String type, String message, String stackTrace) {
            this.timestamp = timestamp;
            this.type = type;
            this.message = message;
            this.stackTrace = stackTrace;
        }
    }
}

// Made with Bob
