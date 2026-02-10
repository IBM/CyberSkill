-- ============================================================================
-- Manual SQL Commands Extracted from run_timed_selects_background.sh
-- Purpose: Run SELECT operations manually without automation
-- Pattern: 50 selects/hour for 4 hours, then 1000 selects in 5th hour
-- ============================================================================
-- 
-- SETUP INSTRUCTIONS:
-- 1. Replace <TIMESTAMP> with your desired timestamp (e.g., 20260209_125000)
-- 2. Replace <RANDOM_HEX> with a random hex string (e.g., a1b2c3d4)
-- 3. Replace <ROOT_PASSWORD> with your MySQL root password
-- 4. Execute each section in order
-- ============================================================================

-- ============================================================================
-- SECTION 1: CREATE DATABASE AND USER
-- ============================================================================

-- Create unique database
CREATE DATABASE `select_db_<TIMESTAMP>`;

-- Create unique user with password
CREATE USER 'select_user_<TIMESTAMP>'@'%' IDENTIFIED BY 'SelectPass_<TIMESTAMP>_<RANDOM_HEX>';

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON `select_db_<TIMESTAMP>`.* TO 'select_user_<TIMESTAMP>'@'%';

-- Apply privilege changes
FLUSH PRIVILEGES;

-- Test user connection (run this as the new user)
-- mysql -h<HOST> -P<PORT> -uselect_user_<TIMESTAMP> -p'SelectPass_<TIMESTAMP>_<RANDOM_HEX>' select_db_<TIMESTAMP>
SELECT 'User connection successful' AS Status;

-- ============================================================================
-- SECTION 2: CREATE TABLE AND INSERT TEST DATA
-- ============================================================================
-- Switch to the new database first: USE select_db_<TIMESTAMP>;

-- Create table with test data
CREATE TABLE IF NOT EXISTS select_test_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    record_number INT NOT NULL,
    data VARCHAR(255),
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_record_number (record_number),
    INDEX idx_category (category)
);

-- Insert 10,000 test records
INSERT IGNORE INTO select_test_data (record_number, data, category)
SELECT n, CONCAT('Test data for record ', n), CONCAT('category_', (n % 10) + 1)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 + d.N * 1000 + 1 AS n
    FROM
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) c,
        (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) d
) numbers
WHERE n <= 10000;

-- Verify table is ready
SELECT CONCAT('Table ready with ', COUNT(*), ' records') AS Status FROM select_test_data;

-- ============================================================================
-- SECTION 3: SAMPLE SELECT QUERIES (5 TYPES)
-- ============================================================================
-- The script uses 5 different query patterns. Here are examples of each:

-- Type 0: Simple SELECT by ID
SELECT * FROM select_test_data WHERE record_number = 1 LIMIT 1;
SELECT * FROM select_test_data WHERE record_number = 2 LIMIT 1;
SELECT * FROM select_test_data WHERE record_number = 3 LIMIT 1;

-- Type 1: SELECT with WHERE clause (by category)
SELECT * FROM select_test_data WHERE category = 'category_1' LIMIT 10;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT * FROM select_test_data WHERE category = 'category_3' LIMIT 10;

-- Type 2: SELECT with COUNT
SELECT COUNT(*) FROM select_test_data WHERE record_number > 1;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 100;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 500;

-- Type 3: SELECT with JOIN (self-join)
SELECT t1.record_number, t2.data
FROM select_test_data t1
JOIN select_test_data t2 ON t1.category = t2.category
WHERE t1.record_number = 1 LIMIT 5;

SELECT t1.record_number, t2.data
FROM select_test_data t1
JOIN select_test_data t2 ON t1.category = t2.category
WHERE t1.record_number = 2 LIMIT 5;

-- Type 4: SELECT with aggregation
SELECT category, COUNT(*) as count, MAX(record_number) as max_record
FROM select_test_data
GROUP BY category;

-- ============================================================================
-- SECTION 4: HOUR 1 - 50 SELECT QUERIES
-- ============================================================================
-- Execute 50 SELECT queries (mix of all 5 types)
-- Pattern: query_type = i % 5 (where i goes from 1 to 50)

-- Queries 1-10 (types 1,2,3,4,0,1,2,3,4,0)
SELECT * FROM select_test_data WHERE record_number = 1 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 3;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 4 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 6 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 8;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 9 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;

-- Queries 11-20
SELECT * FROM select_test_data WHERE record_number = 11 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 13;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 14 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 16 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 18;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 19 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;

-- Queries 21-30
SELECT * FROM select_test_data WHERE record_number = 21 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 23;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 24 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 26 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 28;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 29 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;

-- Queries 31-40
SELECT * FROM select_test_data WHERE record_number = 31 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 33;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 34 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 36 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 38;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 39 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;

-- Queries 41-50
SELECT * FROM select_test_data WHERE record_number = 41 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 43;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 44 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 46 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 48;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 49 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;

-- Verify Hour 1 completion
SELECT 'Hour 1: 50 SELECT commands completed' AS Result;

-- ============================================================================
-- SECTION 5: HOURS 2, 3, 4 - 50 SELECT QUERIES EACH
-- ============================================================================
-- NOTE: Hours 2, 3, and 4 follow the same pattern as Hour 1
-- Just repeat the 50 queries from Section 4 for each hour
-- In the original script, there's a 1-hour sleep between each batch

-- HOUR 2: Repeat Section 4 queries (50 queries)
-- HOUR 3: Repeat Section 4 queries (50 queries)  
-- HOUR 4: Repeat Section 4 queries (50 queries)

-- ============================================================================
-- SECTION 6: HOUR 5 - SPIKE (1000 SELECT QUERIES)
-- ============================================================================
-- NOTE: This section would contain 1000 SELECT queries following the same
-- pattern as above. For brevity, here's a template to generate them:

-- Template for generating 1000 queries:
-- For i = 1 to 1000:
--   query_type = i % 5
--   Execute query based on type (0-4) as shown in Section 3

-- Example of first 20 queries in the spike:
SELECT * FROM select_test_data WHERE record_number = 1 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 3;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 4 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 6 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 8;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 9 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 11 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_2' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 13;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 14 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;
SELECT * FROM select_test_data WHERE record_number = 16 LIMIT 1;
SELECT * FROM select_test_data WHERE category = 'category_7' LIMIT 10;
SELECT COUNT(*) FROM select_test_data WHERE record_number > 18;
SELECT t1.record_number, t2.data FROM select_test_data t1 JOIN select_test_data t2 ON t1.category = t2.category WHERE t1.record_number = 19 LIMIT 5;
SELECT category, COUNT(*) as count, MAX(record_number) as max_record FROM select_test_data GROUP BY category;

-- ... Continue this pattern for queries 21-1000 ...

-- Verify Hour 5 completion
SELECT 'Hour 5: 1000 SELECT commands completed (SPIKE)' AS Result;

-- ============================================================================
-- SECTION 7: SUMMARY QUERY
-- ============================================================================

-- Check total records in table
SELECT COUNT(*) AS total_records FROM select_test_data;

-- Check records by category
SELECT category, COUNT(*) AS count 
FROM select_test_data 
GROUP BY category 
ORDER BY category;

-- ============================================================================
-- SECTION 8: CLEANUP (OPTIONAL)
-- ============================================================================
-- Run these commands if you want to remove the test database and user

-- Drop the database
-- DROP DATABASE IF EXISTS `select_db_<TIMESTAMP>`;

-- Drop the user
-- DROP USER IF EXISTS 'select_user_<TIMESTAMP>'@'%';

-- Apply changes
-- FLUSH PRIVILEGES;

-- ============================================================================
-- EXECUTION SUMMARY
-- ============================================================================
-- Total Batches: 5 (Hours 1-5)
-- Hour 1: 50 SELECT queries
-- Hour 2: 50 SELECT queries (wait 1 hour)
-- Hour 3: 50 SELECT queries (wait 1 hour)
-- Hour 4: 50 SELECT queries (wait 1 hour)
-- Hour 5: 1000 SELECT queries (SPIKE - wait 1 hour)
-- Total: 1200 SELECT queries
-- ============================================================================

-- Made with Bob
