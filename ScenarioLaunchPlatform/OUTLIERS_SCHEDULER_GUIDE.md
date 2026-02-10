# Outliers Scheduler Integration Guide

## Overview

The Outliers feature automatically integrates uploaded scripts with the system's native scheduler:
- **Linux/Unix/Mac**: crontab
- **Windows**: Task Scheduler

When you enable a script with a cron expression, it is automatically added to the appropriate system scheduler.

## How It Works

### Automatic Scheduler Management

1. **Enable Script**: When you toggle a script to "enabled" or update it with a cron expression, the system automatically:
   - Detects your operating system
   - Adds the script to crontab (Linux) or Task Scheduler (Windows)
   - Uses the script's file path, cron expression, and parameters

2. **Disable Script**: When you disable a script, it is automatically removed from the scheduler

3. **Update Script**: When you update a script's cron expression or parameters:
   - The old schedule is removed
   - A new schedule is created with updated settings

4. **Delete Script**: When you delete a script, it is automatically removed from the scheduler

### Linux/Unix/Mac Integration

On Linux systems, scripts are added to the user's crontab with:
- A comment identifying the script by ID and name
- The cron expression
- The full path to the script
- Any parameters specified

**Example crontab entry:**
```bash
# Outliers Script: abc-123-def - backup_database.sh
0 2 * * * /path/to/outliers-uploads/extract-id/backup_database.sh --database=prod
```

**Viewing your crontab:**
```bash
crontab -l
```

**Manual removal (if needed):**
```bash
crontab -e
# Remove the lines for the Outliers script
```

### Windows Integration

On Windows systems, scripts are added to Task Scheduler with:
- Task name: `OutliersScript_{script-id}`
- The script path and parameters
- A schedule converted from the cron expression

**Viewing tasks:**
```powershell
schtasks /query /tn "OutliersScript_*"
```

**Manual removal (if needed):**
```powershell
schtasks /delete /tn "OutliersScript_{script-id}" /f
```

## Cron Expression Format

Standard cron format (5 fields):
```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday=0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Common Examples

| Expression | Description |
|------------|-------------|
| `0 2 * * *` | Daily at 2:00 AM |
| `*/15 * * * *` | Every 15 minutes |
| `0 */6 * * *` | Every 6 hours |
| `0 9 * * 1-5` | Weekdays at 9:00 AM |
| `30 3 1 * *` | First day of month at 3:30 AM |
| `0 0 * * 0` | Every Sunday at midnight |

## Script Parameters

You can specify command-line parameters for your scripts in the "Parameters" field. These will be passed to the script when it runs.

**Examples:**
- `--database=prod --backup-dir=/backups`
- `-v --config=/etc/myapp.conf`
- `arg1 arg2 arg3`

## Permissions

### Linux Requirements

1. **Script Execution Permission:**
   ```bash
   chmod +x /path/to/script.sh
   ```

2. **Crontab Access:**
   - The user running ScenarioLaunchPlatform must have permission to modify crontab
   - Usually works for regular users; may need sudo for system-wide cron

3. **Script File Access:**
   - Ensure the script can access any files/databases it needs
   - Consider using absolute paths in your scripts

### Windows Requirements

1. **Task Scheduler Access:**
   - The user must have permission to create scheduled tasks
   - May require administrator privileges

2. **Script Execution Policy:**
   - For PowerShell scripts, ensure execution policy allows:
     ```powershell
     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
     ```

3. **File Permissions:**
   - Ensure the script has necessary file system permissions

## Troubleshooting

### Linux Issues

**Problem: Script not running**
1. Check crontab: `crontab -l`
2. Verify script permissions: `ls -l /path/to/script.sh`
3. Check cron logs: `grep CRON /var/log/syslog`
4. Test script manually: `/path/to/script.sh`

**Problem: Script runs but fails**
1. Add logging to your script
2. Use absolute paths for all files/commands
3. Set environment variables explicitly in the script
4. Check cron mail: `mail` or `/var/mail/username`

### Windows Issues

**Problem: Task not created**
1. Check Task Scheduler: `schtasks /query`
2. Verify user permissions
3. Check application logs in Event Viewer

**Problem: Task created but not running**
1. Open Task Scheduler GUI
2. Find task: `OutliersScript_{id}`
3. Check "Last Run Result" and "History" tab
4. Verify script path and parameters

## Best Practices

1. **Test Scripts Manually First:**
   - Run your script manually before scheduling
   - Verify it works with the specified parameters

2. **Use Absolute Paths:**
   - In scripts, use full paths for files and commands
   - Don't rely on relative paths or current directory

3. **Add Logging:**
   - Have scripts log their output
   - Include timestamps and error messages

4. **Handle Errors:**
   - Use proper error handling in scripts
   - Exit with appropriate status codes

5. **Set Appropriate Schedules:**
   - Don't schedule resource-intensive tasks too frequently
   - Consider system load and business hours

6. **Monitor Execution:**
   - Regularly check if scripts are running successfully
   - Review logs for errors

## Security Considerations

1. **Script Content:**
   - Review uploaded scripts before enabling
   - Ensure scripts don't contain malicious code

2. **File Permissions:**
   - Scripts run with the permissions of the SLP user
   - Be cautious with scripts that modify system files

3. **Credentials:**
   - Don't hardcode passwords in scripts
   - Use environment variables or secure credential stores

4. **Network Access:**
   - Be aware of what network resources scripts access
   - Consider firewall rules and network policies

## Manual Scheduler Management

If you need to manually manage scheduled tasks:

### Linux - View All Outliers Scripts
```bash
crontab -l | grep "Outliers Script"
```

### Linux - Remove All Outliers Scripts
```bash
crontab -l | grep -v "Outliers Script" | crontab -
```

### Windows - View All Outliers Tasks
```powershell
schtasks /query /fo LIST | findstr "OutliersScript"
```

### Windows - Remove All Outliers Tasks
```powershell
schtasks /query /tn "OutliersScript_*" /fo LIST | findstr "TaskName" | ForEach-Object { $_.Split(":")[1].Trim() } | ForEach-Object { schtasks /delete /tn $_ /f }
```

## Support

For issues or questions:
1. Check application logs: `ScenarioLaunchPlatform/application.log`
2. Review this documentation
3. Test scripts manually before scheduling
4. Verify system permissions and access

## Technical Details

### Implementation

- **OutliersLibrary.java**: Contains scheduler integration methods
  - `addToScheduler()`: Adds script to system scheduler
  - `removeFromScheduler()`: Removes script from scheduler
  - `addToLinuxCron()`: Linux-specific implementation
  - `addToWindowsTaskScheduler()`: Windows-specific implementation

- **OutliersHandler.java**: Calls scheduler methods when:
  - Script is enabled/disabled (toggleScript)
  - Script is updated (updateScript)
  - Script is deleted (deleteScript)

### Cron Expression Conversion

For Windows Task Scheduler, cron expressions are converted to Task Scheduler format. The current implementation uses a simplified conversion (DAILY schedule). For more complex schedules, you may need to enhance the `convertCronToTaskScheduler()` method in OutliersLibrary.java.

---
