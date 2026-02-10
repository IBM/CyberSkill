/*  Pattern Execution Record
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package library.thejasonengine.com;

import io.vertx.core.json.JsonObject;
import io.vertx.core.json.JsonArray;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;

/**
 * Records the execution of an attack pattern
 */
public class PatternExecutionRecord {
    
    private String executionId;
    private String patternId;
    private String patternName;
    private String category;
    private String severity;
    private String targetDatabase;
    private String databaseType;
    private LocalDateTime executionTime;
    private String executedBy;
    private int totalQueries;
    private int successfulQueries;
    private int failedQueries;
    private long executionDurationMs;
    private List<QueryResult> queryResults;
    private String guardiumAlertExpected;
    private boolean guardiumAlertDetected;
    private String notes;
    
    public PatternExecutionRecord(String executionId, String patternId, String patternName,
                                 String category, String severity, String targetDatabase,
                                 String databaseType, String executedBy) {
        this.executionId = executionId;
        this.patternId = patternId;
        this.patternName = patternName;
        this.category = category;
        this.severity = severity;
        this.targetDatabase = targetDatabase;
        this.databaseType = databaseType;
        this.executionTime = LocalDateTime.now();
        this.executedBy = executedBy;
        this.queryResults = new ArrayList<>();
        this.guardiumAlertDetected = false;
    }
    
    // Getters and Setters
    public String getExecutionId() { return executionId; }
    public String getPatternId() { return patternId; }
    public String getPatternName() { return patternName; }
    public String getCategory() { return category; }
    public String getSeverity() { return severity; }
    public String getTargetDatabase() { return targetDatabase; }
    public String getDatabaseType() { return databaseType; }
    public LocalDateTime getExecutionTime() { return executionTime; }
    public String getExecutedBy() { return executedBy; }
    public int getTotalQueries() { return totalQueries; }
    public int getSuccessfulQueries() { return successfulQueries; }
    public int getFailedQueries() { return failedQueries; }
    public long getExecutionDurationMs() { return executionDurationMs; }
    public List<QueryResult> getQueryResults() { return queryResults; }
    public String getGuardiumAlertExpected() { return guardiumAlertExpected; }
    public boolean isGuardiumAlertDetected() { return guardiumAlertDetected; }
    public String getNotes() { return notes; }
    
    public void setTotalQueries(int totalQueries) { this.totalQueries = totalQueries; }
    public void setSuccessfulQueries(int successfulQueries) { this.successfulQueries = successfulQueries; }
    public void setFailedQueries(int failedQueries) { this.failedQueries = failedQueries; }
    public void setExecutionDurationMs(long executionDurationMs) { this.executionDurationMs = executionDurationMs; }
    public void setGuardiumAlertExpected(String guardiumAlertExpected) { this.guardiumAlertExpected = guardiumAlertExpected; }
    public void setGuardiumAlertDetected(boolean guardiumAlertDetected) { this.guardiumAlertDetected = guardiumAlertDetected; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public void addQueryResult(QueryResult result) {
        this.queryResults.add(result);
    }
    
    public JsonObject toJson() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        
        JsonArray resultsArray = new JsonArray();
        queryResults.forEach(result -> resultsArray.add(result.toJson()));
        
        JsonObject json = new JsonObject();
        json.put("executionId", executionId);
        json.put("patternId", patternId);
        json.put("patternName", patternName);
        json.put("category", category);
        json.put("severity", severity);
        json.put("targetDatabase", targetDatabase);
        json.put("databaseType", databaseType);
        json.put("executionTime", executionTime.format(formatter));
        json.put("executedBy", executedBy);
        json.put("totalQueries", totalQueries);
        json.put("successfulQueries", successfulQueries);
        json.put("failedQueries", failedQueries);
        json.put("executionDurationMs", executionDurationMs);
        json.put("queryResults", resultsArray);
        json.put("guardiumAlertExpected", guardiumAlertExpected);
        json.put("guardiumAlertDetected", guardiumAlertDetected);
        json.put("notes", notes);
        
        return json;
    }
    
    /**
     * Inner class to represent individual query results
     */
    public static class QueryResult {
        private int queryNumber;
        private String query;
        private boolean success;
        private String errorMessage;
        private long executionTimeMs;
        private int rowsAffected;
        
        public QueryResult(int queryNumber, String query, boolean success) {
            this.queryNumber = queryNumber;
            this.query = query;
            this.success = success;
        }
        
        public int getQueryNumber() { return queryNumber; }
        public String getQuery() { return query; }
        public boolean isSuccess() { return success; }
        public String getErrorMessage() { return errorMessage; }
        public long getExecutionTimeMs() { return executionTimeMs; }
        public int getRowsAffected() { return rowsAffected; }
        
        public void setErrorMessage(String errorMessage) { this.errorMessage = errorMessage; }
        public void setExecutionTimeMs(long executionTimeMs) { this.executionTimeMs = executionTimeMs; }
        public void setRowsAffected(int rowsAffected) { this.rowsAffected = rowsAffected; }
        
        public JsonObject toJson() {
            JsonObject json = new JsonObject();
            json.put("queryNumber", queryNumber);
            json.put("query", query);
            json.put("success", success);
            json.put("errorMessage", errorMessage);
            json.put("executionTimeMs", executionTimeMs);
            json.put("rowsAffected", rowsAffected);
            return json;
        }
    }
}
