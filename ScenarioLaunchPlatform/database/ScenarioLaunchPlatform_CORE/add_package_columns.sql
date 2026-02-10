-- Migration script to add package_id and package_name columns to tb_outlier_scripts
-- This script is safe to run multiple times (idempotent)

DO $$
BEGIN
    -- Add package_id column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'tb_outlier_scripts' 
        AND column_name = 'package_id'
    ) THEN
        ALTER TABLE public.tb_outlier_scripts 
        ADD COLUMN package_id VARCHAR(100);
        
        RAISE NOTICE 'Added package_id column to tb_outlier_scripts';
    ELSE
        RAISE NOTICE 'package_id column already exists in tb_outlier_scripts';
    END IF;
    
    -- Add package_name column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'tb_outlier_scripts' 
        AND column_name = 'package_name'
    ) THEN
        ALTER TABLE public.tb_outlier_scripts 
        ADD COLUMN package_name VARCHAR(255);
        
        RAISE NOTICE 'Added package_name column to tb_outlier_scripts';
    ELSE
        RAISE NOTICE 'package_name column already exists in tb_outlier_scripts';
    END IF;
    
    -- Create index on package_id for faster package queries
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'tb_outlier_scripts' 
        AND indexname = 'idx_outlier_scripts_package_id'
    ) THEN
        CREATE INDEX idx_outlier_scripts_package_id ON public.tb_outlier_scripts(package_id);
        RAISE NOTICE 'Created index idx_outlier_scripts_package_id';
    ELSE
        RAISE NOTICE 'Index idx_outlier_scripts_package_id already exists';
    END IF;
    
    RAISE NOTICE 'Migration complete!';
END $$;

