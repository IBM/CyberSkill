/*  Outliers Database Persistence
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package outliers.thejasonengine.com;

import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;
import library.thejasonengine.com.AttackPattern;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Database persistence layer for Outliers scripts and schedules
 */
public class OutliersDatabase {
    
    private static final Logger logger = LogManager.getLogger(OutliersDatabase.class);
    private final Pool dbPool;
    
    public OutliersDatabase(Pool dbPool) {
        this.dbPool = dbPool;
    }
    
    /**
     * Save a script to the database (INSERT or UPDATE)
     */
    public Future<Void> saveScript(OutlierScript script) {
        Promise<Void> promise = Promise.promise();
        
        // Convert lists to JSON
        JsonArray relatedFilesJson = new JsonArray(script.getRelatedFiles());
        JsonArray tagsJson = new JsonArray(script.getTags());
        
        String sql = "INSERT INTO public.tb_outlier_scripts " +
                    "(id, name, description, script_type, file_path, original_file_name, file_size, " +
                    "uploaded_by, uploaded_at, enabled, last_executed, last_execution_status, " +
                    "folder_path, readme_content, related_files, tags, package_id, package_name) " +
                    "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15::jsonb, $16::jsonb, $17, $18) " +
                    "ON CONFLICT (id) DO UPDATE SET " +
                    "name = EXCLUDED.name, " +
                    "description = EXCLUDED.description, " +
                    "enabled = EXCLUDED.enabled, " +
                    "last_executed = EXCLUDED.last_executed, " +
                    "last_execution_status = EXCLUDED.last_execution_status, " +
                    "tags = EXCLUDED.tags, " +
                    "package_id = EXCLUDED.package_id, " +
                    "package_name = EXCLUDED.package_name, " +
                    "updated_at = CURRENT_TIMESTAMP";
        
        Tuple params = Tuple.of(
            script.getId(),
            script.getName(),
            script.getDescription(),
            script.getScriptType(),
            script.getFilePath(),
            script.getOriginalFileName(),
            script.getFileSize(),
            script.getUploadedBy(),
            script.getUploadedAt(),
            script.isEnabled(),
            script.getLastExecuted(),
            script.getLastExecutionStatus(),
            script.getFolderPath(),
            script.getReadmeContent(),
            relatedFilesJson.encode(),
            tagsJson.encode(),
            script.getPackageId(),
            script.getPackageName()
        );
        
        dbPool.preparedQuery(sql).execute(params, ar -> {
            if (ar.succeeded()) {
                logger.info("Saved script to database: {} ({})", script.getName(), script.getId());
                
                // Now save all schedules
                saveSchedules(script).onComplete(schedAr -> {
                    if (schedAr.succeeded()) {
                        promise.complete();
                    } else {
                        promise.fail(schedAr.cause());
                    }
                });
            } else {
                logger.error("Failed to save script to database: {}", script.getId(), ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Save all schedules for a script
     * Only saves schedules if OS is compatible with script type
     */
    private Future<Void> saveSchedules(OutlierScript script) {
        Promise<Void> promise = Promise.promise();
        
        if (script.getSchedules().isEmpty()) {
            promise.complete();
            return promise.future();
        }
        
        // Check OS compatibility before saving schedules
        String os = System.getProperty("os.name").toLowerCase();
        String scriptType = script.getScriptType().toLowerCase();
        boolean isCompatible = false;
        
        if (scriptType.equals("bash") && (os.contains("nix") || os.contains("nux") || os.contains("mac"))) {
            isCompatible = true;
        } else if (scriptType.equals("windows") && os.contains("win")) {
            isCompatible = true;
        }
        
        if (!isCompatible) {
            logger.warn("Skipping schedule save for script {} - OS incompatible (script type: {}, OS: {})",
                       script.getId(), scriptType, os);
            promise.complete();
            return promise.future();
        }
        
        // First, delete existing schedules for this script
        String deleteSql = "DELETE FROM public.tb_outlier_schedules WHERE script_id = $1";
        
        dbPool.preparedQuery(deleteSql).execute(Tuple.of(script.getId()), deleteAr -> {
            if (deleteAr.succeeded()) {
                // Now insert all current schedules
                List<Future<Void>> futures = new ArrayList<>();
                
                for (ScriptSchedule schedule : script.getSchedules()) {
                    futures.add(saveSchedule(script.getId(), schedule));
                }
                
                Future.all(new ArrayList<>(futures)).onComplete(ar -> {
                    if (ar.succeeded()) {
                        logger.debug("Saved {} schedules for script: {}", futures.size(), script.getId());
                        promise.complete();
                    } else {
                        promise.fail(ar.cause());
                    }
                });
            } else {
                promise.fail(deleteAr.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Save a single schedule
     */
    private Future<Void> saveSchedule(String scriptId, ScriptSchedule schedule) {
        Promise<Void> promise = Promise.promise();
        
        String sql = "INSERT INTO public.tb_outlier_schedules " +
                    "(schedule_id, script_id, cron_expression, parameters, enabled, description) " +
                    "VALUES ($1, $2, $3, $4, $5, $6)";
        
        Tuple params = Tuple.of(
            schedule.getScheduleId(),
            scriptId,
            schedule.getCronExpression(),
            schedule.getParameters(),
            schedule.isEnabled(),
            schedule.getDescription()
        );
        
        dbPool.preparedQuery(sql).execute(params, ar -> {
            if (ar.succeeded()) {
                promise.complete();
            } else {
                logger.error("Failed to save schedule: {}", schedule.getScheduleId(), ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Load all scripts from the database
     */
    public Future<List<OutlierScript>> loadAllScripts() {
        Promise<List<OutlierScript>> promise = Promise.promise();
        
        String sql = "SELECT * FROM public.tb_outlier_scripts ORDER BY uploaded_at DESC";
        
        dbPool.query(sql).execute(ar -> {
            if (ar.succeeded()) {
                RowSet<Row> rows = ar.result();
                List<OutlierScript> scripts = new ArrayList<>();
                
                for (Row row : rows) {
                    OutlierScript script = rowToScript(row);
                    scripts.add(script);
                }
                
                // Load schedules for all scripts
                loadSchedulesForScripts(scripts).onComplete(schedAr -> {
                    if (schedAr.succeeded()) {
                        logger.info("Loaded {} scripts from database", scripts.size());
                        promise.complete(scripts);
                    } else {
                        promise.fail(schedAr.cause());
                    }
                });
            } else {
                logger.error("Failed to load scripts from database", ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Load schedules for all scripts
     */
    private Future<Void> loadSchedulesForScripts(List<OutlierScript> scripts) {
        Promise<Void> promise = Promise.promise();
        
        if (scripts.isEmpty()) {
            promise.complete();
            return promise.future();
        }
        
        String sql = "SELECT * FROM public.tb_outlier_schedules ORDER BY created_at";
        
        dbPool.query(sql).execute(ar -> {
            if (ar.succeeded()) {
                RowSet<Row> rows = ar.result();
                
                // Group schedules by script_id
                for (Row row : rows) {
                    String scriptId = row.getString("script_id");
                    ScriptSchedule schedule = rowToSchedule(row);
                    
                    // Find the script and add the schedule
                    scripts.stream()
                        .filter(s -> s.getId().equals(scriptId))
                        .findFirst()
                        .ifPresent(s -> s.addSchedule(schedule));
                }
                
                promise.complete();
            } else {
                logger.error("Failed to load schedules from database", ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Delete a script from the database (cascades to schedules)
     */
    public Future<Void> deleteScript(String scriptId) {
        Promise<Void> promise = Promise.promise();
        
        String sql = "DELETE FROM public.tb_outlier_scripts WHERE id = $1";
        
        dbPool.preparedQuery(sql).execute(Tuple.of(scriptId), ar -> {
            if (ar.succeeded()) {
                logger.info("Deleted script from database: {}", scriptId);
                promise.complete();
            } else {
                logger.error("Failed to delete script from database: {}", scriptId, ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Convert database row to OutlierScript object
     */
    private OutlierScript rowToScript(Row row) {
        // Parse JSON arrays
        List<String> relatedFiles = new ArrayList<>();
        List<String> tags = new ArrayList<>();
        
        try {
            JsonArray relatedFilesJson = new JsonArray(row.getString("related_files"));
            for (int i = 0; i < relatedFilesJson.size(); i++) {
                relatedFiles.add(relatedFilesJson.getString(i));
            }
        } catch (Exception e) {
            logger.warn("Failed to parse related_files JSON", e);
        }
        
        try {
            JsonArray tagsJson = new JsonArray(row.getString("tags"));
            for (int i = 0; i < tagsJson.size(); i++) {
                tags.add(tagsJson.getString(i));
            }
        } catch (Exception e) {
            logger.warn("Failed to parse tags JSON", e);
        }
        
        OutlierScript script = new OutlierScript(
            row.getString("id"),
            row.getString("name"),
            row.getString("description"),
            row.getString("script_type"),
            row.getString("file_path"),
            row.getString("original_file_name"),
            row.getLong("file_size"),
            row.getString("uploaded_by"),
            row.getLocalDateTime("uploaded_at"),
            "", // cronExpression - deprecated, will be in schedules
            row.getBoolean("enabled"),
            tags
        );
        
        script.setLastExecuted(row.getLocalDateTime("last_executed"));
        script.setLastExecutionStatus(row.getString("last_execution_status"));
        script.setFolderPath(row.getString("folder_path"));
        script.setReadmeContent(row.getString("readme_content"));
        script.setRelatedFiles(relatedFiles);
        script.setPackageId(row.getString("package_id"));
        script.setPackageName(row.getString("package_name"));
        
        return script;
    }
    
    /**
     * Convert database row to ScriptSchedule object
     */
    private ScriptSchedule rowToSchedule(Row row) {
        return new ScriptSchedule(
            row.getString("schedule_id"),
            row.getString("cron_expression"),
            row.getString("parameters"),
            row.getBoolean("enabled"),
            row.getString("description")
        );
    }
    
    /**
     * Save an attack pattern to the database
     */
    public Future<Void> saveAttackPattern(AttackPattern pattern) {
        Promise<Void> promise = Promise.promise();
        
        JsonArray targetDbsJson = new JsonArray(pattern.getTargetDatabases());
        JsonArray examplesJson = new JsonArray(pattern.getSqlQueries());
        JsonArray tagsJson = new JsonArray(pattern.getTags());
        
        String sql = "INSERT INTO public.tb_attack_patterns " +
                    "(id, name, category, description, severity, attack_type, mitigation, " +
                    "target_databases, example_queries, tags) " +
                    "VALUES ($1, $2, $3, $4, $5, $6, $7, $8::jsonb, $9::jsonb, $10::jsonb) " +
                    "ON CONFLICT (id) DO UPDATE SET " +
                    "name = EXCLUDED.name, " +
                    "category = EXCLUDED.category, " +
                    "description = EXCLUDED.description, " +
                    "severity = EXCLUDED.severity, " +
                    "attack_type = EXCLUDED.attack_type, " +
                    "mitigation = EXCLUDED.mitigation, " +
                    "target_databases = EXCLUDED.target_databases, " +
                    "example_queries = EXCLUDED.example_queries, " +
                    "tags = EXCLUDED.tags, " +
                    "updated_at = CURRENT_TIMESTAMP";
        
        Tuple params = Tuple.of(
            pattern.getId(),
            pattern.getName(),
            pattern.getCategory(),
            pattern.getDescription(),
            pattern.getSeverity(),
            pattern.getExpectedGuardiumAlert(),
            pattern.getMitigation(),
            targetDbsJson.encode(),
            examplesJson.encode(),
            tagsJson.encode()
        );
        
        dbPool.preparedQuery(sql).execute(params, ar -> {
            if (ar.succeeded()) {
                logger.info("Saved attack pattern to database: {} ({})", pattern.getName(), pattern.getId());
                promise.complete();
            } else {
                logger.error("Failed to save attack pattern to database: {}", pattern.getId(), ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Load all attack patterns from the database
     */
    public Future<List<AttackPattern>> loadAllAttackPatterns() {
        Promise<List<AttackPattern>> promise = Promise.promise();
        
        String sql = "SELECT * FROM public.tb_attack_patterns ORDER BY category, name";
        
        dbPool.query(sql).execute(ar -> {
            if (ar.succeeded()) {
                RowSet<Row> rows = ar.result();
                List<AttackPattern> patterns = new ArrayList<>();
                
                for (Row row : rows) {
                    AttackPattern pattern = rowToAttackPattern(row);
                    patterns.add(pattern);
                }
                
                logger.info("Loaded {} attack patterns from database", patterns.size());
                promise.complete(patterns);
            } else {
                logger.error("Failed to load attack patterns from database", ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Delete an attack pattern from the database
     */
    public Future<Void> deleteAttackPattern(String patternId) {
        Promise<Void> promise = Promise.promise();
        
        String sql = "DELETE FROM public.tb_attack_patterns WHERE id = $1";
        
        dbPool.preparedQuery(sql).execute(Tuple.of(patternId), ar -> {
            if (ar.succeeded()) {
                logger.info("Deleted attack pattern from database: {}", patternId);
                promise.complete();
            } else {
                logger.error("Failed to delete attack pattern from database: {}", patternId, ar.cause());
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Convert database row to AttackPattern object
     */
    private AttackPattern rowToAttackPattern(Row row) {
        List<String> targetDatabases = new ArrayList<>();
        List<String> exampleQueries = new ArrayList<>();
        List<String> tags = new ArrayList<>();
        
        try {
            JsonArray targetDbsJson = new JsonArray(row.getString("target_databases"));
            for (int i = 0; i < targetDbsJson.size(); i++) {
                targetDatabases.add(targetDbsJson.getString(i));
            }
        } catch (Exception e) {
            logger.warn("Failed to parse target_databases JSON", e);
        }
        
        try {
            JsonArray examplesJson = new JsonArray(row.getString("example_queries"));
            for (int i = 0; i < examplesJson.size(); i++) {
                exampleQueries.add(examplesJson.getString(i));
            }
        } catch (Exception e) {
            logger.warn("Failed to parse example_queries JSON", e);
        }
        
        try {
            JsonArray tagsJson = new JsonArray(row.getString("tags"));
            for (int i = 0; i < tagsJson.size(); i++) {
                tags.add(tagsJson.getString(i));
            }
        } catch (Exception e) {
            logger.warn("Failed to parse tags JSON", e);
        }
        
        return new AttackPattern(
            row.getString("id"),
            row.getString("name"),
            row.getString("category"),
            row.getString("description"),
            row.getString("severity"),
            targetDatabases,
            exampleQueries,
            row.getString("attack_type"),
            row.getString("mitigation"),
            tags
        );
    }
}
