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
    echo "  - baseline_TIMESTAMP.sh (Hours 1-4: 50 inserts/hour)"
    echo "  - anomaly_TIMESTAMP.sh (Hour 5: 1001 inserts)"
    echo "  Both scripts will use the same user and database"
    exit 1
fi

DB_HOST="$1"
DB_PORT="$2"
ROOT_PASSWORD="$3"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Generate unique identifier
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
UNIQUE_ID="insert_${TIMESTAMP}"

# Generate unique user and database names
DB_USER="${UNIQUE_ID}_user"
DB_USER_PASSWORD="InsertPass_${TIMESTAMP}_$(openssl rand -hex 4 2>/dev/null || echo 'default')"
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
# Purpose: Run INSERT operations for baseline creation (Hours 1-4)
# Pattern: 50 inserts/hour for 4 hours
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

# Function to execute INSERT commands
execute_inserts() {
    local num_inserts="$1"
    local hour_num="$2"
    local batch_log="$LOG_DIR/baseline_${UNIQUE_ID}_hour_${hour_num}.log"

    log_message "Hour ${hour_num}: Executing ${num_inserts} INSERT commands as user '$DB_USER'..."

    # Create table if not exists
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" > "$batch_log" 2>&1 <<EOF
CREATE TABLE IF NOT EXISTS insert_test_data (
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

SELECT CONCAT('Table ready for inserts') AS Status;
EOF

    local start_time=$(date +%s)
    local failed_inserts=0

    # Execute INSERT commands
    for i in $(seq 1 $num_inserts); do
        local insert_type=$((i % 5))

        case $insert_type in
            0)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount)
VALUES ($i, 'Data for record $i', 'category_A', $(echo "scale=2; $i * 1.5" | bc));
EOF
                ;;
            1)
                local cat_num=$((i % 5 + 1))
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount, status)
VALUES ($i, 'Category $cat_num data', 'category_$cat_num', $(echo "scale=2; $i * 2.0" | bc), 'pending');
EOF
                ;;
            2)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category)
VALUES ($i, 'Minimal data $i', NULL);
EOF
                ;;
            3)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount, status)
VALUES ($i, CONCAT('Generated data ', NOW()), 'category_B', RAND() * 1000, 'completed');
EOF
                ;;
            4)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount) VALUES
($i, 'Batch insert row 1', 'category_C', $(echo "scale=2; $i * 0.5" | bc)),
($(($i + 10000)), 'Batch insert row 2', 'category_C', $(echo "scale=2; $i * 0.75" | bc)),
($(($i + 20000)), 'Batch insert row 3', 'category_C', $(echo "scale=2; $i * 1.0" | bc));
EOF
                ;;
        esac

        local mysql_exit=$?
        if [ $mysql_exit -ne 0 ]; then
            ((failed_inserts++))
        fi

        # Show progress every 50 inserts
        if [ $((i % 50)) -eq 0 ]; then
            log_message "  Progress: ${i}/${num_inserts} inserts executed..."
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local successful_inserts=$((num_inserts - failed_inserts))

    # Verify and show statistics
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
SELECT CONCAT('Hour ${hour_num}: ${num_inserts} INSERT commands completed') AS Result;
SELECT
    COUNT(*) as total_records,
    COUNT(DISTINCT category) as distinct_categories,
    COUNT(DISTINCT status) as distinct_statuses,
    MIN(amount) as min_amount,
    MAX(amount) as max_amount,
    AVG(amount) as avg_amount
FROM insert_test_data;
EOF

    if [ $failed_inserts -eq 0 ]; then
        log_message "  ✓ Hour ${hour_num}: ${num_inserts} inserts completed successfully in ${duration} seconds"
        return 0
    else
        log_message "  ⚠ Hour ${hour_num}: ${successful_inserts}/${num_inserts} inserts succeeded, ${failed_inserts} failed in ${duration} seconds (check $batch_log)"
        return 1
    fi
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Baseline INSERT Operations (Hours 1-4)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Pattern: 50 inserts/hour for 4 hours (BASELINE)"
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

        execute_inserts 50 "$hour"

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
    log_message "Baseline INSERT Operations Complete!"
    log_message "============================================================================"
    log_message "Total Batches: 4"
    log_message "Total INSERTs: 200 (baseline)"
    log_message "Total Duration: ${hours}h ${minutes}m ${seconds}s"
    log_message "============================================================================"
    log_message ""
    log_message "NEXT STEP: Run the anomaly script to create the spike (Hour 5):"
    log_message "  ./ANOMALY_SCRIPT_NAME"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Baseline INSERT Operations in Background"
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
    '"$(declare -f execute_inserts)"'
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
# Purpose: Run INSERT operations for anomaly creation (Hour 5)
# Pattern: 1001 inserts in hour 5 (SPIKE)
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

# Function to execute INSERT commands
execute_inserts() {
    local num_inserts="$1"
    local batch_log="$LOG_DIR/anomaly_${UNIQUE_ID}_hour_5.log"

    log_message "Hour 5: Executing ${num_inserts} INSERT commands as user '$DB_USER' (SPIKE!)..."

    # Ensure table exists (baseline should have created it, but just in case)
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" > "$batch_log" 2>&1 <<EOF
CREATE TABLE IF NOT EXISTS insert_test_data (
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

SELECT CONCAT('Table ready for anomaly inserts') AS Status;
EOF

    local start_time=$(date +%s)
    local failed_inserts=0

    # Execute INSERT commands
    for i in $(seq 1 $num_inserts); do
        local insert_type=$((i % 5))

        case $insert_type in
            0)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount)
VALUES ($i, 'Data for record $i', 'category_A', $(echo "scale=2; $i * 1.5" | bc));
EOF
                ;;
            1)
                local cat_num=$((i % 5 + 1))
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount, status)
VALUES ($i, 'Category $cat_num data', 'category_$cat_num', $(echo "scale=2; $i * 2.0" | bc), 'pending');
EOF
                ;;
            2)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category)
VALUES ($i, 'Minimal data $i', NULL);
EOF
                ;;
            3)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount, status)
VALUES ($i, CONCAT('Generated data ', NOW()), 'category_B', RAND() * 1000, 'completed');
EOF
                ;;
            4)
                mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
INSERT INTO insert_test_data (record_number, data, category, amount) VALUES
($i, 'Batch insert row 1', 'category_C', $(echo "scale=2; $i * 0.5" | bc)),
($(($i + 10000)), 'Batch insert row 2', 'category_C', $(echo "scale=2; $i * 0.75" | bc)),
($(($i + 20000)), 'Batch insert row 3', 'category_C', $(echo "scale=2; $i * 1.0" | bc));
EOF
                ;;
        esac

        local mysql_exit=$?
        if [ $mysql_exit -ne 0 ]; then
            ((failed_inserts++))
        fi

        # Show progress every 50 inserts
        if [ $((i % 50)) -eq 0 ]; then
            log_message "  Progress: ${i}/${num_inserts} inserts executed..."
        fi
    done

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local successful_inserts=$((num_inserts - failed_inserts))

    # Verify and show statistics
    mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_USER_PASSWORD" "$DB_NAME" >> "$batch_log" 2>&1 <<EOF
SELECT CONCAT('Hour 5: ${num_inserts} INSERT commands completed (SPIKE!)') AS Result;
SELECT
    COUNT(*) as total_records,
    COUNT(DISTINCT category) as distinct_categories,
    COUNT(DISTINCT status) as distinct_statuses,
    MIN(amount) as min_amount,
    MAX(amount) as max_amount,
    AVG(amount) as avg_amount
FROM insert_test_data;
EOF

    if [ $failed_inserts -eq 0 ]; then
        log_message "  ✓ Hour 5: ${num_inserts} inserts completed successfully in ${duration} seconds (SPIKE!)"
        return 0
    else
        log_message "  ⚠ Hour 5: ${successful_inserts}/${num_inserts} inserts succeeded, ${failed_inserts} failed in ${duration} seconds (check $batch_log)"
        return 1
    fi
}

# Main execution function
main_execution() {
    log_message "============================================================================"
    log_message "Anomaly INSERT Operations (Hour 5 - SPIKE)"
    log_message "============================================================================"
    log_message "Unique ID: $UNIQUE_ID"
    log_message "Host: $DB_HOST"
    log_message "Port: $DB_PORT"
    log_message "Database: $DB_NAME"
    log_message "User: $DB_USER"
    log_message "Pattern: 1001 inserts in hour 5 (ANOMALY SPIKE)"
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
    log_message "Hour 5 of 5 (ANOMALY SPIKE - 1001 INSERTS)"
    log_message "========================================================================"

    execute_inserts 1001

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))

    log_message ""
    log_message "============================================================================"
    log_message "Anomaly INSERT Operations Complete!"
    log_message "============================================================================"
    log_message "Total INSERTs: 1001 (SPIKE)"
    log_message "Total Duration: ${minutes}m ${seconds}s"
    log_message "============================================================================"
    log_message ""
    log_message "COMPLETE: Baseline (200 inserts) + Anomaly (1001 inserts) = 1201 total"
    log_message "============================================================================"
}

# Always run in background
echo "============================================================================"
echo "Starting Anomaly INSERT Operations in Background"
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
    '"$(declare -f execute_inserts)"'
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