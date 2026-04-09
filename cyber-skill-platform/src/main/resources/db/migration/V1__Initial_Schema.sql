-- CyberSkill Platform - Initial Database Schema
-- Version: 1.0.0
-- Description: Creates all core tables for the learning platform

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- USERS AND AUTHENTICATION
-- ============================================================================

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER' CHECK (role IN ('USER', 'ADMIN')),
    mfa_enabled BOOLEAN DEFAULT FALSE,
    mfa_secret VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);

-- Refresh tokens table
CREATE TABLE refresh_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    revoked BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- ============================================================================
-- LEARNING CONTENT STRUCTURE
-- ============================================================================

-- Learning paths (e.g., Penetration Testing, Compliance, etc.)
CREATE TABLE learning_paths (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    slug VARCHAR(200) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    order_index INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    estimated_hours INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_learning_paths_slug ON learning_paths(slug);
CREATE INDEX idx_learning_paths_order ON learning_paths(order_index);

-- Modules within learning paths
CREATE TABLE modules (
    id SERIAL PRIMARY KEY,
    learning_path_id INTEGER NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL,
    estimated_hours INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_modules_path_id ON modules(learning_path_id);
CREATE INDEX idx_modules_order ON modules(order_index);

-- Sections within modules
CREATE TABLE sections (
    id SERIAL PRIMARY KEY,
    module_id INTEGER NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sections_module_id ON sections(module_id);
CREATE INDEX idx_sections_order ON sections(order_index);

-- Lessons within sections
CREATE TABLE lessons (
    id SERIAL PRIMARY KEY,
    section_id INTEGER NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    content TEXT,
    content_type VARCHAR(50) NOT NULL DEFAULT 'text' CHECK (content_type IN ('text', 'video', 'interactive', 'pdf')),
    video_url VARCHAR(500),
    order_index INTEGER NOT NULL,
    estimated_minutes INTEGER,
    content_json JSONB,
    metadata JSONB,
    content_source VARCHAR(50) DEFAULT 'text' CHECK (content_source IN ('text', 'json', 'markdown')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_lessons_section_id ON lessons(section_id);
CREATE INDEX idx_lessons_order ON lessons(order_index);
CREATE INDEX idx_lessons_content_json ON lessons USING GIN (content_json);
CREATE INDEX idx_lessons_metadata ON lessons USING GIN (metadata);

-- ============================================================================
-- ASSESSMENTS AND QUIZZES
-- ============================================================================

-- Quizzes (one per section)
CREATE TABLE quizzes (
    id SERIAL PRIMARY KEY,
    section_id INTEGER NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    passing_score INTEGER NOT NULL DEFAULT 70,
    time_limit_minutes INTEGER,
    max_attempts INTEGER DEFAULT 3,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quizzes_section_id ON quizzes(section_id);

-- Quiz questions
CREATE TABLE quiz_questions (
    id SERIAL PRIMARY KEY,
    quiz_id INTEGER NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL CHECK (question_type IN ('multiple_choice', 'true_false', 'multi_select')),
    explanation TEXT,
    order_index INTEGER NOT NULL,
    points INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quiz_questions_quiz_id ON quiz_questions(quiz_id);

-- Quiz answer options
CREATE TABLE quiz_options (
    id SERIAL PRIMARY KEY,
    question_id INTEGER NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    order_index INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quiz_options_question_id ON quiz_options(question_id);

-- ============================================================================
-- USER PROGRESS TRACKING
-- ============================================================================

-- User lesson progress
CREATE TABLE user_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    time_spent_seconds INTEGER DEFAULT 0,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, lesson_id)
);

CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_user_progress_lesson_id ON user_progress(lesson_id);
CREATE INDEX idx_user_progress_status ON user_progress(status);

-- Quiz attempts
CREATE TABLE quiz_attempts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    quiz_id INTEGER NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
    score INTEGER NOT NULL,
    max_score INTEGER NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    passed BOOLEAN NOT NULL,
    started_at TIMESTAMP NOT NULL,
    completed_at TIMESTAMP NOT NULL,
    time_taken_seconds INTEGER,
    attempt_number INTEGER NOT NULL,
    answers JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_quiz_attempts_user_id ON quiz_attempts(user_id);
CREATE INDEX idx_quiz_attempts_quiz_id ON quiz_attempts(quiz_id);
CREATE INDEX idx_quiz_attempts_passed ON quiz_attempts(passed);

-- ============================================================================
-- BADGES AND ACHIEVEMENTS
-- ============================================================================

-- Badge definitions
CREATE TABLE badges (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    icon VARCHAR(100),
    badge_type VARCHAR(50) NOT NULL CHECK (badge_type IN ('section', 'module', 'path', 'special')),
    criteria JSONB,
    points INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_badges_type ON badges(badge_type);

-- User earned badges
CREATE TABLE user_badges (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id INTEGER NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, badge_id)
);

CREATE INDEX idx_user_badges_user_id ON user_badges(user_id);
CREATE INDEX idx_user_badges_badge_id ON user_badges(badge_id);

-- ============================================================================
-- CERTIFICATES
-- ============================================================================

-- Certificates
CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    learning_path_id INTEGER NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
    certificate_id VARCHAR(100) UNIQUE NOT NULL DEFAULT uuid_generate_v4(),
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pdf_path VARCHAR(500),
    verification_code VARCHAR(50) UNIQUE,
    UNIQUE(user_id, learning_path_id)
);

CREATE INDEX idx_certificates_user_id ON certificates(user_id);
CREATE INDEX idx_certificates_path_id ON certificates(learning_path_id);
CREATE INDEX idx_certificates_cert_id ON certificates(certificate_id);
CREATE INDEX idx_certificates_verification ON certificates(verification_code);

-- ============================================================================
-- ADMIN AND AUDIT
-- ============================================================================

-- Admin audit logs
CREATE TABLE admin_logs (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INTEGER,
    details JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_admin_logs_admin_id ON admin_logs(admin_id);
CREATE INDEX idx_admin_logs_action ON admin_logs(action);
CREATE INDEX idx_admin_logs_entity ON admin_logs(entity_type, entity_id);
CREATE INDEX idx_admin_logs_created ON admin_logs(created_at);

-- ============================================================================
-- ANALYTICS AND METRICS
-- ============================================================================

-- User activity tracking
CREATE TABLE user_activity (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    activity_type VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INTEGER,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_activity_user_id ON user_activity(user_id);
CREATE INDEX idx_user_activity_type ON user_activity(activity_type);
CREATE INDEX idx_user_activity_created ON user_activity(created_at);

-- ============================================================================
-- INITIAL DATA
-- ============================================================================

-- Create default admin user
-- Username: admin@cyberskill.com
-- Password: Admin@123 (MUST BE CHANGED IN PRODUCTION)
-- Password hash generated with BCrypt (12 rounds)
INSERT INTO users (username, email, password_hash, role, is_active, email_verified)
VALUES ('admin', 'admin@cyberskill.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIq.Zu3aCu', 'ADMIN', TRUE, TRUE);

-- Create test user
-- Username: user@cyberskill.com
-- Password: User@123
INSERT INTO users (username, email, password_hash, role, is_active, email_verified)
VALUES ('testuser', 'user@cyberskill.com', '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'USER', TRUE, TRUE);

-- ============================================================================
-- FUNCTIONS AND TRIGGERS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_learning_paths_updated_at BEFORE UPDATE ON learning_paths
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_modules_updated_at BEFORE UPDATE ON modules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sections_updated_at BEFORE UPDATE ON sections
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quizzes_updated_at BEFORE UPDATE ON quizzes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- View for user progress summary
CREATE VIEW user_progress_summary AS
SELECT 
    u.id as user_id,
    u.username,
    u.email,
    lp.id as learning_path_id,
    lp.name as learning_path_name,
    COUNT(DISTINCT l.id) as total_lessons,
    COUNT(DISTINCT CASE WHEN up.status = 'completed' THEN l.id END) as completed_lessons,
    ROUND(
        (COUNT(DISTINCT CASE WHEN up.status = 'completed' THEN l.id END)::DECIMAL / 
        NULLIF(COUNT(DISTINCT l.id), 0) * 100), 2
    ) as completion_percentage
FROM users u
CROSS JOIN learning_paths lp
LEFT JOIN modules m ON m.learning_path_id = lp.id
LEFT JOIN sections s ON s.module_id = m.id
LEFT JOIN lessons l ON l.section_id = s.id
LEFT JOIN user_progress up ON up.lesson_id = l.id AND up.user_id = u.id
WHERE u.role = 'USER' AND u.is_active = TRUE
GROUP BY u.id, u.username, u.email, lp.id, lp.name;

-- View for quiz performance
CREATE VIEW quiz_performance AS
SELECT 
    u.id as user_id,
    u.username,
    q.id as quiz_id,
    q.name as quiz_name,
    s.name as section_name,
    COUNT(qa.id) as total_attempts,
    MAX(qa.score) as best_score,
    AVG(qa.score) as average_score,
    MAX(CASE WHEN qa.passed THEN 1 ELSE 0 END) as has_passed
FROM users u
CROSS JOIN quizzes q
LEFT JOIN quiz_attempts qa ON qa.quiz_id = q.id AND qa.user_id = u.id
LEFT JOIN sections s ON s.id = q.section_id
WHERE u.role = 'USER' AND u.is_active = TRUE
GROUP BY u.id, u.username, q.id, q.name, s.name;

-- Grant permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO cyberskill_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO cyberskill_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO cyberskill_user;

-- Made with Bob
