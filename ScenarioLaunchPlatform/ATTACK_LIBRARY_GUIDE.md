# Attack Pattern Library Guide

## Overview

The Attack Pattern Library is a comprehensive security testing feature that provides pre-built database attack patterns for testing database security controls and Guardium monitoring capabilities. It includes 22 attack patterns across 8 categories, targeting multiple database platforms (MySQL, PostgreSQL, DB2, SQL Server).

## Features

- **22 Pre-built Attack Patterns** across 8 security categories
- **Multi-Database Support**: MySQL, PostgreSQL, DB2, SQL Server
- **Severity Classification**: CRITICAL, HIGH, MEDIUM, LOW
- **REST API** for programmatic access
- **Search and Filter** capabilities
- **Guardium Integration** - Expected alert mappings for each pattern
- **Mitigation Guidance** - Security recommendations for each attack type

## Attack Categories

### 1. SQL Injection (4 patterns)
- **sqli-union-001**: Union-Based SQL Injection
- **sqli-blind-002**: Blind SQL Injection
- **sqli-time-003**: Time-Based SQL Injection
- **sqli-error-004**: Error-Based SQL Injection

### 2. Authentication (3 patterns)
- **auth-bypass-001**: Authentication Bypass
- **auth-brute-002**: Brute Force Attack
- **auth-stuff-003**: Credential Stuffing

### 3. Data Exfiltration (3 patterns)
- **exfil-mass-001**: Mass Data Extraction
- **exfil-sensitive-002**: Sensitive Data Access
- **exfil-export-003**: Unauthorized Data Export

### 4. Privilege Escalation (2 patterns)
- **priv-esc-001**: Privilege Escalation
- **priv-role-002**: Role Manipulation

### 5. Denial of Service (2 patterns)
- **dos-resource-001**: Resource Exhaustion
- **dos-slow-002**: Slow Query Attack

### 6. Compliance Testing (5 patterns)
- **comp-gdpr-001**: GDPR Data Access Test
- **comp-gdpr-002**: GDPR Right to Deletion Test
- **comp-pci-001**: PCI-DSS Card Data Access
- **comp-hipaa-001**: HIPAA PHI Access Test
- **comp-sox-001**: SOX Financial Data Access

### 7. Data Manipulation (2 patterns)
- **manip-update-001**: Unauthorized Data Modification
- **manip-delete-001**: Unauthorized Data Deletion

### 8. Information Disclosure (2 patterns)
- **info-schema-001**: Database Schema Enumeration
- **info-version-001**: Database Version Detection

## Architecture

### Backend Components

#### 1. AttackPattern.java
POJO class representing an attack pattern with properties:
- `id`: Unique identifier
- `name`: Pattern name
- `category`: Attack category
- `description`: Detailed description
- `severity`: CRITICAL, HIGH, MEDIUM, LOW
- `targetDatabases`: List of supported databases
- `sqlQueries`: List of SQL queries to execute
- `expectedGuardiumAlert`: Expected Guardium alert type
- `mitigation`: Security recommendations
- `tags`: Searchable tags

#### 2. AttackPatternLibrary.java
Singleton manager class that:
- Initializes all 22 pre-built patterns
- Provides search and filter methods
- Manages pattern retrieval by ID, category, severity, database
- Generates statistics

#### 3. LibraryHandler.java
REST API handler providing endpoints for:
- Pattern retrieval and search
- Category and severity listing
- Library statistics

## REST API Endpoints

### Get All Patterns
```
GET /api/library/patterns
```
Returns all attack patterns in the library.

**Response:**
```json
{
  "success": true,
  "count": 22,
  "patterns": [...]
}
```

### Get Pattern by ID
```
GET /api/library/patterns/:id
```
Returns a specific pattern by ID.

**Example:**
```
GET /api/library/patterns/sqli-union-001
```

**Response:**
```json
{
  "success": true,
  "pattern": {
    "id": "sqli-union-001",
    "name": "Union-Based SQL Injection",
    "category": "SQL Injection",
    "description": "Attempts to extract data using UNION SELECT statements...",
    "severity": "CRITICAL",
    "targetDatabases": ["mysql", "postgresql", "db2", "sqlserver"],
    "sqlQueries": [...],
    "expectedGuardiumAlert": "SQL_INJECTION_UNION",
    "mitigation": "Use parameterized queries...",
    "tags": ["sqli", "union", "data-extraction", "owasp-top10"]
  }
}
```

### Get Patterns by Category
```
GET /api/library/categories/:category/patterns
```
Returns all patterns in a specific category.

**Example:**
```
GET /api/library/categories/SQL%20Injection/patterns
```

### Get Patterns by Severity
```
GET /api/library/severity/:severity/patterns
```
Returns all patterns with a specific severity level.

**Example:**
```
GET /api/library/severity/CRITICAL/patterns
```

### Get Patterns by Database
```
GET /api/library/database/:database/patterns
```
Returns all patterns compatible with a specific database.

**Example:**
```
GET /api/library/database/mysql/patterns
```

### Search Patterns
```
GET /api/library/search?q=<query>
```
Searches patterns by name, description, and tags.

**Example:**
```
GET /api/library/search?q=injection
```

### Get All Categories
```
GET /api/library/categories
```
Returns all available categories with pattern counts.

**Response:**
```json
{
  "success": true,
  "count": 8,
  "categories": [
    {"name": "SQL Injection", "count": 4},
    {"name": "Authentication", "count": 3},
    ...
  ]
}
```

### Get All Severity Levels
```
GET /api/library/severity
```
Returns all severity levels with pattern counts.

### Get Library Statistics
```
GET /api/library/stats
```
Returns comprehensive library statistics.

**Response:**
```json
{
  "success": true,
  "totalPatterns": 22,
  "totalCategories": 8,
  "totalSeverityLevels": 4,
  "patternsByCategory": {...},
  "patternsBySeverity": {...}
}
```

## Usage Examples

### Example 1: List All SQL Injection Patterns
```bash
curl http://localhost:8080/api/library/categories/SQL%20Injection/patterns
```

### Example 2: Get Critical Severity Patterns
```bash
curl http://localhost:8080/api/library/severity/CRITICAL/patterns
```

### Example 3: Search for Authentication Attacks
```bash
curl http://localhost:8080/api/library/search?q=authentication
```

### Example 4: Get MySQL-Compatible Patterns
```bash
curl http://localhost:8080/api/library/database/mysql/patterns
```

### Example 5: Get Specific Pattern Details
```bash
curl http://localhost:8080/api/library/patterns/sqli-union-001
```

## Pattern Execution

To execute a pattern against a database:

1. **Select a Pattern**: Use the API to browse and select a pattern
2. **Choose Target Database**: Select from your configured database connections
3. **Execute Queries**: Use the existing `/api/runStoryById` endpoint or create a new execution endpoint
4. **Monitor Results**: Check Guardium for expected alerts
5. **Review Mitigation**: Implement recommended security controls

## Security Considerations

### ⚠️ WARNING: Responsible Use Only

This library is designed for:
- **Security Testing** in controlled environments
- **Guardium Validation** and tuning
- **Security Training** and awareness
- **Compliance Testing** with proper authorization

**DO NOT USE** for:
- Unauthorized access attempts
- Production system testing without approval
- Malicious activities
- Testing systems you don't own or have permission to test

### Best Practices

1. **Isolated Environment**: Always test in isolated, non-production environments
2. **Authorization**: Obtain proper authorization before testing
3. **Documentation**: Document all testing activities
4. **Monitoring**: Monitor systems during testing
5. **Cleanup**: Clean up test data after testing
6. **Guardium Alerts**: Verify Guardium captures all expected alerts
7. **Incident Response**: Have incident response procedures ready

## Integration with Existing Features

### Database Connections
The library integrates with existing database connection management:
- Uses configured datasources from `/api/getDatabaseConnections`
- Supports all database types already configured in the system

### Story Execution
Patterns can be converted to stories for:
- Scheduled execution
- Batch testing
- Automated security validation

### Metrics Collection
Pattern execution can be tracked using the existing metrics system:
- Track pattern execution counts
- Monitor success/failure rates
- Measure execution times

## Extending the Library

### Adding New Patterns

To add new attack patterns, modify `AttackPatternLibrary.java`:

```java
addPattern(new AttackPattern(
    "custom-001",                          // Unique ID
    "Custom Attack Pattern",               // Name
    "Custom Category",                     // Category
    "Description of the attack",           // Description
    "HIGH",                                // Severity
    Arrays.asList("mysql", "postgresql"),  // Target databases
    Arrays.asList(                         // SQL queries
        "SELECT * FROM table WHERE 1=1",
        "UPDATE table SET field = 'value'"
    ),
    "EXPECTED_GUARDIUM_ALERT",            // Expected alert
    "Mitigation recommendations",          // Mitigation
    Arrays.asList("tag1", "tag2")         // Tags
));
```

### Custom Categories

Add new categories by creating patterns with new category names. The system automatically discovers and lists all unique categories.

## Troubleshooting

### Pattern Not Found
- Verify the pattern ID is correct
- Check the API response for available pattern IDs

### Database Compatibility Issues
- Verify the pattern supports your database type
- Check the `targetDatabases` field in the pattern

### Execution Failures
- Verify database connection is active
- Check database permissions
- Review SQL syntax for your specific database version

### No Guardium Alerts
- Verify Guardium is properly configured
- Check Guardium policies are active
- Review alert thresholds and rules

## Future Enhancements

Potential future additions:
1. **Custom Pattern Creation**: UI for creating custom patterns
2. **Pattern Import/Export**: Share patterns between systems
3. **Execution History**: Track pattern execution results
4. **Automated Testing**: Schedule pattern execution
5. **Report Generation**: Generate security test reports
6. **Pattern Versioning**: Track pattern changes over time
7. **Collaborative Features**: Share patterns with team members

## Support and Feedback

For questions, issues, or feature requests:
- Review the API documentation
- Check the logs for error messages
- Consult the security team for testing authorization
- Report bugs through the standard issue tracking system

## License

Apache 2.0 License - See LICENSE file for details

## Authors

- Jason Flood
- John Clarke

---
