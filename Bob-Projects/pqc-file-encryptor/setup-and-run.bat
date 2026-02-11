@echo off
echo ========================================
echo PQC File Encryptor - Setup and Run
echo ========================================
echo.

REM Step 1: Create database
echo Step 1: Creating database...
createdb pqc_encryptor
if %errorlevel% neq 0 (
    echo Database might already exist, continuing...
)
echo.

REM Step 2: Create schema
echo Step 2: Creating database schema...
psql -d pqc_encryptor -f database\schema.sql
if %errorlevel% neq 0 (
    echo ERROR: Failed to create schema. Check PostgreSQL connection.
    pause
    exit /b 1
)
echo.

REM Step 3: Build application
echo Step 3: Building application...
call mvn clean package
if %errorlevel% neq 0 (
    echo ERROR: Build failed. Check Maven output above.
    pause
    exit /b 1
)
echo.

REM Step 4: Run application
echo Step 4: Starting application...
echo.
echo ========================================
echo Application will start on port 8080
echo Open browser: http://localhost:8080
echo Press Ctrl+C to stop
echo ========================================
echo.

java -jar target\pqc-file-encryptor-1.0.0-fat.jar

pause

@REM Made with Bob
