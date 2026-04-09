-- CyberSkill Platform - Add JSONB Support to Quizzes and Labs
-- Version: 4.0.0
-- Description: Adds JSONB columns to quizzes table and creates labs table for hands-on exercises

-- ============================================================================
-- ADD JSONB COLUMNS TO QUIZZES TABLE
-- ============================================================================

-- Add quiz_json column to store complete quiz structure
ALTER TABLE quizzes ADD COLUMN IF NOT EXISTS quiz_json JSONB;

-- Add metadata column for quiz configuration
ALTER TABLE quizzes ADD COLUMN IF NOT EXISTS metadata JSONB;

-- Add content_source to track whether quiz uses JSON or relational structure
ALTER TABLE quizzes ADD COLUMN IF NOT EXISTS content_source VARCHAR(50) DEFAULT 'relational'
    CHECK (content_source IN ('relational', 'json'));

-- Create GIN index for efficient JSONB queries
CREATE INDEX IF NOT EXISTS idx_quizzes_quiz_json ON quizzes USING GIN (quiz_json);
CREATE INDEX IF NOT EXISTS idx_quizzes_metadata ON quizzes USING GIN (metadata);

-- ============================================================================
-- CREATE LABS TABLE
-- ============================================================================

-- Labs table for hands-on exercises
CREATE TABLE IF NOT EXISTS labs (
    id SERIAL PRIMARY KEY,
    section_id INTEGER NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    estimated_minutes INTEGER,
    content_source VARCHAR(50) DEFAULT 'json' CHECK (content_source IN ('text', 'json', 'markdown')),
    lab_json JSONB,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_labs_section_id ON labs(section_id);
CREATE INDEX IF NOT EXISTS idx_labs_lab_json ON labs USING GIN (lab_json);
CREATE INDEX IF NOT EXISTS idx_labs_metadata ON labs USING GIN (metadata);

-- ============================================================================
-- SAMPLE JSONB QUIZ
-- ============================================================================

-- Example quiz using JSONB format for Threat Intelligence section
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    13,  -- Threat Intelligence section
    'Threat Intelligence Fundamentals Quiz',
    'Test your understanding of cyber threat intelligence concepts.',
    70,
    20,
    3,
    'json',
    '{
        "title": "Threat Intelligence Fundamentals Quiz",
        "questions": [
            {
                "question": "What is the primary purpose of Cyber Threat Intelligence?",
                "type": "multiple_choice",
                "options": [
                    "To store firewall logs",
                    "To provide actionable insights about threats",
                    "To replace antivirus software",
                    "To manage user passwords"
                ],
                "correctAnswer": 1,
                "explanation": "CTI provides evidence-based knowledge about threats to enable informed security decisions.",
                "points": 1
            },
            {
                "question": "Which type of threat intelligence is most useful for executive decision-making?",
                "type": "multiple_choice",
                "options": [
                    "Technical Intelligence",
                    "Tactical Intelligence",
                    "Strategic Intelligence",
                    "Operational Intelligence"
                ],
                "correctAnswer": 2,
                "explanation": "Strategic intelligence provides high-level, long-term threat trends for executive decision-making.",
                "points": 1
            },
            {
                "question": "The intelligence lifecycle includes which of the following phases? (Select all that apply)",
                "type": "multi_select",
                "options": [
                    "Requirements",
                    "Collection",
                    "Analysis",
                    "Dissemination",
                    "Encryption"
                ],
                "correctAnswers": [0, 1, 2, 3],
                "explanation": "The intelligence lifecycle includes: Requirements, Collection, Processing, Analysis, Dissemination, and Feedback. Encryption is not a phase.",
                "points": 2
            },
            {
                "question": "IOCs (Indicators of Compromise) are examples of technical intelligence.",
                "type": "true_false",
                "options": ["True", "False"],
                "correctAnswer": 0,
                "explanation": "IOCs like file hashes, IP addresses, and domains are technical intelligence used for detection.",
                "points": 1
            },
            {
                "question": "What is the main goal of threat intelligence?",
                "type": "multiple_choice",
                "options": [
                    "To increase network speed",
                    "To reduce security risk through informed decisions",
                    "To replace security analysts",
                    "To eliminate all cyber threats"
                ],
                "correctAnswer": 1,
                "explanation": "Threat intelligence aims to reduce risk by providing actionable information for better security decisions.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 6,
        "difficulty": "beginner",
        "estimatedMinutes": 20,
        "tags": ["threat-intelligence", "fundamentals", "CTI"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- ============================================================================
-- ADDITIONAL JSONB QUIZ EXAMPLES
-- ============================================================================

-- Quiz for Penetration Testing Tools
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    3,  -- Legal and Ethical Considerations section
    'Penetration Testing Ethics Quiz',
    'Test your knowledge of ethical and legal aspects of penetration testing.',
    80,
    15,
    3,
    'json',
    '{
        "title": "Penetration Testing Ethics Quiz",
        "questions": [
            {
                "question": "Is it legal to perform penetration testing without written authorization?",
                "type": "true_false",
                "options": ["True", "False"],
                "correctAnswer": 1,
                "explanation": "Unauthorized penetration testing is illegal and can result in criminal charges, regardless of intent.",
                "points": 1
            },
            {
                "question": "What should you do if you discover a critical vulnerability during a penetration test?",
                "type": "multiple_choice",
                "options": [
                    "Post it on social media immediately",
                    "Report it to the client following responsible disclosure",
                    "Exploit it to demonstrate impact",
                    "Keep it secret for future use"
                ],
                "correctAnswer": 1,
                "explanation": "Always follow responsible disclosure practices and report findings to the client promptly.",
                "points": 1
            },
            {
                "question": "Which of the following are key ethical principles in penetration testing? (Select all that apply)",
                "type": "multi_select",
                "options": [
                    "Authorization",
                    "Confidentiality",
                    "Scope Definition",
                    "Responsible Disclosure",
                    "Public Shaming"
                ],
                "correctAnswers": [0, 1, 2, 3],
                "explanation": "Authorization, confidentiality, scope definition, and responsible disclosure are core ethical principles. Public shaming is unethical.",
                "points": 2
            },
            {
                "question": "What document should define the scope of a penetration test?",
                "type": "multiple_choice",
                "options": [
                    "Email thread",
                    "Verbal agreement",
                    "Written contract or Rules of Engagement",
                    "Social media post"
                ],
                "correctAnswer": 2,
                "explanation": "A written contract or Rules of Engagement document should clearly define the scope, boundaries, and authorization.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "beginner",
        "estimatedMinutes": 15,
        "tags": ["ethics", "legal", "penetration-testing"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Quiz for Data Security
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    7,  -- Understanding Data Classification section
    'Data Classification Quiz',
    'Test your understanding of data classification principles.',
    70,
    15,
    3,
    'json',
    '{
        "title": "Data Classification Quiz",
        "questions": [
            {
                "question": "What is the purpose of data classification?",
                "type": "multiple_choice",
                "options": [
                    "To make data harder to find",
                    "To apply appropriate security controls based on sensitivity",
                    "To delete old data",
                    "To encrypt all data equally"
                ],
                "correctAnswer": 1,
                "explanation": "Data classification helps organizations apply appropriate security controls based on data sensitivity and business impact.",
                "points": 1
            },
            {
                "question": "Which data classification level typically requires the highest security controls?",
                "type": "multiple_choice",
                "options": [
                    "Public",
                    "Internal",
                    "Confidential",
                    "Restricted"
                ],
                "correctAnswer": 3,
                "explanation": "Restricted data requires the highest level of security controls due to its extreme sensitivity.",
                "points": 1
            },
            {
                "question": "Public data requires no security controls.",
                "type": "true_false",
                "options": ["True", "False"],
                "correctAnswer": 1,
                "explanation": "Even public data requires integrity controls to prevent unauthorized modification.",
                "points": 1
            },
            {
                "question": "Which factors influence data classification? (Select all that apply)",
                "type": "multi_select",
                "options": [
                    "Sensitivity",
                    "Regulatory requirements",
                    "Business impact",
                    "File size",
                    "Storage location"
                ],
                "correctAnswers": [0, 1, 2],
                "explanation": "Sensitivity, regulatory requirements, and business impact are key factors. File size and storage location are not classification criteria.",
                "points": 2
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "beginner",
        "estimatedMinutes": 15,
        "tags": ["data-security", "classification", "governance"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- ============================================================================
-- MIGRATION NOTES
-- ============================================================================

-- This migration adds JSONB support to quizzes while maintaining backward compatibility:
--
-- 1. Existing quizzes using relational structure (quiz_questions + quiz_options) continue to work
-- 2. New quizzes can use simplified JSONB format for easier content creation
-- 3. The content_source column tracks which format is used
-- 4. Backend code should check content_source and handle both formats
--
-- JSONB Quiz Structure:
-- {
--   "title": "Quiz Title",
--   "questions": [
--     {
--       "question": "Question text",
--       "type": "multiple_choice" | "true_false" | "multi_select",
--       "options": ["Option 1", "Option 2", ...],
--       "correctAnswer": 0,  // For single answer (index)
--       "correctAnswers": [0, 2],  // For multi_select (array of indices)
--       "explanation": "Why this is correct",
--       "points": 1
--     }
--   ]
-- }
--
-- Metadata Structure:
-- {
--   "totalPoints": 10,
--   "difficulty": "beginner" | "intermediate" | "advanced",
--   "estimatedMinutes": 20,
--   "tags": ["tag1", "tag2"],
--   "version": "1.0",
--   "createdBy": "Author Name",
--   "lastUpdated": "2026-03-12"
-- }

-- Made with ❤️ by Bob - JSONB Quiz Edition

-- Made with Bob
