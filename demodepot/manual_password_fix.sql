-- Manual password fix - generates hash directly in PostgreSQL
-- This uses pgcrypto extension to generate BCrypt hashes

-- Enable pgcrypto extension if not already enabled
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Delete existing users
DELETE FROM users WHERE username IN ('admin@demodepot.com', 'user@demodepot.com');

-- Insert admin with password 'admin123' using PostgreSQL's crypt function
INSERT INTO users (username, password_hash, role) 
VALUES ('admin@demodepot.com', crypt('admin123', gen_salt('bf', 10)), 'admin');

-- Insert user with password 'user123' using PostgreSQL's crypt function
INSERT INTO users (username, password_hash, role) 
VALUES ('user@demodepot.com', crypt('user123', gen_salt('bf', 10)), 'user');

-- Show the generated hashes
SELECT username, role, password_hash FROM users;

-- Made with Bob
