# Database Setup Guide for Scenario Launch Platform

## Overview

The Scenario Launch Platform (SLP) uses PostgreSQL as its system database to persist:
- **Attack Library patterns** - Pre-built attack templates
- **Outlier scripts** - Scheduled security test scripts
- **User data, stories, queries, and database connections**

**Important**: The Attack Library stores attack patterns in PostgreSQL but executes them against your configured MySQL/PostgreSQL/DB2 target databases.

## Problem: Connection Refused Error

If you see this error in the logs:
```
ERROR outliers.thejasonengine.com.OutliersDatabase - Failed to load scripts from database
io.netty.channel.AbstractChannel$AnnotatedConnectException: Connection refused: localhost/127.0.0.1:5432
```

This means the application cannot connect to PostgreSQL to load attack patterns and outlier scripts.

## Solution

### Quick Fix (Already Done!)

Run the initialization script:
```powershell
.\initialize_database.ps1
```

This script will:
1. Check if the `slp` database exists (creates it if needed)
2. Create all required tables including:
   - `tb_attack_patterns` - Attack Library patterns
   - `tb_outlier_scripts` - Outlier scripts
   - `tb_outlier_schedules` - Script schedules
   - All other system tables
3. Verify the setup

### Manual Setup (Alternative)

If you prefer to set up manually:

1. **Create the database:**
   ```sql
   psql -U postgres
   CREATE DATABASE slp;
   \q
   ```

2. **Run the schema script:**
   ```powershell
   psql -U postgres -d slp -f database\ScenarioLaunchPlatform_CORE\gdp_lab_tables.sql
   ```

3. **Verify tables exist:**
   ```sql
   psql -U postgres -d slp
   \dt public.tb_*
   ```

## Configuration

The database connection is configured in `config.json`:

```json
{
    "systemDatabaseController": {
        "host": "localhost",
        "port": 5432,
        "database": "slp",
        "user": "postgres",
        "password": "postgres",
        "maxConnections": 10
    }
}
```

**Update these values if your PostgreSQL setup is different.**

## How It Works

### Attack Library Flow

1. **Storage**: Attack patterns are stored in the SLP PostgreSQL database (`tb_attack_patterns`)
2. **Execution**: When you run an attack pattern:
   - The pattern is loaded from the SLP PostgreSQL database
   - You select a target database connection (MySQL, PostgreSQL, Oracle, DB2, SQL Server)
   - The attack queries are executed against the **`crm` database** on your selected target
   - Queries are automatically adapted for the target database type (syntax varies between MySQL, PostgreSQL, Oracle, DB2)
   - Results are displayed in the UI

**Example**: If you select a MySQL connection, the attack runs against `mysql://target-host:3306/crm`. If you select PostgreSQL, it runs against `postgresql://target-host:5432/crm`.

### Outliers Flow

1. **Storage**: Outlier scripts are stored in the SLP PostgreSQL database (`tb_outlier_scripts`)
2. **Scheduling**: Schedules are stored in `tb_outlier_schedules`
3. **Execution**: Scripts run on schedule against the `crm` database on target systems
   - Scripts are database-specific (MySQL scripts for MySQL targets, PostgreSQL scripts for PostgreSQL targets, etc.)
   - Each outlier pack is designed for a specific database type

## Fallback Mode

If PostgreSQL is unavailable, the application will:
- Log a warning: `Continuing with in-memory storage only`
- Use in-memory storage for the session
- **Attack patterns will still work** but won't persist between restarts
- You'll need to re-upload outlier scripts after each restart

## Troubleshooting

### PostgreSQL Not Running

**Check service status:**
```powershell
Get-Service -Name postgresql*
```

**Start PostgreSQL:**
```powershell
Start-Service postgresql-x64-[version]
```

### Wrong Port or Host

Update `config.json` with your PostgreSQL connection details.

### Permission Issues

Ensure the PostgreSQL user has permissions:
```sql
GRANT ALL PRIVILEGES ON DATABASE slp TO postgres;
```

### Database Already Exists But Tables Missing

Re-run the initialization script - it will drop and recreate all tables:
```powershell
.\initialize_database.ps1
```

## Verification

After setup, verify the connection:

1. **Check tables exist:**
   ```powershell
   psql -U postgres -d slp -c "\dt public.tb_*"
   ```

2. **Start the application:**
   ```powershell
   .\restartSLP.bat
   ```

3. **Check logs** - You should see:
   ```
   INFO outliers.thejasonengine.com.OutliersLibrary - Database initialization complete
   INFO cluster.thejasonengine.com.ClusteredVerticle - Outliers database initialized successfully
   ```

4. **Test Attack Library:**
   - Navigate to Attack Library in the UI
   - You should see the pre-loaded attack patterns
   - Select a target database connection
   - Run an attack pattern

## Key Tables

| Table | Purpose |
|-------|---------|
| `tb_attack_patterns` | Attack Library templates |
| `tb_outlier_scripts` | Uploaded outlier scripts |
| `tb_outlier_schedules` | Script execution schedules |
| `tb_databaseconnections` | Target database connections |
| `tb_query` | Saved queries |
| `tb_stories` | Story execution history |
| `tb_user` | User accounts |

## Summary

- **SLP PostgreSQL Database** (`localhost:5432/slp`) = System database for storing attack patterns, outlier scripts, and SLP metadata
- **Target CRM Databases** = The `crm` database on your target systems (MySQL, PostgreSQL, Oracle, DB2, SQL Server)
- **Attack Library** = Patterns stored in SLP PostgreSQL, executed against target `crm` databases
- **Database-Specific Queries** = Attack queries automatically adapt to target database type (MySQL vs PostgreSQL vs Oracle syntax)
- **Initialization script** = `initialize_database.ps1` (run once to set up SLP database)
- **Fallback mode** = Works without SLP PostgreSQL but attack patterns don't persist between restarts

## Next Steps

After database setup:
1. Start the application: `.\restartSLP.bat`
2. Login with default credentials (admin/admin)
3. Configure target database connections
4. Use Attack Library to run security tests
5. Upload and schedule outlier scripts

For more information, see:
- `ATTACK_LIBRARY_GUIDE.md` - Attack Library usage
- `OUTLIERS_GUIDE.md` - Outlier scripts guide
- `readme.md` - General application documentation