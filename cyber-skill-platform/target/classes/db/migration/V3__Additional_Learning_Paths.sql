-- CyberSkill Platform - Additional Learning Paths with JSONB Content
-- Version: 2.0.0
-- Description: Adds 3 cutting-edge learning paths with JSONB-structured content

-- ============================================================================
-- LEARNING PATH 5: THREAT INTELLIGENCE & HUNTING
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'Threat Intelligence & Hunting',
    'threat-intelligence-hunting',
    'Master threat intelligence analysis, threat hunting techniques, and proactive defense strategies.',
    'crosshair',
    5,
    40
);

-- Modules
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES
    (5, 'Threat Intelligence Fundamentals', 'Core concepts of cyber threat intelligence.', 1, 8),
    (5, 'Threat Actor Analysis', 'Understanding threat actors and their tactics.', 2, 9),
    (5, 'Threat Intelligence Platforms & Tools', 'Master TIPs, MISP, STIX/TAXII.', 3, 8),
    (5, 'Threat Hunting Methodologies', 'Proactive threat hunting techniques.', 4, 10),
    (5, 'Intelligence-Driven Defense', 'Operationalizing threat intelligence.', 5, 5);

-- Sections
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (21, 'Introduction to Threat Intelligence', 'What is threat intelligence and why it matters.', 1),
    (21, 'The Intelligence Lifecycle', 'Intelligence lifecycle phases.', 2),
    (21, 'Types of Threat Intelligence', 'Strategic, tactical, operational, technical.', 3),
    (22, 'Understanding Threat Actors', 'Classification of threat actor types.', 1),
    (22, 'APT Groups and Nation-State Actors', 'Advanced Persistent Threats.', 2),
    (22, 'MITRE ATT&CK Framework', 'Using ATT&CK for threat mapping.', 3),
    (24, 'Threat Hunting Fundamentals', 'Introduction to proactive hunting.', 1),
    (24, 'Hypothesis-Driven Hunting', 'Creating and testing hypotheses.', 2),
    (24, 'Hunting Tools and Techniques', 'Tools for effective hunting.', 3);

-- Sample lessons with JSONB
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES 
    (13, 'What is Cyber Threat Intelligence?', 'Evidence-based knowledge about threats.', 'text', 1, 25,
    '{"title": "Cyber Threat Intelligence", "sections": [{"heading": "CTI Overview", "content": "Cyber Threat Intelligence provides actionable insights about threats to enable informed security decisions."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 25, "tags": ["cti", "fundamentals"]}'::jsonb, 'json'),
    
    (13, 'The Value of Threat Intelligence', 'How CTI reduces risk and improves response.', 'video', 2, 30,
    '{"title": "Value of CTI", "videoUrl": "https://www.youtube.com/embed/cti-value", "sections": [{"heading": "Business Value", "content": "CTI delivers measurable ROI through risk reduction and faster incident response."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 30, "tags": ["cti", "roi"], "hasVideo": true}'::jsonb, 'json'),
    
    (14, 'Intelligence Lifecycle Phases', 'The six phases of intelligence lifecycle.', 'text', 1, 30,
    '{"title": "Intelligence Lifecycle", "sections": [{"heading": "Six Phases", "content": "Requirements, Collection, Processing, Analysis, Dissemination, Feedback."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 30, "tags": ["lifecycle"]}'::jsonb, 'json'),
    
    (15, 'Strategic Intelligence', 'High-level intelligence for executives.', 'text', 1, 20,
    '{"title": "Strategic Intelligence", "sections": [{"heading": "Executive Intelligence", "content": "Strategic intelligence provides long-term threat trends for decision-making."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["strategic"]}'::jsonb, 'json'),
    
    (16, 'Threat Actor Taxonomy', 'Categories of threat actors.', 'text', 1, 25,
    '{"title": "Threat Actors", "sections": [{"heading": "Actor Types", "content": "Nation-states, cybercriminals, hacktivists, insider threats, script kiddies."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["actors"]}'::jsonb, 'json'),
    
    (17, 'Notable APT Groups', 'Analysis of major APT groups.', 'text', 1, 35,
    '{"title": "APT Groups", "sections": [{"heading": "Major APTs", "content": "APT28, APT29, Lazarus Group, APT41 and their campaigns."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 35, "tags": ["apt"]}'::jsonb, 'json'),
    
    (18, 'Introduction to MITRE ATT&CK', 'The ATT&CK framework.', 'text', 1, 25,
    '{"title": "MITRE ATT&CK", "sections": [{"heading": "ATT&CK Framework", "content": "Knowledge base of adversary tactics and techniques."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["mitre-attack"]}'::jsonb, 'json'),
    
    (19, 'What is Threat Hunting?', 'Proactive threat searching.', 'text', 1, 20,
    '{"title": "Threat Hunting", "sections": [{"heading": "Proactive Defense", "content": "Actively searching for threats that evade existing controls."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["hunting"]}'::jsonb, 'json'),
    
    (20, 'Creating Hunt Hypotheses', 'Developing testable hypotheses.', 'text', 1, 25,
    '{"title": "Hunt Hypotheses", "sections": [{"heading": "Hypothesis Development", "content": "Create testable hypotheses based on threat intelligence."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 25, "tags": ["hypothesis"]}'::jsonb, 'json'),
    
    (21, 'SIEM for Threat Hunting', 'Using SIEM for hunting.', 'text', 1, 25,
    '{"title": "SIEM Hunting", "sections": [{"heading": "SIEM Tools", "content": "Leverage SIEM for log analysis and threat detection."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 25, "tags": ["siem"]}'::jsonb, 'json');

-- Quiz
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts)
VALUES (13, 'Threat Intelligence Fundamentals Quiz', 'Test your CTI knowledge.', 70, 15, 3);

INSERT INTO quiz_questions (quiz_id, question_text, question_type, explanation, order_index, points)
VALUES 
    (2, 'Which type of threat intelligence is most useful for executive decision-making?', 'multiple_choice', 'Strategic intelligence provides high-level insights.', 1, 1),
    (2, 'IOCs are examples of technical intelligence.', 'true_false', 'IOCs are technical intelligence for detection.', 2, 1);

INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
VALUES 
    (4, 'Strategic Intelligence', TRUE, 1),
    (4, 'Technical Intelligence', FALSE, 2),
    (4, 'Tactical Intelligence', FALSE, 3),
    (4, 'Operational Intelligence', FALSE, 4),
    (5, 'True', TRUE, 1),
    (5, 'False', FALSE, 2);

-- ============================================================================
-- LEARNING PATH 6: SECURITY ARCHITECTURE & ZERO TRUST
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'Security Architecture & Zero Trust',
    'security-architecture-zero-trust',
    'Design secure systems and implement Zero Trust architecture.',
    'layers',
    6,
    38
);

-- Modules
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES
    (6, 'Security Architecture Fundamentals', 'Core principles of security architecture.', 1, 8),
    (6, 'Zero Trust Architecture', 'Implementing Zero Trust.', 2, 10),
    (6, 'Network Security Architecture', 'Designing secure networks.', 3, 8),
    (6, 'Identity-Centric Security', 'Building security around identity.', 4, 7),
    (6, 'Security Architecture Frameworks', 'SABSA, TOGAF frameworks.', 5, 5);

-- Sections
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (26, 'Principles of Secure Design', 'Fundamental security design principles.', 1),
    (26, 'Threat Modeling', 'Identifying threats during design.', 2),
    (26, 'Security Architecture Patterns', 'Common architectural patterns.', 3),
    (27, 'Zero Trust Principles', 'Core tenets of Zero Trust.', 1),
    (27, 'Implementing Zero Trust', 'Practical Zero Trust deployment.', 2),
    (27, 'Zero Trust Network Access', 'ZTNA solutions.', 3),
    (29, 'Identity as the New Perimeter', 'Identity-based security.', 1),
    (29, 'Privileged Access Management', 'Securing privileged accounts.', 2),
    (29, 'Identity Governance', 'Managing identity lifecycle.', 3);

-- Sample lessons with JSONB
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES 
    (22, 'Defense in Depth', 'Multiple layers of security controls.', 'text', 1, 20,
    '{"title": "Defense in Depth", "sections": [{"heading": "Layered Security", "content": "Implement multiple overlapping security controls."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 20, "tags": ["defense-in-depth"]}'::jsonb, 'json'),
    
    (22, 'Least Privilege Principle', 'Minimum necessary access rights.', 'text', 2, 15,
    '{"title": "Least Privilege", "sections": [{"heading": "Minimal Access", "content": "Grant only minimum required access rights."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 15, "tags": ["least-privilege"]}'::jsonb, 'json'),
    
    (23, 'STRIDE Threat Modeling', 'Systematic threat identification.', 'text', 1, 30,
    '{"title": "STRIDE", "sections": [{"heading": "STRIDE Framework", "content": "Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 30, "tags": ["stride"]}'::jsonb, 'json'),
    
    (24, 'Microservices Security', 'Securing distributed architectures.', 'text', 1, 25,
    '{"title": "Microservices Security", "sections": [{"heading": "Distributed Security", "content": "Service mesh, API gateways, inter-service authentication."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 25, "tags": ["microservices"]}'::jsonb, 'json'),
    
    (25, 'Never Trust, Always Verify', 'Zero Trust foundation.', 'text', 1, 20,
    '{"title": "Zero Trust Foundation", "sections": [{"heading": "Core Principle", "content": "Assume breach, verify explicitly, use least privilege."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["zero-trust"]}'::jsonb, 'json'),
    
    (26, 'Zero Trust Maturity Model', 'Assessing Zero Trust adoption.', 'text', 1, 25,
    '{"title": "Maturity Model", "sections": [{"heading": "Maturity Stages", "content": "Traditional, initial, advanced, optimal stages."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["maturity"]}'::jsonb, 'json'),
    
    (26, 'Micro-Segmentation', 'Granular network segmentation.', 'video', 2, 30,
    '{"title": "Micro-Segmentation", "videoUrl": "https://www.youtube.com/embed/micro-seg", "sections": [{"heading": "Granular Segmentation", "content": "Software-defined policies limiting lateral movement."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 30, "tags": ["segmentation"], "hasVideo": true}'::jsonb, 'json'),
    
    (27, 'ZTNA Solutions', 'Zero Trust Network Access vendors.', 'text', 1, 25,
    '{"title": "ZTNA Solutions", "sections": [{"heading": "ZTNA Vendors", "content": "Zscaler, Cloudflare Access, Palo Alto Prisma Access."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["ztna"]}'::jsonb, 'json'),
    
    (28, 'Identity-First Security Strategy', 'Building around identity.', 'text', 1, 20,
    '{"title": "Identity-First", "sections": [{"heading": "Identity Foundation", "content": "Build all controls around identity verification."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["identity"]}'::jsonb, 'json'),
    
    (29, 'PAM Best Practices', 'Securing privileged accounts.', 'text', 1, 25,
    '{"title": "PAM Best Practices", "sections": [{"heading": "Privileged Access", "content": "Password vaulting, session recording, just-in-time access."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 25, "tags": ["pam"]}'::jsonb, 'json');

-- Quiz
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts)
VALUES (22, 'Security Architecture Principles Quiz', 'Test your architecture knowledge.', 70, 15, 3);

INSERT INTO quiz_questions (quiz_id, question_text, question_type, explanation, order_index, points)
VALUES 
    (3, 'What is the core principle of Zero Trust?', 'multiple_choice', 'Never trust, always verify.', 1, 1),
    (3, 'Defense in depth means relying on multiple layers of security controls.', 'true_false', 'Defense in depth uses multiple overlapping controls.', 2, 1);

INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
VALUES 
    (6, 'Trust but verify', FALSE, 1),
    (6, 'Never trust, always verify', TRUE, 2),
    (6, 'Trust internal networks', FALSE, 3),
    (6, 'Verify once, trust forever', FALSE, 4),
    (7, 'True', TRUE, 1),
    (7, 'False', FALSE, 2);

-- ============================================================================
-- LEARNING PATH 7: AI SECURITY & ADVERSARIAL MACHINE LEARNING
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'AI Security & Adversarial ML',
    'ai-security-adversarial-ml',
    'Secure AI systems and defend against adversarial attacks.',
    'brain',
    7,
    35
);

-- Modules
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES
    (7, 'AI and ML Security Fundamentals', 'AI/ML security challenges.', 1, 7),
    (7, 'Adversarial Machine Learning', 'Defending against adversarial attacks.', 2, 9),
    (7, 'Model Security and Privacy', 'Protecting ML models and data.', 3, 8),
    (7, 'AI Governance and Ethics', 'Responsible AI development.', 4, 6),
    (7, 'Securing AI Systems', 'End-to-end AI/ML security.', 5, 5);

-- Sections
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (31, 'Introduction to AI Security', 'AI security considerations.', 1),
    (31, 'AI Threat Landscape', 'Common AI/ML attacks.', 2),
    (31, 'ML Pipeline Security', 'Securing ML development.', 3),
    (32, 'Types of Adversarial Attacks', 'Classification of attacks.', 1),
    (32, 'Generating Adversarial Examples', 'Creating adversarial inputs.', 2),
    (32, 'Defenses Against Adversarial Attacks', 'Mitigation methods.', 3),
    (33, 'Model Intellectual Property Protection', 'Protecting ML models.', 1),
    (33, 'Privacy-Preserving Machine Learning', 'Privacy-preserving techniques.', 2),
    (33, 'Membership Inference Attacks', 'Training data inference.', 3),
    (34, 'Responsible AI Development', 'Ethical AI principles.', 1),
    (34, 'Bias and Fairness in ML', 'Detecting and mitigating bias.', 2),
    (34, 'AI Regulations and Compliance', 'AI regulatory landscape.', 3);

-- Sample lessons with JSONB
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES 
    (31, 'Why AI Security Matters', 'AI systems are critical infrastructure.', 'text', 1, 20,
    '{"title": "AI Security Importance", "sections": [{"heading": "Critical Systems", "content": "AI systems have unique vulnerabilities with severe consequences."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 20, "tags": ["ai-security"]}'::jsonb, 'json'),
    
    (32, 'Adversarial Examples', 'Inputs that fool ML models.', 'text', 1, 25,
    '{"title": "Adversarial Examples", "sections": [{"heading": "Model Fooling", "content": "Subtle perturbations causing incorrect predictions."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["adversarial"]}'::jsonb, 'json'),
    
    (32, 'Model Poisoning Attacks', 'Corrupting training data.', 'video', 2, 30,
    '{"title": "Model Poisoning", "videoUrl": "https://www.youtube.com/embed/poisoning", "sections": [{"heading": "Data Corruption", "content": "Insert backdoors through corrupted training data."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 30, "tags": ["poisoning"], "hasVideo": true}'::jsonb, 'json'),
    
    (33, 'Securing Training Data', 'Data validation and sanitization.', 'text', 1, 20,
    '{"title": "Training Data Security", "sections": [{"heading": "Data Protection", "content": "Validate, sanitize, and track data provenance."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["data-security"]}'::jsonb, 'json'),
    
    (34, 'White-Box vs Black-Box Attacks', 'Attack types by knowledge level.', 'text', 1, 25,
    '{"title": "Attack Types", "sections": [{"heading": "Knowledge Levels", "content": "White-box has full knowledge, black-box uses queries only."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 25, "tags": ["attack-types"]}'::jsonb, 'json'),
    
    (35, 'FGSM and PGD Attacks', 'Gradient-based attack methods.', 'text', 1, 30,
    '{"title": "Gradient Attacks", "sections": [{"heading": "FGSM and PGD", "content": "Fast Gradient Sign Method and Projected Gradient Descent."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 30, "tags": ["fgsm", "pgd"]}'::jsonb, 'json'),
    
    (36, 'Adversarial Training', 'Training on adversarial examples.', 'text', 1, 25,
    '{"title": "Adversarial Training", "sections": [{"heading": "Robustness Training", "content": "Train models on adversarial examples for improved robustness."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 25, "tags": ["defense"]}'::jsonb, 'json'),
    
    (37, 'Model Watermarking', 'Embedding signatures in models.', 'text', 1, 20,
    '{"title": "Model Watermarking", "sections": [{"heading": "IP Protection", "content": "Embed identifiable signatures to prove ownership."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 20, "tags": ["watermarking"]}'::jsonb, 'json'),
    
    (38, 'Differential Privacy', 'Privacy-preserving data analysis.', 'text', 1, 30,
    '{"title": "Differential Privacy", "sections": [{"heading": "Privacy Framework", "content": "Add calibrated noise to protect individual privacy."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 30, "tags": ["privacy"]}'::jsonb, 'json'),
    
    (40, 'AI Ethics Principles', 'Fairness, accountability, transparency.', 'text', 1, 20,
    '{"title": "AI Ethics", "sections": [{"heading": "Ethical Principles", "content": "Build trustworthy AI with fairness, accountability, transparency."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["ethics"]}'::jsonb, 'json'),
    
    (41, 'Types of Bias in ML', 'Data, algorithmic, deployment bias.', 'text', 1, 25,
    '{"title": "ML Bias", "sections": [{"heading": "Bias Types", "content": "Data bias, algorithmic bias, and deployment bias."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["bias"]}'::jsonb, 'json'),
    
    (42, 'EU AI Act', 'European AI regulation.', 'text', 1, 20,
    '{"title": "EU AI Act", "sections": [{"heading": "AI Regulation", "content": "Risk-based approach to AI regulation in Europe."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["regulation"]}'::jsonb, 'json');

-- Quiz
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts)
VALUES (31, 'AI Security Fundamentals Quiz', 'Test your AI security knowledge.', 70, 15, 3);

INSERT INTO quiz_questions (quiz_id, question_text, question_type, explanation, order_index, points)
VALUES 
    (4, 'What is an adversarial example?', 'multiple_choice', 'An input designed to fool an ML model.', 1, 1),
    (4, 'Differential privacy adds noise to data to protect individual privacy.', 'true_false', 'Differential privacy uses calibrated noise for privacy.', 2, 1);

INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
VALUES 
    (8, 'A malicious ML model', FALSE, 1),
    (8, 'An input designed to fool an ML model', TRUE, 2),
    (8, 'A type of neural network', FALSE, 3),
    (8, 'A data poisoning attack', FALSE, 4),
    (9, 'True', TRUE, 1),
    (9, 'False', FALSE, 2);

-- ============================================================================
-- ADDITIONAL BADGES
-- ============================================================================

INSERT INTO badges (name, description, icon, badge_type, criteria, points)
VALUES 
    ('Threat Hunter', 'Complete Threat Intelligence & Hunting path', 'target', 'path', '{"type": "path_completion", "path_id": 5}', 500),
    ('Security Architect', 'Complete Security Architecture & Zero Trust path', 'blueprint', 'path', '{"type": "path_completion", "path_id": 6}', 500),
    ('AI Security Expert', 'Complete AI Security & Adversarial ML path', 'robot', 'path', '{"type": "path_completion", "path_id": 7}', 500);

-- Made with ❤️ by Bob - JSONB Edition

-- Made with Bob
