# MySQL SQL Executor - Java JDBC Tool

A Java-based tool to execute SQL files against MySQL databases using JDBC connector.

## Features

- Execute SQL files with multiple statements
- Handles stored procedures with DELIMITER changes
- Supports complex SQL scripts
- Configurable database connection via properties file
- Automatic MySQL Connector/J download
- Detailed execution summary with success/error counts
- Pretty-printed result sets for SELECT queries

## Prerequisites

- Java Development Kit (JDK) 8 or higher
- MySQL database server
- Internet connection (for first-time MySQL Connector/J download)

## Setup

### 1. Configure Database Connection

Edit `db.properties` file with your database credentials:

```properties
db.host=localhost
db.port=3306
db.database=testdb
db.username=root
db.password=your_password_here
```

### 2. Compile the Program

Run the compile script which will:
- Download MySQL Connector/J (if not present)
- Compile the Java program

```bash
./compile.sh
```

## Usage

### Basic Usage

```bash
./run.sh <path_to_sql_file>
```

### Examples

Execute 100 GRANT commands:
```bash
./run.sh ../user_specific_grant_commands_mysql/execute_100_grants.sql
```

Execute 100 SELECT queries:
```bash
./run.sh ../user_specific_select_commands_mysql/execute_100_selects.sql
```

Execute 100 DELETE commands:
```bash
./run.sh ../user_specific_delete_commands_mysql/execute_100_deletes.sql
```

Execute 100 ALTER commands:
```bash
./run.sh ../user_specific_alter_commands_mysql/execute_100_alters.sql
```

### Direct Java Execution

You can also run directly with Java:

```bash
java -cp ".:mysql-connector-java-8.0.33.jar" MySQLSQLExecutor <sql_file_path>
```

## File Structure

```
mysql_sql_executor_java/
├── MySQLSQLExecutor.java    # Main Java program
├── db.properties             # Database configuration
├── compile.sh                # Compilation script
├── run.sh                    # Execution script
├── README.md                 # This file
└── mysql-connector-java-*.jar # MySQL JDBC driver (auto-downloaded)
```

## How It Works

1. **Configuration Loading**: Reads database credentials from `db.properties`
2. **SQL File Reading**: Loads the entire SQL file content
3. **Statement Parsing**: Intelligently splits SQL into individual statements
   - Handles standard `;` delimiter
   - Supports `DELIMITER` changes for stored procedures
   - Skips comments and empty lines
4. **Execution**: Executes each statement sequentially
   - Continues on errors (doesn't fail completely)
   - Tracks success/error counts
5. **Result Display**: Shows results for SELECT queries and row counts for DML/DDL

## Features in Detail

### DELIMITER Handling

The tool automatically handles MySQL's `DELIMITER` command used in stored procedures:

```sql
DELIMITER $$
CREATE PROCEDURE my_proc()
BEGIN
    SELECT 'Hello';
END$$
DELIMITER ;
```

### Error Handling

- Continues execution even if individual statements fail
- Reports errors with statement number and SQL snippet
- Provides execution summary at the end

### Result Display

For SELECT queries, results are displayed in a formatted table:

```
Status | Message
--------------------------------------------------------------------------------
Created 10 base tables for ALTER operations
(1 rows)
```

### Connection Options

The JDBC URL includes:
- `allowMultiQueries=true` - Execute multiple statements
- `useSSL=false` - Disable SSL (for local development)
- `serverTimezone=UTC` - Set timezone

## Troubleshooting

### MySQL Connector Not Found

If you see "MySQL JDBC Driver not found", run:
```bash
./compile.sh
```

This will download the connector automatically.

### Connection Refused

Check:
1. MySQL server is running
2. Host and port in `db.properties` are correct
3. Firewall allows connection to MySQL port

### Authentication Failed

Verify:
1. Username and password in `db.properties` are correct
2. User has necessary privileges
3. MySQL user can connect from your host

### Permission Denied on SQL File

Ensure the SQL file path is correct and readable:
```bash
ls -l ../user_specific_grant_commands_mysql/execute_100_grants.sql
```

## Supported SQL Files

This tool works with all the SQL files in the project:

- `execute_100_grants.sql` - User creation and grants
- `execute_100_selects.sql` - SELECT queries with test data
- `execute_100_deletes.sql` - DELETE operations
- `execute_100_alters.sql` - ALTER TABLE commands
- And any other valid MySQL SQL file

## Performance

- Executes statements sequentially (not in parallel)
- Suitable for scripts with up to thousands of statements
- For very large files, consider splitting into smaller chunks

## Security Notes

1. **Password Storage**: The `db.properties` file contains plaintext passwords
   - Keep this file secure
   - Don't commit to version control
   - Consider using environment variables for production

2. **SQL Injection**: This tool executes SQL files directly
   - Only run trusted SQL files
   - Review SQL content before execution

## Advanced Usage

### Custom JDBC URL

Modify the `getConnectionUrl()` method in `MySQLSQLExecutor.java` to customize connection parameters:

```java
private String getConnectionUrl() {
    return String.format("jdbc:mysql://%s:%d/%s?allowMultiQueries=true&useSSL=true&serverTimezone=UTC",
            host, port, database);
}
```

### Batch Execution

To execute multiple SQL files:

```bash
for file in ../user_specific_*_commands_mysql/execute_*.sql; do
    echo "Executing $file"
    ./run.sh "$file"
done
```

## License

This tool is provided as-is for testing and development purposes.

## Support

For issues or questions, refer to the main project documentation.