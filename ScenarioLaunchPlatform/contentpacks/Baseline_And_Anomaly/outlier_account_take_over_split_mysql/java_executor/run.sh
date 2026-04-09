#!/bin/bash

# Run script for MySQL SQL Executor
# Usage: ./run.sh <path_to_sql_file>

MYSQL_CONNECTOR_VERSION="8.0.33"
MYSQL_CONNECTOR_JAR="mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.jar"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <path_to_sql_file>"
    echo
    echo "Examples:"
    echo "  $0 ../user_specific_grant_commands_mysql/execute_100_grants.sql"
    echo "  $0 ../user_specific_select_commands_mysql/execute_100_selects.sql"
    echo "  $0 ../user_specific_delete_commands_mysql/execute_100_deletes.sql"
    echo "  $0 ../user_specific_alter_commands_mysql/execute_100_alters.sql"
    exit 1
fi

SQL_FILE="$1"

# Check if SQL file exists
if [ ! -f "$SQL_FILE" ]; then
    echo "Error: SQL file not found: $SQL_FILE"
    exit 1
fi

# Check if compiled class exists
if [ ! -f "MySQLSQLExecutor.class" ]; then
    echo "Error: MySQLSQLExecutor.class not found"
    echo "Please run ./compile.sh first"
    exit 1
fi

# Check if MySQL Connector JAR exists
if [ ! -f "$MYSQL_CONNECTOR_JAR" ]; then
    echo "Error: MySQL Connector/J not found: $MYSQL_CONNECTOR_JAR"
    echo "Please run ./compile.sh first"
    exit 1
fi

# Check if db.properties exists
if [ ! -f "db.properties" ]; then
    echo "Error: db.properties not found"
    echo "Please create db.properties with your database configuration"
    exit 1
fi

echo "=== MySQL SQL Executor ==="
echo "SQL File: $SQL_FILE"
echo

# Run the Java program
java -cp ".:${MYSQL_CONNECTOR_JAR}" MySQLSQLExecutor "$SQL_FILE"

# Made with Bob
