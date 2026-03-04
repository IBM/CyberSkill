# Fix CSS paths in all FTL files to use /loggedIn/ prefix

$files = @(
    "src/main/resources/templates/loggedIn/user.ftl",
    "src/main/resources/templates/loggedIn/template3.ftl",
    "src/main/resources/templates/loggedIn/template2.ftl",
    "src/main/resources/templates/loggedIn/template.ftl",
    "src/main/resources/templates/loggedIn/storyRunner.ftl",
    "src/main/resources/templates/loggedIn/storyEditor.ftl",
    "src/main/resources/templates/loggedIn/settings.ftl",
    "src/main/resources/templates/loggedIn/secret/adminFunctions.ftl",
    "src/main/resources/templates/loggedIn/scheduler.ftl",
    "src/main/resources/templates/loggedIn/ostask.ftl",
    "src/main/resources/templates/loggedIn/noAccess.ftl",
    "src/main/resources/templates/loggedIn/myStories2.ftl",
    "src/main/resources/templates/loggedIn/myStories.ftl",
    "src/main/resources/templates/loggedIn/live-timeline.ftl",
    "src/main/resources/templates/loggedIn/help.ftl",
    "src/main/resources/templates/loggedIn/health-dashboard.ftl",
    "src/main/resources/templates/loggedIn/guardium.ftl",
    "src/main/resources/templates/loggedIn/experimental.ftl",
    "src/main/resources/templates/loggedIn/error.ftl",
    "src/main/resources/templates/loggedIn/database-dashboard.ftl",
    "src/main/resources/templates/loggedIn/dashboard.ftl",
    "src/main/resources/templates/loggedIn/contentpacks.ftl",
    "src/main/resources/templates/loggedIn/analytics-dashboard.ftl",
    "src/main/resources/templates/loggedIn/adminFunctions.ftl"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "Fixing: $file"
        $content = Get-Content $file -Raw
        
        # Replace relative CSS paths with absolute paths
        $content = $content -replace 'href="css/', 'href="/loggedIn/css/'
        $content = $content -replace 'src="js/', 'src="/loggedIn/js/'
        
        Set-Content $file $content -NoNewline
        Write-Host "  Fixed"
    } else {
        Write-Host "  File not found: $file"
    }
}

Write-Host ""
Write-Host "Done! Fixed CSS and JS paths in all files."

# Made with Bob
