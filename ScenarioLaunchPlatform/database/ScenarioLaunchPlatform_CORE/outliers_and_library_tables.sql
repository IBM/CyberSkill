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

