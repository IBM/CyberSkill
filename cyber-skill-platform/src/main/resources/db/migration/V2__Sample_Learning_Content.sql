-- CyberSkill Platform - Sample Learning Content with JSONB
-- Version: 2.0.0
-- Description: Inserts sample learning paths, modules, sections, and lessons with JSONB content

-- ============================================================================
-- LEARNING PATH 1: PENETRATION TESTING
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'Penetration Testing',
    'penetration-testing',
    'Master the art of ethical hacking and penetration testing. Learn to identify vulnerabilities, exploit systems, and secure networks.',
    'shield-check',
    1,
    40
);

-- Modules for Penetration Testing
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES 
    (1, 'Introduction to Penetration Testing', 'Understand the fundamentals of penetration testing, methodologies, and legal considerations.', 1, 8),
    (1, 'Reconnaissance and Information Gathering', 'Learn techniques for gathering intelligence about target systems and networks.', 2, 8),
    (1, 'Vulnerability Assessment', 'Identify and analyze security vulnerabilities in systems and applications.', 3, 8),
    (1, 'Exploitation Techniques', 'Master various exploitation methods and tools used in penetration testing.', 4, 10),
    (1, 'Post-Exploitation and Reporting', 'Learn post-exploitation techniques and how to document findings professionally.', 5, 6);

-- Sections for Module 1: Introduction to Penetration Testing
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (1, 'What is Penetration Testing?', 'Overview of penetration testing and its importance in cybersecurity.', 1),
    (1, 'Penetration Testing Methodologies', 'Learn industry-standard methodologies like PTES, OWASP, and OSSTMM.', 2),
    (1, 'Legal and Ethical Considerations', 'Understand the legal framework and ethical guidelines for penetration testing.', 3);

-- Lesson 1: Introduction to Ethical Hacking (JSONB Content)
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    1,
    'Introduction to Ethical Hacking',
    'Ethical hacking is the practice of testing computer systems, networks, or applications to find security vulnerabilities that malicious hackers could exploit.',
    'text',
    1,
    15,
    '{
        "title": "Introduction to Ethical Hacking",
        "sections": [
            {
                "heading": "What is Ethical Hacking?",
                "content": "Ethical hacking, also known as penetration testing or white-hat hacking, is the practice of intentionally probing computer systems, networks, and applications to discover security vulnerabilities before malicious actors can exploit them. Ethical hackers use the same tools and techniques as cybercriminals, but with authorization and the goal of improving security."
            },
            {
                "heading": "The Role of Ethical Hackers",
                "content": "Ethical hackers play a crucial role in modern cybersecurity by:",
                "list": [
                    "Identifying security weaknesses before they can be exploited",
                    "Testing the effectiveness of security controls",
                    "Validating compliance with security policies",
                    "Providing actionable recommendations for remediation",
                    "Helping organizations understand their security posture"
                ]
            },
            {
                "heading": "Key Principles",
                "content": "Ethical hacking is guided by several fundamental principles:",
                "subsections": [
                    {
                        "subheading": "Authorization",
                        "content": "Always obtain written permission before testing any system. Unauthorized access is illegal, regardless of intent."
                    },
                    {
                        "subheading": "Scope Definition",
                        "content": "Clearly define what systems, networks, and applications are in scope for testing. Never exceed the agreed-upon boundaries."
                    },
                    {
                        "subheading": "Confidentiality",
                        "content": "Maintain strict confidentiality of all findings and sensitive information discovered during testing."
                    },
                    {
                        "subheading": "Responsible Disclosure",
                        "content": "Report vulnerabilities responsibly to the organization and allow time for remediation before public disclosure."
                    }
                ]
            },
            {
                "heading": "Career Opportunities",
                "content": "The field of ethical hacking offers diverse career paths including penetration tester, security consultant, bug bounty hunter, and security researcher. The demand for skilled ethical hackers continues to grow as organizations recognize the importance of proactive security testing."
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "beginner",
        "estimatedMinutes": 15,
        "prerequisites": [],
        "learningObjectives": [
            "Define ethical hacking and its purpose",
            "Understand the role of ethical hackers in cybersecurity",
            "Recognize key principles guiding ethical hacking",
            "Identify career opportunities in ethical hacking"
        ],
        "tags": ["ethical-hacking", "introduction", "cybersecurity", "career"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0"
    }'::jsonb,
    'json'
);

-- Lesson 2: Types of Penetration Tests (JSONB Content)
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    2,
    'Types of Penetration Tests',
    'Learn about different types of penetration tests including black box, white box, and gray box testing.',
    'text',
    2,
    20,
    '{
        "title": "Types of Penetration Tests",
        "sections": [
            {
                "heading": "Overview",
                "content": "Penetration tests can be categorized based on the amount of information provided to the tester and the testing approach. Each type has its advantages and is suited for different scenarios."
            },
            {
                "heading": "Black Box Testing",
                "content": "In black box testing, the penetration tester has no prior knowledge of the target system. This approach simulates an external attacker with no insider information.",
                "subsections": [
                    {
                        "subheading": "Characteristics",
                        "list": [
                            "No prior knowledge of infrastructure",
                            "Simulates real-world external attack",
                            "Tests external security controls",
                            "Longer testing time required"
                        ]
                    },
                    {
                        "subheading": "Best Used For",
                        "list": [
                            "Testing external-facing systems",
                            "Evaluating perimeter security",
                            "Simulating opportunistic attacks",
                            "Compliance requirements"
                        ]
                    }
                ]
            },
            {
                "heading": "White Box Testing",
                "content": "White box testing provides the tester with complete knowledge of the target system, including source code, architecture diagrams, and credentials.",
                "subsections": [
                    {
                        "subheading": "Characteristics",
                        "list": [
                            "Full system knowledge provided",
                            "Access to source code and documentation",
                            "Comprehensive security assessment",
                            "More efficient use of testing time"
                        ]
                    },
                    {
                        "subheading": "Best Used For",
                        "list": [
                            "Thorough security audits",
                            "Code review and analysis",
                            "Internal security assessments",
                            "Pre-deployment testing"
                        ]
                    }
                ]
            },
            {
                "heading": "Gray Box Testing",
                "content": "Gray box testing provides partial knowledge of the system, typically simulating an insider threat or a compromised user account.",
                "subsections": [
                    {
                        "subheading": "Characteristics",
                        "list": [
                            "Limited system knowledge",
                            "User-level access provided",
                            "Balances realism and efficiency",
                            "Tests internal security controls"
                        ]
                    },
                    {
                        "subheading": "Best Used For",
                        "list": [
                            "Simulating insider threats",
                            "Testing privilege escalation",
                            "Evaluating internal segmentation",
                            "Realistic attack scenarios"
                        ]
                    }
                ]
            },
            {
                "heading": "Comparison Table",
                "table": {
                    "headers": ["Aspect", "Black Box", "White Box", "Gray Box"],
                    "rows": [
                        ["Knowledge Level", "None", "Complete", "Partial"],
                        ["Testing Time", "Longest", "Shortest", "Medium"],
                        ["Realism", "High", "Low", "Medium"],
                        ["Coverage", "External", "Comprehensive", "Targeted"],
                        ["Cost", "Higher", "Lower", "Medium"]
                    ]
                }
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "beginner",
        "estimatedMinutes": 20,
        "prerequisites": ["Introduction to Ethical Hacking"],
        "learningObjectives": [
            "Differentiate between black box, white box, and gray box testing",
            "Understand when to use each testing approach",
            "Compare advantages and disadvantages of each type",
            "Select appropriate testing methodology for different scenarios"
        ],
        "tags": ["penetration-testing", "methodologies", "black-box", "white-box", "gray-box"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0"
    }'::jsonb,
    'json'
);

-- Lesson 3: Penetration Testing Tools Overview (JSONB Content with Video)
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    3,
    'Penetration Testing Tools Overview',
    'Introduction to essential penetration testing tools including Kali Linux, Metasploit, Burp Suite, and Nmap.',
    'video',
    3,
    25,
    '{
        "title": "Penetration Testing Tools Overview",
        "videoUrl": "https://www.youtube.com/embed/3Kq1MIfTWCE",
        "sections": [
            {
                "heading": "Essential Penetration Testing Tools",
                "content": "Professional penetration testers rely on a comprehensive toolkit to identify and exploit vulnerabilities. This lesson introduces the most important tools in the penetration testing arsenal."
            },
            {
                "heading": "Kali Linux",
                "content": "Kali Linux is the industry-standard penetration testing distribution, pre-loaded with hundreds of security tools.",
                "subsections": [
                    {
                        "subheading": "Key Features",
                        "list": [
                            "600+ pre-installed security tools",
                            "Regular updates and tool additions",
                            "Customizable and lightweight",
                            "Extensive documentation and community support"
                        ]
                    },
                    {
                        "subheading": "Common Use Cases",
                        "list": [
                            "Network reconnaissance",
                            "Vulnerability scanning",
                            "Exploitation and post-exploitation",
                            "Password cracking and forensics"
                        ]
                    }
                ],
                "codeBlock": {
                    "language": "bash",
                    "code": "# Update Kali Linux\nsudo apt update && sudo apt upgrade -y\n\n# Install additional tools\nsudo apt install metasploit-framework\n\n# Launch Metasploit\nmsfconsole"
                }
            },
            {
                "heading": "Metasploit Framework",
                "content": "Metasploit is the world''s most popular penetration testing framework, providing tools for discovering, exploiting, and validating vulnerabilities.",
                "subsections": [
                    {
                        "subheading": "Core Components",
                        "list": [
                            "Exploits: Pre-built attack modules",
                            "Payloads: Code executed after exploitation",
                            "Auxiliary: Scanning and fuzzing modules",
                            "Post: Post-exploitation modules"
                        ]
                    }
                ],
                "codeBlock": {
                    "language": "bash",
                    "code": "# Start Metasploit console\nmsfconsole\n\n# Search for exploits\nmsf6 > search type:exploit platform:windows\n\n# Use an exploit\nmsf6 > use exploit/windows/smb/ms17_010_eternalblue\n\n# Set target and payload\nmsf6 exploit(ms17_010_eternalblue) > set RHOSTS 192.168.1.100\nmsf6 exploit(ms17_010_eternalblue) > set PAYLOAD windows/x64/meterpreter/reverse_tcp\nmsf6 exploit(ms17_010_eternalblue) > exploit"
                }
            },
            {
                "heading": "Burp Suite",
                "content": "Burp Suite is the leading web application security testing tool, essential for finding vulnerabilities in web applications.",
                "subsections": [
                    {
                        "subheading": "Key Features",
                        "list": [
                            "Intercepting proxy for HTTP/HTTPS traffic",
                            "Web vulnerability scanner",
                            "Intruder for automated attacks",
                            "Repeater for manual testing",
                            "Extensive plugin ecosystem"
                        ]
                    },
                    {
                        "subheading": "Common Vulnerabilities Detected",
                        "list": [
                            "SQL Injection",
                            "Cross-Site Scripting (XSS)",
                            "Cross-Site Request Forgery (CSRF)",
                            "Authentication bypass",
                            "Session management flaws"
                        ]
                    }
                ]
            },
            {
                "heading": "Nmap",
                "content": "Nmap (Network Mapper) is the industry standard for network discovery and security auditing.",
                "codeBlock": {
                    "language": "bash",
                    "code": "# Basic host discovery\nnmap -sn 192.168.1.0/24\n\n# Port scan with service detection\nnmap -sV -p- 192.168.1.100\n\n# OS detection and aggressive scan\nnmap -A -T4 192.168.1.100\n\n# Vulnerability scan with NSE scripts\nnmap --script vuln 192.168.1.100\n\n# Stealth SYN scan\nsudo nmap -sS -p 1-65535 192.168.1.100"
                },
                "subsections": [
                    {
                        "subheading": "Scan Types",
                        "table": {
                            "headers": ["Scan Type", "Flag", "Description"],
                            "rows": [
                                ["TCP SYN", "-sS", "Stealth scan, doesn''t complete TCP handshake"],
                                ["TCP Connect", "-sT", "Full TCP connection scan"],
                                ["UDP", "-sU", "Scan UDP ports"],
                                ["Service Version", "-sV", "Detect service versions"],
                                ["OS Detection", "-O", "Identify operating system"]
                            ]
                        }
                    }
                ]
            },
            {
                "heading": "Tool Comparison",
                "table": {
                    "headers": ["Tool", "Primary Use", "Skill Level", "Platform"],
                    "rows": [
                        ["Kali Linux", "Complete testing environment", "Intermediate", "Linux"],
                        ["Metasploit", "Exploitation framework", "Advanced", "Cross-platform"],
                        ["Burp Suite", "Web application testing", "Intermediate", "Cross-platform"],
                        ["Nmap", "Network scanning", "Beginner", "Cross-platform"]
                    ]
                }
            },
            {
                "heading": "Hands-On Lab",
                "lab": {
                    "title": "Basic Network Reconnaissance",
                    "objectives": [
                        "Install and configure Kali Linux",
                        "Perform network discovery with Nmap",
                        "Identify open ports and services",
                        "Document findings"
                    ],
                    "steps": [
                        {
                            "step": 1,
                            "task": "Set up Kali Linux virtual machine",
                            "instructions": "Download Kali Linux from official website and install in VirtualBox or VMware"
                        },
                        {
                            "step": 2,
                            "task": "Discover live hosts",
                            "command": "nmap -sn 192.168.1.0/24",
                            "expectedOutput": "List of active hosts on the network"
                        },
                        {
                            "step": 3,
                            "task": "Scan a target host",
                            "command": "nmap -sV -p- <target-ip>",
                            "expectedOutput": "Open ports and running services"
                        },
                        {
                            "step": 4,
                            "task": "Run vulnerability scan",
                            "command": "nmap --script vuln <target-ip>",
                            "expectedOutput": "Potential vulnerabilities identified"
                        }
                    ],
                    "deliverables": [
                        "Screenshot of Nmap scan results",
                        "List of discovered hosts and services",
                        "Brief report of findings"
                    ]
                }
            }
        ],
        "resources": [
            {
                "title": "Kali Linux Official Documentation",
                "url": "https://www.kali.org/docs/",
                "type": "documentation"
            },
            {
                "title": "Metasploit Unleashed",
                "url": "https://www.offensive-security.com/metasploit-unleashed/",
                "type": "course"
            },
            {
                "title": "Burp Suite Documentation",
                "url": "https://portswigger.net/burp/documentation",
                "type": "documentation"
            },
            {
                "title": "Nmap Network Scanning",
                "url": "https://nmap.org/book/",
                "type": "book"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 25,
        "prerequisites": ["Introduction to Ethical Hacking", "Types of Penetration Tests"],
        "learningObjectives": [
            "Identify essential penetration testing tools",
            "Understand the purpose and capabilities of each tool",
            "Execute basic commands in Kali Linux, Metasploit, and Nmap",
            "Perform basic network reconnaissance"
        ],
        "tags": ["tools", "kali-linux", "metasploit", "burp-suite", "nmap", "hands-on"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": true,
        "hasLab": true
    }'::jsonb,
    'json'
);

-- ============================================================================
-- LEARNING PATH 2: COMPLIANCE
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'Compliance',
    'compliance',
    'Navigate the complex world of cybersecurity compliance. Master GDPR, ISO 27001, SOC 2, and other critical frameworks.',
    'clipboard-check',
    2,
    35
);

-- Modules for Compliance
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES 
    (2, 'Introduction to Compliance', 'Understand the importance of compliance in cybersecurity and business operations.', 1, 6),
    (2, 'GDPR and Data Protection', 'Master the General Data Protection Regulation and data protection principles.', 2, 8),
    (2, 'ISO 27001 Information Security', 'Learn the ISO 27001 standard for information security management systems.', 3, 8),
    (2, 'SOC 2 and Trust Services', 'Understand SOC 2 compliance and trust service criteria.', 4, 7),
    (2, 'Industry-Specific Compliance', 'Explore PCI DSS, HIPAA, and other industry-specific compliance requirements.', 5, 6);

-- Sections for Module 1: Introduction to Compliance
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (6, 'Why Compliance Matters', 'Understand the business and legal importance of compliance.', 1),
    (6, 'Compliance Frameworks Overview', 'Survey of major compliance frameworks and standards.', 2),
    (6, 'Building a Compliance Program', 'Steps to establish and maintain an effective compliance program.', 3);

-- Compliance Lessons with JSONB content
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES 
    (4, 'The Business Case for Compliance', 'Compliance is not just about avoiding fines. Learn how compliance can be a competitive advantage and build customer trust.', 'text', 1, 15,
    '{"title": "The Business Case for Compliance", "sections": [{"heading": "Beyond Avoiding Fines", "content": "While regulatory penalties are a concern, compliance offers strategic business benefits including enhanced reputation, customer trust, competitive advantage, and operational efficiency."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 15, "tags": ["compliance", "business", "strategy"]}'::jsonb, 'json'),
    
    (5, 'Major Compliance Frameworks', 'Overview of GDPR, ISO 27001, SOC 2, PCI DSS, HIPAA, and other major frameworks.', 'text', 2, 20,
    '{"title": "Major Compliance Frameworks", "sections": [{"heading": "Overview", "content": "Understanding the landscape of compliance frameworks is essential for any organization handling sensitive data or operating in regulated industries."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 20, "tags": ["compliance", "frameworks", "gdpr", "iso27001"]}'::jsonb, 'json'),
    
    (6, 'Implementing a Compliance Program', 'Step-by-step guide to building and maintaining a compliance program in your organization.', 'video', 3, 30,
    '{"title": "Implementing a Compliance Program", "videoUrl": "https://www.youtube.com/embed/compliance-example", "sections": [{"heading": "Getting Started", "content": "Building a compliance program requires executive support, clear policies, and ongoing monitoring."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 30, "tags": ["compliance", "implementation", "program-management"], "hasVideo": true}'::jsonb, 'json');

-- ============================================================================
-- LEARNING PATH 3: DATA SECURITY
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'Data Security',
    'data-security',
    'Protect sensitive data throughout its lifecycle. Learn encryption, access controls, and data loss prevention strategies.',
    'lock',
    3,
    30
);

-- Modules for Data Security
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES 
    (3, 'Data Security Fundamentals', 'Core concepts of data security and protection.', 1, 6),
    (3, 'Encryption and Cryptography', 'Master encryption techniques and cryptographic principles.', 2, 8),
    (3, 'Access Control and Authentication', 'Implement robust access control and authentication mechanisms.', 3, 7),
    (3, 'Data Loss Prevention', 'Strategies and tools for preventing data breaches and leaks.', 4, 6),
    (3, 'Secure Data Storage and Transmission', 'Best practices for storing and transmitting sensitive data.', 5, 3);

-- Sections for Module 1: Data Security Fundamentals
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (11, 'Understanding Data Classification', 'Learn how to classify and categorize data based on sensitivity.', 1),
    (11, 'Data Lifecycle Management', 'Manage data security throughout its entire lifecycle.', 2),
    (11, 'Regulatory Requirements', 'Understand data security requirements in various regulations.', 3);

-- Data Security Lessons with JSONB content
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES 
    (7, 'Data Classification Principles', 'Learn how to classify data as public, internal, confidential, or restricted based on sensitivity and impact.', 'text', 1, 20,
    '{"title": "Data Classification Principles", "sections": [{"heading": "Why Classify Data?", "content": "Data classification helps organizations apply appropriate security controls based on data sensitivity and business impact."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 20, "tags": ["data-security", "classification", "governance"]}'::jsonb, 'json'),
    
    (8, 'The Data Lifecycle', 'Understand the stages of data lifecycle: creation, storage, use, sharing, archiving, and destruction.', 'text', 2, 15,
    '{"title": "The Data Lifecycle", "sections": [{"heading": "Lifecycle Stages", "content": "Data moves through distinct stages from creation to destruction, each requiring specific security controls."}]}'::jsonb,
    '{"difficulty": "beginner", "estimatedMinutes": 15, "tags": ["data-security", "lifecycle", "management"]}'::jsonb, 'json'),
    
    (9, 'GDPR and Data Security', 'How GDPR requirements impact data security practices and implementations.', 'video', 3, 25,
    '{"title": "GDPR and Data Security", "videoUrl": "https://www.youtube.com/embed/gdpr-example", "sections": [{"heading": "GDPR Requirements", "content": "GDPR mandates specific technical and organizational measures to protect personal data."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 25, "tags": ["data-security", "gdpr", "compliance"], "hasVideo": true}'::jsonb, 'json');

-- ============================================================================
-- LEARNING PATH 4: POST-QUANTUM COMPUTING
-- ============================================================================

INSERT INTO learning_paths (name, slug, description, icon, order_index, estimated_hours)
VALUES (
    'Post-Quantum Computing',
    'post-quantum-computing',
    'Prepare for the quantum computing era. Learn about quantum threats and post-quantum cryptography solutions.',
    'atom',
    4,
    25
);

-- Modules for Post-Quantum Computing
INSERT INTO modules (learning_path_id, name, description, order_index, estimated_hours)
VALUES 
    (4, 'Introduction to Quantum Computing', 'Understand quantum computing basics and its implications for security.', 1, 5),
    (4, 'Quantum Threats to Cryptography', 'Learn how quantum computers threaten current cryptographic systems.', 2, 6),
    (4, 'Post-Quantum Cryptography', 'Explore quantum-resistant cryptographic algorithms and standards.', 3, 8),
    (4, 'Migration Strategies', 'Plan and execute migration to post-quantum cryptography.', 4, 4),
    (4, 'Future of Quantum Security', 'Emerging trends and future developments in quantum security.', 5, 2);

-- Sections for Module 1: Introduction to Quantum Computing
INSERT INTO sections (module_id, name, description, order_index)
VALUES 
    (16, 'Quantum Computing Basics', 'Fundamental concepts of quantum computing.', 1),
    (16, 'Quantum vs Classical Computing', 'Key differences between quantum and classical computing.', 2),
    (16, 'Quantum Computing Timeline', 'Current state and future projections of quantum computing.', 3);

-- Post-Quantum Computing Lessons with JSONB content
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES 
    (10, 'What is Quantum Computing?', 'Introduction to quantum bits (qubits), superposition, and entanglement. Understand how quantum computers differ from classical computers.', 'text', 1, 20,
    '{"title": "What is Quantum Computing?", "sections": [{"heading": "Quantum Fundamentals", "content": "Quantum computing leverages quantum mechanical phenomena like superposition and entanglement to perform computations impossible for classical computers."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 20, "tags": ["quantum-computing", "qubits", "fundamentals"]}'::jsonb, 'json'),
    
    (11, 'Quantum Supremacy and Its Implications', 'Learn about quantum supremacy achievements and what they mean for cybersecurity.', 'text', 2, 15,
    '{"title": "Quantum Supremacy and Its Implications", "sections": [{"heading": "What is Quantum Supremacy?", "content": "Quantum supremacy refers to the point where quantum computers can solve problems that classical computers cannot solve in any reasonable timeframe."}]}'::jsonb,
    '{"difficulty": "intermediate", "estimatedMinutes": 15, "tags": ["quantum-computing", "quantum-supremacy", "security"]}'::jsonb, 'json'),
    
    (12, 'Timeline to Quantum Threat', 'When will quantum computers pose a real threat to current encryption? Expert predictions and preparations.', 'video', 3, 20,
    '{"title": "Timeline to Quantum Threat", "videoUrl": "https://www.youtube.com/embed/quantum-threat-example", "sections": [{"heading": "The Quantum Threat Timeline", "content": "Experts predict that quantum computers capable of breaking current encryption may emerge within 10-15 years, requiring immediate preparation."}]}'::jsonb,
    '{"difficulty": "advanced", "estimatedMinutes": 20, "tags": ["quantum-computing", "cryptography", "threat-assessment"], "hasVideo": true}'::jsonb, 'json');

-- ============================================================================
-- SAMPLE QUIZZES
-- ============================================================================

-- Quiz for Section 1 (Penetration Testing - What is Penetration Testing?)
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts)
VALUES (1, 'Introduction to Penetration Testing Quiz', 'Test your understanding of penetration testing fundamentals.', 70, 15, 3);

-- Questions for Quiz 1
INSERT INTO quiz_questions (quiz_id, question_text, question_type, explanation, order_index, points)
VALUES 
    (1, 'What is the primary goal of penetration testing?', 'multiple_choice', 'The primary goal is to identify security vulnerabilities before malicious actors can exploit them.', 1, 1),
    (1, 'Penetration testing is illegal without proper authorization.', 'true_false', 'Unauthorized penetration testing is illegal and can result in criminal charges.', 2, 1),
    (1, 'Which of the following are types of penetration testing? (Select all that apply)', 'multi_select', 'Black box, white box, and gray box are all valid types of penetration testing.', 3, 2);

-- Options for Question 1
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
VALUES 
    (1, 'To identify and exploit security vulnerabilities', TRUE, 1),
    (1, 'To damage the target system', FALSE, 2),
    (1, 'To steal sensitive data', FALSE, 3),
    (1, 'To install malware', FALSE, 4);

-- Options for Question 2
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
VALUES 
    (2, 'True', TRUE, 1),
    (2, 'False', FALSE, 2);

-- Options for Question 3
INSERT INTO quiz_options (question_id, option_text, is_correct, order_index)
VALUES 
    (3, 'Black box testing', TRUE, 1),
    (3, 'White box testing', TRUE, 2),
    (3, 'Gray box testing', TRUE, 3),
    (3, 'Rainbow box testing', FALSE, 4);

-- ============================================================================
-- SAMPLE BADGES
-- ============================================================================

INSERT INTO badges (name, description, icon, badge_type, criteria, points)
VALUES 
    ('First Steps', 'Complete your first lesson', 'star', 'special', '{"type": "lesson_completion", "count": 1}', 10),
    ('Quick Learner', 'Complete 5 lessons in one day', 'lightning', 'special', '{"type": "daily_lessons", "count": 5}', 25),
    ('Section Master', 'Complete all lessons in a section', 'trophy', 'section', '{"type": "section_completion"}', 50),
    ('Module Champion', 'Complete all sections in a module', 'medal', 'module', '{"type": "module_completion"}', 100),
    ('Path Conqueror', 'Complete an entire learning path', 'crown', 'path', '{"type": "path_completion"}', 500),
    ('Perfect Score', 'Score 100% on a quiz', 'target', 'special', '{"type": "quiz_perfect", "score": 100}', 75),
    ('Persistent Learner', 'Log in for 7 consecutive days', 'calendar', 'special', '{"type": "login_streak", "days": 7}', 50);

-- ============================================================================
-- ANALYTICS SEED DATA
-- ============================================================================

-- Sample user activity for the test user (for demonstration)
INSERT INTO user_activity (user_id, activity_type, entity_type, entity_id, metadata)
VALUES 
    (2, 'login', NULL, NULL, '{"ip": "127.0.0.1", "user_agent": "Mozilla/5.0"}'),
    (2, 'view_lesson', 'lesson', 1, '{"duration_seconds": 300}'),
    (2, 'complete_lesson', 'lesson', 1, '{"time_spent_seconds": 900}');

-- Made with ❤️ by Bob - JSONB Edition

-- Made with Bob
