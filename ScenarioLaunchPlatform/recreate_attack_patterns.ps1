# Recreate Attack Patterns Table with All Fixes
# This script drops and recreates the tb_attack_patterns table
# with correct column names and tbl_users references

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Recreating Attack Patterns Table" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$sqlFile = "database\ScenarioLaunchPlatform_CORE\recreate_attack_patterns_fixed.sql"

if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: $sqlFile not found!" -ForegroundColor Red
    exit 1
}

Write-Host "WARNING: This will DROP and RECREATE the tb_attack_patterns table!" -ForegroundColor Yellow
Write-Host "All existing attack patterns will be replaced with fixed versions." -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Continue? (yes/no)"

if ($confirm -ne "yes") {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Running SQL script: $sqlFile" -ForegroundColor Yellow
Write-Host ""

# Set PostgreSQL password
$env:PGPASSWORD = "postgres"

# Run the SQL script
psql -U postgres -d slp -f $sqlFile

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Attack patterns table recreated!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Changes made:" -ForegroundColor Yellow
    Write-Host "  ✓ All patterns use correct column names" -ForegroundColor White
    Write-Host "  ✓ tbl_product: id (not product_id)" -ForegroundColor White
    Write-Host "  ✓ tbl_crm_accounts: id (not account_id)" -ForegroundColor White
    Write-Host "  ✓ tbl_users: included in patterns" -ForegroundColor White
    Write-Host "  ✓ sqli-blind-002: now has 3 queries" -ForegroundColor White
    Write-Host ""
    Write-Host "Total patterns: 10" -ForegroundColor White
    Write-Host "  - Union-Based SQL Injection" -ForegroundColor White
    Write-Host "  - Blind SQL Injection (sqli-blind-002)" -ForegroundColor White
    Write-Host "  - Time-Based Blind SQL Injection" -ForegroundColor White
    Write-Host "  - Error-Based SQL Injection" -ForegroundColor White
    Write-Host "  - Stacked Queries SQL Injection" -ForegroundColor White
    Write-Host "  - Privilege Escalation via GRANT" -ForegroundColor White
    Write-Host "  - Mass Data Exfiltration" -ForegroundColor White
    Write-Host "  - Unauthorized Data Modification" -ForegroundColor White
    Write-Host "  - Unauthorized Data Deletion" -ForegroundColor White
    Write-Host "  - Schema Tampering via DROP" -ForegroundColor White
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Restart SLP: .\restartSLP.bat" -ForegroundColor White
    Write-Host "2. Test Blind SQL Injection pattern" -ForegroundColor White
    Write-Host "3. All 3 queries should now work with JSON results!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "ERROR: Failed to recreate attack patterns table" -ForegroundColor Red
    Write-Host "Exit code: $LASTEXITCODE" -ForegroundColor Red
}

# Clear password
Remove-Item Env:\PGPASSWORD

# Made with Bob
