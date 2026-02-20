@echo off
REM Windows batch script to restart the SLP application
REM Enhanced with verbose logging

SET BASE_PATH=C:\Users\I74350754\Documents\GitHub\CyberSkill\ScenarioLaunchPlatform\target
SET JAR_NAME=slp-0.0.1-SNAPSHOT.jar
SET LOG_FILE=%BASE_PATH%\slpapprun.log
SET CONFIG_FILE=..\config.json

echo ========================================
echo SLP Application Restart Script
echo ========================================
echo Timestamp: %date% %time%
echo Base Path: %BASE_PATH%
echo JAR Name: %JAR_NAME%
echo Log File: %LOG_FILE%
echo ========================================

REM Log script start
echo. >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%
echo [%date% %time%] Restart script initiated >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%

REM Change to target directory
echo Changing to directory: %BASE_PATH%
cd /d %BASE_PATH%
if errorlevel 1 (
    echo ERROR: Failed to change to directory %BASE_PATH%
    echo [%date% %time%] ERROR: Failed to change to directory >> %LOG_FILE%
    pause
    exit /b 1
)
echo [%date% %time%] Changed to directory: %CD% >> %LOG_FILE%

REM Check if JAR file exists
if not exist "%JAR_NAME%" (
    echo ERROR: JAR file not found: %JAR_NAME%
    echo [%date% %time%] ERROR: JAR file not found: %JAR_NAME% >> %LOG_FILE%
    pause
    exit /b 1
)
echo JAR file found: %JAR_NAME%
echo [%date% %time%] JAR file verified: %JAR_NAME% >> %LOG_FILE%

REM Check if config file exists
if not exist "%CONFIG_FILE%" (
    echo WARNING: Config file not found: %CONFIG_FILE%
    echo [%date% %time%] WARNING: Config file not found: %CONFIG_FILE% >> %LOG_FILE%
) else (
    echo Config file found: %CONFIG_FILE%
    echo [%date% %time%] Config file verified: %CONFIG_FILE% >> %LOG_FILE%
)

echo.
echo Stopping current running instances...
echo [%date% %time%] Stopping current running version of jar file >> %LOG_FILE%

REM Kill any running instances of the JAR
SET FOUND_PROCESS=0
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO LIST ^| findstr /I "PID"') do (
    wmic process where "ProcessId=%%a" get CommandLine 2>nul | findstr /I "%JAR_NAME%" >nul
    if not errorlevel 1 (
        SET FOUND_PROCESS=1
        echo Found running instance with PID: %%a
        echo [%date% %time%] Found running instance with PID: %%a >> %LOG_FILE%
        echo Killing process %%a...
        taskkill /F /PID %%a >nul 2>&1
        if errorlevel 1 (
            echo WARNING: Failed to kill process %%a
            echo [%date% %time%] WARNING: Failed to kill process %%a >> %LOG_FILE%
        ) else (
            echo Successfully killed process %%a
            echo [%date% %time%] Successfully killed process %%a >> %LOG_FILE%
        )
    )
)

if %FOUND_PROCESS%==0 (
    echo No running instances found
    echo [%date% %time%] No running instances found >> %LOG_FILE%
)

REM Wait for processes to terminate
echo.
echo Waiting 3 seconds for processes to terminate...
echo [%date% %time%] Waiting for processes to terminate >> %LOG_FILE%
timeout /t 3 /nobreak >nul

echo.
echo Starting new application instance...
echo [%date% %time%] Starting new version of jar file >> %LOG_FILE%

REM Start the application in the background
start /B javaw -jar %JAR_NAME%
if errorlevel 1 (
    echo ERROR: Failed to start application
    echo [%date% %time%] ERROR: Failed to start application >> %LOG_FILE%
    pause
    exit /b 1
)

echo [%date% %time%] Application started successfully >> %LOG_FILE%

REM Wait a moment and verify the process started
timeout /t 2 /nobreak >nul

echo.
echo Verifying application startup...
tasklist /FI "IMAGENAME eq javaw.exe" | findstr /I "javaw.exe" >nul
if errorlevel 1 (
    echo WARNING: javaw.exe process not found - application may not have started
    echo [%date% %time%] WARNING: javaw.exe process not found >> %LOG_FILE%
) else (
    echo Application process is running
    echo [%date% %time%] Application process verified running >> %LOG_FILE%
)

echo.
echo ========================================
echo Application restart completed
echo ========================================
echo Check the following for details:
echo   - Log file: %LOG_FILE%
echo   - Application logs in: %BASE_PATH%
echo.
echo The application should be accessible at:
echo   http://localhost:8888
echo.
echo [%date% %time%] Restart script completed >> %LOG_FILE%
echo ======================================== >> %LOG_FILE%

@REM Made with Bob
