-- ============================================
-- CREATE tbl_users TABLE FOR CRM DATABASE (PostgreSQL)
-- ============================================
-- This table stores user accounts for the CRM system
-- Used by attack patterns for SQL injection demonstrations
-- PostgreSQL version
-- ============================================

-- Connect to CRM database (adjust if your database name is different)


DROP TABLE IF EXISTS tbl_users CASCADE;

CREATE TABLE tbl_users (
    id VARCHAR(36) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL,
    first_name VARCHAR(100) DEFAULT NULL,
    last_name VARCHAR(100) DEFAULT NULL,
    role VARCHAR(50) DEFAULT 'user',
    status VARCHAR(20) DEFAULT 'active',
    last_login TIMESTAMP DEFAULT NULL,
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    failed_login_attempts INTEGER DEFAULT 0,
    account_locked SMALLINT DEFAULT 0,
    PRIMARY KEY (id)
);

-- Create indexes
CREATE INDEX idx_users_username ON tbl_users(username);
CREATE INDEX idx_users_email ON tbl_users(email);
CREATE INDEX idx_users_status ON tbl_users(status);

-- Create trigger to auto-update date_modified
CREATE OR REPLACE FUNCTION update_tbl_users_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modified = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_tbl_users_modified
    BEFORE UPDATE ON tbl_users
    FOR EACH ROW
    EXECUTE FUNCTION update_tbl_users_modified();

-- Insert sample users for attack pattern testing
INSERT INTO tbl_users (id, username, password, email, first_name, last_name, role, status, last_login) VALUES
('user-001', 'admin', 'admin123', 'admin@example.com', 'Admin', 'User', 'admin', 'active', NOW()),
('user-002', 'john.doe', 'password123', 'john.doe@example.com', 'John', 'Doe', 'user', 'active', NOW() - INTERVAL '1 day'),
('user-003', 'jane.smith', 'secure456', 'jane.smith@example.com', 'Jane', 'Smith', 'manager', 'active', NOW() - INTERVAL '2 hours'),
('user-004', 'bob.wilson', 'bob2024', 'bob.wilson@example.com', 'Bob', 'Wilson', 'user', 'active', NOW() - INTERVAL '5 days'),
('user-005', 'alice.brown', 'alice789', 'alice.brown@example.com', 'Alice', 'Brown', 'user', 'inactive', NOW() - INTERVAL '30 days'),
('user-006', 'charlie.davis', 'charlie321', 'charlie.davis@example.com', 'Charlie', 'Davis', 'user', 'locked', NOW() - INTERVAL '10 days'),
('user-007', 'diana.miller', 'diana999', 'diana.miller@example.com', 'Diana', 'Miller', 'manager', 'active', NOW()),
('user-008', 'eve.taylor', 'eve2024', 'eve.taylor@example.com', 'Eve', 'Taylor', 'user', 'active', NOW() - INTERVAL '3 hours'),
('user-009', 'frank.moore', 'frank555', 'frank.moore@example.com', 'Frank', 'Moore', 'user', 'active', NOW() - INTERVAL '1 week'),
('user-010', 'grace.lee', 'grace777', 'grace.lee@example.com', 'Grace', 'Lee', 'admin', 'active', NOW() - INTERVAL '2 days');

-- Create function to populate more users
CREATE OR REPLACE FUNCTION populate_users()
RETURNS void AS $$
DECLARE
    i INTEGER := 0;
    random_role VARCHAR(50);
    random_status VARCHAR(20);
    random_days INTEGER;
    random_locked SMALLINT;
BEGIN
    WHILE i < 100 LOOP
        -- Generate random role
        CASE 
            WHEN RANDOM() < 0.1 THEN random_role := 'admin';
            WHEN RANDOM() < 0.3 THEN random_role := 'manager';
            ELSE random_role := 'user';
        END CASE;
        
        -- Generate random status
        CASE 
            WHEN RANDOM() < 0.8 THEN random_status := 'active';
            WHEN RANDOM() < 0.9 THEN random_status := 'inactive';
            ELSE random_status := 'locked';
        END CASE;
        
        -- Generate random values
        random_days := FLOOR(RANDOM() * 30)::INTEGER;
        random_locked := CASE WHEN RANDOM() < 0.1 THEN 1 ELSE 0 END;
        
        INSERT INTO tbl_users (id, username, password, email, first_name, last_name, role, status, last_login, failed_login_attempts, account_locked)
        VALUES (
            'user-' || LPAD((i + 11)::TEXT, 3, '0'),
            'user' || i,
            'pass' || i || '!',
            'user' || i || '@example.com',
            'FirstName' || i,
            'LastName' || i,
            random_role,
            random_status,
            NOW() - (random_days || ' days')::INTERVAL,
            FLOOR(RANDOM() * 5)::INTEGER,
            random_locked
        );
        
        i := i + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Populate additional users
SELECT populate_users();

-- Verify table creation
DO $$
DECLARE
    total_count INTEGER;
    admin_count INTEGER;
    manager_count INTEGER;
    user_count INTEGER;
    active_count INTEGER;
    inactive_count INTEGER;
    locked_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM tbl_users;
    SELECT COUNT(*) INTO admin_count FROM tbl_users WHERE role = 'admin';
    SELECT COUNT(*) INTO manager_count FROM tbl_users WHERE role = 'manager';
    SELECT COUNT(*) INTO user_count FROM tbl_users WHERE role = 'user';
    SELECT COUNT(*) INTO active_count FROM tbl_users WHERE status = 'active';
    SELECT COUNT(*) INTO inactive_count FROM tbl_users WHERE status = 'inactive';
    SELECT COUNT(*) INTO locked_count FROM tbl_users WHERE status = 'locked';
    
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'tbl_users table created successfully!';
    RAISE NOTICE '==============================================';
    RAISE NOTICE 'Total users: %', total_count;
    RAISE NOTICE '';
    RAISE NOTICE 'By Role:';
    RAISE NOTICE '  - Admin: %', admin_count;
    RAISE NOTICE '  - Manager: %', manager_count;
    RAISE NOTICE '  - User: %', user_count;
    RAISE NOTICE '';
    RAISE NOTICE 'By Status:';
    RAISE NOTICE '  - Active: %', active_count;
    RAISE NOTICE '  - Inactive: %', inactive_count;
    RAISE NOTICE '  - Locked: %', locked_count;
    RAISE NOTICE '==============================================';
END $$;

