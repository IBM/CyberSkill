# Bulk Upload Database Connections Guide

## Overview
The Scenario Launch Platform (SLP) now supports bulk uploading of database connections via JSON files. This feature allows you to add multiple database connections at once instead of manually entering them one by one through the settings page.

## Features
- Upload multiple database connections from a single JSON file
- Automatic validation of required fields
- Sequential processing with detailed results
- Support for all database types (MySQL, PostgreSQL, DB2, SQL Server, Oracle)
- Real-time progress tracking
- Detailed success/failure reporting

## How to Use

### Step 1: Access the Bulk Upload Feature
1. Log into the SLP application
2. Navigate to the **Settings** page
3. Look for the **"Bulk Upload Connections"** section (with upload icon)
4. Click the upload icon to expand the section

### Step 2: Prepare Your JSON File
Create a JSON file with the following structure:

```json
{
  "connections": [
    {
      "status": "active",
      "db_type": "mysql",
      "db_version": "8.0",
      "db_username": "root",
      "db_password": "password123",
      "db_port": "3306",
      "db_database": "testdb",
      "db_url": "jdbc:mysql://192.168.100.13:3306/testdb",
      "db_jdbcClassName": "com.mysql.cj.jdbc.Driver",
      "db_userIcon": "fa-user",
      "db_databaseIcon": "fa-database",
      "db_alias": "MySQL Test Database",
      "db_access": "public"
    }
  ]
}
```

### Step 3: Upload and Process
1. Click the **"Choose File"** button
2. Select your JSON file
3. Click **"Upload & Add Connections"**
4. Wait for processing to complete
5. Review the results in the modal dialog

## JSON Field Reference

### Required Fields
These fields **must** be present for each connection:

| Field | Description | Example |
|-------|-------------|---------|
| `db_type` | Database type | `mysql`, `postgresql`, `db2`, `sqlserver`, `oracle` |
| `db_username` | Database username | `root` |
| `db_password` | Database password | `password123` |
| `db_port` | Database port | `3306` |
| `db_database` | Database name | `testdb` |
| `db_url` | JDBC connection URL | `jdbc:mysql://192.168.100.13:3306/testdb` |
| `db_jdbcClassName` | JDBC driver class | `com.mysql.cj.jdbc.Driver` |

### Optional Fields
These fields have default values if not provided:

| Field | Description | Default | Example |
|-------|-------------|---------|---------|
| `status` | Connection status | `active` | `active` or `inactive` |
| `db_version` | Database version | Empty string | `8.0` |
| `db_userIcon` | User icon class | Empty string | `fa-user` |
| `db_databaseIcon` | Database icon class | Empty string | `fa-database` |
| `db_alias` | Friendly name | Empty string | `MySQL Production` |
| `db_access` | Access level | Empty string | `public`, `admin` |

## Database-Specific Examples

### MySQL
```json
{
  "status": "active",
  "db_type": "mysql",
  "db_version": "8.0",
  "db_username": "root",
  "db_password": "password123",
  "db_port": "3306",
  "db_database": "testdb",
  "db_url": "jdbc:mysql://192.168.100.13:3306/testdb",
  "db_jdbcClassName": "com.mysql.cj.jdbc.Driver",
  "db_alias": "MySQL Test Database"
}
```

### PostgreSQL
```json
{
  "status": "active",
  "db_type": "postgresql",
  "db_version": "14",
  "db_username": "postgres",
  "db_password": "postgres123",
  "db_port": "5432",
  "db_database": "postgres",
  "db_url": "jdbc:postgresql://192.168.100.12:5432/postgres",
  "db_jdbcClassName": "org.postgresql.Driver",
  "db_alias": "PostgreSQL Production"
}
```

### DB2
```json
{
  "status": "active",
  "db_type": "db2",
  "db_version": "11.5",
  "db_username": "db2admin",
  "db_password": "db2pass",
  "db_port": "50000",
  "db_database": "SAMPLE",
  "db_url": "jdbc:db2://192.168.100.15:50000/SAMPLE",
  "db_jdbcClassName": "com.ibm.db2.jcc.DB2Driver",
  "db_alias": "DB2 Sample Database"
}
```

### SQL Server
```json
{
  "status": "active",
  "db_type": "sqlserver",
  "db_version": "2019",
  "db_username": "sa",
  "db_password": "SqlServer123!",
  "db_port": "1433",
  "db_database": "master",
  "db_url": "jdbc:sqlserver://192.168.100.16:1433;databaseName=master",
  "db_jdbcClassName": "com.microsoft.sqlserver.jdbc.SQLServerDriver",
  "db_alias": "SQL Server Master"
}
```

### Oracle
```json
{
  "status": "active",
  "db_type": "oracle",
  "db_version": "19c",
  "db_username": "system",
  "db_password": "oracle123",
  "db_port": "1521",
  "db_database": "ORCL",
  "db_url": "jdbc:oracle:thin:@192.168.100.14:1521:ORCL",
  "db_jdbcClassName": "oracle.jdbc.driver.OracleDriver",
  "db_alias": "Oracle Production"
}
```

## JDBC Driver Class Names

Use these exact class names for the `db_jdbcClassName` field:

| Database | JDBC Driver Class Name |
|----------|------------------------|
| MySQL | `com.mysql.cj.jdbc.Driver` |
| PostgreSQL | `org.postgresql.Driver` |
| DB2 | `com.ibm.db2.jcc.DB2Driver` |
| SQL Server | `com.microsoft.sqlserver.jdbc.SQLServerDriver` |
| Oracle | `oracle.jdbc.driver.OracleDriver` |

## Results and Error Handling

After uploading, you'll see a results modal showing:
- **Total connections** processed
- **Successful** additions (in green)
- **Failed** additions (in red)
- **Detailed table** with status for each connection

### Common Errors
1. **Missing required fields**: Ensure all required fields are present
2. **Invalid JSON format**: Validate your JSON syntax
3. **Database connection errors**: Check credentials and network connectivity
4. **Duplicate connections**: The system may reject duplicate entries

## Tips and Best Practices

1. **Test with small batches first**: Start with 1-2 connections to verify your JSON format
2. **Use the template**: Reference `bulk_connections_template.json` for correct structure
3. **Validate JSON**: Use a JSON validator before uploading
4. **Keep backups**: Save your JSON files for future use
5. **Check results**: Always review the results modal after upload
6. **Refresh connections**: Click "Close & Refresh" to see new connections in the table

## Template File

A complete template file (`bulk_connections_template.json`) is provided in the root directory with examples for all supported database types.

## Troubleshooting

### File Upload Issues
- Ensure file has `.json` extension
- Check file is valid JSON format
- Verify file size is reasonable (< 1MB recommended)

### Connection Failures
- Verify database is accessible from SLP server
- Check credentials are correct
- Ensure JDBC URL format is correct for database type
- Confirm database port is open and accessible

### Validation Errors
- Review required fields list
- Check for typos in field names
- Ensure values are appropriate for field type

## Support

For additional help or to report issues with the bulk upload feature, please contact the SLP support team or refer to the main SLP documentation.