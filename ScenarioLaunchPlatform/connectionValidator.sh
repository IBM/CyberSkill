#!/usr/bin/env bash

# --- SEQUENTIAL CALLS---

# Paths to the two must-run scripts
SCRIPT_BASE="/opt/slp/scripts/ubuntu/db2"
FIRST_SCRIPT="${SCRIPT_BASE}/db2_getDatabaseConnections.sh"
SECOND_SCRIPT="${SCRIPT_BASE}/db2_getValidatedDatabaseConnections.sh"

echo " Running: $FIRST_SCRIPT"
bash "$FIRST_SCRIPT"

sleep 2  # wait 2 seconds

echo " Running: $SECOND_SCRIPT"
bash "$SECOND_SCRIPT"