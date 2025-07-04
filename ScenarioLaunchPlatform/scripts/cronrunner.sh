#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

BASE_DIR="/opt/slp/scripts"
LOG_FILE="$BASE_DIR/cron_script.log"

# Change to the base directory (optional but safe)
cd "$BASE_DIR" || exit 1

# Find and execute all .sh files in subdirectories (excluding BASE_DIR itself)
find "$BASE_DIR" -mindepth 2 -type f -name "*.sh" | while read -r script; do
    echo "[$(date)] Executing: $script"
    chmod +x "$script"
    "$script"
done