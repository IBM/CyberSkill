# Monday.com Integration Setup Guide

## Overview

The DemoDepot application now includes automatic Monday.com integration. When a demo request is submitted (not saved as draft), a task is automatically created in your Monday.com board.

## Features

✅ **Automatic Task Creation** - Tasks are created when demo requests are submitted  
✅ **Smart Status Mapping** - DemoDepot statuses map to Monday.com labels  
✅ **Rich Data Transfer** - Includes requester name, email, customer, date, and more  
✅ **Error Resilience** - Monday.com failures don't block demo request creation  
✅ **Easy Configuration** - Simple properties file configuration  
✅ **Optional Integration** - Can be enabled/disabled without code changes

## Setup Instructions

### Step 1: Get Your Monday.com API Token

1. Log in to your Monday.com account
2. Click your profile picture (bottom left)
3. Go to **Admin** → **API**
4. Click **Generate API v2 Token**
5. Copy the token (starts with "eyJ...")
6. **Important**: Keep this token secure!

### Step 2: Get Your Board ID

1. Open the Monday.com board where you want tasks created
2. Look at the URL in your browser
3. The Board ID is the number in the URL
   - Example: `https://monday.com/boards/1234567890`
   - Board ID: `1234567890`

### Step 3: (Optional) Get Your Group ID

If you want tasks created in a specific group/section:

1. Open your board
2. Click on the group name
3. The Group ID appears in the URL or you can use the API to find it
4. If you don't specify a group, tasks go to the default group

### Step 4: Configure DemoDepot

1. Open the file: `src/main/resources/monday-config.properties`
2. Update the configuration:

```properties
# Enable Monday.com integration
monday.enabled=true

# Your API Token
monday.api.token=eyJhbGciOiJIUzI1NiJ9.eyJ0aWQiOjEyMzQ1Njc4OSwiaWF0IjoxNjc4OTAxMjM0fQ.example

# Your Board ID
monday.board.id=1234567890

# Optional: Group ID (leave empty for default group)
monday.group.id=
```

3. Save the file
4. Restart the DemoDepot application

### Step 5: Test the Integration

1. Log in to DemoDepot
2. Create a new demo request
3. Click **Submit** (not "Save as Draft")
4. Check your Monday.com board - a new task should appear!

## How It Works

### When Tasks Are Created

- ✅ When a demo request is **submitted**
- ❌ NOT when saved as draft
- ❌ NOT when editing existing requests

### Data Mapping

| DemoDepot Field | Monday.com Column | Column Type | Notes |
|----------------|-------------------|-------------|-------|
| Demo Title | Item | Text | Main task title |
| Demo Type | Group | Group | Auto-routes to correct section |
| Delivery Date | Date | Date | Demo date (YYYY-MM-DD) |
| Status | Status | Status | Mapped to Monday labels |
| Demo Script | Files | Files | Auto-uploaded from form |

### Group Routing

Tasks are automatically placed in the correct Monday.com group based on demo type:

| DemoDepot Demo Type | Monday.com Group | Group ID |
|--------------------|------------------|----------|
| Feature Flash | Feature Flash | topics |
| Standard | Standard | group_title |
| Extended | Extended | group_mm1j259k |

**Note**: The demo_script file uploaded in the form is automatically attached to the Monday.com task.

### Status Mapping

| DemoDepot Status | Monday.com Label |
|-----------------|------------------|
| pending | Working on it |
| approved | Done |
| rejected | Stuck |
| completed | Done |
| draft | (not synced) |

## Customization

### Changing Column Mappings

The current implementation maps to these Monday.com columns:
- **Item (text)**: Demo title/name
- **Person**: Requester email (auto-assigned if user exists)
- **Status**: Mapped status label
- **Date**: Demo delivery date
- **Files**: Not automatically populated (requires separate API call)

To customize column IDs, edit `src/main/java/com/demodepot/MondayService.java`:

```java
// In buildCreateItemMutation() method
columnValues.put("person", personValue);   // Person column
columnValues.put("status", statusValue);   // Status column
columnValues.put("date", dateValue);       // Date column
```

**Finding Your Column IDs:**
1. Use Monday.com API explorer: https://monday.com/developers/v2/try-it-yourself
2. Query your board structure:
```graphql
query {
  boards(ids: YOUR_BOARD_ID) {
    columns {
      id
      title
      type
    }
  }
}
```

### Changing Status Labels

Edit the `mapStatusToMonday()` method in `MondayService.java`:

```java
private String mapStatusToMonday(String status) {
    switch (status.toLowerCase()) {
        case "pending":
            return "Your Custom Label";
        // ... add more mappings
    }
}
```

## Troubleshooting

### Tasks Not Appearing in Monday.com

**Check the logs:**
```
[INFO] Monday.com integration enabled - Board ID: 1234567890
[INFO] Creating Monday.com task for demo request: My Demo
[INFO] Successfully created Monday.com task
```

**Common issues:**

1. **Integration disabled**
   - Check `monday.enabled=true` in config file

2. **Invalid API token**
   - Verify token is correct and not expired
   - Generate a new token if needed

3. **Wrong Board ID**
   - Double-check the Board ID from URL
   - Make sure you have access to the board

4. **Person column not populated**
   - Email must match a Monday.com user
   - User must have access to the board
   - Check if email is correct in DemoDepot

5. **API errors**
   - Check logs for error messages
   - Verify column IDs match your board structure
   - Ensure board has Person, Status, Date columns

### Demo Requests Still Work

Even if Monday.com integration fails:
- ✅ Demo requests are still created in DemoDepot
- ✅ Users see success message
- ✅ Data is saved to database
- ⚠️ Error is logged for admin review

### Viewing Detailed Logs

Check the application logs for Monday.com activity:
```
grep "Monday.com" logs/application.log
```

## Security Best Practices

1. **Never commit API tokens to Git**
   - The config file should be in `.gitignore`
   - Use environment variables in production

2. **Rotate tokens regularly**
   - Generate new tokens periodically
   - Revoke old tokens

3. **Limit token permissions**
   - Use tokens with minimum required permissions
   - Create board-specific tokens if possible

## Advanced Configuration

### Using Environment Variables

For production, use environment variables instead of the properties file:

```java
// In MondayService.java constructor
this.apiToken = System.getenv("MONDAY_API_TOKEN") != null 
    ? System.getenv("MONDAY_API_TOKEN") 
    : config.getProperty("monday.api.token", "");
```

Then set:
```bash
export MONDAY_API_TOKEN=your_token_here
export MONDAY_BOARD_ID=1234567890
```

### Multiple Boards

To support multiple boards (e.g., different boards per product):

1. Add board mapping logic in `MondayService.java`
2. Use product name or demo type to select board
3. Store multiple board IDs in config

## API Reference

### MondayService Methods

**`createTask(JsonObject demoRequest)`**
- Creates a new task in Monday.com
- Returns: `Future<JsonObject>` with task details
- Async operation - doesn't block request

**`updateTaskStatus(String itemId, String status)`**
- Updates task status (for future use)
- Can be called when admin changes status

### GraphQL Mutations

The service uses Monday.com's GraphQL API:

```graphql
mutation {
  create_item (
    board_id: 1234567890,
    item_name: "Demo Title",
    column_values: "{\"text\":\"John Doe\"}"
  ) {
    id
    name
  }
}
```

## Support

For issues with:
- **DemoDepot integration**: Check application logs
- **Monday.com API**: Visit https://developer.monday.com
- **API limits**: Monday.com has rate limits (check their docs)

## Future Enhancements

Potential improvements:
- [ ] Bi-directional sync (Monday.com → DemoDepot)
- [ ] Webhook support for real-time updates
- [ ] Attachment upload to Monday.com
- [ ] Custom field mapping UI
- [ ] Multiple board support
- [ ] Status update sync

## Version History

- **v1.0** (2026-03-18): Initial Monday.com integration
  - Automatic task creation on submit
  - Configurable via properties file
  - Status mapping
  - Error resilience