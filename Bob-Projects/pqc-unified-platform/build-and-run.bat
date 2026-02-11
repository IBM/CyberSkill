@echo off
REM Build and run PQC Unified Platform with Java 24
echo ╔════════════════════════════════════════════════════════════╗
echo ║   PQC UNIFIED PLATFORM - Build and Run                    ║
echo ╚════════════════════════════════════════════════════════════╝

echo.
echo Setting JAVA_HOME to Java 24...
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo Java version:
java -version

echo.
echo Building with Maven...
call mvn clean package

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ╔════════════════════════════════════════════════════════════╗
    echo ║   BUILD FAILED!                                            ║
    echo ╚════════════════════════════════════════════════════════════╝
    pause
    exit /b 1
)

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║   BUILD SUCCESSFUL!                                        ║
echo ╠════════════════════════════════════════════════════════════╣
echo ║   Starting PQC Unified Platform...                         ║
echo ║                                                            ║
echo ║   Features:                                                ║
echo ║   • Domain Scanner    - TLS/PQC certificate analysis       ║
echo ║   • File Encryptor    - Quantum-safe file encryption       ║
echo ║   • Secure Messaging  - Real-time encrypted chat           ║
echo ║                                                            ║
echo ║   Access at: http://localhost:8080                         ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

java --enable-preview -jar target\pqc-unified-platform-1.0.0-fat.jar

pause

@REM Made with Bob