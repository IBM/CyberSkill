# PowerShell script to create consolidated outlier content packs
# Creates outliers_mysql.zip and outliers_postgres.zip containing all 9 outlier scenarios

$ErrorActionPreference = "Stop"

# Define the 9 outlier pack names (without database suffix)
$outlierPacks = @(
    "outlier_account_take_over",
    "outlier_data_leak_command",
    "outlier_data_tampering",
    "outlier_denial_of_service",
    "outlier_insert_anomaly",
    "outlier_massive_grant_case",
    "outlier_revoke_anomaly",
    "outlier_schema_tampering",
    "outlier_update_anomaly"
)

# Function to create consolidated pack
function Create-ConsolidatedPack {
    param(
        [string]$DatabaseType,  # "mysql" or "postgres"
        [string]$OutputName     # "outliers_mysql" or "outliers_postgres"
    )
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Creating $OutputName.zip" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    # Create temporary directory for consolidation
    $tempDir = "temp_$OutputName"
    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    
    # Create subdirectories
    New-Item -ItemType Directory -Path "$tempDir\scripts" | Out-Null
    New-Item -ItemType Directory -Path "$tempDir\sql" | Out-Null
    New-Item -ItemType Directory -Path "$tempDir\html" | Out-Null
    
    # Initialize consolidated JSON arrays
    $allQueries = @()
    $allStories = @()
    $allUninstalls = @()
    $allUsers = @()
    
    # Determine suffix for source directories
    $suffix = if ($DatabaseType -eq "postgres") { "_postgres" } else { "" }
    
    # Process each outlier pack
    foreach ($pack in $outlierPacks) {
        $sourceDir = "gdp_lab_contentpacks\${pack}${suffix}"
        
        if (-not (Test-Path $sourceDir)) {
            Write-Host "WARNING: $sourceDir not found, skipping..." -ForegroundColor Yellow
            continue
        }
        
        Write-Host "Processing: $pack" -ForegroundColor Green
        
        # Read and merge query_inserts.json
        $queryFile = "$sourceDir\sql\query_inserts.json"
        if (Test-Path $queryFile) {
            $queries = Get-Content $queryFile -Raw | ConvertFrom-Json
            $allQueries += $queries
            Write-Host "  - Added $($queries.Count) queries" -ForegroundColor Gray
        }
        
        # Read and merge story_inserts.json
        $storyFile = "$sourceDir\sql\story_inserts.json"
        if (Test-Path $storyFile) {
            $stories = Get-Content $storyFile -Raw | ConvertFrom-Json
            $allStories += $stories
            Write-Host "  - Added $($stories.Count) stories" -ForegroundColor Gray
        }
        
        # Read and merge uninstall.json
        $uninstallFile = "$sourceDir\sql\uninstall.json"
        if (Test-Path $uninstallFile) {
            $uninstalls = Get-Content $uninstallFile -Raw | ConvertFrom-Json
            $allUninstalls += $uninstalls
            Write-Host "  - Added $($uninstalls.Count) uninstall entries" -ForegroundColor Gray
        }
        
        # Read and merge users.json (avoid duplicates)
        $usersFile = "$sourceDir\sql\users.json"
        if (Test-Path $usersFile) {
            $users = Get-Content $usersFile -Raw | ConvertFrom-Json
            foreach ($user in $users) {
                # Check if user already exists (by username)
                $exists = $allUsers | Where-Object { $_.username -eq $user.username }
                if (-not $exists) {
                    $allUsers += $user
                }
            }
        }
        
        # Copy scripts (they should be identical, so just copy once)
        $scriptsDir = "$sourceDir\scripts"
        if (Test-Path $scriptsDir) {
            Get-ChildItem $scriptsDir | ForEach-Object {
                $destFile = "$tempDir\scripts\$($_.Name)"
                if (-not (Test-Path $destFile)) {
                    Copy-Item $_.FullName -Destination $destFile
                }
            }
        }
        
        # Copy HTML files
        $htmlDir = "$sourceDir\html"
        if (Test-Path $htmlDir) {
            Get-ChildItem $htmlDir | ForEach-Object {
                Copy-Item $_.FullName -Destination "$tempDir\html\$($pack)_$($_.Name)"
            }
        }
    }
    
    # Write consolidated JSON files
    Write-Host "`nWriting consolidated files..." -ForegroundColor Cyan
    
    $allQueries | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\query_inserts.json"
    Write-Host "  - query_inserts.json: $($allQueries.Count) queries" -ForegroundColor Green
    
    $allStories | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\story_inserts.json"
    Write-Host "  - story_inserts.json: $($allStories.Count) stories" -ForegroundColor Green
    
    $allUninstalls | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\uninstall.json"
    Write-Host "  - uninstall.json: $($allUninstalls.Count) entries" -ForegroundColor Green
    
    if ($allUsers.Count -gt 0) {
        $allUsers | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\users.json"
        Write-Host "  - users.json: $($allUsers.Count) users" -ForegroundColor Green
    }
    
    # Create master pack.json
    $packJson = @{
        pack_name = $OutputName
        pack_description = "Consolidated Outlier Detection Pack for $DatabaseType - Contains all 9 outlier scenarios: Account Takeover, Data Leak, Data Tampering, Denial of Service, Insert Anomaly, Massive GRANT, Revoke Anomaly, Schema Tampering, and Update Anomaly"
        pack_version = "1.0.0"
        author = "Security Team"
        created_date = (Get-Date -Format "yyyy-MM-dd")
        database_type = $DatabaseType
        scenarios_included = $outlierPacks
    }
    
    $packJson | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\pack.json"
    Write-Host "  - pack.json created" -ForegroundColor Green
    
    # Create master HTML index
    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>$OutputName - Consolidated Outlier Detection Pack</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; margin-top: 30px; }
        .scenario { background: #ecf0f1; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #3498db; }
        .scenario h3 { margin-top: 0; color: #2980b9; }
        .info { background: #d5f4e6; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #27ae60; }
        .warning { background: #ffeaa7; padding: 15px; border-radius: 5px; margin: 20px 0; border-left: 4px solid #f39c12; }
        ul { line-height: 1.8; }
        code { background: #ecf0f1; padding: 2px 6px; border-radius: 3px; font-family: 'Courier New', monospace; }
    </style>
</head>
<body>
    <div class="container">
        <h1>$OutputName - Consolidated Outlier Detection Pack</h1>
        
        <div class="info">
            <strong>📦 Package Information</strong><br>
            <strong>Database Type:</strong> $DatabaseType<br>
            <strong>Total Scenarios:</strong> 9<br>
            <strong>Total Queries:</strong> $($allQueries.Count)<br>
            <strong>Total Stories:</strong> $($allStories.Count)<br>
            <strong>Version:</strong> 1.0.0
        </div>
        
        <h2>📋 Included Scenarios</h2>
        
        <div class="scenario">
            <h3>1. Account Takeover (ATO) Detection</h3>
            <p><strong>ID Range:</strong> 1701-1714</p>
            <p><strong>Purpose:</strong> Detects account takeover via sudden access pattern changes</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 SELECTs/hour on object1) → Hour 5 spike (250 SELECTs across all 5 objects)</p>
        </div>
        
        <div class="scenario">
            <h3>2. Data Leak Command Detection</h3>
            <p><strong>ID Range:</strong> 1601-1610</p>
            <p><strong>Purpose:</strong> Detects unauthorized SELECT operations (data exfiltration)</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 SELECTs/hour) → Hour 5 spike (1000 SELECTs)</p>
        </div>
        
        <div class="scenario">
            <h3>3. Data Tampering Detection</h3>
            <p><strong>ID Range:</strong> 1101-1110</p>
            <p><strong>Purpose:</strong> Detects unauthorized DELETE operations</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 DELETEs/hour) → Hour 5 spike (1000 DELETEs)</p>
        </div>
        
        <div class="scenario">
            <h3>4. Denial of Service Detection</h3>
            <p><strong>ID Range:</strong> 1801-1810</p>
            <p><strong>Purpose:</strong> Detects DoS attacks via query flooding</p>
            <p><strong>Pattern:</strong> 4 hours baseline (1001 queries/hour) → Hour 5 spike (205000 queries)</p>
        </div>
        
        <div class="scenario">
            <h3>5. Insert Anomaly Detection</h3>
            <p><strong>ID Range:</strong> 1301-1309</p>
            <p><strong>Purpose:</strong> Detects unauthorized INSERT operations</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 INSERTs/hour) → Hour 5 spike (1000 INSERTs)</p>
        </div>
        
        <div class="scenario">
            <h3>6. Massive GRANT Case Detection</h3>
            <p><strong>ID Range:</strong> 1501-1511</p>
            <p><strong>Purpose:</strong> Detects privilege escalation via GRANT operations</p>
            <p><strong>Pattern:</strong> 4 hours baseline (1 GRANT/hour) → Hour 5 spike (21 GRANTs)</p>
        </div>
        
        <div class="scenario">
            <h3>7. Revoke Anomaly Detection</h3>
            <p><strong>ID Range:</strong> 1401-1410</p>
            <p><strong>Purpose:</strong> Detects unauthorized REVOKE operations</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 REVOKEs/hour) → Hour 5 spike (1000 REVOKEs)</p>
        </div>
        
        <div class="scenario">
            <h3>8. Schema Tampering Detection</h3>
            <p><strong>ID Range:</strong> 1001-1007</p>
            <p><strong>Purpose:</strong> Detects unauthorized ALTER TABLE operations</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 ALTERs/hour) → Hour 5 spike (1000 ALTERs)</p>
        </div>
        
        <div class="scenario">
            <h3>9. Update Anomaly Detection</h3>
            <p><strong>ID Range:</strong> 1201-1210</p>
            <p><strong>Purpose:</strong> Detects unauthorized UPDATE operations</p>
            <p><strong>Pattern:</strong> 4 hours baseline (50 UPDATEs/hour) → Hour 5 spike (1000 UPDATEs)</p>
        </div>
        
        <h2>🎯 Usage Instructions</h2>
        
        <div class="warning">
            <strong>⚠️ Important Notes:</strong>
            <ul>
                <li>All scenarios use high ID ranges (1000-1800+) to avoid collisions</li>
                <li>Each scenario includes both full (1-hour pauses) and quick demo (5-second pauses) versions</li>
                <li>Pre-cleanup and post-cleanup queries are included for each scenario</li>
                <li>Compatible with Guardium outlier detection policies</li>
            </ul>
        </div>
        
        <h3>Deployment Steps:</h3>
        <ol>
            <li>Upload <code>$OutputName.zip</code> via the Content Packs page</li>
            <li>Install the pack - this will create all queries, stories, and users</li>
            <li>Configure your $DatabaseType database connection in SLP</li>
            <li>Navigate to "My Stories" to run individual scenarios</li>
            <li>Use the Scheduler to automate scenario execution</li>
            <li>Monitor results in Guardium for outlier detection alerts</li>
        </ol>
        
        <h3>Story Naming Convention:</h3>
        <ul>
            <li><strong>Full Stories:</strong> Run with 1-hour pauses between baseline hours (realistic timing)</li>
            <li><strong>Quick Demo Stories:</strong> Run with 5-second pauses (for rapid testing)</li>
        </ul>
        
        <h2>📊 Expected Guardium Behavior</h2>
        <p>When these scenarios run, Guardium should detect:</p>
        <ul>
            <li><strong>Baseline Period (Hours 1-4):</strong> Normal activity, no alerts</li>
            <li><strong>Anomaly Period (Hour 5):</strong> Outlier alerts triggered due to 20x spike in operations</li>
            <li><strong>Alert Types:</strong> Depends on Guardium policy configuration (e.g., "Unusual SELECT activity", "Privilege escalation detected")</li>
        </ul>
        
        <div class="info">
            <strong>💡 Pro Tip:</strong> Start with the quick demo versions to verify connectivity and functionality, then use full versions for realistic Guardium testing.
        </div>
        
        <h2>📞 Support</h2>
        <p>For issues or questions, contact the Security Team.</p>
        <p><strong>Created:</strong> $(Get-Date -Format "yyyy-MM-dd")</p>
    </div>
</body>
</html>
"@
    
    $htmlContent | Set-Content "$tempDir\html\index.html"
    Write-Host "  - index.html created" -ForegroundColor Green
    
    # Create ZIP file
    Write-Host "`nCreating ZIP archive..." -ForegroundColor Cyan
    $zipPath = "gdp_lab_contentpacks\$OutputName.zip"
    
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
    
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath -CompressionLevel Optimal
    
    # Cleanup temp directory
    Remove-Item -Path $tempDir -Recurse -Force
    
    Write-Host "`n✅ Successfully created: $zipPath" -ForegroundColor Green
    Write-Host "   Total size: $([math]::Round((Get-Item $zipPath).Length / 1KB, 2)) KB`n" -ForegroundColor Gray
}

# Main execution
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Consolidated Outlier Content Pack Creator                ║" -ForegroundColor Cyan
Write-Host "║  Creates outliers_mysql.zip and outliers_postgres.zip     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Create MySQL consolidated pack
Create-ConsolidatedPack -DatabaseType "mysql" -OutputName "outliers_mysql"

# Create PostgreSQL consolidated pack
Create-ConsolidatedPack -DatabaseType "postgres" -OutputName "outliers_postgres"

Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  ✅ COMPLETED SUCCESSFULLY                                 ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Created files:" -ForegroundColor Cyan
Write-Host "  📦 gdp_lab_contentpacks\outliers_mysql.zip" -ForegroundColor White
Write-Host "  📦 gdp_lab_contentpacks\outliers_postgres.zip" -ForegroundColor White

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Copy these ZIP files to src/main/resources/webroot/contentpacks/" -ForegroundColor Gray
Write-Host "  2. Rebuild with: mvn clean package" -ForegroundColor Gray
Write-Host "  3. Deploy via Content Packs page in SLP" -ForegroundColor Gray
Write-Host ""

# Made with Bob
