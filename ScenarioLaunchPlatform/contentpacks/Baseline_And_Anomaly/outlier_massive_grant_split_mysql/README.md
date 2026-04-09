# Outlier: Massive Grant Case — Split Baseline/Anomaly (MySQL)

## Overview

This folder contains a **script generator** that creates two paired scripts for simulating a **Massive Grant** outlier scenario in MySQL:

| Script | Purpose | Duration |
|--------|---------|----------|
| `baseline_<ID>.sh` | Hours 1–4: 1 GRANT per hour on Object1–Object4 (normal behaviour) | ~4 hours |
| `anomaly_<ID>.sh`  | Hour 5: MASSIVE GRANT on 21 objects (Object5–Object25) in one run | ~1 run |

Both scripts share the **same unique ID**, database name, and users — ensuring the anomaly is detected against the correct baseline.

---

## How It Works

1. **Run `generate_scripts.sh`** with database credentials:
   ```bash
   ./generate_scripts.sh <host> <port> <root_password>
   ```
   
   This:
   - Creates a unique identifier: `mgrant_YYYYMMDD_HHMMSS`
   - Creates a dedicated database: `mgrant_<ID>_db`
   - Creates two users:
     - `mgrant_<ID>_giver` — has ALL privileges WITH GRANT OPTION
     - `mgrant_<ID>_receiver` — starts with no privileges
   - Generates `baseline_<ID>.sh` and `anomaly_<ID>.sh`
   - **Scripts are NOT launched automatically** — you run them manually

2. **Baseline script** (`baseline_<ID>.sh`):
   - Runs in **background by default**
   - Sets up the database, 25 tables (Object1–Object25), and both users
   - Executes 4 hourly GRANT runs:
     - Hour 1: `GRANT SELECT ON Object1 TO receiver`
     - Hour 2: `GRANT SELECT ON Object2 TO receiver`
     - Hour 3: `GRANT SELECT ON Object3 TO receiver`
     - Hour 4: `GRANT SELECT ON Object4 TO receiver`

3. **Anomaly script** (`anomaly_<ID>.sh`):
   - Runs in **background by default**
   - Hour 5: Issues **21 GRANTs in a single run** (Object5–Object25)
   - This massive spike vs. the baseline (1 grant/hour) triggers outlier detection

---

## Usage

```bash
cd outlier_massive_grant_case_split_mysql

# Generate scripts
./generate_scripts.sh localhost 3306 MyRootPassword123

# Run baseline (starts in background automatically)
./baseline_mgrant_20260304_070000.sh

# After baseline completes (or during hour 4), run anomaly
./anomaly_mgrant_20260304_070000.sh
```

Both scripts run in background by default. No need for `nohup` or `&`.

---

## Monitoring

After running `generate_scripts.sh`, use the printed commands to monitor progress:

```bash
# Monitor baseline (hours 1-4)
tail -f logs/baseline_mgrant_<ID>.log

# Monitor anomaly (hour 5)
tail -f logs/anomaly_mgrant_<ID>.log
```

---

## Stopping the Test

```bash
# Stop baseline
kill $(cat logs/baseline_pid_mgrant_<ID>.txt)

# Stop anomaly
kill $(cat logs/anomaly_pid_mgrant_<ID>.txt)
```

---

## Configuration

The generator script requires command-line arguments:

```bash
./generate_scripts.sh <host> <port> <root_password>
```

- **host**: MySQL server hostname (e.g., `localhost`)
- **port**: MySQL server port (e.g., `3306`)
- **root_password**: MySQL root password for database setup

User passwords are auto-generated with the timestamp for uniqueness.

---

## Outlier Pattern

| Hour | Operation | Objects Granted | Count |
|------|-----------|-----------------|-------|
| 1    | GRANT SELECT | Object1 | 1 |
| 2    | GRANT SELECT | Object2 | 1 |
| 3    | GRANT SELECT | Object3 | 1 |
| 4    | GRANT SELECT | Object4 | 1 |
| **5 (ANOMALY)** | **MASSIVE GRANT SELECT** | **Object5–Object25** | **21** |

The 21× spike in hour 5 vs. the 1-grant-per-hour baseline is designed to trigger outlier detection.

---

## Files

| File | Description |
|------|-------------|
| `generate_scripts.sh` | Parent generator — run this to start everything |
| `baseline_<ID>.sh` | Auto-generated baseline script (hours 1–4) |
| `anomaly_<ID>.sh` | Auto-generated anomaly script (hour 5) |
| `logs/` | All log files and PID files |

---

*Made with Bob*