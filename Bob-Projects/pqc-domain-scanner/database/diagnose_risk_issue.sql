-- Comprehensive Diagnostic Script for Risk Score Issues
-- Run this to identify where the problem is

\echo '=== DIAGNOSTIC REPORT ==='
\echo ''

\echo '1. Check if risk columns exist:'
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'scan_results' 
AND column_name IN ('risk_score', 'risk_level', 'chain_has_issues')
ORDER BY column_name;

\echo ''
\echo '2. Count of scan results with/without risk data:'
SELECT 
    COUNT(*) as total_scans,
    COUNT(risk_score) as scans_with_risk_score,
    COUNT(risk_level) as scans_with_risk_level,
    COUNT(*) - COUNT(risk_score) as scans_missing_risk_score
FROM scan_results;

\echo ''
\echo '3. Risk level distribution:'
SELECT 
    COALESCE(risk_level, 'NULL') as risk_level,
    COUNT(*) as count,
    ROUND(AVG(risk_score), 2) as avg_score
FROM scan_results
GROUP BY risk_level
ORDER BY 
    CASE risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
        ELSE 5
    END;

\echo ''
\echo '4. Sample of recent scan results:'
SELECT 
    sr.id,
    d.domain_name,
    sr.is_pqc_ready,
    sr.days_until_vulnerable,
    sr.risk_score,
    sr.risk_level,
    sr.certificate_valid,
    sr.supports_tls_13,
    sr.scan_date
FROM scan_results sr
JOIN domains d ON sr.domain_id = d.id
ORDER BY sr.scan_date DESC
LIMIT 10;

\echo ''
\echo '5. Check dashboard_stats view:'
SELECT * FROM dashboard_stats;

\echo ''
\echo '6. Check risk_distribution view:'
SELECT * FROM risk_distribution;

\echo ''
\echo '7. Domains without any scans:'
SELECT d.id, d.domain_name, d.last_scanned, d.scan_count
FROM domains d
LEFT JOIN scan_results sr ON d.id = sr.domain_id
WHERE sr.id IS NULL;

\echo ''
\echo '8. Check for NULL days_until_vulnerable (needed for risk calc):'
SELECT 
    COUNT(*) as total,
    COUNT(days_until_vulnerable) as has_days_until_vulnerable,
    COUNT(*) - COUNT(days_until_vulnerable) as missing_days_until_vulnerable
FROM scan_results;

\echo ''
\echo '=== END DIAGNOSTIC REPORT ==='

-- Made with Bob
