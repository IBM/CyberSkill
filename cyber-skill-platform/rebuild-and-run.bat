@echo off
echo ========================================
echo CyberSkill Platform - Rebuild and Run
echo ========================================
echo.

cd /d "%~dp0"

echo Step 1: Stopping any running instances...
echo (Press Ctrl+C in the other terminal if app is running)
timeout /t 3 /nobreak >nul
echo.

echo Step 2: Cleaning old build...
call mvn clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven clean failed!
    pause
    exit /b 1
)
echo.

echo Step 3: Building application with updated templates...
echo (This includes the fixed dashboard.ftl with escaped variables)
call mvn package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven build failed!
    pause
    exit /b 1
)
echo.

echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo The JAR now includes:
echo  - Fixed dashboard.ftl with \${path.name}
echo  - Fixed login.ftl
echo  - SCRAM dependency for PostgreSQL
echo  - All compiled code
echo.
echo Starting application...
echo Press Ctrl+C to stop
echo.
echo ========================================
echo.

java -jar target\cyberskill-platform-1.0.0.jar

@REM Made with Bob
