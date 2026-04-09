# Outlier Baseline & Anomaly Script Generator

This directory contains master scripts to generate baseline and anomaly scripts for all 6 outlier detection patterns.

## Overview

Each outlier folder contains a `generate_scripts.sh` that creates paired baseline/anomaly scripts:
- **Baseline scripts**: Run for 4 hours, establishing normal behavior patterns
- **Anomaly scripts**: Run for 1 hour, creating attack spikes for detection testing

## Master Scripts

### Linux/Mac: `generate_all_outlier_scripts.sh`

Generates all baseline/anomaly script pairs for all 6 outlier types.

**Usage:**
```bash
chmod +x generate_all_outlier_scripts.sh
./generate_all_outlier_scripts.sh <host> <port> <root_password>
```

**Example:**
```bash
./generate_all_outlier_scripts.sh localhost 3306 MyRootPassword123
```

### Windows: `generate_all_outlier_scripts.bat`

Windows batch file version (requires Git Bash or WSL for bash execution).

**Usage:**
```cmd
generate_all_outlier_scripts.bat <host> <port> <root_password>
```

**Example:**
```cmd
generate_all_outlier_scripts.bat localhost 3306 MyRootPassword123
```

## Outlier Types Generated

1. **Account Takeover** (`outlier_account_take_over_split_mysql/`)
   - Baseline: 50 SELECTs/hour on 1 object (4 hours)
   - Anomaly: 500 SELECTs on 5 objects (hour 5)

2. **Data Tampering** (`outlier_data_tampering_split_mysql/`)
   - Baseline: 50 DELETEs/hour (4 hours)
   - Anomaly: 1000 DELETEs (hour 5)

3. **Denial of Service** (`outlier_denial_of_service_split_mysql/`)
   - Baseline: 1001 SELECTs/hour (4 hours)
   - Anomaly: 205,000 SELECTs (hour 5)

4. **INSERT Anomaly** (`outlier_insert_anomaly_split_mysql/`)
   - Baseline: 50 INSERTs/hour (4 hours)
   - Anomaly: 1001 INSERTs (hour 5)

5. **Massive GRANT** (`outlier_massive_grant_split_mysql/`)
   - Baseline: 1 GRANT/hour on Object1-4 (4 hours)
   - Anomaly: 21 GRANTs on Object5-25 (hour 5)

6. **Schema Tampering** (`outlier_schema_tampering_split_mysql/`)
   - Baseline: 50 ALTERs/hour (4 hours)
   - Anomaly: 1000 ALTERs (hour 5)

## Generated Files

After running the master script, each outlier folder will contain:
- `baseline_YYYYMMDD_HHMMSS.sh` - Baseline script (4 hours)
- `anomaly_YYYYMMDD_HHMMSS.sh` - Anomaly script (1 hour)
- `logs/` directory - Execution logs and PID files

## Execution Workflow

### Step 1: Generate All Scripts
```bash
./generate_all_outlier_scripts.sh localhost 3306 MyRootPassword123
```

### Step 2: Run Baseline Scripts
Each baseline script runs in the background automatically:
```bash
cd outlier_account_take_over_split_mysql
./baseline_20260305_100000.sh

cd ../outlier_data_tampering_split_mysql
./baseline_20260305_100000.sh

# Repeat for all outlier types...
```

### Step 3: Wait for Baselines to Complete
Baselines run for approximately 4 hours. Monitor progress:
```bash
tail -f logs/baseline_*_background.log
```

### Step 4: Run Anomaly Scripts
After baselines complete (or during hour 4), run anomaly scripts:
```bash
cd outlier_account_take_over_split_mysql
./anomaly_20260305_100000.sh

cd ../outlier_data_tampering_split_mysql
./anomaly_20260305_100000.sh

# Repeat for all outlier types...
```

## Monitoring

### Check Running Scripts
```bash
# List all running baseline/anomaly processes
ps aux | grep -E "baseline_|anomaly_"

# Check specific PID
cat logs/baseline_*_pid.txt
```

### View Logs
```bash
# Real-time log monitoring
tail -f logs/baseline_*_background.log
tail -f logs/anomaly_*_background.log

# View completed logs
cat logs/baseline_*.log
cat logs/anomaly_*.log
```

### Stop Scripts
```bash
# Stop baseline
kill $(cat logs/baseline_*_pid.txt)

# Stop anomaly
kill $(cat logs/anomaly_*_pid.txt)

# Or use pkill
pkill -f baseline_
pkill -f anomaly_
```

## Database Cleanup

Each outlier type creates unique databases and users. To clean up:

```sql
-- List all outlier databases
SHOW DATABASES LIKE '%_db';

-- Drop specific outlier database
DROP DATABASE IF EXISTS ato_20260305_100000_db;
DROP USER IF EXISTS 'ato_20260305_100000_user'@'%';

-- Drop all outlier databases (be careful!)
-- Use the appropriate database names from your generation
```

## Troubleshooting

### Permission Denied
```bash
chmod +x generate_all_outlier_scripts.sh
chmod +x outlier_*/generate_scripts.sh
```

### MySQL Connection Failed
- Verify host and port are correct
- Check root password
- Ensure MySQL server is running
- Check firewall settings

### Scripts Not Found
- Ensure you're in the `Baseline_And_Anomaly` directory
- Verify all outlier folders exist
- Check that `generate_scripts.sh` exists in each folder

### Bash Not Found (Windows)
- Install Git Bash: https://git-scm.com/download/win
- Or use WSL (Windows Subsystem for Linux)
- Or use Git Bash from the command line

## Notes

- Each script generation creates unique timestamps
- Baseline and anomaly scripts share the same database/user
- Scripts run in background by default (using nohup)
- All logs are stored in the `logs/` directory
- Each outlier type is independent and can be run separately

## Related Content Packs

The `gdp_lab_outliers/` directory contains SLP content packs that provide the same functionality but with dynamic datasource configuration via the Story Editor:

- `outlier_account_takeover_baseline_anomaly/`
- `outlier_data_tampering_baseline_anomaly/`
- `outlier_denial_of_service_baseline_anomaly/`
- `outlier_insert_anomaly_baseline_anomaly/`
- `outlier_massive_grant_baseline_anomaly/`
- `outlier_schema_tampering_baseline_anomaly/`

These content packs allow you to run stories against any database connection configured in your settings table, without hardcoded users.

## Support

For issues or questions, please refer to the individual README files in each outlier folder or contact the GDP Lab team.