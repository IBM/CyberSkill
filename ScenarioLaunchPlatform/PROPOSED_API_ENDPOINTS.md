# Proposed API Endpoints for SLP Feature Enhancements

This document outlines new API endpoints to support the feature suggestions provided. These should be added to the existing Swagger OpenAPI specification (`src/main/resources/webroot/swagger-ui/openapi.json`).

---

## 📊 Story Execution History & Audit Trail

### GET /api/story/history
**Description**: Retrieve story execution history with filtering options  
**Authentication**: JWT required  
**Parameters**:
- `jwt` (string, required): JWT token
- `story_id` (integer, optional): Filter by story ID
- `username` (string, optional): Filter by user
- `datasource` (string, optional): Filter by datasource
- `start_date` (string, optional): ISO 8601 date
- `end_date` (string, optional): ISO 8601 date
- `status` (string, optional): success|failure|in_progress
- `limit` (integer, optional): Default 100
- `offset` (integer, optional): Default 0

**Response 200**:
```json
{
  "total": 1523,
  "executions": [
    {
      "execution_id": 12345,
      "story_id": 42,
      "story_name": "SQL Injection Attack",
      "username": "admin",
      "datasource": "mysql_localhost_crm_app_user",
      "start_time": "2026-03-06T14:30:00Z",
      "end_time": "2026-03-06T14:32:15Z",
      "duration_seconds": 135,
      "status": "success",
      "chapters_executed": 8,
      "queries_run": 24,
      "errors": []
    }
  ]
}
```

### GET /api/story/history/{execution_id}
**Description**: Get detailed execution log for a specific run  
**Parameters**:
- `execution_id` (integer, required): Execution ID
- `jwt` (string, required): JWT token

**Response 200**:
```json
{
  "execution_id": 12345,
  "story_id": 42,
  "chapters": [
    {
      "chapter_number": 1,
      "chapter_name": "Initial Reconnaissance",
      "query_id": 101,
      "query_string": "SELECT * FROM users WHERE username='admin'",
      "start_time": "2026-03-06T14:30:00Z",
      "end_time": "2026-03-06T14:30:02Z",
      "duration_ms": 2150,
      "rows_affected": 1,
      "status": "success"
    }
  ]
}
```

---

## 🔄 Story Templates & Cloning

### POST /api/story/saveAsTemplate
**Description**: Save an existing story as a reusable template  
**Parameters**:
```json
{
  "jwt": "string",
  "story_id": 42,
  "template_name": "SQL Injection Template",
  "template_description": "Reusable SQL injection attack pattern",
  "parameters": [
    {"name": "target_table", "type": "string", "default": "users"},
    {"name": "target_column", "type": "string", "default": "username"}
  ]
}
```

**Response 200**:
```json
{
  "template_id": 7,
  "message": "Template created successfully"
}
```

### GET /api/story/templates
**Description**: List all available story templates  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "templates": [
    {
      "template_id": 7,
      "template_name": "SQL Injection Template",
      "description": "Reusable SQL injection attack pattern",
      "created_by": "admin",
      "created_at": "2026-03-01T10:00:00Z",
      "usage_count": 15
    }
  ]
}
```

### POST /api/story/cloneFromTemplate
**Description**: Create a new story from a template  
**Parameters**:
```json
{
  "jwt": "string",
  "template_id": 7,
  "story_name": "SQL Injection - Production DB",
  "parameters": {
    "target_table": "customers",
    "target_column": "email"
  }
}
```

**Response 200**:
```json
{
  "story_id": 99,
  "message": "Story created from template successfully"
}
```

### POST /api/story/clone
**Description**: Clone an existing story  
**Parameters**:
```json
{
  "jwt": "string",
  "story_id": 42,
  "new_story_name": "SQL Injection - Copy"
}
```

**Response 200**:
```json
{
  "story_id": 100,
  "message": "Story cloned successfully"
}
```

---

## 🎯 Multi-Database Story Execution

### POST /api/story/runMultiDatabase
**Description**: Execute a story across multiple databases simultaneously  
**Parameters**:
```json
{
  "jwt": "string",
  "story_id": 42,
  "datasources": [
    "mysql_localhost_crm_app_user",
    "postgres_localhost_crm_app_user",
    "sqlserver_localhost_crm_app_user"
  ],
  "parallel": true
}
```

**Response 200**:
```json
{
  "execution_batch_id": "batch_12345",
  "executions": [
    {
      "datasource": "mysql_localhost_crm_app_user",
      "execution_id": 5001,
      "status": "started"
    },
    {
      "datasource": "postgres_localhost_crm_app_user",
      "execution_id": 5002,
      "status": "started"
    },
    {
      "datasource": "sqlserver_localhost_crm_app_user",
      "execution_id": 5003,
      "status": "started"
    }
  ]
}
```

### GET /api/story/multiDatabaseStatus/{batch_id}
**Description**: Check status of multi-database execution  
**Parameters**:
- `batch_id` (string, required)
- `jwt` (string, required)

**Response 200**:
```json
{
  "batch_id": "batch_12345",
  "overall_status": "in_progress",
  "completed": 1,
  "in_progress": 1,
  "failed": 1,
  "executions": [
    {
      "datasource": "mysql_localhost_crm_app_user",
      "status": "success",
      "duration_seconds": 45
    },
    {
      "datasource": "postgres_localhost_crm_app_user",
      "status": "in_progress",
      "progress": "60%"
    },
    {
      "datasource": "sqlserver_localhost_crm_app_user",
      "status": "failed",
      "error": "Connection timeout"
    }
  ]
}
```

---

## ⏰ Story Scheduling with Recurrence

### POST /api/scheduler/createRecurringSchedule
**Description**: Create a recurring schedule for story execution  
**Parameters**:
```json
{
  "jwt": "string",
  "story_id": 42,
  "datasource": "mysql_localhost_crm_app_user",
  "schedule_name": "Daily SQL Injection Test",
  "cron_expression": "0 0 2 * * ?",
  "timezone": "UTC",
  "enabled": true,
  "start_date": "2026-03-07T00:00:00Z",
  "end_date": "2026-12-31T23:59:59Z"
}
```

**Response 200**:
```json
{
  "schedule_id": 88,
  "next_run": "2026-03-07T02:00:00Z",
  "message": "Recurring schedule created successfully"
}
```

### GET /api/scheduler/recurring
**Description**: List all recurring schedules  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "schedules": [
    {
      "schedule_id": 88,
      "schedule_name": "Daily SQL Injection Test",
      "story_id": 42,
      "story_name": "SQL Injection Attack",
      "cron_expression": "0 0 2 * * ?",
      "next_run": "2026-03-07T02:00:00Z",
      "last_run": "2026-03-06T02:00:00Z",
      "last_status": "success",
      "enabled": true
    }
  ]
}
```

### PUT /api/scheduler/recurring/{schedule_id}
**Description**: Update a recurring schedule  
**Parameters**:
```json
{
  "jwt": "string",
  "schedule_id": 88,
  "cron_expression": "0 0 3 * * ?",
  "enabled": false
}
```

### DELETE /api/scheduler/recurring/{schedule_id}
**Description**: Delete a recurring schedule  
**Parameters**:
- `schedule_id` (integer, required)
- `jwt` (string, required)

---

## 🔔 Real-Time Notifications

### GET /api/notifications/feed
**Description**: Get user's notification feed  
**Parameters**:
- `jwt` (string, required)
- `limit` (integer, optional): Default 50
- `unread_only` (boolean, optional): Default false

**Response 200**:
```json
{
  "unread_count": 3,
  "notifications": [
    {
      "notification_id": 1001,
      "type": "story_execution",
      "title": "Story Completed",
      "message": "User 'john' completed story 'SQL Injection Attack' on mysql_localhost_crm",
      "timestamp": "2026-03-06T14:32:15Z",
      "read": false,
      "action_url": "/loggedIn/myStories.ftl?story_id=42"
    },
    {
      "notification_id": 1002,
      "type": "database_modified",
      "title": "Database Connection Updated",
      "message": "User 'admin' modified database connection 'Production MySQL'",
      "timestamp": "2026-03-06T13:15:00Z",
      "read": true
    }
  ]
}
```

### POST /api/notifications/markRead
**Description**: Mark notifications as read  
**Parameters**:
```json
{
  "jwt": "string",
  "notification_ids": [1001, 1002, 1003]
}
```

### WebSocket: /websocket/notifications/:username
**Description**: Real-time notification stream  
**Message Format**:
```json
{
  "type": "story_execution",
  "title": "Story Started",
  "message": "User 'john' started story 'SQL Injection Attack'",
  "timestamp": "2026-03-06T14:30:00Z",
  "severity": "info"
}
```

---

## ✅ Query Result Validation & Assertions

### POST /api/query/addAssertion
**Description**: Add validation rules to a query  
**Parameters**:
```json
{
  "jwt": "string",
  "query_id": 101,
  "assertions": [
    {
      "type": "row_count",
      "operator": "equals",
      "expected_value": 1
    },
    {
      "type": "column_value",
      "column_name": "username",
      "operator": "equals",
      "expected_value": "admin"
    },
    {
      "type": "execution_time",
      "operator": "less_than",
      "expected_value": 5000
    }
  ]
}
```

**Response 200**:
```json
{
  "assertion_id": 501,
  "message": "Assertions added successfully"
}
```

### GET /api/query/assertions/{query_id}
**Description**: Get assertions for a query  
**Parameters**:
- `query_id` (integer, required)
- `jwt` (string, required)

**Response 200**:
```json
{
  "query_id": 101,
  "assertions": [
    {
      "assertion_id": 501,
      "type": "row_count",
      "operator": "equals",
      "expected_value": 1,
      "enabled": true
    }
  ]
}
```

### GET /api/story/validationReport/{execution_id}
**Description**: Get validation report for a story execution  
**Parameters**:
- `execution_id` (integer, required)
- `jwt` (string, required)

**Response 200**:
```json
{
  "execution_id": 12345,
  "overall_status": "passed",
  "total_assertions": 24,
  "passed": 23,
  "failed": 1,
  "results": [
    {
      "chapter": 1,
      "query_id": 101,
      "assertion_type": "row_count",
      "expected": 1,
      "actual": 1,
      "status": "passed"
    },
    {
      "chapter": 3,
      "query_id": 105,
      "assertion_type": "execution_time",
      "expected": 5000,
      "actual": 6200,
      "status": "failed"
    }
  ]
}
```

---

## 📦 Export/Import Stories

### GET /api/story/export/{story_id}
**Description**: Export a story as JSON  
**Parameters**:
- `story_id` (integer, required)
- `jwt` (string, required)
- `format` (string, optional): json|yaml (default: json)

**Response 200**:
```json
{
  "version": "1.0",
  "story": {
    "name": "SQL Injection Attack",
    "description": "Demonstrates SQL injection vulnerability",
    "author": "admin",
    "chapters": [...]
  }
}
```

### POST /api/story/import
**Description**: Import a story from JSON/YAML  
**Parameters**:
```json
{
  "jwt": "string",
  "format": "json",
  "content": "{...story JSON...}",
  "overwrite_existing": false
}
```

**Response 200**:
```json
{
  "story_id": 101,
  "message": "Story imported successfully"
}
```

---

## 📈 Story Performance Benchmarking

### GET /api/story/performance/{story_id}
**Description**: Get performance metrics for a story  
**Parameters**:
- `story_id` (integer, required)
- `jwt` (string, required)
- `days` (integer, optional): Default 30

**Response 200**:
```json
{
  "story_id": 42,
  "story_name": "SQL Injection Attack",
  "metrics": {
    "avg_duration_seconds": 135,
    "min_duration_seconds": 120,
    "max_duration_seconds": 180,
    "total_executions": 45,
    "success_rate": 95.5,
    "trend": "improving"
  },
  "history": [
    {
      "date": "2026-03-06",
      "avg_duration": 132,
      "executions": 5
    }
  ]
}
```

### GET /api/query/performance/{query_id}
**Description**: Get performance metrics for a specific query  
**Parameters**:
- `query_id` (integer, required)
- `jwt` (string, required)

**Response 200**:
```json
{
  "query_id": 101,
  "avg_execution_time_ms": 2150,
  "p50_ms": 2000,
  "p95_ms": 3500,
  "p99_ms": 4200,
  "slowest_execution": {
    "execution_id": 12340,
    "duration_ms": 6200,
    "timestamp": "2026-03-05T10:30:00Z"
  }
}
```

---

## 🔐 Enhanced RBAC

### GET /api/roles
**Description**: List all available roles  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "roles": [
    {
      "role_id": 1,
      "role_name": "admin",
      "description": "Full system access",
      "permissions": ["*"]
    },
    {
      "role_id": 2,
      "role_name": "story_executor",
      "description": "Can execute stories",
      "permissions": ["story.execute", "story.view", "database.view"]
    },
    {
      "role_id": 3,
      "role_name": "story_creator",
      "description": "Can create and modify stories",
      "permissions": ["story.*", "query.*", "database.view"]
    }
  ]
}
```

### POST /api/user/assignRole
**Description**: Assign a role to a user  
**Parameters**:
```json
{
  "jwt": "string",
  "username": "john",
  "role_id": 2
}
```

### GET /api/user/permissions
**Description**: Get current user's permissions  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "username": "john",
  "roles": ["story_executor"],
  "permissions": [
    "story.execute",
    "story.view",
    "database.view"
  ]
}
```

---

## 📝 Audit Log

### GET /api/audit/log
**Description**: Retrieve audit log entries  
**Parameters**:
- `jwt` (string, required)
- `action_type` (string, optional): user_created|database_modified|story_executed|etc
- `username` (string, optional): Filter by user
- `start_date` (string, optional)
- `end_date` (string, optional)
- `limit` (integer, optional): Default 100

**Response 200**:
```json
{
  "total": 5234,
  "entries": [
    {
      "audit_id": 10001,
      "timestamp": "2026-03-06T14:30:00Z",
      "username": "admin",
      "action": "database_connection_created",
      "resource_type": "database_connection",
      "resource_id": 15,
      "details": {
        "db_type": "mysql",
        "db_alias": "Production MySQL"
      },
      "ip_address": "192.168.1.100",
      "user_agent": "Mozilla/5.0..."
    }
  ]
}
```

---

## 🔍 Story Tagging & Search

### POST /api/story/addTags
**Description**: Add tags to a story  
**Parameters**:
```json
{
  "jwt": "string",
  "story_id": 42,
  "tags": ["sql-injection", "owasp-top-10", "authentication"]
}
```

### GET /api/story/search
**Description**: Search stories by tags or text  
**Parameters**:
- `jwt` (string, required)
- `query` (string, optional): Full-text search
- `tags` (array, optional): Filter by tags
- `author` (string, optional)

**Response 200**:
```json
{
  "total": 12,
  "stories": [
    {
      "story_id": 42,
      "name": "SQL Injection Attack",
      "description": "...",
      "tags": ["sql-injection", "owasp-top-10"],
      "author": "admin",
      "created_at": "2026-01-15T10:00:00Z"
    }
  ]
}
```

---

## 📊 Outlier Statistics (Already Exists - Enhanced)

### GET /api/outliers/stats
**Description**: Get outlier detection statistics (ALREADY EXISTS - documented for completeness)  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "total_outliers_detected": 1523,
  "outliers_by_type": {
    "data_tampering": 450,
    "schema_tampering": 320,
    "privilege_escalation": 280
  },
  "recent_outliers": [...]
}
```

---

## 🎨 User Preferences

### GET /api/user/preferences
**Description**: Get user preferences  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "theme": "dark",
  "notifications_enabled": true,
  "default_datasource": "mysql_localhost_crm_app_user",
  "items_per_page": 50
}
```

### PUT /api/user/preferences
**Description**: Update user preferences  
**Parameters**:
```json
{
  "jwt": "string",
  "theme": "dark",
  "notifications_enabled": false
}
```

---

## 📊 Dashboard Widgets

### GET /api/dashboard/widgets
**Description**: Get available dashboard widgets  
**Parameters**:
- `jwt` (string, required)

**Response 200**:
```json
{
  "widgets": [
    {
      "widget_id": "active_stories",
      "name": "Active Stories",
      "type": "counter",
      "data": {"count": 5}
    },
    {
      "widget_id": "recent_executions",
      "name": "Recent Executions",
      "type": "list",
      "data": {"executions": [...]}
    }
  ]
}
```

---

## 🔄 Database Snapshot & Rollback

### POST /api/database/snapshot
**Description**: Create a database snapshot before story execution  
**Parameters**:
```json
{
  "jwt": "string",
  "datasource": "mysql_localhost_crm_app_user",
  "snapshot_name": "Before SQL Injection Test"
}
```

**Response 200**:
```json
{
  "snapshot_id": "snap_12345",
  "created_at": "2026-03-06T14:30:00Z",
  "size_mb": 125
}
```

### POST /api/database/rollback
**Description**: Rollback to a previous snapshot  
**Parameters**:
```json
{
  "jwt": "string",
  "snapshot_id": "snap_12345"
}
```

---

## Implementation Notes

1. **Authentication**: All endpoints require JWT token in request body or header
2. **Rate Limiting**: Implement rate limiting (e.g., 100 requests/minute per user)
3. **Pagination**: Use `limit` and `offset` for list endpoints
4. **Error Responses**: Standardize error format:
```json
{
  "error": "Invalid story ID",
  "code": "STORY_NOT_FOUND",
  "status": 404
}
```

5. **WebSocket Events**: Use existing WebSocket infrastructure for real-time updates
6. **Database Schema**: New tables required:
   - `story_execution_log`
   - `story_templates`
   - `story_assertions`
   - `recurring_schedules`
   - `notifications`
   - `audit_log`
   - `story_tags`
   - `user_roles`
   - `role_permissions`

---

## Next Steps

1. Review and approve API specifications
2. Create database migration scripts for new tables
3. Implement backend routes in `StoryRoutes.java`, `DatabaseRoutes.java`, etc.
4. Add OpenAPI specs to `openapi.json`
5. Create frontend UI components for new features
6. Write unit and integration tests
7. Update user documentation

---

**Document Version**: 1.0  
**Last Updated**: 2026-03-06  
**Author**: Bob (AI Developer Assistant)