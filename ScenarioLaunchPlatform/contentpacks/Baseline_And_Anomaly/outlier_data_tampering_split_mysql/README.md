# MySQL Split DELETE Commands Outlier Test (Baseline + Anomaly)

## Overview
This folder contains a script generator that creates **separate baseline and anomaly scripts** for MySQL outlier detection testing. The scripts simulate normal DELETE behavior followed by a sudden spike in DELETE operations during non-working hours, which could indicate data tampering or malicious data destruction.

## Key Features
- **Split Architecture**: Separate scripts for baseline (Hours 1-4) and anomaly (Hour 5)
- **Unique Identifiers**: Each generation creates scripts with matching timestamps
- **Same User & Database**: Both baseline and anomaly scripts use the same database and user
- **Easy Tracking**: Script names include timestamps to identify which baseline matches which anomaly

## Purpose
- Test detection of time-based DELETE operation anomalies
- Simulate normal baseline: 50 deletes/hour for 4 hours
- Create anomaly spike: 1000 deletes in the 5th hour (non-working hour)
- Generate realistic outlier patterns for security monitoring
- Detect potential data tampering or destruction attempts

## Files

### 1. generate_scripts.sh (Main Script)
The parent script that generates both baseline and anomaly scripts with matching identifiers.

**What it does:**
- Generates unique timestamp-based identifier
- Creates unique database and user names
- Generates two scripts:
  - `baseline_YYYYMMDD_HHMMSS.sh` - Hours 1-4 (200 deletes)
  - `anomaly_YYYYMMDD_HHMMSS.sh` - Hour 5 (1000 deletes)
- Both scripts share the same database and user credentials
- Makes scripts executable automatically

### 2. Generated Baseline Script
**Pattern:**
- Hour 1: 50 DELETE commands (records 1-50) → Sleep 1 hour
- Hour 2: 50 DELETE commands (records 51-100) → Sleep 1 hour
- Hour 3: 50 DELETE commands (records 101-150) → Sleep 1 hour
- Hour 4: 50 DELETE commands (records 151-200) → Complete
- **Total: 200 DELETE operations over 4 hours**

**What it does:**
- Creates unique database and user
- Creates table with 2,000 test records
- Executes DELETE commands targeting specific record ranges per hour
- Logs all operations with timestamps
- Can run in foreground or background mode

### 3. Generated Anomaly Script
**Pattern:**
- Hour 5: 1000 DELETE commands (records 201-1200) (SPIKE!) → Complete
- **Total: 1000 DELETE operations in 1 hour**

**What it does:**
- Uses the same database and user created by baseline script
- Executes 1000 DELETE commands (20x normal rate)
- Simulates data tampering/destruction spike
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
Unique ID: delete_20231230_120000
Database: delete_20231230_120000_db
User: delete_20231230_120000_user
Baseline Script: baseline_20231230_120000.sh
Anomaly Script: anomaly_20231230_120000.sh
============================================================================

✓ Scripts generated successfully!
```

### Step 2: Run Baseline Script (Hours 1-4)
```bash
# Foreground (blocks terminal)
./baseline_20231230_120000.sh

# Background (recommended for 4-hour run)
./baseline_20231230_120000.sh background
```

**Monitor Background Execution:**
```bash
# View real-time logs
tail -f logs/baseline_delete_20231230_120000_background.log

# Check if still running
ps aux | grep baseline_20231230_120000.sh

# Stop background execution
pkill -f baseline_20231230_120000.sh
```

### Step 3: Run Anomaly Script (Hour 5)
**After baseline completes**, run the anomaly script:

```bash
# Foreground
./anomaly_20231230_120000.sh

# Background
./anomaly_20231230_120000.sh background
```

**Monitor Background Execution:**
```bash
# View real-time logs
tail -f logs/anomaly_delete_20231230_120000_background.log

# Check if still running
ps aux | grep anomaly_20231230_120000.sh

# Stop background execution
pkill -f anomaly_20231230_120000.sh
```

## Script Naming Convention

All generated scripts follow this pattern:
- **Baseline Script**: `baseline_YYYYMMDD_HHMMSS.sh`
- **Anomaly Script**: `anomaly_YYYYMMDD_HHMMSS.sh`
- **Database**: `delete_YYYYMMDD_HHMMSS_db`
- **User**: `delete_YYYYMMDD_HHMMSS_user`

The timestamp ensures:
- Unique identification of each test run
- Easy matching of baseline with its corresponding anomaly
- No conflicts between multiple test runs

## What Gets Created and Deleted

### Database and User
- **Database Name**: `delete_YYYYMMDD_HHMMSS_db` (unique per generation)
- **User Name**: `delete_YYYYMMDD_HHMMSS_user` (unique per generation)
- **Created by**: Baseline script
- **Used by**: Both baseline and anomaly scripts
- User has full privileges on the database

### Table Structure
- **Table Name:** `timed_delete_test`
- **Columns:**
  - `id` (INT, AUTO_INCREMENT, PRIMARY KEY)
  - `record_number` (INT, NOT NULL)
  - `data` (VARCHAR(255))
  - `created_at` (TIMESTAMP)
- **Index:** `idx_record_number` on `record_number`
- **Records:** 2,000 test records (pre-populated)

### DELETE Operations Pattern

**Baseline (Hours 1-4):**
- Hour 1: DELETE records 1-50
- Hour 2: DELETE records 51-100
- Hour 3: DELETE records 101-150
- Hour 4: DELETE records 151-200

**Anomaly (Hour 5 - SPIKE):**
- Hour 5: DELETE records 201-1200 (1000 records)

## Execution Timeline

```
BASELINE SCRIPT (4 hours):
Hour 1:  50 deletes (records 1-50)    → Sleep 1 hour
Hour 2:  50 deletes (records 51-100)  → Sleep 1 hour
Hour 3:  50 deletes (records 101-150) → Sleep 1 hour
Hour 4:  50 deletes (records 151-200) → Complete (200 total)

ANOMALY SCRIPT (immediate):
Hour 5:  1000 deletes (records 201-1200) (SPIKE!) → Complete

TOTAL: 1200 DELETE operations
```

## Logs

The scripts create detailed logs in the `logs/` directory:

### Log Files
- `baseline_delete_YYYYMMDD_HHMMSS.log` - Baseline execution log
- `baseline_delete_YYYYMMDD_HHMMSS_background.log` - Baseline background mode log
- `baseline_delete_YYYYMMDD_HHMMSS_hour_N.log` - Individual hour logs (1-4)
- `anomaly_delete_YYYYMMDD_HHMMSS.log` - Anomaly execution log
- `anomaly_delete_YYYYMMDD_HHMMSS_background.log` - Anomaly background mode log
- `anomaly_delete_YYYYMMDD_HHMMSS_hour_5.log` - Hour 5 detailed log
- `baseline_delete_YYYYMMDD_HHMMSS_pid.txt` - Baseline process ID
- `anomaly_delete_YYYYMMDD_HHMMSS_pid.txt` - Anomaly process ID

## Verification

After execution, check the results:

```sql
-- Use the database created by your scripts
USE delete_20231230_120000_db;  -- Replace with your actual database name

-- Check remaining records
SELECT COUNT(*) AS RemainingRecords FROM timed_delete_test;
-- Expected after baseline: ~1800 records (2000 - 200 deleted)
-- Expected after anomaly: ~800 records (2000 - 1200 deleted)

-- Check which records were deleted
SELECT MIN(record_number), MAX(record_number) FROM timed_delete_test;

-- Sample remaining records
SELECT * FROM timed_delete_test LIMIT 10;
```

## Cleanup

To remove the test database and user:

```sql
-- Replace with your actual database and user names from the logs
DROP DATABASE IF EXISTS delete_20231230_120000_db;
DROP USER IF EXISTS 'delete_20231230_120000_user'@'%';
FLUSH PRIVILEGES;
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
- Table `timed_delete_test` exists with records 201-1200

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

## Security Notes

⚠️ **WARNING:** This script simulates data tampering patterns!

- Only run in test environments
- Never run on production databases
- Simulates potential data destruction scenarios
- Monitor for security alerts during execution
- Test in isolated environment first
- Useful for testing data integrity monitoring systems

## Time-Based Anomaly Pattern

| Hour | DELETE Count | Records Deleted | Type | Purpose |
|------|--------------|-----------------|------|---------|
| 1 | 50 | 1-50 | Baseline | Normal activity |
| 2 | 50 | 51-100 | Baseline | Normal activity |
| 3 | 50 | 101-150 | Baseline | Normal activity |
| 4 | 50 | 151-200 | Baseline | Normal activity |
| **5** | **1000** | **201-1200** | **SPIKE** | **Anomaly/Data Tampering** |
| **Total** | **1200** | - | - | **Complete** |

## Use Cases

1. **Data Tampering Detection**
   - Test detection of mass data deletion
   - Simulate insider threat scenarios
   - Validate data integrity monitoring

2. **Anomaly Detection Testing**
   - Verify baseline establishment
   - Test spike detection algorithms
   - Validate alert thresholds

3. **Security Monitoring**
   - Test SIEM integration
   - Validate audit logging
   - Check query monitoring systems

4. **Non-Working Hour Detection**
   - Simulate off-hours data manipulation
   - Test time-based anomaly detection
   - Validate behavioral analytics

## Made with Bob