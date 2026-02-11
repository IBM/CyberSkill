@echo off
REM Complete build and run script for PQC Crypto Agility Runtime
echo ========================================
echo PQC Crypto Agility - Build and Run
echo ========================================
echo.

echo Setting JAVA_HOME to Java 24...
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo Java version:
java -version

echo.
echo Maven version:
call mvn -version

echo.
echo [1/3] Cleaning previous builds...
call mvn clean
if %ERRORLEVEL% NEQ 0 (
    echo Clean failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Compiling with Java 24...
call mvn compile
if %ERRORLEVEL% NEQ 0 (
    echo Compilation failed!
    pause
    exit /b 1
)

echo.
echo [3/3] Packaging fat JAR (skipping tests)...
call mvn package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo Packaging failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo Fat JAR created: target\pqc-crypto-agility-1.0.0-fat.jar
echo.
echo Starting demo...
echo.

java --enable-preview -jar target/pqc-crypto-agility-1.0.0-fat.jar

pause

@REM Made with Bob