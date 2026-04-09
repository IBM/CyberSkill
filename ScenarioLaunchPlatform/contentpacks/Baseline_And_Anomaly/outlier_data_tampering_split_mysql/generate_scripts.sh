#!/bin/bash
# ============================================================================
# Script: generate_scripts.sh
# Purpose: Generate baseline and anomaly scripts with matching identifiers
# Usage: ./generate_scripts.sh <host> <port> <root_password>
# ============================================================================

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <host> <port> <root_password>"
    echo "Example: $0 localhost 3306 MyPassword123"
    echo ""
    echo "This will generate:"
    echo "  - baseline_TIMESTAMP.sh (Hours 1-4: 50 deletes/hour)"
    echo "  - anomaly_TIMESTAMP.sh (Hour 5: 1000 deletes)"
    echo "  Both scripts will use the same user and database"
    exit 1
fi

DB_HOST="$1"
DB_PORT="$2"
ROOT_PASSWORD="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate unique identifier
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
UNIQUE_ID="delete_${TIMESTAMP}"

# Generate unique user and database names
DB_USER="${UNIQUE_ID}_user"
DB_USER_PASSWORD="DeletePass_${TIMESTAMP}_$(openssl rand -hex 4 2>/dev/null || echo 'default')"
DB_NAME="${UNIQUE_ID}_db"

# Script names
BASELINE_SCRIPT="baseline_${TIMESTAMP}.sh"
ANOMALY_SCRIPT="anomaly_${TIMESTAMP}.sh"

echo "============================================================================"
echo "Generating Baseline and Anomaly Scripts"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Baseline Script: $BASELINE_SCRIPT"
echo "Anomaly Script: $ANOMALY_SCRIPT"
echo "============================================================================"
echo ""

# Create baseline script
cat > "$SCRIPT_DIR/$BASELINE_SCRIPT" <<'BASELINE_EOF'
#!/bin/bash
# ============================================================================
# Script: BASELINE_SCRIPT_NAME
# Purpose: Run DELETE operations for baseline creation (Hours 1-4)
# Pattern: 50 deletes/hour for 4 hours
# Generated: GENERATION_TIME
# Unique ID: UNIQUE_ID_VALUE
# ============================================================================

# Configuration (DO NOT MODIFY - Generated values)
DB_HOST="DB_HOST_VALUE"
DB_PORT="DB_PORT_VALUE"
ROOT_PASSWORD="ROOT_PASSWORD_VALUE"
DB_USER="DB_USER_VALUE"
DB_USER_PASSWORD="DB_USER_PASSWORD_VALUE"
DB_NAME="DB_NAME_VALUE"
UNIQUE_ID="UNIQUE_ID_VALUE"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure mysql is in PATH
export PATH="$PATH:/usr/bin:/usr/local/bin:/usr/local/mysql/bin"

# Runtime configuration
SLEEP_HOURS=1
SLEEP_SECONDS=$((SLEEP_HOURS * 3600))
LOG_DIR="$SCRIPT_DIR/logs"
MAIN_LOG="$LOG_DIR/baseline_${UNIQUE_ID}.log"
BACKGROUND_LOG="$LOG_DIR/baseline_${UNIQUE_ID}_background.log"

# Create logs directory
mkdir -p "$LOG_DIR"

# Function to log messages
log_message() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$MAIN_LOG"
}

# Function to setup user and database
setup_user_and_database() {
    log_message "Setting up unique user and database..."
    log_message "  Database: $DB_NAME"
    log_message "  User: $DB_USER"

    log_message "  Creating database '$DB_NAME'..."
    mysql -h"$DB_HOST" -P"$DB_PORT" -uroot -p"$ROOT_PASSWORD" > /dev/null 2>&1 <<EOF
CREATE DATABASE \`$DB_NAME\`;
EOF

    if [ $? -eq 0 ]; then
        log_message "  ✓ Database '$DB_NAME' created successfully"
    else
        log_message "  ✗ Failed to create database '$DB_NAME'"
        return 1
    fi

    log_message "  Creating user '$DB_USER' with all privileges..."
    mysql -h"$DB_HOST" -P"$DB_PORT" -uroot -p"$ROOT_PASSWORD" > /dev/null 2>&1 <<EOF
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    if [ $? -eq 0 ]; then
        log_message "  ✓ User '$DB_USER' created with all privileges on '$DB_NAME'"
    else
        log_message "  ✗ Failed to create user or grant privileges"
        return 1
    fi

    log_message "  Testing user connection..."
    if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" -e "SELECT 'User connection successful' AS Status;" > /dev/null 2>&1; then
        log_message "  ✓ User '$DB_USER' can connect to database '$DB_NAME'"
        return 0
    else
        log_message "  ✗ User connection test failed"
        return 1
    fi
}

# Function to execute DELETE commands
execute_deletes() {
    local num_deletes="$1"
    local hour_num="$2"
    local batch_log="$LOG_DIR/baseline_${UNIQUE_ID}_hour_${hour_num}.log"

    log_message "Hour ${hour_num}: Executing ${num_deletes} DELETE commands as user '$DB_USER'..."

    # Create table and insert data if needed
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" > "$batch_log" 2>&1 <<EOF
CREATE TABLE IF NOT EXISTS timed_delete_test (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_number INT NOT NULL,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_record_number (record_number)
);

INSERT IGNORE INTO timed_delete_test (record_number, data)
SELECT n, CONCAT('Data for record ', n)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS n
    FROM
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
WHERE n <= 2000;

SELECT CONCAT('Records before delete: ', COUNT(*)) AS Status FROM timed_delete_test;
EOF

    # Execute DELETE commands (50 per hour, offset by hour)
    local start_record=$(( (hour_num - 1) * 50 + 1 ))
    for i in $(seq $start_record $((start_record + 49))); do
        mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
DELETE FROM timed_delete_test WHERE record_number = $i;
EOF
    done

    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
SELECT CONCAT('Records after delete: ', COUNT(*)) AS Status FROM timed_delete_test;
SELECT CONCAT('Hour ${hour_num}: ${num_deletes} DELETE commands completed') AS Result;
EOF

    if [ $? -eq 0 ]; then
        log_message "  ✓ Hour ${hour_num}: ${num_deletes} deletes completed successfully"
        return 0
    else
        log_message "  ✗ Hour ${hour_num}: DELETE operations failed (check $batch_log)"
        return 1
    fi
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Baseline DELETE Operations (Hours 1-4)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Pattern: 50 deletes/hour for 4 hours (BASELINE)"
    log_message "Sleep Between Batches: $SLEEP_HOURS hour(s)"
    log_message "============================================================================"
    log_message ""

    log_message "Testing MySQL root connection..."
    if mysql -h"$DB_HOST" -P"$DB_PORT" -uroot -p"$ROOT_PASSWORD" -e "SELECT 'Connection successful' AS Status;" > /dev/null 2>&1; then
        log_message "✓ MySQL root connection successful"
    else
        log_message "✗ MySQL root connection failed!"
        exit 1
    fi
    log_message ""

    if ! setup_user_and_database; then
        log_message "✗ Failed to setup user and database"
        exit 1
    fi
    log_message ""

    local start_time=$(date +%s)

    for hour in $(seq 1 4); do
        log_message "========================================================================"
        log_message "Hour ${hour} of 4 (BASELINE)"
        log_message "========================================================================"

        execute_deletes 50 "$hour"

        if [ $hour -lt 4 ]; then
            log_message ""
            log_message "Sleeping for $SLEEP_HOURS hour(s) before next batch..."
            log_message "Next batch (Hour $((hour + 1))) will start at: $(date -d "+${SLEEP_HOURS} hours" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -v+${SLEEP_HOURS}H '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo 'N/A')"
            log_message ""
            sleep $SLEEP_SECONDS
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))
    local seconds=$((duration % 60))

    log_message ""
    log_message "============================================================================"
    log_message "Baseline DELETE Operations Complete!"
    log_message "============================================================================"
    log_message "Total Batches: 4"
    log_message "Total DELETEs: 200 (baseline)"
    log_message "Total Duration: ${hours}h ${minutes}m ${seconds}s"
    log_message "============================================================================"
    log_message ""
    log_message "NEXT STEP: Run the anomaly script to create the spike (Hour 5):"
    log_message "  ./ANOMALY_SCRIPT_NAME"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Baseline DELETE Operations in Background"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Background Log: $BACKGROUND_LOG"
echo "============================================================================"
echo ""
echo "To monitor: tail -f $BACKGROUND_LOG"
echo "To stop: pkill -f BASELINE_SCRIPT_NAME"
echo "============================================================================"

# Export all variables and run in background
export DB_HOST DB_PORT ROOT_PASSWORD DB_USER DB_USER_PASSWORD DB_NAME UNIQUE_ID SCRIPT_DIR SLEEP_HOURS SLEEP_SECONDS LOG_DIR MAIN_LOG BACKGROUND_LOG

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    ROOT_PASSWORD="'"$ROOT_PASSWORD"'"
    DB_USER="'"$DB_USER"'"
    DB_USER_PASSWORD="'"$DB_USER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    SLEEP_HOURS='"$SLEEP_HOURS"'
    SLEEP_SECONDS='"$SLEEP_SECONDS"'
    LOG_DIR="'"$LOG_DIR"'"
    MAIN_LOG="'"$MAIN_LOG"'"

    # Define all functions
    '"$(declare -f log_message)"'
    '"$(declare -f setup_user_and_database)"'
    '"$(declare -f execute_deletes)"'
    '"$(declare -f main_execution)"'

    # Run main execution
    main_execution
' > "$BACKGROUND_LOG" 2>&1 &

BG_PID=$!
echo "Background Process ID: $BG_PID"
echo "$BG_PID" > "$LOG_DIR/baseline_${UNIQUE_ID}_pid.txt"

# Made with Bob
BASELINE_EOF

# Create anomaly script
cat > "$SCRIPT_DIR/$ANOMALY_SCRIPT" <<'ANOMALY_EOF'
#!/bin/bash
# ============================================================================
# Script: ANOMALY_SCRIPT_NAME
# Purpose: Run DELETE operations for anomaly creation (Hour 5)
# Pattern: 1000 deletes in hour 5 (SPIKE)
# Generated: GENERATION_TIME
# Unique ID: UNIQUE_ID_VALUE
# ============================================================================

# Configuration (DO NOT MODIFY - Generated values)
DB_HOST="DB_HOST_VALUE"
DB_PORT="DB_PORT_VALUE"
DB_USER="DB_USER_VALUE"
DB_USER_PASSWORD="DB_USER_PASSWORD_VALUE"
DB_NAME="DB_NAME_VALUE"
UNIQUE_ID="UNIQUE_ID_VALUE"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure mysql is in PATH
export PATH="$PATH:/usr/bin:/usr/local/bin:/usr/local/mysql/bin"

# Runtime configuration
LOG_DIR="$SCRIPT_DIR/logs"
MAIN_LOG="$LOG_DIR/anomaly_${UNIQUE_ID}.log"
BACKGROUND_LOG="$LOG_DIR/anomaly_${UNIQUE_ID}_background.log"

# Create logs directory
mkdir -p "$LOG_DIR"

# Function to log messages
log_message() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$MAIN_LOG"
}

# Function to execute DELETE commands
execute_deletes() {
    local num_deletes="$1"
    local batch_log="$LOG_DIR/anomaly_${UNIQUE_ID}_hour_5.log"

    log_message "Hour 5: Executing ${num_deletes} DELETE commands as user '$DB_USER' (SPIKE!)..."

    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" > "$batch_log" 2>&1 <<EOF
SELECT CONCAT('Records before spike delete: ', COUNT(*)) AS Status FROM timed_delete_test;
EOF

    # Hour 5: delete records 201-1200
    for i in $(seq 201 1200); do
        mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
DELETE FROM timed_delete_test WHERE record_number = $i;
EOF
    done

    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
SELECT CONCAT('Records after spike delete: ', COUNT(*)) AS Status FROM timed_delete_test;
SELECT CONCAT('Hour 5: ${num_deletes} DELETE commands completed (SPIKE!)') AS Result;
EOF

    if [ $? -eq 0 ]; then
        log_message "  ✓ Hour 5: ${num_deletes} deletes completed successfully (SPIKE!)"
        return 0
    else
        log_message "  ✗ Hour 5: DELETE operations failed (check $batch_log)"
        return 1
    fi
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Anomaly DELETE Operations (Hour 5 - SPIKE)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Pattern: 1000 deletes in hour 5 (ANOMALY SPIKE)"
    log_message "============================================================================"
    log_message ""

    log_message "Testing MySQL connection..."
    if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" -e "SELECT 'Connection successful' AS Status;" > /dev/null 2>&1; then
        log_message "✓ MySQL connection successful"
    else
        log_message "✗ MySQL connection failed!"
        log_message "Make sure the baseline script has been run first!"
        exit 1
    fi
    log_message ""

    local start_time=$(date +%s)

    log_message "========================================================================"
    log_message "Hour 5 of 5 (ANOMALY SPIKE)"
    log_message "========================================================================"

    execute_deletes 1000

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    log_message ""
    log_message "============================================================================"
    log_message "Anomaly DELETE Operations Complete!"
    log_message "============================================================================"
    log_message "Total DELETEs: 1000 (SPIKE)"
    log_message "Total Duration: ${minutes}m ${seconds}s"
    log_message "============================================================================"
    log_message ""
    log_message "COMPLETE: Baseline (200 deletes) + Anomaly (1000 deletes) = 1200 total"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Anomaly DELETE Operations in Background"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Background Log: $BACKGROUND_LOG"
echo "============================================================================"
echo ""
echo "To monitor: tail -f $BACKGROUND_LOG"
echo "To stop: pkill -f ANOMALY_SCRIPT_NAME"
echo "============================================================================"

# Export all variables and run in background
export DB_HOST DB_PORT DB_USER DB_USER_PASSWORD DB_NAME UNIQUE_ID SCRIPT_DIR LOG_DIR MAIN_LOG BACKGROUND_LOG

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    DB_USER="'"$DB_USER"'"
    DB_USER_PASSWORD="'"$DB_USER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    LOG_DIR="'"$LOG_DIR"'"
    MAIN_LOG="'"$MAIN_LOG"'"

    # Define all functions
    '"$(declare -f log_message)"'
    '"$(declare -f execute_deletes)"'
    '"$(declare -f main_execution)"'

    # Run main execution
    main_execution
' > "$BACKGROUND_LOG" 2>&1 &

BG_PID=$!
echo "Background Process ID: $BG_PID"
echo "$BG_PID" > "$LOG_DIR/anomaly_${UNIQUE_ID}_pid.txt"

# Made with Bob
ANOMALY_EOF

# Replace placeholders in baseline script
sed -i.bak "s|BASELINE_SCRIPT_NAME|$BASELINE_SCRIPT|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|ANOMALY_SCRIPT_NAME|$ANOMALY_SCRIPT|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|GENERATION_TIME|$(date '+%Y-%m-%d %H:%M:%S')|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|UNIQUE_ID_VALUE|$UNIQUE_ID|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|DB_HOST_VALUE|$DB_HOST|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|DB_PORT_VALUE|$DB_PORT|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|ROOT_PASSWORD_VALUE|$ROOT_PASSWORD|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|DB_USER_VALUE|$DB_USER|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|DB_USER_PASSWORD_VALUE|$DB_USER_PASSWORD|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|DB_NAME_VALUE|$DB_NAME|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"

# Replace placeholders in anomaly script
sed -i.bak "s|ANOMALY_SCRIPT_NAME|$ANOMALY_SCRIPT|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|GENERATION_TIME|$(date '+%Y-%m-%d %H:%M:%S')|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|UNIQUE_ID_VALUE|$UNIQUE_ID|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_HOST_VALUE|$DB_HOST|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_PORT_VALUE|$DB_PORT|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_USER_VALUE|$DB_USER|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_USER_PASSWORD_VALUE|$DB_USER_PASSWORD|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_NAME_VALUE|$DB_NAME|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"

# Remove backup files
rm -f "$SCRIPT_DIR/$BASELINE_SCRIPT.bak" "$SCRIPT_DIR/$ANOMALY_SCRIPT.bak"

# Make scripts executable
chmod +x "$SCRIPT_DIR/$BASELINE_SCRIPT"
chmod +x "$SCRIPT_DIR/$ANOMALY_SCRIPT"

echo "✓ Scripts generated successfully!"
echo ""
echo "============================================================================"
echo "USAGE INSTRUCTIONS"
echo "============================================================================"
echo ""
echo "1. Run the BASELINE script first (Hours 1-4) - runs in background automatically:"
echo "   ./$BASELINE_SCRIPT"
echo ""
echo "2. After baseline completes, run the ANOMALY script (Hour 5) - runs in background automatically:"
echo "   ./$ANOMALY_SCRIPT"
echo ""
echo "Both scripts use the same database and user:"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo ""
echo "Monitor baseline: tail -f $SCRIPT_DIR/logs/baseline_${UNIQUE_ID}_background.log"
echo "Monitor anomaly:  tail -f $SCRIPT_DIR/logs/anomaly_${UNIQUE_ID}_background.log"
echo ""
echo "Logs will be in: $SCRIPT_DIR/logs/"
echo "============================================================================"

# Made with Bob