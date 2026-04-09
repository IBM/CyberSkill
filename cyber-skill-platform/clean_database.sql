-- Clean Database Script for CyberSkill Platform
-- Run this to drop all existing tables and start fresh
-- WARNING: This will delete ALL data in the database!

\c cyberskill

-- Drop all tables in correct order (respecting foreign keys)
DROP TABLE IF EXISTS user_activity CASCADE;
DROP TABLE IF EXISTS admin_logs CASCADE;
DROP TABLE IF EXISTS certificates CASCADE;
DROP TABLE IF EXISTS user_badges CASCADE;
DROP TABLE IF EXISTS badges CASCADE;
DROP TABLE IF EXISTS quiz_attempts CASCADE;
DROP TABLE IF EXISTS quiz_options CASCADE;
DROP TABLE IF EXISTS quiz_questions CASCADE;
DROP TABLE IF EXISTS quizzes CASCADE;
DROP TABLE IF EXISTS user_progress CASCADE;
DROP TABLE IF EXISTS lessons CASCADE;
DROP TABLE IF EXISTS sections CASCADE;
DROP TABLE IF EXISTS modules CASCADE;
DROP TABLE IF EXISTS learning_paths CASCADE;
DROP TABLE IF EXISTS refresh_tokens CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Drop views
DROP VIEW IF EXISTS user_progress_summary CASCADE;
DROP VIEW IF EXISTS quiz_performance CASCADE;

-- Drop Flyway schema history table
DROP TABLE IF EXISTS flyway_schema_history CASCADE;

-- Drop extensions (optional - only if you want to recreate them)
-- DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;

-- Verify all tables are dropped
\dt

SELECT 'Database cleaned successfully!' AS status;

-- Made with Bob
