-- Fix PostgreSQL Database Permissions for CyberSkill Platform
-- Run this as the postgres superuser

-- Connect to the cyberskill database
\c cyberskill

-- Grant all privileges on database to cyberskill_user
GRANT ALL PRIVILEGES ON DATABASE cyberskill TO cyberskill_user;

-- Grant all privileges on schema public to cyberskill_user
GRANT ALL PRIVILEGES ON SCHEMA public TO cyberskill_user;

-- Grant create privilege on schema public
GRANT CREATE ON SCHEMA public TO cyberskill_user;

-- Grant usage on schema public
GRANT USAGE ON SCHEMA public TO cyberskill_user;

-- Grant all privileges on all tables in public schema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cyberskill_user;

-- Grant all privileges on all sequences in public schema
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO cyberskill_user;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO cyberskill_user;

-- Set default privileges for future sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO cyberskill_user;

-- Make cyberskill_user the owner of the public schema (optional but recommended)
ALTER SCHEMA public OWNER TO cyberskill_user;

-- Verify permissions
\dp

-- Made with Bob
