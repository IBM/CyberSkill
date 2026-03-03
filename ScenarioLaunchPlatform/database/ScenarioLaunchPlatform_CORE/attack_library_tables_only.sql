-- ============================================
-- ATTACK LIBRARY TABLES ONLY
-- ============================================
-- Author: Jason Flood/John Clarke
-- This script creates ONLY the Attack Library tables for the SLP system database
-- Run this against the 'slp' PostgreSQL database (localhost:5432/slp)
--
-- Purpose: Stores attack pattern templates that can be executed against target CRM databases
-- Note: This does NOT include Outliers tables (tb_outlier_scripts, tb_outlier_schedules)
--
-- Usage:
--   psql -U postgres -d slp -f attack_library_tables_only.sql
-- ============================================

-- Main table for attack patterns
CREATE TABLE IF NOT EXISTS public.tb_attack_patterns
(
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT,
    severity VARCHAR(50), -- 'CRITICAL', 'HIGH', 'MEDIUM', 'LOW'
    attack_type VARCHAR(100),
    mitigation TEXT,
    target_databases JSONB, -- Array of database types: ['mysql', 'postgresql', 'oracle', 'db2', 'sqlserver']
    example_queries JSONB, -- Array of example SQL queries
    tags JSONB, -- Array of tags for categorization
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster searches
CREATE INDEX IF NOT EXISTS idx_attack_patterns_category ON public.tb_attack_patterns(category);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_severity ON public.tb_attack_patterns(severity);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_type ON public.tb_attack_patterns(attack_type);

-- ============================================
-- TRIGGER FUNCTION FOR UPDATED_AT
-- ============================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_attack_patterns_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for attack patterns
DROP TRIGGER IF EXISTS update_attack_patterns_updated_at ON public.tb_attack_patterns;
CREATE TRIGGER update_attack_patterns_updated_at
    BEFORE UPDATE ON public.tb_attack_patterns
    FOR EACH ROW
    EXECUTE FUNCTION update_attack_patterns_updated_at_column();

-- ============================================
-- SAMPLE ATTACK PATTERNS
-- ============================================

-- 1. Union-Based SQL Injection
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-union-001',
    'Union-Based SQL Injection',
    'SQL Injection',
    'Attempts to extract data using UNION SELECT statements to combine results from multiple queries across CRM tables',
    'CRITICAL',
    'SQL_INJECTION_UNION',
    'Use parameterized queries, input validation, and least privilege database accounts',
    '["mysql", "postgresql", "db2", "sqlserver"]'::jsonb,
    '["SELECT id, name, phone_office, website FROM crm.tbl_crm_accounts WHERE id = ''1'' UNION SELECT id, email_address, ''N/A'', ''N/A'' FROM crm.tbl_email_lists"]'::jsonb,
    '["sqli", "union", "data-extraction", "owasp-top10"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- 2. Boolean-Based Blind SQL Injection
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-blind-001',
    'Boolean-Based Blind SQL Injection',
    'SQL Injection',
    'Exploits application responses to infer database structure and data through true/false conditions',
    'HIGH',
    'SQL_INJECTION_BLIND',
    'Implement proper error handling, use parameterized queries, and apply input validation',
    '["mysql", "postgresql", "oracle", "db2", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 AND 1=1", "SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 AND 1=2"]'::jsonb,
    '["sqli", "blind", "inference", "owasp-top10"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- 3. Privilege Escalation via GRANT
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'priv-escalation-001',
    'Privilege Escalation via GRANT',
    'Privilege Escalation',
    'Attempts to grant elevated privileges to a low-privilege account',
    'CRITICAL',
    'PRIVILEGE_ESCALATION',
    'Restrict GRANT privileges, implement role-based access control, and monitor privilege changes',
    '["mysql", "postgresql", "oracle", "db2"]'::jsonb,
    '["GRANT ALL PRIVILEGES ON crm.* TO ''lowpriv_user''@''%''", "GRANT SELECT, INSERT, UPDATE, DELETE ON crm.tbl_users TO lowpriv_user"]'::jsonb,
    '["privilege-escalation", "grant", "access-control"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- 4. Data Exfiltration via SELECT
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
    '["SELECT * FROM crm.tbl_crm_accounts", "SELECT name, phone_office, phone_alternate, website, annual_revenue FROM crm.tbl_crm_accounts", "SELECT * FROM crm.tbl_email_lists"]'::jsonb,
    '["data-leak", "exfiltration", "sensitive-data"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- 5. Schema Tampering via DROP
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
)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- VIEW FOR EASIER QUERYING
-- ============================================

-- View for attack patterns by category
CREATE OR REPLACE VIEW v_attack_patterns_by_category AS
SELECT 
    category,
    COUNT(*) as pattern_count,
    json_agg(
        json_build_object(
            'id', id,
            'name', name,
            'severity', severity,
            'attack_type', attack_type
        ) ORDER BY severity DESC, name
    ) as patterns
FROM public.tb_attack_patterns
GROUP BY category;

-- ============================================
-- DOCUMENTATION
-- ============================================

COMMENT ON TABLE public.tb_attack_patterns IS 'Stores pre-built attack pattern templates for the attack library';
COMMENT ON COLUMN public.tb_attack_patterns.target_databases IS 'JSONB array of compatible database types (mysql, postgresql, oracle, db2, sqlserver)';
COMMENT ON COLUMN public.tb_attack_patterns.example_queries IS 'JSONB array of example attack queries to execute against target CRM databases';
COMMENT ON COLUMN public.tb_attack_patterns.severity IS 'Attack severity level: CRITICAL, HIGH, MEDIUM, or LOW';
COMMENT ON COLUMN public.tb_attack_patterns.tags IS 'JSONB array of tags for categorization and searching';

-- Success message
DO $$
BEGIN
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Attack Library tables created successfully!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Table: tb_attack_patterns';
    RAISE NOTICE 'View: v_attack_patterns_by_category';
    RAISE NOTICE 'Sample patterns: 5 attack patterns inserted';
    RAISE NOTICE '';
    RAISE NOTICE 'Next steps:';
    RAISE NOTICE '1. Restart SLP application';
    RAISE NOTICE '2. Navigate to Attack Library in UI';
    RAISE NOTICE '3. Select an attack pattern';
    RAISE NOTICE '4. Choose target database connection';
    RAISE NOTICE '5. Execute pattern against target CRM database';
    RAISE NOTICE '==============================================';
END $$;

-- Made with Bob
