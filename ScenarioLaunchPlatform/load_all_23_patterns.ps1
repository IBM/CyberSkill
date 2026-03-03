# Load All 23 Attack Patterns into PostgreSQL SLP Database
# This script loads the complete set of attack patterns with fixed column names

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Loading All 23 Attack Patterns" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# PostgreSQL connection details for SLP system database
$pgHost = "localhost"
$pgPort = "5432"
$pgDatabase = "slp"
$pgUser = "postgres"

# Prompt for password
$pgPassword = Read-Host "Enter PostgreSQL password for user '$pgUser'" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pgPassword)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "Connecting to PostgreSQL database: $pgDatabase" -ForegroundColor Yellow

# Set PGPASSWORD environment variable
$env:PGPASSWORD = $plainPassword

try {
    # Test connection
    Write-Host "Testing connection..." -ForegroundColor Yellow
    $testQuery = "SELECT version();"
    $result = & psql -h $pgHost -p $pgPort -U $pgUser -d $pgDatabase -c $testQuery 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to connect to PostgreSQL database" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Connection successful!" -ForegroundColor Green
    Write-Host ""
    
    # Execute the SQL file
    Write-Host "Loading all 23 attack patterns from SQL file..." -ForegroundColor Yellow
    $sqlFile = "database\ScenarioLaunchPlatform_CORE\all_23_attack_patterns.sql"
    
    if (-not (Test-Path $sqlFile)) {
        Write-Host "ERROR: SQL file not found: $sqlFile" -ForegroundColor Red
        exit 1
    }
    
    $result = & psql -h $pgHost -p $pgPort -U $pgUser -d $pgDatabase -f $sqlFile 2>&1
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to execute SQL file" -ForegroundColor Red
        Write-Host $result -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "SUCCESS!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "All 23 attack patterns have been loaded into the database." -ForegroundColor Green
    Write-Host ""
    Write-Host "Pattern breakdown:" -ForegroundColor Cyan
    Write-Host "  - SQL Injection: 4 patterns" -ForegroundColor White
    Write-Host "  - Authentication: 3 patterns" -ForegroundColor White
    Write-Host "  - Data Exfiltration: 3 patterns" -ForegroundColor White
    Write-Host "  - Privilege Escalation: 2 patterns" -ForegroundColor White
    Write-Host "  - Denial of Service: 2 patterns" -ForegroundColor White
    Write-Host "  - Compliance Testing: 5 patterns" -ForegroundColor White
    Write-Host "  - Data Manipulation: 2 patterns" -ForegroundColor White
    Write-Host "  - Information Disclosure: 2 patterns" -ForegroundColor White
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Rebuild the application: mvn clean package -DskipTests" -ForegroundColor White
    Write-Host "2. Restart SLP: .\restartSLP.bat" -ForegroundColor White
    Write-Host "3. Test Attack Library - you should now see all 23 patterns" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host "ERROR: An unexpected error occurred" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
} finally {
    # Clear password from environment
    $env:PGPASSWORD = $null
}

# Made with Bob
