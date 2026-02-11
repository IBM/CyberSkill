@echo off
echo ========================================
echo PQC File Encryptor - Build and Run
echo ========================================
echo.

REM Copy webapp files to resources
echo Copying web files to resources...
mkdir src\main\resources\webroot 2>nul
xcopy /E /I /Y src\main\webapp\* src\main\resources\webroot\ >nul
echo Done!
echo.

REM Build
echo Building application...
call mvn clean package -q
if %errorlevel% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)
echo Build successful!
echo.

REM Run
echo Starting application...
echo.
echo ========================================
echo Server will start on port 9999
echo Open browser: http://localhost:9999
echo Press Ctrl+C to stop
echo ========================================
echo.

java -jar target\pqc-file-encryptor-1.0.0-fat.jar

pause

@REM Made with Bob
