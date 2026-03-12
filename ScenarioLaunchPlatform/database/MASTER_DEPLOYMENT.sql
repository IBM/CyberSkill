-- ============================================================================================================
-- SCENARIO LAUNCH PLATFORM (SLP) - MASTER DEPLOYMENT SCRIPT
-- ============================================================================================================
-- Version: 1.0012
-- Database: PostgreSQL 14+
-- Authors: Jason Flood, John Clarke, Bob (AI Assistant)
-- Created: 2026-03-12
-- 
-- DESCRIPTION:
-- This is the complete master deployment script for first-time installation of the Scenario Launch Platform.
-- It creates the database, all tables, stored procedures, triggers, views, and populates initial data.
--
-- PREREQUISITES:
-- 1. PostgreSQL 14 or higher installed
-- 2. Database 'slp' created (or modify database name below)
-- 3. Execute as superuser or user with CREATE privileges
--
-- DEPLOYMENT INSTRUCTIONS:
-- 1. Create database: CREATE DATABASE slp;
-- 2. Connect to database: \c slp
-- 3. Execute this script: \i MASTER_DEPLOYMENT.sql
-- 4. Verify deployment: SELECT * FROM public.tb_version;
--
-- DEFAULT CREDENTIALS:
-- Username: admin
-- Password: admin (SHA-256: aca1a1c6a87b983c3346f44ba66936000a462f99ac5201c4c5f958046e61a79b)
-- ============================================================================================================

-- Set client encoding and timezone
SET client_encoding = 'UTF8';
SET timezone = 'UTC';

-- Begin transaction
BEGIN;

DO $$
BEGIN
    RAISE NOTICE '============================================================================================================';
    RAISE NOTICE 'SCENARIO LAUNCH PLATFORM - MASTER DEPLOYMENT';
    RAISE NOTICE '============================================================================================================';
    RAISE NOTICE 'Starting deployment at: %', NOW();
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 1: DROP EXISTING OBJECTS (Clean Slate)
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 1: Dropping existing tables and functions...';
    
    -- Drop tables with CASCADE to remove dependencies
    DROP TABLE IF EXISTS public.tb_user CASCADE;
    DROP TABLE IF EXISTS public.tb_query CASCADE;
    DROP TABLE IF EXISTS public.tb_databaseConnections CASCADE;
    DROP TABLE IF EXISTS public.tb_schedule CASCADE;
    DROP TABLE IF EXISTS public.tb_tasks CASCADE;
    DROP TABLE IF EXISTS public.tb_query_types CASCADE;
    DROP TABLE IF EXISTS public.tb_version CASCADE;
    DROP TABLE IF EXISTS public.tb_stories CASCADE;
    DROP TABLE IF EXISTS public.tb_myvars CASCADE;
    DROP TABLE IF EXISTS public.tb_content_packs CASCADE;
    DROP TABLE IF EXISTS public.tb_admin_functions CASCADE;
    DROP TABLE IF EXISTS public.tb_outlier_scripts CASCADE;
    DROP TABLE IF EXISTS public.tb_outlier_schedules CASCADE;
    DROP TABLE IF EXISTS public.tb_attack_patterns CASCADE;
    
    -- Drop functions
    DROP FUNCTION IF EXISTS function_login(TEXT, TEXT);
    DROP FUNCTION IF EXISTS update_updated_at_column();
    
    -- Drop views
    DROP VIEW IF EXISTS v_outlier_scripts_with_schedules;
    DROP VIEW IF EXISTS v_attack_patterns_by_category;
    
    RAISE NOTICE '✓ All existing objects dropped successfully';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 2: CREATE CORE TABLES
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 2: Creating core application tables...';
END $$;

-- Version Table
CREATE TABLE IF NOT EXISTS public.tb_version
(
    version character varying(100)
);
INSERT INTO public.tb_version(version) VALUES('v01.0012');
COMMENT ON TABLE public.tb_version IS 'Stores the current SLP application version';

-- User Table
CREATE TABLE IF NOT EXISTS public.tb_user
(
    id serial NOT NULL,
    firstname character varying(100),
    surname character varying(100),
    email character varying(100),
    username character varying(100) UNIQUE,
    password character varying(100) NOT NULL,
    active character varying(100),
    authlevel integer DEFAULT 0 NOT NULL,
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.tb_user IS 'Stores user accounts and authentication information';
COMMENT ON COLUMN public.tb_user.password IS 'SHA-256 hashed password';
COMMENT ON COLUMN public.tb_user.authlevel IS 'Authorization level: 0=user, 1=admin';

-- Insert default admin user (password: admin)
INSERT INTO public.tb_user(firstname, surname, email, username, password, active, authlevel) 
VALUES('admin_firstname', 'admin_surname', 'admin_email', 'admin', 
       'aca1a1c6a87b983c3346f44ba66936000a462f99ac5201c4c5f958046e61a79b', 'active', 1);

-- My Variables Table (User-specific JSON data)
CREATE TABLE public.tb_myvars 
(
    id SERIAL PRIMARY KEY, 
    username VARCHAR(255) UNIQUE, 
    data JSONB
);
COMMENT ON TABLE public.tb_myvars IS 'Stores user-specific variables in JSON format';

INSERT INTO public.tb_myvars (username, data) VALUES ('admin','{"my_var1": 1, "my_var2": "simpleString1"}');
INSERT INTO public.tb_myvars (username, data) VALUES ('username','{"my_var1": 2, "my_var2": "simpleString2"}');

-- Stories Table (Story execution history)
CREATE TABLE IF NOT EXISTS public.tb_stories
(
    id serial NOT NULL,
    runTime timestamp,
    story JSONB,
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.tb_stories IS 'Stores story execution history and results in JSON format';
ALTER SEQUENCE tb_stories_id_seq RESTART WITH 5000;

-- Schedule Table
CREATE TABLE IF NOT EXISTS public.tb_schedule
(
    id serial NOT NULL,
    name character varying(100),
    chronSequence character varying(100),
    fk_tb_databaseConnections_db_connection_id character varying(100),
    fk_tb_query_id INT,
    lastRunTime timestamp,
    lastRunMessage character varying(500),
    active character varying(100),
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.tb_schedule IS 'Stores scheduled query executions';
COMMENT ON COLUMN public.tb_schedule.chronSequence IS 'Cron expression for scheduling';

-- Tasks Table (OS-level scheduled tasks)
CREATE TABLE IF NOT EXISTS public.tb_tasks
(
    id SERIAL PRIMARY KEY,
    task_name character varying(255) NOT NULL,
    task_schedule character varying(50) NOT NULL,
    task_file_path text NOT NULL,
    task_os_type character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    task_file_content bytea,
    task_active character varying (20) DEFAULT 'Active'
);
COMMENT ON TABLE public.tb_tasks IS 'Stores OS-level scheduled tasks (scripts, batch files)';

-- Content Packs Table
CREATE TABLE IF NOT EXISTS public.tb_content_packs
(
    id SERIAL PRIMARY KEY,
    pack_name character varying(255) NOT NULL,
    version character varying(255) NOT NULL,
    db_type character varying(255) NOT NULL,
    build_date character varying(255),
    build_version character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    author character varying(255),
    icon character varying(255),
    background_traffic character varying(255),
    pack_info jsonb,
    pack_deployed character varying(5) DEFAULT 'false',
    uploaded_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_pack_version UNIQUE (pack_name, version)
);
COMMENT ON TABLE public.tb_content_packs IS 'Stores content pack metadata for database scenarios';

-- Database Connections Table
CREATE TABLE IF NOT EXISTS public.tb_databaseconnections
(
    id serial NOT NULL,
    db_connection_id character varying(100) NOT NULL UNIQUE,
    status character varying(100),
    db_type character varying(100) NOT NULL,
    db_version character varying(100),
    db_username character varying(100) NOT NULL,
    db_password character varying(100) NOT NULL,
    db_port character varying(100),
    db_database character varying(100) NOT NULL,
    db_url character varying(100) NOT NULL,
    db_jdbcClassName character varying(100),
    db_userIcon character varying(100),
    db_databaseIcon character varying(100),
    db_alias character varying(500),
    db_access character varying(500),
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.tb_databaseconnections IS 'Stores database connection configurations';
ALTER SEQUENCE tb_databaseconnections_id_seq RESTART WITH 5000;

-- Admin Functions Table
CREATE TABLE IF NOT EXISTS public.tb_admin_functions
(
    id SERIAL PRIMARY KEY,
    function_name character varying(255) NOT NULL,
    function_description character varying(255) NOT NULL,
    function_script character varying(50) NOT NULL,
    function_api_call character varying(50) NOT NULL,
    function_file_path text NOT NULL,
    function_os_type character varying(255) NOT NULL,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    task_active character varying (20) DEFAULT 'Active'
);
COMMENT ON TABLE public.tb_admin_functions IS 'Stores administrative functions and scripts';

-- Query Table
CREATE TABLE IF NOT EXISTS public.tb_query
(
    id serial NOT NULL,
    fk_tb_databaseConnections_id INT,
    query_db_type character varying(100),
    query_string TEXT NOT NULL, 
    query_usecase character varying(100),
    query_type character varying(100),
    query_description character varying(500),
    video_link character varying(500),
    query_loop INT,
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.tb_query IS 'Stores prepared SQL queries for stories';
ALTER SEQUENCE tb_query_id_seq RESTART WITH 5000;

-- Query Types Table
CREATE TABLE IF NOT EXISTS public.tb_query_types
(
    id serial NOT NULL,
    query_type character varying(100),
    PRIMARY KEY (id)
);
COMMENT ON TABLE public.tb_query_types IS 'Stores query type categories';
ALTER SEQUENCE tb_query_types_id_seq RESTART WITH 5000;

DO $$
BEGIN
    RAISE NOTICE '✓ Core tables created successfully';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 3: CREATE OUTLIERS AND ATTACK LIBRARY TABLES
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 3: Creating Outliers and Attack Library tables...';
END $$;

-- Outlier Scripts Table
CREATE TABLE IF NOT EXISTS public.tb_outlier_scripts
(
    id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    script_type VARCHAR(50) NOT NULL,
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
    related_files JSONB,
    tags JSONB,
    package_id VARCHAR(100),
    package_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE public.tb_outlier_scripts IS 'Stores metadata for uploaded outlier scripts that can be scheduled';
COMMENT ON COLUMN public.tb_outlier_scripts.script_type IS 'Type of script: bash (.sh) or windows (.bat, .cmd, .ps1)';
COMMENT ON COLUMN public.tb_outlier_scripts.related_files IS 'JSONB array of related file names (SQL, README, etc.)';

-- Outlier Schedules Table
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
COMMENT ON TABLE public.tb_outlier_schedules IS 'Stores multiple schedules for each outlier script';
COMMENT ON COLUMN public.tb_outlier_schedules.cron_expression IS 'Cron expression for scheduling (e.g., "0 0 * * *")';

-- Attack Patterns Table
CREATE TABLE IF NOT EXISTS public.tb_attack_patterns
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
COMMENT ON TABLE public.tb_attack_patterns IS 'Stores pre-built attack pattern templates for the attack library';
COMMENT ON COLUMN public.tb_attack_patterns.target_databases IS 'JSONB array of compatible database types';
COMMENT ON COLUMN public.tb_attack_patterns.example_queries IS 'JSONB array of example attack queries';

-- Create Indexes
CREATE INDEX IF NOT EXISTS idx_outlier_schedules_script_id ON public.tb_outlier_schedules(script_id);
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_enabled ON public.tb_outlier_scripts(enabled);
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_type ON public.tb_outlier_scripts(script_type);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_category ON public.tb_attack_patterns(category);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_severity ON public.tb_attack_patterns(severity);
CREATE INDEX IF NOT EXISTS idx_attack_patterns_type ON public.tb_attack_patterns(attack_type);

DO $$
BEGIN
    RAISE NOTICE '✓ Outliers and Attack Library tables created successfully';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 4: CREATE STORED PROCEDURES AND FUNCTIONS
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 4: Creating stored procedures and functions...';
END $$;

-- Login Function
CREATE FUNCTION function_login(var_username TEXT, var_password TEXT)
RETURNS TABLE (
    id integer,
    firstname varchar,
    surname varchar,
    email varchar,
    username varchar,
    active varchar,
    authlevel integer
)
AS $$ 
BEGIN
    RAISE NOTICE 'Username: % Password: %', var_username, var_password;
    
    RETURN QUERY 
    SELECT
        tb_user.id,
        tb_user.firstname,
        tb_user.surname,
        tb_user.email,
        tb_user.username,
        tb_user.active,
        tb_user.authlevel
    FROM tb_user
    WHERE tb_user.username = var_username AND tb_user.password = var_password;
END
$$ LANGUAGE plpgsql;
COMMENT ON FUNCTION function_login IS 'Authenticates user and returns user details';

-- Update Timestamp Function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';
COMMENT ON FUNCTION update_updated_at_column IS 'Automatically updates updated_at timestamp on row modification';

DO $$
BEGIN
    RAISE NOTICE '✓ Stored procedures and functions created successfully';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 5: CREATE TRIGGERS
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 5: Creating triggers...';
END $$;

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

DO $$
BEGIN
    RAISE NOTICE '✓ Triggers created successfully';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 6: CREATE VIEWS
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 6: Creating views...';
END $$;

-- View: Outlier Scripts with Schedules
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
COMMENT ON VIEW v_outlier_scripts_with_schedules IS 'Provides outlier scripts with their associated schedules';

-- View: Attack Patterns by Category
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
COMMENT ON VIEW v_attack_patterns_by_category IS 'Groups attack patterns by category with counts';

DO $$
BEGIN
    RAISE NOTICE '✓ Views created successfully';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 7: INSERT INITIAL DATA - Query Types
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 7: Inserting initial data - Query Types...';
END $$;

INSERT INTO public.tb_query_types(id,query_type) VALUES (1,'Select');
INSERT INTO public.tb_query_types(id,query_type) VALUES (2,'Update');
INSERT INTO public.tb_query_types(id,query_type) VALUES (3,'Delete'); 
INSERT INTO public.tb_query_types(id,query_type) VALUES (4,'Insert');
INSERT INTO public.tb_query_types(id,query_type) VALUES (5,'Drop'); 
INSERT INTO public.tb_query_types(id,query_type) VALUES (6,'Outlier');
INSERT INTO public.tb_query_types(id,query_type) VALUES (7,'Malicious Procedure');
INSERT INTO public.tb_query_types(id,query_type) VALUES (8,'Policy Violation');
INSERT INTO public.tb_query_types(id,query_type) VALUES (9,'Eagle Eye');
INSERT INTO public.tb_query_types(id,query_type) VALUES (10,'Setup');
INSERT INTO public.tb_query_types(id,query_type) VALUES (11,'New Grants');
INSERT INTO public.tb_query_types(id,query_type) VALUES (12,'Brute-force Attack');
INSERT INTO public.tb_query_types(id,query_type) VALUES (13,'SQL Injection');
INSERT INTO public.tb_query_types(id,query_type) VALUES (14,'DDL');
INSERT INTO public.tb_query_types(id,query_type) VALUES (15,'DML');
INSERT INTO public.tb_query_types(id,query_type) VALUES (16,'DQL');
INSERT INTO public.tb_query_types(id,query_type) VALUES (17,'DCL');
INSERT INTO public.tb_query_types(id,query_type) VALUES (18,'Massive Grants');

DO $$
BEGIN
    RAISE NOTICE '✓ Query types inserted: 18 types';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 8: INSERT INITIAL DATA - Content Packs
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 8: Inserting initial data - Content Packs...';
END $$;

-- Base Content Packs
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed) VALUES 
(1, 'mysql8.0', 'v1.0', 'mysql', '08-Jul-2025', '139', 'MySQL 8.0 base content pack with CRM schema and sample queries', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "mysql8.0", "build_date": "08-Jul-2025", "description": "MySQL 8.0 base content pack", "build_version": "139", "background_traffic": "yes"}', 'false'),
(2, 'db2', 'v1.0', 'db2', '08-Jul-2025', '139', 'IBM DB2 base content pack with CRM schema and sample queries', 'Official', 'my2sql.png', 'yes', '{"icon": "my2sql.png", "author": "Official", "db_type": "db2", "version": "v1.0", "pack_name": "db2", "build_date": "08-Jul-2025", "description": "IBM DB2 base content pack", "build_version": "139", "background_traffic": "yes"}', 'false'),
(3, 'oracle', 'v1.0', 'oracle', '08-Jul-2025', '139', 'Oracle Database base content pack with CRM schema and sample queries', 'Official', 'oracle.png', 'yes', '{"icon": "oracle.png", "author": "Official", "db_type": "oracle", "version": "v1.0", "pack_name": "oracle", "build_date": "08-Jul-2025", "description": "Oracle Database base content pack", "build_version": "139", "background_traffic": "yes"}', 'false'),
(4, 'postgres', 'v1.0', 'postgres', '08-Jul-2025', '139', 'PostgreSQL base content pack with CRM schema and sample queries', 'Official', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Official", "db_type": "postgres", "version": "v1.0", "pack_name": "postgres", "build_date": "08-Jul-2025", "description": "PostgreSQL base content pack", "build_version": "139", "background_traffic": "yes"}', 'false'),
(5, 'sqlserver', 'v1.0', 'sqlserver', '01-Sept-2025', '139', 'Microsoft SQL Server base content pack with CRM schema and sample queries', 'Official', 'sqlserver.png', 'yes', '{"icon": "sqlserver.png", "author": "Official", "db_type": "sqlserver", "version": "v1.0", "pack_name": "sqlserver", "build_date": "01-Sept-2025", "description": "SQL Server base content pack", "build_version": "139", "background_traffic": "yes"}', 'false');

-- MySQL Outlier Content Packs
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES 
(6, 'outlier_schema_tampering', 'v1.0', 'mysql', '11-Feb-2026', '139', 'Detects unauthorized schema modifications through DDL anomalies', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_schema_tampering", "build_date": "10-Feb-2026", "description": "Schema tampering detection", "build_version": "139", "background_traffic": "yes"}', 'false', '2026-02-11 12:53:50.323099'),
(7, 'outlier_data_tampering', 'v1.0', 'mysql', '11-Feb-2026', '140', 'Detects data tampering through DELETE anomalies. Simulates 4 hours baseline (50 DELETEs/hour) followed by massive spike (1000 DELETEs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_data_tampering", "build_date": "11-Feb-2026", "description": "Data tampering detection", "build_version": "140", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(8, 'outlier_update_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '141', 'Detects UPDATE anomalies indicating data manipulation attacks. Simulates 4 hours baseline (50 UPDATEs/hour) followed by massive spike (1000 UPDATEs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_update_anomaly", "build_date": "11-Feb-2026", "description": "UPDATE anomaly detection", "build_version": "141", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(9, 'outlier_insert_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '142', 'Detects INSERT anomalies indicating data injection attacks. Simulates 4 hours baseline (50 INSERTs/hour) followed by massive spike (1000 INSERTs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_insert_anomaly", "build_date": "11-Feb-2026", "description": "INSERT anomaly detection", "build_version": "142", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(10, 'outlier_revoke_anomaly', 'v1.0', 'mysql', '11-Feb-2026', '143', 'Detects REVOKE anomalies indicating privilege removal attacks. Simulates 4 hours baseline (50 REVOKEs/hour) followed by massive spike (1000 REVOKEs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_revoke_anomaly", "build_date": "11-Feb-2026", "description": "REVOKE anomaly detection", "build_version": "143", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(11, 'outlier_massive_grant_case', 'v1.0', 'mysql', '11-Feb-2026', '144', 'Detects massive GRANT anomalies indicating privilege escalation attacks. Simulates 4 hours baseline (1 GRANT/hour) followed by spike (21 simultaneous GRANTs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_massive_grant_case", "build_date": "11-Feb-2026", "description": "Massive GRANT detection", "build_version": "144", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(12, 'outlier_data_leak_command', 'v1.0', 'mysql', '11-Feb-2026', '145', 'Detects data exfiltration through SELECT anomalies. Simulates 4 hours baseline (50 SELECTs/hour) followed by massive spike (1000 SELECTs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_data_leak_command", "build_date": "11-Feb-2026", "description": "Data leak detection", "build_version": "145", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(13, 'outlier_account_take_over', 'v1.0', 'mysql', '11-Feb-2026', '146', 'Detects account takeover through object access pattern changes. Simulates 4 hours accessing 1 object (50 SELECTs/hour) followed by sudden access to all 5 objects (250 SELECTs)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_account_take_over", "build_date": "11-Feb-2026", "description": "Account takeover detection", "build_version": "146", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908'),
(14, 'outlier_denial_of_service', 'v1.0', 'mysql', '11-Feb-2026', '147', 'Detects Denial of Service attacks through query volume anomalies. Simulates 4 hours baseline (1001 queries/hour) followed by massive spike (205000 queries)', 'Official', 'mysql.png', 'yes', '{"icon": "mysql.png", "author": "Official", "db_type": "mysql", "version": "v1.0", "pack_name": "outlier_denial_of_service", "build_date": "11-Feb-2026", "description": "DoS detection", "build_version": "147", "background_traffic": "yes"}', 'false', '2026-02-11 15:58:29.638908');

-- PostgreSQL Outlier Content Packs
INSERT INTO public.tb_content_packs (id, pack_name, version, db_type, build_date, build_version, description, author, icon, background_traffic, pack_info, pack_deployed, uploaded_date) VALUES 
(15, 'outlier_account_take_over_postgres', 'v1.0', 'postgres', '23-Feb-2026', '150', 'PostgreSQL Account Takeover Detection - Simulates normal access pattern followed by sudden access to all objects', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_account_take_over_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Account Takeover Detection", "build_version": "150", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(16, 'outlier_data_leak_command_postgres', 'v1.0', 'postgres', '23-Feb-2026', '151', 'PostgreSQL Data Leak Detection - Detects data exfiltration through SELECT anomalies', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_data_leak_command_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Data Leak Detection", "build_version": "151", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(17, 'outlier_data_tampering_postgres', 'v1.0', 'postgres', '23-Feb-2026', '152', 'PostgreSQL Data Tampering Detection - Detects data tampering through DELETE anomalies', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_data_tampering_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Data Tampering Detection", "build_version": "152", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(18, 'outlier_denial_of_service_postgres', 'v1.0', 'postgres', '23-Feb-2026', '153', 'PostgreSQL Denial of Service Detection - Detects DoS attacks through query volume anomalies', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_denial_of_service_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL DoS Detection", "build_version": "153", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(19, 'outlier_insert_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '154', 'PostgreSQL Insert Anomaly Detection - Detects INSERT anomalies indicating data injection attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_insert_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Insert Anomaly Detection", "build_version": "154", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(20, 'outlier_massive_grant_case_postgres', 'v1.0', 'postgres', '23-Feb-2026', '155', 'PostgreSQL Massive Grant Detection - Detects massive GRANT anomalies indicating privilege escalation attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_massive_grant_case_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Massive Grant Detection", "build_version": "155", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(21, 'outlier_revoke_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '156', 'PostgreSQL Revoke Anomaly Detection - Detects REVOKE anomalies indicating privilege removal attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_revoke_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Revoke Anomaly Detection", "build_version": "156", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(22, 'outlier_schema_tampering_postgres', 'v1.0', 'postgres', '23-Feb-2026', '157', 'PostgreSQL Schema Tampering Detection - Detects unauthorized schema modifications through DDL anomalies', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_schema_tampering_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Schema Tampering Detection", "build_version": "157", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP),
(23, 'outlier_update_anomaly_postgres', 'v1.0', 'postgres', '23-Feb-2026', '158', 'PostgreSQL Update Anomaly Detection - Detects UPDATE anomalies indicating data manipulation attacks', 'Security Team', 'postgres.png', 'yes', '{"icon": "postgres.png", "author": "Security Team", "db_type": "postgres", "version": "v1.0", "pack_name": "outlier_update_anomaly_postgres", "build_date": "23-Feb-2026", "description": "PostgreSQL Update Anomaly Detection", "build_version": "158", "background_traffic": "yes"}', 'false', CURRENT_TIMESTAMP);

ALTER SEQUENCE public.tb_content_packs_id_seq RESTART WITH 24;

DO $$
BEGIN
    RAISE NOTICE '✓ Content packs inserted: 23 packs (5 base + 9 MySQL outliers + 9 PostgreSQL outliers)';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 9: INSERT INITIAL DATA - Admin Functions
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 9: Inserting initial data - Admin Functions...';
END $$;

INSERT INTO public.tb_admin_functions (id,function_name,function_description,function_script,function_api_call,function_file_path,function_os_type) 
VALUES (1,'Restart SLP system','This function call will restart the SLP application. This should only be utilised in cases of emergency where the application hangs.','restartSLP.sh','getRestartSLP()','/opt/slp/scripts','Linux');

ALTER SEQUENCE tb_admin_functions_id_seq RESTART WITH 2;

DO $$
BEGIN
    RAISE NOTICE '✓ Admin functions inserted: 1 function';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 10: INSERT INITIAL DATA - Sample Attack Pattern
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 10: Inserting initial data - Sample Attack Pattern...';
END $$;

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

DO $$
BEGIN
    RAISE NOTICE '✓ Sample attack pattern inserted: 1 pattern';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 11: DATABASE CONFIGURATION
-- ============================================================================================================

DO $$
BEGIN
    RAISE NOTICE 'SECTION 11: Applying database configuration...';
END $$;

-- Set idle transaction timeout
ALTER DATABASE slp SET idle_in_transaction_session_timeout = '1min';

DO $$
BEGIN
    RAISE NOTICE '✓ Database configuration applied';
    RAISE NOTICE '';
END $$;

-- ============================================================================================================
-- SECTION 12: VERIFICATION AND SUMMARY
-- ============================================================================================================

DO $$
DECLARE
    v_table_count INTEGER;
    v_function_count INTEGER;
    v_trigger_count INTEGER;
    v_view_count INTEGER;
    v_user_count INTEGER;
    v_content_pack_count INTEGER;
    v_query_type_count INTEGER;
    v_attack_pattern_count INTEGER;
BEGIN
    RAISE NOTICE 'SECTION 12: Verification and Summary...';
    RAISE NOTICE '';
    
    -- Count objects
    SELECT COUNT(*) INTO v_table_count FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE';
    SELECT COUNT(*) INTO v_function_count FROM pg_proc WHERE pronamespace = 'public'::regnamespace;
    SELECT COUNT(*) INTO v_trigger_count FROM information_schema.triggers WHERE trigger_schema = 'public';
    SELECT COUNT(*) INTO v_view_count FROM information_schema.views WHERE table_schema = 'public';
    SELECT COUNT(*) INTO v_user_count FROM public.tb_user;
    SELECT COUNT(*) INTO v_content_pack_count FROM public.tb_content_packs;
    SELECT COUNT(*) INTO v_query_type_count FROM public.tb_query_types;
    SELECT COUNT(*) INTO v_attack_pattern_count FROM public.tb_attack_patterns;
    
    RAISE NOTICE '============================================================================================================';
    RAISE NOTICE 'DEPLOYMENT SUMMARY';
    RAISE NOTICE '============================================================================================================';
    RAISE NOTICE 'Tables Created:          %', v_table_count;
    RAISE NOTICE 'Functions Created:       %', v_function_count;
    RAISE NOTICE 'Triggers Created:        %', v_trigger_count;
    RAISE NOTICE 'Views Created:           %', v_view_count;
    RAISE NOTICE '';
    RAISE NOTICE 'Initial Data Inserted:';
    RAISE NOTICE '  - Users:               %', v_user_count;
    RAISE NOTICE '  - Content Packs:       %', v_content_pack_count;
    RAISE NOTICE '  - Query Types:         %', v_query_type_count;
    RAISE NOTICE '  - Attack Patterns:     %', v_attack_pattern_count;
    RAISE NOTICE '';
    RAISE NOTICE 'Default Admin Credentials:';
    RAISE NOTICE '  - Username:            admin';
    RAISE NOTICE '  - Password:            admin';
    RAISE NOTICE '';
    RAISE NOTICE 'Application Version:     v01.0012';
    RAISE NOTICE 'Deployment completed at: %', NOW();
    RAISE NOTICE '============================================================================================================';
    RAISE NOTICE '';
    RAISE NOTICE '✓ DEPLOYMENT SUCCESSFUL!';
    RAISE NOTICE '';
    RAISE NOTICE 'Next Steps:';
    RAISE NOTICE '1. Change the default admin password immediately';
    RAISE NOTICE '2. Configure database connections in tb_databaseconnections table';
    RAISE NOTICE '3. Deploy content packs as needed';
    RAISE NOTICE '4. Review and customize attack patterns';
    RAISE NOTICE '5. Start the SLP application';
    RAISE NOTICE '';
END $$;

-- Commit transaction
COMMIT;

-- End of Master Deployment Script
