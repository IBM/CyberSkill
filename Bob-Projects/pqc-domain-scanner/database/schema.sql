-- PQC Domain Scanner Database Schema

-- Drop tables if they exist
DROP TABLE IF EXISTS certificate_chain CASCADE;
DROP TABLE IF EXISTS scan_results CASCADE;
DROP TABLE IF EXISTS domains CASCADE;
DROP TABLE IF EXISTS certificate_details CASCADE;

-- Domains table
CREATE TABLE domains (
    id SERIAL PRIMARY KEY,
    domain_name VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_scanned TIMESTAMP,
    scan_count INTEGER DEFAULT 0
);

-- Scan results table (with risk scoring)
CREATE TABLE scan_results (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER REFERENCES domains(id) ON DELETE CASCADE,
    scan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_pqc_ready BOOLEAN DEFAULT FALSE,
    supports_tls_13 BOOLEAN DEFAULT FALSE,
    certificate_valid BOOLEAN DEFAULT FALSE,
    certificate_expiry TIMESTAMP,
    days_until_vulnerable INTEGER,
    cipher_suites TEXT,
    key_exchange_algorithm VARCHAR(100),
    signature_algorithm VARCHAR(100),
    error_message TEXT,
    response_time_ms INTEGER,
    risk_score INTEGER,
    risk_level VARCHAR(20),
    chain_has_issues BOOLEAN DEFAULT FALSE
);

-- Certificate details table
CREATE TABLE certificate_details (
    id SERIAL PRIMARY KEY,
    scan_result_id INTEGER REFERENCES scan_results(id) ON DELETE CASCADE,
    subject VARCHAR(500),
    issuer VARCHAR(500),
    serial_number VARCHAR(100),
    not_before TIMESTAMP,
    not_after TIMESTAMP,
    public_key_algorithm VARCHAR(100),
    public_key_size INTEGER,
    signature_algorithm VARCHAR(100),
    is_quantum_safe BOOLEAN DEFAULT FALSE,
    pqc_algorithm_type VARCHAR(100),
    san_entries TEXT
);

-- Certificate chain table (for chain analysis)
CREATE TABLE certificate_chain (
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

-- Indexes for better query performance
CREATE INDEX idx_domains_name ON domains(domain_name);
CREATE INDEX idx_scan_results_domain ON scan_results(domain_id);
CREATE INDEX idx_scan_results_date ON scan_results(scan_date DESC);
CREATE INDEX idx_scan_results_pqc ON scan_results(is_pqc_ready);
CREATE INDEX idx_cert_details_scan ON certificate_details(scan_result_id);
CREATE INDEX idx_cert_chain_scan ON certificate_chain(scan_result_id);
CREATE INDEX idx_scan_results_risk ON scan_results(risk_level);
CREATE INDEX idx_scan_results_score ON scan_results(risk_score DESC);

-- View for dashboard statistics (with risk scoring)
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

-- View for recent scans (with risk info)
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

-- View for trend analysis
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

-- View for risk distribution
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

-- Insert sample domains for testing
INSERT INTO domains (domain_name) VALUES 
    ('google.com'),
    ('cloudflare.com'),
    ('github.com'),
    ('microsoft.com'),
    ('amazon.com')
ON CONFLICT (domain_name) DO NOTHING;

-- Made with Bob
