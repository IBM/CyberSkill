-- Complete Attack Pattern Library - All 23 Patterns with Fixed Column Names
-- Drop and recreate table to ensure clean state

DROP TABLE IF EXISTS public.tb_attack_patterns CASCADE;

CREATE TABLE public.tb_attack_patterns (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    severity VARCHAR(20),
    attack_type VARCHAR(100),
    mitigation TEXT,
    target_databases JSONB,
    example_queries JSONB,
    tags JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SQL Injection Patterns (4 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('sqli-union-001', 'Union-Based SQL Injection', 'SQL Injection', 
 'Attempts to extract data using UNION SELECT statements to combine results from multiple queries', 
 'CRITICAL', 'SQL_INJECTION_UNION',
 'Use parameterized queries, input validation, and least privilege database accounts',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' UNION SELECT username, password, email, phone, NULL, NULL, NULL, NULL FROM crm.tbl_users", "SELECT * FROM crm.tbl_product WHERE id = ''d67f8d9d'' UNION SELECT table_name, column_name, NULL, NULL, NULL FROM information_schema.columns"]',
 '["sqli", "union", "data-extraction", "owasp-top10"]'),

('sqli-blind-002', 'Blind SQL Injection', 'SQL Injection',
 'Boolean-based blind SQL injection that infers data by observing application behavior',
 'HIGH', 'SQL_INJECTION_BLIND',
 'Implement proper error handling, use parameterized queries, and monitor for unusual query patterns',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=1", "SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=2", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND SUBSTRING(password,1,1) = ''a''"]',
 '["sqli", "blind", "inference", "owasp-top10"]'),

('sqli-time-003', 'Time-Based SQL Injection', 'SQL Injection',
 'Uses database sleep functions to infer data based on response time delays',
 'HIGH', 'SQL_INJECTION_TIME_BASED',
 'Use parameterized queries, implement query timeout limits, and monitor for slow queries',
 '["mysql", "postgresql", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND SLEEP(5)", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND IF(SUBSTRING(password,1,1)=''a'', SLEEP(5), 0)", "SELECT * FROM crm.tbl_product WHERE id = ''d67f8d9d''; WAITFOR DELAY ''00:00:05''"]',
 '["sqli", "time-based", "blind", "owasp-top10"]'),

('sqli-error-004', 'Error-Based SQL Injection', 'SQL Injection',
 'Exploits database error messages to extract information about database structure',
 'HIGH', 'SQL_INJECTION_ERROR_BASED',
 'Disable detailed error messages in production, use parameterized queries, and implement proper exception handling',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND (SELECT 1 FROM (SELECT COUNT(*), CONCAT((SELECT version()), 0x3a, FLOOR(RAND()*2)) x FROM information_schema.tables GROUP BY x) y)", "SELECT * FROM crm.tbl_users WHERE user_id = CAST(''abc'' AS INTEGER)", "SELECT * FROM crm.tbl_product WHERE id = ''d67f8d9d'' AND 1=CONVERT(int, (SELECT @@version))"]',
 '["sqli", "error-based", "information-disclosure", "owasp-top10"]');

-- Authentication Attack Patterns (3 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('auth-bypass-001', 'Authentication Bypass', 'Authentication',
 'Attempts to bypass authentication using SQL injection in login forms',
 'CRITICAL', 'AUTHENTICATION_BYPASS',
 'Use parameterized queries for authentication, implement account lockout, and use multi-factor authentication',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_users WHERE username = ''admin'' OR ''1''=''1'' AND password = ''anything''", "SELECT * FROM crm.tbl_users WHERE username = ''admin''--'' AND password = ''anything''", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' OR 1=1 LIMIT 1--'' AND password = ''x''"]',
 '["authentication", "bypass", "sqli", "owasp-top10"]'),

('auth-brute-002', 'Brute Force Attack', 'Authentication',
 'Attempts multiple login combinations to guess valid credentials',
 'HIGH', 'BRUTE_FORCE_ATTACK',
 'Implement rate limiting, account lockout after failed attempts, CAPTCHA, and monitor for suspicious login patterns',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND password = ''password123''", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND password = ''admin123''", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND password = ''123456''", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND password = ''qwerty''"]',
 '["authentication", "brute-force", "password-attack"]'),

('auth-stuff-003', 'Credential Stuffing', 'Authentication',
 'Uses known username/password combinations from data breaches',
 'HIGH', 'CREDENTIAL_STUFFING',
 'Implement multi-factor authentication, monitor for unusual login patterns, use CAPTCHA, and enforce password complexity',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_users WHERE username = ''john.doe@example.com'' AND password = ''Password123!''", "SELECT * FROM crm.tbl_users WHERE username = ''admin@company.com'' AND password = ''Welcome2024''", "SELECT * FROM crm.tbl_users WHERE username = ''user@domain.com'' AND password = ''Summer2024!''"]',
 '["authentication", "credential-stuffing", "password-attack"]');

-- Data Exfiltration Patterns (3 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('exfil-mass-001', 'Mass Data Extraction', 'Data Exfiltration',
 'Attempts to extract large amounts of data from multiple tables',
 'CRITICAL', 'MASS_DATA_EXTRACTION',
 'Implement row-level security, audit all SELECT queries, limit result set sizes, and use data masking',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts", "SELECT * FROM crm.tbl_users", "SELECT * FROM crm.tbl_product", "SELECT * FROM crm.tbl_calls", "SELECT * FROM crm.tbl_email_lists"]',
 '["exfiltration", "data-theft", "mass-extraction"]'),

('exfil-sensitive-002', 'Sensitive Data Access', 'Data Exfiltration',
 'Targets tables containing personally identifiable information (PII)',
 'CRITICAL', 'SENSITIVE_DATA_ACCESS',
 'Encrypt sensitive data at rest, implement column-level encryption, use data masking, and audit all access to PII',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT username, password, email, phone FROM crm.tbl_users", "SELECT account_name, contact_email, contact_phone, billing_address FROM crm.tbl_crm_accounts", "SELECT * FROM crm.tbl_users WHERE role = ''admin''"]',
 '["exfiltration", "pii", "sensitive-data", "gdpr"]'),

('exfil-export-003', 'Unauthorized Data Export', 'Data Exfiltration',
 'Attempts to export data to external files or locations',
 'CRITICAL', 'UNAUTHORIZED_DATA_EXPORT',
 'Disable file export functions, restrict file system permissions, monitor for OUTFILE/COPY commands, and use database firewalls',
 '["mysql", "postgresql", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts INTO OUTFILE ''/tmp/accounts.csv''", "SELECT * FROM crm.tbl_users INTO OUTFILE ''/var/www/html/users.txt''", "COPY crm.tbl_crm_accounts TO ''/tmp/accounts.csv'' DELIMITER '','' CSV HEADER"]',
 '["exfiltration", "file-export", "data-theft"]');

-- Privilege Escalation Patterns (2 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('priv-esc-001', 'Privilege Escalation', 'Privilege Escalation',
 'Attempts to gain elevated privileges through SQL injection',
 'CRITICAL', 'PRIVILEGE_ESCALATION',
 'Use least privilege principle, disable dangerous SQL commands, implement role-based access control, and audit privilege changes',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["GRANT ALL PRIVILEGES ON *.* TO ''attacker''@''%'' IDENTIFIED BY ''password''", "UPDATE crm.tbl_users SET role = ''admin'' WHERE username = ''attacker''", "ALTER USER attacker WITH SUPERUSER", "EXEC sp_addsrvrolemember ''attacker'', ''sysadmin''"]',
 '["privilege-escalation", "authorization", "admin-access"]'),

('priv-role-002', 'Role Manipulation', 'Privilege Escalation',
 'Modifies user roles to gain unauthorized access',
 'HIGH', 'ROLE_MANIPULATION',
 'Implement proper authorization checks, audit role changes, use database triggers to prevent unauthorized modifications',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["UPDATE crm.tbl_users SET role = ''admin'' WHERE user_id = 999", "UPDATE crm.tbl_users SET permissions = ''ALL'' WHERE username = ''attacker''", "INSERT INTO crm.tbl_user_roles (user_id, role_id) VALUES (999, 1)"]',
 '["privilege-escalation", "role-manipulation", "authorization"]');

-- Denial of Service Patterns (2 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('dos-resource-001', 'Resource Exhaustion', 'Denial of Service',
 'Executes resource-intensive queries to exhaust database resources',
 'HIGH', 'RESOURCE_EXHAUSTION',
 'Implement query timeout limits, use connection pooling, monitor resource usage, and implement rate limiting',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts a1, crm.tbl_crm_accounts a2, crm.tbl_crm_accounts a3", "SELECT * FROM crm.tbl_users u1 CROSS JOIN crm.tbl_product p1 CROSS JOIN crm.tbl_calls c1", "SELECT COUNT(*) FROM crm.tbl_crm_accounts WHERE account_name LIKE ''%a%'' OR account_name LIKE ''%b%'' OR account_name LIKE ''%c%''"]',
 '["dos", "resource-exhaustion", "performance"]'),

('dos-slow-002', 'Slow Query Attack', 'Denial of Service',
 'Crafts intentionally slow queries to degrade database performance',
 'MEDIUM', 'SLOW_QUERY_ATTACK',
 'Set query execution time limits, optimize database indexes, monitor slow query logs, and implement query complexity analysis',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_crm_accounts WHERE account_name LIKE ''%'' ORDER BY RAND()", "SELECT * FROM crm.tbl_users u JOIN crm.tbl_crm_accounts a ON u.username LIKE CONCAT(''%'', a.account_name, ''%'')", "SELECT * FROM crm.tbl_product WHERE UPPER(product_name) = UPPER(''test'') AND LOWER(description) LIKE ''%slow%''"]',
 '["dos", "slow-query", "performance"]');

-- Compliance Testing Patterns (5 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('comp-gdpr-001', 'GDPR Data Access Test', 'Compliance Testing',
 'Tests access controls for personal data under GDPR requirements',
 'MEDIUM', 'GDPR_DATA_ACCESS',
 'Implement data access logging, use encryption for PII, implement right to access controls, and maintain audit trails',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT email, phone, billing_address FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a''", "SELECT username, email, phone FROM crm.tbl_users WHERE user_id = 1", "SELECT * FROM crm.tbl_users WHERE email LIKE ''%@example.com''"]',
 '["compliance", "gdpr", "pii", "privacy"]'),

('comp-gdpr-002', 'GDPR Right to Deletion Test', 'Compliance Testing',
 'Tests data deletion capabilities required by GDPR',
 'MEDIUM', 'GDPR_RIGHT_TO_DELETION',
 'Implement secure deletion procedures, maintain deletion audit logs, and ensure cascading deletes for related data',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["DELETE FROM crm.tbl_users WHERE user_id = 999", "DELETE FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a''", "UPDATE crm.tbl_users SET email = NULL, phone = NULL WHERE user_id = 999"]',
 '["compliance", "gdpr", "data-deletion", "privacy"]'),

('comp-pci-001', 'PCI-DSS Card Data Access', 'Compliance Testing',
 'Tests access controls for payment card data',
 'CRITICAL', 'PCI_DSS_CARD_DATA_ACCESS',
 'Encrypt card data at rest and in transit, implement tokenization, restrict access to cardholder data, and maintain audit logs',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_payment_cards", "SELECT card_number, cvv, expiry_date FROM crm.tbl_payment_cards WHERE user_id = 1", "SELECT * FROM crm.tbl_transactions WHERE amount > 1000"]',
 '["compliance", "pci-dss", "payment-card", "financial"]'),

('comp-hipaa-001', 'HIPAA PHI Access Test', 'Compliance Testing',
 'Tests access controls for Protected Health Information',
 'CRITICAL', 'HIPAA_PHI_ACCESS',
 'Implement role-based access control, encrypt PHI, maintain comprehensive audit logs, and use data masking',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_patient_records", "SELECT patient_name, diagnosis, treatment FROM crm.tbl_patient_records WHERE patient_id = 1", "SELECT * FROM crm.tbl_medical_history WHERE ssn = ''123-45-6789''"]',
 '["compliance", "hipaa", "phi", "healthcare"]'),

('comp-sox-001', 'SOX Financial Data Access', 'Compliance Testing',
 'Tests access controls for financial data under SOX requirements',
 'HIGH', 'SOX_FINANCIAL_DATA_ACCESS',
 'Implement segregation of duties, maintain audit trails, use change management controls, and restrict financial data access',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT * FROM crm.tbl_financial_records", "SELECT account_number, balance, transaction_amount FROM crm.tbl_accounts WHERE account_type = ''revenue''", "UPDATE crm.tbl_financial_records SET amount = 999999 WHERE record_id = 1"]',
 '["compliance", "sox", "financial", "audit"]');

-- Data Manipulation Patterns (2 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('manip-update-001', 'Unauthorized Data Modification', 'Data Manipulation',
 'Attempts to modify data without proper authorization',
 'HIGH', 'UNAUTHORIZED_DATA_MODIFICATION',
 'Implement proper authorization checks, use database triggers, maintain audit logs, and use row-level security',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["UPDATE crm.tbl_crm_accounts SET account_status = ''active'' WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a''", "UPDATE crm.tbl_product SET price = 0.01 WHERE id = ''d67f8d9d''", "UPDATE crm.tbl_users SET account_balance = 999999 WHERE user_id = 1"]',
 '["data-manipulation", "unauthorized-update", "integrity"]'),

('manip-delete-001', 'Unauthorized Data Deletion', 'Data Manipulation',
 'Attempts to delete critical data without authorization',
 'CRITICAL', 'UNAUTHORIZED_DATA_DELETION',
 'Implement proper authorization, use soft deletes, maintain backups, and restrict DROP/TRUNCATE permissions',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["DELETE FROM crm.tbl_crm_accounts WHERE 1=1", "DROP TABLE crm.tbl_users", "TRUNCATE TABLE crm.tbl_product"]',
 '["data-manipulation", "data-deletion", "integrity"]');

-- Information Disclosure Patterns (2 patterns)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags) VALUES
('info-schema-001', 'Database Schema Enumeration', 'Information Disclosure',
 'Attempts to discover database structure and table information',
 'MEDIUM', 'SCHEMA_ENUMERATION',
 'Restrict access to information_schema, use database firewalls, and monitor for reconnaissance queries',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT table_name FROM information_schema.tables WHERE table_schema = ''crm''", "SELECT column_name, data_type FROM information_schema.columns WHERE table_name = ''tbl_users''", "SELECT * FROM information_schema.table_privileges"]',
 '["information-disclosure", "reconnaissance", "schema-discovery"]'),

('info-version-001', 'Database Version Detection', 'Information Disclosure',
 'Attempts to identify database version and configuration',
 'LOW', 'VERSION_DETECTION',
 'Disable version disclosure, use database firewalls, and monitor for version detection attempts',
 '["mysql", "postgresql", "db2", "sqlserver"]',
 '["SELECT VERSION()", "SELECT @@version", "SELECT * FROM v$version"]',
 '["information-disclosure", "reconnaissance", "version-detection"]');

-- Verify count
SELECT COUNT(*) as total_patterns FROM public.tb_attack_patterns;
SELECT category, COUNT(*) as count FROM public.tb_attack_patterns GROUP BY category ORDER BY category;

