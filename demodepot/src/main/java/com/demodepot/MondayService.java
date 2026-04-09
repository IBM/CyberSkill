package com.demodepot;

import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.buffer.Buffer;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.client.WebClient;
import io.vertx.ext.web.client.WebClientOptions;
import io.vertx.ext.web.client.HttpResponse;
import io.vertx.ext.web.multipart.MultipartForm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Properties;

/**
 * Service for integrating with Monday.com API
 * Creates tasks/items in Monday.com boards when demo requests are submitted
 */
public class MondayService {
    private static final Logger logger = LoggerFactory.getLogger(MondayService.class);
    private static final String MONDAY_API_URL = "https://api.monday.com/v2";
    
    private final WebClient webClient;
    private final String apiToken;
    private final String boardId;
    private final String groupId;
    private final boolean enabled;
    
    // Column IDs from configuration
    private final String statusColumnId;
    private final String dateColumnId;
    private final String filesColumnId;
    
    // Group IDs from configuration
    private final String featureFlashGroupId;
    private final String standardGroupId;
    private final String extendedGroupId;

    public MondayService(Vertx vertx) {
        // Load configuration
        Properties config = loadConfiguration();
        
        this.apiToken = config.getProperty("monday.api.token", "");
        this.boardId = config.getProperty("monday.board.id", "");
        this.groupId = config.getProperty("monday.group.id", "");
        this.enabled = Boolean.parseBoolean(config.getProperty("monday.enabled", "false"));
        
        // Load column IDs
        this.statusColumnId = config.getProperty("monday.column.status", "status");
        this.dateColumnId = config.getProperty("monday.column.date", "date4");
        this.filesColumnId = config.getProperty("monday.column.files", "files");
        
        // Load group IDs
        this.featureFlashGroupId = config.getProperty("monday.group.feature_flash", "topics");
        this.standardGroupId = config.getProperty("monday.group.standard", "group_title");
        this.extendedGroupId = config.getProperty("monday.group.extended", "group_mm1j259k");
        
        // Create web client with increased header size for Monday.com responses
        WebClientOptions options = new WebClientOptions()
            .setSsl(true)
            .setTrustAll(false)
            .setDefaultHost("api.monday.com")
            .setDefaultPort(443)
            .setMaxHeaderSize(16384); // Increase from default 8192 to 16384 bytes
        
        this.webClient = WebClient.create(vertx, options);
        
        if (enabled) {
            logger.info("Monday.com integration enabled - Board ID: {}", boardId);
        } else {
            logger.info("Monday.com integration disabled");
        }
    }
    
    /**
     * Get the files column ID from configuration
     */
    public String getFilesColumnId() {
        return filesColumnId;
    }

    /**
     * Load configuration from properties file
     */
    private Properties loadConfiguration() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("monday-config.properties")) {
            if (input != null) {
                props.load(input);
                logger.info("Loaded Monday.com configuration");
            } else {
                logger.warn("monday-config.properties not found, using defaults");
            }
        } catch (IOException e) {
            logger.error("Error loading Monday.com configuration", e);
        }
        return props;
    }

    /**
     * Create a task in Monday.com for a demo request
     * 
     * @param demoRequest The demo request data
     * @return Future that completes when the task is created
     */
    public Future<JsonObject> createTask(JsonObject demoRequest) {
        if (!enabled) {
            logger.debug("Monday.com integration disabled, skipping task creation");
            return Future.succeededFuture(new JsonObject().put("skipped", true));
        }

        if (apiToken.isEmpty() || boardId.isEmpty()) {
            logger.error("Monday.com API token or board ID not configured");
            return Future.failedFuture("Monday.com not properly configured");
        }

        // Build the GraphQL mutation
        String mutation = buildCreateItemMutation(demoRequest);
        
        JsonObject requestBody = new JsonObject()
            .put("query", mutation);

        logger.info("Creating Monday.com task for demo request: {}", 
            demoRequest.getString("demo_name"));

        return webClient
            .post("/v2")
            .putHeader("Authorization", apiToken)
            .putHeader("Content-Type", "application/json")
            .sendJsonObject(requestBody)
            .compose(response -> {
                return handleResponse(response, "create");
            })
            .recover(throwable -> {
                logger.error("Failed to create Monday.com task", throwable);
                return Future.failedFuture(throwable);
            });
    }

    /**
     * Handle HTTP response from Monday.com API
     */
    private Future<JsonObject> handleResponse(HttpResponse<Buffer> response, String operation) {
        try {
            int status = response.statusCode();
            
            if (status == 200) {
                JsonObject body = response.bodyAsJsonObject();
                
                if (body.containsKey("errors")) {
                    String errors = body.getJsonArray("errors").encode();
                    logger.error("Monday.com API returned errors: {}", errors);
                    return Future.failedFuture("Monday.com API error: " + errors);
                }
                
                logger.info("Successfully {} Monday.com task", operation);
                return Future.succeededFuture(body);
            } else {
                String error = String.format("Monday.com API returned status %d: %s",
                    status, response.bodyAsString());
                logger.error(error);
                return Future.failedFuture(error);
            }
        } catch (Exception e) {
            logger.error("Error processing Monday.com response", e);
            return Future.failedFuture(e);
        }
    }

    /**
     * Build GraphQL mutation for creating an item
     * Monday.com columns: Item(text), Status, Date, Files
     */
    private String buildCreateItemMutation(JsonObject demoRequest) {
        String demoName = escapeGraphQL(demoRequest.getString("demo_name", "Untitled Demo"));
        String demoDate = demoRequest.getString("demo_date", "");
        String status = demoRequest.getString("status", "pending");
        String demoType = demoRequest.getString("demo_type", "");
        
        // Map demo type to Monday.com group
        String targetGroupId = mapDemoTypeToGroup(demoType);
        
        // Build column values JSON - must be properly escaped for GraphQL
        // Column IDs loaded from configuration
        StringBuilder columnValuesJson = new StringBuilder("{");
        
        // Status column
        String mondayStatus = mapStatusToMonday(status);
        columnValuesJson.append("\\\"").append(statusColumnId).append("\\\":{\\\"label\\\":\\\"")
            .append(mondayStatus).append("\\\"}");
        
        // Date column
        if (!demoDate.isEmpty()) {
            columnValuesJson.append(",\\\"").append(dateColumnId).append("\\\":{\\\"date\\\":\\\"")
                .append(demoDate).append("\\\"}");
        }
        
        columnValuesJson.append("}");
        
        // Build the mutation
        StringBuilder mutation = new StringBuilder();
        mutation.append("mutation { create_item (");
        mutation.append("board_id: ").append(boardId);
        
        // Use mapped group ID based on demo type, or fall back to config group ID
        if (!targetGroupId.isEmpty()) {
            mutation.append(", group_id: \"").append(targetGroupId).append("\"");
        } else if (!groupId.isEmpty()) {
            mutation.append(", group_id: \"").append(groupId).append("\"");
        }
        
        mutation.append(", item_name: \"").append(demoName).append("\"");
        mutation.append(", column_values: \"").append(columnValuesJson.toString()).append("\"");
        mutation.append(") { id name } }");
        
        logger.debug("Monday.com mutation: {}", mutation.toString());
        
        return mutation.toString();
    }
    
    /**
     * Map DemoDepot demo_type to Monday.com group ID
     * Groups: Feature Flash (topics), Standard (group_title), Extended (group_mm1j259k)
     */
    private String mapDemoTypeToGroup(String demoType) {
        if (demoType == null || demoType.isEmpty()) {
            return "";
        }
        
        switch (demoType.toLowerCase()) {
            case "feature flash":
            case "feature_flash":
            case "flash":
                return featureFlashGroupId;
                
            case "standard":
            case "standard demo":
                return standardGroupId;
                
            case "extended":
            case "extended demo":
                return extendedGroupId;
                
            default:
                logger.warn("Unknown demo type '{}', using default group", demoType);
                return "";
        }
    }

    /**
     * Map DemoDepot status to Monday.com status labels
     * Monday.com statuses: Working on it, Stuck, Done, Submitted, In Progress, On Hold
     */
    private String mapStatusToMonday(String status) {
        switch (status.toLowerCase()) {
            case "pending":
            case "submitted":
                return "Submitted";
            case "approved":
                return "Done";
            case "rejected":
                return "Stuck";
            case "completed":
                return "Done";
            case "in_progress":
            case "in progress":
                return "In Progress";
            case "on_hold":
            case "on hold":
                return "On Hold";
            default:
                return "Submitted";
        }
    }

    /**
     * Escape special characters for GraphQL strings
     */
    private String escapeGraphQL(String input) {
        if (input == null) {
            return "";
        }
        return input
            .replace("\\", "\\\\")
            .replace("\"", "\\\"")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t");
    }

    /**
     * Upload a file to Monday.com item using multipart/form-data
     *
     * @param itemId The Monday.com item ID
     * @param filePath Path to the file to upload
     * @param columnId The Files column ID
     * @return Future that completes when file is uploaded
     */
    public Future<JsonObject> uploadFile(String itemId, String filePath, String columnId) {
        if (!enabled) {
            return Future.succeededFuture(new JsonObject().put("skipped", true));
        }

        try {
            // Check if file exists
            java.nio.file.Path path = Paths.get(filePath);
            if (!Files.exists(path)) {
                logger.error("File not found: {}", filePath);
                return Future.failedFuture("File not found: " + filePath);
            }

            // Build the GraphQL mutation
            String mutation = String.format(
                "mutation add_file($file: File!) {add_file_to_column (item_id: %s, column_id:\"%s\", file: $file) {id}}",
                itemId, columnId
            );

            // Create multipart form with query, map, and file
            MultipartForm form = MultipartForm.create()
                .attribute("query", mutation)
                .attribute("map", "{\"image\":\"variables.file\"}")
                .binaryFileUpload("image", path.getFileName().toString(), filePath, "application/octet-stream");

            logger.info("Uploading file to Monday.com: {} to item {} column {}", filePath, itemId, columnId);

            // Send multipart request to /v2/file endpoint
            return webClient
                .post("/v2/file")
                .putHeader("Authorization", apiToken)
                .putHeader("API-version", "2023-10")
                .sendMultipartForm(form)
                .compose(response -> {
                    return handleResponse(response, "upload file");
                })
                .recover(err -> {
                    logger.error("File upload to Monday.com failed: {}", err.getMessage(), err);
                    // Don't fail the entire operation if file upload fails
                    return Future.succeededFuture(new JsonObject()
                        .put("file_upload_failed", true)
                        .put("error", err.getMessage()));
                });

        } catch (Exception e) {
            logger.error("Error preparing file upload", e);
            return Future.failedFuture(e);
        }
    }

    /**
     * Update a task in Monday.com (for status changes)
     *
     * @param itemId The Monday.com item ID
     * @param status The new status
     * @return Future that completes when the task is updated
     */
    public Future<JsonObject> updateTaskStatus(String itemId, String status) {
        if (!enabled) {
            return Future.succeededFuture(new JsonObject().put("skipped", true));
        }

        String mondayStatus = mapStatusToMonday(status);
        String mutation = String.format(
            "mutation { change_simple_column_value (board_id: %s, item_id: %s, column_id: \"status\", value: \"%s\") { id } }",
            boardId, itemId, mondayStatus
        );

        JsonObject requestBody = new JsonObject().put("query", mutation);

        return webClient
            .post("/v2")
            .putHeader("Authorization", apiToken)
            .putHeader("Content-Type", "application/json")
            .sendJsonObject(requestBody)
            .compose(response -> {
                return handleResponse(response, "update");
            });
    }
}

// Made with Bob
