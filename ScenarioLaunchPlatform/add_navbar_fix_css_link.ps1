# PowerShell script to add navbar-fix.css link to all FTL files

$files = Get-ChildItem -Path "src/main/resources/templates/loggedIn" -Filter "*.ftl" -File

$updated = 0
$skipped = 0

foreach ($file in $files) {
    $filePath = $file.FullName
    Write-Host "Processing: $($file.Name)"
    
    try {
        $content = Get-Content $filePath -Raw
        
        # Check if navbar-fix.css is already present
        if ($content -match "navbar-fix\.css") {
            Write-Host "  Already has navbar-fix.css, skipping" -ForegroundColor Yellow
            $skipped++
            continue
        }
        
        # Add navbar-fix.css after w3-theme-blue-grey.css
        if ($content -match 'w3-theme-blue-grey\.css">') {
            $content = $content -replace '(w3-theme-blue-grey\.css">)', "`$1`r`n<link rel=`"stylesheet`" href=`"/loggedIn/css/navbar-fix.css`">"
            Set-Content $filePath -Value $content -NoNewline
            Write-Host "  Added navbar-fix.css link" -ForegroundColor Green
            $updated++
        } else {
            Write-Host "  No w3-theme-blue-grey.css found, skipping" -ForegroundColor Yellow
            $skipped++
        }
    } catch {
        Write-Host "  Error: $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Updated: $updated files" -ForegroundColor Green
Write-Host "  Skipped: $skipped files" -ForegroundColor Yellow

# Made with Bob
