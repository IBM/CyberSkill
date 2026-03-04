Write-Host "=== Verifying Built Files ===" -ForegroundColor Cyan

# Check if the JAR was built
$jarPath = "target/slp-0.0.1-SNAPSHOT.jar"
if (Test-Path $jarPath) {
    $jarInfo = Get-Item $jarPath
    Write-Host "JAR file exists: $jarPath" -ForegroundColor Green
    Write-Host "Last modified: $($jarInfo.LastWriteTime)" -ForegroundColor Yellow
    
    # Check if leftColumn2.ftl has the fix
    Write-Host "`nChecking source file..." -ForegroundColor Cyan
    $sourceFile = "src/main/resources/templates/loggedIn/includes/leftColumn2.ftl"
    if (Test-Path $sourceFile) {
        $content = Get-Content $sourceFile -Raw
        if ($content -match 'style="border-radius:0;"') {
            Write-Host "Source leftColumn2.ftl contains border-radius:0 fix" -ForegroundColor Green
        } else {
            Write-Host "Source leftColumn2.ftl does NOT contain border-radius:0 fix" -ForegroundColor Red
        }
    }
} else {
    Write-Host "JAR file not found: $jarPath" -ForegroundColor Red
    Write-Host "Run: mvn clean package -DskipTests" -ForegroundColor Yellow
}

Write-Host "`n=== Browser Cache Clearing Instructions ===" -ForegroundColor Cyan
Write-Host "After restarting the application, clear your browser cache:" -ForegroundColor Yellow
Write-Host "Chrome/Edge: Ctrl+Shift+Delete -> Clear cached images and files" -ForegroundColor White
Write-Host "Firefox: Ctrl+Shift+Delete -> Cached Web Content" -ForegroundColor White
Write-Host "OR use Incognito/Private mode to test" -ForegroundColor White
Write-Host "`nAlternatively, do a hard refresh on the page:" -ForegroundColor Yellow
Write-Host "Ctrl+F5 or Ctrl+Shift+R" -ForegroundColor White

Write-Host "`n=== Restart Instructions ===" -ForegroundColor Cyan
Write-Host "1. Stop the application (if running)" -ForegroundColor White
Write-Host "2. Run: restartSLP.bat" -ForegroundColor White
Write-Host "3. Clear browser cache or use Incognito mode" -ForegroundColor White
Write-Host "4. Navigate to any page and check left column buttons" -ForegroundColor White

# Made with Bob
