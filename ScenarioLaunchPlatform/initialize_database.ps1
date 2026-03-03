# Initialize SLP Database
# This script creates the database and tables needed for the Scenario Launch Platform

Write-Host "=== Scenario Launch Platform Database Initialization ===" -ForegroundColor Cyan
Write-Host ""

# Database configuration
$dbHost = "localhost"
$dbPort = "5432"
$dbName = "slp"
$dbUser = "postgres"
$dbPassword = "postgres"

# Set PGPASSWORD environment variable to avoid password prompt
$env:PGPASSWORD = $dbPassword

Write-Host "Step 1: Checking if database 'slp' exists..." -ForegroundColor Yellow

# Check if database exists
$dbExists = & psql -h $dbHost -p $dbPort -U $dbUser -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$dbName'" 2>$null

if ($dbExists -eq "1") {
    Write-Host "[OK] Database 'slp' already exists" -ForegroundColor Green
} else {
    Write-Host "Creating database 'slp'..." -ForegroundColor Yellow
    & psql -h $dbHost -p $dbPort -U $dbUser -d postgres -c "CREATE DATABASE $dbName;" 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Database 'slp' created successfully" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Failed to create database" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "Step 2: Creating tables and schema..." -ForegroundColor Yellow

# Run the SQL script
$sqlFile = "database\ScenarioLaunchPlatform_CORE\tables.sql"

if (Test-Path $sqlFile) {
    & psql -h $dbHost -p $dbPort -U $dbUser -d $dbName -f $sqlFile 2>&1 | ForEach-Object {
        if ($_ -match "NOTICE|Created|successfully") {
            Write-Host "  $_" -ForegroundColor Gray
        } elseif ($_ -match "ERROR") {
            Write-Host "  $_" -ForegroundColor Red
        }
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Tables created successfully" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Some errors occurred during table creation" -ForegroundColor Yellow
    }
} else {
    Write-Host "[ERROR] SQL file not found: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Step 3: Verifying table creation..." -ForegroundColor Yellow

# Check if critical tables exist
$tables = @(
    "tb_user",
    "tb_databaseconnections", 
    "tb_query",
    "tb_stories",
    "tb_content_packs",
    "tb_outlier_scripts",
    "tb_outlier_schedules",
    "tb_attack_patterns"
)

$allTablesExist = $true
foreach ($table in $tables) {
    $exists = & psql -h $dbHost -p $dbPort -U $dbUser -d $dbName -tAc "SELECT 1 FROM information_schema.tables WHERE table_schema='public' AND table_name='$table'" 2>$null
    
    if ($exists -eq "1") {
        Write-Host "  [OK] $table" -ForegroundColor Green
    } else {
        Write-Host "  [MISSING] $table" -ForegroundColor Red
        $allTablesExist = $false
    }
}

Write-Host ""
if ($allTablesExist) {
    Write-Host "=== Database initialization completed successfully! ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now start the application with:" -ForegroundColor Cyan
    Write-Host "  .\restartSLP.bat" -ForegroundColor White
} else {
    Write-Host "=== Database initialization completed with warnings ===" -ForegroundColor Yellow
    Write-Host "Some tables are missing. Please check the errors above." -ForegroundColor Yellow
}

# Clear password from environment
$env:PGPASSWORD = $null

# Made with Bob
