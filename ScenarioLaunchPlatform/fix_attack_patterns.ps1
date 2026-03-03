# Fix Attack Patterns in PostgreSQL Database
# This script updates attack patterns with correct column names

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fixing Attack Patterns in SLP Database" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sqlFile = "fix_attack_patterns.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: $sqlFile not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Running SQL script: $sqlFile" -ForegroundColor Yellow
Write-Host ""

# Run the SQL script
$env:PGPASSWORD = "postgres"
psql -U postgres -d slp -f $sqlFile

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Attack patterns fixed successfully!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Restart SLP: .\restartSLP.bat" -ForegroundColor White
    Write-Host "2. Test Union-Based SQL Injection attack" -ForegroundColor White
    Write-Host "3. Query should now work with correct column names" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to update attack patterns" -ForegroundColor Red
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
}

Remove-Item Env:\PGPASSWORD

# Made with Bob
