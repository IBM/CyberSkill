#!/bin/bash

# Compile script for MySQL SQL Executor
# Downloads MySQL Connector/J if not present and compiles the Java program

MYSQL_CONNECTOR_VERSION="8.0.33"
MYSQL_CONNECTOR_JAR="mysql-connector-j-${MYSQL_CONNECTOR_VERSION}.jar"
DOWNLOAD_URL="https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/${MYSQL_CONNECTOR_VERSION}/${MYSQL_CONNECTOR_JAR}"

echo "=== MySQL SQL Executor - Compile Script ==="
echo

# Check if MySQL Connector JAR exists
if [ ! -f "$MYSQL_CONNECTOR_JAR" ]; then
    echo "MySQL Connector/J not found. Downloading..."
    echo "URL: $DOWNLOAD_URL"
    
    if command -v curl &> /dev/null; then
        curl -L -O "$DOWNLOAD_URL"
    elif command -v wget &> /dev/null; then
        wget "$DOWNLOAD_URL"
    else
        echo "Error: Neither curl nor wget found. Please download manually:"
        echo "$DOWNLOAD_URL"
        exit 1
    fi
    
    if [ ! -f "$MYSQL_CONNECTOR_JAR" ]; then
        echo "Error: Failed to download MySQL Connector/J"
        exit 1
    fi
    
    echo "Download completed!"
    echo
fi

# Compile Java program
echo "Compiling MySQLSQLExecutor.java..."
echo "Targeting Java 8 for compatibility..."
javac -source 8 -target 8 -cp ".:${MYSQL_CONNECTOR_JAR}" MySQLSQLExecutor.java

if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo
    echo "To run the program:"
    echo "  ./run.sh <path_to_sql_file>"
    echo
    echo "Example:"
    echo "  ./run.sh ../user_specific_grant_commands_mysql/execute_100_grants.sql"
else
    echo "Compilation failed!"
    exit 1
fi

# Made with Bob
