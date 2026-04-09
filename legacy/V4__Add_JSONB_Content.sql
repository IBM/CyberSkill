-- CyberSkill Platform - Add JSONB Content Storage
-- Version: 1.2.0
-- Description: Add JSONB column for structured lesson content storage

-- Add JSONB column for rich content
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS content_json JSONB;

-- Create index for JSONB queries
CREATE INDEX IF NOT EXISTS idx_lessons_content_json ON lessons USING GIN (content_json);

-- Add metadata column for additional structured data
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Create index for metadata queries
CREATE INDEX IF NOT EXISTS idx_lessons_metadata ON lessons USING GIN (metadata);

-- Add flag to track content source
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS content_source VARCHAR(50) DEFAULT 'text';

-- Comment on columns
COMMENT ON COLUMN lessons.content_json IS 'Structured lesson content in JSON format including markdown, videos, exercises, etc.';
COMMENT ON COLUMN lessons.metadata IS 'Additional metadata like difficulty, prerequisites, tags, etc.';
COMMENT ON COLUMN lessons.content_source IS 'Source of content: text, json, or hybrid';

COMMIT;

-- Made with Bob
