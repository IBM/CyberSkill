# Monday.com Integration Guide

## Overview
Automatically create Monday.com tasks when demo requests are submitted in DemoDepot.

## Prerequisites

### 1. Monday.com API Token
1. Go to https://monday.com
2. Click your profile picture → Admin → API
3. Generate a new API token
4. Copy the token (keep it secure!)

### 2. Board ID
1. Open your Monday.com board
2. Look at the URL: `https://monday.com/boards/1234567890`
3. The number `1234567890` is your Board ID

### 3. Group ID (Optional)
1. Open your board
2. Right-click on a group name
3. Select "Copy group ID"

## Implementation Steps

### Step 1: Add Monday.com Configuration

Create a configuration file: `src/main/resources/monday-config.properties`

```properties
# Monday.com API Configuration
monday.api.token=YOUR_API_TOKEN_HERE
monday.board.id=YOUR_BOARD_ID_HERE
monday.group.id=YOUR_GROUP_ID_HERE
monday.api.url=https://api.monday.com/v2
```

### Step 2: Add Vert.x Web Client Dependency

Add to `pom.xml`:

```xml
<dependency>
    <groupId>io.vertx</groupId>
    <artifactId>vertx-web-client</artifactId>
    <version>4.5.11</version>
</dependency>
```

### Step 3: Implementation Code

The integration will:
- ✅ Create a Monday.com item when status changes to "submitted"
- ✅ Include all demo request details
- ✅ Set proper column values
- ✅ Handle errors gracefully
- ✅ Log all API calls

## Monday.com GraphQL Mutation

```graphql
mutation {
  create_item (
    board_id: BOARD_ID,
    group_id: "GROUP_ID",
    item_name: "Demo Request: TITLE",
    column_values: "{
      \"text\": \"PM Owner Name\",
      \"text0\": \"Product Name\",
      \"date\": \"2024-12-31\",
      \"status\": \"Submitted\"
    }"
  ) {
    id
    name
  }
}
```

## Column Mapping

Map DemoDepot fields to Monday.com columns:

| DemoDepot Field | Monday.com Column | Type |
|----------------|-------------------|------|
| title | Item Name | Text |
| pm_owner | PM Owner | Text |
| product_name | Product | Text |
| delivery_date | Delivery Date | Date |
| status | Status | Status |
| demo_type | Demo Type | Text |
| requester_email | Email | Email |

## Testing

### 1. Test API Connection
```bash
curl -X POST https://api.monday.com/v2 \
  -H "Authorization: YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"query": "{ boards(ids: YOUR_BOARD_ID) { name } }"}'
```

### 2. Test Item Creation
Submit a demo request and check:
- ✅ Item appears in Monday.com board
- ✅ All fields are populated correctly
- ✅ Status is set to "Submitted"
- ✅ Logs show successful API call

## Error Handling

The integration handles:
- ❌ Invalid API token
- ❌ Board not found
- ❌ Network errors
- ❌ Rate limiting
- ✅ Graceful fallback (request still saves to database)

## Security Best Practices

1. **Never commit API tokens** to version control
2. Use environment variables: `MONDAY_API_TOKEN`
3. Rotate tokens regularly
4. Use read-only tokens where possible
5. Monitor API usage

## Rate Limits

Monday.com API limits:
- **Free Plan**: 60 requests/minute
- **Basic Plan**: 120 requests/minute
- **Standard+**: 240 requests/minute

## Webhook Alternative

For real-time updates, consider Monday.com webhooks:
1. Create webhook in Monday.com
2. Point to your server endpoint
3. Receive updates when items change

## Benefits

✅ **Automatic Task Creation** - No manual entry needed
✅ **Centralized Tracking** - All requests in Monday.com
✅ **Team Visibility** - Everyone sees new requests
✅ **Workflow Automation** - Trigger Monday.com automations
✅ **Reporting** - Use Monday.com analytics

## Next Steps

1. Get your Monday.com API token
2. Find your Board ID
3. Update configuration file
4. Add dependency to pom.xml
5. Implement the integration code
6. Test with a demo request
7. Monitor logs for success

Would you like me to implement the actual Java code for this integration?