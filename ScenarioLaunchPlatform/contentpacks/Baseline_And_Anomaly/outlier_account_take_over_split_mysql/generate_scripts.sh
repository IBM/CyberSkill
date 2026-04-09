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
    echo "  - baseline_TIMESTAMP.sh (Hours 1-4: 50 SELECTs/hour on ato_object1)"
    echo "  - anomaly_TIMESTAMP.sh (Hour 5: 100 SELECTs on each of 5 objects via Java JDBC)"
    echo "  Both scripts will use the same user and database"
    exit 1
fi

DB_HOST="$1"
DB_PORT="$2"
ROOT_PASSWORD="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate unique identifier
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
UNIQUE_ID="ato_${TIMESTAMP}"

# Generate unique user and database names
DB_USER="${UNIQUE_ID}_user"
USER_PASSWORD="AtoPass_${TIMESTAMP}!"
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
# Purpose: Account Takeover baseline (Hours 1-4)
# Pattern: 50 SELECTs/hour on ato_object1 only
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

# Function to setup database, tables, and user
setup_environment() {
    log_message "Setting up test environment..."
    log_message "  Database: $DB_NAME"
    log_message "  User: $DB_USER"
    log_message "  Tables: ato_object1 through ato_object5"

    mysql -h"$DB_HOST" -P"$DB_PORT" -uroot -p"$ROOT_PASSWORD" >> "$MAIN_LOG" 2>&1 <<EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
USE \`$DB_NAME\`;

CREATE TABLE IF NOT EXISTS ato_object1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ato_object2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ato_object3 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ato_object4 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ato_object5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ato_object1 (data) VALUES ('Object1 Data 1'), ('Object1 Data 2'), ('Object1 Data 3'), ('Object1 Data 4'), ('Object1 Data 5');
INSERT INTO ato_object2 (data) VALUES ('Object2 Data 1'), ('Object2 Data 2'), ('Object2 Data 3'), ('Object2 Data 4'), ('Object2 Data 5');
INSERT INTO ato_object3 (data) VALUES ('Object3 Data 1'), ('Object3 Data 2'), ('Object3 Data 3'), ('Object3 Data 4'), ('Object3 Data 5');
INSERT INTO ato_object4 (data) VALUES ('Object4 Data 1'), ('Object4 Data 2'), ('Object4 Data 3'), ('Object4 Data 4'), ('Object4 Data 5');
INSERT INTO ato_object5 (data) VALUES ('Object5 Data 1'), ('Object5 Data 2'), ('Object5 Data 3'), ('Object5 Data 4'), ('Object5 Data 5');

DROP USER IF EXISTS '$DB_USER'@'%';
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$USER_PASSWORD';
GRANT SELECT ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
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

# Function to execute SELECT queries on a specific table
execute_selects() {
    local num_queries="$1"
    local table_name="$2"
    local run_num="$3"
    local run_log="$LOG_DIR/baseline_${UNIQUE_ID}_run${run_num}.log"

    log_message "RUN ${run_num}: Executing ${num_queries} SELECT queries on ${table_name}..."

    local start_time=$(date +%s)
    local failed_queries=0

    for i in $(seq 1 $num_queries); do
        mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$USER_PASSWORD" "$DB_NAME" -e "SELECT * FROM ${table_name};" >> "$run_log" 2>&1
        local mysql_exit=$?

        if [ $mysql_exit -ne 0 ]; then
            ((failed_queries++))
        fi

        # Show progress every 10 queries
        if [ $((i % 10)) -eq 0 ]; then
            log_message "  Progress: ${i}/${num_queries} queries executed on ${table_name}..."
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local successful_queries=$((num_queries - failed_queries))

    if [ $failed_queries -eq 0 ]; then
        log_message "  ✓ RUN ${run_num}: ${num_queries} queries on ${table_name} completed successfully in ${duration} seconds"
        return 0
    else
        log_message "  ⚠ RUN ${run_num}: ${successful_queries}/${num_queries} queries succeeded, ${failed_queries} failed in ${duration} seconds (check $run_log)"
        return 1
    fi
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Baseline Account Takeover Test (Hours 1-4)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Pattern: 50 SELECTs/hour on ato_object1 only (BASELINE)"
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

    for hour in $(seq 1 4); do
        log_message "========================================================================"
        log_message "HOUR ${hour} of 4 (BASELINE) - 50 SELECTs on ato_object1"
        log_message "========================================================================"

        execute_selects 50 "ato_object1" "$hour"

        if [ $hour -lt 4 ]; then
            log_message ""
            log_message "Sleeping for $SLEEP_HOURS hour(s) before next run..."
            log_message "Next run (HOUR $((hour + 1))) will start at: $(date -d "+${SLEEP_HOURS} hours" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -v+${SLEEP_HOURS}H '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo 'N/A')"
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
    log_message "Baseline Account Takeover Test Complete!"
    log_message "============================================================================"
    log_message "Total Runs: 4"
    log_message "Total Queries: 200 (50/hour on ato_object1)"
    log_message "Total Duration: ${HOURS}h ${MINUTES}m ${SECONDS}s"
    log_message "============================================================================"
    log_message ""
    log_message "NEXT STEP: Run the anomaly script (Hour 5 - Java JDBC):"
    log_message "  ./ANOMALY_SCRIPT_NAME"
    log_message "  NOTE: Ensure Java and MySQL Connector/J are available in the java_executor/ folder"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Baseline Account Takeover Test in Background"
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
export DB_HOST DB_PORT ROOT_PASSWORD DB_USER USER_PASSWORD DB_NAME UNIQUE_ID SCRIPT_DIR SLEEP_HOURS SLEEP_SECONDS LOG_DIR MAIN_LOG BACKGROUND_LOG

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    ROOT_PASSWORD="'"$ROOT_PASSWORD"'"
    DB_USER="'"$DB_USER"'"
    USER_PASSWORD="'"$USER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    SLEEP_HOURS='"$SLEEP_HOURS"'
    SLEEP_SECONDS='"$SLEEP_SECONDS"'
    LOG_DIR="'"$LOG_DIR"'"
    MAIN_LOG="'"$MAIN_LOG"'"

    # Define all functions
    '"$(declare -f log_message)"'
    '"$(declare -f setup_environment)"'
    '"$(declare -f execute_selects)"'
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
# Purpose: Account Takeover anomaly (Hour 5) - access all 5 objects via Java JDBC
# Pattern: 100 SELECTs on each of 5 objects (500 total) via Java JDBC
# Generated: GENERATION_TIME
# Unique ID: UNIQUE_ID_VALUE
# ============================================================================

# Configuration (DO NOT MODIFY - Generated values)
DB_HOST="DB_HOST_VALUE"
DB_PORT="DB_PORT_VALUE"
DB_USER="DB_USER_VALUE"
USER_PASSWORD="USER_PASSWORD_VALUE"
DB_NAME="DB_NAME_VALUE"
UNIQUE_ID="UNIQUE_ID_VALUE"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure mysql/java is in PATH
export PATH="$PATH:/usr/bin:/usr/local/bin:/usr/local/mysql/bin"

# Runtime configuration
LOG_DIR="$SCRIPT_DIR/logs"
MAIN_LOG="$LOG_DIR/anomaly_${UNIQUE_ID}.log"
BACKGROUND_LOG="$LOG_DIR/anomaly_${UNIQUE_ID}_background.log"
JAVA_DIR="$SCRIPT_DIR/java_executor"

# Create logs directory
mkdir -p "$LOG_DIR"

# Function to log messages
log_message() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$MAIN_LOG"
}

# Function to generate SQL file for hour 5
generate_hour5_sql() {
    local sql_file="$SCRIPT_DIR/hour5_selects_${UNIQUE_ID}.sql"
    log_message "Generating SQL file for hour 5: $sql_file" >&2

    cat > "$sql_file" <<EOF
-- Hour 5: Account Takeover - Access to all 5 objects via Java JDBC
-- 100 SELECT queries on each of 5 objects (500 total)
USE \`$DB_NAME\`;

EOF

    for obj_num in 1 2 3 4 5; do
        echo "-- 100 SELECTs on ato_object${obj_num}" >> "$sql_file"
        for i in $(seq 1 100); do
            echo "SELECT * FROM ato_object${obj_num};" >> "$sql_file"
        done
        echo "" >> "$sql_file"
    done

    log_message "✓ SQL file generated: $sql_file (500 queries total)" >&2
    # Return only the file path to stdout
    echo "$sql_file"
}

# Function to execute hour 5 using Java executor
execute_hour5_java() {
    local sql_file="$1"
    local db_props="$JAVA_DIR/db.properties"

    log_message "========================================================================"
    log_message "HOUR 5 - ACCOUNT TAKEOVER SPIKE: Accessing all 5 objects via Java JDBC"
    log_message "========================================================================"

    # Check Java executor exists
    if [ ! -d "$JAVA_DIR" ]; then
        log_message "✗ Java executor directory not found: $JAVA_DIR"
        log_message "  Please ensure java_executor/ folder exists with MySQLSQLExecutor.class"
        exit 1
    fi

    if [ ! -f "$JAVA_DIR/MySQLSQLExecutor.class" ]; then
        log_message "  MySQLSQLExecutor.class not found. Attempting to compile..."
        if [ -f "$JAVA_DIR/compile.sh" ]; then
            cd "$JAVA_DIR" && bash compile.sh
            cd "$SCRIPT_DIR"
        else
            log_message "✗ compile.sh not found. Cannot compile Java executor."
            exit 1
        fi
    fi

    # Create db.properties for Java executor
    log_message "Creating db.properties for Java executor..."
    cat > "$db_props" <<EOF
db.host=$DB_HOST
db.port=$DB_PORT
db.database=$DB_NAME
db.username=$DB_USER
db.password=$USER_PASSWORD
EOF

    log_message "Executing 500 SELECT queries (100 per object) using Java JDBC executor..."
    local start_time=$(date +%s)

    cd "$JAVA_DIR"
    ./run.sh "$sql_file" >> "$MAIN_LOG" 2>&1
    local exit_code=$?
    cd "$SCRIPT_DIR"

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    if [ $exit_code -eq 0 ]; then
        log_message "✓ Hour 5: 500 queries (100 per object) completed in ${duration} seconds"
        return 0
    else
        log_message "✗ Hour 5: Java execution failed (exit code: $exit_code, check $MAIN_LOG)"
        return 1
    fi
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Anomaly Account Takeover Test (Hour 5 - SPIKE)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Pattern: 100 SELECTs on each of 5 objects via Java JDBC (ANOMALY)"
    log_message "Java Executor: $JAVA_DIR"
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

    # Generate SQL file and execute via Java
    local sql_file
    sql_file=$(generate_hour5_sql)
    log_message ""

    execute_hour5_java "$sql_file"

    local TEST_END=$(date +%s)
    local TOTAL_DURATION=$((TEST_END - TEST_START))
    local MINUTES=$((TOTAL_DURATION / 60))
    local SECONDS=$((TOTAL_DURATION % 60))

    log_message ""
    log_message "============================================================================"
    log_message "Anomaly Account Takeover Test Complete!"
    log_message "============================================================================"
    log_message "Total Queries: 500 (100 per object × 5 objects)"
    log_message "Total Duration: ${MINUTES}m ${SECONDS}s"
    log_message "============================================================================"
    log_message ""
    log_message "COMPLETE: Baseline (200 selects on object1) + Anomaly (500 selects on all 5 objects)"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Anomaly Account Takeover Test in Background"
echo "============================================================================"
echo "Unique ID: $UNIQUE_ID"
echo "Database: $DB_NAME"
echo "User: $DB_USER"
echo "Background Log: $BACKGROUND_LOG"
echo "Java Executor: $JAVA_DIR"
echo "============================================================================"
echo ""
echo "To monitor: tail -f $BACKGROUND_LOG"
echo "To stop: pkill -f ANOMALY_SCRIPT_NAME"
echo "============================================================================"

# Export all variables and run in background
export DB_HOST DB_PORT DB_USER USER_PASSWORD DB_NAME UNIQUE_ID SCRIPT_DIR LOG_DIR MAIN_LOG BACKGROUND_LOG JAVA_DIR

nohup bash -c '
    # Re-import all variables
    DB_HOST="'"$DB_HOST"'"
    DB_PORT="'"$DB_PORT"'"
    DB_USER="'"$DB_USER"'"
    USER_PASSWORD="'"$USER_PASSWORD"'"
    DB_NAME="'"$DB_NAME"'"
    UNIQUE_ID="'"$UNIQUE_ID"'"
    SCRIPT_DIR="'"$SCRIPT_DIR"'"
    LOG_DIR="'"$LOG_DIR"'"
    MAIN_LOG="'"$MAIN_LOG"'"
    JAVA_DIR="'"$JAVA_DIR"'"

    # Define all functions
    '"$(declare -f log_message)"'
    '"$(declare -f generate_hour5_sql)"'
    '"$(declare -f execute_hour5_java)"'
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

# Replace placeholders in anomaly script
sed -i.bak "s|ANOMALY_SCRIPT_NAME|$ANOMALY_SCRIPT|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|GENERATION_TIME|$(date '+%Y-%m-%d %H:%M:%S')|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|UNIQUE_ID_VALUE|$UNIQUE_ID|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_HOST_VALUE|$DB_HOST|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_PORT_VALUE|$DB_PORT|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|DB_USER_VALUE|$DB_USER|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
sed -i.bak "s|USER_PASSWORD_VALUE|$USER_PASSWORD|g" "$SCRIPT_DIR/$ANOMALY_SCRIPT"
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
echo "IMPORTANT: The anomaly script uses Java JDBC executor."
echo "  Ensure java_executor/ folder contains:"
echo "    - MySQLSQLExecutor.class (or MySQLSQLExecutor.java + compile.sh)"
echo "    - mysql-connector-j-8.0.33.jar"
echo "    - run.sh"
echo ""
echo "Monitor baseline: tail -f $SCRIPT_DIR/logs/baseline_${UNIQUE_ID}_background.log"
echo "Monitor anomaly:  tail -f $SCRIPT_DIR/logs/anomaly_${UNIQUE_ID}_background.log"
echo ""
echo "Logs will be in: $SCRIPT_DIR/logs/"
echo "============================================================================"

# Made with Bob