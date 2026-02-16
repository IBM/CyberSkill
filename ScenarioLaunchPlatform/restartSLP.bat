@echo off
REM Windows batch script to restart the SLP application

SET BASE_PATH=C:\slp
SET JAR_NAME=slp-0.0.1-SNAPSHOT.jar
SET LOG_FILE=%BASE_PATH%\slpapprun.log

cd /d %BASE_PATH%

echo [%date% %time%] Stopping current running version of jar file >> %LOG_FILE%

REM Kill any running instances of the JAR
for /f "tokens=2" %%a in ('tasklist /FI "IMAGENAME eq java.exe" /FO LIST ^| findstr /I "PID"') do (
    wmic process where "ProcessId=%%a" get CommandLine | findstr /I "%JAR_NAME%" >nul
    if not errorlevel 1 (
        echo Killing process %%a
        taskkill /F /PID %%a >nul 2>&1
    )
)

REM Wait a moment for processes to terminate
timeout /t 2 /nobreak >nul

echo [%date% %time%] Starting new version of jar file >> %LOG_FILE%

REM Start the application in the background
start /B javaw -jar %JAR_NAME%

echo Application restarted successfully
echo Check %LOG_FILE% for details

@REM Made with Bob
