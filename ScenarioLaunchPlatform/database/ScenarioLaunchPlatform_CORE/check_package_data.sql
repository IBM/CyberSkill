-- Check current package data in outlier scripts
SELECT 
    id,
    name,
    package_id,
    package_name,
    uploaded_at
FROM public.tb_outlier_scripts
ORDER BY uploaded_at DESC;

-- Count scripts by package status
SELECT 
    CASE 
        WHEN package_id IS NULL THEN 'No Package (NULL)'
        ELSE 'Has Package'
    END as package_status,
    COUNT(*) as script_count
FROM public.tb_outlier_scripts
GROUP BY package_status;

