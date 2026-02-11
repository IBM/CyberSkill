@echo off
echo ========================================
echo Building PQC Example Application
echo ========================================

REM Set Java 24 path
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo Using Java: %JAVA_HOME%
java -version

echo.
echo [1/3] Installing parent crypto agility runtime...
cd ..
call mvn clean install -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo Failed to install parent runtime
    exit /b 1
)

echo.
echo [2/3] Building example application...
cd example-app
call mvn clean package
if %ERRORLEVEL% NEQ 0 (
    echo Build failed
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo Fat JAR created: target\pqc-example-app-1.0.0-fat.jar
echo.
echo [3/3] Starting server...
echo.

java -jar target\pqc-example-app-1.0.0-fat.jar

@REM Made with Bob
