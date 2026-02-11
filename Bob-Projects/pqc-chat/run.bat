@echo off
echo ========================================
echo PQC Secured Messaging Application
echo ========================================
echo.

echo Checking Java version...
java -version
echo.

echo Building application...
call mvn clean package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo Starting PQC Chat Server with Java 24 ML-KEM...
echo Access the application at: http://localhost:9999
echo Press Ctrl+C to stop the server
echo.

java --enable-preview -jar target/pqc-chat-1.0.0-fat.jar

pause

@REM Made with Bob
