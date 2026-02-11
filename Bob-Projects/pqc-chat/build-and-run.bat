@echo off
REM Build and run PQC Chat with Java 24
echo Setting JAVA_HOME to Java 24...
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo Java version:
java -version

echo.
echo Building fat JAR with Maven...
call mvn clean package

if %ERRORLEVEL% NEQ 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo Starting PQC Chat application...
echo Access the application at: http://localhost:9999
echo.
java --enable-preview -jar target\pqc-chat-1.0.0-fat.jar

pause

@REM Made with Bob