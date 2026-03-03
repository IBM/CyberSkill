-- ============================================
-- RECREATE ATTACK PATTERNS TABLE WITH FIXES
-- ============================================
-- This script drops and recreates the attack patterns table
-- with all correct column names (id instead of account_id/product_id)
-- and includes tbl_users references
--
-- Run against: PostgreSQL slp database (localhost:5432/slp)
-- Usage: psql -U postgres -d slp -f recreate_attack_patterns_fixed.sql
-- ============================================

-- Drop existing table and recreate
DROP TABLE IF EXISTS public.tb_attack_patterns CASCADE;

CREATE TABLE public.tb_attack_patterns
(
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    severity VARCHAR(50),
    attack_type VARCHAR(100),
    mitigation TEXT,
    target_databases JSONB,
    example_queries JSONB,
    tags JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_attack_patterns_category ON public.tb_attack_patterns(category);
CREATE INDEX idx_attack_patterns_severity ON public.tb_attack_patterns(severity);
CREATE INDEX idx_attack_patterns_type ON public.tb_attack_patterns(attack_type);

-- Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_attack_patterns_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_attack_patterns_updated_at ON public.tb_attack_patterns;
CREATE TRIGGER update_attack_patterns_updated_at
    BEFORE UPDATE ON public.tb_attack_patterns
    FOR EACH ROW
    EXECUTE FUNCTION update_attack_patterns_updated_at_column();

-- ============================================
-- INSERT ATTACK PATTERNS WITH CORRECT COLUMN NAMES
-- ============================================

-- 1. Union-Based SQL Injection (FIXED: uses id not product_id)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-union-001',
    'Union-Based SQL Injection',
    'SQL Injection',
    'Attempts to extract database schema information using UNION SELECT to combine product data with information_schema metadata',
    'CRITICAL',
    'SQL_INJECTION_UNION',
    'Use parameterized queries, input validation, and least privilege database accounts',
    '["mysql", "postgresql", "db2", "sqlserver"]'::jsonb,
    '["SELECT id, name, description, price, quantity FROM crm.tbl_product WHERE id = ''d67f8d9d'' UNION SELECT table_name, column_name, NULL, NULL, NULL FROM information_schema.columns"]'::jsonb,
    '["sqli", "union", "data-extraction", "owasp-top10"]'::jsonb
);

-- 2. Boolean-Based Blind SQL Injection (FIXED: uses id not account_id, includes tbl_users query)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-blind-002',
    'Blind SQL Injection',
    'SQL Injection',
    'Boolean-based blind SQL injection that infers data by observing application behavior',
    'HIGH',
    'SQL_INJECTION_BLIND',
    'Implement proper error handling, use parameterized queries, and apply input validation',
    '["mysql", "postgresql", "db2", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=1", "SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=2", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND SUBSTRING(password,1,1) = ''a''"]'::jsonb,
    '["sqli", "blind", "inference", "owasp-top10"]'::jsonb
);

-- 3. Time-Based Blind SQL Injection
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-time-001',
    'Time-Based Blind SQL Injection',
    'SQL Injection',
    'Uses database sleep functions to infer data through response timing',
    'HIGH',
    'SQL_INJECTION_TIME_BASED',
    'Use parameterized queries, implement query timeouts, and monitor slow queries',
    '["mysql", "postgresql", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_product WHERE id = ''d67f8d9d'' AND SLEEP(5)", "SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND (SELECT SLEEP(5))"]'::jsonb,
    '["sqli", "time-based", "blind", "owasp-top10"]'::jsonb
);

-- 4. Error-Based SQL Injection
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-error-001',
    'Error-Based SQL Injection',
    'SQL Injection',
    'Exploits database error messages to extract information',
    'HIGH',
    'SQL_INJECTION_ERROR_BASED',
    'Disable detailed error messages in production, use parameterized queries',
    '["mysql", "postgresql", "oracle", "db2", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_product WHERE id = ''d67f8d9d'' AND (SELECT 1 FROM (SELECT COUNT(*), CONCAT((SELECT name FROM crm.tbl_crm_accounts LIMIT 1), FLOOR(RAND()*2)) x FROM information_schema.tables GROUP BY x) y)", "SELECT * FROM crm.tbl_email_lists WHERE email_address = ''jim@example.com'' AND EXTRACTVALUE(1, CONCAT(0x7e, (SELECT name FROM crm.tbl_crm_accounts LIMIT 1)))"]'::jsonb,
    '["sqli", "error-based", "information-disclosure", "owasp-top10"]'::jsonb
);

-- 5. Stacked Queries Attack
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-stacked-001',
    'Stacked Queries SQL Injection',
    'SQL Injection',
    'Executes multiple SQL statements in a single query to perform unauthorized operations',
    'CRITICAL',
    'SQL_INJECTION_STACKED',
    'Disable multi-statement queries, use parameterized queries, restrict database permissions',
    '["mysql", "postgresql", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_product WHERE id = ''d67f8d9d''; UPDATE crm.tbl_product SET price = 0.01 WHERE id = ''d67f8d9d''", "SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a''; DELETE FROM crm.tbl_calls WHERE id = ''e854b40d-414e-6c8d-d2b7-53e90f7b0f77''"]'::jsonb,
    '["sqli", "stacked-queries", "data-manipulation", "owasp-top10"]'::jsonb
);

-- 6. Privilege Escalation via GRANT (FIXED: uses tbl_crm_accounts not tbl_users)
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'priv-escalation-001',
    'Privilege Escalation via GRANT',
    'Privilege Escalation',
    'Attempts to grant elevated privileges to a low-privilege account on CRM tables',
    'CRITICAL',
    'PRIVILEGE_ESCALATION',
    'Restrict GRANT privileges, implement role-based access control, and monitor privilege changes',
    '["mysql", "postgresql", "oracle", "db2"]'::jsonb,
    '["GRANT ALL PRIVILEGES ON crm.* TO ''lowpriv_user''@''%''", "GRANT SELECT, INSERT, UPDATE, DELETE ON crm.tbl_crm_accounts TO lowpriv_user"]'::jsonb,
    '["privilege-escalation", "grant", "access-control"]'::jsonb
);

-- 7. Mass Data Exfiltration
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'data-exfil-001',
    'Mass Data Exfiltration',
    'Data Leakage',
    'Attempts to extract large amounts of sensitive data from the CRM database',
    'CRITICAL',
    'DATA_EXFILTRATION',
    'Implement data access monitoring, use column-level encryption, and apply query result limits',
    '["mysql", "postgresql", "oracle", "db2", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_crm_accounts", "SELECT name, phone_office, phone_alternate, website, annual_revenue FROM crm.tbl_crm_accounts", "SELECT * FROM crm.tbl_email_lists", "SELECT * FROM crm.tbl_users"]'::jsonb,
    '["data-leak", "exfiltration", "sensitive-data"]'::jsonb
);

-- 8. Unauthorized Data Modification
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'data-modify-001',
    'Unauthorized Data Modification',
    'Data Manipulation',
    'Attempts to modify sensitive CRM data without authorization',
    'CRITICAL',
    'DATA_MODIFICATION',
    'Implement proper access controls, use audit logging, enable row-level security',
    '["mysql", "postgresql", "oracle", "db2", "sqlserver"]'::jsonb,
    '["UPDATE crm.tbl_product SET price = 0.01 WHERE id = ''d67f8d9d''", "UPDATE crm.tbl_crm_accounts SET status = 1 WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a''", "UPDATE crm.tbl_email_lists SET opt_out = 1 WHERE email_address = ''jim@example.com''"]'::jsonb,
    '["data-manipulation", "unauthorized-access", "integrity-violation"]'::jsonb
);

-- 9. Unauthorized Data Deletion
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'data-delete-001',
    'Unauthorized Data Deletion',
    'Data Manipulation',
    'Attempts to delete critical CRM records',
    'CRITICAL',
    'DATA_DELETION',
    'Implement soft deletes, use audit logging, restrict DELETE privileges',
    '["mysql", "postgresql", "oracle", "db2", "sqlserver"]'::jsonb,
    '["DELETE FROM crm.tbl_calls WHERE id = ''e854b40d-414e-6c8d-d2b7-53e90f7b0f77''", "DELETE FROM crm.tbl_bugs WHERE id = ''e4f7505c-0a0e-f582-f406-53e90f8a5637''", "DELETE FROM crm.tbl_product WHERE id = ''d67f8d9d''"]'::jsonb,
    '["data-deletion", "destructive", "unauthorized-access"]'::jsonb
);

-- 10. Schema Tampering via DROP
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'schema-tamper-001',
    'Schema Tampering via DROP',
    'Schema Tampering',
    'Attempts to drop critical CRM database tables',
    'CRITICAL',
    'SCHEMA_TAMPERING',
    'Restrict DDL privileges, implement database backups, and enable audit logging',
    '["mysql", "postgresql", "oracle", "db2", "sqlserver"]'::jsonb,
    '["DROP TABLE crm.tbl_product", "DROP TABLE crm.tbl_crm_accounts", "DROP TABLE crm.tbl_email_lists"]'::jsonb,
    '["ddl", "drop", "schema-tampering", "destructive"]'::jsonb
);

-- Success message
DO $$
DECLARE
    pattern_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO pattern_count FROM public.tb_attack_patterns;
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Attack patterns table recreated successfully!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Total patterns: %', pattern_count;
    RAISE NOTICE '';
    RAISE NOTICE 'All patterns now use correct column names:';
    RAISE NOTICE '  ✓ tbl_product: id (not product_id)';
    RAISE NOTICE '  ✓ tbl_crm_accounts: id (not account_id)';
    RAISE NOTICE '  ✓ tbl_users: included in patterns';
    RAISE NOTICE '';
    RAISE NOTICE 'Pattern sqli-blind-002 now has 3 queries:';
    RAISE NOTICE '  1. SELECT ... WHERE id = ... AND 1=1';
    RAISE NOTICE '  2. SELECT ... WHERE id = ... AND 1=2';
    RAISE NOTICE '  3. SELECT ... FROM tbl_users WHERE username = ...';
    RAISE NOTICE '==============================================';
END $$;

-- Made with Bob
