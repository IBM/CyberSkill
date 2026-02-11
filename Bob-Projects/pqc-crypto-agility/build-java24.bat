@echo off
REM Build script for PQC Crypto Agility Runtime with Java 24
REM This script sets JAVA_HOME to Java 24 and builds the project

echo ========================================
echo PQC Crypto Agility Runtime - Build Script
echo ========================================
echo.

REM Check if Java 24 is available
where java >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Java not found in PATH
    echo Please install Java 24 from: https://jdk.java.net/24/
    exit /b 1
)

REM Get Java version
for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
    set JAVA_VERSION_STRING=%%g
)
set JAVA_VERSION_STRING=%JAVA_VERSION_STRING:"=%
for /f "delims=. tokens=1" %%v in ("%JAVA_VERSION_STRING%") do set JAVA_MAJOR_VERSION=%%v

echo Detected Java version: %JAVA_VERSION_STRING%
echo Java major version: %JAVA_MAJOR_VERSION%
echo.

REM Check if Java 24 is being used
if NOT "%JAVA_MAJOR_VERSION%"=="24" (
    echo WARNING: Java 24 is required for native PQC support
    echo Current version: %JAVA_VERSION_STRING%
    echo.
    echo Please set JAVA_HOME to Java 24 installation directory
    echo Example: set JAVA_HOME=C:\Program Files\Java\jdk-24
    echo.
    
    REM Try to find Java 24 automatically
    if exist "C:\Program Files\Java\jdk-24" (
        echo Found Java 24 at: C:\Program Files\Java\jdk-24
        set "JAVA_HOME=C:\Program Files\Java\jdk-24"
        set "PATH=%JAVA_HOME%\bin;%PATH%"
        echo JAVA_HOME set to: %JAVA_HOME%
        echo.
    ) else (
        echo Java 24 not found in default location
        echo Please install Java 24 or set JAVA_HOME manually
        exit /b 1
    )
)

REM Update JAVA_HOME for Maven
if exist "C:\Program Files\Java\jdk-24" (
    set "JAVA_HOME=C:\Program Files\Java\jdk-24"
    set "PATH=%JAVA_HOME%\bin;%PATH%"
)

echo Using JAVA_HOME: %JAVA_HOME%
echo Using PATH: %PATH:~0,100%...
echo.

REM Verify Maven is using correct Java
echo Verifying Maven Java version...
call mvn -version
echo.

REM Clean previous builds
echo [1/3] Cleaning previous builds...
call mvn clean
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Maven clean failed
    exit /b 1
)
echo.

REM Compile the project
echo [2/3] Compiling with Java 24...
call mvn compile
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Compilation failed
    echo.
    echo Common issues:
    echo - Make sure Java 24 is installed
    echo - Check that JAVA_HOME points to Java 24
    echo - Verify pom.xml has source/target set to 24
    exit /b 1
)
echo.

REM Package the project
echo [3/3] Packaging fat JAR...
call mvn package -DskipTests
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Packaging failed
    exit /b 1
)
echo.

echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo Fat JAR created: target\pqc-crypto-agility-1.0.0-fat.jar
echo.
echo To run the demo:
echo   java -jar target\pqc-crypto-agility-1.0.0-fat.jar
echo.
echo To run tests:
echo   mvn test
echo.

@REM Made with Bob
