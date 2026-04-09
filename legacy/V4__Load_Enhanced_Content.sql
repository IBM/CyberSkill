-- CyberSkill Platform - Load Enhanced Content from JSON
-- Version: 1.2.0
-- Description: Placeholder migration - actual content loaded via ContentLoaderService

-- This migration is intentionally minimal
-- Content is loaded from JSON files in lesson-content/ directory
-- See ContentLoaderService.java for implementation

-- Add a flag to track content loading
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS content_loaded_from_json BOOLEAN DEFAULT FALSE;

-- Update will be done programmatically by ContentLoaderService
-- No direct SQL content updates to avoid escaping issues

COMMIT;

-- Made with Bob
