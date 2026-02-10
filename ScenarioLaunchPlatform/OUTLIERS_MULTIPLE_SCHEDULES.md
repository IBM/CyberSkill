# Outliers Multiple Schedules Feature

## Overview

The Outliers feature now supports **multiple schedules per script**, allowing you to run the same script at different times with different parameters.

## Use Case Example

Run the same database cleanup script at different times with different parameters:

```bash
# Morning cleanup - background mode
0 2 * * * /path/to/run_timed_deletes_background.sh localhost 3306 MyPassword123 bg

# Evening cleanup - foreground mode  
0 5 * * * /path/to/run_timed_deletes_background.sh localhost 3306 MyPassword123 fg
```

## How It Works

### Data Model

Each script can have multiple `ScriptSchedule` objects:

```java
public class ScriptSchedule {
    private String scheduleId;        // Unique ID for this schedule
    private String cronExpression;    // When to run (e.g., "0 2 * * *")
    private String parameters;        // Command-line args for this schedule
    private boolean enabled;          // Enable/disable this specific schedule
    private String description;       // Human-readable description
}
```

### Crontab Integration (Linux)

Each schedule creates a separate crontab entry with a unique identifier:

```bash
# Outliers Script: abc-123 [schedule-id-1] - Morning cleanup
0 2 * * * /path/to/script.sh localhost 3306 MyPassword123 bg

# Outliers Script: abc-123 [schedule-id-2] - Evening cleanup
0 5 * * * /path/to/script.sh localhost 3306 MyPassword123 fg
```

The system uses the schedule ID in brackets `[schedule-id]` to track and manage individual schedules.

### Task Scheduler Integration (Windows)

Each schedule creates a separate Windows task:

```
OutliersScript_abc-123_schedule-id-1
OutliersScript_abc-123_schedule-id-2
```

## API Endpoints

### Get Script with Schedules

```http
GET /api/outliers/scripts/{scriptId}
```

Response includes `schedules` array:

```json
{
  "success": true,
  "script": {
    "id": "abc-123",
    "name": "cleanup_script.sh",
    "schedules": [
      {
        "scheduleId": "schedule-id-1",
        "cronExpression": "0 2 * * *",
        "parameters": "localhost 3306 MyPassword123 bg",
        "enabled": true,
        "description": "Morning cleanup"
      },
      {
        "scheduleId": "schedule-id-2",
        "cronExpression": "0 5 * * *",
        "parameters": "localhost 3306 MyPassword123 fg",
        "enabled": true,
        "description": "Evening cleanup"
      }
    ]
  }
}
```

### Add Schedule to Script

```http
POST /api/outliers/scripts/{scriptId}/schedules
Content-Type: application/json

{
  "cronExpression": "0 2 * * *",
  "parameters": "localhost 3306 MyPassword123 bg",
  "enabled": true,
  "description": "Morning cleanup"
}
```

### Update Schedule

```http
PUT /api/outliers/scripts/{scriptId}/schedules/{scheduleId}
Content-Type: application/json

{
  "cronExpression": "0 3 * * *",
  "parameters": "localhost 3306 MyPassword123 bg",
  "enabled": true,
  "description": "Updated morning cleanup"
}
```

### Delete Schedule

```http
DELETE /api/outliers/scripts/{scriptId}/schedules/{scheduleId}
```

### Toggle Schedule

```http
POST /api/outliers/scripts/{scriptId}/schedules/{scheduleId}/toggle
```

## Scheduler Behavior

### When Script is Enabled

- All enabled schedules are added to crontab/Task Scheduler
- Each schedule creates a separate entry
- Schedules can be individually enabled/disabled

### When Script is Disabled

- All schedules are removed from crontab/Task Scheduler
- Schedule configurations are preserved in memory
- Re-enabling the script restores all enabled schedules

### When Schedule is Added

- If script is enabled, the new schedule is immediately added to crontab/Task Scheduler
- If script is disabled, schedule is stored but not added to scheduler

### When Schedule is Updated

- Old schedule entry is removed from crontab/Task Scheduler
- New schedule entry is added (if enabled)
- Changes take effect immediately

### When Schedule is Deleted

- Schedule entry is removed from crontab/Task Scheduler
- Schedule is removed from script's schedule list

## Backward Compatibility

The system maintains backward compatibility with the old single cron/parameters model:

- Old scripts with `cronExpression` and `parameters` fields are automatically migrated
- On load, a single schedule is created from the old fields
- The old fields are marked as deprecated but still functional

## Verification

### Linux - View All Schedules for a Script

```bash
crontab -l | grep "Outliers Script: abc-123"
```

Output:
```bash
# Outliers Script: abc-123 [schedule-id-1] - Morning cleanup
0 2 * * * /path/to/script.sh localhost 3306 MyPassword123 bg
# Outliers Script: abc-123 [schedule-id-2] - Evening cleanup
0 5 * * * /path/to/script.sh localhost 3306 MyPassword123 fg
```

### Windows - View All Tasks for a Script

```powershell
schtasks /query /tn "OutliersScript_abc-123_*"
```

## UI Implementation (To Be Added)

The UI should include:

1. **Schedules Tab/Section** in script details view
2. **Add Schedule Button** to create new schedules
3. **Schedule List** showing all schedules with:
   - Cron expression
   - Parameters
   - Description
   - Enable/disable toggle
   - Edit button
   - Delete button
4. **Schedule Editor Modal** for adding/editing schedules

## Example Usage

### Scenario: Database Maintenance Script

You have a script `db_maintenance.sh` that needs to run:
- Daily at 2 AM for full backup
- Daily at 6 AM for incremental backup
- Weekly on Sunday at 3 AM for deep cleanup

**Schedule 1: Full Backup**
- Cron: `0 2 * * *`
- Parameters: `--mode=full --database=prod`
- Description: "Daily full backup"

**Schedule 2: Incremental Backup**
- Cron: `0 6 * * *`
- Parameters: `--mode=incremental --database=prod`
- Description: "Daily incremental backup"

**Schedule 3: Deep Cleanup**
- Cron: `0 3 * * 0`
- Parameters: `--mode=cleanup --deep --database=prod`
- Description: "Weekly deep cleanup"

All three schedules will be added to crontab:

```bash
# Outliers Script: db-maint-001 [sched-1] - Daily full backup
0 2 * * * /path/to/db_maintenance.sh --mode=full --database=prod

# Outliers Script: db-maint-001 [sched-2] - Daily incremental backup
0 6 * * * /path/to/db_maintenance.sh --mode=incremental --database=prod

# Outliers Script: db-maint-001 [sched-3] - Weekly deep cleanup
0 3 * * 0 /path/to/db_maintenance.sh --mode=cleanup --deep --database=prod
```

## Benefits

1. **Flexibility**: Run the same script with different configurations
2. **Simplicity**: Manage all schedules for a script in one place
3. **Clarity**: Each schedule has a description explaining its purpose
4. **Control**: Enable/disable individual schedules without affecting others
5. **Traceability**: Each schedule has a unique ID for tracking

## Technical Notes

- Schedule IDs are UUIDs generated automatically
- Crontab entries include schedule ID in brackets for identification
- Windows tasks include schedule ID in task name
- All schedules are stored in the script's JSON representation
- Scheduler operations are atomic per schedule

---
