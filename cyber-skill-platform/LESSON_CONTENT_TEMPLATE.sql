-- ============================================================================
-- LESSON CONTENT TEMPLATE - CyberSkill Platform
-- ============================================================================
-- This file provides templates and examples for creating comprehensive lessons
-- with JSONB content. Copy and modify these templates for your content.
-- ============================================================================

-- ============================================================================
-- TEMPLATE 1: TEXT-BASED LESSON (Beginner Level)
-- ============================================================================
-- Use this for introductory lessons with explanations, lists, and basic concepts

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    1,  -- CHANGE THIS: section_id from your sections table
    'Introduction to Network Security',  -- CHANGE THIS: Lesson title
    'Learn the fundamentals of network security including firewalls, IDS/IPS, and network segmentation.',  -- CHANGE THIS: Brief description
    'text',
    1,  -- CHANGE THIS: Order within the section
    30,  -- CHANGE THIS: Estimated minutes to complete
    '{
        "title": "Introduction to Network Security",
        "sections": [
            {
                "heading": "What is Network Security?",
                "content": "Network security encompasses the policies, practices, and technologies designed to protect the integrity, confidentiality, and availability of computer networks and data. It involves both hardware and software technologies and targets a variety of threats to prevent them from entering or spreading on your network."
            },
            {
                "heading": "Key Components of Network Security",
                "content": "Network security consists of multiple layers of defense at the edge and within the network. Each layer implements policies and controls:",
                "list": [
                    "Firewalls: Control incoming and outgoing network traffic based on security rules",
                    "Intrusion Detection Systems (IDS): Monitor network traffic for suspicious activity",
                    "Intrusion Prevention Systems (IPS): Actively block detected threats",
                    "Virtual Private Networks (VPN): Secure remote access to the network",
                    "Network Segmentation: Divide network into separate zones for better control"
                ]
            },
            {
                "heading": "Why Network Security Matters",
                "content": "Organizations face numerous network-based threats:",
                "subsections": [
                    {
                        "subheading": "External Threats",
                        "content": "Hackers, malware, ransomware, and DDoS attacks targeting your network from outside the organization."
                    },
                    {
                        "subheading": "Internal Threats",
                        "content": "Insider threats, accidental data leaks, and compromised credentials from within the organization."
                    },
                    {
                        "subheading": "Business Impact",
                        "content": "Network breaches can result in data loss, financial damage, regulatory fines, and reputational harm."
                    }
                ]
            },
            {
                "heading": "Network Security Best Practices",
                "list": [
                    "Implement defense in depth with multiple security layers",
                    "Keep all network devices and software updated",
                    "Use strong authentication and access controls",
                    "Monitor network traffic continuously",
                    "Conduct regular security audits and penetration tests",
                    "Train employees on security awareness",
                    "Maintain incident response procedures"
                ]
            }
        ],
        "resources": [
            {
                "title": "NIST Cybersecurity Framework",
                "url": "https://www.nist.gov/cyberframework",
                "type": "documentation"
            },
            {
                "title": "SANS Network Security Resources",
                "url": "https://www.sans.org/network-security/",
                "type": "documentation"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "beginner",
        "estimatedMinutes": 30,
        "prerequisites": [],
        "learningObjectives": [
            "Define network security and its importance",
            "Identify key components of network security",
            "Understand common network threats",
            "Recognize network security best practices"
        ],
        "tags": ["network-security", "fundamentals", "firewalls", "ids-ips"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": false,
        "hasQuiz": false
    }'::jsonb,
    'json'
);

-- ============================================================================
-- TEMPLATE 2: LESSON WITH CODE EXAMPLES (Intermediate Level)
-- ============================================================================
-- Use this for technical lessons that include command-line examples or code

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    2,  -- CHANGE THIS: section_id
    'Nmap Network Scanning Techniques',  -- CHANGE THIS: Lesson title
    'Master Nmap scanning techniques for network reconnaissance and vulnerability discovery.',  -- CHANGE THIS: Brief description
    'text',
    2,  -- CHANGE THIS: Order within the section
    45,  -- CHANGE THIS: Estimated minutes
    '{
        "title": "Nmap Network Scanning Techniques",
        "sections": [
            {
                "heading": "Introduction to Nmap",
                "content": "Nmap (Network Mapper) is a free and open-source utility for network discovery and security auditing. It uses raw IP packets to determine what hosts are available on the network, what services those hosts are offering, what operating systems they are running, and what type of packet filters/firewalls are in use."
            },
            {
                "heading": "Basic Nmap Scans",
                "content": "Start with these fundamental Nmap scanning techniques:",
                "codeBlock": {
                    "language": "bash",
                    "code": "# Ping scan - discover live hosts\nnmap -sn 192.168.1.0/24\n\n# Basic port scan\nnmap 192.168.1.100\n\n# Scan specific ports\nnmap -p 80,443,8080 192.168.1.100\n\n# Scan port range\nnmap -p 1-1000 192.168.1.100\n\n# Scan all 65535 ports\nnmap -p- 192.168.1.100"
                }
            },
            {
                "heading": "Advanced Scanning Techniques",
                "content": "More sophisticated scans for detailed information:",
                "subsections": [
                    {
                        "subheading": "Service Version Detection",
                        "content": "Identify service versions running on open ports:",
                        "codeBlock": {
                            "language": "bash",
                            "code": "# Service version detection\nnmap -sV 192.168.1.100\n\n# Aggressive version detection\nnmap -sV --version-intensity 9 192.168.1.100"
                        }
                    },
                    {
                        "subheading": "Operating System Detection",
                        "content": "Determine the target operating system:",
                        "codeBlock": {
                            "language": "bash",
                            "code": "# OS detection (requires root/admin)\nsudo nmap -O 192.168.1.100\n\n# Aggressive OS detection\nsudo nmap -O --osscan-guess 192.168.1.100"
                        }
                    },
                    {
                        "subheading": "Stealth Scanning",
                        "content": "Perform scans that are harder to detect:",
                        "codeBlock": {
                            "language": "bash",
                            "code": "# SYN stealth scan\nsudo nmap -sS 192.168.1.100\n\n# FIN scan\nsudo nmap -sF 192.168.1.100\n\n# NULL scan\nsudo nmap -sN 192.168.1.100"
                        }
                    }
                ]
            },
            {
                "heading": "Nmap Scripting Engine (NSE)",
                "content": "Use NSE scripts for vulnerability detection and advanced reconnaissance:",
                "codeBlock": {
                    "language": "bash",
                    "code": "# Run default scripts\nnmap -sC 192.168.1.100\n\n# Run specific script category\nnmap --script vuln 192.168.1.100\n\n# Run specific script\nnmap --script http-sql-injection 192.168.1.100\n\n# List available scripts\nnmap --script-help \"*\""
                }
            },
            {
                "heading": "Scan Timing and Performance",
                "content": "Control scan speed and stealth:",
                "table": {
                    "headers": ["Timing Template", "Flag", "Description", "Use Case"],
                    "rows": [
                        ["-T0", "Paranoid", "Very slow, 5 min between probes", "IDS evasion"],
                        ["-T1", "Sneaky", "Slow, 15 sec between probes", "IDS evasion"],
                        ["-T2", "Polite", "Slows down to use less bandwidth", "Avoid network load"],
                        ["-T3", "Normal", "Default timing", "Normal scanning"],
                        ["-T4", "Aggressive", "Faster scan, assumes fast network", "Fast networks"],
                        ["-T5", "Insane", "Very fast, may miss results", "Very fast networks"]
                    ]
                }
            },
            {
                "heading": "Output Formats",
                "content": "Save scan results in various formats:",
                "codeBlock": {
                    "language": "bash",
                    "code": "# Normal output\nnmap -oN scan_results.txt 192.168.1.100\n\n# XML output\nnmap -oX scan_results.xml 192.168.1.100\n\n# Grepable output\nnmap -oG scan_results.gnmap 192.168.1.100\n\n# All formats\nnmap -oA scan_results 192.168.1.100"
                }
            },
            {
                "heading": "Practical Example: Complete Network Audit",
                "content": "Comprehensive scan combining multiple techniques:",
                "codeBlock": {
                    "language": "bash",
                    "code": "# Complete network audit scan\nsudo nmap -sS -sV -O -A -T4 \\\n  --script \"default,vuln\" \\\n  -p- \\\n  --open \\\n  -oA complete_audit \\\n  192.168.1.0/24\n\n# Explanation:\n# -sS: SYN stealth scan\n# -sV: Service version detection\n# -O: OS detection\n# -A: Aggressive scan (OS, version, script, traceroute)\n# -T4: Aggressive timing\n# --script: Run default and vulnerability scripts\n# -p-: Scan all 65535 ports\n# --open: Show only open ports\n# -oA: Output in all formats"
                }
            }
        ],
        "resources": [
            {
                "title": "Nmap Official Documentation",
                "url": "https://nmap.org/book/",
                "type": "documentation"
            },
            {
                "title": "Nmap NSE Scripts",
                "url": "https://nmap.org/nsedoc/",
                "type": "documentation"
            },
            {
                "title": "Nmap Cheat Sheet",
                "url": "https://www.stationx.net/nmap-cheat-sheet/",
                "type": "reference"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 45,
        "prerequisites": ["Introduction to Network Security", "Basic Linux Commands"],
        "learningObjectives": [
            "Execute basic and advanced Nmap scans",
            "Interpret Nmap scan results",
            "Use Nmap Scripting Engine for vulnerability detection",
            "Optimize scan timing and stealth",
            "Save and analyze scan outputs"
        ],
        "tags": ["nmap", "network-scanning", "reconnaissance", "penetration-testing"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": false
    }'::jsonb,
    'json'
);

-- ============================================================================
-- TEMPLATE 3: LESSON WITH HANDS-ON LAB (Advanced Level)
-- ============================================================================
-- Use this for practical lessons with step-by-step lab exercises

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    3,  -- CHANGE THIS: section_id
    'SQL Injection Attack Lab',  -- CHANGE THIS: Lesson title
    'Hands-on lab demonstrating SQL injection vulnerabilities and exploitation techniques.',  -- CHANGE THIS: Brief description
    'text',
    3,  -- CHANGE THIS: Order within the section
    60,  -- CHANGE THIS: Estimated minutes
    '{
        "title": "SQL Injection Attack Lab",
        "sections": [
            {
                "heading": "Lab Overview",
                "content": "In this hands-on lab, you will learn to identify and exploit SQL injection vulnerabilities in a web application. You will use various SQL injection techniques to bypass authentication, extract data, and understand how to prevent these attacks."
            },
            {
                "heading": "Understanding SQL Injection",
                "content": "SQL injection is a code injection technique that exploits security vulnerabilities in an applications database layer. Attackers can manipulate SQL queries by injecting malicious SQL code through user input fields.",
                "subsections": [
                    {
                        "subheading": "How SQL Injection Works",
                        "content": "When user input is directly concatenated into SQL queries without proper validation or parameterization, attackers can inject SQL commands that alter the query logic."
                    },
                    {
                        "subheading": "Types of SQL Injection",
                        "list": [
                            "In-band SQLi: Results displayed directly in the application",
                            "Blind SQLi: No direct output, infer results from application behavior",
                            "Out-of-band SQLi: Data retrieved through different channels (DNS, HTTP)"
                        ]
                    }
                ]
            },
            {
                "heading": "Lab Environment Setup",
                "lab": {
                    "title": "SQL Injection Exploitation Lab",
                    "objectives": [
                        "Identify SQL injection vulnerabilities",
                        "Bypass authentication using SQL injection",
                        "Extract database information",
                        "Understand prevention techniques"
                    ],
                    "prerequisites": [
                        "DVWA (Damn Vulnerable Web Application) installed",
                        "Burp Suite or similar proxy tool",
                        "Basic SQL knowledge"
                    ],
                    "environment": {
                        "target": "DVWA running on http://localhost/dvwa",
                        "tools": ["Burp Suite", "SQLMap", "Browser Developer Tools"],
                        "credentials": "admin/password"
                    },
                    "steps": [
                        {
                            "step": 1,
                            "title": "Setup and Initial Reconnaissance",
                            "task": "Access DVWA and navigate to SQL Injection page",
                            "instructions": "1. Open browser and go to http://localhost/dvwa\n2. Login with admin/password\n3. Set security level to Low\n4. Navigate to SQL Injection page",
                            "expectedOutput": "You should see a User ID input field"
                        },
                        {
                            "step": 2,
                            "title": "Test for SQL Injection Vulnerability",
                            "task": "Identify if the input is vulnerable to SQL injection",
                            "instructions": "Enter the following payloads in the User ID field:",
                            "commands": [
                                "1",
                                "1''",
                                "1'' OR ''1''=''1",
                                "1'' UNION SELECT NULL--"
                            ],
                            "expectedOutput": "Error messages or unexpected behavior indicates vulnerability"
                        },
                        {
                            "step": 3,
                            "title": "Determine Number of Columns",
                            "task": "Find the number of columns in the query result",
                            "instructions": "Use ORDER BY to determine column count:",
                            "commands": [
                                "1'' ORDER BY 1--",
                                "1'' ORDER BY 2--",
                                "1'' ORDER BY 3--"
                            ],
                            "expectedOutput": "Error when ORDER BY exceeds column count (likely 2 columns)"
                        },
                        {
                            "step": 4,
                            "title": "Extract Database Information",
                            "task": "Use UNION SELECT to extract database metadata",
                            "instructions": "Inject UNION queries to extract information:",
                            "commands": [
                                "1'' UNION SELECT NULL, database()--",
                                "1'' UNION SELECT NULL, version()--",
                                "1'' UNION SELECT NULL, user()--",
                                "1'' UNION SELECT table_name, NULL FROM information_schema.tables--"
                            ],
                            "expectedOutput": "Database name, version, and table names displayed"
                        },
                        {
                            "step": 5,
                            "title": "Extract User Credentials",
                            "task": "Retrieve usernames and passwords from users table",
                            "instructions": "Extract user data:",
                            "commands": [
                                "1'' UNION SELECT user, password FROM users--",
                                "1'' UNION SELECT CONCAT(user,'':'',password), NULL FROM users--"
                            ],
                            "expectedOutput": "List of usernames and password hashes"
                        },
                        {
                            "step": 6,
                            "title": "Automated Exploitation with SQLMap",
                            "task": "Use SQLMap to automate the exploitation",
                            "instructions": "Run SQLMap against the vulnerable parameter:",
                            "command": "sqlmap -u \"http://localhost/dvwa/vulnerabilities/sqli/?id=1&Submit=Submit\" --cookie=\"security=low; PHPSESSID=your_session_id\" --dbs",
                            "expectedOutput": "SQLMap identifies vulnerability and lists databases"
                        },
                        {
                            "step": 7,
                            "title": "Prevention Techniques",
                            "task": "Understand how to prevent SQL injection",
                            "instructions": "Review prevention methods:",
                            "codeBlock": {
                                "language": "php",
                                "code": "// VULNERABLE CODE\n$query = \"SELECT * FROM users WHERE id = ''\" . $_GET[''id''] . \"''\";\n\n// SECURE CODE - Prepared Statements\n$stmt = $pdo->prepare(\"SELECT * FROM users WHERE id = ?\");\n$stmt->execute([$_GET[''id'']]);\n\n// SECURE CODE - Parameterized Query\n$stmt = $mysqli->prepare(\"SELECT * FROM users WHERE id = ?\");\n$stmt->bind_param(\"i\", $_GET[''id'']);\n$stmt->execute();"
                            }
                        }
                    ],
                    "deliverables": [
                        "Screenshot of successful SQL injection",
                        "List of extracted database tables",
                        "Extracted user credentials",
                        "SQLMap output showing vulnerability",
                        "Brief report documenting findings"
                    ],
                    "challenges": [
                        {
                            "title": "Challenge 1: Blind SQL Injection",
                            "description": "Set DVWA security to Medium and exploit using blind SQL injection techniques",
                            "hint": "Use time-based or boolean-based blind SQL injection"
                        },
                        {
                            "title": "Challenge 2: WAF Bypass",
                            "description": "Set security to High and bypass the Web Application Firewall",
                            "hint": "Try encoding, case variation, and comment injection"
                        }
                    ]
                }
            },
            {
                "heading": "Prevention Best Practices",
                "content": "Protect your applications from SQL injection:",
                "list": [
                    "Use parameterized queries (prepared statements)",
                    "Implement input validation and sanitization",
                    "Apply principle of least privilege for database accounts",
                    "Use stored procedures with proper parameterization",
                    "Implement Web Application Firewall (WAF)",
                    "Regular security testing and code reviews",
                    "Keep database software updated",
                    "Use ORM frameworks with built-in protection"
                ]
            },
            {
                "heading": "Real-World Impact",
                "content": "SQL injection remains one of the most dangerous web vulnerabilities:",
                "table": {
                    "headers": ["Year", "Incident", "Impact"],
                    "rows": [
                        ["2023", "MOVEit Transfer", "Millions of records exposed"],
                        ["2021", "Accellion FTA", "100+ organizations breached"],
                        ["2019", "Capital One", "100 million customer records stolen"],
                        ["2017", "Equifax", "147 million records compromised"]
                    ]
                }
            }
        ],
        "resources": [
            {
                "title": "OWASP SQL Injection Guide",
                "url": "https://owasp.org/www-community/attacks/SQL_Injection",
                "type": "documentation"
            },
            {
                "title": "PortSwigger SQL Injection Cheat Sheet",
                "url": "https://portswigger.net/web-security/sql-injection/cheat-sheet",
                "type": "reference"
            },
            {
                "title": "SQLMap Documentation",
                "url": "https://github.com/sqlmapproject/sqlmap/wiki",
                "type": "documentation"
            },
            {
                "title": "DVWA Setup Guide",
                "url": "https://github.com/digininja/DVWA",
                "type": "tool"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "estimatedMinutes": 60,
        "prerequisites": [
            "Basic SQL knowledge",
            "Web application fundamentals",
            "HTTP request/response understanding"
        ],
        "learningObjectives": [
            "Identify SQL injection vulnerabilities",
            "Execute various SQL injection attacks",
            "Use automated tools like SQLMap",
            "Extract sensitive data from databases",
            "Implement SQL injection prevention techniques"
        ],
        "tags": ["sql-injection", "web-security", "owasp-top-10", "hands-on-lab", "dvwa"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);

-- ============================================================================
-- TEMPLATE 4: VIDEO LESSON WITH TRANSCRIPT
-- ============================================================================
-- Use this for lessons that include video content

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    4,  -- CHANGE THIS: section_id
    'Zero Trust Architecture Explained',  -- CHANGE THIS: Lesson title
    'Comprehensive video lesson on Zero Trust security model and implementation strategies.',  -- CHANGE THIS: Brief description
    'video',
    4,  -- CHANGE THIS: Order within the section
    35,  -- CHANGE THIS: Estimated minutes
    '{
        "title": "Zero Trust Architecture Explained",
        "videoUrl": "https://www.youtube.com/embed/VIDEO_ID_HERE",
        "videoDuration": "25:30",
        "chapters": [
            {"time": "0:00", "title": "Introduction to Zero Trust"},
            {"time": "3:15", "title": "Traditional vs Zero Trust Security"},
            {"time": "8:45", "title": "Core Principles of Zero Trust"},
            {"time": "15:20", "title": "Implementation Strategies"},
            {"time": "21:00", "title": "Real-World Examples"}
        ],
        "sections": [
            {
                "heading": "Video Overview",
                "content": "This video provides a comprehensive introduction to Zero Trust Architecture, explaining why traditional perimeter-based security is no longer sufficient and how Zero Trust provides a more robust security model for modern organizations."
            },
            {
                "heading": "Key Takeaways",
                "list": [
                    "Zero Trust assumes breach and verifies every access request",
                    "Never trust, always verify - regardless of network location",
                    "Least privilege access is fundamental to Zero Trust",
                    "Continuous monitoring and validation are essential",
                    "Identity becomes the new security perimeter"
                ]
            },
            {
                "heading": "Video Transcript Summary",
                "subsections": [
                    {
                        "subheading": "Introduction (0:00 - 3:15)",
                        "content": "The video begins by explaining the evolution of cybersecurity from castle-and-moat to Zero Trust. Traditional security models assumed everything inside the network perimeter was trustworthy, but modern threats require a different approach."
                    },
                    {
                        "subheading": "Core Principles (8:45 - 15:20)",
                        "content": "The presenter explains the three core principles: 1) Verify explicitly using all available data points, 2) Use least privilege access with just-in-time and just-enough-access, 3) Assume breach and minimize blast radius through segmentation."
                    },
                    {
                        "subheading": "Implementation (15:20 - 21:00)",
                        "content": "Practical implementation strategies are discussed, including identity-centric security, micro-segmentation, continuous monitoring, and the Zero Trust maturity model."
                    }
                ]
            },
            {
                "heading": "Additional Resources",
                "content": "Supplement your learning with these resources:",
                "list": [
                    "NIST SP 800-207: Zero Trust Architecture",
                    "Microsoft Zero Trust Deployment Guide",
                    "Google BeyondCorp Papers",
                    "Forrester Zero Trust eXtended (ZTX) Framework"
                ]
            },
            {
                "heading": "Discussion Questions",
                "content": "After watching the video, consider these questions:",
                "list": [
                    "How does Zero Trust differ from your current security model?",
                    "What are the biggest challenges in implementing Zero Trust?",
                    "Which Zero Trust principle is most important for your organization?",
                    "How would you measure Zero Trust maturity?"
                ]
            }
        ],
        "resources": [
            {
                "title": "NIST Zero Trust Architecture",
                "url": "https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf",
                "type": "documentation"
            },
            {
                "title": "Microsoft Zero Trust Guidance",
                "url": "https://www.microsoft.com/en-us/security/business/zero-trust",
                "type": "documentation"
            },
            {
                "title": "Google BeyondCorp",
                "url": "https://cloud.google.com/beyondcorp",
                "type": "case-study"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 35,
        "prerequisites": ["Security Architecture Fundamentals", "Network Security Basics"],
        "learningObjectives": [
            "Explain the Zero Trust security model",
            "Compare Zero Trust with traditional perimeter security",
            "Identify the core principles of Zero Trust",
            "Understand Zero Trust implementation strategies",
            "Assess Zero Trust maturity levels"
        ],
        "tags": ["zero-trust", "security-architecture", "identity-security", "video-lesson"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": true,
        "hasLab": false,
        "hasQuiz": true
    }'::jsonb,
    'json'
);

-- ============================================================================
-- TEMPLATE 5: CASE STUDY LESSON
-- ============================================================================
-- Use this for lessons analyzing real-world incidents or scenarios

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    5,  -- CHANGE THIS: section_id
    'Case Study: SolarWinds Supply Chain Attack',  -- CHANGE THIS: Lesson title
    'Detailed analysis of the SolarWinds supply chain attack, one of the most sophisticated cyber espionage campaigns in history.',  -- CHANGE THIS: Brief description
    'text',
    5,  -- CHANGE THIS: Order within the section
    50,  -- CHANGE THIS: Estimated minutes
    '{
        "title": "Case Study: SolarWinds Supply Chain Attack",
        "sections": [
            {
                "heading": "Executive Summary",
                "content": "In December 2020, the cybersecurity world discovered one of the most sophisticated and far-reaching cyberattacks in history. The SolarWinds supply chain attack, attributed to Russian state-sponsored actors (APT29/Cozy Bear), compromised the software build system of SolarWinds Orion platform, affecting approximately 18,000 customers including multiple U.S. government agencies and Fortune 500 companies."
            },
            {
                "heading": "Attack Timeline",
                "table": {
                    "headers": ["Date", "Event", "Significance"],
                    "rows": [
                        ["Sept 2019", "Initial compromise of SolarWinds network", "Attackers gain access to build environment"],
                        ["Oct 2019 - Feb 2020", "Reconnaissance and preparation", "Attackers study build process and plan injection"],
                        ["March 2020", "SUNBURST backdoor injected", "Malicious code inserted into Orion updates"],
                        ["March - June 2020", "Trojanized updates distributed", "18,000+ customers receive compromised software"],
                        ["Dec 13, 2020", "FireEye discovers breach", "Public disclosure begins"],
                        ["Dec 2020 - Jan 2021", "Investigation and remediation", "Scope of breach becomes clear"]
                    ]
                }
            },
            {
                "heading": "Attack Methodology",
                "subsections": [
                    {
                        "subheading": "Phase 1: Initial Access",
                        "content": "Attackers gained access to SolarWinds network through unknown means, possibly through:",
                        "list": [
                            "Compromised credentials",
                            "Exploitation of internet-facing systems",
                            "Social engineering",
                            "Third-party vendor compromise"
                        ]
                    },
                    {
                        "subheading": "Phase 2: Build System Compromise",
                        "content": "Once inside, attackers targeted the software build environment:",
                        "list": [
                            "Studied the Orion build process",
                            "Identified injection points in the build pipeline",
                            "Developed SUNBURST backdoor to evade detection",
                            "Tested malicious code in isolated environment"
                        ]
                    },
                    {
                        "subheading": "Phase 3: Supply Chain Injection",
                        "content": "The SUNBURST backdoor was injected into legitimate Orion software updates:",
                        "codeBlock": {
                            "language": "text",
                            "code": "Compromised File: SolarWinds.Orion.Core.BusinessLayer.dll\nBackdoor Name: SUNBURST (also known as Solorigate)\nDistribution: Digitally signed updates via official channels\nAffected Versions: Orion Platform 2019.4 HF 5 through 2020.2.1"
                        }
                    },
                    {
                        "subheading": "Phase 4: Victim Selection and Exploitation",
                        "content": "After deployment, SUNBURST performed reconnaissance and selective activation:",
                        "list": [
                            "Dormant period of 12-14 days to evade sandbox analysis",
                            "Checked for security tools and analysis environments",
                            "Communicated with C2 servers via DNS",
                            "Selectively activated only for high-value targets",
                            "Deployed additional tools (TEARDROP, RAINDROP) for persistence"
                        ]
                    }
                ]
            },
            {
                "heading": "Technical Analysis",
                "subsections": [
                    {
                        "subheading": "SUNBURST Backdoor Capabilities",
                        "list": [
                            "File operations (read, write, delete, execute)",
                            "Registry manipulation",
                            "Process creation and termination",
                            "System profiling and reconnaissance",
                            "Lateral movement preparation",
                            "C2 communication via DNS and HTTP"
                        ]
                    },
                    {
                        "subheading": "Evasion Techniques",
                        "list": [
                            "Legitimate code signing with SolarWinds certificate",
                            "Dormancy period to avoid sandbox detection",
                            "Blocklist of security tools and analysis environments",
                            "Domain generation algorithm (DGA) for C2",
                            "Minimal network footprint",
                            "Blending with legitimate Orion traffic"
                        ]
                    }
                ]
            },
            {
                "heading": "Impact Assessment",
                "content": "The attack had unprecedented scope and impact:",
                "table": {
                    "headers": ["Category", "Impact", "Details"],
                    "rows": [
                        ["Scale", "~18,000 organizations", "Received trojanized updates"],
                        ["Confirmed Breaches", "~100 organizations", "Confirmed compromise by attackers"],
                        ["Government Impact", "9 U.S. agencies", "Including Treasury, Commerce, DHS"],
                        ["Private Sector", "Fortune 500 companies", "Microsoft, Cisco, Intel, others"],
                        ["Duration", "9+ months", "From injection to discovery"],
                        ["Remediation Cost", "Billions of dollars", "Industry-wide response"]
                    ]
                }
            },
            {
                "heading": "Lessons Learned",
                "subsections": [
                    {
                        "subheading": "For Software Vendors",
                        "list": [
                            "Implement secure software development lifecycle (SSDLC)",
                            "Protect build environments with Zero Trust principles",
                            "Use code signing with hardware security modules (HSM)",
                            "Implement build integrity verification",
                            "Monitor build systems for anomalies",
                            "Conduct regular security audits of build pipeline"
                        ]
                    },
                    {
                        "subheading": "For Organizations",
                        "list": [
                            "Implement supply chain risk management",
                            "Monitor software updates for anomalies",
                            "Use network segmentation to limit blast radius",
                            "Deploy endpoint detection and response (EDR)",
                            "Maintain comprehensive logging and monitoring",
                            "Develop incident response plans for supply chain attacks"
                        ]
                    },
                    {
                        "subheading": "For the Industry",
                        "list": [
                            "Develop supply chain security standards",
                            "Improve software bill of materials (SBOM) practices",
                            "Enhance threat intelligence sharing",
                            "Invest in supply chain security research",
                            "Create regulatory frameworks for software security"
                        ]
                    }
                ]
            },
            {
                "heading": "Prevention and Detection",
                "content": "How to protect against similar attacks:",
                "subsections": [
                    {
                        "subheading": "Prevention Measures",
                        "list": [
                            "Zero Trust architecture for build environments",
                            "Multi-factor authentication for all access",
                            "Privileged access management (PAM)",
                            "Network segmentation and micro-segmentation",
                            "Regular security assessments and penetration testing",
                            "Vendor security assessments"
                        ]
                    },
                    {
                        "subheading": "Detection Strategies",
                        "list": [
                            "Behavioral analytics for anomaly detection",
                            "DNS monitoring for C2 communication",
                            "File integrity monitoring",
                            "Network traffic analysis",
                            "Endpoint detection and response (EDR)",
                            "Threat hunting programs"
                        ]
                    }
                ]
            },
            {
                "heading": "Discussion Questions",
                "list": [
                    "How could SolarWinds have prevented this attack?",
                    "What detection mechanisms might have identified the breach earlier?",
                    "How should organizations balance trust in vendors with security?",
                    "What role should government play in supply chain security?",
                    "How has this attack changed your approach to vendor risk management?"
                ]
            }
        ],
        "resources": [
            {
                "title": "CISA SolarWinds Analysis",
                "url": "https://www.cisa.gov/uscert/ncas/alerts/aa20-352a",
                "type": "documentation"
            },
            {
                "title": "FireEye SUNBURST Analysis",
                "url": "https://www.fireeye.com/blog/threat-research/2020/12/evasive-attacker-leverages-solarwinds-supply-chain-compromises-with-sunburst-backdoor.html",
                "type": "analysis"
            },
            {
                "title": "Microsoft SolarWinds Response",
                "url": "https://www.microsoft.com/security/blog/2020/12/18/analyzing-solorigate-the-compromised-dll-file-that-started-a-sophisticated-cyberattack-and-how-microsoft-defender-helps-protect/",
                "type": "analysis"
            },
            {
                "title": "MITRE ATT&CK: SolarWinds Compromise",
                "url": "https://attack.mitre.org/campaigns/C0024/",
                "type": "reference"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "estimatedMinutes": 50,
        "prerequisites": [
            "Supply chain security concepts",
            "Threat intelligence fundamentals",
            "APT tactics and techniques"
        ],
        "learningObjectives": [
            "Analyze the SolarWinds supply chain attack methodology",
            "Understand supply chain attack vectors",
            "Identify prevention and detection strategies",
            "Apply lessons learned to organizational security",
            "Assess supply chain risk in your environment"
        ],
        "tags": ["case-study", "supply-chain-attack", "apt29", "sunburst", "incident-analysis"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": false,
        "hasQuiz": true
    }'::jsonb,
    'json'
);

-- ============================================================================
-- INSTRUCTIONS FOR CONTENT CREATORS
-- ============================================================================
-- 
-- 1. Choose the appropriate template based on lesson type:
--    - Template 1: Basic text lessons with explanations
--    - Template 2: Technical lessons with code examples
--    - Template 3: Hands-on labs with step-by-step instructions
--    - Template 4: Video lessons with transcripts
--    - Template 5: Case studies and real-world analysis
--
-- 2. Update these fields for each lesson:
--    - section_id: Get from your sections table
--    - name: Clear, descriptive lesson title
--    - content: Brief 1-2 sentence description
--    - order_index: Position within the section
--    - estimated_minutes: Realistic time to complete
--
-- 3. Customize the content_json:
--    - title: Same as lesson name
--    - sections: Array of content sections
--    - Each section can include:
--      * heading: Section title
--      * content: Main text content
--      * list: Bullet points
--      * subsections: Nested content
--      * codeBlock: Code examples with syntax highlighting
--      * table: Tabular data
--      * lab: Hands-on exercise with steps
--    - resources: External links and references
--
-- 4. Set appropriate metadata:
--    - difficulty: beginner, intermediate, or advanced
--    - estimatedMinutes: Match the lesson duration
--    - prerequisites: Array of required prior knowledge
--    - learningObjectives: What students will learn
--    - tags: Keywords for search and categorization
--    - hasVideo, hasLab, hasQuiz: Boolean flags
--
-- 5. Quality checklist:
--    ✓ Clear learning objectives
--    ✓ Structured content with headings
--    ✓ Practical examples where applicable
--    ✓ External resources for further learning
--    ✓ Consistent formatting
--    ✓ Accurate estimated time
--    ✓ Appropriate difficulty level
--    ✓ Relevant tags for discoverability
--
-- 6. Testing:
--    - Verify JSON syntax is valid
--    - Test SQL insertion in development environment
--    - Review content rendering in application
--    - Validate all links and resources
--
-- ============================================================================

-- Made with Bob
