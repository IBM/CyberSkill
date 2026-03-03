# Add tbl_users table to PostgreSQL CRM database
# This script creates the missing tbl_users table that attack patterns reference

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Adding tbl_users to PostgreSQL CRM Database" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sqlFile = "database\PostgreSQL\create_tbl_users.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: $sqlFile not found!" -ForegroundColor Red
    exit 1
}

Write-Host "This will add tbl_users table to the PostgreSQL CRM database" -ForegroundColor Yellow
Write-Host "Database: postgresql://localhost:5432/crm" -ForegroundColor Yellow
Write-Host ""

Write-Host "Running SQL script: $sqlFile" -ForegroundColor Yellow
Write-Host ""

# Set PostgreSQL password environment variable
$env:PGPASSWORD = "postgres"

# Run the SQL script
psql -U postgres -f $sqlFile

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "tbl_users table created successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Table details:" -ForegroundColor Yellow
    Write-Host "  - 110 users created (10 sample + 100 generated)" -ForegroundColor White
    Write-Host "  - Columns: id, username, password, email, first_name, last_name, role, status" -ForegroundColor White
    Write-Host "  - Sample users: admin, john.doe, jane.smith, etc." -ForegroundColor White
    Write-Host "  - Roles: admin, manager, user" -ForegroundColor White
    Write-Host "  - Status: active, inactive, locked" -ForegroundColor White
    Write-Host "  - Auto-update trigger for date_modified column" -ForegroundColor White
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Run: .\fix_attack_patterns.ps1" -ForegroundColor White
    Write-Host "2. Run: .\restartSLP.bat" -ForegroundColor White
    Write-Host "3. Test all attack patterns in Attack Library" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to create tbl_users table" -ForegroundColor Red
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  - Verify PostgreSQL is running" -ForegroundColor White
    Write-Host "  - Check PostgreSQL password (default: postgres)" -ForegroundColor White
    Write-Host "  - Ensure CRM database exists" -ForegroundColor White
    Write-Host "  - Try: psql -U postgres -l (to list databases)" -ForegroundColor White
}

# Clear password from environment
Remove-Item Env:\PGPASSWORD

# Made with Bob
