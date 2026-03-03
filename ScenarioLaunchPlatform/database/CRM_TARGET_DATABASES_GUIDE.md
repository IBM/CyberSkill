# CRM Target Database Schemas for Attack Library

## Overview

The Attack Library executes attack patterns against **CRM databases** on target systems. These are separate from the SLP system database.

## Available CRM Database Schemas

### Location
All CRM database schemas are located in: `database/`

### Database Types

#### 1. MySQL CRM Database
**File**: `database/MySQL/0001_crm_mysql.sql`

**Tables**:
- `tbl_crm_accounts_status` - Account status lookup
- `tbl_crm_accounts` - Customer account information
- `tbl_calls` - Call logs and activities
- `tbl_email_lists` - Email addresses for marketing
- `tbl_marketing_template` - Email templates
- `tbl_marketing_campaign` - Marketing campaigns
- `tbl_bugs` - Bug tracking
- `tbl_product` - Product catalog

**Setup**:
```bash
mysql -u root -p
CREATE DATABASE crm;
USE crm;
SOURCE database/MySQL/0001_crm_mysql.sql;
```

**Users File**: `database/MySQL/users.sql` - Creates test users (polly, john, jason, liher)

---

#### 2. PostgreSQL CRM Database
**File**: `database/Postgresql/0001_crm_postgres.sql`

**Tables**: Same structure as MySQL but with PostgreSQL syntax
- `tbl_crm_accounts_status`
- `tbl_crm_accounts`
- `tbl_calls`
- `tbl_email_lists`
- `tbl_marketing_template`
- `tbl_marketing_campaign`
- `tbl_bugs`
- `tbl_product`

**Setup**:
```bash
psql -U postgres
CREATE DATABASE crm;
\c crm
\i database/Postgresql/0001_crm_postgres.sql
```

**Audit Extension**: `database/Postgresql/0002_crm_postgres_audit.sql` - Adds audit logging

---

#### 3. DB2 CRM Database
**Files**:
- `database/DB2/0001_crm_db2.sql` - Full schema with referential integrity
- `database/DB2/0002_crm_db2_no_ref_integrity.sql` - Schema without foreign keys

**Tables**: Same CRM structure adapted for DB2 syntax

**Setup**:
```bash
db2 CREATE DATABASE crm
db2 CONNECT TO crm
db2 -tvf database/DB2/0001_crm_db2.sql
```

---

#### 4. SQL Server CRM Database
**File**: `database/sqlserver/FullSQL.sql`

**Individual Component Files**:
- `tables.sql` - Table definitions
- `indexes.sql` - Index definitions
- `views.sql` - View definitions
- `procedures.sql` - Stored procedures
- `triggers.sql` - Trigger definitions
- `synonyms.sql` - Synonym definitions
- `inserts.sql` - Sample data
- `bulkinsert.sql` - Bulk data loading

**Setup**:
```sql
CREATE DATABASE crm;
GO
USE crm;
GO
-- Run FullSQL.sql or individual component files
```

---

## How Attack Library Uses These Databases

### Architecture

```
┌─────────────────────────────────────┐
│  SLP System (localhost:5432/slp)   │
│  - tb_attack_patterns (stores      │
│    attack templates)                │
│  - tb_databaseconnections (stores  │
│    target connections)              │
└─────────────────────────────────────┘
              ↓
         Executes attacks against
              ↓
┌─────────────────────────────────────┐
│  Target CRM Databases               │
│  - MySQL:      192.168.100.13:3306 │
│  - PostgreSQL: 192.168.100.12:5432 │
│  - DB2:        192.168.100.14:50000│
│  - SQL Server: 192.168.100.15:1433 │
└─────────────────────────────────────┘
```

### Example Attack Flow

1. **User selects** "Union-Based SQL Injection" from Attack Library
2. **User chooses** target: `mysql_192.168.100.13_crm_polly`
3. **Attack executes** against: `mysql://192.168.100.13:3306/crm`
4. **Query runs**: 
   ```sql
   SELECT * FROM crm.tbl_crm_accounts 
   WHERE account_id = 1 
   UNION SELECT username, password, email, phone, NULL, NULL, NULL, NULL 
   FROM crm.tbl_users
   ```
5. **Results** displayed in SLP UI
6. **Guardium** should detect and alert on the attack

---

## Common CRM Tables Targeted by Attacks

### High-Value Targets

**Actual CRM Tables** (no tbl_users exists):

| Table | Contains | Attack Types |
|-------|----------|--------------|
| `tbl_crm_accounts` | Customer data, revenue, contact info | Data exfiltration, SQL injection |
| `tbl_email_lists` | Email addresses, opt-out status | Data leakage, PII theft |
| `tbl_product` | Product catalog, pricing | Data tampering, competitive intelligence |
| `tbl_bugs` | Bug reports, vulnerabilities | Information disclosure |
| `tbl_calls` | Call logs, customer interactions | Privacy violations |
| `tbl_marketing_template` | Email templates | Template injection |
| `tbl_marketing_campaign` | Campaign data | Marketing intelligence |
| `tbl_crm_accounts_status` | Status lookup values | Reference data |

---

## Setting Up Test Environment

### Quick Setup for All Databases

1. **Install databases** on target systems or Docker containers

2. **Create CRM databases**:
   ```bash
   # MySQL
   mysql -u root -p < database/MySQL/0001_crm_mysql.sql
   
   # PostgreSQL
   psql -U postgres -f database/Postgresql/0001_crm_postgres.sql
   
   # DB2
   db2 -tvf database/DB2/0001_crm_db2.sql
   
   # SQL Server
   sqlcmd -S localhost -i database/sqlserver/FullSQL.sql
   ```

3. **Create test users** (MySQL example):
   ```bash
   mysql -u root -p < database/MySQL/users.sql
   ```

4. **Configure connections** in SLP:
   - Navigate to Databases in SLP UI
   - Add connection for each target database
   - Test connection
   - Save

5. **Run attacks** from Attack Library

---

## Database Differences

### Key Syntax Differences

| Feature | MySQL | PostgreSQL | DB2 | SQL Server |
|---------|-------|------------|-----|------------|
| Auto Increment | `AUTO_INCREMENT` | `SERIAL` | `GENERATED` | `IDENTITY` |
| Boolean | `TINYINT(1)` | `BOOLEAN` | `SMALLINT` | `BIT` |
| Text | `TEXT` | `TEXT` | `CLOB` | `VARCHAR(MAX)` |
| UUID | `CHAR(36)` | `UUID` | `CHAR(36)` | `UNIQUEIDENTIFIER` |
| Timestamp | `DATETIME` | `TIMESTAMP` | `TIMESTAMP` | `DATETIME2` |

### Why Multiple Versions?

Attack patterns must adapt to different database syntaxes. The same logical attack requires different SQL for each database type.

**Example - Get first 10 records**:
- MySQL: `SELECT * FROM tbl_crm_accounts LIMIT 10`
- PostgreSQL: `SELECT * FROM tbl_crm_accounts LIMIT 10`
- Oracle: `SELECT * FROM tbl_crm_accounts WHERE ROWNUM <= 10`
- DB2: `SELECT * FROM tbl_crm_accounts FETCH FIRST 10 ROWS ONLY`
- SQL Server: `SELECT TOP 10 * FROM tbl_crm_accounts`

---

## Summary

- **SLP Database** (`localhost:5432/slp`) = Stores attack patterns and configuration
- **CRM Databases** (various hosts) = Target databases where attacks execute
- **Schema Files** = Located in `database/` folder for each database type
- **Attack Library** = Bridges the two by executing stored patterns against target CRM databases

All CRM schema files are already available in the `database/` folder - no additional SQL files needed!