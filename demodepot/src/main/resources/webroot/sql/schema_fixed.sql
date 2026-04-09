-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'user', -- 'user' or 'admin'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Update demo_requests table to include user_id and improve status tracking
ALTER TABLE demo_requests 
ADD COLUMN IF NOT EXISTS user_id INTEGER REFERENCES users(id),
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_demo_requests_user_id ON demo_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_demo_requests_status ON demo_requests(status);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Delete existing users if they exist
DELETE FROM users WHERE username IN ('admin@demodepot.com', 'user@demodepot.com');

-- Insert default admin user (password: admin123)
-- This hash was generated using: BCrypt.hashpw("admin123", BCrypt.gensalt())
INSERT INTO users (username, password_hash, role) 
VALUES ('admin@demodepot.com', '$2a$10$8K1p/a0dL3.qdCzn4qlF3OEm6rOw67yuGR5bbJxp5.6KqYqXqX9Hy', 'admin');

-- Insert a test regular user (password: user123)
-- This hash was generated using: BCrypt.hashpw("user123", BCrypt.gensalt())
INSERT INTO users (username, password_hash, role) 
VALUES ('user@demodepot.com', '$2a$10$dXJ3SW6G7P37LkqX06flescFLDD5lDWqyGyqC.3DtUZgaH0CD.OgC', 'user');

-- Made with Bob
