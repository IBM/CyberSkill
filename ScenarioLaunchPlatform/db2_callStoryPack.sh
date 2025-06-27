#!/usr/bin/env bash



# Paths to the base
SCRIPT_BASE="/opt/slp/scripts/ubuntu/db2"


# --- RANDOM CALLS ---

# Available datasources (users)
DATASOURCES=(
  "db2_localhost_crm_polly"
  "db2_localhost_crm_liher"
  "db2_localhost_crm_jason"
  "db2_localhost_crm_john"
)

# List of insert scripts
INSERT_SCRIPTS=(
"db2_insert_into_crm.tbl_calls.sh"
"db2_insert_into_crm.tbl_email_lists.sh"
"db2_insert_into_crm.tbl_product.sh"
"db2_select_from_crm.tbl_bugs.sh"
"db2_select_from_crm.tbl_calls.sh"
"db2_select_from_crm.tbl_crm_accounts.sh"
"db2_select_from_crm.tbl_crm_accounts_status.sh"
"db2_select_from_crm.tbl_email_lists.sh"
"db2_select_from_crm.tbl_marketing_campaign.sh"
"db2_select_from_crm.tbl_marketing_template.sh"
"db2_select_from_crm.tbl_product.sh"
"db2_update_crm.tbl_product.sh"
"db2_insert_into_crm.tbl_crm_accounts.sh"
)

# Run each insert script once with a randomly chosen datasource
for SCRIPT_NAME in "${INSERT_SCRIPTS[@]}"; do
  RANDOM_USER="${DATASOURCES[$RANDOM % ${#DATASOURCES[@]}]}"
  FULL_SCRIPT_PATH="${SCRIPT_BASE}/${SCRIPT_NAME}"
   echo " Running $SCRIPT_NAME with user: $RANDOM_USER"
  sudo bash "$FULL_SCRIPT_PATH" "$RANDOM_USER"
  sleep 2
done
