@echo off
echo ========================================
echo Starting CyberSkill Platform
echo ========================================
echo.

cd /d "%~dp0"

if not exist "target\cyberskill-platform-1.0.0.jar" (
    echo ERROR: JAR file not found!
    echo.
    echo Please build the application first by running: build.bat
    echo Or manually: mvn clean package -DskipTests
    echo.
    pause
    exit /b 1
)

echo Starting application on port 8080...
echo Press Ctrl+C to stop the server
echo.
echo ========================================
echo.

java -jar target\cyberskill-platform-1.0.0.jar

@REM Made with Bob
