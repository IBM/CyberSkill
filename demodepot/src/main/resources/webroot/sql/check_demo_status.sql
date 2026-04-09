-- Check demo request status distribution
SELECT status, COUNT(*) as count 
FROM demo_requests 
GROUP BY status 
ORDER BY count DESC;

-- Show all demo requests with their status
SELECT id, pm_owner, product_name, title, status, created_at 
FROM demo_requests 
ORDER BY created_at DESC;

-- Made with Bob
