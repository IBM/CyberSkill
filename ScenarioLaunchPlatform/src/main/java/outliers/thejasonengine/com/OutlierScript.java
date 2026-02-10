/*  Outlier Script
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package outliers.thejasonengine.com;

import io.vertx.core.json.JsonObject;
import io.vertx.core.json.JsonArray;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Represents an outlier script that can be scheduled for execution
 */
public class OutlierScript {
    
    private String id;
    private String name;
    private String description;
    private String scriptType; // "bash" or "windows"
    private String filePath;
    private String originalFileName;
    private long fileSize;
    private String uploadedBy;
    private LocalDateTime uploadedAt;
    private String cronExpression; // Deprecated: kept for backward compatibility
    private String parameters; // Deprecated: kept for backward compatibility
    private boolean enabled;
    private LocalDateTime lastExecuted;
    private String lastExecutionStatus;
    private List<String> tags;
    private String folderPath; // Path to the folder containing this script
    private String readmeContent; // Content of README file if found
    private List<String> relatedFiles; // List of other files in the same folder (SQL, etc.)
    private List<ScriptSchedule> schedules; // Multiple schedules for the same script
    private String packageId; // ID of the outlier package this script belongs to
    private String packageName; // Name of the outlier package (from JSON or ZIP name)
    
    public OutlierScript(String id, String name, String description, String scriptType,
                        String filePath, String originalFileName, long fileSize,
                        String uploadedBy, LocalDateTime uploadedAt, String cronExpression,
                        boolean enabled, List<String> tags) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.scriptType = scriptType;
        this.filePath = filePath;
        this.originalFileName = originalFileName;
        this.fileSize = fileSize;
        this.uploadedBy = uploadedBy;
        this.uploadedAt = uploadedAt;
        this.cronExpression = cronExpression;
        this.parameters = ""; // Default empty parameters
        this.enabled = enabled;
        this.tags = tags != null ? tags : new ArrayList<>();
        this.lastExecuted = null;
        this.lastExecutionStatus = "Never executed";
        this.folderPath = "";
        this.readmeContent = null;
        this.relatedFiles = new ArrayList<>();
        this.schedules = new ArrayList<>();
        
        // Migrate old single cron/parameters to schedules if provided
        if (cronExpression != null && !cronExpression.isEmpty()) {
            this.schedules.add(new ScriptSchedule(cronExpression, this.parameters, enabled, "Default schedule"));
        }
    }
    
    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getScriptType() { return scriptType; }
    public String getFilePath() { return filePath; }
    public String getOriginalFileName() { return originalFileName; }
    public long getFileSize() { return fileSize; }
    public String getUploadedBy() { return uploadedBy; }
    public LocalDateTime getUploadedAt() { return uploadedAt; }
    public String getCronExpression() { return cronExpression; }
    public String getParameters() { return parameters; }
    public boolean isEnabled() { return enabled; }
    public LocalDateTime getLastExecuted() { return lastExecuted; }
    public String getLastExecutionStatus() { return lastExecutionStatus; }
    public List<String> getTags() { return tags; }
    public String getFolderPath() { return folderPath; }
    public String getReadmeContent() { return readmeContent; }
    public String getPackageId() { return packageId; }
    public String getPackageName() { return packageName; }
    public List<String> getRelatedFiles() { return relatedFiles; }
    public List<ScriptSchedule> getSchedules() { return schedules; }
    
    // Setters
    public void setName(String name) { this.name = name; }
    public void setDescription(String description) { this.description = description; }
    public void setCronExpression(String cronExpression) { this.cronExpression = cronExpression; }
    public void setParameters(String parameters) { this.parameters = parameters; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    public void setLastExecuted(LocalDateTime lastExecuted) { this.lastExecuted = lastExecuted; }
    public void setLastExecutionStatus(String status) { this.lastExecutionStatus = status; }
    public void setTags(List<String> tags) { this.tags = tags; }
    public void setFolderPath(String folderPath) { this.folderPath = folderPath; }
    public void setReadmeContent(String readmeContent) { this.readmeContent = readmeContent; }
    public void setRelatedFiles(List<String> relatedFiles) { this.relatedFiles = relatedFiles; }
    public void setPackageId(String packageId) { this.packageId = packageId; }
    public void setPackageName(String packageName) { this.packageName = packageName; }
    public void setSchedules(List<ScriptSchedule> schedules) { this.schedules = schedules; }
    
    /**
     * Add a new schedule
     */
    public void addSchedule(ScriptSchedule schedule) {
        this.schedules.add(schedule);
    }
    
    /**
     * Remove a schedule by ID
     */
    public boolean removeSchedule(String scheduleId) {
        return this.schedules.removeIf(s -> s.getScheduleId().equals(scheduleId));
    }
    
    /**
     * Get schedule by ID
     */
    public ScriptSchedule getScheduleById(String scheduleId) {
        return this.schedules.stream()
            .filter(s -> s.getScheduleId().equals(scheduleId))
            .findFirst()
            .orElse(null);
    }
    
    /**
     * Get all enabled schedules
     */
    public List<ScriptSchedule> getEnabledSchedules() {
        return this.schedules.stream()
            .filter(ScriptSchedule::isEnabled)
            .collect(Collectors.toList());
    }
    
    public JsonObject toJson() {
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        
        JsonObject json = new JsonObject();
        json.put("id", id);
        json.put("name", name);
        json.put("description", description);
        json.put("scriptType", scriptType);
        json.put("filePath", filePath);
        json.put("originalFileName", originalFileName);
        json.put("fileSize", fileSize);
        json.put("uploadedBy", uploadedBy);
        json.put("uploadedAt", uploadedAt.format(formatter));
        json.put("cronExpression", cronExpression);
        json.put("parameters", parameters);
        json.put("enabled", enabled);
        json.put("lastExecuted", lastExecuted != null ? lastExecuted.format(formatter) : null);
        json.put("lastExecutionStatus", lastExecutionStatus);
        json.put("tags", new JsonArray(tags));
        json.put("folderPath", folderPath);
        json.put("readmeContent", readmeContent);
        json.put("relatedFiles", new JsonArray(relatedFiles));
        json.put("packageId", packageId);
        json.put("packageName", packageName);
        
        // Add schedules
        JsonArray schedulesArray = new JsonArray();
        schedules.forEach(schedule -> schedulesArray.add(schedule.toJson()));
        json.put("schedules", schedulesArray);
        
        return json;
    }
    
    public static OutlierScript fromJson(JsonObject json) {
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        
        List<String> tags = new ArrayList<>();
        if (json.containsKey("tags")) {
            json.getJsonArray("tags").forEach(t -> tags.add((String) t));
        }
        
        OutlierScript script = new OutlierScript(
            json.getString("id"),
            json.getString("name"),
            json.getString("description"),
            json.getString("scriptType"),
            json.getString("filePath"),
            json.getString("originalFileName"),
            json.getLong("fileSize", 0L),
            json.getString("uploadedBy"),
            LocalDateTime.parse(json.getString("uploadedAt"), formatter),
            json.getString("cronExpression"),
            json.getBoolean("enabled", false),
            tags
        );
        
        if (json.getString("lastExecuted") != null) {
            script.setLastExecuted(LocalDateTime.parse(json.getString("lastExecuted"), formatter));
        }
        script.setLastExecutionStatus(json.getString("lastExecutionStatus", "Never executed"));
        
        // Load schedules
        if (json.containsKey("schedules")) {
            List<ScriptSchedule> schedules = new ArrayList<>();
            json.getJsonArray("schedules").forEach(s -> {
                schedules.add(ScriptSchedule.fromJson((JsonObject) s));
            });
            script.setSchedules(schedules);
        }
        
        // Load folder path, readme, and related files if present
        if (json.containsKey("folderPath")) {
            script.setFolderPath(json.getString("folderPath"));
        }
        if (json.containsKey("readmeContent")) {
            script.setReadmeContent(json.getString("readmeContent"));
        }
        if (json.containsKey("relatedFiles")) {
            List<String> relatedFiles = new ArrayList<>();
            json.getJsonArray("relatedFiles").forEach(f -> relatedFiles.add((String) f));
            script.setRelatedFiles(relatedFiles);
        }
        if (json.containsKey("parameters")) {
            script.setParameters(json.getString("parameters"));
        }
        if (json.containsKey("packageId")) {
            script.setPackageId(json.getString("packageId"));
        }
        if (json.containsKey("packageName")) {
            script.setPackageName(json.getString("packageName"));
        }
        
        return script;
    }
    
    /**
     * Get human-readable file size
     */
    public String getFormattedFileSize() {
        if (fileSize < 1024) {
            return fileSize + " B";
        } else if (fileSize < 1024 * 1024) {
            return String.format("%.2f KB", fileSize / 1024.0);
        } else {
            return String.format("%.2f MB", fileSize / (1024.0 * 1024.0));
        }
    }
}

