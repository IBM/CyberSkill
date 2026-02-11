-- PQC File Encryptor Database Schema
-- PostgreSQL Database

-- Drop tables if they exist
DROP TABLE IF EXISTS encryption_metadata CASCADE;
DROP TABLE IF EXISTS key_statistics CASCADE;

-- Table to store encryption metadata
CREATE TABLE encryption_metadata (
    id SERIAL PRIMARY KEY,
    file_name VARCHAR(500) NOT NULL,
    original_size BIGINT NOT NULL,
    encrypted_size BIGINT NOT NULL,
    encryption_algorithm VARCHAR(50) NOT NULL DEFAULT 'AES-256-GCM',
    kem_algorithm VARCHAR(50) NOT NULL DEFAULT 'Kyber1024',
    aes_key_size INTEGER NOT NULL DEFAULT 256,
    kyber_public_key_size INTEGER NOT NULL,
    kyber_private_key_size INTEGER NOT NULL,
    kyber_ciphertext_size INTEGER NOT NULL,
    classical_key_size INTEGER NOT NULL DEFAULT 256,
    pqc_overhead_bytes INTEGER NOT NULL,
    pqc_overhead_percentage DECIMAL(10, 2) NOT NULL,
    encrypted_file_path VARCHAR(1000),
    encryption_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    decryption_timestamp TIMESTAMP,
    status VARCHAR(20) DEFAULT 'encrypted',
    notes TEXT
);

-- Table to store aggregated key statistics for dashboard
CREATE TABLE key_statistics (
    id SERIAL PRIMARY KEY,
    algorithm_type VARCHAR(50) NOT NULL,
    key_type VARCHAR(50) NOT NULL,
    average_size INTEGER NOT NULL,
    min_size INTEGER NOT NULL,
    max_size INTEGER NOT NULL,
    total_operations INTEGER NOT NULL DEFAULT 1,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better query performance
CREATE INDEX idx_encryption_timestamp ON encryption_metadata(encryption_timestamp DESC);
CREATE INDEX idx_status ON encryption_metadata(status);
CREATE INDEX idx_kem_algorithm ON encryption_metadata(kem_algorithm);
CREATE INDEX idx_algorithm_type ON key_statistics(algorithm_type, key_type);

-- Insert initial statistics for comparison
INSERT INTO key_statistics (algorithm_type, key_type, average_size, min_size, max_size, total_operations) VALUES
('Classical', 'RSA-2048 Public Key', 294, 294, 294, 0),
('Classical', 'RSA-2048 Private Key', 1704, 1704, 1704, 0),
('Classical', 'AES-256 Key', 32, 32, 32, 0),
('PQC', 'Kyber512 Public Key', 800, 800, 800, 0),
('PQC', 'Kyber512 Private Key', 1632, 1632, 1632, 0),
('PQC', 'Kyber512 Ciphertext', 768, 768, 768, 0),
('PQC', 'Kyber768 Public Key', 1184, 1184, 1184, 0),
('PQC', 'Kyber768 Private Key', 2400, 2400, 2400, 0),
('PQC', 'Kyber768 Ciphertext', 1088, 1088, 1088, 0),
('PQC', 'Kyber1024 Public Key', 1568, 1568, 1568, 0),
('PQC', 'Kyber1024 Private Key', 3168, 3168, 3168, 0),
('PQC', 'Kyber1024 Ciphertext', 1568, 1568, 1568, 0);

-- View for easy dashboard queries
CREATE OR REPLACE VIEW encryption_summary AS
SELECT 
    COUNT(*) as total_files,
    SUM(original_size) as total_original_size,
    SUM(encrypted_size) as total_encrypted_size,
    AVG(pqc_overhead_percentage) as avg_pqc_overhead,
    kem_algorithm,
    status
FROM encryption_metadata
GROUP BY kem_algorithm, status;

-- View for size comparison
CREATE OR REPLACE VIEW size_comparison AS
SELECT 
    'Classical RSA-2048' as method,
    294 + 1704 as total_key_size,
    'Key Exchange' as purpose
UNION ALL
SELECT 
    'PQC Kyber512' as method,
    800 + 1632 + 768 as total_key_size,
    'Key Encapsulation' as purpose
UNION ALL
SELECT 
    'PQC Kyber768' as method,
    1184 + 2400 + 1088 as total_key_size,
    'Key Encapsulation' as purpose
UNION ALL
SELECT 
    'PQC Kyber1024' as method,
    1568 + 3168 + 1568 as total_key_size,
    'Key Encapsulation' as purpose;

COMMENT ON TABLE encryption_metadata IS 'Stores metadata about encrypted files including algorithm choices and size metrics';
COMMENT ON TABLE key_statistics IS 'Aggregated statistics about cryptographic key sizes for dashboard visualization';
COMMENT ON VIEW encryption_summary IS 'Summary view for dashboard showing encryption statistics by algorithm';
COMMENT ON VIEW size_comparison IS 'Comparison of classical vs PQC key sizes';

-- Made with Bob
