#!/usr/bin/env bash
# runById.sh <datasource> <id>— POST a SQL query to the datasource API
# Example: ./runById mysql_localhost_crm_polly 12

set -euo pipefail

###############################################################################
# 1. Argument check
###############################################################################
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <datasource> $1 <id>"
  exit 1
fi
DATASOURCE="$1"
ID = "$2"



# echo "ID: $ID"
###############################################################################
# 2. Build JSON payload safely (cat <<'EOF' keeps literal quotes)
###############################################################################
PAYLOAD=$(cat <<EOF
{
  "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
  "datasource": "${DATASOURCE}",
  "queryId": "${ID}",
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
       'http://127.0.0.1:80/api/runDatabaseQueryByDatasourceMapAndQueryId' \
       --header 'Content-Type: application/json' \
       --data-raw "${PAYLOAD}"
  echo -e "\n"  # neat blank line between entries
} | tee -a /var/log/slp_mysql_run_query.log