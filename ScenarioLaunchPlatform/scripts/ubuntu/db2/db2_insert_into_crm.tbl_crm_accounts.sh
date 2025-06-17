#!/usr/bin/env bash
# db2_insert_into_crm.tbl_crm_accounts.sh — POST a SQL query to the datasource API
# Example: ./db2_insert_into_crm.tbl_crm_accounts.sh df61978a-f4cc-ff64-8de0-53e90f19a56b

set -euo pipefail

###############################################################################
# 1. Argument check
###############################################################################
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <account_uuid>"
  exit 1
fi
ID="$1"
# echo "ID: $ID"
###############################################################################
# 2. Dynamic values
###############################################################################
DATE_NOW=$(date '+%Y-%m-%d %H:%M:%S')        # e.g. 2025-06-17 14:23:45
# echo "DATE_NOW: $DATE_NOW"

# Use C locale so {A..Z} works the same everywhere
NAME=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8 || true)
# echo "NAME: $NAME"

###############################################################################
# 3. Build JSON payload safely (cat <<'EOF' keeps literal quotes)
###############################################################################
PAYLOAD=$(cat <<EOF
{
  "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MSwiZmlyc3RuYW1lIjoiamFzb24iLCJzdXJuYW1lIjoiZmxvb2QiLCJlbWFpbCI6Imphc29uLmZsb29kQGVtYWlsLmNvbSIsInVzZXJuYW1lIjoibXl1c2VybmFtZSIsImFjdGl2ZSI6IjEiLCJhdXRobGV2ZWwiOjEsImlhdCI6MTczMzkxMzU1NywiZXhwIjoxNzMzOTEzNjE3fQ.mvDvSanNTCvN5puizSme7URjPbhWOkRfW3ZioUWz174",
  "datasource": "db2_localhost_crm_polly",
  "query_loop": 1,
  "sql": "INSERT INTO crm.tbl_crm_accounts (Id, Name, Date_entered, Date_modified, Modified_user_id, Created_by, Description, Deleted, Assigned_user_id, Account_type, Industry, Annual_revenue, Phone_fax, Billing_address_street, Billing_address_city, Billing_address_state, Billing_address_postalcode, Billing_address_country, Rating, Phone_office, Phone_alternate, Website, Ownership, Employees, Ticker_symbol, Shipping_address_street, Shipping_address_city, Shipping_address_state, Shipping_address_postalcode, Shipping_address_country, Parent_id, Sic_code, Campaign_id, Status) VALUES ('${ID}', '${NAME}', '${DATE_NOW}', '${DATE_NOW}', 'seed_will_id', '1', NULL, 0, 'seed_max_id', 'Customer', 'Technology', NULL, NULL, '1715 Scott Dr', 'Alabama', 'CA', '14882', 'USA', NULL, '(847) 706-6877', NULL, 'www.devim.edu', NULL, NULL, NULL, '1715 Scott Dr', 'Alabama', 'CA', '14882', 'USA', NULL, NULL, NULL, '1');"
  }
EOF
)

# echo "Payload: $PAYLOAD"

###############################################################################
# 4. Call curl and log everything
###############################################################################
{
  echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="
  echo "ID=$ID, NAME=$NAME"
  curl --silent --show-error --location --request POST \
       'http://127.0.0.1:80/api/runDatabaseQueryByDatasourceMap' \
       --header 'Content-Type: application/json' \
       --data-raw "${PAYLOAD}"
  echo -e "\n"  # neat blank line between entries
} | tee -a db2_run_query.log