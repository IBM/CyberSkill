@echo off
REM Compile PQC Crypto Agility Runtime with Java 24 for ML-KEM support
echo ========================================
echo PQC Crypto Agility - Compile with Java 24
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
echo Compiling with Java 24 and preview features...
call mvn clean compile

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo COMPILATION SUCCESSFUL!
    echo ========================================
    echo.
    echo Next steps:
    echo   1. Package: mvn package
    echo   2. Run: java --enable-preview -jar target\pqc-crypto-agility-1.0.0-fat.jar
    echo.
) else (
    echo.
    echo ========================================
    echo COMPILATION FAILED!
    echo ========================================
    echo.
    echo Please check:
    echo   - Java 24 is installed at C:\Program Files\Java\jdk-24
    echo   - Maven can access Java 24
    echo   - All source files are correct
    echo.
)

pause

@REM Made with Bob