-- Update Risk Scores for Existing Scan Results
-- This script calculates and updates risk scores for all existing scan results

-- Update risk scores based on the risk calculation algorithm
UPDATE scan_results
SET 
    risk_score = CASE
        -- Calculate vulnerability score (40% weight)
        WHEN days_until_vulnerable < 0 THEN 0  -- Quantum-safe
        WHEN days_until_vulnerable < 365 THEN 
            ROUND(
                (100 * 0.40) +  -- Vulnerability: Critical
                (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +  -- Cert validity
                (30 * 0.20) +  -- Algorithm (assume RSA)
                (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +  -- TLS version
                (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)  -- Chain
            )
        WHEN days_until_vulnerable < 730 THEN 
            ROUND(
                (80 * 0.40) +  -- Vulnerability: High
                (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                (30 * 0.20) +
                (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
            )
        WHEN days_until_vulnerable < 1095 THEN 
            ROUND(
                (60 * 0.40) +  -- Vulnerability: Medium
                (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                (30 * 0.20) +
                (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
            )
        WHEN days_until_vulnerable < 1460 THEN 
            ROUND(
                (40 * 0.40) +  -- Vulnerability: Low-Medium
                (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                (30 * 0.20) +
                (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
            )
        ELSE 
            ROUND(
                (20 * 0.40) +  -- Vulnerability: Low
                (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                (30 * 0.20) +
                (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
            )
    END,
    risk_level = CASE
        WHEN days_until_vulnerable < 0 THEN 'LOW'  -- Quantum-safe
        WHEN days_until_vulnerable < 365 THEN 
            CASE 
                WHEN ROUND(
                    (100 * 0.40) +
                    (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                    (30 * 0.20) +
                    (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                    (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
                ) >= 80 THEN 'CRITICAL'
                WHEN ROUND(
                    (100 * 0.40) +
                    (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                    (30 * 0.20) +
                    (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                    (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
                ) >= 60 THEN 'HIGH'
                WHEN ROUND(
                    (100 * 0.40) +
                    (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                    (30 * 0.20) +
                    (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                    (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
                ) >= 40 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        WHEN days_until_vulnerable < 730 THEN 
            CASE 
                WHEN ROUND(
                    (80 * 0.40) +
                    (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                    (30 * 0.20) +
                    (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                    (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
                ) >= 80 THEN 'CRITICAL'
                WHEN ROUND(
                    (80 * 0.40) +
                    (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                    (30 * 0.20) +
                    (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                    (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
                ) >= 60 THEN 'HIGH'
                WHEN ROUND(
                    (80 * 0.40) +
                    (CASE WHEN certificate_valid THEN 10 ELSE 100 END * 0.20) +
                    (30 * 0.20) +
                    (CASE WHEN supports_tls_13 THEN 10 ELSE 60 END * 0.10) +
                    (CASE WHEN chain_has_issues THEN 80 ELSE 10 END * 0.10)
                ) >= 40 THEN 'MEDIUM'
                ELSE 'LOW'
            END
        WHEN days_until_vulnerable < 1095 THEN 'MEDIUM'
        WHEN days_until_vulnerable < 1460 THEN 'MEDIUM'
        ELSE 'LOW'
    END
WHERE risk_score IS NULL OR risk_level IS NULL;

-- Verify the update
SELECT 
    risk_level,
    COUNT(*) as count,
    ROUND(AVG(risk_score), 2) as avg_score,
    MIN(risk_score) as min_score,
    MAX(risk_score) as max_score
FROM scan_results
WHERE risk_score IS NOT NULL
GROUP BY risk_level
ORDER BY 
    CASE risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
        ELSE 5
    END;

-- Show sample of updated records
SELECT 
    d.domain_name,
    sr.is_pqc_ready,
    sr.days_until_vulnerable,
    sr.risk_score,
    sr.risk_level,
    sr.scan_date
FROM scan_results sr
JOIN domains d ON sr.domain_id = d.id
ORDER BY sr.scan_date DESC
LIMIT 10;

-- Made with Bob
