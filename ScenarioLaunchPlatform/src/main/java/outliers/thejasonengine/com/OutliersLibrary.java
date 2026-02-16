/*  Outliers Library
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*
*/

package outliers.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Vertx;
import io.vertx.core.Future;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.PoolOptions;
import memory.thejasonengine.com.Ram;

import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import io.vertx.core.json.JsonObject;
import io.vertx.core.json.JsonArray;

/**
 * Singleton library that manages outlier scripts with database persistence
 */
public class OutliersLibrary {
    
    private static final Logger logger = LogManager.getLogger(OutliersLibrary.class);
    private static OutliersLibrary instance;
    private Map<String, OutlierScript> scripts = new HashMap<>();
    private final String uploadsDirectory;
    private OutliersDatabase database;
    private boolean databaseInitialized = false;
    
    private OutliersLibrary() {
        this.uploadsDirectory = "outliers-uploads";
        initializeUploadsDirectory();
    }
    
    public static synchronized OutliersLibrary getInstance() {
        if (instance == null) {
            instance = new OutliersLibrary();
        }
        return instance;
    }
    
    /**
     * Initialize database connection and load scripts from database
     * This should be called once during application startup with the Vertx instance
     */
    public Future<Void> initializeDatabase(Vertx vertx) {
        if (databaseInitialized) {
            logger.info("Database already initialized");
            return Future.succeededFuture();
        }
        
        logger.info("Initializing OutliersLibrary database connection...");
        
        // Get configuration from Ram
        Ram ram = new Ram();
        JsonObject configs = ram.getSystemConfig();
        
        // Create PostgreSQL connection pool using config values
        PgConnectOptions connectOptions = new PgConnectOptions()
            .setHost(configs.getJsonObject("systemDatabaseController").getString("host"))
            .setPort(configs.getJsonObject("systemDatabaseController").getInteger("port"))
            .setDatabase(configs.getJsonObject("systemDatabaseController").getString("database"))
            .setUser(configs.getJsonObject("systemDatabaseController").getString("user"))
            .setPassword(configs.getJsonObject("systemDatabaseController").getString("password"));
        
        PoolOptions poolOptions = new PoolOptions()
            .setMaxSize(configs.getJsonObject("systemDatabaseController").getInteger("maxConnections"));
        
        Pool dbPool = Pool.pool(vertx, connectOptions, poolOptions);
        
        logger.info("Database pool created with host: {}, port: {}, database: {}",
            configs.getJsonObject("systemDatabaseController").getString("host"),
            configs.getJsonObject("systemDatabaseController").getInteger("port"),
            configs.getJsonObject("systemDatabaseController").getString("database"));
        
        database = new OutliersDatabase(dbPool);
        logger.info("Database pool created");
        
        return database.loadAllScripts()
            .onSuccess(loadedScripts -> {
                logger.info("Loaded {} scripts from database", loadedScripts.size());
                for (OutlierScript script : loadedScripts) {
                    scripts.put(script.getId(), script);
                    logger.debug("Loaded script: {} ({})", script.getName(), script.getId());
                }
                databaseInitialized = true;
                logger.info("Database initialization complete");
            })
            .onFailure(err -> {
                logger.error("Failed to load scripts from database", err);
                logger.warn("Continuing with in-memory storage only");
            })
            .mapEmpty();
    }
    
    /**
     * Check if database is initialized
     */
    public boolean isDatabaseInitialized() {
        return databaseInitialized;
    }
    
    private void initializeUploadsDirectory() {
        try {
            Path uploadsPath = Paths.get(uploadsDirectory);
            if (!Files.exists(uploadsPath)) {
                Files.createDirectories(uploadsPath);
                logger.info("Created outliers uploads directory: {}", uploadsDirectory);
            }
        } catch (IOException e) {
            logger.error("Failed to create uploads directory", e);
        }
    }
    
    /**
     * Add a new script to the library
     */
    public void addScript(OutlierScript script) {
        scripts.put(script.getId(), script);
        logger.info("Added script to library: {} ({}) - PackageId: {}, PackageName: {}",
                   script.getName(), script.getId(), script.getPackageId(), script.getPackageName());
        
        // Save to database if initialized
        if (databaseInitialized && database != null) {
            database.saveScript(script)
                .onSuccess(v -> logger.info("Script saved to database: {}", script.getId()))
                .onFailure(err -> logger.error("Failed to save script to database: {}", script.getId(), err));
        }
    }
    
    /**
     * Remove a script from the library
     */
    public boolean removeScript(String id) {
        OutlierScript script = scripts.remove(id);
        if (script != null) {
            // Delete from database if initialized
            if (databaseInitialized && database != null) {
                database.deleteScript(id)
                    .onSuccess(v -> logger.info("Script deleted from database: {}", id))
                    .onFailure(err -> logger.error("Failed to delete script from database: {}", id, err));
            }
            
            // Delete the file
            try {
                Files.deleteIfExists(Paths.get(script.getFilePath()));
                logger.info("Removed script: {} ({})", script.getName(), id);
                return true;
            } catch (IOException e) {
                logger.error("Failed to delete script file: {}", script.getFilePath(), e);
                return false;
            }
        }
        return false;
    }
    
    /**
     * Delete a script (alias for removeScript for consistency with handler naming)
     */
    public boolean deleteScript(String id) {
        return removeScript(id);
    }
    
    /**
     * Get all scripts
     */
    public List<OutlierScript> getAllScripts() {
        return new ArrayList<>(scripts.values());
    }
    
    /**
     * Get script by ID
     */
    public OutlierScript getScriptById(String id) {
        return scripts.get(id);
    }
    
    /**
     * Get scripts by type
     */
    public List<OutlierScript> getScriptsByType(String scriptType) {
        return scripts.values().stream()
            .filter(s -> s.getScriptType().equalsIgnoreCase(scriptType))
            .collect(Collectors.toList());
    }
    
    /**
     * Get enabled scripts
     */
    public List<OutlierScript> getEnabledScripts() {
        return scripts.values().stream()
            .filter(OutlierScript::isEnabled)
            .collect(Collectors.toList());
    }
    
    /**
     * Search scripts by query string
     */
    public List<OutlierScript> searchScripts(String query) {
        String lowerQuery = query.toLowerCase();
        return scripts.values().stream()
            .filter(s -> 
                s.getName().toLowerCase().contains(lowerQuery) ||
                s.getDescription().toLowerCase().contains(lowerQuery) ||
                s.getTags().stream().anyMatch(tag -> tag.toLowerCase().contains(lowerQuery))
            )
            .collect(Collectors.toList());
    }
    
    /**
     * Update script
     */
    public boolean updateScript(String id, OutlierScript updatedScript) {
        if (scripts.containsKey(id)) {
            scripts.put(id, updatedScript);
            logger.info("Updated script: {} ({})", updatedScript.getName(), id);
            
            // Save to database if initialized
            if (databaseInitialized && database != null) {
                database.saveScript(updatedScript)
                    .onSuccess(v -> logger.info("Script updated in database: {}", id))
                    .onFailure(err -> logger.error("Failed to update script in database: {}", id, err));
            }
            
            return true;
        }
        return false;
    }
    
    /**
     * Get total script count
     */
    public int getTotalScriptCount() {
        return scripts.size();
    }
    
    /**
     * Get script count by type
     */
    public Map<String, Long> getScriptCountByType() {
        return scripts.values().stream()
            .collect(Collectors.groupingBy(OutlierScript::getScriptType, Collectors.counting()));
    }
    
    /**
     * Get enabled script count
     */
    public long getEnabledScriptCount() {
        return scripts.values().stream()
            .filter(OutlierScript::isEnabled)
            .count();
    }
    
    /**
     * Check if a script with the same name already exists
     */
    public boolean isDuplicateScript(String scriptName) {
        return scripts.values().stream()
            .anyMatch(s -> s.getName().equalsIgnoreCase(scriptName));
    }
    
    /**
     * Find existing script by name
     */
    public OutlierScript findScriptByName(String scriptName) {
        return scripts.values().stream()
            .filter(s -> s.getName().equalsIgnoreCase(scriptName))
            .findFirst()
            .orElse(null);
    }
    
    /**
     * Get all scripts belonging to a specific package
     */
    public List<OutlierScript> getScriptsByPackage(String packageId) {
        return scripts.values().stream()
            .filter(s -> packageId.equals(s.getPackageId()))
            .collect(Collectors.toList());
    }
    
    /**
     * Get all unique packages (grouped by packageId)
     */
    public Map<String, List<OutlierScript>> getAllPackages() {
        logger.info("getAllPackages called - Total scripts in memory: {}", scripts.size());
        
        // Log all scripts with their package info
        scripts.values().forEach(s -> {
            logger.debug("Script: {} - PackageId: {}, PackageName: {}",
                        s.getName(), s.getPackageId(), s.getPackageName());
        });
        
        Map<String, List<OutlierScript>> packages = scripts.values().stream()
            .filter(s -> s.getPackageId() != null && !s.getPackageId().isEmpty())
            .collect(Collectors.groupingBy(OutlierScript::getPackageId));
            
        logger.info("getAllPackages returning {} packages", packages.size());
        packages.forEach((packageId, scriptList) -> {
            logger.info("Package: {} - {} scripts", packageId, scriptList.size());
        });
        
        return packages;
    }
    
    /**
     * Enable or disable all scripts in a package
     */
    public boolean togglePackage(String packageId, boolean enabled) {
        List<OutlierScript> packageScripts = getScriptsByPackage(packageId);
        if (packageScripts.isEmpty()) {
            logger.warn("No scripts found for package: {}", packageId);
            return false;
        }
        
        logger.info("Toggling package {} to {}: {} scripts", packageId, enabled, packageScripts.size());
        System.out.println("\n========================================");
        System.out.println("TOGGLE PACKAGE: " + packageScripts.get(0).getPackageName());
        System.out.println("Package ID: " + packageId);
        System.out.println("New State: " + (enabled ? "ENABLED" : "DISABLED"));
        System.out.println("Scripts: " + packageScripts.size());
        System.out.println("========================================");
        
        int successCount = 0;
        for (OutlierScript script : packageScripts) {
            script.setEnabled(enabled);
            updateScript(script.getId(), script);
            
            if (enabled) {
                // Add to scheduler if enabled and has schedules
                if (!script.getEnabledSchedules().isEmpty()) {
                    boolean added = addToScheduler(script);
                    if (added) {
                        successCount++;
                        System.out.println("  ✓ " + script.getName() + " - added to scheduler");
                    } else {
                        System.out.println("  ✗ " + script.getName() + " - failed to add to scheduler");
                    }
                } else {
                    System.out.println("  ⚠ " + script.getName() + " - no enabled schedules");
                }
            } else {
                // Remove from scheduler if disabled
                boolean removed = removeFromScheduler(script);
                if (removed) {
                    successCount++;
                    System.out.println("  ✓ " + script.getName() + " - removed from scheduler");
                } else {
                    System.out.println("  ⚠ " + script.getName() + " - not in scheduler");
                }
            }
        }
        
        System.out.println("========================================");
        System.out.println("Result: " + successCount + "/" + packageScripts.size() + " scripts updated");
        System.out.println("========================================\n");
        
        return true;
    }
    
    /**
     * Process uploaded ZIP file and extract scripts with related files
     */
    public UploadResult processZipUpload(String zipFilePath, String uploadedBy) throws IOException {
        UploadResult result = new UploadResult();
        String extractId = UUID.randomUUID().toString();
        String extractFolder = uploadsDirectory + File.separator + extractId;
        
        // First pass: Extract ALL files from ZIP
        Map<String, List<String>> folderContents = new HashMap<>();
        try (ZipInputStream zis = new ZipInputStream(new FileInputStream(zipFilePath))) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                if (!entry.isDirectory()) {
                    String entryName = entry.getName();
                    String extractedFilePath = extractFolder + File.separator + entryName.replace("/", File.separator);
                    
                    // Create parent directories
                    File parentDir = new File(extractedFilePath).getParentFile();
                    if (!parentDir.exists()) {
                        parentDir.mkdirs();
                    }
                    
                    // Extract file
                    Files.copy(zis, Paths.get(extractedFilePath), StandardCopyOption.REPLACE_EXISTING);
                    
                    // Track folder contents
                    String folderPath = parentDir.getAbsolutePath();
                    folderContents.putIfAbsent(folderPath, new ArrayList<>());
                    folderContents.get(folderPath).add(new File(extractedFilePath).getName());
                    
                    logger.debug("Extracted: {}", entryName);
                }
                zis.closeEntry();
            }
        }
        
        // Second pass: Process scripts and gather related files
        File extractDir = new File(extractFolder);
        processDirectory(extractDir, extractDir, result, folderContents, uploadedBy);
        
        // Delete the ZIP file after extraction
        Files.deleteIfExists(Paths.get(zipFilePath));
        
        return result;
    }
    
    /**
     * Recursively process directory to find scripts and related files
     */
    private void processDirectory(File dir, File rootDir, UploadResult result,
                                  Map<String, List<String>> folderContents, String uploadedBy) {
        File[] files = dir.listFiles();
        if (files == null) return;
        
        // Find README in this directory
        String readmeContent = null;
        for (File file : files) {
            if (file.isFile() && file.getName().toLowerCase().matches("readme\\.(txt|md)")) {
                try {
                    readmeContent = new String(Files.readAllBytes(file.toPath()));
                    logger.info("Found README: {}", file.getName());
                } catch (IOException e) {
                    logger.warn("Could not read README: {}", file.getName(), e);
                }
                break;
            }
        }
        
        // Process scripts in this directory
        for (File file : files) {
            if (file.isFile()) {
                String fileName = file.getName();
                String scriptType = determineScriptType(fileName);
                
                if (scriptType != null) {
                    // Check for duplicate script name
                    if (isDuplicateScript(fileName)) {
                        logger.warn("Skipping duplicate script: {}", fileName);
                        System.out.println("⚠ Skipping duplicate script: " + fileName);
                        result.addSkippedDuplicate(fileName);
                        continue; // Skip this script
                    }
                    
                    // This is a script file
                    String scriptId = UUID.randomUUID().toString();
                    String relativePath = rootDir.toPath().relativize(file.toPath()).toString();
                    String folderPath = file.getParent();
                    
                    // Get related files in same folder
                    List<String> relatedFiles = new ArrayList<>();
                    for (File relatedFile : files) {
                        if (relatedFile.isFile() && !relatedFile.equals(file)) {
                            relatedFiles.add(relatedFile.getName());
                        }
                    }
                    
                    // Create script object
                    OutlierScript script = new OutlierScript(
                        scriptId,
                        fileName,
                        "Extracted from ZIP: " + relativePath,
                        scriptType,
                        file.getAbsolutePath(),
                        fileName,
                        file.length(),
                        uploadedBy,
                        LocalDateTime.now(),
                        "",
                        false,
                        new ArrayList<>()
                    );
                    
                    // Set additional properties
                    script.setFolderPath(folderPath);
                    script.setReadmeContent(readmeContent);
                    script.setRelatedFiles(relatedFiles);
                    
                    addScript(script);
                    result.addScript(script);
                    logger.info("Processed script: {} with {} related files", fileName, relatedFiles.size());
                }
            } else if (file.isDirectory()) {
                // Recursively process subdirectories
                processDirectory(file, rootDir, result, folderContents, uploadedBy);
            }
        }
    }
    
    /**
     * Determine script type based on file extension
     */
    private String determineScriptType(String fileName) {
        String lowerName = fileName.toLowerCase();
        if (lowerName.endsWith(".sh") || lowerName.endsWith(".bash")) {
            return "bash";
        } else if (lowerName.endsWith(".bat") || lowerName.endsWith(".cmd") || lowerName.endsWith(".ps1")) {
            return "windows";
        }
        return null;
    }
    
    /**
     * Process uploaded ZIP file with JSON configuration support
     * Looks for outlier-config.json in the ZIP root and auto-configures schedules
     */
    public UploadResult processZipUploadWithConfig(String zipFilePath, String uploadedBy) throws IOException {
        UploadResult result = new UploadResult();
        String extractId = UUID.randomUUID().toString();
        String packageId = UUID.randomUUID().toString(); // Unique ID for this outlier package
        String extractFolder = uploadsDirectory + File.separator + extractId;
        
        JsonObject config = null;
        Map<String, List<String>> folderContents = new HashMap<>();
        
        // First pass: Extract ALL files and look for config
        try (ZipInputStream zis = new ZipInputStream(new FileInputStream(zipFilePath))) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                if (!entry.isDirectory()) {
                    String entryName = entry.getName();
                    String extractedFilePath = extractFolder + File.separator + entryName.replace("/", File.separator);
                    
                    // Create parent directories
                    File parentDir = new File(extractedFilePath).getParentFile();
                    if (!parentDir.exists()) {
                        parentDir.mkdirs();
                    }
                    
                    // Extract file
                    Files.copy(zis, Paths.get(extractedFilePath), StandardCopyOption.REPLACE_EXISTING);
                    
                    // Check if this is a config file (flexible naming: outlier-config.json, outlier_*.json, or any .json in root)
                    String fileName = new File(entryName).getName().toLowerCase();
                    boolean isConfigFile = fileName.equals("outlier-config.json") ||
                                          (fileName.startsWith("outlier") && fileName.endsWith(".json"));
                    
                    // Accept config if: (1) it's in root and matches pattern, OR (2) it's in a single-level subfolder and matches pattern
                    boolean isInRoot = !entryName.contains("/");
                    boolean isInSubfolder = entryName.matches("[^/]+/[^/]+\\.json");
                    
                    if (isConfigFile && (isInRoot || isInSubfolder)) {
                        try {
                            String configContent = new String(Files.readAllBytes(Paths.get(extractedFilePath)));
                            config = new JsonObject(configContent);
                            logger.info("Found configuration file: {} in ZIP", entryName);
                            System.out.println("✓ Found configuration file: " + entryName + " - will auto-configure schedules");
                        } catch (Exception e) {
                            logger.error("Failed to parse configuration file: {}", entryName, e);
                            System.out.println("✗ Failed to parse " + entryName + ": " + e.getMessage());
                        }
                    }
                    
                    // Track folder contents
                    String folderPath = parentDir.getAbsolutePath();
                    folderContents.putIfAbsent(folderPath, new ArrayList<>());
                    folderContents.get(folderPath).add(new File(extractedFilePath).getName());
                    
                    logger.debug("Extracted: {}", entryName);
                }
                zis.closeEntry();
            }
        }
        
        // Second pass: Process scripts
        File extractDir = new File(extractFolder);
        
        if (config != null) {
            // Process with JSON configuration
            String packageName = config.getString("outlierName", "Unknown Package");
            processDirectoryWithConfig(extractDir, extractDir, result, folderContents, uploadedBy, config, packageId, packageName);
        } else {
            // Process without configuration (legacy mode)
            processDirectory(extractDir, extractDir, result, folderContents, uploadedBy);
        }
        
        // NOTE: Do NOT delete the ZIP file - it may be from the library and needs to be preserved
        // Only delete if it's a temporary upload (not from outliers directory)
        // Files.deleteIfExists(Paths.get(zipFilePath));
        
        return result;
    }
    
    /**
     * Process directory with JSON configuration
     */
    private void processDirectoryWithConfig(File dir, File rootDir, UploadResult result,
                                           Map<String, List<String>> folderContents,
                                           String uploadedBy, JsonObject config,
                                           String packageId, String packageName) {
        File[] files = dir.listFiles();
        if (files == null) return;
        
        // Get outlier metadata from config
        String outlierName = config.getString("outlierName", "Unknown Outlier");
        String outlierDescription = config.getString("description", "");
        JsonArray scriptsConfig = config.getJsonArray("scripts", new JsonArray());
        
        logger.info("Processing outlier: {} with {} script configurations", outlierName, scriptsConfig.size());
        System.out.println("\n========================================");
        System.out.println("Processing Outlier: " + outlierName);
        System.out.println("Description: " + outlierDescription);
        System.out.println("Scripts in config: " + scriptsConfig.size());
        System.out.println("========================================");
        
        // Find README in this directory
        String readmeContent = null;
        for (File file : files) {
            if (file.isFile() && file.getName().toLowerCase().matches("readme\\.(txt|md)")) {
                try {
                    readmeContent = new String(Files.readAllBytes(file.toPath()));
                    logger.info("Found README: {}", file.getName());
                } catch (IOException e) {
                    logger.warn("Could not read README: {}", file.getName(), e);
                }
                break;
            }
        }
        
        // Process each script file
        for (File file : files) {
            if (file.isFile()) {
                String fileName = file.getName();
                String scriptType = determineScriptType(fileName);
                
                if (scriptType != null) {
                    // Check for duplicate script name
                    if (isDuplicateScript(fileName)) {
                        logger.warn("Skipping duplicate script: {}", fileName);
                        System.out.println("⚠ Skipping duplicate script: " + fileName);
                        result.addSkippedDuplicate(fileName);
                        continue;
                    }
                    
                    // Find configuration for this script
                    JsonObject scriptConfig = findScriptConfig(scriptsConfig, fileName);
                    
                    // Create script object
                    String scriptId = UUID.randomUUID().toString();
                    String relativePath = rootDir.toPath().relativize(file.toPath()).toString();
                    String folderPath = file.getParent();
                    
                    // Get related files in same folder
                    List<String> relatedFiles = new ArrayList<>();
                    for (File relatedFile : files) {
                        if (relatedFile.isFile() && !relatedFile.equals(file) && 
                            !relatedFile.getName().equals("outlier-config.json")) {
                            relatedFiles.add(relatedFile.getName());
                        }
                    }
                    
                    // Create script with configuration
                    OutlierScript script = new OutlierScript(
                        scriptId,
                        fileName,
                        scriptConfig != null ? scriptConfig.getString("description", "Extracted from ZIP: " + relativePath) 
                                             : "Extracted from ZIP: " + relativePath,
                        scriptType,
                        file.getAbsolutePath(),
                        fileName,
                        file.length(),
                        uploadedBy,
                        LocalDateTime.now(),
                        "",
                        scriptConfig != null ? scriptConfig.getBoolean("enabled", false) : false,
                        new ArrayList<>()
                    );
                    
                    // Set additional properties
                    script.setFolderPath(folderPath);
                    script.setReadmeContent(readmeContent);
                    script.setRelatedFiles(relatedFiles);
                    script.setPackageId(packageId);
                    script.setPackageName(packageName);
                    
                    // Add schedules from configuration
                    if (scriptConfig != null) {
                        JsonArray schedulesConfig = scriptConfig.getJsonArray("schedules", new JsonArray());
                        logger.info("Adding {} schedules for script: {}", schedulesConfig.size(), fileName);
                        System.out.println("  ✓ Script: " + fileName);
                        System.out.println("    Schedules: " + schedulesConfig.size());
                        
                        for (int i = 0; i < schedulesConfig.size(); i++) {
                            JsonObject scheduleConfig = schedulesConfig.getJsonObject(i);
                            
                            ScriptSchedule schedule = new ScriptSchedule(
                                UUID.randomUUID().toString(),
                                scheduleConfig.getString("cronExpression", "0 0 * * *"),
                                scheduleConfig.getString("parameters", ""),
                                scheduleConfig.getBoolean("enabled", true),
                                scheduleConfig.getString("description", "Schedule " + (i + 1))
                            );
                            
                            script.addSchedule(schedule);
                            System.out.println("      - " + schedule.getDescription() + 
                                             " (" + schedule.getCronExpression() + ") " +
                                             (schedule.isEnabled() ? "[ENABLED]" : "[DISABLED]"));
                        }
                    } else {
                        logger.warn("No configuration found for script: {}", fileName);
                        System.out.println("  ⚠ Script: " + fileName + " (no config found)");
                    }
                    
                    addScript(script);
                    result.addScript(script);
                    logger.info("Processed script: {} with {} schedules", fileName, script.getSchedules().size());
                    
                    // Auto-add to scheduler if enabled and has schedules
                    if (script.isEnabled() && !script.getEnabledSchedules().isEmpty()) {
                        logger.info("Auto-adding script to scheduler: {}", fileName);
                        System.out.println("    ⚡ Auto-adding to scheduler...");
                        boolean added = addToScheduler(script);
                        if (added) {
                            System.out.println("    ✓ Successfully added to scheduler");
                        } else {
                            System.out.println("    ✗ Failed to add to scheduler (check OS compatibility)");
                        }
                    }
                }
            } else if (file.isDirectory()) {
                // Recursively process subdirectories
                processDirectoryWithConfig(file, rootDir, result, folderContents, uploadedBy, config, packageId, packageName);
            }
        }
        
        System.out.println("========================================\n");
    }
    
    /**
     * Find script configuration in JSON array by script name
     */
    private JsonObject findScriptConfig(JsonArray scriptsConfig, String scriptName) {
        for (int i = 0; i < scriptsConfig.size(); i++) {
            JsonObject scriptConfig = scriptsConfig.getJsonObject(i);
            String configScriptName = scriptConfig.getString("scriptName", "");
            if (configScriptName.equals(scriptName)) {
                return scriptConfig;
            }
        }
        return null;
    }
    
    /**
     * Add script to system scheduler (cron or Task Scheduler)
     * Adds all enabled schedules for the script
     * Uses script type to determine scheduler: bash -> cron, windows -> Task Scheduler
     */
    public boolean addToScheduler(OutlierScript script) {
        logger.info("========================================");
        logger.info("ADD TO SCHEDULER CALLED");
        logger.info("Script: {} (ID: {})", script.getName(), script.getId());
        logger.info("Script Type: {}", script.getScriptType());
        logger.info("Script Enabled: {}", script.isEnabled());
        logger.info("Total Schedules: {}", script.getSchedules().size());
        System.out.println("\n========================================");
        System.out.println("ADD TO SCHEDULER: " + script.getName());
        System.out.println("Script Type: " + script.getScriptType());
        System.out.println("========================================");
        
        if (!script.isEnabled()) {
            logger.warn("Cannot add script to scheduler: script not enabled");
            System.out.println("✗ Script is not enabled");
            return false;
        }
        
        List<ScriptSchedule> enabledSchedules = script.getEnabledSchedules();
        logger.info("Enabled Schedules: {}", enabledSchedules.size());
        System.out.println("Enabled Schedules: " + enabledSchedules.size());
        
        if (enabledSchedules.isEmpty()) {
            logger.warn("Cannot add script to scheduler: no enabled schedules");
            System.out.println("✗ No enabled schedules found");
            return false;
        }
        
        // Determine scheduler based on script type, not OS
        String scriptType = script.getScriptType().toLowerCase();
        boolean useWindowsScheduler = scriptType.equals("windows");
        boolean useLinuxCron = scriptType.equals("bash");
        
        String os = System.getProperty("os.name").toLowerCase();
        logger.info("Operating System: {}", os);
        logger.info("Using scheduler: {}", useWindowsScheduler ? "Windows Task Scheduler" : "Linux Cron");
        System.out.println("Operating System: " + os);
        System.out.println("Target Scheduler: " + (useWindowsScheduler ? "Windows Task Scheduler" : "Linux Cron"));
        
        // Validate OS compatibility
        if (useWindowsScheduler && !os.contains("win")) {
            logger.warn("Cannot add Windows script to Task Scheduler on non-Windows OS");
            System.err.println("✗ Cannot schedule Windows script (.bat/.cmd/.ps1) on " + os);
            System.err.println("  This script requires Windows Task Scheduler");
            System.err.println("  Script is saved but schedules will not be added to system scheduler");
            System.out.println("========================================\n");
            return false;
        }
        
        if (useLinuxCron && os.contains("win")) {
            logger.warn("Cannot add bash script to cron on Windows OS");
            System.err.println("✗ Cannot schedule bash script (.sh) on Windows");
            System.err.println("  This script requires Linux/Unix cron");
            System.err.println("  Script is saved but schedules will not be added to system scheduler");
            System.out.println("========================================\n");
            return false;
        }
        
        boolean allSuccess = true;
        
        try {
            for (ScriptSchedule schedule : enabledSchedules) {
                logger.info("Processing schedule: {} - {}", schedule.getScheduleId(), schedule.getDescription());
                System.out.println("\nProcessing schedule: " + schedule.getScheduleId());
                System.out.println("  Description: " + schedule.getDescription());
                System.out.println("  Cron: " + schedule.getCronExpression());
                System.out.println("  Parameters: " + schedule.getParameters());
                
                boolean success;
                if (useWindowsScheduler) {
                    success = addToWindowsTaskScheduler(script, schedule);
                } else if (useLinuxCron) {
                    success = addToLinuxCron(script, schedule);
                } else {
                    logger.error("Unknown script type: {}", scriptType);
                    System.err.println("✗ Unknown script type: " + scriptType);
                    return false;
                }
                
                if (!success) {
                    allSuccess = false;
                    logger.warn("Failed to add schedule {} for script {}", schedule.getScheduleId(), script.getName());
                    System.err.println("✗ Failed to add schedule: " + schedule.getScheduleId());
                } else {
                    System.out.println("✓ Schedule added successfully");
                }
            }
            
            System.out.println("========================================\n");
            return allSuccess;
        } catch (Exception e) {
            logger.error("Failed to add script to scheduler: {}", script.getName(), e);
            System.err.println("✗ Exception: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Remove script from system scheduler
     * Removes all schedules for the script
     */
    public boolean removeFromScheduler(OutlierScript script) {
        String os = System.getProperty("os.name").toLowerCase();
        boolean allSuccess = true;
        
        try {
            // Remove all schedules (both enabled and disabled)
            for (ScriptSchedule schedule : script.getSchedules()) {
                boolean success;
                if (os.contains("win")) {
                    success = removeFromWindowsTaskScheduler(script, schedule);
                } else if (os.contains("nix") || os.contains("nux") || os.contains("mac")) {
                    success = removeFromLinuxCron(script, schedule);
                } else {
                    logger.error("Unsupported operating system: {}", os);
                    return false;
                }
                
                if (!success) {
                    allSuccess = false;
                    logger.warn("Failed to remove schedule {} for script {}", schedule.getScheduleId(), script.getName());
                }
            }
            return allSuccess;
        } catch (Exception e) {
            logger.error("Failed to remove script from scheduler: {}", script.getName(), e);
            return false;
        }
    }
    
    /**
     * Add script schedule to Linux crontab
     */
    private boolean addToLinuxCron(OutlierScript script, ScriptSchedule schedule) throws IOException, InterruptedException {
        logger.info("=== ADDING TO LINUX CRON ===");
        logger.info("Script: {} (ID: {})", script.getName(), script.getId());
        logger.info("Schedule ID: {}", schedule.getScheduleId());
        logger.info("Cron Expression: {}", schedule.getCronExpression());
        logger.info("Parameters: {}", schedule.getParameters());
        
        // Build the cron command
        String scriptPath = script.getFilePath();
        String parameters = schedule.getParameters() != null && !schedule.getParameters().isEmpty()
                          ? schedule.getParameters()
                          : "";
        String cronCommand = schedule.getCronExpression() + " " + scriptPath + " " + parameters;
        
        logger.info("Full cron command: {}", cronCommand);
        
        // Add comment to identify the script and schedule
        String scheduleDesc = schedule.getDescription() != null && !schedule.getDescription().isEmpty()
                            ? " - " + schedule.getDescription()
                            : "";
        String cronEntry = "# Outliers Script: " + script.getId() + " [" + schedule.getScheduleId() + "]" + scheduleDesc + "\n" + cronCommand;
        
        logger.info("Cron entry to add:\n{}", cronEntry);
        
        // Get current crontab
        logger.info("Reading current crontab...");
        ProcessBuilder getCurrentCron = new ProcessBuilder("crontab", "-l");
        Process getCurrentProcess = getCurrentCron.start();
        StringBuilder currentCron = new StringBuilder();
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(getCurrentProcess.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                currentCron.append(line).append("\n");
            }
        }
        int readExitCode = getCurrentProcess.waitFor();
        logger.info("Current crontab read exit code: {}", readExitCode);
        logger.info("Current crontab length: {} characters", currentCron.length());
        
        // Check if this specific schedule already exists in crontab
        String scheduleMarker = "# Outliers Script: " + script.getId() + " [" + schedule.getScheduleId() + "]";
        if (currentCron.toString().contains(scheduleMarker)) {
            logger.info("Schedule {} already exists in crontab for script: {}", schedule.getScheduleId(), script.getName());
            return true;
        }
        
        // Append new cron entry
        currentCron.append(cronEntry).append("\n");
        logger.info("Updated crontab length: {} characters", currentCron.length());
        
        // Write updated crontab
        logger.info("Writing updated crontab...");
        ProcessBuilder setNewCron = new ProcessBuilder("crontab", "-");
        Process setProcess = setNewCron.start();
        try (OutputStream os = setProcess.getOutputStream()) {
            os.write(currentCron.toString().getBytes());
            os.flush();
        }
        
        int exitCode = setProcess.waitFor();
        logger.info("Crontab write exit code: {}", exitCode);
        
        if (exitCode == 0) {
            logger.info("=== SUCCESS: Added schedule {} to crontab for script: {} ===", schedule.getScheduleId(), script.getName());
            System.out.println("✓ Successfully added schedule to crontab: " + script.getName() + " [" + schedule.getScheduleId() + "]");
            System.out.println("  Cron: " + schedule.getCronExpression());
            System.out.println("  Command: " + cronCommand);
            return true;
        } else {
            logger.error("=== FAILED: Could not add schedule to crontab, exit code: {} ===", exitCode);
            System.err.println("✗ Failed to add schedule to crontab: " + script.getName());
            return false;
        }
    }
    
    /**
     * Remove script schedule from Linux crontab
     */
    private boolean removeFromLinuxCron(OutlierScript script, ScriptSchedule schedule) throws IOException, InterruptedException {
        // Get current crontab
        ProcessBuilder getCurrentCron = new ProcessBuilder("crontab", "-l");
        Process getCurrentProcess = getCurrentCron.start();
        StringBuilder currentCron = new StringBuilder();
        
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(getCurrentProcess.getInputStream()))) {
            String line;
            boolean skipNext = false;
            String scheduleMarker = "# Outliers Script: " + script.getId() + " [" + schedule.getScheduleId() + "]";
            while ((line = reader.readLine()) != null) {
                if (line.contains(scheduleMarker)) {
                    skipNext = true; // Skip the comment line
                    continue;
                }
                if (skipNext) {
                    skipNext = false; // Skip the cron command line
                    continue;
                }
                currentCron.append(line).append("\n");
            }
        }
        getCurrentProcess.waitFor();
        
        // Write updated crontab
        ProcessBuilder setNewCron = new ProcessBuilder("crontab", "-");
        Process setProcess = setNewCron.start();
        try (OutputStream os = setProcess.getOutputStream()) {
            os.write(currentCron.toString().getBytes());
            os.flush();
        }
        
        int exitCode = setProcess.waitFor();
        if (exitCode == 0) {
            logger.info("Successfully removed schedule {} from crontab for script: {}", schedule.getScheduleId(), script.getName());
            return true;
        } else {
            logger.error("Failed to remove schedule from crontab, exit code: {}", exitCode);
            return false;
        }
    }
    
    /**
     * Add script schedule to Windows Task Scheduler
     */
    private boolean addToWindowsTaskScheduler(OutlierScript script, ScriptSchedule schedule) throws IOException, InterruptedException {
        logger.info("=== ADDING TO WINDOWS TASK SCHEDULER ===");
        logger.info("Script: {} (ID: {})", script.getName(), script.getId());
        logger.info("Schedule ID: {}", schedule.getScheduleId());
        logger.info("Cron Expression: {}", schedule.getCronExpression());
        logger.info("Parameters: {}", schedule.getParameters());
        
        String taskName = "OutliersScript_" + script.getId() + "_" + schedule.getScheduleId();
        String scriptPath = script.getFilePath();
        String parameters = schedule.getParameters() != null && !schedule.getParameters().isEmpty()
                          ? schedule.getParameters()
                          : "";
        
        logger.info("Task Name: {}", taskName);
        logger.info("Script Path: {}", scriptPath);
        
        // Convert cron expression to Task Scheduler schedule
        // This is a simplified conversion - you may need to enhance this
        String scheduleType = convertCronToTaskScheduler(schedule.getCronExpression());
        logger.info("Converted schedule type: {}", scheduleType);
        
        // Create the scheduled task using schtasks command
        List<String> command = new ArrayList<>();
        command.add("schtasks");
        command.add("/Create");
        command.add("/TN");
        command.add(taskName);
        command.add("/TR");
        command.add("\"" + scriptPath + " " + parameters + "\"");
        command.add("/SC");
        command.add(scheduleType);
        command.add("/F"); // Force create, overwrite if exists
        
        logger.info("Command: {}", String.join(" ", command));
        System.out.println("\nExecuting schtasks command:");
        System.out.println("  " + String.join(" ", command));
        
        ProcessBuilder pb = new ProcessBuilder(command);
        pb.redirectErrorStream(true); // Merge error stream with output
        Process process = pb.start();
        
        // Read output
        StringBuilder output = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
                System.out.println("  OUTPUT: " + line);
            }
        }
        
        int exitCode = process.waitFor();
        logger.info("schtasks exit code: {}", exitCode);
        logger.info("schtasks output:\n{}", output.toString());
        
        if (exitCode == 0) {
            logger.info("=== SUCCESS: Added schedule {} to Task Scheduler for script: {} ===", schedule.getScheduleId(), script.getName());
            System.out.println("✓ Successfully added schedule to Task Scheduler: " + script.getName() + " [" + schedule.getScheduleId() + "]");
            System.out.println("  Task Name: " + taskName);
            System.out.println("  Schedule: " + scheduleType);
            return true;
        } else {
            logger.error("=== FAILED: Could not add schedule to Task Scheduler, exit code: {} ===", exitCode);
            System.err.println("✗ Failed to add schedule to Task Scheduler: " + script.getName());
            System.err.println("  Exit code: " + exitCode);
            System.err.println("  Output: " + output.toString());
            return false;
        }
    }
    
    /**
     * Remove script schedule from Windows Task Scheduler
     */
    private boolean removeFromWindowsTaskScheduler(OutlierScript script, ScriptSchedule schedule) throws IOException, InterruptedException {
        String taskName = "OutliersScript_" + script.getId() + "_" + schedule.getScheduleId();
        
        ProcessBuilder pb = new ProcessBuilder("schtasks", "/Delete", "/TN", taskName, "/F");
        Process process = pb.start();
        
        int exitCode = process.waitFor();
        if (exitCode == 0) {
            logger.info("Successfully removed script from Task Scheduler: {}", script.getName());
            return true;
        } else {
            logger.error("Failed to remove script from Task Scheduler, exit code: {}", exitCode);
            return false;
        }
    }
    
    /**
     * Convert cron expression to Windows Task Scheduler format
     * This is a simplified conversion - enhance as needed
     */
    private String convertCronToTaskScheduler(String cronExpression) {
        // Basic conversion - you may want to enhance this
        // Cron format: minute hour day month day-of-week
        // For now, return DAILY as default - you can enhance this based on cron parsing
        return "DAILY";
    }
    
    /**
     * Get uploads directory path
     */
    public String getUploadsDirectory() {
        return uploadsDirectory;
    }
}
