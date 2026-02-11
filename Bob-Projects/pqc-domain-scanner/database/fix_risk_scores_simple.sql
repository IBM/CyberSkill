-- Simple Risk Score Fix
-- This script updates ALL scan results with calculated risk scores

-- First, let's see what we're working with
SELECT 
    'Before Update' as status,
    COUNT(*) as total_scans,
    COUNT(risk_score) as with_risk_score,
    COUNT(*) - COUNT(risk_score) as missing_risk_score
FROM scan_results;

-- Update all records with a simple risk calculation
-- Based on days_until_vulnerable as the primary factor
UPDATE scan_results
SET 
    risk_score = CASE
        -- If quantum-safe (negative days), low risk
        WHEN days_until_vulnerable < 0 THEN 15
        -- If less than 1 year, critical
        WHEN days_until_vulnerable < 365 THEN 85
        -- If 1-2 years, high
        WHEN days_until_vulnerable < 730 THEN 70
        -- If 2-3 years, medium
        WHEN days_until_vulnerable < 1095 THEN 50
        -- If 3-4 years, low-medium
        WHEN days_until_vulnerable < 1460 THEN 35
        -- If more than 4 years, low
        ELSE 20
    END,
    risk_level = CASE
        WHEN days_until_vulnerable < 0 THEN 'LOW'
        WHEN days_until_vulnerable < 365 THEN 'CRITICAL'
        WHEN days_until_vulnerable < 730 THEN 'HIGH'
        WHEN days_until_vulnerable < 1095 THEN 'MEDIUM'
        WHEN days_until_vulnerable < 1460 THEN 'MEDIUM'
        ELSE 'LOW'
    END
WHERE days_until_vulnerable IS NOT NULL;

-- For records without days_until_vulnerable, set default medium risk
UPDATE scan_results
SET 
    risk_score = 50,
    risk_level = 'MEDIUM'
WHERE days_until_vulnerable IS NULL 
  AND (risk_score IS NULL OR risk_level IS NULL);

-- Show results after update
SELECT 
    'After Update' as status,
    COUNT(*) as total_scans,
    COUNT(risk_score) as with_risk_score,
    COUNT(*) - COUNT(risk_score) as missing_risk_score
FROM scan_results;

-- Show distribution
SELECT 
    risk_level,
    COUNT(*) as count,
    MIN(risk_score) as min_score,
    MAX(risk_score) as max_score,
    ROUND(AVG(risk_score), 1) as avg_score
FROM scan_results
WHERE risk_score IS NOT NULL
GROUP BY risk_level
ORDER BY 
    CASE risk_level
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        WHEN 'LOW' THEN 4
    END;

-- Show sample of updated records
SELECT 
    d.domain_name,
    sr.days_until_vulnerable,
    sr.risk_score,
    sr.risk_level,
    sr.is_pqc_ready,
    sr.scan_date
FROM scan_results sr
JOIN domains d ON sr.domain_id = d.id
ORDER BY sr.scan_date DESC
LIMIT 10;

-- Made with Bob
