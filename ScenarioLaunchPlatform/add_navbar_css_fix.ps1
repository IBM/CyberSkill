# PowerShell script to add navbar CSS fix to specific FTL files

$files = @(
    "src/main/resources/templates/loggedIn/settings.ftl",
    "src/main/resources/templates/loggedIn/user.ftl",
    "src/main/resources/templates/loggedIn/contentpacks.ftl",
    "src/main/resources/templates/loggedIn/storyRunner.ftl"
)

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

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing: $file"
        $content = Get-Content $file -Raw
        
        # Check if the CSS is already present
        if ($content -match "box-sizing: border-box") {
            Write-Host "  CSS already present, skipping" -ForegroundColor Yellow
            continue
        }
        
        # Find the closing </head> tag and insert CSS before it
        if ($content -match "</head>") {
            $content = $content -replace "</head>", "$cssToAdd`r`n</head>"
            Set-Content $file -Value $content -NoNewline
            Write-Host "  Added navbar CSS fix" -ForegroundColor Green
        } else {
            Write-Host "  Could not find </head> tag" -ForegroundColor Red
        }
    } else {
        Write-Host "  File not found: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Navbar CSS fix applied to all specified files!" -ForegroundColor Cyan

# Made with Bob
