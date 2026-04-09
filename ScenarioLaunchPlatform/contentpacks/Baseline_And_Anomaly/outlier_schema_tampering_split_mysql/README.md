# MySQL Split ALTER Commands Outlier Test (Baseline + Anomaly)

## Overview
This folder contains a script generator that creates **separate baseline and anomaly scripts** for MySQL outlier detection testing. The scripts simulate normal ALTER TABLE behavior followed by a sudden spike in ALTER operations, which could indicate schema tampering or unauthorized DDL activity.

## Key Features
- **Split Architecture**: Separate scripts for baseline (Hours 1-4) and anomaly (Hour 5)
- **Always Background**: Both generated scripts always run in background automatically
- **Unique Identifiers**: Each generation creates scripts with matching timestamps
- **Same User & Database**: Both baseline and anomaly scripts use the same database and user
- **Easy Tracking**: Script names include timestamps to identify which baseline matches which anomaly

## Purpose
- Test detection of time-based ALTER operation anomalies
- Simulate normal baseline: 50 alters/hour for 4 hours
- Create anomaly spike: 1000 alters in the 5th hour
- Generate realistic outlier patterns for security monitoring
- Test anomaly detection systems with temporal patterns
- Detect potential schema tampering or unauthorized DDL operations

## Files

### 1. generate_scripts.sh (Main Script)
The parent script that generates both baseline and anomaly scripts with matching identifiers.

**What it does:**
- Generates unique timestamp-based identifier
- Creates unique database and user names
- Generates two scripts:
  - `baseline_YYYYMMDD_HHMMSS.sh` - Hours 1-4 (200 alters)
  - `anomaly_YYYYMMDD_HHMMSS.sh` - Hour 5 (1000 alters)
- Both scripts share the same database and user credentials
- Makes scripts executable automatically

### 2. Generated Baseline Script
**Pattern:**
- Hour 1: 50 ALTER commands → Sleep 1 hour
- Hour 2: 50 ALTER commands → Sleep 1 hour
- Hour 3: 50 ALTER commands → Sleep 1 hour
- Hour 4: 50 ALTER commands → Complete
- **Total: 200 ALTER operations over 4 hours**

**What it does:**
- Creates unique database and user
- Creates 100 base tables for ALTER operations
- Executes varied ALTER commands (ADD COLUMN operations)
- Logs all operations with timestamps
- Can run in foreground or background mode

### 3. Generated Anomaly Script
**Pattern:**
- Hour 5: 1000 ALTER commands (SPIKE!) → Complete
- **Total: 1000 ALTER operations in 1 hour**

**What it does:**
- Uses the same database and user created by baseline script
- Executes 1000 ALTER commands (20x normal rate)
- Simulates schema tampering spike
- Logs all operations with timestamps
- Can run in foreground or background mode

## Prerequisites
- MySQL Server 5.7 or higher
- MySQL client installed
- **Root access** (required for creating database and user)
- Sufficient server resources
- Time: ~4 hours for baseline + time for anomaly

## Usage

### Step 1: Generate Scripts
```bash
chmod +x generate_scripts.sh
./generate_scripts.sh <host> <port> <root_password>
```

**Example:**
```bash
./generate_scripts.sh localhost 3306 MyRootPassword123
```

**Output:**
```
============================================================================
Generating Baseline and Anomaly Scripts
============================================================================
Unique ID: alter_20231230_120000
Database: alter_20231230_120000_db
User: alter_20231230_120000_user
Baseline Script: baseline_20231230_120000.sh
Anomaly Script: anomaly_20231230_120000.sh
============================================================================

✓ Scripts generated successfully!
```

### Step 2: Run Baseline Script (Hours 1-4)
```bash
# Always runs in background automatically
./baseline_20231230_120000.sh
```

**Monitor Background Execution:**
```bash
# View real-time logs
tail -f logs/baseline_alter_20231230_120000_background.log

# Check if still running
ps aux | grep baseline_alter_20231230_120000_runner.sh

# Stop background execution
pkill -f baseline_alter_20231230_120000_runner.sh
```

### Step 3: Run Anomaly Script (Hour 5)
**After baseline completes**, run the anomaly script:

```bash
# Always runs in background automatically
./anomaly_20231230_120000.sh
```

**Monitor Background Execution:**
```bash
# View real-time logs
tail -f logs/anomaly_alter_20231230_120000_background.log

# Check if still running
ps aux | grep anomaly_alter_20231230_120000_runner.sh

# Stop background execution
pkill -f anomaly_alter_20231230_120000_runner.sh
```

## Script Naming Convention

All generated scripts follow this pattern:
- **Baseline Script**: `baseline_YYYYMMDD_HHMMSS.sh`
- **Anomaly Script**: `anomaly_YYYYMMDD_HHMMSS.sh`
- **Database**: `alter_YYYYMMDD_HHMMSS_db`
- **User**: `alter_YYYYMMDD_HHMMSS_user`

The timestamp ensures:
- Unique identification of each test run
- Easy matching of baseline with its corresponding anomaly
- No conflicts between multiple test runs

## What Gets Created and Altered

### Database and User
- **Database Name**: `alter_YYYYMMDD_HHMMSS_db` (unique per generation)
- **User Name**: `alter_YYYYMMDD_HHMMSS_user` (unique per generation)
- **Created by**: Baseline script
- **Used by**: Both baseline and anomaly scripts
- User has full privileges on the database

### Base Tables (100 total)
- **Table Names**: `alter_test_table_1` through `alter_test_table_100`
- **Initial Structure**:
  - `id` (INT, AUTO_INCREMENT, PRIMARY KEY)
  - `data` (VARCHAR(100))
  - `created_at` (TIMESTAMP)

### ALTER Operations Pattern

**Hours 1-4 (Normal Baseline):**
- 50 ALTER operations per hour
- Adds columns named: `col_h{hour}_{number}`
- Example: `col_h1_1`, `col_h1_2`, ..., `col_h4_50`
- Cycles through all 100 tables
- Each ALTER adds a VARCHAR(50) column

**Hour 5 (SPIKE - Anomaly):**
- 1000 ALTER operations in one hour
- Adds columns named: `col_spike_{number}`
- Example: `col_spike_1`, `col_spike_2`, ..., `col_spike_1000`
- Cycles through all 100 tables
- Each ALTER adds a VARCHAR(50) column

### Total Operations
- 200 normal ALTER commands (hours 1-4)
- 1000 spike ALTER commands (hour 5)
- **Total: 1200 ALTER operations**

## Execution Timeline

```
BASELINE SCRIPT (4 hours):
Hour 1:  50 alters  → Sleep 1 hour
Hour 2:  50 alters  → Sleep 1 hour
Hour 3:  50 alters  → Sleep 1 hour
Hour 4:  50 alters  → Complete (200 total)

ANOMALY SCRIPT (immediate):
Hour 5:  1000 alters (SPIKE!) → Complete

TOTAL: 1200 ALTER operations
```

## Logs

The scripts create detailed logs in the `logs/` directory:

### Log Files
- `baseline_alter_YYYYMMDD_HHMMSS.log` - Baseline execution log
- `baseline_alter_YYYYMMDD_HHMMSS_background.log` - Baseline background mode log
- `baseline_alter_YYYYMMDD_HHMMSS_hour_N.log` - Individual hour logs (1-4)
- `anomaly_alter_YYYYMMDD_HHMMSS.log` - Anomaly execution log
- `anomaly_alter_YYYYMMDD_HHMMSS_background.log` - Anomaly background mode log
- `anomaly_alter_YYYYMMDD_HHMMSS_hour_5.log` - Hour 5 detailed log
- `baseline_alter_YYYYMMDD_HHMMSS_pid.txt` - Baseline process ID
- `anomaly_alter_YYYYMMDD_HHMMSS_pid.txt` - Anomaly process ID

### Log Contents
Each log includes:
- Timestamp for each operation
- Connection status
- Number of alters executed
- Success/failure status
- Total duration and summary

## Verification

After execution, check the results:

```sql
-- Use the database created by your scripts
USE alter_20231230_120000_db;  -- Replace with your actual database name

-- Count columns per table
SELECT table_name, COUNT(*) as column_count
FROM information_schema.columns
WHERE table_schema = 'alter_20231230_120000_db'
AND table_name LIKE 'alter_test_table_%'
GROUP BY table_name
ORDER BY table_name;

-- Count total columns added
SELECT
    COUNT(DISTINCT table_name) as tables_altered,
    COUNT(*) as total_columns
FROM information_schema.columns
WHERE table_schema = 'alter_20231230_120000_db'
AND table_name LIKE 'alter_test_table_%';

-- Check baseline columns (hours 1-4)
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'alter_20231230_120000_db'
AND table_name LIKE 'alter_test_table_%'
AND column_name LIKE 'col_h%'
ORDER BY table_name, column_name
LIMIT 20;

-- Check spike columns (hour 5)
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'alter_20231230_120000_db'
AND table_name LIKE 'alter_test_table_%'
AND column_name LIKE 'col_spike_%'
ORDER BY table_name, column_name
LIMIT 20;

-- Sample table structure
DESCRIBE alter_test_table_1;
```

## Cleanup

To remove the test database and user:

```sql
-- Replace with your actual database and user names from the logs
DROP DATABASE IF EXISTS alter_20231230_120000_db;
DROP USER IF EXISTS 'alter_20231230_120000_user'@'%';
FLUSH PRIVILEGES;
```

Or use a cleanup script:

```bash
#!/bin/bash
# Replace with your actual values
DB_NAME="alter_20231230_120000_db"
DB_USER="alter_20231230_120000_user"

mysql -hlocalhost -P3306 -uroot -p <<EOF
DROP DATABASE IF EXISTS \`$DB_NAME\`;
DROP USER IF EXISTS '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF
```

## Troubleshooting

### Issue: Permission Denied
```bash
chmod +x generate_scripts.sh
chmod +x baseline_*.sh
chmod +x anomaly_*.sh
```

### Issue: MySQL Connection Failed
Check:
- Host and port are correct
- Root password is correct
- MySQL server is running
- Firewall allows connections

### Issue: Anomaly Script Fails
Make sure:
- Baseline script completed successfully
- Database and user were created
- You're using the correct anomaly script (matching timestamp)

### Issue: Background Process Not Starting
```bash
# Check if nohup is available
which nohup

# Check logs directory permissions
ls -la logs/

# Verify script syntax
bash -n baseline_*.sh
bash -n anomaly_*.sh
```

### Issue: Script Stops Unexpectedly
```bash
# Check the logs
tail -100 logs/baseline_alter_*.log

# Check for MySQL errors
tail -100 logs/baseline_alter_*_hour_*.log

# Verify MySQL is still running
mysql -h<host> -P<port> -uroot -p<password> -e "SELECT 1;"
```

## Security Notes

⚠️ **WARNING:** This script simulates schema tampering patterns!

- Only run in test environments
- Never run on production databases
- Simulates potential unauthorized DDL operations
- Monitor for security alerts during execution
- Test in isolated environment first
- Useful for testing database activity monitoring systems

## Example Output

### Script Generation
```
============================================================================
Generating Baseline and Anomaly Scripts
============================================================================
Unique ID: alter_20231230_120000
Database: alter_20231230_120000_db
User: alter_20231230_120000_user
Baseline Script: baseline_20231230_120000.sh
Anomaly Script: anomaly_20231230_120000.sh
============================================================================

✓ Scripts generated successfully!

============================================================================
USAGE INSTRUCTIONS
============================================================================

1. Run the BASELINE script first (Hours 1-4):
   ./baseline_20231230_120000.sh [background]

2. After baseline completes, run the ANOMALY script (Hour 5):
   ./anomaly_20231230_120000.sh [background]

Both scripts use the same database and user:
  Database: alter_20231230_120000_db
  User: alter_20231230_120000_user

Logs will be in: /path/to/logs/
============================================================================
```

### Baseline Execution
```
============================================================================
Baseline ALTER Operations (Hours 1-4)
============================================================================
Unique ID: alter_20231230_120000
Host: localhost
Port: 3306
Database: alter_20231230_120000_db
User: alter_20231230_120000_user
Pattern: 50 alters/hour for 4 hours (BASELINE)
============================================================================

Testing MySQL root connection...
✓ MySQL root connection successful

Setting up unique user and database...
  ✓ Database 'alter_20231230_120000_db' created successfully
  ✓ User 'alter_20231230_120000_user' created with all privileges
  ✓ User can connect to database

========================================================================
Hour 1 of 4 (BASELINE)
========================================================================
Hour 1: Executing 50 ALTER commands...
  ✓ Hour 1: 50 alters completed successfully

Sleeping for 1 hour(s) before next batch...
...

============================================================================
Baseline ALTER Operations Complete!
============================================================================
Total Batches: 4
Total ALTERs: 200 (baseline)
Total Duration: 4h 5m 30s
============================================================================

NEXT STEP: Run the anomaly script to create the spike (Hour 5):
  ./anomaly_20231230_120000.sh [background]
============================================================================
```

### Anomaly Execution
```
============================================================================
Anomaly ALTER Operations (Hour 5 - SPIKE)
============================================================================
Unique ID: alter_20231230_120000
Host: localhost
Port: 3306
Database: alter_20231230_120000_db
User: alter_20231230_120000_user
Pattern: 1000 alters in hour 5 (ANOMALY SPIKE)
============================================================================

Testing MySQL connection...
✓ MySQL connection successful

========================================================================
Hour 5 of 5 (ANOMALY SPIKE)
========================================================================
Hour 5: Executing 1000 ALTER commands (SPIKE!)...
  ✓ Hour 5: 1000 alters completed successfully (SPIKE!)

============================================================================
Anomaly ALTER Operations Complete!
============================================================================
Total ALTERs: 1000 (SPIKE)
Total Duration: 12m 45s
============================================================================

COMPLETE: Baseline (200 alters) + Anomaly (1000 alters) = 1200 total
============================================================================
```

## Integration with Monitoring

This script is designed to trigger alerts in:
- Database activity monitors
- Security information and event management (SIEM) systems
- Audit log analyzers
- Anomaly detection systems
- Change management systems
- Database security monitoring tools

Look for:
- Sudden spike in ALTER commands (hour 5)
- Deviation from baseline pattern (50 alters/hour)
- Temporal anomaly detection
- Unusual schema change activity
- Unauthorized DDL operations
- High-volume DDL patterns

## Time-Based Anomaly Pattern

| Hour | ALTER Count | Type | Purpose |
|------|-------------|------|---------|
| 1 | 50 | Baseline | Normal activity |
| 2 | 50 | Baseline | Normal activity |
| 3 | 50 | Baseline | Normal activity |
| 4 | 50 | Baseline | Normal activity |
| **5** | **1000** | **SPIKE** | **Anomaly/Schema Tampering** |
| **Total** | **1200** | - | **Complete** |

## Use Cases

1. **Schema Tampering Detection**
   - Test detection of mass schema changes
   - Simulate unauthorized DDL operations
   - Validate database security systems

2. **Anomaly Detection Testing**
   - Verify baseline establishment
   - Test spike detection algorithms
   - Validate alert thresholds

3. **Security Monitoring**
   - Test SIEM integration
   - Validate audit logging
   - Check DDL monitoring systems

4. **Change Management**
   - Test change tracking systems
   - Validate approval workflows
   - Monitor unauthorized changes

## Advantages of Split Architecture

1. **Flexibility**: Run baseline and anomaly at different times
2. **Control**: Decide when to trigger the anomaly
3. **Testing**: Test baseline behavior separately from anomaly
4. **Reusability**: Run multiple anomalies against same baseline
5. **Tracking**: Clear identification of which scripts belong together
6. **Debugging**: Easier to troubleshoot individual components

## Made with Bob