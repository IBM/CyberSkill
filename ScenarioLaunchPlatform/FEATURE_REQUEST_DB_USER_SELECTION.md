# Feature Request: Database Type and User Selection for Attack Library

## Current Status
✅ **Database initialization issue RESOLVED** - PostgreSQL tables created successfully
✅ Attack Library is functional and can execute patterns

## Current Behavior

The Attack Library currently:
- Stores attack patterns in the SLP PostgreSQL database (`localhost:5432/slp`)
- Executes attacks against the `crm` database on target systems
- Patterns are pre-configured for specific database types (MySQL, PostgreSQL, Oracle, DB2, SQL Server)
- Users must manually select which database connection to use

## Requested Enhancement

Add dynamic database type and user selection to the Attack Library UI:

### 1. Database Type Selector
- Dropdown to select target database type (MySQL, PostgreSQL, Oracle, DB2, SQL Server)
- Automatically filters attack patterns compatible with selected database
- Dynamically adjusts SQL queries for the selected database syntax

### 2. User/Connection Selector
- Dropdown populated from `tb_databaseconnections` table
- Filters connections by selected database type
- Shows user alias and access level (e.g., "polly - DB Admin", "john - Standard User")
- Only shows active connections

### 3. Query Adaptation
- SQL queries automatically adapt to target database syntax
- Example: MySQL `LIMIT 10` → PostgreSQL `LIMIT 10` → Oracle `ROWNUM <= 10`
- Handle database-specific data types and functions

## Implementation Plan

### Phase 1: Backend API Enhancement

**New Endpoint**: `GET /api/library/database-connections`
```java
// Returns available database connections grouped by type
{
  "success": true,
  "connections": {
    "mysql": [
      {"id": "mysql_192.168.100.13_crm_polly", "username": "polly", "alias": "DB Admin", "host": "192.168.100.13"},
      {"id": "mysql_192.168.100.13_crm_john", "username": "john", "alias": "Standard User", "host": "192.168.100.13"}
    ],
    "postgresql": [
      {"id": "postgresql_192.168.100.12_crm_polly", "username": "polly", "alias": "DB Admin", "host": "192.168.100.12"}
    ]
  }
}
```

**Enhanced Endpoint**: `POST /api/library/patterns/:id/execute`
```java
// Request body
{
  "patternId": "sqli-union-001",
  "databaseType": "mysql",
  "connectionId": "mysql_192.168.100.13_crm_polly",
  "parameters": {}
}
```

### Phase 2: Query Adaptation Engine

Create `QueryAdapter.java`:
```java
public class QueryAdapter {
    public static String adaptQuery(String query, String sourceDb, String targetDb) {
        // Convert query syntax from source to target database
        // Handle: LIMIT/ROWNUM, data types, functions, etc.
    }
}
```

### Phase 3: UI Enhancement

Update `attackLibrary.ftl`:

```html
<!-- Add to search bar -->
<select id="databaseTypeFilter" onchange="filterByDatabaseType()">
  <option value="">All Database Types</option>
  <option value="mysql">MySQL</option>
  <option value="postgresql">PostgreSQL</option>
  <option value="oracle">Oracle</option>
  <option value="db2">DB2</option>
  <option value="sqlserver">SQL Server</option>
</select>

<!-- Add to pattern execution modal -->
<div class="form-group">
  <label>Target Database Type</label>
  <select id="targetDbType" onchange="loadConnectionsForDbType()">
    <option value="">Select Database Type</option>
    <option value="mysql">MySQL</option>
    <option value="postgresql">PostgreSQL</option>
    <option value="oracle">Oracle</option>
    <option value="db2">DB2</option>
    <option value="sqlserver">SQL Server</option>
  </select>
</div>

<div class="form-group">
  <label>Target Connection</label>
  <select id="targetConnection">
    <option value="">Select Connection</option>
    <!-- Populated dynamically based on database type -->
  </select>
</div>
```

### Phase 4: Pattern Storage Enhancement

Update `tb_attack_patterns` table to support multiple database variants:

```sql
ALTER TABLE tb_attack_patterns ADD COLUMN query_variants JSONB;

-- Example data
{
  "mysql": "SELECT * FROM crm.tbl_users LIMIT 10",
  "postgresql": "SELECT * FROM crm.tbl_users LIMIT 10",
  "oracle": "SELECT * FROM crm.tbl_users WHERE ROWNUM <= 10",
  "db2": "SELECT * FROM crm.tbl_users FETCH FIRST 10 ROWS ONLY",
  "sqlserver": "SELECT TOP 10 * FROM crm.tbl_users"
}
```

## Benefits

1. **Flexibility**: Test same attack pattern across different database types
2. **User Context**: Execute attacks as different users (admin vs standard user)
3. **Realism**: Simulate real-world scenarios with appropriate user privileges
4. **Efficiency**: No need to create separate patterns for each database type
5. **Comparison**: Compare how different databases handle the same attack

## Technical Considerations

### Database Syntax Differences

| Feature | MySQL | PostgreSQL | Oracle | DB2 | SQL Server |
|---------|-------|------------|--------|-----|------------|
| Limit | `LIMIT n` | `LIMIT n` | `ROWNUM <= n` | `FETCH FIRST n ROWS` | `TOP n` |
| String Concat | `CONCAT()` | `\|\|` or `CONCAT()` | `\|\|` | `\|\|` or `CONCAT()` | `+` |
| Date Functions | `NOW()` | `NOW()` | `SYSDATE` | `CURRENT TIMESTAMP` | `GETDATE()` |
| Auto Increment | `AUTO_INCREMENT` | `SERIAL` | `SEQUENCE` | `GENERATED` | `IDENTITY` |

### Security Considerations

- Validate connection IDs against `tb_databaseconnections`
- Ensure user has permission to execute on selected connection
- Log all executions with database type and connection used
- Prevent SQL injection in adapted queries

## Example Use Cases

### Use Case 1: Cross-Database Testing
```
1. Select "SQL Injection - Union Based" pattern
2. Choose "MySQL" as target database type
3. Select "john - Standard User" connection
4. Execute → See results for MySQL
5. Change to "PostgreSQL" 
6. Select "john - Standard User" connection
7. Execute → Compare results
```

### Use Case 2: Privilege Escalation Testing
```
1. Select "Privilege Escalation" pattern
2. Choose "MySQL" as target database type
3. Execute with "john - Standard User" → Should fail
4. Execute with "polly - DB Admin" → Should succeed
5. Document the difference in access levels
```

## Priority

**Medium Priority** - Enhancement, not a bug fix

The current system works but requires:
- Manual pattern selection per database type
- Manual connection configuration
- No dynamic query adaptation

## Estimated Effort

- Backend API: 2-3 days
- Query Adapter: 3-4 days
- UI Updates: 2 days
- Testing: 2-3 days
- **Total: ~10-12 days**

## Alternative Approach (Simpler)

Instead of dynamic query adaptation, maintain separate pattern sets:
- `sqli-union-mysql-001`
- `sqli-union-postgresql-001`
- `sqli-union-oracle-001`

Then add UI filters to show only patterns matching selected database type.

**Effort: ~3-4 days**

## Next Steps

1. ✅ Resolve database initialization issue (COMPLETED)
2. Review this feature request with team
3. Decide on approach (dynamic adaptation vs separate patterns)
4. Create detailed technical specification
5. Implement in phases
6. Test across all database types

## Related Documentation

- `DATABASE_SETUP_GUIDE.md` - Database initialization
- `ATTACK_LIBRARY_GUIDE.md` - Current Attack Library usage
- `database/ScenarioLaunchPlatform_CORE/gdp_lab_tables.sql` - Database schema