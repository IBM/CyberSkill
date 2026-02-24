-- Outliers and Attack Library Database Tables
-- Author: Jason Flood/John Clarke
-- This script adds database persistence for Outliers scripts and Attack Library patterns

-- ============================================
-- OUTLIERS TABLES
-- ============================================

-- Main table for outlier scripts
CREATE TABLE IF NOT EXISTS public.tb_outlier_scripts
(
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    script_type VARCHAR(50) NOT NULL, -- 'bash' or 'windows'
    file_path TEXT NOT NULL,
    original_file_name VARCHAR(255),
    file_size BIGINT,
    uploaded_by VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN DEFAULT false,
    last_executed TIMESTAMP,
    last_execution_status VARCHAR(255),
    folder_path TEXT,
    readme_content TEXT,
    related_files JSONB, -- Array of related file names
    tags JSONB, -- Array of tags
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for script schedules (multiple schedules per script)
CREATE TABLE IF NOT EXISTS public.tb_outlier_schedules
(
    schedule_id VARCHAR(100) PRIMARY KEY,
    script_id VARCHAR(100) NOT NULL REFERENCES public.tb_outlier_scripts(id) ON DELETE CASCADE,
    cron_expression VARCHAR(100) NOT NULL,
    parameters TEXT,
    enabled BOOLEAN DEFAULT true,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_outlier_schedules_script_id ON public.tb_outlier_schedules(script_id);
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_enabled ON public.tb_outlier_scripts(enabled);
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_type ON public.tb_outlier_scripts(script_type);

-- ============================================
-- ATTACK LIBRARY TABLES
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
    target_databases JSONB, -- Array of database types: ['mysql', 'postgresql', etc.]
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
-- TRIGGER FUNCTIONS FOR UPDATED_AT
-- ============================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for outlier scripts
DROP TRIGGER IF EXISTS update_outlier_scripts_updated_at ON public.tb_outlier_scripts;
CREATE TRIGGER update_outlier_scripts_updated_at
    BEFORE UPDATE ON public.tb_outlier_scripts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for outlier schedules
DROP TRIGGER IF EXISTS update_outlier_schedules_updated_at ON public.tb_outlier_schedules;
CREATE TRIGGER update_outlier_schedules_updated_at
    BEFORE UPDATE ON public.tb_outlier_schedules
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Triggers for attack patterns
DROP TRIGGER IF EXISTS update_attack_patterns_updated_at ON public.tb_attack_patterns;
CREATE TRIGGER update_attack_patterns_updated_at
    BEFORE UPDATE ON public.tb_attack_patterns
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert a sample attack pattern
INSERT INTO public.tb_attack_patterns (id, name, category, description, severity, attack_type, mitigation, target_databases, example_queries, tags)
VALUES (
    'sqli-union-001',
    'Union-Based SQL Injection',
    'SQL Injection',
    'Attempts to extract data using UNION SELECT statements to combine results from multiple queries',
    'CRITICAL',
    'SQL_INJECTION_UNION',
    'Use parameterized queries, input validation, and least privilege database accounts',
    '["mysql", "postgresql", "db2", "sqlserver"]'::jsonb,
    '["SELECT * FROM crm.tbl_crm_accounts WHERE account_id = 1 UNION SELECT username, password, email, phone, NULL, NULL, NULL, NULL FROM crm.tbl_users"]'::jsonb,
    '["sqli", "union", "data-extraction", "owasp-top10"]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- VIEWS FOR EASIER QUERYING
-- ============================================

-- View to get scripts with their schedules
CREATE OR REPLACE VIEW v_outlier_scripts_with_schedules AS
SELECT 
    s.id,
    s.name,
    s.description,
    s.script_type,
    s.enabled,
    s.uploaded_by,
    s.uploaded_at,
    s.last_executed,
    s.last_execution_status,
    COUNT(sch.schedule_id) as schedule_count,
    COUNT(CASE WHEN sch.enabled = true THEN 1 END) as enabled_schedule_count,
    json_agg(
        json_build_object(
            'schedule_id', sch.schedule_id,
            'cron_expression', sch.cron_expression,
            'parameters', sch.parameters,
            'enabled', sch.enabled,
            'description', sch.description
        ) ORDER BY sch.created_at
    ) FILTER (WHERE sch.schedule_id IS NOT NULL) as schedules
FROM public.tb_outlier_scripts s
LEFT JOIN public.tb_outlier_schedules sch ON s.id = sch.script_id
GROUP BY s.id, s.name, s.description, s.script_type, s.enabled, s.uploaded_by, 
         s.uploaded_at, s.last_executed, s.last_execution_status;

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
-- COMMENTS FOR DOCUMENTATION
-- ============================================

COMMENT ON TABLE public.tb_outlier_scripts IS 'Stores metadata for uploaded outlier scripts that can be scheduled';
COMMENT ON TABLE public.tb_outlier_schedules IS 'Stores multiple schedules for each outlier script';
COMMENT ON TABLE public.tb_attack_patterns IS 'Stores pre-built attack pattern templates for the attack library';

COMMENT ON COLUMN public.tb_outlier_scripts.script_type IS 'Type of script: bash (.sh) or windows (.bat, .cmd, .ps1)';
COMMENT ON COLUMN public.tb_outlier_scripts.related_files IS 'JSONB array of related file names (SQL, README, etc.)';
COMMENT ON COLUMN public.tb_outlier_schedules.cron_expression IS 'Cron expression for scheduling (e.g., "0 0 * * *")';
COMMENT ON COLUMN public.tb_attack_patterns.target_databases IS 'JSONB array of compatible database types';
COMMENT ON COLUMN public.tb_attack_patterns.example_queries IS 'JSONB array of example attack queries';

-- Success message
DO $$
BEGIN
    RAISE NOTICE 'Outliers and Attack Library tables created successfully!';
    RAISE NOTICE 'Tables: tb_outlier_scripts, tb_outlier_schedules, tb_attack_patterns';
    RAISE NOTICE 'Views: v_outlier_scripts_with_schedules, v_attack_patterns_by_category';
END $$;

-- Add package grouping fields to outlier scripts table
-- Run this script to add support for package grouping feature

ALTER TABLE public.tb_outlier_scripts 
ADD COLUMN IF NOT EXISTS package_id VARCHAR(100),
ADD COLUMN IF NOT EXISTS package_name VARCHAR(255);

-- Create index for faster package lookups
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_package_id ON public.tb_outlier_scripts(package_id);

-- Display confirmation
SELECT 'Package fields added successfully!' as status;

-- Migration script to add package_id and package_name columns to tb_outlier_scripts
-- This script is safe to run multiple times (idempotent)

DO $$
BEGIN
    -- Add package_id column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'tb_outlier_scripts' 
        AND column_name = 'package_id'
    ) THEN
        ALTER TABLE public.tb_outlier_scripts 
        ADD COLUMN package_id VARCHAR(100);
        
        RAISE NOTICE 'Added package_id column to tb_outlier_scripts';
    ELSE
        RAISE NOTICE 'package_id column already exists in tb_outlier_scripts';
    END IF;
    
    -- Add package_name column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'tb_outlier_scripts' 
        AND column_name = 'package_name'
    ) THEN
        ALTER TABLE public.tb_outlier_scripts 
        ADD COLUMN package_name VARCHAR(255);
        
        RAISE NOTICE 'Added package_name column to tb_outlier_scripts';
    ELSE
        RAISE NOTICE 'package_name column already exists in tb_outlier_scripts';
    END IF;
    
    -- Create index on package_id for faster package queries
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'tb_outlier_scripts' 
        AND indexname = 'idx_outlier_scripts_package_id'
    ) THEN
        CREATE INDEX idx_outlier_scripts_package_id ON public.tb_outlier_scripts(package_id);
        RAISE NOTICE 'Created index idx_outlier_scripts_package_id';
    ELSE
        RAISE NOTICE 'Index idx_outlier_scripts_package_id already exists';
    END IF;
    
    RAISE NOTICE 'Migration complete!';
END $$;

INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (11, 'outlier_massive_grant_case', 'v1.0', 'mysql', '11-Feb-2026', '144', 'Detects massive GRANT anomalies indicating privilege escalation attacks. Simulates 4 hours baseline (1 GRANT/hour) followed by spike (21 simultaneous GRANTs) to identify privilege abuse patterns.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_massive_grant_case", "build_date": "11-Feb-2026", "description": "Detects massive GRANT anomalies for privilege escalation", "build_version": "144", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (8, 'outlier_update_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '141', 'Detects UPDATE anomalies indicating data manipulation attacks. Simulates 4 hours baseline (50 UPDATEs/hour) followed by massive spike (1000 UPDATEs) to identify bulk data modification attempts.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_update_anomaly", "build_date": "11-Feb-2026", "description": "Detects UPDATE anomalies indicating data manipulation", "build_version": "141", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (9, 'outlier_insert_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '142', 'Detects INSERT anomalies indicating data injection attacks. Simulates 4 hours baseline (50 INSERTs/hour) followed by massive spike (1000 INSERTs) to identify bulk data insertion attempts.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_insert_anomaly", "build_date": "11-Feb-2026", "description": "Detects INSERT anomalies indicating data injection", "build_version": "142", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (10, 'outlier_revoke_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '143', 'Detects REVOKE anomalies indicating privilege removal attacks. Simulates 4 hours baseline (50 REVOKEs/hour) followed by massive spike (1000 REVOKEs) to identify bulk privilege stripping attempts.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_revoke_anomaly", "build_date": "11-Feb-2026", "description": "Detects REVOKE anomalies indicating privilege removal", "build_version": "143", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (12, 'outlier_data_leak_command', 'v1.0', 'mysql', '11-Feb-2026', '145', 'Detects data exfiltration through SELECT anomalies. Simulates 4 hours baseline (50 SELECTs/hour) followed by massive spike (1000 SELECTs) to identify data leak attempts and unauthorized data access.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_data_leak_command", "build_date": "11-Feb-2026", "description": "Detects data exfiltration through SELECT anomalies", "build_version": "145", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (13, 'outlier_account_take_over', 'v1.0', 'mysql', '11-Feb-2026', '146', 'Detects account takeover through object access pattern changes. Simulates 4 hours accessing 1 object (50 SELECTs/hour) followed by sudden access to all 5 objects (250 SELECTs) indicating compromised credentials.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_account_take_over", "build_date": "11-Feb-2026", "description": "Detects account takeover through access pattern changes", "build_version": "146", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (14, 'outlier_denial_of_service', 'v1.0', 'mysql', '11-Feb-2026', '147', 'Detects Denial of Service attacks through query volume anomalies. Simulates 4 hours baseline (1001 queries/hour) followed by massive spike (205000 queries) to identify resource exhaustion attacks.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_denial_of_service", "build_date": "11-Feb-2026", "description": "Detects DoS attacks through query volume anomalies", "build_version": "147", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (6, 'outlier_schema_tampering', 'v1.0', 'mysql', '11-Feb-2026', '139', 'A brief description of the pack contents', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_schema_tampering", "build_date": "10-Feb-2026", "description": "A brief description of the pack contents", "build_version": "139", "background_traffic": "yes"}', 'false', '2026-02-11 12:53:50.323099');
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (7, 'outlier_data_tampering', 'v1.0', 'mysql', '11-Feb-2026', '140', 'Detects data tampering through DELETE anomalies. Simulates 4 hours baseline (50 DELETEs/hour) followed by massive spike (1000 DELETEs) to identify unauthorized data destruction.', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_data_tampering", "build_date": "11-Feb-2026", "description": "Detects data tampering through DELETE anomalies", "build_version": "140", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');

-- PostgreSQL Outlier Content Packs
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (15, 'outlier_account_take_over_postgres', 'v1.0', 'postgres', '23-Feb-2026', '150', 'PostgreSQL Account Takeover Detection - Simulates normal access pattern (50 SELECTs on object1 for 4 hours) followed by sudden access to all 5 objects (250 SELECTs) to detect account takeover attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_account_take_over_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Account Takeover Detection", "build_version": "150", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (16, 'outlier_data_leak_command_postgres', 'v1.0', 'postgres', '23-Feb-2026', '151', 'PostgreSQL Data Leak Detection - Detects data exfiltration through SELECT anomalies. Simulates 4 hours baseline (50 SELECTs/hour) followed by massive spike (1000 SELECTs) to identify data leak attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_data_leak_command_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Data Leak Detection", "build_version": "151", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (17, 'outlier_data_tampering_postgres', 'v1.0', 'postgres', '23-Feb-2026', '152', 'PostgreSQL Data Tampering Detection - Detects data tampering through DELETE anomalies. Simulates 4 hours baseline (50 DELETEs/hour) followed by massive spike (1000 DELETEs) to identify unauthorized data destruction', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_data_tampering_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Data Tampering Detection", "build_version": "152", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (18, 'outlier_denial_of_service_postgres', 'v1.0', 'postgres', '23-Feb-2026', '153', 'PostgreSQL Denial of Service Detection - Detects DoS attacks through query volume anomalies. Simulates 4 hours baseline (1001 queries/hour) followed by massive spike (205000 queries) to identify resource exhaustion attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_denial_of_service_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL DoS Detection", "build_version": "153", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (19, 'outlier_insert_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '154', 'PostgreSQL Insert Anomaly Detection - Detects INSERT anomalies indicating data injection attacks. Simulates 4 hours baseline (50 INSERTs/hour) followed by massive spike (1000 INSERTs) to identify bulk data insertion attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_insert_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Insert Anomaly Detection", "build_version": "154", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (20, 'outlier_massive_grant_case_postgres', 'v1.0', 'postgres', '23-Feb-2026', '155', 'PostgreSQL Massive Grant Detection - Detects massive GRANT anomalies indicating privilege escalation attacks. Simulates 4 hours baseline (1 GRANT/hour) followed by spike (21 simultaneous GRANTs) to identify privilege abuse patterns', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_massive_grant_case_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Massive Grant Detection", "build_version": "155", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (21, 'outlier_revoke_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '156', 'PostgreSQL Revoke Anomaly Detection - Detects REVOKE anomalies indicating privilege removal attacks. Simulates 4 hours baseline (50 REVOKEs/hour) followed by massive spike (1000 REVOKEs) to identify bulk privilege stripping attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_revoke_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Revoke Anomaly Detection", "build_version": "156", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (22, 'outlier_schema_tampering_postgres', 'v1.0', 'postgres', '23-Feb-2026', '157', 'PostgreSQL Schema Tampering Detection - Detects unauthorized schema modifications through DDL anomalies. Monitors CREATE, ALTER, DROP operations to identify schema manipulation attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_schema_tampering_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Schema Tampering Detection", "build_version": "157", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES (22, 'outlier_update_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '158', 'PostgreSQL Update Anomaly Detection - Detects UPDATE anomalies indicating data manipulation attacks. Simulates 4 hours baseline (50 UPDATEs/hour) followed by massive spike (1000 UPDATEs) to identify bulk data modification attempts', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_update_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Update Anomaly Detection", "build_version": "158", "background_traffic": "yes"}', 'no', CURRENT_TIMESTAMP);


ALTER SEQUENCE public.tb_content_packs_id_seq RESTART WITH 24;

UPDATE public.tb_version SET version = 'v01.0013';