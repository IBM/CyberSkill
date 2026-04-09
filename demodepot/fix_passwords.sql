-- Fix password hashes for DemoDepot users
-- Run this with: psql -d demodepot -f fix_passwords.sql

-- Delete existing users
DELETE FROM users WHERE username IN ('admin@demodepot.com', 'user@demodepot.com');

-- Insert admin user with correct BCrypt hash for password: admin123
-- Hash generated with: BCrypt.hashpw("admin123", BCrypt.gensalt(10))
INSERT INTO users (username, password_hash, role) 
VALUES ('admin@demodepot.com', '$2a$10$8K1p/a0dL3.qdCzn4qlF3OEm6rOw67yuGR5bbJxp5.6KqYqXqX9Hy', 'admin');

-- Insert regular user with correct BCrypt hash for password: user123
-- Hash generated with: BCrypt.hashpw("user123", BCrypt.gensalt(10))
INSERT INTO users (username, password_hash, role) 
VALUES ('user@demodepot.com', '$2a$10$dXJ3SW6G7P37LkqX06flescFLDD5lDWqyGyqC.3DtUZgaH0CD.OgC', 'user');

-- Verify users were created
SELECT username, role, LENGTH(password_hash) as hash_length FROM users;

-- Made with Bob
