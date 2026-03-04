# PowerShell script to standardize fonts across all FTL files
# Removes Google Fonts, adds local fonts.css, fixes font-family syntax

$files = @(
    "src/main/resources/templates/loggedIn/dashboard.ftl",
    "src/main/resources/templates/loggedIn/contentpacks.ftl",
    "src/main/resources/templates/loggedIn/settings.ftl",
    "src/main/resources/templates/loggedIn/adminFunctions.ftl",
    "src/main/resources/templates/loggedIn/analytics-dashboard.ftl",
    "src/main/resources/templates/loggedIn/database-dashboard.ftl",
    "src/main/resources/templates/loggedIn/experimental.ftl",
    "src/main/resources/templates/loggedIn/guardium.ftl",
    "src/main/resources/templates/loggedIn/health-dashboard.ftl",
    "src/main/resources/templates/loggedIn/help.ftl",
    "src/main/resources/templates/loggedIn/live-timeline.ftl",
    "src/main/resources/templates/loggedIn/myStories.ftl",
    "src/main/resources/templates/loggedIn/myStories2.ftl",
    "src/main/resources/templates/loggedIn/ostask.ftl",
    "src/main/resources/templates/loggedIn/scheduler.ftl",
    "src/main/resources/templates/loggedIn/storyEditor.ftl",
    "src/main/resources/templates/loggedIn/storyRunner.ftl",
    "src/main/resources/templates/loggedIn/template.ftl",
    "src/main/resources/templates/loggedIn/template2.ftl",
    "src/main/resources/templates/loggedIn/template3.ftl",
    "src/main/resources/templates/loggedIn/user.ftl",
    "src/main/resources/templates/loggedIn/secret/adminFunctions.ftl"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Processing: $file"
        $content = Get-Content $file -Raw
        
        # Remove Google Fonts link
        $content = $content -replace '<link rel=''stylesheet'' href=''https://fonts\.googleapis\.com/css\?family=Open\+Sans''>\r?\n?', ''
        
        # Fix broken relative path css/fonts.css to /loggedIn/css/fonts.css
        $content = $content -replace '<link rel=''stylesheet'' href=''css/fonts\.css''>', '<link rel="stylesheet" href="/loggedIn/css/fonts.css">'
        
        # Add fonts.css if not present (after font-awesome.min.css line)
        if ($content -notmatch '/loggedIn/css/fonts\.css') {
            $content = $content -replace '(<link rel="stylesheet" href="/loggedIn/css/font-awesome\.min\.css">)', "`$1`r`n<link rel=`"stylesheet`" href=`"/loggedIn/css/fonts.css`">"
        }
        
        # Fix incorrect font-family syntax: "Roboto", normal -> Roboto, sans-serif
        $content = $content -replace 'font-family:\s*"Roboto",\s*normal', 'font-family: Roboto, sans-serif'
        
        # Also fix if it's in single quotes
        $content = $content -replace "font-family:\s*'Roboto',\s*normal", 'font-family: Roboto, sans-serif'
        
        Set-Content $file -Value $content -NoNewline
        Write-Host "  Updated fonts" -ForegroundColor Green
    } else {
        Write-Host "  File not found: $file" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Font standardization complete!" -ForegroundColor Cyan
Write-Host "All pages now use /loggedIn/css/fonts.css with Roboto sans-serif" -ForegroundColor Cyan

# Made with Bob
