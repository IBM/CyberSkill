# Scenario Launch Platform (SLP) - Database Deployment Guide

## Overview

This guide provides complete instructions for deploying the Scenario Launch Platform database from scratch. The deployment includes all tables, stored procedures, triggers, views, and initial data required for the application to function.

---

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Deployment Steps](#detailed-deployment-steps)
4. [Database Schema Overview](#database-schema-overview)
5. [Post-Deployment Configuration](#post-deployment-configuration)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)
8. [Rollback Procedures](#rollback-procedures)

---

## Prerequisites

### Software Requirements
- **PostgreSQL**: Version 14 or higher
- **Operating System**: Linux, Windows, or macOS
- **Database Client**: psql, pgAdmin, DBeaver, or similar

### Access Requirements
- PostgreSQL superuser access OR
- User with the following privileges:
  - CREATE DATABASE
  - CREATE TABLE
  - CREATE FUNCTION
  - CREATE TRIGGER
  - CREATE VIEW
  - INSERT, UPDATE, DELETE, SELECT

### Network Requirements
- Access to PostgreSQL server (default port: 5432)
- Sufficient disk space (minimum 500MB recommended)

---

## Quick Start

For experienced users who want to deploy immediately:

```bash
# 1. Create database
createdb slp

# 2. Execute master deployment script
psql -d slp -f MASTER_DEPLOYMENT.sql

# 3. Verify deployment
psql -d slp -c "SELECT * FROM public.tb_version;"
```

**Default Credentials:**
- Username: `admin`
- Password: `admin`

⚠️ **IMPORTANT**: Change the default password immediately after deployment!

---

## Detailed Deployment Steps

### Step 1: Create the Database

#### Option A: Using psql Command Line
```bash
createdb slp
```

#### Option B: Using SQL
```sql
CREATE DATABASE slp
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
```

#### Option C: Using pgAdmin
1. Right-click on "Databases"
2. Select "Create" → "Database..."
3. Enter database name: `slp`
4. Click "Save"

### Step 2: Connect to the Database

```bash
psql -d slp
```

Or specify host and user:
```bash
psql -h localhost -U postgres -d slp
```

### Step 3: Execute the Master Deployment Script

#### Option A: From psql prompt
```sql
\i /path/to/MASTER_DEPLOYMENT.sql
```

#### Option B: From command line
```bash
psql -d slp -f /path/to/MASTER_DEPLOYMENT.sql
```

#### Option C: Using pgAdmin
1. Open Query Tool
2. Open file: `MASTER_DEPLOYMENT.sql`
3. Click "Execute" (F5)

### Step 4: Monitor Deployment Progress

The script provides detailed progress messages:
- ✓ Section completion confirmations
- Table creation notices
- Data insertion counts
- Final deployment summary

Expected output:
```
NOTICE: ============================================================================================================
NOTICE: SCENARIO LAUNCH PLATFORM - MASTER DEPLOYMENT
NOTICE: ============================================================================================================
NOTICE: Starting deployment at: 2026-03-12 17:30:00
...
NOTICE: ✓ DEPLOYMENT SUCCESSFUL!
```

---

## Database Schema Overview

### Core Tables (11 tables)

| Table Name | Purpose | Key Features |
|------------|---------|--------------|
| `tb_version` | Application version tracking | Single row with version string |
| `tb_user` | User accounts and authentication | SHA-256 password hashing |
| `tb_myvars` | User-specific variables | JSONB storage for flexibility |
| `tb_stories` | Story execution history | JSONB for execution results |
| `tb_schedule` | Scheduled query executions | Cron-based scheduling |
| `tb_tasks` | OS-level scheduled tasks | Binary file storage |
| `tb_content_packs` | Content pack metadata | 23 pre-loaded packs |
| `tb_databaseconnections` | Database connection configs | Multi-database support |
| `tb_admin_functions` | Administrative functions | System management |
| `tb_query` | Prepared SQL queries | Story building blocks |
| `tb_query_types` | Query categorization | 18 predefined types |

### Outliers & Attack Library Tables (3 tables)

| Table Name | Purpose | Records |
|------------|---------|---------|
| `tb_outlier_scripts` | Outlier script metadata | User-uploaded scripts |
| `tb_outlier_schedules` | Script scheduling | Multiple schedules per script |
| `tb_attack_patterns` | Attack pattern library | 1 sample pattern (expandable to 23+) |

### Database Objects Summary

- **Tables**: 14 core tables
- **Functions**: 2 stored procedures
- **Triggers**: 3 update triggers
- **Views**: 2 analytical views
- **Indexes**: 6 performance indexes

---

## Post-Deployment Configuration

### 1. Change Default Admin Password

**CRITICAL SECURITY STEP** - Change immediately!

```sql
-- Generate new SHA-256 hash for your password
-- Use online tool or command: echo -n "YourNewPassword" | sha256sum

UPDATE public.tb_user 
SET password = 'YOUR_SHA256_HASH_HERE'
WHERE username = 'admin';
```

### 2. Configure Database Connections

Add your target database connections:

```sql
INSERT INTO public.tb_databaseconnections (
    db_connection_id, status, db_type, db_version, 
    db_username, db_password, db_port, db_database, 
    db_url, db_jdbcClassName, db_alias, db_access
) VALUES (
    'mysql_192.168.1.100_crm_user1',
    'active',
    'mysql',
    '8.0',
    'user1',
    'Password123!',
    '3306',
    'crm',
    '192.168.1.100',
    'com.mysql.cj.jdbc.Driver',
    'Production MySQL',
    'Select,Update,Insert,Delete'
);
```

### 3. Load Additional Attack Patterns (Optional)

The deployment includes 1 sample attack pattern. To load all 23 patterns:

```bash
psql -d slp -f database/ScenarioLaunchPlatform_CORE/all_23_attack_patterns.sql
```

### 4. Configure Admin Functions

Update the admin function path for your environment:

```sql
UPDATE public.tb_admin_functions
SET function_file_path = '/your/slp/installation/path/scripts'
WHERE id = 1;
```

---

## Verification

### 1. Check Version

```sql
SELECT * FROM public.tb_version;
```
Expected: `v01.0012`

### 2. Verify Table Count

```sql
SELECT COUNT(*) as table_count 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_type = 'BASE TABLE';
```
Expected: `14 tables`

### 3. Check Initial Data

```sql
-- Users
SELECT COUNT(*) as user_count FROM public.tb_user;
-- Expected: 1 (admin user)

-- Content Packs
SELECT COUNT(*) as pack_count FROM public.tb_content_packs;
-- Expected: 23 packs

-- Query Types
SELECT COUNT(*) as type_count FROM public.tb_query_types;
-- Expected: 18 types

-- Attack Patterns
SELECT COUNT(*) as pattern_count FROM public.tb_attack_patterns;
-- Expected: 1 pattern (or 23 if you loaded all patterns)
```

### 4. Test Login Function

```sql
SELECT * FROM function_login('admin', 'aca1a1c6a87b983c3346f44ba66936000a462f99ac5201c4c5f958046e61a79b');
```
Should return admin user details.

### 5. Verify Views

```sql
-- Check views exist
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public';
```
Expected: `v_outlier_scripts_with_schedules`, `v_attack_patterns_by_category`

---

## Troubleshooting

### Issue: "database already exists"

**Solution**: Drop and recreate
```sql
DROP DATABASE IF EXISTS slp;
CREATE DATABASE slp;
```

### Issue: "permission denied"

**Solution**: Grant necessary privileges
```sql
GRANT ALL PRIVILEGES ON DATABASE slp TO your_user;
```

### Issue: "relation already exists"

**Solution**: The script includes DROP statements. If issues persist:
```sql
-- Connect to slp database
\c slp

-- Drop all tables
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Re-run deployment script
\i MASTER_DEPLOYMENT.sql
```

### Issue: Script execution stops with errors

**Solution**: Check PostgreSQL version
```sql
SELECT version();
```
Ensure PostgreSQL 14+ is installed.

### Issue: Character encoding errors

**Solution**: Set client encoding
```sql
SET client_encoding = 'UTF8';
```

---

## Rollback Procedures

### Complete Rollback (Delete Everything)

```sql
-- Drop the entire database
DROP DATABASE IF EXISTS slp;
```

### Partial Rollback (Keep Database, Remove Objects)

```sql
-- Connect to database
\c slp

-- Drop all objects
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```

### Backup Before Deployment

**Recommended**: Always backup before deployment

```bash
# Create backup
pg_dump slp > slp_backup_$(date +%Y%m%d_%H%M%S).sql

# Restore if needed
psql slp < slp_backup_YYYYMMDD_HHMMSS.sql
```

---

## Additional Resources

### Related Files
- `MASTER_DEPLOYMENT.sql` - Main deployment script
- `tables.sql` - Core table definitions
- `gdp_lab_tables.sql` - GDP Lab specific tables
- `all_23_attack_patterns.sql` - Complete attack pattern library
- `gdp_lab_inserts.sql` - Sample database connections

### Documentation
- `readme.md` - Project overview
- `OUTLIERS_GUIDE.md` - Outliers feature documentation
- `OUTLIERS_SCHEDULER_GUIDE.md` - Scheduler configuration
- `METRICS_GUIDE.md` - Performance metrics

### Support
For issues or questions:
1. Check application logs: `target/application-YYYYMMDD.log`
2. Review PostgreSQL logs
3. Consult project documentation
4. Contact development team

---

## Deployment Checklist

- [ ] PostgreSQL 14+ installed and running
- [ ] Database `slp` created
- [ ] `MASTER_DEPLOYMENT.sql` executed successfully
- [ ] Deployment summary shows "DEPLOYMENT SUCCESSFUL"
- [ ] Version verified: `v01.0012`
- [ ] Table count verified: 14 tables
- [ ] Default admin password changed
- [ ] Database connections configured
- [ ] Login function tested
- [ ] Application started and connected to database
- [ ] First story executed successfully

---

## Security Recommendations

1. **Change default password immediately**
2. **Use strong passwords** (minimum 12 characters, mixed case, numbers, symbols)
3. **Restrict database access** to application server only
4. **Enable SSL/TLS** for database connections
5. **Regular backups** (daily recommended)
6. **Monitor audit logs** for suspicious activity
7. **Keep PostgreSQL updated** with security patches
8. **Use least privilege principle** for database users
9. **Encrypt sensitive data** at rest and in transit
10. **Regular security audits** of database permissions

---

## Performance Tuning

### Recommended PostgreSQL Settings

```sql
-- Increase shared buffers (25% of RAM)
ALTER SYSTEM SET shared_buffers = '2GB';

-- Increase work memory
ALTER SYSTEM SET work_mem = '64MB';

-- Increase maintenance work memory
ALTER SYSTEM SET maintenance_work_mem = '512MB';

-- Enable query planning statistics
ALTER SYSTEM SET track_activities = on;
ALTER SYSTEM SET track_counts = on;

-- Reload configuration
SELECT pg_reload_conf();
```

### Index Maintenance

```sql
-- Analyze tables for query optimization
ANALYZE;

-- Reindex if needed
REINDEX DATABASE slp;
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| v01.0012 | 2026-03-12 | Master deployment script created |
| v01.0011 | 2026-02-23 | PostgreSQL outlier packs added |
| v01.0010 | 2026-02-11 | MySQL outlier packs added |
| v01.0009 | 2026-01-15 | Attack library tables added |
| v01.0008 | 2025-12-01 | Outlier scripts tables added |

---

**Document Version**: 1.0  
**Last Updated**: 2026-03-12  
**Authors**: John Clarke

---

*End of Deployment Guide*