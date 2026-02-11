@echo off
REM Compile with Java 24 for ML-KEM support
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

echo.
echo Build complete!
pause

@REM Made with Bob
