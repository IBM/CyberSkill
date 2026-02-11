-- Migration script to add Risk Scoring, Trend Analysis, and Certificate Chain features
-- Run this on existing databases to add new features

-- Drop existing views first (they will be recreated with new columns)
DROP VIEW IF EXISTS dashboard_stats CASCADE;
DROP VIEW IF EXISTS recent_scans CASCADE;

-- Add new columns to scan_results
ALTER TABLE scan_results ADD COLUMN IF NOT EXISTS risk_score INTEGER;
ALTER TABLE scan_results ADD COLUMN IF NOT EXISTS risk_level VARCHAR(20);
ALTER TABLE scan_results ADD COLUMN IF NOT EXISTS chain_has_issues BOOLEAN DEFAULT FALSE;

-- Create certificate_chain table
CREATE TABLE IF NOT EXISTS certificate_chain (
    id SERIAL PRIMARY KEY,
    scan_result_id INTEGER REFERENCES scan_results(id) ON DELETE CASCADE,
    chain_position INTEGER NOT NULL,
    subject VARCHAR(500),
    issuer VARCHAR(500),
    serial_number VARCHAR(100),
    not_before TIMESTAMP,
    not_after TIMESTAMP,
    public_key_algorithm VARCHAR(100),
    public_key_size INTEGER,
    signature_algorithm VARCHAR(100),
    is_root BOOLEAN DEFAULT FALSE,
    is_quantum_safe BOOLEAN DEFAULT FALSE,
    pqc_algorithm_type VARCHAR(100),
    is_valid BOOLEAN DEFAULT TRUE,
    validation_error TEXT
);

-- Add new indexes
CREATE INDEX IF NOT EXISTS idx_cert_chain_scan ON certificate_chain(scan_result_id);
CREATE INDEX IF NOT EXISTS idx_scan_results_risk ON scan_results(risk_level);
CREATE INDEX IF NOT EXISTS idx_scan_results_score ON scan_results(risk_score DESC);

-- Update dashboard_stats view
CREATE OR REPLACE VIEW dashboard_stats AS
SELECT 
    COUNT(DISTINCT d.id) as total_domains,
    COUNT(DISTINCT CASE WHEN sr.is_pqc_ready THEN d.id END) as pqc_ready_domains,
    COUNT(DISTINCT CASE WHEN NOT sr.is_pqc_ready THEN d.id END) as vulnerable_domains,
    AVG(sr.response_time_ms) as avg_response_time,
    COUNT(sr.id) as total_scans,
    AVG(sr.risk_score) as avg_risk_score,
    COUNT(DISTINCT CASE WHEN sr.risk_level = 'CRITICAL' THEN d.id END) as critical_domains,
    COUNT(DISTINCT CASE WHEN sr.risk_level = 'HIGH' THEN d.id END) as high_risk_domains,
    COUNT(DISTINCT CASE WHEN sr.chain_has_issues THEN d.id END) as domains_with_chain_issues
FROM domains d
LEFT JOIN scan_results sr ON d.id = sr.domain_id
WHERE sr.id IN (
    SELECT MAX(id) FROM scan_results GROUP BY domain_id
);

-- Update recent_scans view
CREATE OR REPLACE VIEW recent_scans AS
SELECT 
    d.domain_name,
    sr.scan_date,
    sr.is_pqc_ready,
    sr.supports_tls_13,
    sr.certificate_valid,
    sr.certificate_expiry,
    sr.days_until_vulnerable,
    sr.key_exchange_algorithm,
    sr.signature_algorithm,
    sr.risk_score,
    sr.risk_level,
    sr.chain_has_issues,
    cd.public_key_algorithm,
    cd.public_key_size,
    cd.is_quantum_safe,
    cd.pqc_algorithm_type
FROM domains d
JOIN scan_results sr ON d.id = sr.domain_id
LEFT JOIN certificate_details cd ON sr.id = cd.scan_result_id
ORDER BY sr.scan_date DESC
LIMIT 100;

-- Create scan_trends view
CREATE OR REPLACE VIEW scan_trends AS
SELECT 
    DATE_TRUNC('day', sr.scan_date) as scan_day,
    COUNT(DISTINCT sr.domain_id) as domains_scanned,
    COUNT(DISTINCT CASE WHEN sr.is_pqc_ready THEN sr.domain_id END) as pqc_ready_count,
    AVG(sr.risk_score) as avg_risk_score,
    COUNT(DISTINCT CASE WHEN sr.risk_level = 'CRITICAL' THEN sr.domain_id END) as critical_count,
    COUNT(DISTINCT CASE WHEN sr.risk_level = 'HIGH' THEN sr.domain_id END) as high_risk_count,
    AVG(sr.days_until_vulnerable) as avg_days_until_vulnerable,
    COUNT(DISTINCT CASE WHEN sr.supports_tls_13 THEN sr.domain_id END) as tls13_count
FROM scan_results sr
WHERE sr.scan_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE_TRUNC('day', sr.scan_date)
ORDER BY scan_day DESC;

-- Create risk_distribution view
CREATE OR REPLACE VIEW risk_distribution AS
SELECT 
    sr.risk_level,
    COUNT(DISTINCT sr.domain_id) as domain_count,
    AVG(sr.risk_score) as avg_score,
    MIN(sr.risk_score) as min_score,
    MAX(sr.risk_score) as max_score
FROM scan_results sr
WHERE sr.id IN (
    SELECT MAX(id) FROM scan_results GROUP BY domain_id
)
AND sr.risk_level IS NOT NULL
GROUP BY sr.risk_level
ORDER BY 
    CASE sr.risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
    END;

-- Made with Bob