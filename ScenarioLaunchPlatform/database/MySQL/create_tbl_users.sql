-- ============================================
-- CREATE tbl_users TABLE FOR CRM DATABASE
-- ============================================
-- This table stores user accounts for the CRM system
-- Used by attack patterns for SQL injection demonstrations
-- ============================================

USE crm;

DROP TABLE IF EXISTS tbl_users;

CREATE TABLE tbl_users (
    id VARCHAR(36) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL,
    first_name VARCHAR(100) DEFAULT NULL,
    last_name VARCHAR(100) DEFAULT NULL,
    role VARCHAR(50) DEFAULT 'user',
    status VARCHAR(20) DEFAULT 'active',
    last_login DATETIME DEFAULT NULL,
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,
    date_modified DATETIME DEFAULT CURRENT_TIMESTAMP,
    failed_login_attempts INT DEFAULT 0,
    account_locked TINYINT(1) DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_username (username),
    KEY idx_email (email),
    KEY idx_status (status)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Insert sample users for attack pattern testing
INSERT INTO tbl_users (id, username, password, email, first_name, last_name, role, status, last_login) VALUES
('user-001', 'admin', 'admin123', 'admin@example.com', 'Admin', 'User', 'admin', 'active', NOW()),
('user-002', 'john.doe', 'password123', 'john.doe@example.com', 'John', 'Doe', 'user', 'active', DATE_SUB(NOW(), INTERVAL 1 DAY)),
('user-003', 'jane.smith', 'secure456', 'jane.smith@example.com', 'Jane', 'Smith', 'manager', 'active', DATE_SUB(NOW(), INTERVAL 2 HOUR)),
('user-004', 'bob.wilson', 'bob2024', 'bob.wilson@example.com', 'Bob', 'Wilson', 'user', 'active', DATE_SUB(NOW(), INTERVAL 5 DAY)),
('user-005', 'alice.brown', 'alice789', 'alice.brown@example.com', 'Alice', 'Brown', 'user', 'inactive', DATE_SUB(NOW(), INTERVAL 30 DAY)),
('user-006', 'charlie.davis', 'charlie321', 'charlie.davis@example.com', 'Charlie', 'Davis', 'user', 'locked', DATE_SUB(NOW(), INTERVAL 10 DAY)),
('user-007', 'diana.miller', 'diana999', 'diana.miller@example.com', 'Diana', 'Miller', 'manager', 'active', NOW()),
('user-008', 'eve.taylor', 'eve2024', 'eve.taylor@example.com', 'Eve', 'Taylor', 'user', 'active', DATE_SUB(NOW(), INTERVAL 3 HOUR)),
('user-009', 'frank.moore', 'frank555', 'frank.moore@example.com', 'Frank', 'Moore', 'user', 'active', DATE_SUB(NOW(), INTERVAL 1 WEEK)),
('user-010', 'grace.lee', 'grace777', 'grace.lee@example.com', 'Grace', 'Lee', 'admin', 'active', DATE_SUB(NOW(), INTERVAL 2 DAY));

-- Add stored procedure to populate more users
DROP PROCEDURE IF EXISTS PopulateUsers;

DELIMITER $$
CREATE PROCEDURE PopulateUsers()
BEGIN
    DECLARE i INT DEFAULT 0;
    
    WHILE i < 100 DO
        INSERT INTO tbl_users (id, username, password, email, first_name, last_name, role, status, last_login, failed_login_attempts, account_locked)
        VALUES (
            SUBSTRING(UUID(), 1, 36),
            CONCAT('user', i),
            CONCAT('pass', i, '!'),
            CONCAT('user', i, '@example.com'),
            CONCAT('FirstName', i),
            CONCAT('LastName', i),
            CASE 
                WHEN RAND() < 0.1 THEN 'admin'
                WHEN RAND() < 0.3 THEN 'manager'
                ELSE 'user'
            END,
            CASE 
                WHEN RAND() < 0.8 THEN 'active'
                WHEN RAND() < 0.9 THEN 'inactive'
                ELSE 'locked'
            END,
            DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY),
            FLOOR(RAND() * 5),
            CASE WHEN RAND() < 0.1 THEN 1 ELSE 0 END
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

-- Populate additional users
CALL PopulateUsers();

-- Verify table creation
SELECT 'tbl_users table created successfully!' AS status;
SELECT COUNT(*) AS total_users FROM tbl_users;
SELECT role, COUNT(*) AS count FROM tbl_users GROUP BY role;
SELECT status, COUNT(*) AS count FROM tbl_users GROUP BY status;

-- Made with Bob
