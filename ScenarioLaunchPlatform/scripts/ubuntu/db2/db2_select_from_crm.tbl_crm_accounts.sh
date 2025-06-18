#!/usr/bin/env bash
# db2_select_from_crm.tbl_crm_accounts <datasource> — POST a SQL query to the datasource API
# Example: ./db2_select_from_crm.tbl_crm_accounts db2_localhost_crm_polly

set -euo pipefail

###############################################################################
# 1. Argument check
###############################################################################
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <datasource>"
  exit 1
fi
DATASOURCE="$1"
# echo "ID: $ID"
###############################################################################
# 2. Build JSON payload safely (cat <<'EOF' keeps literal quotes)
###############################################################################
PAYLOAD=$(cat <<EOF
{
  "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
  "datasource": "${DATASOURCE}",
  "query_loop": 1,
  "sql": "SELECT id, name, status, date_entered FROM crm.tbl_crm_accounts WHERE status < {INT} ORDER BY date_entered DESC FETCH FIRST {INT} ROWS ONLY;"
  }
EOF
)
# echo "Payload: $PAYLOAD"
###############################################################################
# 3. Call curl and log everything
###############################################################################
{
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
  curl --silent --show-error --location --request POST \
       'http://127.0.0.1:80/api/runDatabaseQueryByDatasourceMap' \
       --header 'Content-Type: application/json' \
       --data-raw "${PAYLOAD}"
  echo -e "\n"  # neat blank line between entries
} | tee -a db2_run_query.log