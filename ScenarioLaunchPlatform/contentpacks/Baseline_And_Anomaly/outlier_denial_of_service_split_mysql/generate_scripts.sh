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
    echo "  - baseline_TIMESTAMP.sh (Hours 1-4: 1001 queries/hour)"
    echo "  - anomaly_TIMESTAMP.sh (Hour 5: 205000 queries - DoS spike)"
    echo "  Both scripts will use the same user and database"
    exit 1
fi

DB_HOST="$1"
DB_PORT="$2"
ROOT_PASSWORD="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate unique identifier
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
UNIQUE_ID="dos_${TIMESTAMP}"

# Generate unique user and database names
DB_USER="${UNIQUE_ID}_user"
USER_PASSWORD="DosPass_${TIMESTAMP}!"
DB_NAME="${UNIQUE_ID}_db"
TABLE_NAME="dos_test_table"

# Script names
BASELINE_SCRIPT="baseline_${TIMESTAMP}.sh"
ANOMALY_SCRIPT="anomaly_${TIMESTAMP}.sh"

echo "============================================================================"
echo "Generating Baseline and Anomaly Scripts"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Table: $TABLE_NAME"
echo "Baseline Script: $BASELINE_SCRIPT"
echo "Anomaly Script: $ANOMALY_SCRIPT"
echo "============================================================================"
echo ""

# Create baseline script
cat > "$SCRIPT_DIR/$BASELINE_SCRIPT" <<'BASELINE_EOF'
#!/bin/bash
# ============================================================================
# Script: BASELINE_SCRIPT_NAME
# Purpose: Denial of Service baseline (Hours 1-4)
# Pattern: 1001 SELECT queries/hour for 4 hours
# Generated: GENERATION_TIME
# Unique ID: UNIQUE_ID_VALUE
# ============================================================================

# Configuration (DO NOT MODIFY - Generated values)
DB_HOST="DB_HOST_VALUE"
DB_PORT="DB_PORT_VALUE"
ROOT_PASSWORD="ROOT_PASSWORD_VALUE"
DB_USER="DB_USER_VALUE"
USER_PASSWORD="USER_PASSWORD_VALUE"
DB_NAME="DB_NAME_VALUE"
TABLE_NAME="TABLE_NAME_VALUE"
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

# Function to setup database, table, and user
setup_environment() {
    log_message "Setting up test environment..."
    log_message "  Database: $DB_NAME"
    log_message "  User: $DB_USER"
    log_message "  Table: $TABLE_NAME"

    mysql -h"$DB_HOST" -P"$DB_PORT" -uroot -p"$ROOT_PASSWORD" >> "$MAIN_LOG" 2>&1 <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
USE \`$DB_NAME\`;

CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO $TABLE_NAME (data) VALUES
('Test data 1'),
('Test data 2'),
('Test data 3'),
('Test data 4'),
('Test data 5');

DROP USER IF EXISTS '$DB_USER'@'%';
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$USER_PASSWORD';
GRANT SELECT ON \`$DB_NAME\`.$TABLE_NAME TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    if [ $? -eq 0 ]; then
        log_message "✓ Environment setup completed successfully"
        return 0
    else
        log_message "✗ Environment setup failed!"
        return 1
    fi
}

# Function to execute queries
execute_queries() {
    local num_queries="$1"
    local run_num="$2"
    local run_log="$LOG_DIR/baseline_${UNIQUE_ID}_run${run_num}.log"

    log_message "RUN ${run_num}: Executing ${num_queries} SELECT queries..."

    local start_time=$(date +%s)

    for i in $(seq 1 $num_queries); do
        mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$USER_PASSWORD" "$DB_NAME" -e "SELECT * FROM $TABLE_NAME;" >> "$run_log" 2>&1

        # Show progress every 1000 queries
        if [ $((i % 1000)) -eq 0 ]; then
            log_message "  Progress: ${i}/${num_queries} queries executed..."
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    log_message "  ✓ RUN ${run_num}: ${num_queries} queries completed in ${duration} seconds"
    return 0
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Baseline Denial of Service Test (Hours 1-4)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Table: $TABLE_NAME"
    log_message "Pattern: 1001 queries/hour for 4 hours (BASELINE)"
    log_message "Sleep Between Runs: $SLEEP_HOURS hour(s)"
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

    setup_environment
    if [ $? -ne 0 ]; then
        log_message "✗ Failed to setup environment. Exiting."
        exit 1
    fi
    log_message ""

    local TEST_START=$(date +%s)

    for run in $(seq 1 4); do
        log_message "========================================================================"
        log_message "RUN ${run} of 4 (BASELINE) - 1001 SELECT queries"
        log_message "========================================================================"

        execute_queries 1001 "$run"

        if [ $run -lt 4 ]; then
            log_message ""
            log_message "Sleeping for $SLEEP_HOURS hour(s) before next run..."
            log_message "Next run (RUN $((run + 1))) will start at: $(date -d "+${SLEEP_HOURS} hours" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -v+${SLEEP_HOURS}H '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo 'N/A')"
            log_message ""
            sleep $SLEEP_SECONDS
        fi
    done

    local TEST_END=$(date +%s)
    local TOTAL_DURATION=$((TEST_END - TEST_START))
    local HOURS=$((TOTAL_DURATION / 3600))
    local MINUTES=$(((TOTAL_DURATION % 3600) / 60))
    local SECONDS=$((TOTAL_DURATION % 60))

    log_message ""
    log_message "============================================================================"
    log_message "Baseline Denial of Service Test Complete!"
    log_message "============================================================================"
    log_message "Total Runs: 4"
    log_message "Total Queries: 4004 (1001/hour × 4 hours)"
    log_message "Total Duration: ${HOURS}h ${MINUTES}m ${SECONDS}s"
    log_message "============================================================================"
    log_message ""
    log_message "NEXT STEP: Run the anomaly script to create the DoS spike (Hour 5):"
    log_message "  ./ANOMALY_SCRIPT_NAME"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Baseline Denial of Service Test in Background"
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
export DB_HOST DB_PORT ROOT_PASSWORD DB_USER USER_PASSWORD DB_NAME TABLE_NAME UNIQUE_ID SCRIPT_DIR SLEEP_HOURS SLEEP_SECONDS LOG_DIR MAIN_LOG BACKGROUND_LOG

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    ROOT_PASSWORD="'"$ROOT_PASSWORD"'"
    DB_USER="'"$DB_USER"'"
    USER_PASSWORD="'"$USER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    TABLE_NAME="'"$TABLE_NAME"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    SLEEP_HOURS='"$SLEEP_HOURS"'
    SLEEP_SECONDS='"$SLEEP_SECONDS"'
    LOG_DIR="'"$LOG_DIR"'"
    MAIN_LOG="'"$MAIN_LOG"'"

    # Define all functions
    '"$(declare -f log_message)"'
    '"$(declare -f setup_environment)"'
    '"$(declare -f execute_queries)"'
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
# Purpose: Denial of Service anomaly (Hour 5) - massive query spike
# Pattern: 205000 SELECT queries in hour 5 (DoS SPIKE)
# Generated: GENERATION_TIME
# Unique ID: UNIQUE_ID_VALUE
# ============================================================================

# Configuration (DO NOT MODIFY - Generated values)
DB_HOST="DB_HOST_VALUE"
DB_PORT="DB_PORT_VALUE"
DB_USER="DB_USER_VALUE"
USER_PASSWORD="USER_PASSWORD_VALUE"
DB_NAME="DB_NAME_VALUE"
TABLE_NAME="TABLE_NAME_VALUE"
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

# Function to execute queries
execute_queries() {
    local num_queries="$1"
    local run_log="$LOG_DIR/anomaly_${UNIQUE_ID}_run5.log"

    log_message "RUN 5 (DoS SPIKE): Executing ${num_queries} SELECT queries..."

    local start_time=$(date +%s)

    for i in $(seq 1 $num_queries); do
        mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$USER_PASSWORD" "$DB_NAME" -e "SELECT * FROM $TABLE_NAME;" >> "$run_log" 2>&1

        # Show progress every 1000 queries
        if [ $((i % 1000)) -eq 0 ]; then
            log_message "  Progress: ${i}/${num_queries} queries executed..."
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    log_message "  ✓ RUN 5 (DoS SPIKE): ${num_queries} queries completed in ${duration} seconds"
    return 0
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Anomaly Denial of Service Test (Hour 5 - DoS SPIKE)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Table: $TABLE_NAME"
    log_message "Pattern: 205000 queries in hour 5 (DENIAL OF SERVICE SPIKE)"
    log_message "============================================================================"
    log_message ""

    log_message "Testing MySQL connection..."
    if mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$USER_PASSWORD" "$DB_NAME" -e "SELECT 'Connection successful' AS Status;" > /dev/null 2>&1; then
        log_message "✓ MySQL connection successful"
    else
        log_message "✗ MySQL connection failed!"
        log_message "Make sure the baseline script has been run first!"
        exit 1
    fi
    log_message ""

    local TEST_START=$(date +%s)

    log_message "========================================================================"
    log_message "RUN 5 of 5 (DENIAL OF SERVICE SPIKE - 205000 QUERIES)"
    log_message "========================================================================"

    execute_queries 205000

    local TEST_END=$(date +%s)
    local TOTAL_DURATION=$((TEST_END - TEST_START))
    local HOURS=$((TOTAL_DURATION / 3600))
    local MINUTES=$(((TOTAL_DURATION % 3600) / 60))
    local SECONDS=$((TOTAL_DURATION % 60))

    log_message ""
    log_message "============================================================================"
    log_message "Anomaly Denial of Service Test Complete!"
    log_message "============================================================================"
    log_message "Total Queries: 205000 (DoS SPIKE)"
    log_message "Total Duration: ${HOURS}h ${MINUTES}m ${SECONDS}s"
    log_message "============================================================================"
    log_message ""
    log_message "COMPLETE: Baseline (4004 queries) + Anomaly (205000 queries) = 209004 total"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Anomaly Denial of Service Test in Background"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Background Log: $BACKGROUND_LOG"
echo "============================================================================"
echo ""
echo "WARNING: This will execute 205,000 queries - this is the DoS spike!"
echo ""
echo "To monitor: tail -f $BACKGROUND_LOG"
echo "To stop: pkill -f ANOMALY_SCRIPT_NAME"
echo "============================================================================"

# Export all variables and run in background
export DB_HOST DB_PORT DB_USER USER_PASSWORD DB_NAME TABLE_NAME UNIQUE_ID SCRIPT_DIR LOG_DIR MAIN_LOG BACKGROUND_LOG

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    DB_USER="'"$DB_USER"'"
    USER_PASSWORD="'"$USER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    TABLE_NAME="'"$TABLE_NAME"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    LOG_DIR="'"$LOG_DIR"'"
    MAIN_LOG="'"$MAIN_LOG"'"

    # Define all functions
    '"$(declare -f log_message)"'
    '"$(declare -f execute_queries)"'
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
sed -i.bak "s|USER_PASSWORD_VALUE|$USER_PASSWORD|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|DB_NAME_VALUE|$DB_NAME|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"
sed -i.bak "s|TABLE_NAME_VALUE|$TABLE_NAME|g" "$SCRIPT_DIR/$BASELINE_SCRIPT"

# Replace placeholders in anomaly script
sed -i.bak "s|ANOMALY_SCRIPT_NAME|$ANOMALY_SCRIPT|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|GENERATION_TIME|$(date '+%Y-%m-%d %H:%M:%S')|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|UNIQUE_ID_VALUE|$UNIQUE_ID|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_HOST_VALUE|$DB_HOST|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_PORT_VALUE|$DB_PORT|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_USER_VALUE|$DB_USER|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|USER_PASSWORD_VALUE|$USER_PASSWORD|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_NAME_VALUE|$DB_NAME|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|TABLE_NAME_VALUE|$TABLE_NAME|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"

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
echo "  Table: $TABLE_NAME"
echo ""
echo "Monitor baseline: tail -f $SCRIPT_DIR/logs/baseline_${UNIQUE_ID}_background.log"
echo "Monitor anomaly:  tail -f $SCRIPT_DIR/logs/anomaly_${UNIQUE_ID}_background.log"
echo ""
echo "Logs will be in: $SCRIPT_DIR/logs/"
echo "============================================================================"

# Made with Bob