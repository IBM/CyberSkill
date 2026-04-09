# Outlier Denial of Service Split - MySQL

## Overview

This folder contains a **script generator** that creates two separate scripts for simulating a Denial of Service (DoS) outlier pattern in MySQL:

1. **Baseline Script** (Hours 1-4): 1001 SELECT queries per hour for 4 hours (normal load)
2. **Anomaly Script** (Hour 5): 205,000 SELECT queries in a single hour (massive DoS spike)

Both generated scripts automatically use the **same unique user and database**, ensuring the anomaly is detected against the correct baseline.

---

## How It Works

```
generate_scripts.sh
       │
       ├──► baseline_TIMESTAMP.sh   (Hours 1-4: 1001 queries/hour)
       │         └── Creates unique DB + user (SELECT only)
       │         └── Creates dos_test_table with test data
       │         └── Runs in background automatically
       │
       └──► anomaly_TIMESTAMP.sh    (Hour 5: 205,000 queries)
                 └── Uses same DB + user as baseline
                 └── Reuses dos_test_table
                 └── Runs in background automatically
```

---

## Usage

### Step 1: Generate the Scripts

```bash
chmod +x generate_scripts.sh
./generate_scripts.sh <host> <port> <root_password>
```

**Example:**
```bash
./generate_scripts.sh localhost 3306 MyRootPassword123
```

This will generate two scripts with matching timestamps:
- `baseline_20240215_143022.sh`
- `anomaly_20240215_143022.sh`

### Step 2: Run the Baseline Script

```bash
./baseline_TIMESTAMP.sh
```

- Runs **automatically in the background** (no arguments needed)
- Creates a unique database and user (SELECT privilege only)
- Creates `dos_test_table` with 5 test rows
- Executes 1001 SELECT queries per hour for 4 hours
- Total duration: ~4 hours

### Step 3: Run the Anomaly Script

After the baseline completes (or while it's running for the last hour):

```bash
./anomaly_TIMESTAMP.sh
```

- Runs **automatically in the background** (no arguments needed)
- Uses the **same database and user** as the baseline
- Executes **205,000 SELECT queries** in hour 5 (DoS spike)

> ⚠️ **Warning**: The anomaly script executes 205,000 queries. This is intentional to simulate a Denial of Service attack pattern.

---

## Query Pattern

| Hour | Script   | Query Count | Pattern   |
|------|----------|-------------|-----------|
| 1    | Baseline | 1,001       | Normal    |
| 2    | Baseline | 1,001       | Normal    |
| 3    | Baseline | 1,001       | Normal    |
| 4    | Baseline | 1,001       | Normal    |
| 5    | Anomaly  | 205,000     | **DoS SPIKE** |

**Spike ratio**: 205,000 / 1,001 ≈ **205× normal volume**

All queries: `SELECT * FROM dos_test_table;`

---

## Monitoring

```bash
# Monitor baseline progress
tail -f logs/baseline_dos_TIMESTAMP_background.log

# Monitor anomaly progress (shows progress every 1000 queries)
tail -f logs/anomaly_dos_TIMESTAMP_background.log

# Check if baseline is still running
cat logs/baseline_dos_TIMESTAMP_pid.txt
ps aux | grep baseline_TIMESTAMP.sh

# Check if anomaly is still running
cat logs/anomaly_dos_TIMESTAMP_pid.txt
ps aux | grep anomaly_TIMESTAMP.sh
```

---

## Log Files

All logs are stored in the `logs/` directory:

| File | Description |
|------|-------------|
| `baseline_dos_TIMESTAMP.log` | Main baseline log |
| `baseline_dos_TIMESTAMP_background.log` | Background process output |
| `baseline_dos_TIMESTAMP_run_N.log` | Per-run query logs |
| `baseline_dos_TIMESTAMP_pid.txt` | Baseline process ID |
| `anomaly_dos_TIMESTAMP.log` | Main anomaly log |
| `anomaly_dos_TIMESTAMP_background.log` | Background process output |
| `anomaly_dos_TIMESTAMP_run5.log` | Hour 5 query logs |
| `anomaly_dos_TIMESTAMP_pid.txt` | Anomaly process ID |

---

## Stopping Scripts

```bash
# Stop baseline
kill $(cat logs/baseline_dos_TIMESTAMP_pid.txt)
# or
pkill -f baseline_TIMESTAMP.sh

# Stop anomaly
kill $(cat logs/anomaly_dos_TIMESTAMP_pid.txt)
# or
pkill -f anomaly_TIMESTAMP.sh
```

---

## Generated Script Details

### Baseline Script
- **Database**: `dos_TIMESTAMP_db` (unique per generation)
- **User**: `dos_TIMESTAMP_user` (unique per generation, SELECT only on `dos_test_table`)
- **Operations**: 1001 SELECTs/hour × 4 hours = 4004 total queries
- **Sleep**: 1 hour between runs
- **Execution**: Always runs in background via `nohup`

### Anomaly Script
- **Database**: Same as baseline (`dos_TIMESTAMP_db`)
- **User**: Same as baseline (`dos_TIMESTAMP_user`)
- **Operations**: 205,000 SELECTs in hour 5
- **Execution**: Always runs in background via `nohup`

---

## Requirements

- MySQL client (`mysql`) installed and in PATH
- Root access to MySQL server
- Bash shell

---

## Notes

- Each run of `generate_scripts.sh` creates a **new unique pair** of scripts
- The baseline script **creates** the database, user, and table; the anomaly script **reuses** them
- Scripts always run in the background — no need to pass any arguments
- The anomaly script will fail if the baseline has not been run first (user/db won't exist)
- Progress is logged every 1000 queries during execution
- The 205× query spike is designed to trigger DoS anomaly detection