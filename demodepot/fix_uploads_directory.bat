@echo off
echo Fixing uploads directory issue...
echo.

REM Check if webroot\uploads exists
if exist webroot\uploads (
    echo Found webroot\uploads
    
    REM Check if it's a file
    if exist webroot\uploads\* (
        echo webroot\uploads is already a directory - no action needed
    ) else (
        echo webroot\uploads is a FILE - deleting it...
        del /F webroot\uploads
        echo Creating webroot\uploads as a directory...
        mkdir webroot\uploads
        echo Done! webroot\uploads is now a directory
    )
) else (
    echo webroot\uploads does not exist - creating it...
    mkdir webroot\uploads
    echo Done! Created webroot\uploads directory
)

echo.
echo You can now restart your Java application.
pause

@REM Made with Bob
