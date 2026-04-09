# Outlier INSERT Anomaly Split - MySQL

## Overview

This folder contains a **script generator** that creates two separate scripts for simulating an INSERT command anomaly outlier pattern in MySQL:

1. **Baseline Script** (Hours 1-4): Runs 50 INSERT operations per hour for 4 hours
2. **Anomaly Script** (Hour 5): Runs 1001 INSERT operations in a single hour (spike)

Both generated scripts automatically use the **same unique user and database**, ensuring the anomaly is detected against the correct baseline.

---

## How It Works

```
generate_scripts.sh
       │
       ├──► baseline_TIMESTAMP.sh   (Hours 1-4: 50 inserts/hour)
       │         └── Creates unique DB + user
       │         └── Creates insert_test_data table
       │         └── Runs in background automatically
       │
       └──► anomaly_TIMESTAMP.sh    (Hour 5: 1001 inserts)
                 └── Uses same DB + user as baseline
                 └── Reuses insert_test_data table
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
- Creates a unique database and user
- Creates the `insert_test_data` table
- Executes 50 INSERT operations per hour for 4 hours
- Total duration: ~4 hours

### Step 3: Run the Anomaly Script

After the baseline completes (or while it's running for the last hour):

```bash
./anomaly_TIMESTAMP.sh
```

- Runs **automatically in the background** (no arguments needed)
- Uses the **same database and user** as the baseline
- Executes 1001 INSERT operations in hour 5 (spike)

---

## INSERT Pattern

| Hour | Script   | INSERT Count | Pattern   |
|------|----------|--------------|-----------|
| 1    | Baseline | 50           | Normal    |
| 2    | Baseline | 50           | Normal    |
| 3    | Baseline | 50           | Normal    |
| 4    | Baseline | 50           | Normal    |
| 5    | Anomaly  | 1001         | **SPIKE** |

### INSERT Variety (5 rotating types)

Each INSERT batch uses 5 rotating query types for realism:

| Type | Description |
|------|-------------|
| 0    | Simple single-row INSERT with `category_A` |
| 1    | INSERT with varying category and `pending` status |
| 2    | INSERT with NULL category (minimal data) |
| 3    | INSERT with computed values (`NOW()`, `RAND()`) |
| 4    | Multi-row INSERT (3 rows at once) |

### Table Schema

```sql
CREATE TABLE insert_test_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_number INT NOT NULL,
    data VARCHAR(255),
    category VARCHAR(50),
    amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_record_number (record_number),
    INDEX idx_category (category),
    INDEX idx_status (status)
);
```

---

## Monitoring

```bash
# Monitor baseline progress
tail -f logs/baseline_insert_TIMESTAMP_background.log

# Monitor anomaly progress
tail -f logs/anomaly_insert_TIMESTAMP_background.log

# Check if baseline is still running
cat logs/baseline_insert_TIMESTAMP_pid.txt
ps aux | grep baseline_TIMESTAMP.sh

# Check if anomaly is still running
cat logs/anomaly_insert_TIMESTAMP_pid.txt
ps aux | grep anomaly_TIMESTAMP.sh
```

---

## Log Files

All logs are stored in the `logs/` directory:

| File | Description |
|------|-------------|
| `baseline_insert_TIMESTAMP.log` | Main baseline log |
| `baseline_insert_TIMESTAMP_background.log` | Background process output |
| `baseline_insert_TIMESTAMP_hour_N.log` | Per-hour INSERT logs |
| `baseline_insert_TIMESTAMP_pid.txt` | Baseline process ID |
| `anomaly_insert_TIMESTAMP.log` | Main anomaly log |
| `anomaly_insert_TIMESTAMP_background.log` | Background process output |
| `anomaly_insert_TIMESTAMP_hour_5.log` | Hour 5 INSERT logs |
| `anomaly_insert_TIMESTAMP_pid.txt` | Anomaly process ID |

---

## Stopping Scripts

```bash
# Stop baseline
kill $(cat logs/baseline_insert_TIMESTAMP_pid.txt)
# or
pkill -f baseline_TIMESTAMP.sh

# Stop anomaly
kill $(cat logs/anomaly_insert_TIMESTAMP_pid.txt)
# or
pkill -f anomaly_TIMESTAMP.sh
```

---

## Generated Script Details

### Baseline Script
- **Database**: `insert_TIMESTAMP_db` (unique per generation)
- **User**: `insert_TIMESTAMP_user` (unique per generation)
- **Operations**: 50 INSERTs/hour × 4 hours = 200 total inserts
- **Sleep**: 1 hour between batches
- **Execution**: Always runs in background via `nohup`

### Anomaly Script
- **Database**: Same as baseline (`insert_TIMESTAMP_db`)
- **User**: Same as baseline (`insert_TIMESTAMP_user`)
- **Operations**: 1001 INSERTs in hour 5
- **Execution**: Always runs in background via `nohup`

---

## Requirements

- MySQL client (`mysql`) installed and in PATH
- Root access to MySQL server
- `bc` utility (for arithmetic in INSERT values)
- Bash shell

---

## Notes

- Each run of `generate_scripts.sh` creates a **new unique pair** of scripts
- The baseline script **creates** the database, user, and table; the anomaly script **reuses** them
- Scripts always run in the background — no need to pass any arguments
- The anomaly script will fail if the baseline has not been run first (user/db won't exist)
- Progress is logged every 50 inserts during execution