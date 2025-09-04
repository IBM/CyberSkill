#!/bin/bash

# Description:
#   Kill all idle PostgreSQL connections from localhost on PostgreSQL 14 (or any version)

# --- CONFIGURATION ---
PGUSER="postgres"         # PostgreSQL superuser
PGDATABASE="slp"     # DB to connect to
PGSOCKET="/var/run/postgresql"  # Default location
IDLE_MINUTES=1            # Only kill if idle for more than X minutes

# --- EXECUTION ---
echo "Finding idle PostgreSQL connections older than ${IDLE_MINUTES} minutes..."

sudo -u postgres psql <<EOF
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle'
  AND now() - state_change > interval '${IDLE_MINUTES} minutes'
  AND usename = 'postgres'
  AND client_addr = '127.0.0.1'
  AND pid <> pg_backend_pid();

EOF
