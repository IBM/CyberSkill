/*  Library Handler
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package router.thejasonengine.com;

import io.vertx.core.Handler;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import library.thejasonengine.com.AttackPattern;
import library.thejasonengine.com.AttackPatternLibrary;
import library.thejasonengine.com.ExecutionHistoryManager;
import library.thejasonengine.com.PatternExecutionRecord;
import library.thejasonengine.com.ReportGenerator;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * REST API handler for the Attack Pattern Library
 */
public class LibraryHandler {
    
    private static final Logger logger = LogManager.getLogger(LibraryHandler.class);
    private final AttackPatternLibrary library;
    
    public LibraryHandler() {
        this.library = AttackPatternLibrary.getInstance();
        logger.info("LibraryHandler initialized with {} patterns", library.getTotalPatternCount());
    }
    
    /**
     * Register all library routes
     */
    public void registerRoutes(Router router) {
        // Get all patterns
        router.get("/api/library/patterns").handler(this::getAllPatterns);
        
        // Get pattern by ID
        router.get("/api/library/patterns/:id").handler(this::getPatternById);
        
        // Get patterns by category
        router.get("/api/library/categories/:category/patterns").handler(this::getPatternsByCategory);
        
        // Get patterns by severity
        router.get("/api/library/severity/:severity/patterns").handler(this::getPatternsBySeverity);
        
        // Get patterns by database
        router.get("/api/library/database/:database/patterns").handler(this::getPatternsByDatabase);
        
        // Search patterns
        router.get("/api/library/search").handler(this::searchPatterns);
        
        // Get all categories
        router.get("/api/library/categories").handler(this::getCategories);
        
        // Get all severity levels
        router.get("/api/library/severity").handler(this::getSeverityLevels);
        
        // Get statistics
        router.get("/api/library/stats").handler(this::getStatistics);
        
        // Report generation endpoints
        router.get("/api/library/reports/html").handler(this::generateHtmlReport);
        router.get("/api/library/reports/json").handler(this::generateJsonReport);
        router.get("/api/library/reports/csv").handler(this::generateCsvReport);
        router.get("/api/library/executions").handler(this::getExecutionHistory);
        
        logger.info("Library routes registered");
    }
    
    /**
     * Get all attack patterns
     */
    private void getAllPatterns(RoutingContext ctx) {
        try {
            List<AttackPattern> patterns = library.getAllPatterns();
            JsonArray jsonArray = new JsonArray();
            patterns.forEach(pattern -> jsonArray.add(pattern.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", patterns.size())
                .put("patterns", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved all patterns: {} patterns", patterns.size());
        } catch (Exception e) {
            logger.error("Error retrieving all patterns", e);
            sendError(ctx, 500, "Error retrieving patterns: " + e.getMessage());
        }
    }
    
    /**
     * Get pattern by ID
     */
    private void getPatternById(RoutingContext ctx) {
        try {
            String id = ctx.pathParam("id");
            AttackPattern pattern = library.getPatternById(id);
            
            if (pattern == null) {
                sendError(ctx, 404, "Pattern not found: " + id);
                return;
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("pattern", pattern.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved pattern: {}", id);
        } catch (Exception e) {
            logger.error("Error retrieving pattern by ID", e);
            sendError(ctx, 500, "Error retrieving pattern: " + e.getMessage());
        }
    }
    
    /**
     * Get patterns by category
     */
    private void getPatternsByCategory(RoutingContext ctx) {
        try {
            String category = ctx.pathParam("category");
            List<AttackPattern> patterns = library.getPatternsByCategory(category);
            
            JsonArray jsonArray = new JsonArray();
            patterns.forEach(pattern -> jsonArray.add(pattern.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("category", category)
                .put("count", patterns.size())
                .put("patterns", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved patterns by category '{}': {} patterns", category, patterns.size());
        } catch (Exception e) {
            logger.error("Error retrieving patterns by category", e);
            sendError(ctx, 500, "Error retrieving patterns: " + e.getMessage());
        }
    }
    
    /**
     * Get patterns by severity
     */
    private void getPatternsBySeverity(RoutingContext ctx) {
        try {
            String severity = ctx.pathParam("severity");
            List<AttackPattern> patterns = library.getPatternsBySeverity(severity);
            
            JsonArray jsonArray = new JsonArray();
            patterns.forEach(pattern -> jsonArray.add(pattern.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("severity", severity)
                .put("count", patterns.size())
                .put("patterns", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved patterns by severity '{}': {} patterns", severity, patterns.size());
        } catch (Exception e) {
            logger.error("Error retrieving patterns by severity", e);
            sendError(ctx, 500, "Error retrieving patterns: " + e.getMessage());
        }
    }
    
    /**
     * Get patterns by database
     */
    private void getPatternsByDatabase(RoutingContext ctx) {
        try {
            String database = ctx.pathParam("database");
            List<AttackPattern> patterns = library.getPatternsByDatabase(database);
            
            JsonArray jsonArray = new JsonArray();
            patterns.forEach(pattern -> jsonArray.add(pattern.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("database", database)
                .put("count", patterns.size())
                .put("patterns", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved patterns by database '{}': {} patterns", database, patterns.size());
        } catch (Exception e) {
            logger.error("Error retrieving patterns by database", e);
            sendError(ctx, 500, "Error retrieving patterns: " + e.getMessage());
        }
    }
    
    /**
     * Search patterns
     */
    private void searchPatterns(RoutingContext ctx) {
        try {
            String query = ctx.request().getParam("q");
            
            if (query == null || query.trim().isEmpty()) {
                sendError(ctx, 400, "Search query parameter 'q' is required");
                return;
            }
            
            List<AttackPattern> patterns = library.searchPatterns(query);
            
            JsonArray jsonArray = new JsonArray();
            patterns.forEach(pattern -> jsonArray.add(pattern.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("query", query)
                .put("count", patterns.size())
                .put("patterns", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Search for '{}': {} patterns found", query, patterns.size());
        } catch (Exception e) {
            logger.error("Error searching patterns", e);
            sendError(ctx, 500, "Error searching patterns: " + e.getMessage());
        }
    }
    
    /**
     * Get all categories
     */
    private void getCategories(RoutingContext ctx) {
        try {
            List<String> categories = library.getCategories();
            Map<String, Long> categoryCounts = library.getPatternCountByCategory();
            
            JsonArray jsonArray = new JsonArray();
            categories.forEach(category -> {
                JsonObject categoryObj = new JsonObject()
                    .put("name", category)
                    .put("count", categoryCounts.getOrDefault(category, 0L));
                jsonArray.add(categoryObj);
            });
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", categories.size())
                .put("categories", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved categories: {} categories", categories.size());
        } catch (Exception e) {
            logger.error("Error retrieving categories", e);
            sendError(ctx, 500, "Error retrieving categories: " + e.getMessage());
        }
    }
    
    /**
     * Get all severity levels
     */
    private void getSeverityLevels(RoutingContext ctx) {
        try {
            List<String> severityLevels = library.getSeverityLevels();
            Map<String, Long> severityCounts = library.getPatternCountBySeverity();
            
            JsonArray jsonArray = new JsonArray();
            severityLevels.forEach(severity -> {
                JsonObject severityObj = new JsonObject()
                    .put("name", severity)
                    .put("count", severityCounts.getOrDefault(severity, 0L));
                jsonArray.add(severityObj);
            });
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", severityLevels.size())
                .put("severityLevels", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved severity levels: {} levels", severityLevels.size());
        } catch (Exception e) {
            logger.error("Error retrieving severity levels", e);
            sendError(ctx, 500, "Error retrieving severity levels: " + e.getMessage());
        }
    }
    
    /**
     * Get library statistics
     */
    private void getStatistics(RoutingContext ctx) {
        try {
            Map<String, Long> categoryCount = library.getPatternCountByCategory();
            Map<String, Long> severityCount = library.getPatternCountBySeverity();
            
            JsonObject categoryStats = new JsonObject();
            categoryCount.forEach(categoryStats::put);
            
            JsonObject severityStats = new JsonObject();
            severityCount.forEach(severityStats::put);
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("totalPatterns", library.getTotalPatternCount())
                .put("totalCategories", library.getCategories().size())
                .put("totalSeverityLevels", library.getSeverityLevels().size())
                .put("patternsByCategory", categoryStats)
                .put("patternsBySeverity", severityStats);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved library statistics");
        } catch (Exception e) {
            logger.error("Error retrieving statistics", e);
            sendError(ctx, 500, "Error retrieving statistics: " + e.getMessage());
        }
    }
    
    /**
     * Send error response
     */
    private void sendError(RoutingContext ctx, int statusCode, String message) {
        JsonObject error = new JsonObject()
            .put("success", false)
            .put("error", message);
        
        ctx.response()
            .setStatusCode(statusCode)
            .putHeader("content-type", "application/json")
            .end(error.encodePrettily());
    }
    
    /**
     * Get execution history
     */
    private void getExecutionHistory(RoutingContext ctx) {
        try {
            ExecutionHistoryManager historyManager = ExecutionHistoryManager.getInstance();
            
            List<PatternExecutionRecord> executions = historyManager.getAllExecutions();
            
            JsonArray executionsArray = new JsonArray();
            executions.forEach(record -> executionsArray.add(record.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", executions.size())
                .put("executions", executionsArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved execution history: {} records", executions.size());
        } catch (Exception e) {
            logger.error("Error retrieving execution history", e);
            sendError(ctx, 500, "Error retrieving execution history: " + e.getMessage());
        }
    }
    
    /**
     * Generate HTML report
     */
    private void generateHtmlReport(RoutingContext ctx) {
        try {
            ExecutionHistoryManager historyManager = ExecutionHistoryManager.getInstance();
            
            List<PatternExecutionRecord> executions = historyManager.getAllExecutions();
            
            if (executions.isEmpty()) {
                sendError(ctx, 404, "No execution history available. Execute some patterns first.");
                return;
            }
            
            String reportTitle = "Security Test Report - " + LocalDateTime.now().format(
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            
            String htmlReport = ReportGenerator.generateHtmlReport(executions, reportTitle);
            
            ctx.response()
                .putHeader("content-type", "text/html")
                .putHeader("content-disposition", "attachment; filename=security-report.html")
                .end(htmlReport);
                
            logger.info("Generated HTML report with {} executions", executions.size());
        } catch (Exception e) {
            logger.error("Error generating HTML report", e);
            sendError(ctx, 500, "Error generating HTML report: " + e.getMessage());
        }
    }
    
    /**
     * Generate JSON report
     */
    private void generateJsonReport(RoutingContext ctx) {
        try {
            ExecutionHistoryManager historyManager = ExecutionHistoryManager.getInstance();
            
            List<PatternExecutionRecord> executions = historyManager.getAllExecutions();
            
            if (executions.isEmpty()) {
                sendError(ctx, 404, "No execution history available. Execute some patterns first.");
                return;
            }
            
            String reportTitle = "Security Test Report - " + LocalDateTime.now().format(
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            
            JsonObject jsonReport = ReportGenerator.generateJsonReport(executions, reportTitle);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .putHeader("content-disposition", "attachment; filename=security-report.json")
                .end(jsonReport.encodePrettily());
                
            logger.info("Generated JSON report with {} executions", executions.size());
        } catch (Exception e) {
            logger.error("Error generating JSON report", e);
            sendError(ctx, 500, "Error generating JSON report: " + e.getMessage());
        }
    }
    
    /**
     * Generate CSV report
     */
    private void generateCsvReport(RoutingContext ctx) {
        try {
            ExecutionHistoryManager historyManager = ExecutionHistoryManager.getInstance();
            
            List<PatternExecutionRecord> executions = historyManager.getAllExecutions();
            
            if (executions.isEmpty()) {
                sendError(ctx, 404, "No execution history available. Execute some patterns first.");
                return;
            }
            
            String csvReport = ReportGenerator.generateCsvReport(executions);
            
            ctx.response()
                .putHeader("content-type", "text/csv")
                .putHeader("content-disposition", "attachment; filename=security-report.csv")
                .end(csvReport);
                
            logger.info("Generated CSV report with {} executions", executions.size());
        } catch (Exception e) {
            logger.error("Error generating CSV report", e);
            sendError(ctx, 500, "Error generating CSV report: " + e.getMessage());
        }
    }
}