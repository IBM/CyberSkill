# Outliers - Scheduled Scripts Feature

## Overview

The **Outliers** feature allows you to upload, manage, and schedule bash or Windows scripts for automated execution via cron (Linux) or Task Scheduler (Windows). This feature is similar to the Attack Pattern Library but focuses on scheduled script execution.

## Features

- **ZIP Upload**: Upload ZIP files containing multiple scripts (.sh, .bash, .bat, .cmd, .ps1)
- **Script Management**: View, edit, enable/disable, and delete scripts
- **Scheduling**: Set cron expressions for automated execution
- **Type Support**: Supports both bash scripts (Linux) and Windows scripts (batch, PowerShell)
- **Search & Filter**: Search scripts by name, description, or tags; filter by script type
- **Status Tracking**: Track enabled/disabled status and last execution details

## Architecture

**Important**: Following ScenarioLaunchPlatform's architectural pattern, the file upload route with BodyHandler is registered directly in `ClusteredVerticle.java` (not in OutliersHandler). This ensures consistent file upload handling across the application.

### Backend Components

#### 1. Model Classes

**OutlierScript.java** (`outliers/thejasonengine/com/OutlierScript.java`)
- Represents a single script with metadata
- Properties: id, name, description, scriptType, filePath, cronExpression, enabled, etc.
- Supports JSON serialization/deserialization

**OutliersLibrary.java** (`outliers/thejasonengine/com/OutliersLibrary.java`)
- Singleton library managing all scripts
- Handles ZIP file extraction and script storage
- Provides search, filter, and CRUD operations
- Automatically determines script type from file extension

#### 2. REST API Handler

**OutliersHandler.java** (`router/thejasonengine/com/OutliersHandler.java`)
- Registers REST API endpoints for script management
- Handles file uploads, updates, deletions
- Provides statistics and search functionality

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/outliers/scripts` | Get all scripts |
| GET | `/api/outliers/scripts/:id` | Get script by ID |
| GET | `/api/outliers/type/:type/scripts` | Get scripts by type (bash/windows) |
| GET | `/api/outliers/enabled` | Get enabled scripts |
| GET | `/api/outliers/search?q=query` | Search scripts |
| GET | `/api/outliers/stats` | Get statistics |
| POST | `/api/outliers/upload` | Upload ZIP file |
| PUT | `/api/outliers/scripts/:id` | Update script |
| DELETE | `/api/outliers/scripts/:id` | Delete script |
| POST | `/api/outliers/scripts/:id/toggle` | Toggle enabled status |

### Frontend

**outliers.ftl** (`templates/loggedIn/outliers.ftl`)
- User interface for managing scripts
- Drag-and-drop ZIP upload
- Script cards with status indicators
- Modal dialogs for viewing and editing scripts
- Real-time statistics display

## Usage

### 1. Accessing the Page

Navigate to: `http://your-server/loggedIn/outliers.ftl`

### 2. Uploading Scripts

1. **Prepare ZIP File**: Create a ZIP file containing your scripts
   - Bash scripts: `.sh`, `.bash`
   - Windows scripts: `.bat`, `.cmd`, `.ps1`

2. **Upload**: 
   - Click the upload zone or drag and drop the ZIP file
   - Scripts are automatically extracted and added to the library
   - All scripts are **disabled by default** for security

### 3. Managing Scripts

**View Script Details**:
- Click on any script card to view full details
- See file path, size, upload date, and execution history

**Edit Script**:
- Click "Edit" in the script details modal
- Update name, description, cron expression, tags
- Enable/disable the script

**Delete Script**:
- Click "Delete" in the script details modal
- Confirms deletion and removes the script file

**Toggle Status**:
- Click "Toggle Enable/Disable" to quickly change status
- Only enabled scripts will be executed by the scheduler

### 4. Setting Up Scheduled Execution

#### Linux (Cron)

1. Enable the script in the Outliers interface
2. Note the script's file path from the details view
3. Edit your crontab: `crontab -e`
4. Add an entry for each enabled script:

```bash
# Example: Run script daily at 2 AM
0 2 * * * /path/to/outliers-uploads/script-id_scriptname.sh

# Example: Run script every hour
0 * * * * /path/to/outliers-uploads/script-id_scriptname.sh
```

#### Windows (Task Scheduler)

1. Enable the script in the Outliers interface
2. Note the script's file path from the details view
3. Open Task Scheduler
4. Create a new task:
   - **General**: Set name and description
   - **Triggers**: Set schedule (e.g., daily at 2 AM)
   - **Actions**: 
     - Action: Start a program
     - Program/script: `cmd.exe` (for .bat/.cmd) or `powershell.exe` (for .ps1)
     - Arguments: `/c "C:\path\to\outliers-uploads\script-id_scriptname.bat"`
   - **Conditions**: Configure as needed
   - **Settings**: Configure as needed

### 5. Cron Expression Format

The cron expression field accepts standard cron format:

```
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

**Examples**:
- `0 2 * * *` - Daily at 2:00 AM
- `*/15 * * * *` - Every 15 minutes
- `0 0 * * 0` - Weekly on Sunday at midnight
- `0 9-17 * * 1-5` - Every hour from 9 AM to 5 PM, Monday to Friday

## File Storage

Scripts are stored in the `outliers-uploads/` directory with the following naming convention:
```
{script-id}_{original-filename}
```

Example: `a1b2c3d4-e5f6-7890-abcd-ef1234567890_backup.sh`

## Security Considerations

1. **Default Disabled**: All uploaded scripts are disabled by default
2. **Review Before Enable**: Always review script content before enabling
3. **File Permissions**: Ensure proper file permissions on Linux (chmod +x for bash scripts)
4. **Execution Context**: Scripts run with the permissions of the cron/Task Scheduler user
5. **Logging**: Monitor script execution logs for errors or security issues
6. **Access Control**: Only authorized users should have access to the Outliers page

## Best Practices

1. **Naming**: Use descriptive names for scripts
2. **Documentation**: Add detailed descriptions explaining what each script does
3. **Tags**: Use tags to categorize scripts (e.g., "backup", "maintenance", "daily")
4. **Testing**: Test scripts manually before scheduling
5. **Monitoring**: Regularly check execution history and logs
6. **Cleanup**: Remove unused or obsolete scripts
7. **Version Control**: Keep original scripts in version control
8. **Error Handling**: Include error handling in your scripts
9. **Notifications**: Configure scripts to send notifications on failure
10. **Backup**: Maintain backups of critical scripts

## Troubleshooting

### Script Not Executing

1. **Check Status**: Ensure script is enabled in Outliers interface
2. **Verify Cron/Task**: Confirm cron job or scheduled task is configured correctly
3. **File Permissions**: On Linux, ensure script has execute permissions
4. **Path**: Verify the file path in cron/Task Scheduler matches the actual location
5. **Logs**: Check system logs (cron logs, Task Scheduler history)

### Upload Fails

1. **File Format**: Ensure file is a valid ZIP archive
2. **File Size**: Check if file size exceeds server limits
3. **Script Types**: Verify ZIP contains supported script types
4. **Permissions**: Ensure server has write permissions to outliers-uploads directory

### Script Execution Errors

1. **Dependencies**: Ensure all required dependencies are installed
2. **Environment**: Check if script requires specific environment variables
3. **Working Directory**: Scripts may need to run from a specific directory
4. **User Context**: Verify the user running the script has necessary permissions

## Integration with Existing Systems

The Outliers feature integrates seamlessly with:
- **Attack Pattern Library**: Similar UI/UX for consistency
- **Authentication**: Uses existing JWT authentication
- **File Upload**: Leverages Vert.x file upload capabilities
- **Logging**: Uses Log4j2 for consistent logging

## Future Enhancements

Potential improvements:
- Built-in scheduler (eliminate need for external cron/Task Scheduler)
- Script execution history with detailed logs
- Script output capture and display
- Script dependencies and chaining
- Notification system for execution failures
- Script templates library
- Version control integration
- Execution statistics and analytics


This feature was created to provide a centralized way to manage and schedule scripts across Linux and Windows environments, making it easier to automate routine tasks and maintenance operations.