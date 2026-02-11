-- PQC Unified Platform Database Schema
-- PostgreSQL 12+

-- Create database
-- CREATE DATABASE pqc_unified;
-- \c pqc_unified;

-- ============================================================================
-- DOMAIN SCANNER TABLES
-- ============================================================================

-- Scan results table
CREATE TABLE IF NOT EXISTS scan_results (
    id SERIAL PRIMARY KEY,
    domain VARCHAR(255) NOT NULL,
    host VARCHAR(255) NOT NULL,
    port INTEGER NOT NULL DEFAULT 443,
    is_pqc BOOLEAN DEFAULT FALSE,
    pqc_algorithm VARCHAR(100),
    cipher_suite VARCHAR(255),
    protocol VARCHAR(50),
    risk_score INTEGER DEFAULT 0,
    risk_level VARCHAR(20) DEFAULT 'UNKNOWN',
    scan_data JSONB,
    status VARCHAR(50) DEFAULT 'success',
    error_message TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for scan results
CREATE INDEX IF NOT EXISTS idx_scan_domain ON scan_results(domain);
CREATE INDEX IF NOT EXISTS idx_scan_created ON scan_results(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_scan_pqc ON scan_results(is_pqc);
CREATE INDEX IF NOT EXISTS idx_scan_risk ON scan_results(risk_level);

-- ============================================================================
-- FILE ENCRYPTOR TABLES
-- ============================================================================

-- Encrypted files metadata
CREATE TABLE IF NOT EXISTS encrypted_files (
    id SERIAL PRIMARY KEY,
    original_filename VARCHAR(255) NOT NULL,
    encrypted_filename VARCHAR(255) NOT NULL UNIQUE,
    file_size BIGINT NOT NULL,
    encrypted_size BIGINT NOT NULL,
    encryption_algorithm VARCHAR(100) DEFAULT 'ML-KEM-768 + AES-256-GCM',
    public_key TEXT,
    encapsulated_key TEXT,
    iv TEXT,
    file_path VARCHAR(500),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    accessed_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for encrypted files
CREATE INDEX IF NOT EXISTS idx_file_original ON encrypted_files(original_filename);
CREATE INDEX IF NOT EXISTS idx_file_encrypted ON encrypted_files(encrypted_filename);
CREATE INDEX IF NOT EXISTS idx_file_created ON encrypted_files(created_at DESC);

-- ============================================================================
-- SECURE MESSAGING TABLES
-- ============================================================================

-- Chat sessions
CREATE TABLE IF NOT EXISTS chat_sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL UNIQUE,
    user_count INTEGER DEFAULT 0,
    key_exchange_complete BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    last_activity TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP,
    metadata JSONB
);

-- Chat users
CREATE TABLE IF NOT EXISTS chat_users (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL,
    public_key TEXT,
    joined_at TIMESTAMP DEFAULT NOW(),
    last_seen TIMESTAMP DEFAULT NOW(),
    UNIQUE(session_id, username),
    FOREIGN KEY (session_id) REFERENCES chat_sessions(session_id) ON DELETE CASCADE
);

-- Chat messages
CREATE TABLE IF NOT EXISTS chat_messages (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL,
    username VARCHAR(100) NOT NULL,
    message_text TEXT NOT NULL,
    encrypted_text TEXT NOT NULL,
    iv TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (session_id) REFERENCES chat_sessions(session_id) ON DELETE CASCADE
);

-- Indexes for chat
CREATE INDEX IF NOT EXISTS idx_session_id ON chat_sessions(session_id);
CREATE INDEX IF NOT EXISTS idx_session_activity ON chat_sessions(last_activity DESC);
CREATE INDEX IF NOT EXISTS idx_user_session ON chat_users(session_id);
CREATE INDEX IF NOT EXISTS idx_message_session ON chat_messages(session_id);
CREATE INDEX IF NOT EXISTS idx_message_created ON chat_messages(created_at DESC);

-- ============================================================================
-- AUDIT LOG TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS audit_log (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    event_category VARCHAR(50) NOT NULL, -- 'scanner', 'file', 'chat'
    user_identifier VARCHAR(255),
    event_data JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for audit log
CREATE INDEX IF NOT EXISTS idx_audit_type ON audit_log(event_type);
CREATE INDEX IF NOT EXISTS idx_audit_category ON audit_log(event_category);
CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_log(created_at DESC);

-- ============================================================================
-- STATISTICS VIEW
-- ============================================================================

CREATE OR REPLACE VIEW platform_statistics AS
SELECT
    (SELECT COUNT(*) FROM scan_results) as total_scans,
    (SELECT COUNT(*) FROM scan_results WHERE is_pqc = true) as pqc_enabled_scans,
    (SELECT COUNT(*) FROM scan_results WHERE risk_level = 'HIGH') as high_risk_scans,
    (SELECT COUNT(*) FROM encrypted_files) as total_encrypted_files,
    (SELECT COALESCE(SUM(file_size), 0) FROM encrypted_files) as total_file_size,
    (SELECT COUNT(*) FROM chat_sessions) as total_chat_sessions,
    (SELECT COUNT(*) FROM chat_messages) as total_messages,
    (SELECT COUNT(DISTINCT username) FROM chat_users) as unique_users;

-- ============================================================================
-- CLEANUP FUNCTIONS
-- ============================================================================

-- Function to clean up old scan results (older than 30 days)
CREATE OR REPLACE FUNCTION cleanup_old_scans()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM scan_results
    WHERE created_at < NOW() - INTERVAL '30 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to clean up expired chat sessions
CREATE OR REPLACE FUNCTION cleanup_expired_sessions()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM chat_sessions
    WHERE expires_at IS NOT NULL AND expires_at < NOW();
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to update session activity
CREATE OR REPLACE FUNCTION update_session_activity()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE chat_sessions
    SET last_activity = NOW()
    WHERE session_id = NEW.session_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update session activity on new message
CREATE TRIGGER trigger_update_session_activity
AFTER INSERT ON chat_messages
FOR EACH ROW
EXECUTE FUNCTION update_session_activity();

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================

-- Uncomment to insert sample data
/*
INSERT INTO scan_results (domain, host, port, is_pqc, pqc_algorithm, cipher_suite, protocol, risk_score, risk_level)
VALUES 
    ('example.com', 'example.com', 443, false, 'none', 'TLS_AES_256_GCM_SHA384', 'TLSv1.3', 50, 'MEDIUM'),
    ('quantum-safe.example', 'quantum-safe.example', 443, true, 'dilithium3', 'TLS_AES_256_GCM_SHA384', 'TLSv1.3', 10, 'LOW');
*/

-- ============================================================================
-- GRANTS (Adjust as needed)
-- ============================================================================

-- Grant permissions to application user
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO pqc_app_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO pqc_app_user;

-- ============================================================================
-- MAINTENANCE QUERIES
-- ============================================================================

-- View platform statistics
-- SELECT * FROM platform_statistics;

-- Clean up old data
-- SELECT cleanup_old_scans();
-- SELECT cleanup_expired_sessions();

-- View recent activity
-- SELECT event_type, event_category, COUNT(*) as count
-- FROM audit_log
-- WHERE created_at > NOW() - INTERVAL '24 hours'
-- GROUP BY event_type, event_category
-- ORDER BY count DESC;

-- Made with Bob