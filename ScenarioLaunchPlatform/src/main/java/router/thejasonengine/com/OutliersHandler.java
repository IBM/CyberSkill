/*  Outliers Handler
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
import io.vertx.ext.web.FileUpload;
import outliers.thejasonengine.com.OutlierScript;
import outliers.thejasonengine.com.OutliersLibrary;
import outliers.thejasonengine.com.ScriptSchedule;
import outliers.thejasonengine.com.UploadResult;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * REST API handler for the Outliers (scheduled scripts) feature
 */
public class OutliersHandler {
    
    private static final Logger logger = LogManager.getLogger(OutliersHandler.class);
    private final OutliersLibrary library;
    
    public OutliersHandler() {
        this.library = OutliersLibrary.getInstance();
        logger.info("OutliersHandler initialized with {} scripts", library.getTotalScriptCount());
    }
    
    /**
     * Register all outliers routes
     */
    public void registerRoutes(Router router) {
        // Get all scripts
        router.get("/api/outliers/scripts").handler(this::getAllScripts);
        
        // Get script by ID
        router.get("/api/outliers/scripts/:id").handler(this::getScriptById);
        
        // Get scripts by type
        router.get("/api/outliers/type/:type/scripts").handler(this::getScriptsByType);
        
        // Get enabled scripts
        router.get("/api/outliers/enabled").handler(this::getEnabledScripts);
        
        // Search scripts
        router.get("/api/outliers/search").handler(this::searchScripts);
        
        // Get statistics
        router.get("/api/outliers/stats").handler(this::getStatistics);
        
        // Note: Upload route is registered in ClusteredVerticle with BodyHandler
        
        // Update script
        router.put("/api/outliers/scripts/:id")
            .handler(io.vertx.ext.web.handler.BodyHandler.create())
            .handler(this::updateScript);
        
        // Delete script
        router.delete("/api/outliers/scripts/:id").handler(this::deleteScript);
        
        // Toggle script enabled status
        router.post("/api/outliers/scripts/:id/toggle")
            .handler(io.vertx.ext.web.handler.BodyHandler.create())
            .handler(this::toggleScript);
        
        // Get all packages (grouped scripts)
        router.get("/api/outliers/packages").handler(this::handleGetPackages);
        
        // Toggle package (enable/disable all scripts in package)
        router.post("/api/outliers/packages/:packageId/toggle").handler(this::handleTogglePackage);
        
        // Schedule management endpoints
        // Add schedule to script
        router.post("/api/outliers/scripts/:id/schedules")
            .handler(io.vertx.ext.web.handler.BodyHandler.create())
            .handler(this::addSchedule);
        
        // Update schedule
        router.put("/api/outliers/scripts/:id/schedules/:scheduleId")
            .handler(io.vertx.ext.web.handler.BodyHandler.create())
            .handler(this::updateSchedule);
        
        // Delete schedule
        router.delete("/api/outliers/scripts/:id/schedules/:scheduleId")
            .handler(this::deleteSchedule);
        
        // Toggle schedule enabled status
        router.post("/api/outliers/scripts/:id/schedules/:scheduleId/toggle")
            .handler(io.vertx.ext.web.handler.BodyHandler.create())
            .handler(this::toggleSchedule);
        
        // Deployment endpoints
        // Get available outliers from outliers directory
        router.get("/api/outliers/available").handler(this::getAvailableOutliers);
        
        // Deploy an outlier from the outliers directory
        router.post("/api/outliers/deploy")
            .handler(io.vertx.ext.web.handler.BodyHandler.create())
            .handler(this::deployOutlier);
        
        // Delete/undeploy a package (all scripts in the package)
        router.delete("/api/outliers/packages/:packageId").handler(this::deletePackage);
        
        logger.info("Outliers routes registered");
    }
    
    /**
     * Get all scripts
     */
    private void getAllScripts(RoutingContext ctx) {
        try {
            List<OutlierScript> scripts = library.getAllScripts();
            JsonArray jsonArray = new JsonArray();
            scripts.forEach(script -> jsonArray.add(script.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", scripts.size())
                .put("scripts", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved all scripts: {} scripts", scripts.size());
        } catch (Exception e) {
            logger.error("Error retrieving all scripts", e);
            sendError(ctx, 500, "Error retrieving scripts: " + e.getMessage());
        }
    }
    
    /**
     * Get script by ID
     */
    private void getScriptById(RoutingContext ctx) {
        try {
            String id = ctx.pathParam("id");
            OutlierScript script = library.getScriptById(id);
            
            if (script == null) {
                sendError(ctx, 404, "Script not found: " + id);
                return;
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("script", script.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved script: {}", id);
        } catch (Exception e) {
            logger.error("Error retrieving script by ID", e);
            sendError(ctx, 500, "Error retrieving script: " + e.getMessage());
        }
    }
    
    /**
     * Get scripts by type
     */
    private void getScriptsByType(RoutingContext ctx) {
        try {
            String type = ctx.pathParam("type");
            List<OutlierScript> scripts = library.getScriptsByType(type);
            
            JsonArray jsonArray = new JsonArray();
            scripts.forEach(script -> jsonArray.add(script.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("type", type)
                .put("count", scripts.size())
                .put("scripts", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved scripts by type '{}': {} scripts", type, scripts.size());
        } catch (Exception e) {
            logger.error("Error retrieving scripts by type", e);
            sendError(ctx, 500, "Error retrieving scripts: " + e.getMessage());
        }
    }
    
    /**
     * Get enabled scripts
     */
    private void getEnabledScripts(RoutingContext ctx) {
        try {
            List<OutlierScript> scripts = library.getEnabledScripts();
            JsonArray jsonArray = new JsonArray();
            scripts.forEach(script -> jsonArray.add(script.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", scripts.size())
                .put("scripts", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved enabled scripts: {} scripts", scripts.size());
        } catch (Exception e) {
            logger.error("Error retrieving enabled scripts", e);
            sendError(ctx, 500, "Error retrieving scripts: " + e.getMessage());
        }
    }
    
    /**
     * Search scripts
     */
    private void searchScripts(RoutingContext ctx) {
        try {
            String query = ctx.request().getParam("q");
            
            if (query == null || query.trim().isEmpty()) {
                sendError(ctx, 400, "Search query parameter 'q' is required");
                return;
            }
            
            List<OutlierScript> scripts = library.searchScripts(query);
            
            JsonArray jsonArray = new JsonArray();
            scripts.forEach(script -> jsonArray.add(script.toJson()));
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("query", query)
                .put("count", scripts.size())
                .put("scripts", jsonArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Search for '{}': {} scripts found", query, scripts.size());
        } catch (Exception e) {
            logger.error("Error searching scripts", e);
            sendError(ctx, 500, "Error searching scripts: " + e.getMessage());
        }
    }
    
    /**
     * Get statistics
     */
    private void getStatistics(RoutingContext ctx) {
        try {
            Map<String, Long> typeCount = library.getScriptCountByType();
            
            JsonObject typeStats = new JsonObject();
            typeCount.forEach(typeStats::put);
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("totalScripts", library.getTotalScriptCount())
                .put("enabledScripts", library.getEnabledScriptCount())
                .put("scriptsByType", typeStats);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved outliers statistics");
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
     * Upload ZIP file containing scripts
     * Public so it can be called from ClusteredVerticle route registration
     */
    public void uploadZipFile(RoutingContext ctx) {
        logger.info("=== OUTLIERS UPLOAD HANDLER CALLED ===");
        logger.info("Request method: {}", ctx.request().method());
        logger.info("Request path: {}", ctx.request().path());
        logger.info("Content-Type: {}", ctx.request().getHeader("Content-Type"));
        
        try {
            logger.info("=== OUTLIERS UPLOAD START ===");
            // Get uploaded files
            List<FileUpload> uploads = ctx.fileUploads();
            logger.info("File uploads list: {}", uploads);
            logger.info("Number of uploads: {}", uploads == null ? "null" : uploads.size());
            
            if (uploads == null || uploads.isEmpty()) {
                logger.warn("No file uploads found in request");
                sendError(ctx, 400, "No file uploaded");
                return;
            }
            
            if (uploads.size() != 1) {
                logger.warn("Expected exactly one file, got: {}", uploads.size());
                sendError(ctx, 400, "Exactly one file expected");
                return;
            }
            
            FileUpload upload = uploads.get(0);
            String fileName = upload.fileName();
            String uploadedFileName = upload.uploadedFileName();
            long fileSize = upload.size();
            
            logger.info("Upload details:");
            logger.info("  - Original filename: {}", fileName);
            logger.info("  - Uploaded filename: {}", uploadedFileName);
            logger.info("  - File size: {} bytes", fileSize);
            logger.info("  - Content type: {}", upload.contentType());
            
            // Validate file is a ZIP
            if (!fileName.toLowerCase().endsWith(".zip")) {
                logger.warn("Invalid file type: {}", fileName);
                // Clean up temp file
                try {
                    ctx.vertx().fileSystem().deleteBlocking(uploadedFileName);
                    logger.info("Deleted temp file: {}", uploadedFileName);
                } catch (Exception ex) {
                    logger.error("Failed to delete temp file: {}", uploadedFileName, ex);
                }
                sendError(ctx, 415, "Only ZIP files are allowed");
                return;
            }
            
            // Get username from request body or default
            String uploadedBy = ctx.request().getFormAttribute("uploadedBy");
            if (uploadedBy == null || uploadedBy.isEmpty()) {
                uploadedBy = "unknown";
            }
            
            logger.info("Processing ZIP file uploaded by: {}", uploadedBy);
            logger.info("Calling library.processZipUploadWithConfig()...");

            // Process the ZIP file with JSON configuration support
            UploadResult uploadResult = library.processZipUploadWithConfig(uploadedFileName, uploadedBy);
            
            logger.info("ZIP processing complete. Added: {}, Skipped duplicates: {}",
                       uploadResult.getAddedCount(), uploadResult.getSkippedCount());
            
            JsonArray scriptsArray = new JsonArray();
            uploadResult.getAddedScripts().forEach(script -> {
                logger.debug("Adding script to response: {}", script.getName());
                scriptsArray.add(script.toJson());
            });
            
            JsonArray duplicatesArray = new JsonArray();
            uploadResult.getSkippedDuplicates().forEach(duplicatesArray::add);
            
            // Build message
            String message = "ZIP file processed successfully";
            if (uploadResult.hasDuplicates()) {
                message += ". " + uploadResult.getSkippedCount() + " duplicate(s) skipped";
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", message)
                .put("addedCount", uploadResult.getAddedCount())
                .put("skippedCount", uploadResult.getSkippedCount())
                .put("totalProcessed", uploadResult.getTotalProcessed())
                .put("scripts", scriptsArray)
                .put("skippedDuplicates", duplicatesArray);
            
            logger.info("Sending success response");
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("=== OUTLIERS UPLOAD SUCCESS: {} added, {} duplicates skipped ===",
                       uploadResult.getAddedCount(), uploadResult.getSkippedCount());
        } catch (Exception e) {
            logger.error("=== OUTLIERS UPLOAD ERROR ===", e);
            logger.error("Error type: {}", e.getClass().getName());
            logger.error("Error message: {}", e.getMessage());
            logger.error("Stack trace:", e);
            sendError(ctx, 500, "Error processing ZIP file: " + e.getMessage());
        }
    }
    
    /**
     * Update script
     */
    private void updateScript(RoutingContext ctx) {
        try {
            String id = ctx.pathParam("id");
            JsonObject body = ctx.getBodyAsJson();
            
            OutlierScript existingScript = library.getScriptById(id);
            if (existingScript == null) {
                sendError(ctx, 404, "Script not found: " + id);
                return;
            }
            
            // Track if scheduler-related fields changed
            boolean wasEnabled = existingScript.isEnabled();
            String oldCron = existingScript.getCronExpression();
            String oldParams = existingScript.getParameters();
            
            // Update fields
            if (body.containsKey("name")) {
                existingScript.setName(body.getString("name"));
            }
            if (body.containsKey("description")) {
                existingScript.setDescription(body.getString("description"));
            }
            if (body.containsKey("cronExpression")) {
                existingScript.setCronExpression(body.getString("cronExpression"));
            }
            if (body.containsKey("parameters")) {
                existingScript.setParameters(body.getString("parameters"));
            }
            if (body.containsKey("enabled")) {
                existingScript.setEnabled(body.getBoolean("enabled"));
            }
            if (body.containsKey("tags")) {
                List<String> tags = new ArrayList<>();
                body.getJsonArray("tags").forEach(t -> tags.add((String) t));
                existingScript.setTags(tags);
            }
            
            library.updateScript(id, existingScript);
            
            // Update scheduler if relevant fields changed
            boolean cronChanged = (oldCron == null && existingScript.getCronExpression() != null) ||
                                 (oldCron != null && !oldCron.equals(existingScript.getCronExpression()));
            boolean paramsChanged = (oldParams == null && existingScript.getParameters() != null) ||
                                   (oldParams != null && !oldParams.equals(existingScript.getParameters()));
            boolean enabledChanged = wasEnabled != existingScript.isEnabled();
            
            if (cronChanged || paramsChanged || enabledChanged) {
                // Remove old schedule first
                if (wasEnabled) {
                    library.removeFromScheduler(existingScript);
                }
                // Add new schedule if enabled
                if (existingScript.isEnabled()) {
                    boolean scheduled = library.addToScheduler(existingScript);
                    if (!scheduled) {
                        logger.warn("Failed to add script to scheduler: {}", id);
                    }
                }
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Script updated successfully")
                .put("script", existingScript.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Updated script: {}", id);
        } catch (Exception e) {
            logger.error("Error updating script", e);
            sendError(ctx, 500, "Error updating script: " + e.getMessage());
        }
    }
    
    /**
     * Delete script
     */
    private void deleteScript(RoutingContext ctx) {
        try {
            String id = ctx.pathParam("id");
            
            // Get script before deletion to remove from scheduler
            OutlierScript script = library.getScriptById(id);
            if (script != null && script.isEnabled()) {
                library.removeFromScheduler(script);
            }
            
            boolean removed = library.removeScript(id);
            
            if (!removed) {
                sendError(ctx, 404, "Script not found: " + id);
                return;
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Script deleted successfully");
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Deleted script: {}", id);
        } catch (Exception e) {
            logger.error("Error deleting script", e);
            sendError(ctx, 500, "Error deleting script: " + e.getMessage());
        }
    }
    
    /**
     * Toggle script enabled status
     */
    private void toggleScript(RoutingContext ctx) {
        try {
            String id = ctx.pathParam("id");
            
            OutlierScript script = library.getScriptById(id);
            if (script == null) {
                sendError(ctx, 404, "Script not found: " + id);
                return;
            }
            
            boolean wasEnabled = script.isEnabled();
            script.setEnabled(!script.isEnabled());
            library.updateScript(id, script);
            
            // Update scheduler
            if (script.isEnabled()) {
                // Script was disabled, now enabled - add to scheduler
                boolean scheduled = library.addToScheduler(script);
                if (!scheduled) {
                    logger.warn("Failed to add script to scheduler: {}", id);
                }
            } else {
                // Script was enabled, now disabled - remove from scheduler
                library.removeFromScheduler(script);
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Script status toggled")
                .put("enabled", script.isEnabled())
                .put("script", script.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Toggled script {}: enabled={}", id, script.isEnabled());
        } catch (Exception e) {
            logger.error("Error toggling script", e);
            sendError(ctx, 500, "Error toggling script: " + e.getMessage());
        }
    }
    
    /**
     * Get all packages (grouped scripts)
     */
    private void handleGetPackages(RoutingContext ctx) {
        try {
            Map<String, List<OutlierScript>> packages = library.getAllPackages();
            
            JsonArray packagesArray = new JsonArray();
            for (Map.Entry<String, List<OutlierScript>> entry : packages.entrySet()) {
                String packageId = entry.getKey();
                List<OutlierScript> scripts = entry.getValue();
                
                if (!scripts.isEmpty()) {
                    OutlierScript firstScript = scripts.get(0);
                    long enabledCount = scripts.stream().filter(OutlierScript::isEnabled).count();
                    
                    JsonObject packageObj = new JsonObject()
                        .put("packageId", packageId)
                        .put("packageName", firstScript.getPackageName())
                        .put("scriptCount", scripts.size())
                        .put("enabledCount", enabledCount)
                        .put("allEnabled", enabledCount == scripts.size())
                        .put("scripts", new JsonArray(scripts.stream()
                            .map(OutlierScript::toJson)
                            .collect(Collectors.toList())));
                    
                    packagesArray.add(packageObj);
                }
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("packages", packagesArray)
                .put("totalPackages", packagesArray.size());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.debug("Retrieved {} packages", packagesArray.size());
        } catch (Exception e) {
            logger.error("Error getting packages", e);
            sendError(ctx, 500, "Error getting packages: " + e.getMessage());
        }
    }
    
    /**
     * Toggle package (enable/disable all scripts in package)
     */
    private void handleTogglePackage(RoutingContext ctx) {
        try {
            String packageId = ctx.pathParam("packageId");
            
            List<OutlierScript> packageScripts = library.getScriptsByPackage(packageId);
            if (packageScripts.isEmpty()) {
                sendError(ctx, 404, "Package not found: " + packageId);
                return;
            }
            
            // Determine new state - if any script is disabled, enable all; otherwise disable all
            boolean anyDisabled = packageScripts.stream().anyMatch(s -> !s.isEnabled());
            boolean newState = anyDisabled; // Enable if any disabled, otherwise disable
            
            boolean success = library.togglePackage(packageId, newState);
            
            JsonObject response = new JsonObject()
                .put("success", success)
                .put("message", "Package " + (newState ? "enabled" : "disabled"))
                .put("packageId", packageId)
                .put("packageName", packageScripts.get(0).getPackageName())
                .put("enabled", newState)
                .put("scriptCount", packageScripts.size());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Toggled package {}: enabled={}", packageId, newState);
        } catch (Exception e) {
            logger.error("Error toggling package", e);
            sendError(ctx, 500, "Error toggling package: " + e.getMessage());
        }
    }
    
    /**
     * Add schedule to script
     */
    private void addSchedule(RoutingContext ctx) {
        try {
            String scriptId = ctx.pathParam("id");
            JsonObject body = ctx.getBodyAsJson();
            
            OutlierScript script = library.getScriptById(scriptId);
            if (script == null) {
                sendError(ctx, 404, "Script not found: " + scriptId);
                return;
            }
            
            // Create new schedule
            ScriptSchedule schedule = new ScriptSchedule(
                body.getString("cronExpression"),
                body.getString("parameters", ""),
                body.getBoolean("enabled", true),
                body.getString("description", "")
            );
            
            // Add schedule to script
            script.addSchedule(schedule);
            library.updateScript(scriptId, script);
            
            // Add to scheduler if script and schedule are enabled
            logger.info("Checking if schedule should be added to system scheduler:");
            logger.info("  Script enabled: {}", script.isEnabled());
            logger.info("  Schedule enabled: {}", schedule.isEnabled());
            System.out.println("\n=== SCHEDULE ADDED TO SCRIPT ===");
            System.out.println("Script: " + script.getName());
            System.out.println("Script Enabled: " + script.isEnabled());
            System.out.println("Schedule Enabled: " + schedule.isEnabled());
            
            if (script.isEnabled() && schedule.isEnabled()) {
                System.out.println("✓ Both enabled - calling addToScheduler()");
                boolean scheduled = library.addToScheduler(script);
                if (!scheduled) {
                    logger.warn("Failed to add schedule to system scheduler: {}", schedule.getScheduleId());
                    System.err.println("✗ addToScheduler() returned false");
                }
            } else {
                System.out.println("✗ NOT calling addToScheduler() because:");
                if (!script.isEnabled()) {
                    System.out.println("  - Script is DISABLED (toggle the script to enable it)");
                }
                if (!schedule.isEnabled()) {
                    System.out.println("  - Schedule is DISABLED (check the 'Enabled' checkbox when creating schedule)");
                }
                System.out.println("\nTo add this schedule to Task Scheduler:");
                System.out.println("1. Make sure the script is enabled (toggle it on)");
                System.out.println("2. Make sure the schedule is enabled (checkbox in schedule form)");
                System.out.println("3. Or toggle the script off and on again to refresh scheduler");
            }
            System.out.println("================================\n");
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Schedule added successfully")
                .put("schedule", schedule.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Added schedule {} to script: {}", schedule.getScheduleId(), scriptId);
        } catch (Exception e) {
            logger.error("Error adding schedule", e);
            sendError(ctx, 500, "Error adding schedule: " + e.getMessage());
        }
    }
    
    /**
     * Update schedule
     */
    private void updateSchedule(RoutingContext ctx) {
        try {
            String scriptId = ctx.pathParam("id");
            String scheduleId = ctx.pathParam("scheduleId");
            JsonObject body = ctx.getBodyAsJson();
            
            OutlierScript script = library.getScriptById(scriptId);
            if (script == null) {
                sendError(ctx, 404, "Script not found: " + scriptId);
                return;
            }
            
            ScriptSchedule schedule = script.getScheduleById(scheduleId);
            if (schedule == null) {
                sendError(ctx, 404, "Schedule not found: " + scheduleId);
                return;
            }
            
            // Track old state for scheduler update
            boolean wasEnabled = schedule.isEnabled();
            String oldCron = schedule.getCronExpression();
            String oldParams = schedule.getParameters();
            
            // Update schedule fields
            if (body.containsKey("cronExpression")) {
                schedule.setCronExpression(body.getString("cronExpression"));
            }
            if (body.containsKey("parameters")) {
                schedule.setParameters(body.getString("parameters"));
            }
            if (body.containsKey("enabled")) {
                schedule.setEnabled(body.getBoolean("enabled"));
            }
            if (body.containsKey("description")) {
                schedule.setDescription(body.getString("description"));
            }
            
            library.updateScript(scriptId, script);
            
            // Update scheduler if relevant fields changed
            boolean cronChanged = !oldCron.equals(schedule.getCronExpression());
            boolean paramsChanged = (oldParams == null && schedule.getParameters() != null) ||
                                   (oldParams != null && !oldParams.equals(schedule.getParameters()));
            boolean enabledChanged = wasEnabled != schedule.isEnabled();
            
            if (script.isEnabled() && (cronChanged || paramsChanged || enabledChanged)) {
                // Remove and re-add to update scheduler
                library.removeFromScheduler(script);
                library.addToScheduler(script);
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Schedule updated successfully")
                .put("schedule", schedule.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Updated schedule {} for script: {}", scheduleId, scriptId);
        } catch (Exception e) {
            logger.error("Error updating schedule", e);
            sendError(ctx, 500, "Error updating schedule: " + e.getMessage());
        }
    }
    
    /**
     * Delete schedule
     */
    private void deleteSchedule(RoutingContext ctx) {
        try {
            String scriptId = ctx.pathParam("id");
            String scheduleId = ctx.pathParam("scheduleId");
            
            OutlierScript script = library.getScriptById(scriptId);
            if (script == null) {
                sendError(ctx, 404, "Script not found: " + scriptId);
                return;
            }
            
            ScriptSchedule schedule = script.getScheduleById(scheduleId);
            if (schedule == null) {
                sendError(ctx, 404, "Schedule not found: " + scheduleId);
                return;
            }
            
            // Remove from scheduler if script is enabled
            if (script.isEnabled()) {
                library.removeFromScheduler(script);
            }
            
            // Remove schedule from script
            boolean removed = script.removeSchedule(scheduleId);
            if (!removed) {
                sendError(ctx, 500, "Failed to remove schedule");
                return;
            }
            
            library.updateScript(scriptId, script);
            
            // Re-add remaining schedules to scheduler
            if (script.isEnabled()) {
                library.addToScheduler(script);
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Schedule deleted successfully");
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Deleted schedule {} from script: {}", scheduleId, scriptId);
        } catch (Exception e) {
            logger.error("Error deleting schedule", e);
            sendError(ctx, 500, "Error deleting schedule: " + e.getMessage());
        }
    }
    
    /**
     * Toggle schedule enabled status
     */
    private void toggleSchedule(RoutingContext ctx) {
        try {
            String scriptId = ctx.pathParam("id");
            String scheduleId = ctx.pathParam("scheduleId");
            
            OutlierScript script = library.getScriptById(scriptId);
            if (script == null) {
                sendError(ctx, 404, "Script not found: " + scriptId);
                return;
            }
            
            ScriptSchedule schedule = script.getScheduleById(scheduleId);
            if (schedule == null) {
                sendError(ctx, 404, "Schedule not found: " + scheduleId);
                return;
            }
            
            // Toggle schedule
            schedule.setEnabled(!schedule.isEnabled());
            library.updateScript(scriptId, script);
            
            // Update scheduler if script is enabled
            if (script.isEnabled()) {
                library.removeFromScheduler(script);
                library.addToScheduler(script);
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Schedule status toggled")
                .put("enabled", schedule.isEnabled())
                .put("schedule", schedule.toJson());
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Toggled schedule {} for script {}: enabled={}", scheduleId, scriptId, schedule.isEnabled());
        } catch (Exception e) {
            logger.error("Error toggling schedule", e);
            sendError(ctx, 500, "Error toggling schedule: " + e.getMessage());
        }
    }
    
    /**
     * Get available outliers from the outliers directory
     */
    public void getAvailableOutliers(RoutingContext ctx) {
        try {
            logger.info("Getting available outliers from outliers directory");
            
            // Get current working directory
            java.nio.file.Path currPath = java.nio.file.Paths.get("").toAbsolutePath();
            java.nio.file.Path outliersDir = currPath.resolve("outliers");
            
            logger.debug("Outliers directory path: {}", outliersDir);
            
            if (!java.nio.file.Files.exists(outliersDir)) {
                logger.warn("Outliers directory does not exist: {}", outliersDir);
                sendError(ctx, 404, "Outliers directory not found");
                return;
            }
            
            JsonArray outliersArray = new JsonArray();
            
            // List all ZIP files in the outliers directory
            try (java.util.stream.Stream<java.nio.file.Path> paths = java.nio.file.Files.list(outliersDir)) {
                paths.filter(path -> path.toString().toLowerCase().endsWith(".zip"))
                     .forEach(zipPath -> {
                         try {
                             String fileName = zipPath.getFileName().toString();
                             long fileSize = java.nio.file.Files.size(zipPath);
                             java.nio.file.attribute.BasicFileAttributes attrs = 
                                 java.nio.file.Files.readAttributes(zipPath, java.nio.file.attribute.BasicFileAttributes.class);
                             
                             JsonObject outlierInfo = new JsonObject()
                                 .put("fileName", fileName)
                                 .put("displayName", fileName.replace(".zip", "").replace("_", " "))
                                 .put("filePath", zipPath.toString())
                                 .put("fileSize", fileSize)
                                 .put("fileSizeMB", String.format("%.2f", fileSize / (1024.0 * 1024.0)))
                                 .put("lastModified", attrs.lastModifiedTime().toString());
                             
                             outliersArray.add(outlierInfo);
                             logger.debug("Found outlier: {}", fileName);
                         } catch (Exception e) {
                             logger.error("Error reading file info: {}", zipPath, e);
                         }
                     });
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("count", outliersArray.size())
                .put("outliers", outliersArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Retrieved {} available outliers", outliersArray.size());
        } catch (Exception e) {
            logger.error("Error getting available outliers", e);
            sendError(ctx, 500, "Error getting available outliers: " + e.getMessage());
        }
    }
    
    /**
     * Deploy an outlier from the outliers directory
     */
    public void deployOutlier(RoutingContext ctx) {
        try {
            JsonObject body = ctx.getBodyAsJson();
            String fileName = body.getString("fileName");
            
            if (fileName == null || fileName.isEmpty()) {
                sendError(ctx, 400, "fileName is required");
                return;
            }
            
            logger.info("Deploying outlier: {}", fileName);
            
            // Get current working directory
            java.nio.file.Path currPath = java.nio.file.Paths.get("").toAbsolutePath();
            java.nio.file.Path zipPath = currPath.resolve("outliers").resolve(fileName);
            
            if (!java.nio.file.Files.exists(zipPath)) {
                logger.warn("Outlier file not found: {}", zipPath);
                sendError(ctx, 404, "Outlier file not found: " + fileName);
                return;
            }
            
            // Get username from request or default
            String deployedBy = body.getString("deployedBy", "admin");
            
            logger.info("Processing outlier ZIP: {} deployed by: {}", fileName, deployedBy);
            
            // Process the ZIP file using the existing upload processing logic
            UploadResult uploadResult = library.processZipUploadWithConfig(zipPath.toString(), deployedBy);
            
            logger.info("Outlier deployment complete. Added: {}, Skipped duplicates: {}",
                       uploadResult.getAddedCount(), uploadResult.getSkippedCount());
            
            JsonArray scriptsArray = new JsonArray();
            uploadResult.getAddedScripts().forEach(script -> {
                logger.debug("Deployed script: {}", script.getName());
                scriptsArray.add(script.toJson());
            });
            
            JsonArray duplicatesArray = new JsonArray();
            uploadResult.getSkippedDuplicates().forEach(duplicatesArray::add);
            
            // Build message
            String message = "Outlier deployed successfully";
            if (uploadResult.hasDuplicates()) {
                message += ". " + uploadResult.getSkippedCount() + " duplicate(s) skipped";
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", message)
                .put("fileName", fileName)
                .put("addedCount", uploadResult.getAddedCount())
                .put("skippedCount", uploadResult.getSkippedCount())
                .put("totalProcessed", uploadResult.getTotalProcessed())
                .put("scripts", scriptsArray)
                .put("skippedDuplicates", duplicatesArray);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("=== OUTLIER DEPLOYMENT SUCCESS: {} - {} added, {} duplicates skipped ===",
                       fileName, uploadResult.getAddedCount(), uploadResult.getSkippedCount());
        } catch (Exception e) {
            logger.error("=== OUTLIER DEPLOYMENT ERROR ===", e);
            logger.error("Error type: {}", e.getClass().getName());
            logger.error("Error message: {}", e.getMessage());
            sendError(ctx, 500, "Error deploying outlier: " + e.getMessage());
        }
    }
    
    /**
     * Delete/undeploy a package (removes all scripts in the package)
     */
    public void deletePackage(RoutingContext ctx) {
        try {
            String packageId = ctx.pathParam("packageId");
            logger.info("Deleting package: {}", packageId);
            
            // Get all scripts in the package
            List<OutlierScript> scripts = library.getAllScripts();
            List<OutlierScript> packageScripts = scripts.stream()
                .filter(s -> packageId.equals(s.getPackageId()))
                .collect(java.util.stream.Collectors.toList());
            
            if (packageScripts.isEmpty()) {
                sendError(ctx, 404, "Package not found");
                return;
            }
            
            // Delete all scripts in the package
            int deletedCount = 0;
            for (OutlierScript script : packageScripts) {
                if (library.deleteScript(script.getId())) {
                    deletedCount++;
                }
            }
            
            JsonObject response = new JsonObject()
                .put("success", true)
                .put("message", "Package undeployed successfully. Removed " + deletedCount + " script(s)")
                .put("deletedCount", deletedCount);
            
            ctx.response()
                .putHeader("content-type", "application/json")
                .end(response.encodePrettily());
                
            logger.info("Package {} deleted. Removed {} scripts", packageId, deletedCount);
        } catch (Exception e) {
            logger.error("Error deleting package", e);
            sendError(ctx, 500, "Error deleting package: " + e.getMessage());
        }
    }
}
