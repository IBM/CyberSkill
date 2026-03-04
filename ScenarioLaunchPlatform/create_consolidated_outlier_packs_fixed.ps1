# PowerShell script to create consolidated outlier content packs
# Creates outliers_mysql.zip and outliers_postgres.zip containing all 9 outlier scenarios
# FIXED: Uses contentpacks/ directory which has the correct flat JSON structure

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Consolidated Outlier Content Pack Creator" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

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
    
    Write-Host "`nCreating $OutputName.zip..." -ForegroundColor Cyan
    
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
    
    # Initialize consolidated arrays
    $allQueries = @()
    $allStories = @()
    $allUninstalls = @()
    $allUsers = @()
    
    # Determine suffix for source directories
    $suffix = if ($DatabaseType -eq "postgres") { "_postgres" } else { "" }
    
    # Use contentpacks/ directory which has correct format
    $sourceBase = "contentpacks"
    
    # Process each outlier pack
    foreach ($pack in $outlierPacks) {
        $sourceDir = "$sourceBase\${pack}${suffix}"
        
        if (-not (Test-Path $sourceDir)) {
            Write-Host "WARNING: $sourceDir not found, skipping..." -ForegroundColor Yellow
            continue
        }
        
        Write-Host "  Processing: $pack" -ForegroundColor Green
        
        # Read and merge query_inserts.json
        $queryFile = "$sourceDir\sql\query_inserts.json"
        if (Test-Path $queryFile) {
            $queryData = Get-Content $queryFile -Raw | ConvertFrom-Json
            if ($queryData.queries) {
                $allQueries += $queryData.queries
                Write-Host "    Added $($queryData.queries.Count) queries" -ForegroundColor Gray
            }
        }
        
        # Read and merge story_inserts.json
        $storyFile = "$sourceDir\sql\story_inserts.json"
        if (Test-Path $storyFile) {
            $storyData = Get-Content $storyFile -Raw | ConvertFrom-Json
            if ($storyData.stories) {
                $allStories += $storyData.stories
                Write-Host "    Added $($storyData.stories.Count) stories" -ForegroundColor Gray
            }
        }
        
        # Read and merge uninstall.json
        $uninstallFile = "$sourceDir\sql\uninstall.json"
        if (Test-Path $uninstallFile) {
            $uninstallData = Get-Content $uninstallFile -Raw | ConvertFrom-Json
            if ($uninstallData.queries) { $allUninstalls += $uninstallData.queries }
            if ($uninstallData.stories) { $allUninstalls += $uninstallData.stories }
            if ($uninstallData.users) { $allUninstalls += $uninstallData.users }
        }
        
        # Read and merge users.json (avoid duplicates)
        $usersFile = "$sourceDir\sql\users.json"
        if (Test-Path $usersFile) {
            $userData = Get-Content $usersFile -Raw | ConvertFrom-Json
            if ($userData.users) {
                foreach ($user in $userData.users) {
                    # Check if user already exists (by id)
                    $exists = $allUsers | Where-Object { $_.id -eq $user.id }
                    if (-not $exists) {
                        $allUsers += $user
                    }
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
    
    # Write consolidated JSON files with proper structure
    Write-Host "  Writing consolidated files..." -ForegroundColor Cyan
    
    # query_inserts.json
    $queryOutput = @{ queries = $allQueries }
    $queryOutput | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\query_inserts.json"
    Write-Host "    query_inserts.json: $($allQueries.Count) queries" -ForegroundColor Green
    
    # story_inserts.json
    $storyOutput = @{ stories = $allStories }
    $storyOutput | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\story_inserts.json"
    Write-Host "    story_inserts.json: $($allStories.Count) stories" -ForegroundColor Green
    
    # uninstall.json - separate by type
    $uninstallQueries = $allQueries | ForEach-Object { $_.id }
    $uninstallStories = $allStories | ForEach-Object { $_.id }
    $uninstallUsers = $allUsers | ForEach-Object { $_.id }
    
    $uninstallOutput = @{
        queries = $uninstallQueries
        stories = $uninstallStories
        users = $uninstallUsers
    }
    $uninstallOutput | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\uninstall.json"
    Write-Host "    uninstall.json: $($uninstallQueries.Count) queries, $($uninstallStories.Count) stories, $($uninstallUsers.Count) users" -ForegroundColor Green
    
    # users.json
    if ($allUsers.Count -gt 0) {
        $userOutput = @{ users = $allUsers }
        $userOutput | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\sql\users.json"
        Write-Host "    users.json: $($allUsers.Count) users" -ForegroundColor Green
    }
    
    # Create master pack.json with correct format matching backend expectations
    $packJson = @{
        pack_name = $OutputName
        version = "v1.0"
        db_type = $DatabaseType
        build_date = (Get-Date -Format "dd-MMM-yyyy")
        build_version = "1"
        description = "Consolidated Outlier Detection Pack for $DatabaseType - Contains all 9 outlier scenarios: Account Takeover, Data Leak, Data Tampering, Denial of Service, Insert Anomaly, Massive GRANT, Revoke Anomaly, Schema Tampering, and Update Anomaly"
        author = "Security Team"
        icon = "outliers.png"
        background_traffic = "no"
    }
    
    $packJson | ConvertTo-Json -Depth 10 | Set-Content "$tempDir\pack.json"
    
    # Create master HTML index
    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>$OutputName - Consolidated Outlier Detection Pack</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        .info { background: #d5f4e6; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>$OutputName - Consolidated Outlier Detection Pack</h1>
        <div class="info">
            <strong>Package Information</strong><br>
            Database Type: $DatabaseType<br>
            Total Scenarios: 9<br>
            Total Queries: $($allQueries.Count)<br>
            Total Stories: $($allStories.Count)
        </div>
        <h2>Included Scenarios</h2>
        <ul>
            <li>Account Takeover Detection (ID 1701-1714)</li>
            <li>Data Leak Command Detection (ID 1601-1610)</li>
            <li>Data Tampering Detection (ID 1101-1110)</li>
            <li>Denial of Service Detection (ID 1801-1810)</li>
            <li>Insert Anomaly Detection (ID 1301-1309)</li>
            <li>Massive GRANT Case Detection (ID 1501-1511)</li>
            <li>Revoke Anomaly Detection (ID 1401-1410)</li>
            <li>Schema Tampering Detection (ID 1001-1007)</li>
            <li>Update Anomaly Detection (ID 1201-1210)</li>
        </ul>
    </div>
</body>
</html>
"@
    
    $htmlContent | Set-Content "$tempDir\html\index.html"
    
    # Create ZIP file
    Write-Host "  Creating ZIP archive..." -ForegroundColor Cyan
    $zipPath = "src\main\resources\webroot\contentpacks\$OutputName.zip"
    
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
    
    Compress-Archive -Path "$tempDir\*" -DestinationPath $zipPath -CompressionLevel Optimal
    
    # Cleanup temp directory
    Remove-Item -Path $tempDir -Recurse -Force
    
    Write-Host "  SUCCESS: Created $zipPath" -ForegroundColor Green
    $size = [math]::Round((Get-Item $zipPath).Length / 1KB, 2)
    Write-Host "  Size: $size KB" -ForegroundColor Gray
}

# Main execution
Write-Host ""

# Create MySQL consolidated pack
Create-ConsolidatedPack -DatabaseType "mysql" -OutputName "outliers_mysql"

# Create PostgreSQL consolidated pack
Create-ConsolidatedPack -DatabaseType "postgres" -OutputName "outliers_postgres"

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

Write-Host "`nCreated files:" -ForegroundColor Cyan
Write-Host "  - src\main\resources\webroot\contentpacks\outliers_mysql.zip" -ForegroundColor White
Write-Host "  - src\main\resources\webroot\contentpacks\outliers_postgres.zip" -ForegroundColor White

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "  1. Rebuild with: mvn clean package" -ForegroundColor Gray
Write-Host "  2. Restart SLP" -ForegroundColor Gray
Write-Host "  3. Deploy via Content Packs page in SLP" -ForegroundColor Gray
Write-Host ""

# Made with Bob
