/*  Execution History Manager
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package library.thejasonengine.com;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Manages execution history for attack patterns (in-memory storage)
 */
public class ExecutionHistoryManager {
    
    private static ExecutionHistoryManager instance;
    private ConcurrentHashMap<String, PatternExecutionRecord> executionHistory;
    
    private ExecutionHistoryManager() {
        this.executionHistory = new ConcurrentHashMap<>();
    }
    
    public static synchronized ExecutionHistoryManager getInstance() {
        if (instance == null) {
            instance = new ExecutionHistoryManager();
        }
        return instance;
    }
    
    /**
     * Add execution record to history
     */
    public void addExecution(PatternExecutionRecord record) {
        executionHistory.put(record.getExecutionId(), record);
    }
    
    /**
     * Get all execution records
     */
    public List<PatternExecutionRecord> getAllExecutions() {
        return new ArrayList<>(executionHistory.values());
    }
    
    /**
     * Get executions by pattern ID
     */
    public List<PatternExecutionRecord> getExecutionsByPattern(String patternId) {
        return executionHistory.values().stream()
            .filter(record -> record.getPatternId().equals(patternId))
            .collect(Collectors.toList());
    }
    
    /**
     * Get executions by category
     */
    public List<PatternExecutionRecord> getExecutionsByCategory(String category) {
        return executionHistory.values().stream()
            .filter(record -> record.getCategory().equals(category))
            .collect(Collectors.toList());
    }
    
    /**
     * Get recent executions (last N)
     */
    public List<PatternExecutionRecord> getRecentExecutions(int limit) {
        return executionHistory.values().stream()
            .sorted((a, b) -> b.getExecutionTime().compareTo(a.getExecutionTime()))
            .limit(limit)
            .collect(Collectors.toList());
    }
    
    /**
     * Clear all execution history
     */
    public void clearHistory() {
        executionHistory.clear();
    }
    
    /**
     * Get total execution count
     */
    public int getTotalExecutions() {
        return executionHistory.size();
    }
}
