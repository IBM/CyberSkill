# How to Create Deployable Outlier ZIP Files

## Overview
The "Deploy from Library" feature looks for `.zip` files directly in the `ScenarioLaunchPlatform/outliers/` directory. Currently, you have subdirectories that need to be packaged as ZIP files.

## Current Directory Structure
```
ScenarioLaunchPlatform/outliers/
├── outlier_account_take_over_mysql/
├── outlier_data_leak_command_mysql/
├── outlier_data_tampering_mysql/
├── outlier_denial_of_service_run_mysql/
├── outlier_insert_anomaly_mysql/
├── outlier_massive_grant_case_mysql/
├── outlier_revoke_anomaly_mysql/
├── outlier_schema_tampering_mysql/
└── outlier_update_anomaly_mysql/
```

## Required Structure
```
ScenarioLaunchPlatform/outliers/
├── outlier_account_take_over_mysql.zip
├── outlier_data_leak_command_mysql.zip
├── outlier_data_tampering_mysql.zip
└── ... (other ZIP files)
```

## How to Create ZIP Files

### Option 1: Using Windows File Explorer
1. Navigate to `ScenarioLaunchPlatform/outliers/`
2. Right-click on a subdirectory (e.g., `outlier_account_take_over_mysql`)
3. Select "Send to" → "Compressed (zipped) folder"
4. The ZIP file will be created in the same directory
5. Repeat for each subdirectory

### Option 2: Using PowerShell
Run this command from the `ScenarioLaunchPlatform` directory:

```powershell
# Navigate to outliers directory
cd outliers

# Create ZIP files from each subdirectory
Get-ChildItem -Directory | ForEach-Object {
    $zipPath = "$($_.Name).zip"
    Compress-Archive -Path $_.FullName -DestinationPath $zipPath -Force
    Write-Host "Created: $zipPath"
}
```

### Option 3: Using Command Prompt with PowerShell
```cmd
cd ScenarioLaunchPlatform\outliers
powershell -Command "Get-ChildItem -Directory | ForEach-Object { Compress-Archive -Path $_.FullName -DestinationPath \"$($_.Name).zip\" -Force }"
```

### Option 4: Manual ZIP Creation
1. Open each subdirectory
2. Select all files inside
3. Right-click → "Send to" → "Compressed (zipped) folder"
4. Move the ZIP file to the parent `outliers/` directory
5. Rename to match the directory name

## ZIP File Contents
Each ZIP should contain:
- **Scripts**: `.sh` (bash) or `.bat`/`.ps1` (Windows) files
- **README.md**: (Optional) Documentation about the outlier
- **outlier-config.json**: (Optional) Auto-configuration for schedules
- **Related files**: SQL scripts, config files, etc.

## Example outlier-config.json
```json
{
  "packageName": "Account Takeover Detection",
  "description": "Monitors for suspicious account access patterns",
  "scripts": [
    {
      "scriptName": "monitor_failed_logins.sh",
      "description": "Tracks failed login attempts",
      "schedules": [
        {
          "cronExpression": "*/5 * * * *",
          "description": "Run every 5 minutes",
          "enabled": true
        }
      ]
    }
  ]
}
```

## After Creating ZIP Files

1. **Refresh the Outliers page** in your browser
2. Click **"Deploy from Library"** button
3. You should now see your ZIP files listed
4. Click **"Deploy"** on any package to install it
5. The system will:
   - Extract the ZIP
   - Parse the configuration (if present)
   - Create database entries
   - Set up schedules automatically

## Verification

After deployment, check:
- **Outliers page**: Scripts should appear in the main list
- **Database**: Check `outlier_scripts` and `outlier_schedules` tables
- **Logs**: Review `application-YYYYMMDD.log` for any errors

## Troubleshooting

**No outliers showing in Deploy modal?**
- Ensure ZIP files are directly in `outliers/` directory (not in subdirectories)
- Check file extensions are `.zip` (lowercase)
- Verify the application has read permissions

**Deployment fails?**
- Check the ZIP structure (scripts should be at root or in subdirectories)
- Verify outlier-config.json is valid JSON
- Review application logs for specific errors

## Alternative: Use Regular Upload
If you prefer not to create ZIP files, you can:
1. Use the regular "Upload Outlier Package" feature
2. Select your existing ZIP files or create them on-the-fly
3. Upload directly through the UI

The deployment feature is designed for pre-packaged, frequently-used outliers that you want to deploy quickly without re-uploading.