@echo off
REM Run PQC File Encryptor with Java 24 and ML-KEM support
echo Setting JAVA_HOME to Java 24...
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo Building fat JAR with Java 24...
call compile-java24.bat
call mvn package

echo.
echo Starting PQC File Encryptor with Java 24 ML-KEM support...
echo Server will be available at: http://localhost:9999
echo.
echo Press Ctrl+C to stop the server
echo.

java --enable-preview -jar target/pqc-file-encryptor-1.0.0-fat.jar

pause

@REM Made with Bob
