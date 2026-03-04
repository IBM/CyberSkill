# PowerShell script to add navbar CSS fix to ALL FTL files that need it

$cssToAdd = @"
<style>
*, *::before, *::after { box-sizing: border-box; }
.w3-top, .w3-top *, .w3-bar, .w3-bar *, .w3-bar-item, .w3-button { 
  border-radius: 0 !important; 
}
.w3-bar .w3-button:hover, .w3-bar .w3-bar-item:hover {
  background-color: white !important;
  color: #000 !important;
}
</style>
"@

# Get all FTL files in loggedIn directory
$files = Get-ChildItem -Path "src/main/resources/templates/loggedIn" -Filter "*.ftl" -File

$updated = 0
$skipped = 0
$errors = 0

foreach ($file in $files) {
    $filePath = $file.FullName
    Write-Host "Processing: $($file.Name)"
    
    try {
        $content = Get-Content $filePath -Raw
        
        # Check if the CSS is already present
        if ($content -match "box-sizing: border-box") {
            Write-Host "  Already has CSS, skipping" -ForegroundColor Yellow
            $skipped++
            continue
        }
        
        # Find the closing </head> tag and insert CSS before it
        if ($content -match "</head>") {
            $content = $content -replace "</head>", "$cssToAdd`r`n</head>"
            Set-Content $filePath -Value $content -NoNewline
            Write-Host "  Added navbar CSS fix" -ForegroundColor Green
            $updated++
        } else {
            Write-Host "  No </head> tag found, skipping" -ForegroundColor Yellow
            $skipped++
        }
    } catch {
        Write-Host "  Error: $_" -ForegroundColor Red
        $errors++
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Updated: $updated files" -ForegroundColor Green
Write-Host "  Skipped: $skipped files" -ForegroundColor Yellow
Write-Host "  Errors: $errors files" -ForegroundColor Red

# Made with Bob
