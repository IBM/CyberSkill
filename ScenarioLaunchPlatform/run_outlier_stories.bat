@echo off
REM Batch script to run all stories (excluding Quick Demo) via SLP API
REM Author: Bob
REM This script fetches all stories and runs those WITHOUT "Quick Demo" in their name

SETLOCAL EnableDelayedExpansion

REM ========================================
REM Configuration
REM ========================================
SET SLP_HOST=localhost
SET SLP_PORT=8888
SET BASE_URL=http://%SLP_HOST%:%SLP_PORT%
SET LOG_FILE=outlier_stories_run.log

REM JWT Token - Replace with your actual token
SET JWT_TOKEN=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdXRobGV2ZWwiOiIxIiwidXNlcm5hbWUiOiJhZG1pbiIsImlhdCI6MTc3MTI3OTc4NywiZXhwIjoxNzcxMzM5Nzg3fQ.U8ERo1pWV95AApIUL-m4ZscnehiBuRVujIOdeAsv17I

REM Temporary files
SET TEMP_STORIES=temp_stories.json
SET TEMP_RESPONSE=temp_response.json

echo ========================================
echo SLP Stories Runner (Excluding Quick Demo)
echo ========================================
echo Timestamp: %date% %time%
echo Base URL: %BASE_URL%
echo Log File: %LOG_FILE%
echo ========================================
echo.

REM Log script start
echo. >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%
echo [%date% %time%] Script started >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%

REM Check if curl is available
where curl >nul 2>&1
if errorlevel 1 (
    echo ERROR: curl is not installed or not in PATH
    echo [%date% %time%] ERROR: curl not found >> %LOG_FILE%
    pause
    exit /b 1
)
echo curl found
echo [%date% %time%] curl verified >> %LOG_FILE%

REM ========================================
REM Step 1: Get all stories
REM ========================================
echo.
echo Step 1: Fetching all stories from SLP...
echo [%date% %time%] Fetching all stories >> %LOG_FILE%

curl -s -X POST "%BASE_URL%/api/getAllStories" ^
  -H "Content-Type: application/json" ^
  -d "{\"jwt\":\"%JWT_TOKEN%\"}" ^
  -o %TEMP_STORIES%

if errorlevel 1 (
    echo ERROR: Failed to fetch stories
    echo [%date% %time%] ERROR: Failed to fetch stories >> %LOG_FILE%
    pause
    exit /b 1
)

REM Check if response file exists and has content
if not exist %TEMP_STORIES% (
    echo ERROR: No response received from server
    echo [%date% %time%] ERROR: No response file created >> %LOG_FILE%
    pause
    exit /b 1
)

echo Stories fetched successfully
echo [%date% %time%] Stories fetched successfully >> %LOG_FILE%

REM ========================================
REM Step 2: Parse and run stories (excluding Quick Demo)
REM ========================================
echo.
echo Step 2: Parsing stories and running all stories (excluding Quick Demo)...
echo [%date% %time%] Parsing stories >> %LOG_FILE%

REM Use PowerShell to parse JSON and extract story IDs WITHOUT "Quick Demo" in name
powershell -Command "$stories = Get-Content '%TEMP_STORIES%' | ConvertFrom-Json; $count = 0; $skipped = 0; foreach ($story in $stories) { if ($story.story -and $story.story.name) { if ($story.story.name -notmatch 'Quick Demo') { $count++; Write-Host \"Running story: ID=$($story.id) Name=$($story.story.name)\"; Add-Content '%LOG_FILE%' \"[%date% %time%] Running story: ID=$($story.id) Name=$($story.story.name)\"; $body = @{jwt='%JWT_TOKEN%'; id=$story.id} | ConvertTo-Json; try { $response = Invoke-RestMethod -Uri '%BASE_URL%/api/runStoryById' -Method Post -Body $body -ContentType 'application/json'; Write-Host \"  -> Story $($story.id) execution started successfully\"; Add-Content '%LOG_FILE%' \"[%date% %time%] Story $($story.id) execution started successfully\"; Start-Sleep -Seconds 2 } catch { Write-Host \"  -> ERROR running story $($story.id): $($_.Exception.Message)\"; Add-Content '%LOG_FILE%' \"[%date% %time%] ERROR running story $($story.id): $($_.Exception.Message)\" } } else { $skipped++; Write-Host \"Skipping Quick Demo story: ID=$($story.id) Name=$($story.story.name)\"; Add-Content '%LOG_FILE%' \"[%date% %time%] Skipped Quick Demo story: ID=$($story.id) Name=$($story.story.name)\" } } }; Write-Host \"`nSummary:\"; Write-Host \"  Stories executed: $count\"; Write-Host \"  Stories skipped (Quick Demo): $skipped\"; Add-Content '%LOG_FILE%' \"[%date% %time%] Summary: $count stories executed, $skipped skipped\""

if errorlevel 1 (
    echo WARNING: Some stories may have failed to run
    echo [%date% %time%] WARNING: Some stories may have failed >> %LOG_FILE%
)

REM ========================================
REM Cleanup
REM ========================================
echo.
echo Cleaning up temporary files...
if exist %TEMP_STORIES% del %TEMP_STORIES%
if exist %TEMP_RESPONSE% del %TEMP_RESPONSE%

echo.
echo ========================================
echo Script completed
echo ========================================
echo Check %LOG_FILE% for detailed execution log
echo.
echo [%date% %time%] Script completed >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%

ENDLOCAL
pause

@REM Made with Bob
