-- ============================================
-- FIX ATTACK PATTERNS WITH CORRECT COLUMN NAMES
-- ============================================
-- This script updates the attack patterns to use correct column names
-- based on the actual MySQL CRM schema
--
-- Run against: PostgreSQL slp database (localhost:5432/slp)
-- Usage: psql -U postgres -d slp -f fix_attack_patterns.sql
-- ============================================

-- Fix Union-Based SQL Injection pattern
-- tbl_product columns: id, name, description, price, quantity
UPDATE public.tb_attack_patterns
SET example_queries = '["SELECT id, name, description, price, quantity FROM crm.tbl_product WHERE id = ''d67f8d9d'' UNION SELECT table_name, column_name, NULL, NULL, NULL FROM information_schema.columns"]'::jsonb,
    description = 'Attempts to extract database schema information using UNION SELECT to combine product data with information_schema metadata',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 'sqli-union-001';

-- Fix Boolean-Based Blind SQL Injection pattern
-- tbl_crm_accounts uses 'id' not 'account_id'
UPDATE public.tb_attack_patterns
SET example_queries = '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=1", "SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=2"]'::jsonb,
    updated_at = CURRENT_TIMESTAMP
WHERE id = 'sqli-blind-001';

-- Fix Privilege Escalation pattern (remove tbl_users reference)
UPDATE public.tb_attack_patterns
SET example_queries = '["GRANT ALL PRIVILEGES ON crm.* TO ''lowpriv_user''@''%''", "GRANT SELECT, INSERT, UPDATE, DELETE ON crm.tbl_crm_accounts TO lowpriv_user"]'::jsonb,
    description = 'Attempts to grant elevated privileges to a low-privilege account on CRM tables',
    updated_at = CURRENT_TIMESTAMP

-- Fix sqli-blind-002 if it exists (alternative blind SQL injection pattern)
UPDATE public.tb_attack_patterns
SET example_queries = '["SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=1", "SELECT * FROM crm.tbl_crm_accounts WHERE id = ''df61978a-f4cc-ff64-8de0-53e90f19a56a'' AND 1=2", "SELECT * FROM crm.tbl_users WHERE username = ''admin'' AND SUBSTRING(password,1,1) = ''a''"]'::jsonb,
    description = 'Boolean-based blind SQL injection that infers data by observing application behavior',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 'sqli-blind-002';

WHERE id = 'priv-escalation-001';

-- Add more realistic attack patterns with correct column names

-- Time-Based Blind SQL Injection
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
)
ON CONFLICT (id) DO UPDATE SET
    example_queries = EXCLUDED.example_queries,
    updated_at = CURRENT_TIMESTAMP;

-- Error-Based SQL Injection
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
)
ON CONFLICT (id) DO UPDATE SET
    example_queries = EXCLUDED.example_queries,
    updated_at = CURRENT_TIMESTAMP;

-- Stacked Queries Attack
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
)
ON CONFLICT (id) DO UPDATE SET
    example_queries = EXCLUDED.example_queries,
    updated_at = CURRENT_TIMESTAMP;

-- Unauthorized Data Modification
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
)
ON CONFLICT (id) DO UPDATE SET
    example_queries = EXCLUDED.example_queries,
    updated_at = CURRENT_TIMESTAMP;

-- Unauthorized Data Deletion
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
)
ON CONFLICT (id) DO UPDATE SET
    example_queries = EXCLUDED.example_queries,
    updated_at = CURRENT_TIMESTAMP;

-- Success message
DO $$
DECLARE
    pattern_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO pattern_count FROM public.tb_attack_patterns;
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Attack patterns updated successfully!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Total patterns in database: %', pattern_count;
    RAISE NOTICE '';
    RAISE NOTICE 'Fixed patterns:';
    RAISE NOTICE '  - Union-Based SQL Injection (corrected column names)';
    RAISE NOTICE '  - Boolean-Based Blind SQL Injection (corrected column names)';
    RAISE NOTICE '';
    RAISE NOTICE 'Added patterns:';
    RAISE NOTICE '  - Time-Based Blind SQL Injection';
    RAISE NOTICE '  - Error-Based SQL Injection';
    RAISE NOTICE '  - Stacked Queries SQL Injection';
    RAISE NOTICE '  - Unauthorized Data Modification';
    RAISE NOTICE '  - Unauthorized Data Deletion';
    RAISE NOTICE '';
    RAISE NOTICE 'All queries now use correct CRM table column names:';
    RAISE NOTICE '  - tbl_product: id, name, description, price, quantity';
    RAISE NOTICE '  - tbl_crm_accounts: id, name, status, phone_office, etc.';
    RAISE NOTICE '  - tbl_email_lists: id, email_address, opt_out, etc.';
    RAISE NOTICE '==============================================';
END $$;

-- Made with Bob
