#!/usr/bin/env bash
# runById.sh <datasource> <id> — POST a SQL query to the datasource API
# runById.sh with no parameters will randomly pick from a list of datasources and ids.
# Example: ./runById sqlserver_10.10.9.59_crm_polly 1212

set -euo pipefail

# Predefined list of datasources and IDs
DATASOURCES=("sqlserver_10.10.9.59_crm_liher" "sqlserver_10.10.9.59_crm_polly" "sqlserver_10.10.9.59_crm_john" "sqlserver_10.10.9.59_crm_jason")
IDS=("1215" "1216" "1217" "1218" "1219" "1220" "1221" "1222" "1223" "1224" "1225" "1226" "1227" "1228")

###############################################################################
# 1. Argument check or random fallback
###############################################################################
if [[ $# -ne 2 ]]; then
  echo "No or insufficient arguments provided. Picking random values..."
  DATASOURCE=$(shuf -n1 -e "${DATASOURCES[@]}")
  ID=$(shuf -n1 -e "${IDS[@]}")
  echo "Using random datasource: $DATASOURCE"
  echo "Using random ID: $ID"
else
  DATASOURCE="$1"
  ID="$2"
fi

###############################################################################
# 2. Build JSON payload safely
###############################################################################
PAYLOAD=$(cat <<EOF
{
  "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
  "datasource": "${DATASOURCE}",
  "queryId": "${ID}"
}
EOF
)

###############################################################################
# 3. Call curl and log everything
###############################################################################
{
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
  curl --silent --show-error --location --request POST \
       'http://192.168.100.16:80/api/runDatabaseQueryByDatasourceMapAndQueryId' \
       --header 'Content-Type: application/json' \
       --data-raw "${PAYLOAD}"
  echo -e "\n"  # neat blank line between entries
} | tee -a /var/log/slp_sqlserver_run_query.log
