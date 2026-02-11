@echo off
REM Run PQC Crypto Agility Runtime with Java 24 and ML-KEM support
echo ========================================
echo PQC Crypto Agility - Run with Java 24
echo ========================================
echo.

echo Setting JAVA_HOME to Java 24...
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo Building fat JAR with Java 24...
call compile-java24.bat
if %ERRORLEVEL% NEQ 0 (
    echo Build failed! Cannot run.
    pause
    exit /b 1
)

call mvn package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo Package failed! Cannot run.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Starting PQC Crypto Agility Runtime
echo ========================================
echo.
echo Running demo with Java 24 ML-KEM support...
echo.

java --enable-preview -jar target/pqc-crypto-agility-1.0.0-fat.jar

pause

@REM Made with Bob