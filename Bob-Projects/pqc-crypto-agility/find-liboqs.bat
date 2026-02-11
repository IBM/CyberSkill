@echo off
REM Helper script to find your liboqs installation and configure it

echo.
echo ========================================
echo   Finding liboqs Installation
echo ========================================
echo.

REM Check common build locations
set FOUND=0
set LIBOQS_PATH=

echo Searching for oqs.dll...
echo.

REM Check 1: Development directory
if exist "C:\Users\I74350754\Documents\Development\liboqs\build\bin\oqs.dll" (
    set LIBOQS_PATH=C:\Users\I74350754\Documents\Development\liboqs\build\bin
    set FOUND=1
    echo [32m[FOUND][0m %LIBOQS_PATH%\oqs.dll
    goto :configure
)

REM Check 2: liboqs directory in current location
if exist "..\liboqs\build\bin\oqs.dll" (
    set LIBOQS_PATH=%CD%\..\liboqs\build\bin
    set FOUND=1
    echo [32m[FOUND][0m %LIBOQS_PATH%\oqs.dll
    goto :configure
)

REM Check 3: Standard install locations
if exist "C:\Program Files\liboqs\bin\oqs.dll" (
    set LIBOQS_PATH=C:\Program Files\liboqs\bin
    set FOUND=1
    echo [32m[FOUND][0m %LIBOQS_PATH%\oqs.dll
    goto :configure
)

if exist "C:\liboqs\bin\oqs.dll" (
    set LIBOQS_PATH=C:\liboqs\bin
    set FOUND=1
    echo [32m[FOUND][0m %LIBOQS_PATH%\oqs.dll
    goto :configure
)

REM Check 4: Search in common locations
echo Searching in common locations...
for /r "C:\Users\I74350754\Documents\Development" %%f in (oqs.dll) do (
    if exist "%%f" (
        set LIBOQS_PATH=%%~dpf
        set LIBOQS_PATH=!LIBOQS_PATH:~0,-1!
        set FOUND=1
        echo [32m[FOUND][0m %%f
        goto :configure
    )
)

:notfound
echo [31m[NOT FOUND][0m Could not locate oqs.dll
echo.
echo Please specify the location manually:
echo   1. Find where you built liboqs (e.g., C:\Users\...\liboqs\build\bin)
echo   2. Run this command:
echo      set LIBOQS_PATH=C:\path\to\liboqs\build\bin
echo   3. Then run: build-with-liboqs.bat
echo.
pause
exit /b 1

:configure
echo.
echo ========================================
echo   Configuration
echo ========================================
echo.
echo liboqs found at: %LIBOQS_PATH%
echo.

REM Create a batch file with the correct path
echo @echo off > build-with-liboqs.bat
echo REM Auto-generated build script with liboqs path >> build-with-liboqs.bat
echo. >> build-with-liboqs.bat
echo set LIBOQS_PATH=%LIBOQS_PATH% >> build-with-liboqs.bat
echo. >> build-with-liboqs.bat
echo echo Building with liboqs from: %%LIBOQS_PATH%% >> build-with-liboqs.bat
echo echo. >> build-with-liboqs.bat
echo. >> build-with-liboqs.bat
echo mvn clean package >> build-with-liboqs.bat
echo. >> build-with-liboqs.bat
echo if %%ERRORLEVEL%% EQU 0 ( >> build-with-liboqs.bat
echo     echo. >> build-with-liboqs.bat
echo     echo ======================================== >> build-with-liboqs.bat
echo     echo   Build Successful! >> build-with-liboqs.bat
echo     echo ======================================== >> build-with-liboqs.bat
echo     echo. >> build-with-liboqs.bat
echo     echo To run the demo: >> build-with-liboqs.bat
echo     echo   java -Djava.library.path="%%LIBOQS_PATH%%" -jar target\pqc-crypto-agility-1.0.0-fat.jar >> build-with-liboqs.bat
echo     echo. >> build-with-liboqs.bat
echo     echo Or run: >> build-with-liboqs.bat
echo     echo   run-demo.bat >> build-with-liboqs.bat
echo     echo. >> build-with-liboqs.bat
echo ^) >> build-with-liboqs.bat

REM Create run script
echo @echo off > run-demo.bat
echo REM Auto-generated run script >> run-demo.bat
echo set LIBOQS_PATH=%LIBOQS_PATH% >> run-demo.bat
echo java -Djava.library.path="%%LIBOQS_PATH%%" -jar target\pqc-crypto-agility-1.0.0-fat.jar >> run-demo.bat

REM Create run example script
echo @echo off > run-example.bat
echo REM Auto-generated run script for simple example >> run-example.bat
echo set LIBOQS_PATH=%LIBOQS_PATH% >> run-example.bat
echo java -Djava.library.path="%%LIBOQS_PATH%%" -cp target\pqc-crypto-agility-1.0.0-fat.jar com.pqc.agility.examples.SimpleEncryptionApp >> run-example.bat

echo [32m[OK][0m Created build-with-liboqs.bat
echo [32m[OK][0m Created run-demo.bat
echo [32m[OK][0m Created run-example.bat
echo.
echo ========================================
echo   Next Steps
echo ========================================
echo.
echo 1. Build the project:
echo    build-with-liboqs.bat
echo.
echo 2. Run the demo:
echo    run-demo.bat
echo.
echo 3. Or run the simple example:
echo    run-example.bat
echo.
echo These scripts will automatically use the correct liboqs path.
echo.

pause

@REM Made with Bob
