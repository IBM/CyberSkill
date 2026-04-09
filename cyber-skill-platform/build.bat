@echo off
echo ========================================
echo Building CyberSkill Platform
echo ========================================
echo.

cd /d "%~dp0"

echo Cleaning previous build...
call mvn clean

echo.
echo Building application (this may take a few minutes)...
call mvn package -DskipTests

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo JAR file created: target\cyberskill-platform-1.0.0.jar
    echo.
    echo To run the application, execute: run.bat
    echo Or manually: java -jar target\cyberskill-platform-1.0.0.jar
    echo.
) else (
    echo.
    echo ========================================
    echo BUILD FAILED!
    echo ========================================
    echo Please check the error messages above.
    echo.
)

pause

@REM Made with Bob
