-- Add package grouping fields to outlier scripts table
-- Run this script to add support for package grouping feature

ALTER TABLE public.tb_outlier_scripts 
ADD COLUMN IF NOT EXISTS package_id VARCHAR(100),
ADD COLUMN IF NOT EXISTS package_name VARCHAR(255);

-- Create index for faster package lookups
CREATE INDEX IF NOT EXISTS idx_outlier_scripts_package_id ON public.tb_outlier_scripts(package_id);

-- Display confirmation
SELECT 'Package fields added successfully!' as status;

