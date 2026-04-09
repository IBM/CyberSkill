#!/bin/bash

# ============================================================
# MASSIVE GRANT CASE OUTLIER - SCRIPT GENERATOR
# Generates two paired scripts:
#   1. baseline_<ID>.sh  — Hours 1-4: 1 GRANT per hour on Object1-Object4
#   2. anomaly_<ID>.sh   — Hour 5:   MASSIVE GRANT on 21 objects (Object5-Object25)
# Both scripts share the same UNIQUE_ID, DB name, and users.
# Scripts are NOT launched automatically — run them manually when ready.
# Usage: ./generate_scripts.sh <host> <port> <root_password>
# ============================================================

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <host> <port> <root_password>"
    echo "Example: $0 localhost 3306 MyRootPassword123"
    echo ""
    echo "This will generate:"
    echo "  - baseline_TIMESTAMP.sh (Hours 1-4: 1 GRANT/hour on Object1-4)"
    echo "  - anomaly_TIMESTAMP.sh (Hour 5: 21 GRANTs on Object5-25)"
    echo "  Both scripts will use the same user and database"
    echo "  Both scripts run in background by default"
    exit 1
fi

DB_HOST="$1"
DB_PORT="$2"
MYSQL_ROOT_PASSWORD="$3"

export PATH="$PATH:/usr/bin:/usr/local/bin:/usr/local/mysql/bin"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
UNIQUE_ID="mgrant_${TIMESTAMP}"

DB_NAME="${UNIQUE_ID}_db"
GIVER_USER="${UNIQUE_ID}_giver"
RECEIVER_USER="${UNIQUE_ID}_receiver"
GIVER_PASSWORD="MGrantPass_${TIMESTAMP}!"

BASELINE_SCRIPT="${SCRIPT_DIR}/baseline_${UNIQUE_ID}.sh"
ANOMALY_SCRIPT="${SCRIPT_DIR}/anomaly_${UNIQUE_ID}.sh"

echo "=============================================="
echo "  MASSIVE GRANT CASE - SCRIPT GENERATOR"
echo "=============================================="
echo "  Unique ID   : ${UNIQUE_ID}"
echo "  Database    : ${DB_NAME}"
echo "  Giver User  : ${GIVER_USER}"
echo "  Receiver    : ${RECEIVER_USER}"
echo "  Baseline    : $(basename ${BASELINE_SCRIPT})"
echo "  Anomaly     : $(basename ${ANOMALY_SCRIPT})"
echo "=============================================="
echo ""

# -------------------------------------------------------
# Write BASELINE script
# -------------------------------------------------------
cat > "${BASELINE_SCRIPT}" << 'BASELINE_EOF'
#!/bin/bash
# AUTO-GENERATED BASELINE SCRIPT — DO NOT EDIT MANUALLY
# Massive Grant Case Baseline: Hours 1-4, 1 GRANT per hour on Object1-Object4
# Run this script first (baseline), then run the anomaly script separately.
# This script runs in BACKGROUND by default.

export PATH="$PATH:/usr/bin:/usr/local/bin:/usr/local/mysql/bin"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNIQUE_ID="PLACEHOLDER_UNIQUE_ID"
DB_HOST="PLACEHOLDER_DB_HOST"
DB_PORT="PLACEHOLDER_DB_PORT"
DB_NAME="PLACEHOLDER_DB_NAME"
GIVER_USER="PLACEHOLDER_GIVER_USER"
RECEIVER_USER="PLACEHOLDER_RECEIVER_USER"
MYSQL_ROOT_PASSWORD="PLACEHOLDER_ROOT_PASS"
GIVER_PASSWORD="PLACEHOLDER_GIVER_PASS"

LOG_DIR="${SCRIPT_DIR}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/baseline_${UNIQUE_ID}.log"
BACKGROUND_LOG="${LOG_DIR}/baseline_${UNIQUE_ID}_background.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Main execution function
main_execution() {

    log "=============================================="
    log "  MASSIVE GRANT BASELINE STARTING"
    log "  Unique ID   : ${UNIQUE_ID}"
    log "  Host        : ${DB_HOST}"
    log "  Port        : ${DB_PORT}"
    log "  Database    : ${DB_NAME}"
    log "  Giver User  : ${GIVER_USER}"
    log "  Receiver    : ${RECEIVER_USER}"
    log "=============================================="

    # ---- Setup: Create DB, tables, and users ----
    log "Setting up database, tables, and users..."

    MYSQL_PWD="${MYSQL_ROOT_PASSWORD}" mysql -h"${DB_HOST}" -P"${DB_PORT}" -uroot <<SETUP_SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
USE \`${DB_NAME}\`;

CREATE TABLE IF NOT EXISTS Object1  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object2  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object3  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object4  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object5  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object6  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object7  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object8  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object9  (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object10 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object11 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object12 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object13 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object14 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object15 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object16 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object17 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object18 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object19 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object20 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object21 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object22 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object23 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object24 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS Object25 (id INT PRIMARY KEY AUTO_INCREMENT, data VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

INSERT INTO Object1  (data) VALUES ('Sample data for Object1');
INSERT INTO Object2  (data) VALUES ('Sample data for Object2');
INSERT INTO Object3  (data) VALUES ('Sample data for Object3');
INSERT INTO Object4  (data) VALUES ('Sample data for Object4');
INSERT INTO Object5  (data) VALUES ('Sample data for Object5');
INSERT INTO Object6  (data) VALUES ('Sample data for Object6');
INSERT INTO Object7  (data) VALUES ('Sample data for Object7');
INSERT INTO Object8  (data) VALUES ('Sample data for Object8');
INSERT INTO Object9  (data) VALUES ('Sample data for Object9');
INSERT INTO Object10 (data) VALUES ('Sample data for Object10');
INSERT INTO Object11 (data) VALUES ('Sample data for Object11');
INSERT INTO Object12 (data) VALUES ('Sample data for Object12');
INSERT INTO Object13 (data) VALUES ('Sample data for Object13');
INSERT INTO Object14 (data) VALUES ('Sample data for Object14');
INSERT INTO Object15 (data) VALUES ('Sample data for Object15');
INSERT INTO Object16 (data) VALUES ('Sample data for Object16');
INSERT INTO Object17 (data) VALUES ('Sample data for Object17');
INSERT INTO Object18 (data) VALUES ('Sample data for Object18');
INSERT INTO Object19 (data) VALUES ('Sample data for Object19');
INSERT INTO Object20 (data) VALUES ('Sample data for Object20');
INSERT INTO Object21 (data) VALUES ('Sample data for Object21');
INSERT INTO Object22 (data) VALUES ('Sample data for Object22');
INSERT INTO Object23 (data) VALUES ('Sample data for Object23');
INSERT INTO Object24 (data) VALUES ('Sample data for Object24');
INSERT INTO Object25 (data) VALUES ('Sample data for Object25');

DROP USER IF EXISTS '${GIVER_USER}'@'%';
CREATE USER '${GIVER_USER}'@'%' IDENTIFIED BY '${GIVER_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${GIVER_USER}'@'%' WITH GRANT OPTION;

DROP USER IF EXISTS '${RECEIVER_USER}'@'%';
CREATE USER '${RECEIVER_USER}'@'%' IDENTIFIED BY '${GIVER_PASSWORD}';

FLUSH PRIVILEGES;
SETUP_SQL

    if [ $? -ne 0 ]; then
        log "ERROR: Setup failed. Exiting."
        exit 1
    fi
    log "Setup completed successfully."

    # ---- Baseline: 4 hourly grant runs ----
    run_grant() {
        local run_num=$1
        local object_name=$2
        log "=========================================="
        log "  RUN ${run_num}: GRANT SELECT on ${object_name}"
        log "=========================================="
        MYSQL_PWD="${GIVER_PASSWORD}" mysql -h"${DB_HOST}" -P"${DB_PORT}" -u"${GIVER_USER}" <<GRANT_SQL
USE \`${DB_NAME}\`;
GRANT SELECT ON \`${DB_NAME}\`.\`${object_name}\` TO '${RECEIVER_USER}'@'%';
FLUSH PRIVILEGES;
SELECT 'RUN ${run_num} COMPLETED: Granted SELECT on ${object_name} to ${RECEIVER_USER}' AS Status;
SELECT NOW() AS execution_time;
GRANT_SQL
        if [ $? -eq 0 ]; then
            log "RUN ${run_num} completed successfully."
        else
            log "ERROR: RUN ${run_num} failed."
        fi
    }

    sleep_hour() {
        local h=$1
        log "Sleeping 1 hour before next run..."
        local elapsed=0
        while [ $elapsed -lt 3600 ]; do
            sleep 600
            elapsed=$((elapsed + 600))
            log "  ... $((elapsed/60)) min elapsed, $(( (3600 - elapsed)/60 )) min remaining"
        done
        log "Sleep complete."
    }

    # Hour 1
    run_grant 1 "Object1"
    sleep_hour 1

    # Hour 2
    run_grant 2 "Object2"
    sleep_hour 2

    # Hour 3
    run_grant 3 "Object3"
    sleep_hour 3

    # Hour 4
    run_grant 4 "Object4"

    log "=============================================="
    log "  BASELINE COMPLETED (Hours 1-4)"
    log "  Now run the anomaly script separately:"
    log "  ./anomaly_${UNIQUE_ID}.sh"
    log "=============================================="
}

# Always run in background
echo "============================================================================"
echo "Starting Massive Grant Baseline in Background"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "Background Log: $BACKGROUND_LOG"
echo "============================================================================"
echo ""
echo "To monitor: tail -f $BACKGROUND_LOG"
echo "To stop: pkill -f baseline_${UNIQUE_ID}.sh"
echo "============================================================================"

# Export all variables and run in background
export DB_HOST DB_PORT MYSQL_ROOT_PASSWORD GIVER_PASSWORD DB_NAME GIVER_USER RECEIVER_USER UNIQUE_ID SCRIPT_DIR LOG_DIR LOG_FILE

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    MYSQL_ROOT_PASSWORD="'"$MYSQL_ROOT_PASSWORD"'"
    GIVER_PASSWORD="'"$GIVER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    GIVER_USER="'"$GIVER_USER"'"
    RECEIVER_USER="'"$RECEIVER_USER"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    LOG_DIR="'"$LOG_DIR"'"
    LOG_FILE="'"$LOG_FILE"'"
    
    # Define all functions
    '"$(declare -f log)"'
    '"$(declare -f main_execution)"'
    
    # Run main execution
    main_execution
' > "$BACKGROUND_LOG" 2>&1 &

BG_PID=$!
echo "Background Process ID: $BG_PID"
echo "$BG_PID" > "$LOG_DIR/baseline_${UNIQUE_ID}_pid.txt"
BASELINE_EOF

# -------------------------------------------------------
# Write ANOMALY script
# -------------------------------------------------------
cat > "${ANOMALY_SCRIPT}" << 'ANOMALY_EOF'
#!/bin/bash
# AUTO-GENERATED ANOMALY SCRIPT — DO NOT EDIT MANUALLY
# Massive Grant Case Anomaly: Hour 5 — MASSIVE GRANT on 21 objects (Object5-Object25)
# Run this script AFTER the baseline script has completed (or is running).
# NOTE: The baseline script must have already created the DB and users.
# This script runs in BACKGROUND by default.

export PATH="$PATH:/usr/bin:/usr/local/bin:/usr/local/mysql/bin"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNIQUE_ID="PLACEHOLDER_UNIQUE_ID"
DB_HOST="PLACEHOLDER_DB_HOST"
DB_PORT="PLACEHOLDER_DB_PORT"
DB_NAME="PLACEHOLDER_DB_NAME"
GIVER_USER="PLACEHOLDER_GIVER_USER"
RECEIVER_USER="PLACEHOLDER_RECEIVER_USER"
GIVER_PASSWORD="PLACEHOLDER_GIVER_PASS"

LOG_DIR="${SCRIPT_DIR}/logs"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/anomaly_${UNIQUE_ID}.log"
BACKGROUND_LOG="${LOG_DIR}/anomaly_${UNIQUE_ID}_background.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Main execution function
main_execution() {
    log "=============================================="
    log "  MASSIVE GRANT ANOMALY SCRIPT STARTED"
    log "  Unique ID   : ${UNIQUE_ID}"
    log "  Host        : ${DB_HOST}"
    log "  Port        : ${DB_PORT}"
    log "  Database    : ${DB_NAME}"
    log "  Giver User  : ${GIVER_USER}"
    log "  Receiver    : ${RECEIVER_USER}"
    log "=============================================="
    log "  HOUR 5: EXECUTING MASSIVE GRANT (21 objects)"
    log "  This should trigger outlier detection!"
    log "=============================================="

    MYSQL_PWD="${GIVER_PASSWORD}" mysql -h"${DB_HOST}" -P"${DB_PORT}" -u"${GIVER_USER}" <<MASSIVE_GRANT_SQL
USE \`${DB_NAME}\`;
GRANT SELECT ON \`${DB_NAME}\`.\`Object5\`  TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object6\`  TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object7\`  TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object8\`  TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object9\`  TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object10\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object11\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object12\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object13\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object14\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object15\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object16\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object17\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object18\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object19\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object20\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object21\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object22\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object23\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object24\` TO '${RECEIVER_USER}'@'%';
GRANT SELECT ON \`${DB_NAME}\`.\`Object25\` TO '${RECEIVER_USER}'@'%';
FLUSH PRIVILEGES;
SELECT 'ANOMALY RUN COMPLETED: Granted SELECT on 21 objects (Object5-Object25) to ${RECEIVER_USER}' AS Status;
SELECT 'This massive grant operation should trigger outlier detection!' AS Alert;
SELECT NOW() AS execution_time;
MASSIVE_GRANT_SQL

    if [ $? -eq 0 ]; then
        log "ANOMALY RUN COMPLETED SUCCESSFULLY."
        log "  - 21 GRANTs issued in a single run (Object5-Object25)"
        log "  - This spike vs baseline (1 grant/hour) should trigger outlier detection."
    else
        log "ERROR: Anomaly run failed."
    fi

    log "=============================================="
    log "  ANOMALY SCRIPT FINISHED"
    log "  Log: ${LOG_FILE}"
    log "=============================================="
}

# Always run in background
echo "============================================================================"
echo "Starting Massive Grant Anomaly in Background"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "Background Log: $BACKGROUND_LOG"
echo "============================================================================"
echo ""
echo "To monitor: tail -f $BACKGROUND_LOG"
echo "To stop: pkill -f anomaly_${UNIQUE_ID}.sh"
echo "============================================================================"

# Export all variables and run in background
export DB_HOST DB_PORT GIVER_PASSWORD DB_NAME GIVER_USER RECEIVER_USER UNIQUE_ID SCRIPT_DIR LOG_DIR LOG_FILE

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    GIVER_PASSWORD="'"$GIVER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    GIVER_USER="'"$GIVER_USER"'"
    RECEIVER_USER="'"$RECEIVER_USER"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    LOG_DIR="'"$LOG_DIR"'"
    LOG_FILE="'"$LOG_FILE"'"
    
    # Define all functions
    '"$(declare -f log)"'
    '"$(declare -f main_execution)"'
    
    # Run main execution
    main_execution
' > "$BACKGROUND_LOG" 2>&1 &

BG_PID=$!
echo "Background Process ID: $BG_PID"
echo "$BG_PID" > "$LOG_DIR/anomaly_${UNIQUE_ID}_pid.txt"
ANOMALY_EOF

# -------------------------------------------------------
# Replace placeholders in both scripts
# -------------------------------------------------------
for SCRIPT in "${BASELINE_SCRIPT}" "${ANOMALY_SCRIPT}"; do
    sed -i.bak "s|PLACEHOLDER_UNIQUE_ID|${UNIQUE_ID}|g"        "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_DB_HOST|${DB_HOST}|g"            "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_DB_PORT|${DB_PORT}|g"            "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_DB_NAME|${DB_NAME}|g"            "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_GIVER_USER|${GIVER_USER}|g"      "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_RECEIVER_USER|${RECEIVER_USER}|g" "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_ROOT_PASS|${MYSQL_ROOT_PASSWORD}|g" "${SCRIPT}"
    sed -i.bak "s|PLACEHOLDER_GIVER_PASS|${GIVER_PASSWORD}|g"  "${SCRIPT}"
    rm -f "${SCRIPT}.bak"
    chmod +x "${SCRIPT}"
done

echo ""
echo "=============================================="
echo "  SCRIPTS GENERATED SUCCESSFULLY"
echo "=============================================="
echo "  Unique ID   : ${UNIQUE_ID}"
echo "  Host        : ${DB_HOST}"
echo "  Port        : ${DB_PORT}"
echo "  Database    : ${DB_NAME}"
echo "  Giver User  : ${GIVER_USER}"
echo "  Receiver    : ${RECEIVER_USER}"
echo ""
echo "  Baseline    : $(basename ${BASELINE_SCRIPT})"
echo "  Anomaly     : $(basename ${ANOMALY_SCRIPT})"
echo ""
echo "  Both scripts run in BACKGROUND by default (no nohup needed)"
echo ""
echo "  To run baseline (hours 1-4):"
echo "    ./$(basename ${BASELINE_SCRIPT})"
echo ""
echo "  To run anomaly (hour 5):"
echo "    ./$(basename ${ANOMALY_SCRIPT})"
echo ""
echo "  To monitor:"
echo "    tail -f logs/baseline_${UNIQUE_ID}_background.log"
echo "    tail -f logs/anomaly_${UNIQUE_ID}_background.log"
echo "=============================================="

# Made with Bob