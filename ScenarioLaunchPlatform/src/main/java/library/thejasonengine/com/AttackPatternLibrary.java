/*  Attack Pattern Library
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package library.thejasonengine.com;

import java.util.*;
import java.util.stream.Collectors;
import memory.thejasonengine.com.Ram;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Singleton library that manages pre-built attack pattern templates
 * Now loads patterns from PostgreSQL database instead of hardcoding
 */
public class AttackPatternLibrary {
    
    private static final Logger logger = LogManager.getLogger(AttackPatternLibrary.class);
    private static AttackPatternLibrary instance;
    private Map<String, AttackPattern> patterns = new HashMap<>();
    private boolean loadedFromDatabase = false;
    
    private AttackPatternLibrary() {
        initializePatterns();
    }
    
    public static synchronized AttackPatternLibrary getInstance() {
        if (instance == null) {
            instance = new AttackPatternLibrary();
        }
        return instance;
    }
    
    private void initializePatterns() {
        logger.info("Initializing Attack Pattern Library...");
        
        // Load fallback patterns first (non-blocking)
        loadFallbackPatterns();
        logger.info("Loaded {} fallback patterns", patterns.size());
        
        // Then try to load from database asynchronously
        loadPatternsFromDatabaseAsync();
    }
    
    /**
     * Load attack patterns from PostgreSQL tb_attack_patterns table asynchronously
     * This won't block the event loop
     */
    private void loadPatternsFromDatabaseAsync() {
        try {
            Ram ram = new Ram();
            Pool pool = ram.getPostGresSystemPool();
            
            if (pool == null) {
                logger.warn("PostgreSQL pool is null, using fallback patterns only");
                return;
            }
            
            String query = "SELECT id, name, category, description, severity, attack_type, " +
                          "mitigation, target_databases, example_queries, tags " +
                          "FROM public.tb_attack_patterns ORDER BY category, name";
            
            // Async query - won't block event loop
            pool.query(query).execute(ar -> {
                if (ar.succeeded()) {
                    RowSet<Row> rows = ar.result();
                    logger.info("Found {} attack patterns in database", rows.size());
                    
                    // Clear fallback patterns and load from database
                    patterns.clear();
                    
                    for (Row row : rows) {
                        try {
                            String id = row.getString("id");
                            String name = row.getString("name");
                            String category = row.getString("category");
                            String description = row.getString("description");
                            String severity = row.getString("severity");
                            String expectedAlert = row.getString("attack_type");
                            String mitigation = row.getString("mitigation");
                            
                            // Parse JSONB arrays
                            JsonArray targetDbsJson = row.getJsonArray("target_databases");
                            JsonArray queriesJson = row.getJsonArray("example_queries");
                            JsonArray tagsJson = row.getJsonArray("tags");
                            
                            // Convert to Lists
                            List<String> targetDatabases = new ArrayList<>();
                            if (targetDbsJson != null) {
                                for (int i = 0; i < targetDbsJson.size(); i++) {
                                    targetDatabases.add(targetDbsJson.getString(i));
                                }
                            }
                            
                            List<String> sqlQueries = new ArrayList<>();
                            if (queriesJson != null) {
                                for (int i = 0; i < queriesJson.size(); i++) {
                                    sqlQueries.add(queriesJson.getString(i));
                                }
                            }
                            
                            List<String> tags = new ArrayList<>();
                            if (tagsJson != null) {
                                for (int i = 0; i < tagsJson.size(); i++) {
                                    tags.add(tagsJson.getString(i));
                                }
                            }
                            
                            // Create and add pattern
                            AttackPattern pattern = new AttackPattern(
                                id, name, category, description, severity,
                                targetDatabases, sqlQueries, expectedAlert, mitigation, tags
                            );
                            
                            patterns.put(id, pattern);
                            logger.debug("Loaded pattern: {} - {}", id, name);
                            
                        } catch (Exception e) {
                            logger.error("Error parsing pattern row: {}", e.getMessage());
                        }
                    }
                    
                    loadedFromDatabase = true;
                    logger.info("Successfully loaded {} patterns from database", patterns.size());
                    
                } else {
                    logger.error("Failed to query attack patterns: {}", ar.cause().getMessage());
                    logger.warn("Continuing with fallback patterns");
                }
            });
            
        } catch (Exception e) {
            logger.error("Exception loading patterns from database: {}", e.getMessage(), e);
            logger.warn("Continuing with fallback patterns");
        }
    }
    
    /**
     * Fallback hardcoded patterns if database load fails
     */
    private void loadFallbackPatterns() {
        logger.info("Loading fallback hardcoded patterns...");
        
        // SQL Injection Patterns with FIXED column names
        addPattern(new AttackPattern(
            "sqli-union-001",
            "Union-Based SQL Injection",
            "SQL Injection",
            "Attempts to extract database schema information using UNION SELECT to combine product data with information_schema metadata",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT id, name, description, price, quantity FROM crm.tbl_product WHERE id = 'd67f8d9d' UNION SELECT table_name, column_name, NULL, NULL, NULL FROM information_schema.columns"
            ),
            "SQL_INJECTION_UNION",
            "Use parameterized queries, input validation, and least privilege database accounts",
            Arrays.asList("sqli", "union", "data-extraction", "owasp-top10")
        ));
        
        addPattern(new AttackPattern(
            "sqli-blind-002",
            "Blind SQL Injection",
            "SQL Injection",
            "Boolean-based blind SQL injection that infers data by observing application behavior",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE id = 'df61978a-f4cc-ff64-8de0-53e90f19a56a' AND 1=1",
                "SELECT * FROM crm.tbl_crm_accounts WHERE id = 'df61978a-f4cc-ff64-8de0-53e90f19a56a' AND 1=2",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND SUBSTRING(password,1,1) = 'a'"
            ),
            "SQL_INJECTION_BLIND",
            "Implement proper error handling, use parameterized queries, and monitor for unusual query patterns",
            Arrays.asList("sqli", "blind", "inference", "owasp-top10")
        ));
        
        addPattern(new AttackPattern(
            "sqli-time-003",
            "Time-Based SQL Injection",
            "SQL Injection",
            "Uses database sleep functions to infer data based on response time delays",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE id = 'df61978a-f4cc-ff64-8de0-53e90f19a56a' AND SLEEP(5)",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND IF(SUBSTRING(password,1,1)='a', SLEEP(5), 0)",
                "SELECT * FROM crm.tbl_product WHERE id = 'd67f8d9d' AND SLEEP(5)"
            ),
            "SQL_INJECTION_TIME_BASED",
            "Use parameterized queries, implement query timeout limits, and monitor for slow queries",
            Arrays.asList("sqli", "time-based", "blind", "owasp-top10")
        ));
        
        logger.info("Loaded {} fallback patterns", patterns.size());
    }
    
    public void addPattern(AttackPattern pattern) {
        patterns.put(pattern.getId(), pattern);
    }
    
    public AttackPattern getPattern(String id) {
        return patterns.get(id);
    }
    
    public List<AttackPattern> getAllPatterns() {
        return new ArrayList<>(patterns.values());
    }
    
    public List<AttackPattern> getPatternsByCategory(String category) {
        return patterns.values().stream()
            .filter(p -> p.getCategory().equalsIgnoreCase(category))
            .collect(Collectors.toList());
    }
    
    public List<AttackPattern> getPatternsBySeverity(String severity) {
        return patterns.values().stream()
            .filter(p -> p.getSeverity().equalsIgnoreCase(severity))
            .collect(Collectors.toList());
    }
    
    public List<String> getAllCategories() {
        return patterns.values().stream()
            .map(AttackPattern::getCategory)
            .distinct()
            .sorted()
            .collect(Collectors.toList());
    }
    
    public int getTotalPatternCount() {
        return patterns.size();
    }
    
    public boolean isLoadedFromDatabase() {
        return loadedFromDatabase;
    }
    
    /**
     * Reload patterns from database (useful after database updates)
     */
    public synchronized void reloadPatterns() {
        logger.info("Reloading attack patterns from database...");
        patterns.clear();
        loadedFromDatabase = false;
        initializePatterns();
    }
    
    /**
     * Get pattern by ID (alias for getPattern)
     */
    public AttackPattern getPatternById(String id) {
        return getPattern(id);
    }
    
    /**
     * Get patterns by target database
     */
    public List<AttackPattern> getPatternsByDatabase(String database) {
        return patterns.values().stream()
            .filter(p -> p.getTargetDatabases().stream()
                .anyMatch(db -> db.equalsIgnoreCase(database)))
            .collect(Collectors.toList());
    }
    
    /**
     * Search patterns by name, description, or tags
     */
    public List<AttackPattern> searchPatterns(String query) {
        String lowerQuery = query.toLowerCase();
        return patterns.values().stream()
            .filter(p ->
                p.getName().toLowerCase().contains(lowerQuery) ||
                p.getDescription().toLowerCase().contains(lowerQuery) ||
                p.getTags().stream().anyMatch(tag -> tag.toLowerCase().contains(lowerQuery))
            )
            .collect(Collectors.toList());
    }
    
    /**
     * Get all categories (alias for getAllCategories)
     */
    public List<String> getCategories() {
        return getAllCategories();
    }
    
    /**
     * Get all severity levels
     */
    public List<String> getSeverityLevels() {
        return patterns.values().stream()
            .map(AttackPattern::getSeverity)
            .distinct()
            .sorted()
            .collect(Collectors.toList());
    }
    
    /**
     * Get pattern count by category
     */
    public Map<String, Long> getPatternCountByCategory() {
        return patterns.values().stream()
            .collect(Collectors.groupingBy(
                AttackPattern::getCategory,
                Collectors.counting()
            ));
    }
    
    /**
     * Get pattern count by severity
     */
    public Map<String, Long> getPatternCountBySeverity() {
        return patterns.values().stream()
            .collect(Collectors.groupingBy(
                AttackPattern::getSeverity,
                Collectors.counting()
            ));
    }
}
