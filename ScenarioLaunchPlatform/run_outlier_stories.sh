#!/bin/bash
# Bash script to run all stories (excluding Quick Demo) via SLP API
# Author: Bob
# This script fetches all stories and runs those WITHOUT "Quick Demo" in their name

# ========================================
# Configuration
# ========================================
SLP_HOST="localhost"
SLP_PORT="8888"
BASE_URL="http://${SLP_HOST}:${SLP_PORT}"
LOG_FILE="outlier_stories_run.log"

# JWT Token - Replace with your actual token
JWT_TOKEN="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdXRobGV2ZWwiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsImlhdCI6MTc3MTI3OTc4NywiZXhwIjoxNzcxMzM5Nzg3fQ.U8ERo1pWV95AApIUL-m4ZscnehiBuRVujIOdeAsv17I"

# Temporary files
TEMP_STORIES="temp_stories.json"
TEMP_RESPONSE="temp_response.json"

echo "========================================"
echo "SLP Stories Runner (Excluding Quick Demo)"
echo "========================================"
echo "Timestamp: $(date)"
echo "Base URL: ${BASE_URL}"
echo "Log File: ${LOG_FILE}"
echo "========================================"
echo ""

# Log script start
echo "" >> "${LOG_FILE}"
echo "========================================" >> "${LOG_FILE}"
echo "[$(date)] Script started" >> "${LOG_FILE}"
echo "========================================" >> "${LOG_FILE}"

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "ERROR: curl is not installed or not in PATH"
    echo "[$(date)] ERROR: curl not found" >> "${LOG_FILE}"
    exit 1
fi
echo "curl found"
echo "[$(date)] curl verified" >> "${LOG_FILE}"

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "ERROR: jq is not installed or not in PATH"
    echo "Please install jq: sudo apt-get install jq (Ubuntu/Debian) or brew install jq (macOS)"
    echo "[$(date)] ERROR: jq not found" >> "${LOG_FILE}"
    exit 1
fi
echo "jq found"
echo "[$(date)] jq verified" >> "${LOG_FILE}"

# ========================================
# Step 1: Get all stories
# ========================================
echo ""
echo "Step 1: Fetching all stories from SLP..."
echo "[$(date)] Fetching all stories" >> "${LOG_FILE}"

curl -s -X POST "${BASE_URL}/api/getAllStories" \
  -H "Content-Type: application/json" \
  -d "{\"jwt\":\"${JWT_TOKEN}\"}" \
  -o "${TEMP_STORIES}"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to fetch stories"
    echo "[$(date)] ERROR: Failed to fetch stories" >> "${LOG_FILE}"
    exit 1
fi

# Check if response file exists and has content
if [ ! -f "${TEMP_STORIES}" ]; then
    echo "ERROR: No response received from server"
    echo "[$(date)] ERROR: No response file created" >> "${LOG_FILE}"
    exit 1
fi

echo "Stories fetched successfully"
echo "[$(date)] Stories fetched successfully" >> "${LOG_FILE}"

# ========================================
# Step 2: Parse and run stories (excluding Quick Demo)
# ========================================
echo ""
echo "Step 2: Parsing stories and running all stories (excluding Quick Demo)..."
echo "[$(date)] Parsing stories" >> "${LOG_FILE}"

# Initialize counters
count=0
skipped=0

# Parse JSON and iterate through stories
while IFS= read -r story; do
    story_id=$(echo "${story}" | jq -r '.id')
    story_name=$(echo "${story}" | jq -r '.story.name // empty')
    
    if [ -n "${story_name}" ]; then
        # Check if story name contains "Quick Demo"
        if [[ ! "${story_name}" =~ "Quick Demo" ]]; then
            ((count++))
            echo "Running story: ID=${story_id} Name=${story_name}"
            echo "[$(date)] Running story: ID=${story_id} Name=${story_name}" >> "${LOG_FILE}"
            
            # Run the story
            response=$(curl -s -X POST "${BASE_URL}/api/runStoryById" \
              -H "Content-Type: application/json" \
              -d "{\"jwt\":\"${JWT_TOKEN}\",\"id\":${story_id}}")
            
            if [ $? -eq 0 ]; then
                echo "  -> Story ${story_id} execution started successfully"
                echo "[$(date)] Story ${story_id} execution started successfully" >> "${LOG_FILE}"
            else
                echo "  -> ERROR running story ${story_id}"
                echo "[$(date)] ERROR running story ${story_id}" >> "${LOG_FILE}"
            fi
            
            # Wait 2 seconds between story executions
            sleep 2
        else
            ((skipped++))
            echo "Skipping Quick Demo story: ID=${story_id} Name=${story_name}"
            echo "[$(date)] Skipped Quick Demo story: ID=${story_id} Name=${story_name}" >> "${LOG_FILE}"
        fi
    fi
done < <(jq -c '.[]' "${TEMP_STORIES}")

echo ""
echo "Summary:"
echo "  Stories executed: ${count}"
echo "  Stories skipped (Quick Demo): ${skipped}"
echo "[$(date)] Summary: ${count} stories executed, ${skipped} skipped" >> "${LOG_FILE}"

# ========================================
# Cleanup
# ========================================
echo ""
echo "Cleaning up temporary files..."
[ -f "${TEMP_STORIES}" ] && rm "${TEMP_STORIES}"
[ -f "${TEMP_RESPONSE}" ] && rm "${TEMP_RESPONSE}"

echo ""
echo "========================================"
echo "Script completed"
echo "========================================"
echo "Check ${LOG_FILE} for detailed execution log"
echo ""
echo "[$(date)] Script completed" >> "${LOG_FILE}"
echo "========================================" >> "${LOG_FILE}"

# Made with Bob