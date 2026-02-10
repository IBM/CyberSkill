/*  Attack Pattern
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package library.thejasonengine.com;

import io.vertx.core.json.JsonObject;
import io.vertx.core.json.JsonArray;
import java.util.List;
import java.util.ArrayList;

/**
 * Represents an attack pattern template
 */
public class AttackPattern {
    
    private String id;
    private String name;
    private String category;
    private String description;
    private String severity;
    private List<String> targetDatabases;
    private List<String> sqlQueries;
    private String expectedGuardiumAlert;
    private String mitigation;
    private List<String> tags;
    
    public AttackPattern(String id, String name, String category, String description, 
                        String severity, List<String> targetDatabases, List<String> sqlQueries,
                        String expectedGuardiumAlert, String mitigation, List<String> tags) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.description = description;
        this.severity = severity;
        this.targetDatabases = targetDatabases;
        this.sqlQueries = sqlQueries;
        this.expectedGuardiumAlert = expectedGuardiumAlert;
        this.mitigation = mitigation;
        this.tags = tags;
    }
    
    // Getters
    public String getId() { return id; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public String getDescription() { return description; }
    public String getSeverity() { return severity; }
    public List<String> getTargetDatabases() { return targetDatabases; }
    public List<String> getSqlQueries() { return sqlQueries; }
    public String getExpectedGuardiumAlert() { return expectedGuardiumAlert; }
    public String getMitigation() { return mitigation; }
    public List<String> getTags() { return tags; }
    
    public JsonObject toJson() {
        JsonObject json = new JsonObject();
        json.put("id", id);
        json.put("name", name);
        json.put("category", category);
        json.put("description", description);
        json.put("severity", severity);
        json.put("targetDatabases", new JsonArray(targetDatabases));
        json.put("sqlQueries", new JsonArray(sqlQueries));
        json.put("expectedGuardiumAlert", expectedGuardiumAlert);
        json.put("mitigation", mitigation);
        json.put("tags", new JsonArray(tags));
        return json;
    }
    
    public static AttackPattern fromJson(JsonObject json) {
        List<String> targetDbs = new ArrayList<>();
        json.getJsonArray("targetDatabases").forEach(db -> targetDbs.add((String) db));
        
        List<String> queries = new ArrayList<>();
        json.getJsonArray("sqlQueries").forEach(q -> queries.add((String) q));
        
        List<String> tags = new ArrayList<>();
        json.getJsonArray("tags").forEach(t -> tags.add((String) t));
        
        return new AttackPattern(
            json.getString("id"),
            json.getString("name"),
            json.getString("category"),
            json.getString("description"),
            json.getString("severity"),
            targetDbs,
            queries,
            json.getString("expectedGuardiumAlert"),
            json.getString("mitigation"),
            tags
        );
    }
}

