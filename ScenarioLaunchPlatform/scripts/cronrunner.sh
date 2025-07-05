#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

BASE_DIR="/opt/slp/scripts"
LOG_FILE="/var/log/slp_cron_script.log"

cd "$BASE_DIR" || exit 1

###############################################################################
# 1. Run predefined scripts: a.sh and b.sh
###############################################################################
for SCRIPT_NAME in getDatabaseConnections.sh getValidatedDatabaseConnections.sh; do
    if [[ -f "$BASE_DIR/$SCRIPT_NAME" ]]; then
        echo "[$(date)] Executing predefined script: $SCRIPT_NAME" | tee -a "$LOG_FILE"
        chmod +x "$BASE_DIR/$SCRIPT_NAME"
        "$BASE_DIR/$SCRIPT_NAME" >> "$LOG_FILE" 2>&1
        sleep 2
    else
        echo "[$(date)] Predefined script not found: $SCRIPT_NAME" | tee -a "$LOG_FILE"
    fi
done

###############################################################################
# 2. Find and run a random subfolder script (one level deep)
###############################################################################
SCRIPTS=($(find "$BASE_DIR" -mindepth 2 -maxdepth 2 -type f -name "*.sh"))

if [[ ${#SCRIPTS[@]} -eq 0 ]]; then
    echo "[$(date)] No scripts found in subfolders to execute." | tee -a "$LOG_FILE"
    exit 0
fi

SELECTED_SCRIPT=$(shuf -n1 -e "${SCRIPTS[@]}")
RUN_COUNT=$((RANDOM % 20 + 1))

echo "[$(date)] Selected script from subfolders: $SELECTED_SCRIPT — Will run $RUN_COUNT times" | tee -a "$LOG_FILE"

chmod +x "$SELECTED_SCRIPT"

for ((i=1; i<=RUN_COUNT; i++)); do
    echo "[$(date)] Run #$i of $SELECTED_SCRIPT" | tee -a "$LOG_FILE"
    "$SELECTED_SCRIPT" >> "$LOG_FILE" 2>&1
    sleep 2
done
