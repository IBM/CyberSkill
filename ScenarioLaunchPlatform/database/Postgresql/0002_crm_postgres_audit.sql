-- ============================================
-- PostgreSQL Audit Policy for CRM Database
-- File: 0002_crm_postgres_audit.sql
-- Purpose: Comprehensive audit logging for all CRM tables
-- Tables Audited: tbl_crm_accounts, tbl_product, tbl_calls, tbl_bugs, tbl_email_lists
-- Operations Logged: INSERT, UPDATE, DELETE (SELECT via postgresql.conf)
-- ============================================

-- ============================================
-- STEP 1: Create Audit Log Table
-- ============================================
DROP TABLE IF EXISTS public.audit_log CASCADE;

CREATE TABLE public.audit_log (
    audit_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    user_name VARCHAR(100) DEFAULT CURRENT_USER,
    client_addr INET DEFAULT inet_client_addr(),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_data JSONB,
    new_data JSONB,
    query TEXT,
    application_name VARCHAR(100) DEFAULT current_setting('application_name', true)
);

-- Add comment to table
COMMENT ON TABLE public.audit_log IS 'Audit log table for tracking all DML operations on CRM tables';
COMMENT ON COLUMN public.audit_log.audit_id IS 'Unique identifier for each audit entry';
COMMENT ON COLUMN public.audit_log.table_name IS 'Name of the table where the operation occurred';
COMMENT ON COLUMN public.audit_log.operation IS 'Type of operation: INSERT, UPDATE, or DELETE';
COMMENT ON COLUMN public.audit_log.user_name IS 'Database user who performed the operation';
COMMENT ON COLUMN public.audit_log.client_addr IS 'IP address of the client connection';
COMMENT ON COLUMN public.audit_log.timestamp IS 'Timestamp when the operation occurred';
COMMENT ON COLUMN public.audit_log.old_data IS 'JSON representation of the row before the operation (UPDATE/DELETE)';
COMMENT ON COLUMN public.audit_log.new_data IS 'JSON representation of the row after the operation (INSERT/UPDATE)';
COMMENT ON COLUMN public.audit_log.query IS 'The SQL query that was executed';
COMMENT ON COLUMN public.audit_log.application_name IS 'Name of the application that performed the operation';

-- ============================================
-- STEP 2: Create Indexes for Performance
-- ============================================
CREATE INDEX idx_audit_log_table_name ON public.audit_log(table_name);
CREATE INDEX idx_audit_log_timestamp ON public.audit_log(timestamp DESC);
CREATE INDEX idx_audit_log_user_name ON public.audit_log(user_name);
CREATE INDEX idx_audit_log_operation ON public.audit_log(operation);
CREATE INDEX idx_audit_log_table_operation ON public.audit_log(table_name, operation);

-- GIN index for JSONB data for faster searches
CREATE INDEX idx_audit_log_old_data ON public.audit_log USING GIN (old_data);
CREATE INDEX idx_audit_log_new_data ON public.audit_log USING GIN (new_data);

-- ============================================
-- STEP 3: Create Audit Trigger Function
-- ============================================
CREATE OR REPLACE FUNCTION public.audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO public.audit_log (table_name, operation, old_data, query)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), current_query());
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO public.audit_log (table_name, operation, old_data, new_data, query)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), current_query());
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO public.audit_log (table_name, operation, new_data, query)
        VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), current_query());
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.audit_trigger_function() IS 'Trigger function to log INSERT, UPDATE, and DELETE operations to audit_log table';

-- ============================================
-- STEP 4: Apply Audit Triggers to tbl_crm_accounts
-- ============================================
DROP TRIGGER IF EXISTS audit_crm_accounts_insert ON public.tbl_crm_accounts;
CREATE TRIGGER audit_crm_accounts_insert
    AFTER INSERT ON public.tbl_crm_accounts
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_crm_accounts_update ON public.tbl_crm_accounts;
CREATE TRIGGER audit_crm_accounts_update
    AFTER UPDATE ON public.tbl_crm_accounts
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_crm_accounts_delete ON public.tbl_crm_accounts;
CREATE TRIGGER audit_crm_accounts_delete
    AFTER DELETE ON public.tbl_crm_accounts
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 5: Apply Audit Triggers to tbl_product
-- ============================================
DROP TRIGGER IF EXISTS audit_product_insert ON public.tbl_product;
CREATE TRIGGER audit_product_insert
    AFTER INSERT ON public.tbl_product
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_product_update ON public.tbl_product;
CREATE TRIGGER audit_product_update
    AFTER UPDATE ON public.tbl_product
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_product_delete ON public.tbl_product;
CREATE TRIGGER audit_product_delete
    AFTER DELETE ON public.tbl_product
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 6: Apply Audit Triggers to tbl_calls
-- ============================================
DROP TRIGGER IF EXISTS audit_calls_insert ON public.tbl_calls;
CREATE TRIGGER audit_calls_insert
    AFTER INSERT ON public.tbl_calls
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_calls_update ON public.tbl_calls;
CREATE TRIGGER audit_calls_update
    AFTER UPDATE ON public.tbl_calls
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_calls_delete ON public.tbl_calls;
CREATE TRIGGER audit_calls_delete
    AFTER DELETE ON public.tbl_calls
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 7: Apply Audit Triggers to tbl_bugs
-- ============================================
DROP TRIGGER IF EXISTS audit_bugs_insert ON public.tbl_bugs;
CREATE TRIGGER audit_bugs_insert
    AFTER INSERT ON public.tbl_bugs
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_bugs_update ON public.tbl_bugs;
CREATE TRIGGER audit_bugs_update
    AFTER UPDATE ON public.tbl_bugs
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_bugs_delete ON public.tbl_bugs;
CREATE TRIGGER audit_bugs_delete
    AFTER DELETE ON public.tbl_bugs
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 8: Apply Audit Triggers to tbl_email_lists
-- ============================================
DROP TRIGGER IF EXISTS audit_email_lists_insert ON public.tbl_email_lists;
CREATE TRIGGER audit_email_lists_insert
    AFTER INSERT ON public.tbl_email_lists
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_email_lists_update ON public.tbl_email_lists;
CREATE TRIGGER audit_email_lists_update
    AFTER UPDATE ON public.tbl_email_lists
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_email_lists_delete ON public.tbl_email_lists;
CREATE TRIGGER audit_email_lists_delete
    AFTER DELETE ON public.tbl_email_lists
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 9: Apply Audit Triggers to tbl_marketing_template
-- ============================================
DROP TRIGGER IF EXISTS audit_marketing_template_insert ON public.tbl_marketing_template;
CREATE TRIGGER audit_marketing_template_insert
    AFTER INSERT ON public.tbl_marketing_template
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_marketing_template_update ON public.tbl_marketing_template;
CREATE TRIGGER audit_marketing_template_update
    AFTER UPDATE ON public.tbl_marketing_template
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_marketing_template_delete ON public.tbl_marketing_template;
CREATE TRIGGER audit_marketing_template_delete
    AFTER DELETE ON public.tbl_marketing_template
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 10: Apply Audit Triggers to tbl_marketing_campaign
-- ============================================
DROP TRIGGER IF EXISTS audit_marketing_campaign_insert ON public.tbl_marketing_campaign;
CREATE TRIGGER audit_marketing_campaign_insert
    AFTER INSERT ON public.tbl_marketing_campaign
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_marketing_campaign_update ON public.tbl_marketing_campaign;
CREATE TRIGGER audit_marketing_campaign_update
    AFTER UPDATE ON public.tbl_marketing_campaign
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_marketing_campaign_delete ON public.tbl_marketing_campaign;
CREATE TRIGGER audit_marketing_campaign_delete
    AFTER DELETE ON public.tbl_marketing_campaign
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 11: Apply Audit Triggers to tbl_crm_accounts_status
-- ============================================
DROP TRIGGER IF EXISTS audit_crm_accounts_status_insert ON public.tbl_crm_accounts_status;
CREATE TRIGGER audit_crm_accounts_status_insert
    AFTER INSERT ON public.tbl_crm_accounts_status
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_crm_accounts_status_update ON public.tbl_crm_accounts_status;
CREATE TRIGGER audit_crm_accounts_status_update
    AFTER UPDATE ON public.tbl_crm_accounts_status
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

DROP TRIGGER IF EXISTS audit_crm_accounts_status_delete ON public.tbl_crm_accounts_status;
CREATE TRIGGER audit_crm_accounts_status_delete
    AFTER DELETE ON public.tbl_crm_accounts_status
    FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

-- ============================================
-- STEP 12: Grant Permissions
-- ============================================
-- Grant SELECT on audit_log to regular users
GRANT SELECT ON public.audit_log TO john, jason;

-- Grant ALL on audit_log to superusers
GRANT ALL ON public.audit_log TO polly, liher;

-- Grant sequence usage
GRANT USAGE, SELECT ON SEQUENCE audit_log_audit_id_seq TO john, jason, polly, liher;

-- ============================================
-- STEP 13: Create Helpful Views
-- ============================================

-- View for recent audit activity
CREATE OR REPLACE VIEW public.v_audit_recent AS
SELECT 
    audit_id,
    table_name,
    operation,
    user_name,
    client_addr,
    timestamp,
    application_name
FROM public.audit_log
ORDER BY timestamp DESC
LIMIT 1000;

COMMENT ON VIEW public.v_audit_recent IS 'Shows the 1000 most recent audit log entries';

-- View for audit summary by table
CREATE OR REPLACE VIEW public.v_audit_summary_by_table AS
SELECT 
    table_name,
    operation,
    COUNT(*) as operation_count,
    COUNT(DISTINCT user_name) as unique_users,
    MIN(timestamp) as first_occurrence,
    MAX(timestamp) as last_occurrence
FROM public.audit_log
GROUP BY table_name, operation
ORDER BY table_name, operation;

COMMENT ON VIEW public.v_audit_summary_by_table IS 'Summary of audit operations grouped by table and operation type';

-- View for audit summary by user
CREATE OR REPLACE VIEW public.v_audit_summary_by_user AS
SELECT 
    user_name,
    table_name,
    operation,
    COUNT(*) as operation_count,
    MIN(timestamp) as first_operation,
    MAX(timestamp) as last_operation
FROM public.audit_log
GROUP BY user_name, table_name, operation
ORDER BY user_name, table_name, operation;

COMMENT ON VIEW public.v_audit_summary_by_user IS 'Summary of audit operations grouped by user, table, and operation type';

-- Grant SELECT on views
GRANT SELECT ON public.v_audit_recent TO john, jason, polly, liher;
GRANT SELECT ON public.v_audit_summary_by_table TO john, jason, polly, liher;
GRANT SELECT ON public.v_audit_summary_by_user TO john, jason, polly, liher;

-- ============================================
-- STEP 14: Create Audit Maintenance Function
-- ============================================

-- Function to archive old audit logs
CREATE OR REPLACE FUNCTION public.archive_old_audit_logs(days_to_keep INTEGER DEFAULT 90)
RETURNS TABLE(archived_count BIGINT) AS $$
DECLARE
    deleted_count BIGINT;
BEGIN
    DELETE FROM public.audit_log
    WHERE timestamp < NOW() - (days_to_keep || ' days')::INTERVAL;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    RETURN QUERY SELECT deleted_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION public.archive_old_audit_logs(INTEGER) IS 'Archives (deletes) audit log entries older than specified days (default 90)';

-- ============================================
-- STEP 15: Enable SELECT Query Logging (Optional)
-- ============================================
-- Note: This must be done at the database or server level
-- Uncomment and run as superuser if you want to log SELECT statements:

-- ALTER DATABASE crm SET log_statement = 'all';
-- ALTER DATABASE crm SET log_min_duration_statement = 0;

-- Or for production, log only slow queries:
-- ALTER DATABASE crm SET log_min_duration_statement = 1000;  -- Log queries taking more than 1 second

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Verify all triggers are created
SELECT 
    trigger_name,
    event_object_table,
    action_timing,
    event_manipulation
FROM information_schema.triggers
WHERE trigger_schema = 'public'
AND trigger_name LIKE 'audit_%'
ORDER BY event_object_table, event_manipulation;

-- Test the audit system with a sample operation
-- INSERT INTO tbl_product VALUES (gen_random_uuid()::VARCHAR, 'Test Product', 'Test Description', 9.99, 10);
-- SELECT * FROM public.audit_log ORDER BY timestamp DESC LIMIT 5;

-- ============================================
-- USEFUL AUDIT QUERIES
-- ============================================

-- View all recent audit logs
-- SELECT * FROM public.v_audit_recent;

-- View audit logs for specific table
-- SELECT * FROM public.audit_log 
-- WHERE table_name = 'tbl_crm_accounts' 
-- ORDER BY timestamp DESC LIMIT 100;

-- View audit logs by specific user
-- SELECT * FROM public.audit_log 
-- WHERE user_name = 'john' 
-- ORDER BY timestamp DESC;

-- View changes to a specific record (by ID in JSON)
-- SELECT * FROM public.audit_log 
-- WHERE table_name = 'tbl_crm_accounts' 
-- AND (old_data->>'id' = 'df61978a-f4cc-ff64-8de0-53e90f19a56a' 
--      OR new_data->>'id' = 'df61978a-f4cc-ff64-8de0-53e90f19a56a')
-- ORDER BY timestamp DESC;

-- View summary by table
-- SELECT * FROM public.v_audit_summary_by_table;

-- View summary by user
-- SELECT * FROM public.v_audit_summary_by_user;

-- Find all DELETE operations
-- SELECT * FROM public.audit_log 
-- WHERE operation = 'DELETE' 
-- ORDER BY timestamp DESC;

-- Find operations from specific IP address
-- SELECT * FROM public.audit_log 
-- WHERE client_addr = '192.168.1.100'::INET 
-- ORDER BY timestamp DESC;

-- Archive logs older than 90 days
-- SELECT * FROM public.archive_old_audit_logs(90);

-- ============================================
-- CLEANUP SCRIPT (Use with caution!)
-- ============================================
/*
-- To remove all audit triggers and tables:

DROP TRIGGER IF EXISTS audit_crm_accounts_insert ON public.tbl_crm_accounts;
DROP TRIGGER IF EXISTS audit_crm_accounts_update ON public.tbl_crm_accounts;
DROP TRIGGER IF EXISTS audit_crm_accounts_delete ON public.tbl_crm_accounts;
DROP TRIGGER IF EXISTS audit_product_insert ON public.tbl_product;
DROP TRIGGER IF EXISTS audit_product_update ON public.tbl_product;
DROP TRIGGER IF EXISTS audit_product_delete ON public.tbl_product;
DROP TRIGGER IF EXISTS audit_calls_insert ON public.tbl_calls;
DROP TRIGGER IF EXISTS audit_calls_update ON public.tbl_calls;
DROP TRIGGER IF EXISTS audit_calls_delete ON public.tbl_calls;
DROP TRIGGER IF EXISTS audit_bugs_insert ON public.tbl_bugs;
DROP TRIGGER IF EXISTS audit_bugs_update ON public.tbl_bugs;
DROP TRIGGER IF EXISTS audit_bugs_delete ON public.tbl_bugs;
DROP TRIGGER IF EXISTS audit_email_lists_insert ON public.tbl_email_lists;
DROP TRIGGER IF EXISTS audit_email_lists_update ON public.tbl_email_lists;
DROP TRIGGER IF EXISTS audit_email_lists_delete ON public.tbl_email_lists;
DROP TRIGGER IF EXISTS audit_marketing_template_insert ON public.tbl_marketing_template;
DROP TRIGGER IF EXISTS audit_marketing_template_update ON public.tbl_marketing_template;
DROP TRIGGER IF EXISTS audit_marketing_template_delete ON public.tbl_marketing_template;
DROP TRIGGER IF EXISTS audit_marketing_campaign_insert ON public.tbl_marketing_campaign;
DROP TRIGGER IF EXISTS audit_marketing_campaign_update ON public.tbl_marketing_campaign;
DROP TRIGGER IF EXISTS audit_marketing_campaign_delete ON public.tbl_marketing_campaign;
DROP TRIGGER IF EXISTS audit_crm_accounts_status_insert ON public.tbl_crm_accounts_status;
DROP TRIGGER IF EXISTS audit_crm_accounts_status_update ON public.tbl_crm_accounts_status;
DROP TRIGGER IF EXISTS audit_crm_accounts_status_delete ON public.tbl_crm_accounts_status;

DROP VIEW IF EXISTS public.v_audit_recent;
DROP VIEW IF EXISTS public.v_audit_summary_by_table;
DROP VIEW IF EXISTS public.v_audit_summary_by_user;

DROP FUNCTION IF EXISTS public.archive_old_audit_logs(INTEGER);
DROP FUNCTION IF EXISTS public.audit_trigger_function();
DROP TABLE IF EXISTS public.audit_log CASCADE;
*/

-- ============================================
-- END OF AUDIT SCRIPT
-- ============================================

-- Display success message
DO $$
BEGIN
    RAISE NOTICE '============================================';
    RAISE NOTICE 'PostgreSQL Audit System Successfully Installed!';
    RAISE NOTICE '============================================';
    RAISE NOTICE 'Tables Audited:';
    RAISE NOTICE '  - tbl_crm_accounts';
    RAISE NOTICE '  - tbl_product';
    RAISE NOTICE '  - tbl_calls';
    RAISE NOTICE '  - tbl_bugs';
    RAISE NOTICE '  - tbl_email_lists';
    RAISE NOTICE '  - tbl_marketing_template';
    RAISE NOTICE '  - tbl_marketing_campaign';
    RAISE NOTICE '  - tbl_crm_accounts_status';
    RAISE NOTICE '';
    RAISE NOTICE 'Operations Logged: INSERT, UPDATE, DELETE';
    RAISE NOTICE 'Audit Log Table: public.audit_log';
    RAISE NOTICE '';
    RAISE NOTICE 'Helpful Views Created:';
    RAISE NOTICE '  - v_audit_recent';
    RAISE NOTICE '  - v_audit_summary_by_table';
    RAISE NOTICE '  - v_audit_summary_by_user';
    RAISE NOTICE '';
    RAISE NOTICE 'Run: SELECT * FROM v_audit_recent; to see recent activity';
    RAISE NOTICE '============================================';
END $$;

-- Made with Bob
