/*  Script Schedule
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package outliers.thejasonengine.com;

import io.vertx.core.json.JsonObject;
import java.util.UUID;

/**
 * Represents a single schedule for a script
 * Allows multiple schedules with different cron expressions and parameters
 */
public class ScriptSchedule {
    
    private String scheduleId;
    private String cronExpression;
    private String parameters;
    private boolean enabled;
    private String description;
    
    public ScriptSchedule(String cronExpression, String parameters, boolean enabled, String description) {
        this.scheduleId = UUID.randomUUID().toString();
        this.cronExpression = cronExpression;
        this.parameters = parameters != null ? parameters : "";
        this.enabled = enabled;
        this.description = description != null ? description : "";
    }
    
    public ScriptSchedule(String scheduleId, String cronExpression, String parameters, boolean enabled, String description) {
        this.scheduleId = scheduleId;
        this.cronExpression = cronExpression;
        this.parameters = parameters != null ? parameters : "";
        this.enabled = enabled;
        this.description = description != null ? description : "";
    }
    
    // Getters
    public String getScheduleId() { return scheduleId; }
    public String getCronExpression() { return cronExpression; }
    public String getParameters() { return parameters; }
    public boolean isEnabled() { return enabled; }
    public String getDescription() { return description; }
    
    // Setters
    public void setScheduleId(String scheduleId) { this.scheduleId = scheduleId; }
    public void setCronExpression(String cronExpression) { this.cronExpression = cronExpression; }
    public void setParameters(String parameters) { this.parameters = parameters; }
    public void setEnabled(boolean enabled) { this.enabled = enabled; }
    public void setDescription(String description) { this.description = description; }
    
    /**
     * Convert to JSON
     */
    public JsonObject toJson() {
        return new JsonObject()
            .put("scheduleId", scheduleId)
            .put("cronExpression", cronExpression)
            .put("parameters", parameters)
            .put("enabled", enabled)
            .put("description", description);
    }
    
    /**
     * Create from JSON
     */
    public static ScriptSchedule fromJson(JsonObject json) {
        return new ScriptSchedule(
            json.getString("scheduleId"),
            json.getString("cronExpression"),
            json.getString("parameters"),
            json.getBoolean("enabled", false),
            json.getString("description", "")
        );
    }
    
    @Override
    public String toString() {
        return String.format("Schedule[%s: %s %s]", scheduleId, cronExpression, parameters);
    }
}
