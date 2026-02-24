# PowerShell script to remove users.json from PostgreSQL outlier packs
# These packs should use the base postgres pack users, not define their own

$outlierPacks = @(
    "outlier_account_take_over_postgres",
    "outlier_data_leak_command_postgres",
    "outlier_data_tampering_postgres",
    "outlier_denial_of_service_postgres",
    "outlier_insert_anomaly_postgres",
    "outlier_massive_grant_case_postgres",
    "outlier_revoke_anomaly_postgres",
    "outlier_schema_tampering_postgres",
    "outlier_update_anomaly_postgres"
)

foreach ($pack in $outlierPacks) {
    Write-Host "Processing $pack..." -ForegroundColor Green
    
    # Remove from both gdp_lab_contentpacks and contentpacks
    foreach ($baseDir in @("gdp_lab_contentpacks", "contentpacks")) {
        $usersJsonPath = "$baseDir\$pack\sql\users.json"
        
        if (Test-Path $usersJsonPath) {
            Remove-Item $usersJsonPath -Force
            Write-Host "  Removed $baseDir\$pack\sql\users.json" -ForegroundColor Cyan
        }
        
        # Recreate zip file
        $zipPath = "$baseDir\${pack}.zip"
        if (Test-Path $zipPath) {
            Remove-Item $zipPath -Force
        }
        Compress-Archive -Path "$baseDir\$pack\*" -DestinationPath $zipPath -Force
        Write-Host "  Recreated $zipPath" -ForegroundColor Yellow
    }
}

Write-Host "`nAll users.json files removed from PostgreSQL outlier packs!" -ForegroundColor Green
Write-Host "These packs will now use the base postgres pack users." -ForegroundColor Yellow

# Made with Bob
