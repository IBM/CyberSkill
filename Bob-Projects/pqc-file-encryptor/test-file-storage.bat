@echo off
echo Testing PQC File Encryptor with File Storage...
echo.
echo Step 1: Stop any running instances
taskkill /F /IM java.exe 2>nul
timeout /t 2 >nul

echo.
echo Step 2: Clean and rebuild
call mvn clean package -DskipTests

echo.
echo Step 3: Start application
echo Application starting on http://localhost:9999
echo.
echo Watch for these log messages:
echo   - "FileStorageService initialized"
echo   - "Services initialized successfully with file-based storage"
echo   - "PQC File Encryptor Started Successfully"
echo.
echo Press Ctrl+C to stop the application
echo.

java --enable-preview -jar target\pqc-file-encryptor-1.0.0-fat.jar

@REM Made with Bob
