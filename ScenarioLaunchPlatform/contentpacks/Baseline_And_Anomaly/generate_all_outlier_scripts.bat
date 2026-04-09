@echo off
REM ############################################################################
REM Master Script: Generate All Outlier Baseline/Anomaly Scripts (Windows)
REM ############################################################################
REM This script calls all generate_scripts.sh files in the outlier folders
REM and passes the same host, port, and password to each one.
REM
REM Usage:
REM   generate_all_outlier_scripts.bat <host> <port> <root_password>
REM
REM Example:
REM   generate_all_outlier_scripts.bat localhost 3306 MyRootPassword123
REM ############################################################################

setlocal enabledelayedexpansion

REM Check arguments
if "%~3"=="" (
    echo ============================================================================
    echo ERROR: Invalid number of arguments
    echo ============================================================================
    echo.
    echo Usage: %~nx0 ^<host^> ^<port^> ^<root_password^>
    echo.
    echo Example:
    echo   %~nx0 localhost 3306 MyRootPassword123
    echo.
    echo This will generate baseline and anomaly scripts for all 6 outlier types:
    echo   1. Account Takeover
    echo   2. Data Tampering
    echo   3. Denial of Service
    echo   4. INSERT Anomaly
    echo   5. Massive GRANT
    echo   6. Schema Tampering
    echo.
    exit /b 1
)

REM Get parameters
set HOST=%~1
set PORT=%~2
set ROOT_PASSWORD=%~3

REM Get the directory where this script is located
set SCRIPT_DIR=%~dp0
cd /d "%SCRIPT_DIR%"

echo ============================================================================
echo Master Script: Generate All Outlier Baseline/Anomaly Scripts
echo ============================================================================
echo Host: %HOST%
echo Port: %PORT%
echo Password: [HIDDEN]
echo Script Directory: %SCRIPT_DIR%
echo ============================================================================
echo.

REM Define outlier folders
set FOLDERS=outlier_account_take_over_split_mysql outlier_data_tampering_split_mysql outlier_denial_of_service_split_mysql outlier_insert_anomaly_split_mysql outlier_massive_grant_split_mysql outlier_schema_tampering_split_mysql

REM Counter for success/failure
set SUCCESS_COUNT=0
set FAILURE_COUNT=0
set TOTAL_COUNT=6

REM Loop through each folder and run generate_scripts.sh
for %%F in (%FOLDERS%) do (
    echo ----------------------------------------------------------------------------
    echo Processing: %%F
    echo ----------------------------------------------------------------------------
    
    REM Check if folder exists
    if not exist "%%F\" (
        echo ERROR: Folder not found: %%F
        set /a FAILURE_COUNT+=1
        echo.
    ) else (
        REM Check if generate_scripts.sh exists
        if not exist "%%F\generate_scripts.sh" (
            echo ERROR: generate_scripts.sh not found in: %%F
            set /a FAILURE_COUNT+=1
            echo.
        ) else (
            REM Change to the folder directory
            cd /d "%%F"
            
            REM Run the generate_scripts.sh using bash (requires Git Bash or WSL)
            echo Running: bash generate_scripts.sh %HOST% %PORT% [PASSWORD]
            bash generate_scripts.sh "%HOST%" "%PORT%" "%ROOT_PASSWORD%"
            
            if !errorlevel! equ 0 (
                echo SUCCESS: Scripts generated for %%F
                set /a SUCCESS_COUNT+=1
            ) else (
                echo FAILED: Script generation failed for %%F
                set /a FAILURE_COUNT+=1
            )
            
            REM Return to script directory
            cd /d "%SCRIPT_DIR%"
            echo.
        )
    )
)

REM Summary
echo ============================================================================
echo SUMMARY
echo ============================================================================
echo Total Outlier Types: %TOTAL_COUNT%
echo Successful: %SUCCESS_COUNT%
echo Failed: %FAILURE_COUNT%
echo ============================================================================
echo.

if %FAILURE_COUNT% equ 0 (
    echo All outlier scripts generated successfully!
    echo.
    echo Next Steps:
    echo 1. Review the generated baseline_*.sh and anomaly_*.sh scripts in each folder
    echo 2. Run baseline scripts first ^(they create databases and users^)
    echo 3. After baseline completes, run corresponding anomaly scripts
    echo.
    echo Example:
    echo   cd outlier_account_take_over_split_mysql
    echo   bash baseline_TIMESTAMP.sh
    echo   REM Wait for baseline to complete ^(4 hours^)
    echo   bash anomaly_TIMESTAMP.sh
    echo.
    exit /b 0
) else (
    echo Some script generations failed. Please check the errors above.
    exit /b 1
)

@REM Made with Bob
