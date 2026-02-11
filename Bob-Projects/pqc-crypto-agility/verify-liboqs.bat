@echo off
REM Verification script for liboqs installation on Windows
REM Run this to check if liboqs is properly installed and configured

echo.
echo ========================================
echo   Verifying liboqs Installation
echo ========================================
echo.

REM Check 1: liboqs DLL
echo [1/6] Checking liboqs library...
set LIBOQS_FOUND=0

if exist "C:\Program Files\liboqs\bin\oqs.dll" (
    echo [32m[OK][0m Found: C:\Program Files\liboqs\bin\oqs.dll
    dir "C:\Program Files\liboqs\bin\oqs.dll" | findstr /C:"oqs.dll"
    set LIBOQS_FOUND=1
) else if exist "C:\liboqs\bin\oqs.dll" (
    echo [32m[OK][0m Found: C:\liboqs\bin\oqs.dll
    dir "C:\liboqs\bin\oqs.dll" | findstr /C:"oqs.dll"
    set LIBOQS_FOUND=1
) else (
    echo [31m[ERROR][0m liboqs DLL not found
    echo   Expected locations:
    echo   - C:\Program Files\liboqs\bin\oqs.dll
    echo   - C:\liboqs\bin\oqs.dll
    echo.
    echo   Install instructions:
    echo   1. Download from: https://github.com/open-quantum-safe/liboqs/releases
    echo   2. Or build from source: https://github.com/open-quantum-safe/liboqs
)
echo.

REM Check 2: PATH environment variable
echo [2/6] Checking PATH...
echo %PATH% | findstr /C:"liboqs" >nul
if %ERRORLEVEL% EQU 0 (
    echo [32m[OK][0m liboqs found in PATH
) else (
    echo [33m[WARNING][0m liboqs not in PATH
    echo   Add to PATH:
    if %LIBOQS_FOUND% EQU 1 (
        echo   setx PATH "%%PATH%%;C:\Program Files\liboqs\bin"
    ) else (
        echo   setx PATH "%%PATH%%;C:\liboqs\bin"
    )
    echo   Then restart your terminal
)
echo.

REM Check 3: Java
echo [3/6] Checking Java...
java -version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [32m[OK][0m Java found
    java -version 2>&1 | findstr /C:"version"
    
    REM Check Java version
    for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
        set JAVA_VERSION=%%g
    )
    echo   Version: %JAVA_VERSION%
    
    REM Simple version check (looking for 17 or higher)
    echo %JAVA_VERSION% | findstr /C:"\"17" /C:"\"18" /C:"\"19" /C:"\"20" /C:"\"21" >nul
    if %ERRORLEVEL% EQU 0 (
        echo [32m[OK][0m Java 17+ detected
    ) else (
        echo [33m[WARNING][0m Java 17+ recommended
    )
) else (
    echo [31m[ERROR][0m Java not found
    echo   Install Java 17+: https://adoptium.net/
)
echo.

REM Check 4: Maven
echo [4/6] Checking Maven...
mvn -version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [32m[OK][0m Maven found
    mvn -version | findstr /C:"Apache Maven"
) else (
    echo [31m[ERROR][0m Maven not found
    echo   Install: https://maven.apache.org/download.cgi
)
echo.

REM Check 5: pom.xml dependency
echo [5/6] Checking liboqs-java Maven dependency...
if exist "pom.xml" (
    findstr /C:"liboqs-java" pom.xml >nul
    if %ERRORLEVEL% EQU 0 (
        echo [32m[OK][0m liboqs-java dependency found in pom.xml
        findstr /C:"liboqs-java" pom.xml
        findstr /C:"<version>" pom.xml | findstr /C:"liboqs"
    ) else (
        echo [31m[ERROR][0m liboqs-java dependency not found in pom.xml
    )
) else (
    echo [33m[WARNING][0m pom.xml not found (run from project root)
)
echo.

REM Check 6: Try to build
echo [6/6] Testing Maven build...
if exist "pom.xml" (
    mvn -version >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Running: mvn dependency:resolve -q
        mvn dependency:resolve -q >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            echo [32m[OK][0m Maven dependencies resolved successfully
        ) else (
            echo [33m[WARNING][0m Some dependencies may be missing
            echo   Run: mvn dependency:resolve
        )
    )
) else (
    echo [33m[WARNING][0m Skipping (pom.xml not found)
)
echo.

REM Summary
echo ========================================
echo   Summary
echo ========================================
echo.
echo Next steps:
echo.
echo 1. If liboqs is missing, install it:
echo    - Download: https://github.com/open-quantum-safe/liboqs/releases
echo    - Or build from source (requires CMake and Visual Studio)
echo.
echo 2. Add liboqs to PATH:
if %LIBOQS_FOUND% EQU 1 (
    echo    setx PATH "%%PATH%%;C:\Program Files\liboqs\bin"
) else (
    echo    setx PATH "%%PATH%%;C:\liboqs\bin"
)
echo    Then restart your terminal
echo.
echo 3. Build the project:
echo    mvn clean package
echo.
echo 4. Run the demo:
echo    java -jar target\pqc-crypto-agility-1.0.0-fat.jar
echo.
echo 5. Or run with explicit library path:
if %LIBOQS_FOUND% EQU 1 (
    echo    java -Djava.library.path="C:\Program Files\liboqs\bin" -jar target\pqc-crypto-agility-1.0.0-fat.jar
) else (
    echo    java -Djava.library.path="C:\liboqs\bin" -jar target\pqc-crypto-agility-1.0.0-fat.jar
)
echo.
echo For detailed setup instructions, see LIBOQS_SETUP.md
echo.

pause

@REM Made with Bob
