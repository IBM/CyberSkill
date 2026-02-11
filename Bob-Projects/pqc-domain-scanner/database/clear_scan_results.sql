-- Clear All Scan Results and Start Fresh
-- This script removes all scan history while keeping domain definitions

-- Show current state before clearing
SELECT 
    'Before Clear' as status,
    (SELECT COUNT(*) FROM scan_results) as scan_results_count,
    (SELECT COUNT(*) FROM certificate_details) as certificate_details_count,
    (SELECT COUNT(*) FROM certificate_chain) as certificate_chain_count,
    (SELECT COUNT(*) FROM domains) as domains_count;

-- Delete all scan-related data (cascades will handle related records)
DELETE FROM certificate_chain;
DELETE FROM certificate_details;
DELETE FROM scan_results;

-- Reset domain scan counters
UPDATE domains 
SET 
    last_scanned = NULL,
    scan_count = 0;

-- Show state after clearing
SELECT 
    'After Clear' as status,
    (SELECT COUNT(*) FROM scan_results) as scan_results_count,
    (SELECT COUNT(*) FROM certificate_details) as certificate_details_count,
    (SELECT COUNT(*) FROM certificate_chain) as certificate_chain_count,
    (SELECT COUNT(*) FROM domains) as domains_count;

-- Show remaining domains (ready for fresh scans)
SELECT 
    id,
    domain_name,
    last_scanned,
    scan_count,
    created_at
FROM domains
ORDER BY domain_name;

-- Verification queries
SELECT 'All scan results cleared. Domains preserved and ready for fresh scans.' as message;

-- Made with Bob
