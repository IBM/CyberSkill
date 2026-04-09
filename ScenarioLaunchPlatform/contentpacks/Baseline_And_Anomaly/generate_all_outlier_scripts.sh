#!/bin/bash

################################################################################
# Master Script: Generate All Outlier Baseline/Anomaly Scripts
################################################################################
# This script calls all generate_scripts.sh files in the outlier folders
# and passes the same host, port, and password to each one.
#
# Usage:
#   ./generate_all_outlier_scripts.sh <host> <port> <root_password>
#
# Example:
#   ./generate_all_outlier_scripts.sh localhost 3306 MyRootPassword123
################################################################################

# Check arguments
if [ "$#" -ne 3 ]; then
    echo "============================================================================"
    echo "ERROR: Invalid number of arguments"
    echo "============================================================================"
    echo ""
    echo "Usage: $0 <host> <port> <root_password>"
    echo ""
    echo "Example:"
    echo "  $0 localhost 3306 MyRootPassword123"
    echo ""
    echo "This will generate baseline and anomaly scripts for all 6 outlier types:"
    echo "  1. Account Takeover"
    echo "  2. Data Tampering"
    echo "  3. Denial of Service"
    echo "  4. INSERT Anomaly"
    echo "  5. Massive GRANT"
    echo "  6. Schema Tampering"
    echo ""
    exit 1
fi

# Get parameters
HOST="$1"
PORT="$2"
ROOT_PASSWORD="$3"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "============================================================================"
echo "Master Script: Generate All Outlier Baseline/Anomaly Scripts"
echo "============================================================================"
echo "Host: $HOST"
echo "Port: $PORT"
echo "Password: [HIDDEN]"
echo "Script Directory: $SCRIPT_DIR"
echo "============================================================================"
echo ""

# Array of outlier folders
OUTLIER_FOLDERS=(
    "outlier_account_take_over_split_mysql"
    "outlier_data_tampering_split_mysql"
    "outlier_denial_of_service_split_mysql"
    "outlier_insert_anomaly_split_mysql"
    "outlier_massive_grant_split_mysql"
    "outlier_schema_tampering_split_mysql"
)

# Counter for success/failure
SUCCESS_COUNT=0
FAILURE_COUNT=0
TOTAL_COUNT=${#OUTLIER_FOLDERS[@]}

# Loop through each folder and run generate_scripts.sh
for FOLDER in "${OUTLIER_FOLDERS[@]}"; do
    FOLDER_PATH="$SCRIPT_DIR/$FOLDER"
    GENERATE_SCRIPT="$FOLDER_PATH/generate_scripts.sh"
    
    echo "----------------------------------------------------------------------------"
    echo "Processing: $FOLDER"
    echo "----------------------------------------------------------------------------"
    
    # Check if folder exists
    if [ ! -d "$FOLDER_PATH" ]; then
        echo "❌ ERROR: Folder not found: $FOLDER_PATH"
        ((FAILURE_COUNT++))
        echo ""
        continue
    fi
    
    # Check if generate_scripts.sh exists
    if [ ! -f "$GENERATE_SCRIPT" ]; then
        echo "❌ ERROR: generate_scripts.sh not found in: $FOLDER_PATH"
        ((FAILURE_COUNT++))
        echo ""
        continue
    fi
    
    # Make script executable
    chmod +x "$GENERATE_SCRIPT"
    
    # Change to the folder directory
    cd "$FOLDER_PATH" || {
        echo "❌ ERROR: Cannot change to directory: $FOLDER_PATH"
        ((FAILURE_COUNT++))
        echo ""
        continue
    }
    
    # Run the generate_scripts.sh
    echo "Running: ./generate_scripts.sh $HOST $PORT [PASSWORD]"
    if ./generate_scripts.sh "$HOST" "$PORT" "$ROOT_PASSWORD"; then
        echo "✅ SUCCESS: Scripts generated for $FOLDER"
        ((SUCCESS_COUNT++))
    else
        echo "❌ FAILED: Script generation failed for $FOLDER"
        ((FAILURE_COUNT++))
    fi
    
    # Return to script directory
    cd "$SCRIPT_DIR" || exit 1
    
    echo ""
done

# Summary
echo "============================================================================"
echo "SUMMARY"
echo "============================================================================"
echo "Total Outlier Types: $TOTAL_COUNT"
echo "Successful: $SUCCESS_COUNT"
echo "Failed: $FAILURE_COUNT"
echo "============================================================================"
echo ""

if [ $FAILURE_COUNT -eq 0 ]; then
    echo "✅ All outlier scripts generated successfully!"
    echo ""
    echo "Next Steps:"
    echo "1. Review the generated baseline_*.sh and anomaly_*.sh scripts in each folder"
    echo "2. Run baseline scripts first (they create databases and users)"
    echo "3. After baseline completes, run corresponding anomaly scripts"
    echo ""
    echo "Example:"
    echo "  cd outlier_account_take_over_split_mysql"
    echo "  ./baseline_TIMESTAMP.sh"
    echo "  # Wait for baseline to complete (4 hours)"
    echo "  ./anomaly_TIMESTAMP.sh"
    echo ""
    exit 0
else
    echo "⚠️  Some script generations failed. Please check the errors above."
    exit 1
fi

# Made with Bob
