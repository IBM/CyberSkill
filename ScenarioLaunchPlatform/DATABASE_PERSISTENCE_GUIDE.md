# Database Persistence Guide for Outliers and Attack Library

## Overview

This guide explains how to use the database persistence layer for Outliers scripts and Attack Library patterns.

## Database Setup

### 1. Run the SQL Script

Execute the database schema creation script:

```bash
psql -U postgres -d SLP -f database/ScenarioLaunchPlatform_CORE/outliers_and_library_tables.sql
```

This creates:
- `tb_outlier_scripts` - Main scripts table
- `tb_outlier_schedules` - Multiple schedules per script
- `tb_attack_patterns` - Attack pattern templates
- Views and triggers for easier querying

### 2. Verify Tables Created

```sql
\dt public.tb_outlier*
\dt public.tb_attack*
```

## Using OutliersDatabase Class

### Initialize the Database Connection

```java
import outliers.thejasonengine.com.OutliersDatabase;
import io.vertx.sqlclient.Pool;

// Get the database pool (from DatasourcePojo or your connection manager)
Pool dbPool = datasourcePojo.getPool();

// Create database instance
OutliersDatabase outliersDb = new OutliersDatabase(dbPool);
```

### Save a Script

```java
OutlierScript script = new OutlierScript(...);

// Add schedules
script.addSchedule(new ScriptSchedule("0 0 * * *", "--full", true, "Daily backup"));
script.addSchedule(new ScriptSchedule("*/15 * * * *", "--incremental", true, "Every 15 min"));

// Save to database (async)
outliersDb.saveScript(script).onComplete(ar -> {
    if (ar.succeeded()) {
        logger.info("Script saved to database");
    } else {
        logger.error("Failed to save script", ar.cause());
    }
});
```

### Load All Scripts

```java
outliersDb.loadAllScripts().onComplete(ar -> {
    if (ar.succeeded()) {
        List<OutlierScript> scripts = ar.result();
        logger.info("Loaded {} scripts from database", scripts.size());
        
        // Add to in-memory library
        scripts.forEach(script -> library.addScript(script));
    } else {
        logger.error("Failed to load scripts", ar.cause());
    }
});
```

### Delete a Script

```java
outliersDb.deleteScript(scriptId).onComplete(ar -> {
    if (ar.succeeded()) {
        logger.info("Script deleted from database");
    } else {
        logger.error("Failed to delete script", ar.cause());
    }
});
```

### Save Attack Pattern

```java
AttackPattern pattern = new AttackPattern(...);

outliersDb.saveAttackPattern(pattern).onComplete(ar -> {
    if (ar.succeeded()) {
        logger.info("Attack pattern saved to database");
    } else {
        logger.error("Failed to save pattern", ar.cause());
    }
});
```

### Load All Attack Patterns

```java
outliersDb.loadAllAttackPatterns().onComplete(ar -> {
    if (ar.succeeded()) {
        List<AttackPattern> patterns = ar.result();
        logger.info("Loaded {} patterns from database", patterns.size());
        
        // Add to in-memory library
        patterns.forEach(pattern -> attackLibrary.addPattern(pattern));
    } else {
        logger.error("Failed to load patterns", ar.cause());
    }
});
```

## Integration with OutliersLibrary

### Modify OutliersLibrary Constructor

```java
private OutliersLibrary() {
    this.uploadsDirectory = "outliers-uploads";
    initializeUploadsDirectory();
    
    // Initialize database connection
    DatasourcePojo datasource = new DatasourcePojo();
    Pool dbPool = datasource.DatasourcePojo("postgres", vertx);
    this.outliersDb = new OutliersDatabase(dbPool);
    
    // Load scripts from database on startup
    loadScriptsFromDatabase();
}

private void loadScriptsFromDatabase() {
    outliersDb.loadAllScripts().onComplete(ar -> {
        if (ar.succeeded()) {
            List<OutlierScript> scripts = ar.result();
            scripts.forEach(script -> {
                this.scripts.put(script.getId(), script);
                
                // Re-add to scheduler if enabled
                if (script.isEnabled()) {
                    addToScheduler(script);
                }
            });
            logger.info("Loaded {} scripts from database", scripts.size());
        } else {
            logger.error("Failed to load scripts from database", ar.cause());
        }
    });
}
```

### Update addScript Method

```java
public void addScript(OutlierScript script) {
    scripts.put(script.getId(), script);
    logger.info("Added script to library: {} ({})", script.getName(), script.getId());
    
    // Save to database
    if (outliersDb != null) {
        outliersDb.saveScript(script).onComplete(ar -> {
            if (ar.failed()) {
                logger.error("Failed to save script to database", ar.cause());
            }
        });
    }
}
```

### Update removeScript Method

```java
public boolean removeScript(String id) {
    OutlierScript script = scripts.remove(id);
    if (script != null) {
        // Delete from database
        if (outliersDb != null) {
            outliersDb.deleteScript(id).onComplete(ar -> {
                if (ar.failed()) {
                    logger.error("Failed to delete script from database", ar.cause());
                }
            });
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
```

### Update updateScript Method

```java
public void updateScript(String id, OutlierScript script) {
    scripts.put(id, script);
    logger.info("Updated script: {} ({})", script.getName(), id);
    
    // Save to database
    if (outliersDb != null) {
        outliersDb.saveScript(script).onComplete(ar -> {
            if (ar.failed()) {
                logger.error("Failed to update script in database", ar.cause());
            }
        });
    }
}
```

## Integration with AttackPatternLibrary

### Modify AttackPatternLibrary Constructor

```java
private AttackPatternLibrary() {
    // Initialize database connection
    DatasourcePojo datasource = new DatasourcePojo();
    Pool dbPool = datasource.DatasourcePojo("postgres", vertx);
    this.outliersDb = new OutliersDatabase(dbPool);
    
    // Load patterns from database first
    loadPatternsFromDatabase();
    
    // Then initialize hardcoded patterns (if not in database)
    initializePatterns();
}

private void loadPatternsFromDatabase() {
    outliersDb.loadAllAttackPatterns().onComplete(ar -> {
        if (ar.succeeded()) {
            List<AttackPattern> patterns = ar.result();
            patterns.forEach(pattern -> this.patterns.put(pattern.getId(), pattern));
            logger.info("Loaded {} attack patterns from database", patterns.size());
        } else {
            logger.error("Failed to load attack patterns from database", ar.cause());
        }
    });
}
```

## Database Queries

### Useful SQL Queries

**Get all enabled scripts:**
```sql
SELECT * FROM public.tb_outlier_scripts WHERE enabled = true;
```

**Get scripts with schedule count:**
```sql
SELECT * FROM public.v_outlier_scripts_with_schedules;
```

**Get attack patterns by severity:**
```sql
SELECT * FROM public.tb_attack_patterns 
WHERE severity = 'CRITICAL' 
ORDER BY category, name;
```

**Get patterns by category:**
```sql
SELECT * FROM public.v_attack_patterns_by_category;
```

**Find scripts by type:**
```sql
SELECT * FROM public.tb_outlier_scripts 
WHERE script_type = 'bash';
```

## Benefits of Database Persistence

✅ **Data Survives Restarts** - Scripts and patterns persist across application restarts
✅ **Scalability** - Can handle large numbers of scripts and patterns
✅ **Querying** - Easy to search, filter, and analyze data
✅ **Backup** - Standard database backup procedures apply
✅ **Multi-Instance** - Multiple application instances can share data
✅ **Audit Trail** - Created/updated timestamps for tracking
✅ **Relationships** - Proper foreign key relationships between scripts and schedules

## Troubleshooting

### Scripts Not Loading on Startup

Check logs for database connection errors:
```
Failed to load scripts from database
```

Verify database connection in `DatasourcePojo.java`.

### Schedules Not Saving

Check that the script is saved before schedules:
- Schedules are saved automatically when script is saved
- Foreign key constraint requires script to exist first

### JSON Parsing Errors

Ensure JSONB columns contain valid JSON:
```sql
SELECT id, name, related_files::text 
FROM public.tb_outlier_scripts 
WHERE related_files IS NOT NULL;
```

## Next Steps

1. Run the SQL script to create tables
2. Add database initialization to OutliersLibrary constructor
3. Update CRUD methods to persist to database
4. Test with a few scripts to verify persistence
5. Monitor logs for any database errors

---

**Note**: The database persistence layer is fully implemented and ready to use. You just need to integrate it into the OutliersLibrary and AttackPatternLibrary classes as shown above.