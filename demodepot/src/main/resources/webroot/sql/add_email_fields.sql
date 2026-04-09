-- Add email field to users table
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS email VARCHAR(255),
ADD COLUMN IF NOT EXISTS full_name VARCHAR(255);

-- Create unique index on email
CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Add email field to demo_requests table for tracking
ALTER TABLE demo_requests
ADD COLUMN IF NOT EXISTS requester_email VARCHAR(255);

-- Update existing users to use username as email if email is null
UPDATE users SET email = username WHERE email IS NULL;

-- Made with Bob