# Outliers JSON Configuration Guide

## Overview

The Outliers feature now supports **one-click deployment** through JSON configuration files. Simply include an `outlier-config.json` file in your ZIP upload, and all scripts and schedules will be automatically configured and added to the system scheduler (cron or Task Scheduler).

## Quick Start

1. Create a ZIP file containing:
   - Your bash or Windows scripts
   - An `outlier-config.json` file (see format below)
   - Optional: README.md or README.txt
   - Optional: Related files (SQL, configs, etc.)

2. Upload the ZIP through the Outliers page

3. Scripts are automatically:
   - Extracted and registered
   - Configured with schedules from JSON
   - Added to cron (Linux) or Task Scheduler (Windows) if enabled

## JSON Configuration Format

### Basic Structure

```json
{
  "outlierName": "Name of your outlier package",
  "description": "Description of what this outlier does",
  "version": "1.0.0",
  "author": "Your Name",
  "scripts": [
    {
      "scriptName": "script_file.sh",
      "scriptType": "bash",
      "description": "What this script does",
      "enabled": true,
      "schedules": [
        {
          "description": "When this runs",
          "cronExpression": "0 2 * * *",
          "parameters": "param1 param2",
          "enabled": true
        }
      ]
    }
  ]
}
```

### Field Descriptions

#### Root Level
- **outlierName** (string, required): Display name for the outlier package
- **description** (string, optional): Description of the outlier's purpose
- **version** (string, optional): Version number
- **author** (string, optional): Author name

#### Script Level
- **scriptName** (string, required): Exact filename of the script in the ZIP
- **scriptType** (string, required): Either "bash" or "windows"
- **description** (string, optional): What the script does
- **enabled** (boolean, required): Whether to add to scheduler immediately
- **schedules** (array, required): List of schedule configurations

#### Schedule Level
- **description** (string, optional): Human-readable schedule description
- **cronExpression** (string, required): Cron expression (5-field format)
- **parameters** (string, optional): Command-line parameters for the script
- **enabled** (boolean, required): Whether this schedule is active

## Cron Expression Format

Standard 5-field cron format:
```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, 0 and 7 are Sunday)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Common Examples

```
0 2 * * *       # Daily at 2:00 AM
0 */6 * * *     # Every 6 hours
30 3 * * 0      # Sundays at 3:30 AM
0 9-17 * * 1-5  # Weekdays 9 AM to 5 PM (hourly)
*/15 * * * *    # Every 15 minutes
0 0 1 * *       # First day of every month at midnight
```

## Complete Example

### Example 1: MySQL Monitoring Scripts

```json
{
  "outlierName": "MySQL Performance Monitor",
  "description": "Automated MySQL performance monitoring and reporting",
  "version": "1.0.0",
  "author": "Jason Flood",
  "scripts": [
    {
      "scriptName": "run_timed_selects_background.sh",
      "scriptType": "bash",
      "description": "Run SELECT operations with time-based pattern",
      "enabled": true,
      "schedules": [
        {
          "description": "Daily execution at 2 AM",
          "cronExpression": "0 2 * * *",
          "parameters": "localhost 3306 MyPassword123 background",
          "enabled": true
        },
        {
          "description": "Weekly execution on Sundays at 3 AM",
          "cronExpression": "0 3 * * 0",
          "parameters": "localhost 3306 MyPassword123 background",
          "enabled": false
        }
      ]
    },
    {
      "scriptName": "cleanup_old_logs.sh",
      "scriptType": "bash",
      "description": "Clean up log files older than 30 days",
      "enabled": true,
      "schedules": [
        {
          "description": "Daily cleanup at midnight",
          "cronExpression": "0 0 * * *",
          "parameters": "/var/log/mysql 30",
          "enabled": true
        }
      ]
    },
    {
      "scriptName": "generate_report.sh",
      "scriptType": "bash",
      "description": "Generate weekly performance report",
      "enabled": true,
      "schedules": [
        {
          "description": "Weekly report on Monday at 6 AM",
          "cronExpression": "0 6 * * 1",
          "parameters": "--format pdf --email admin@example.com",
          "enabled": true
        }
      ]
    }
  ]
}
```

### Example 2: Windows Backup Scripts

```json
{
  "outlierName": "Windows Backup Automation",
  "description": "Automated backup scripts for Windows servers",
  "version": "2.0.0",
  "author": "John Clarke",
  "scripts": [
    {
      "scriptName": "backup_database.bat",
      "scriptType": "windows",
      "description": "Backup SQL Server databases",
      "enabled": true,
      "schedules": [
        {
          "description": "Daily full backup at 1 AM",
          "cronExpression": "0 1 * * *",
          "parameters": "FULL C:\\Backups\\Daily",
          "enabled": true
        },
        {
          "description": "Hourly incremental backup (business hours)",
          "cronExpression": "0 9-17 * * 1-5",
          "parameters": "INCREMENTAL C:\\Backups\\Hourly",
          "enabled": true
        }
      ]
    },
    {
      "scriptName": "cleanup_backups.ps1",
      "scriptType": "windows",
      "description": "Remove backups older than 7 days",
      "enabled": true,
      "schedules": [
        {
          "description": "Daily cleanup at 11 PM",
          "cronExpression": "0 23 * * *",
          "parameters": "-Path C:\\Backups -Days 7",
          "enabled": true
        }
      ]
    }
  ]
}
```

## ZIP File Structure Examples

### Example 1: Simple Structure
```
mysql-monitor.zip
├── outlier-config.json
├── run_timed_selects_background.sh
├── cleanup_old_logs.sh
├── generate_report.sh
└── README.md
```

### Example 2: Organized Structure
```
backup-automation.zip
├── outlier-config.json
├── README.md
├── scripts/
│   ├── backup_database.bat
│   ├── cleanup_backups.ps1
│   └── verify_backup.ps1
├── config/
│   ├── backup_config.json
│   └── email_settings.json
└── sql/
    ├── backup_queries.sql
    └── restore_queries.sql
```

## Behavior

### With JSON Configuration
1. System looks for `outlier-config.json` in ZIP root
2. Extracts all files preserving folder structure
3. Processes each script defined in JSON
4. Creates script entries with configured schedules
5. **Automatically adds enabled scripts to scheduler**
6. Displays detailed console output showing:
   - Outlier name and description
   - Each script found
   - Number of schedules per script
   - Whether auto-added to scheduler

### Without JSON Configuration (Legacy Mode)
1. Extracts all files
2. Auto-detects scripts by extension (.sh, .bash, .bat, .cmd, .ps1)
3. Creates script entries without schedules
4. User must manually add schedules via UI

## OS Compatibility

### Script Type Routing
- **bash scripts** (.sh, .bash) → Linux cron
- **Windows scripts** (.bat, .cmd, .ps1) → Windows Task Scheduler

### Cross-Platform Upload
- You can upload any script type on any OS
- Schedules are only added to the system scheduler if:
  - Script type matches OS (bash on Linux, Windows scripts on Windows)
  - Script is enabled
  - At least one schedule is enabled

### Example Scenarios

| Upload OS | Script Type | Enabled | Result |
|-----------|-------------|---------|--------|
| Linux | bash | Yes | ✓ Added to cron |
| Linux | windows | Yes | ✗ Not added (wrong OS) |
| Windows | windows | Yes | ✓ Added to Task Scheduler |
| Windows | bash | Yes | ✗ Not added (wrong OS) |
| Any | Any | No | ✗ Not added (disabled) |

## Console Output Example

When uploading a ZIP with JSON configuration:

```
========================================
Processing Outlier: MySQL Performance Monitor
Description: Automated MySQL performance monitoring and reporting
Scripts in config: 3
========================================
  ✓ Script: run_timed_selects_background.sh
    Schedules: 2
      - Daily execution at 2 AM (0 2 * * *) [ENABLED]
      - Weekly execution on Sundays at 3 AM (0 3 * * 0) [DISABLED]
    ⚡ Auto-adding to scheduler...
    ✓ Successfully added to scheduler
  ✓ Script: cleanup_old_logs.sh
    Schedules: 1
      - Daily cleanup at midnight (0 0 * * *) [ENABLED]
    ⚡ Auto-adding to scheduler...
    ✓ Successfully added to scheduler
  ✓ Script: generate_report.sh
    Schedules: 1
      - Weekly report on Monday at 6 AM (0 6 * * 1) [ENABLED]
    ⚡ Auto-adding to scheduler...
    ✓ Successfully added to scheduler
========================================
```

## Best Practices

1. **Always include README**: Helps users understand what the outlier does
2. **Use descriptive schedule descriptions**: Makes management easier
3. **Start with schedules disabled**: Test manually before enabling
4. **Group related scripts**: Keep scripts that work together in one ZIP
5. **Version your outliers**: Use semantic versioning (1.0.0, 1.1.0, etc.)
6. **Document parameters**: Explain what each parameter does in README
7. **Test cron expressions**: Use online cron validators before deploying
8. **Include error handling**: Scripts should handle failures gracefully

## Troubleshooting

### Script Not Added to Scheduler
- Check script is enabled in JSON (`"enabled": true`)
- Check at least one schedule is enabled
- Verify OS compatibility (bash on Linux, Windows scripts on Windows)
- Check console output for error messages

### Duplicate Script Error
- Script with same name already exists
- Either delete existing script or rename new one
- System prevents overwriting to avoid data loss

### JSON Parse Error
- Validate JSON syntax (use online JSON validator)
- Check all required fields are present
- Ensure cron expressions are valid
- Verify script names match actual files in ZIP

### Schedule Not Running
- Verify cron expression is correct
- Check script has execute permissions (Linux)
- Review system scheduler logs (crontab -l or Task Scheduler)
- Ensure parameters are correct

## Migration from Manual Configuration

If you have existing scripts without JSON configuration:

1. Export current script details from UI
2. Create `outlier-config.json` with current settings
3. Re-package scripts with JSON file
4. Delete old scripts
5. Upload new ZIP package

## API Integration

The JSON configuration is processed automatically during upload via:
- **Endpoint**: `POST /api/outliers/upload`
- **Method**: `OutliersLibrary.processZipUploadWithConfig()`
- **Returns**: `UploadResult` with added/skipped script counts

## Security Considerations

1. **Validate script sources**: Only upload trusted scripts
2. **Review parameters**: Check for sensitive data in parameters
3. **Use environment variables**: For passwords and secrets
4. **Limit permissions**: Scripts run with user permissions
5. **Audit schedules**: Regularly review what's scheduled

## Future Enhancements

Planned features:
- Schedule templates library
- Bulk enable/disable schedules
- Schedule conflict detection
- Execution history and logs
- Email notifications on failures
- Web-based schedule editor

## Support

For issues or questions:
- Check application logs
- Review console output during upload
- Consult OUTLIERS_MULTIPLE_SCHEDULES.md for schedule management
- Contact: Jason Flood / John Clarke

---

