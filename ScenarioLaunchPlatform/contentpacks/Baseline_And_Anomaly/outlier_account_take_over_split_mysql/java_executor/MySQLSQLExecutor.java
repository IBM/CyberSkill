import java.io.*;
import java.nio.file.*;
import java.sql.*;
import java.util.*;

/**
 * MySQL SQL File Executor
 * Connects to MySQL database via JDBC and executes SQL files
 * 
 * Usage: java MySQLSQLExecutor <sql_file_path>
 * Configuration: Edit db.properties file with your database credentials
 */
public class MySQLSQLExecutor {
    
    private String host;
    private int port;
    private String database;
    private String username;
    private String password;
    
    public MySQLSQLExecutor(String propertiesFile) throws IOException {
        loadProperties(propertiesFile);
    }
    
    /**
     * Load database configuration from properties file
     */
    private void loadProperties(String propertiesFile) throws IOException {
        Properties props = new Properties();
        try (FileInputStream fis = new FileInputStream(propertiesFile)) {
            props.load(fis);
        }
        
        this.host = props.getProperty("db.host", "localhost");
        this.port = Integer.parseInt(props.getProperty("db.port", "3306"));
        this.database = props.getProperty("db.database", "testdb");
        this.username = props.getProperty("db.username", "root");
        this.password = props.getProperty("db.password", "");
        
        System.out.println("Configuration loaded:");
        System.out.println("  Host: " + host);
        System.out.println("  Port: " + port);
        System.out.println("  Database: " + database);
        System.out.println("  Username: " + username);
        System.out.println();
    }
    
    /**
     * Get JDBC connection URL
     */
    private String getConnectionUrl() {
        return String.format("jdbc:mysql://%s:%d/%s?allowMultiQueries=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                host, port, database);
    }
    
    /**
     * Execute SQL file
     */
    public void executeSQLFile(String sqlFilePath) throws SQLException, IOException {
        String sqlContent = readSQLFile(sqlFilePath);
        
        if (sqlContent == null || sqlContent.trim().isEmpty()) {
            System.err.println("Error: SQL file is empty or could not be read");
            return;
        }
        
        System.out.println("Executing SQL file: " + sqlFilePath);
        System.out.println("File size: " + sqlContent.length() + " characters");
        System.out.println("Connecting to database...");
        
        try (Connection conn = DriverManager.getConnection(getConnectionUrl(), username, password)) {
            System.out.println("Connected successfully!");
            
            // Split SQL content by semicolons and execute each statement
            String[] statements = splitSQLStatements(sqlContent);
            
            int successCount = 0;
            int errorCount = 0;
            
            try (Statement stmt = conn.createStatement()) {
                for (int i = 0; i < statements.length; i++) {
                    String sql = statements[i].trim();
                    
                    if (sql.isEmpty() || sql.startsWith("--")) {
                        continue; // Skip empty lines and comments
                    }
                    
                    try {
                        boolean hasResultSet = stmt.execute(sql);
                        
                        if (hasResultSet) {
                            // Query returned results - just count rows, don't print
                            try (ResultSet rs = stmt.getResultSet()) {
                                int rowCount = 0;
                                while (rs.next()) {
                                    rowCount++;
                                }
                                // Only print summary for SELECT queries
                                if ((i + 1) % 50 == 0) {
                                    System.out.println("Executed " + (i + 1) + " statements so far...");
                                }
                            }
                        } else {
                            // DML/DDL statement
                            int updateCount = stmt.getUpdateCount();
                            if (updateCount >= 0) {
                                System.out.println("Statement " + (i + 1) + ": " + updateCount + " rows affected");
                            }
                        }
                        successCount++;
                        
                    } catch (SQLException e) {
                        errorCount++;
                        System.err.println("Error executing statement " + (i + 1) + ": " + e.getMessage());
                        System.err.println("SQL: " + sql.substring(0, Math.min(100, sql.length())) + "...");
                        
                        // Continue with next statement instead of failing completely
                    }
                }
            }
            
            System.out.println("\n=== Execution Summary ===");
            System.out.println("Total statements: " + statements.length);
            System.out.println("Successful: " + successCount);
            System.out.println("Errors: " + errorCount);
            
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Read SQL file content
     */
    private String readSQLFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        if (!Files.exists(path)) {
            throw new FileNotFoundException("SQL file not found: " + filePath);
        }
        return new String(Files.readAllBytes(path));
    }
    
    /**
     * Split SQL content into individual statements
     * Handles DELIMITER changes for stored procedures
     */
    private String[] splitSQLStatements(String sqlContent) {
        List<String> statements = new ArrayList<>();
        StringBuilder currentStatement = new StringBuilder();
        String currentDelimiter = ";";
        
        String[] lines = sqlContent.split("\n");
        
        for (String line : lines) {
            String trimmedLine = line.trim();
            
            // Check for DELIMITER change
            if (trimmedLine.toUpperCase().startsWith("DELIMITER")) {
                String[] parts = trimmedLine.split("\\s+");
                if (parts.length > 1) {
                    currentDelimiter = parts[1];
                }
                continue;
            }
            
            // Skip comment lines
            if (trimmedLine.startsWith("--") || trimmedLine.startsWith("#")) {
                continue;
            }
            
            currentStatement.append(line).append("\n");
            
            // Check if statement ends with current delimiter
            if (trimmedLine.endsWith(currentDelimiter)) {
                String stmt = currentStatement.toString().trim();
                // Remove the delimiter from the end
                if (stmt.endsWith(currentDelimiter)) {
                    stmt = stmt.substring(0, stmt.length() - currentDelimiter.length()).trim();
                }
                if (!stmt.isEmpty()) {
                    statements.add(stmt);
                }
                currentStatement = new StringBuilder();
            }
        }
        
        // Add any remaining statement
        String remaining = currentStatement.toString().trim();
        if (!remaining.isEmpty()) {
            statements.add(remaining);
        }
        
        return statements.toArray(new String[0]);
    }
    
    /**
     * Print ResultSet in a formatted way
     */
    private void printResultSet(ResultSet rs) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();
        
        // Print column headers
        System.out.println();
        for (int i = 1; i <= columnCount; i++) {
            System.out.print(metaData.getColumnName(i));
            if (i < columnCount) System.out.print(" | ");
        }
        System.out.println();
        System.out.println("-".repeat(80));
        
        // Print rows
        int rowCount = 0;
        while (rs.next()) {
            for (int i = 1; i <= columnCount; i++) {
                System.out.print(rs.getString(i));
                if (i < columnCount) System.out.print(" | ");
            }
            System.out.println();
            rowCount++;
        }
        System.out.println("(" + rowCount + " rows)");
        System.out.println();
    }
    
    /**
     * Main method
     */
    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java MySQLSQLExecutor <sql_file_path>");
            System.err.println("Example: java MySQLSQLExecutor ../user_specific_grant_commands_mysql/execute_100_grants.sql");
            System.exit(1);
        }
        
        String sqlFilePath = args[0];
        String propertiesFile = "db.properties";
        
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            MySQLSQLExecutor executor = new MySQLSQLExecutor(propertiesFile);
            executor.executeSQLFile(sqlFilePath);
            
            System.out.println("\nExecution completed successfully!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            System.err.println("Please download mysql-connector-java JAR and add to classpath");
            System.err.println("Download from: https://dev.mysql.com/downloads/connector/j/");
            System.exit(1);
        } catch (FileNotFoundException e) {
            System.err.println("Error: " + e.getMessage());
            System.exit(1);
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}

// Made with Bob
