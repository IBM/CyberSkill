





-- Intermediate Lessons for Threat Intelligence & Hunting
-- These correspond to the expanded section IDs:

-- Intermediate Section IDs: 22–26
--Section 22 — Threat Intelligence Platforms (TIPs)

--Section 23 — Indicators of Compromise (IOCs)

--Section 24 — Threat Data Normalization & Enrichment

--Section 25 — Threat Actor TTP Analysis

-- Section 26 — Building Threat Intelligence Reports

-- 🧩 Lesson (Section 22): Threat Intelligence Platforms (Intermediate)

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    22,
    'Threat Intelligence Platforms (TIPs)',
    'Learn how Threat Intelligence Platforms aggregate, normalize, and operationalize threat data for security teams.',
    'text',
    1,
    45,
    '{
        "title": "Threat Intelligence Platforms (TIPs)",
        "sections": [
            {
                "heading": "What is a Threat Intelligence Platform?",
                "content": "A Threat Intelligence Platform (TIP) is a centralized system that aggregates threat data from multiple sources, enriches it, and distributes actionable intelligence to security tools and teams."
            },
            {
                "heading": "Core Functions of TIPs",
                "list": [
                    "Aggregation of threat feeds and OSINT sources",
                    "Normalization and correlation of threat data",
                    "IOC enrichment using internal and external sources",
                    "Integration with SIEM, SOAR, and EDR tools",
                    "Automated intelligence sharing"
                ]
            },
            {
                "heading": "Common TIP Solutions",
                "table": {
                    "headers": ["Platform", "Strengths", "Use Cases"],
                    "rows": [
                        ["MISP", "Open-source, community-driven", "IOC sharing, threat research"],
                        ["Anomali", "Enterprise-grade analytics", "Threat correlation, SOC automation"],
                        ["ThreatConnect", "Robust integrations", "Operational and strategic intelligence"],
                        ["OpenCTI", "Graph-based intelligence modeling", "APT tracking, knowledge management"]
                    ]
                }
            },
            {
                "heading": "TIP Integrations",
                "content": "TIPs integrate with multiple security tools to operationalize intelligence:",
                "list": [
                    "SIEM (Splunk, Sentinel, QRadar)",
                    "SOAR platforms",
                    "EDR/XDR solutions",
                    "Firewall and IDS/IPS systems",
                    "Email security gateways"
                ]
            },
            {
                "heading": "Benefits of Using a TIP",
                "list": [
                    "Improved detection accuracy",
                    "Faster incident response",
                    "Reduced analyst workload",
                    "Better visibility into threat actor behavior",
                    "Centralized intelligence management"
                ]
            }
        ],
        "resources": [
            {
                "title": "MISP Documentation",
                "url": "https://www.misp-project.org/documentation/",
                "type": "documentation"
            },
            {
                "title": "OpenCTI Platform",
                "url": "https://www.opencti.io",
                "type": "documentation"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 45,
        "prerequisites": ["Introduction to Threat Intelligence", "Types of Threat Intelligence"],
        "learningObjectives": [
            "Understand the purpose of Threat Intelligence Platforms",
            "Identify common TIP solutions and their strengths",
            "Explain how TIPs integrate with security tools",
            "Recognize the benefits of TIP adoption"
        ],
        "tags": ["threat-intelligence", "TIP", "MISP", "OpenCTI"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);
--- 🧩 Lesson (Section 23): Indicators of Compromise (IOCs) — Intermediate
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    24,
    'Threat Data Normalization & Enrichment',
    'Learn how to normalize, enrich, and contextualize threat intelligence data to improve detection and response accuracy.',
    'text',
    1,
    50,
    '{
        "title": "Threat Data Normalization & Enrichment",
        "sections": [
            {
                "heading": "Why Normalization Matters",
                "content": "Threat data comes from diverse sources with inconsistent formats. Normalization ensures that indicators, attributes, and metadata follow a consistent structure for analysis and automation."
            },
            {
                "heading": "Normalization Techniques",
                "list": [
                    "Standardizing IOC formats (IP, hash, domain)",
                    "Mapping fields to a common schema (STIX, OpenCTI)",
                    "Removing duplicates and stale indicators",
                    "Applying consistent timestamp formats",
                    "Tagging indicators with threat categories"
                ]
            },
            {
                "heading": "What is Threat Enrichment?",
                "content": "Enrichment adds context to raw threat data, making it more actionable for analysts and automated systems."
            },
            {
                "heading": "Common Enrichment Sources",
                "subsections": [
                    {
                        "subheading": "Reputation Services",
                        "content": "Check if an IOC is known malicious using services like VirusTotal or AbuseIPDB."
                    },
                    {
                        "subheading": "Passive DNS",
                        "content": "Identify historical domain-IP relationships to uncover infrastructure."
                    },
                    {
                        "subheading": "WHOIS Data",
                        "content": "Reveal domain ownership, registration dates, and hosting providers."
                    },
                    {
                        "subheading": "Threat Actor Associations",
                        "content": "Link indicators to known APT groups or malware families."
                    }
                ]
            },
            {
                "heading": "Normalization & Enrichment Workflow",
                "table": {
                    "headers": ["Step", "Description", "Tools"],
                    "rows": [
                        ["1. Ingest", "Collect raw threat data", "TIPs, OSINT feeds"],
                        ["2. Normalize", "Standardize formats and fields", "STIX/TAXII, MISP"],
                        ["3. Enrich", "Add context and metadata", "VirusTotal, PassiveTotal"],
                        ["4. Correlate", "Identify relationships and clusters", "OpenCTI, Maltego"],
                        ["5. Distribute", "Share with SOC tools", "SIEM, SOAR"]
                    ]
                }
            }
        ],
        "resources": [
            {
                "title": "STIX 2.1 Specification",
                "url": "https://oasis-open.github.io/cti-documentation/stix/intro",
                "type": "documentation"
            },
            {
                "title": "PassiveTotal Documentation",
                "url": "https://community.riskiq.com",
                "type": "tool"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 50,
        "prerequisites": ["Indicators of Compromise (IOCs)"],
        "learningObjectives": [
            "Explain the importance of threat data normalization",
            "Perform enrichment using common intelligence sources",
            "Understand the normalization and enrichment workflow",
            "Apply enrichment to improve detection accuracy"
        ],
        "tags": ["threat-intelligence", "enrichment", "normalization", "STIX"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🧩 Lesson (Section 24): Threat Data Normalization & Enrichment — Intermediate
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    23,
    'Indicators of Compromise (IOCs)',
    'Learn how to identify, classify, enrich, and operationalize Indicators of Compromise in threat intelligence workflows.',
    'text',
    1,
    50,
    '{
        "title": "Indicators of Compromise (IOCs)",
        "sections": [
            {
                "heading": "What Are IOCs?",
                "content": "Indicators of Compromise are forensic artifacts that suggest a system or network may have been breached. They are used to detect malicious activity and support incident response."
            },
            {
                "heading": "Types of IOCs",
                "list": [
                    "File Hashes (MD5, SHA1, SHA256)",
                    "IP Addresses",
                    "Domain Names",
                    "URLs",
                    "Registry Keys",
                    "File Paths",
                    "Email Addresses",
                    "Mutexes"
                ]
            },
            {
                "heading": "IOC Quality and Scoring",
                "content": "Not all IOCs are equal. Analysts evaluate IOCs using:",
                "list": [
                    "Confidence score",
                    "Freshness / age",
                    "Source reliability",
                    "Contextual relevance",
                    "Associated threat actor or campaign"
                ]
            },
            {
                "heading": "IOC Enrichment",
                "content": "Enrichment adds context to raw indicators:",
                "subsections": [
                    {
                        "subheading": "Passive DNS",
                        "content": "Shows historical domain-IP relationships."
                    },
                    {
                        "subheading": "WHOIS Data",
                        "content": "Provides domain ownership and registration details."
                    },
                    {
                        "subheading": "Reputation Services",
                        "content": "Checks if an IOC is known malicious."
                    }
                ]
            },
            {
                "heading": "Operationalizing IOCs",
                "content": "IOCs are used across security tools:",
                "list": [
                    "SIEM correlation rules",
                    "Firewall blocklists",
                    "EDR detection logic",
                    "Email filtering",
                    "SOAR playbooks"
                ]
            }
        ],
        "resources": [
            {
                "title": "STIX/TAXII Standards",
                "url": "https://oasis-open.github.io/cti-documentation/",
                "type": "documentation"
            },
            {
                "title": "VirusTotal Intelligence",
                "url": "https://www.virustotal.com",
                "type": "tool"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 50,
        "prerequisites": ["Introduction to Threat Intelligence"],
        "learningObjectives": [
            "Identify different types of IOCs",
            "Evaluate IOC quality and scoring",
            "Perform IOC enrichment",
            "Operationalize IOCs across security tools"
        ],
        "tags": ["IOC", "threat-hunting", "incident-response"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🧩 Lesson (Section 25): Threat Actor TTP Analysis — Intermediate

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    25,
    'Threat Actor TTP Analysis',
    'Learn how to analyze threat actor tactics, techniques, and procedures (TTPs) using frameworks like MITRE ATT&CK.',
    'text',
    1,
    55,
    '{
        "title": "Threat Actor TTP Analysis",
        "sections": [
            {
                "heading": "What Are TTPs?",
                "content": "Tactics, Techniques, and Procedures (TTPs) describe how threat actors operate. They provide deeper insight than simple IOCs and help analysts understand attacker behavior."
            },
            {
                "heading": "MITRE ATT&CK Overview",
                "content": "MITRE ATT&CK is a globally recognized framework that categorizes adversary behaviors across the attack lifecycle.",
                "list": [
                    "Tactics: The attacker’s goals (e.g., Initial Access, Persistence)",
                    "Techniques: How the goal is achieved (e.g., phishing, credential dumping)",
                    "Sub-techniques: More granular variations of techniques"
                ]
            },
            {
                "heading": "Why TTP Analysis Matters",
                "list": [
                    "Improves detection engineering",
                    "Supports threat hunting",
                    "Enhances attribution accuracy",
                    "Strengthens incident response",
                    "Enables proactive defense"
                ]
            },
            {
                "heading": "Analyzing Threat Actor Behavior",
                "subsections": [
                    {
                        "subheading": "Campaign Analysis",
                        "content": "Identify recurring patterns across multiple attacks."
                    },
                    {
                        "subheading": "Infrastructure Analysis",
                        "content": "Track domains, IPs, and hosting patterns used by threat actors."
                    },
                    {
                        "subheading": "Malware Analysis",
                        "content": "Map malware capabilities to ATT&CK techniques."
                    }
                ]
            },
            {
                "heading": "TTP Correlation Example",
                "table": {
                    "headers": ["Threat Actor", "Technique", "Tactic", "Description"],
                    "rows": [
                        ["APT29", "Spearphishing Attachment (T1566.001)", "Initial Access", "Delivers malware via malicious documents"],
                        ["FIN7", "Credential Dumping (T1003)", "Credential Access", "Extracts credentials using LSASS memory"],
                        ["Lazarus Group", "Command and Control (T1071)", "C2", "Uses custom encrypted channels"]
                    ]
                }
            }
        ],
        "resources": [
            {
                "title": "MITRE ATT&CK Navigator",
                "url": "https://mitre-attack.github.io/attack-navigator/",
                "type": "tool"
            },
            {
                "title": "Threat Actor Encyclopedia",
                "url": "https://attack.mitre.org/groups/",
                "type": "documentation"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 55,
        "prerequisites": ["MITRE ATT&CK Framework"],
        "learningObjectives": [
            "Understand the structure of TTPs",
            "Analyze threat actor behavior using ATT&CK",
            "Correlate TTPs across campaigns",
            "Apply TTP analysis to threat hunting"
        ],
        "tags": ["TTP", "MITRE-ATTACK", "threat-actors", "APT"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🧩 Lesson (Section 26): Building Threat Intelligence Reports — Intermediate

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    26,
    'Building Threat Intelligence Reports',
    'Learn how to structure, write, and deliver high-quality threat intelligence reports for SOC teams, leadership, and external stakeholders.',
    'text',
    1,
    60,
    '{
        "title": "Building Threat Intelligence Reports",
        "sections": [
            {
                "heading": "Purpose of Threat Intelligence Reports",
                "content": "Threat intelligence reports communicate findings, analysis, and recommendations to stakeholders. They support decision-making, incident response, and long-term defense planning."
            },
            {
                "heading": "Types of TI Reports",
                "list": [
                    "Tactical Reports: Immediate threats, IOCs, detection guidance",
                    "Operational Reports: Campaign analysis, infrastructure mapping",
                    "Strategic Reports: High-level trends, geopolitical context, risk assessments"
                ]
            },
            {
                "heading": "Key Components of a TI Report",
                "subsections": [
                    {
                        "subheading": "Executive Summary",
                        "content": "High-level overview for leadership."
                    },
                    {
                        "subheading": "Threat Overview",
                        "content": "Description of threat actor, malware, or campaign."
                    },
                    {
                        "subheading": "Analysis",
                        "content": "Deep dive into TTPs, infrastructure, and motivations."
                    },
                    {
                        "subheading": "Indicators",
                        "content": "List of IOCs with context and confidence scores."
                    },
                    {
                        "subheading": "Recommendations",
                        "content": "Actionable defensive measures."
                    }
                ]
            },
            {
                "heading": "Writing Best Practices",
                "list": [
                    "Be concise and avoid jargon",
                    "Use evidence-based analysis",
                    "Include visualizations where possible",
                    "Provide clear recommendations",
                    "Tailor content to the audience"
                ]
            },
            {
                "heading": "Example Report Structure",
                "table": {
                    "headers": ["Section", "Description"],
                    "rows": [
                        ["Executive Summary", "High-level overview of findings"],
                        ["Threat Actor Profile", "Background and known activity"],
                        ["TTP Analysis", "Mapped to MITRE ATT&CK"],
                        ["IOC List", "Indicators with context"],
                        ["Impact Assessment", "Potential business impact"],
                        ["Recommendations", "Mitigation and detection guidance"]
                    ]
                }
            }
        ],
        "resources": [
            {
                "title": "ENISA Threat Landscape Reports",
                "url": "https://www.enisa.europa.eu/topics/threat-risk-management/threats-and-trends",
                "type": "documentation"
            },
            {
                "title": "Recorded Future Intelligence Reports",
                "url": "https://www.recordedfuture.com",
                "type": "reference"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "estimatedMinutes": 60,
        "prerequisites": ["Threat Actor TTP Analysis"],
        "learningObjectives": [
            "Understand the purpose of TI reports",
            "Differentiate between tactical, operational, and strategic reports",
            "Structure a professional TI report",
            "Apply best practices for intelligence writing"
        ],
        "tags": ["threat-reports", "intelligence-writing", "analysis"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🧠 Advanced Lesson (Section 27): Advanced Threat Hunting


INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    27,
    'Advanced Threat Hunting',
    'Learn advanced threat hunting methodologies, detection engineering, and hypothesis-driven investigation techniques.',
    'text',
    1,
    70,
    '{
        "title": "Advanced Threat Hunting",
        "sections": [
            {
                "heading": "What Makes Threat Hunting Advanced?",
                "content": "Advanced threat hunting moves beyond reactive detection and focuses on uncovering stealthy, unknown, or novel threats using behavioral analytics, hypothesis-driven investigation, and deep telemetry analysis."
            },
            {
                "heading": "Hunting Maturity Model (HMM)",
                "content": "The Hunting Maturity Model defines an organization’s ability to proactively detect threats:",
                "table": {
                    "headers": ["Level", "Description"],
                    "rows": [
                        ["HMM0", "No hunting capability; fully reactive"],
                        ["HMM1", "Basic hunting using manual queries"],
                        ["HMM2", "Repeatable hunting with documented processes"],
                        ["HMM3", "Automated hunting with analytics"],
                        ["HMM4", "Full hunting program with continuous improvement"]
                    ]
                }
            },
            {
                "heading": "Hypothesis-Driven Hunting",
                "content": "Hunters form hypotheses based on threat intelligence, TTPs, and environmental knowledge.",
                "subsections": [
                    {
                        "subheading": "Example Hypothesis",
                        "content": "“APT29 is known to use credential dumping via LSASS. We will hunt for suspicious LSASS access patterns.”"
                    },
                    {
                        "subheading": "Data Required",
                        "list": [
                            "Process creation logs",
                            "Memory access telemetry",
                            "EDR behavioral alerts"
                        ]
                    }
                ]
            },
            {
                "heading": "Behavioral Analytics",
                "content": "Behavior-based hunting focuses on attacker actions rather than static indicators.",
                "list": [
                    "Unusual parent-child process relationships",
                    "Abnormal authentication patterns",
                    "Suspicious PowerShell or WMI usage",
                    "Lateral movement behavior"
                ]
            },
            {
                "heading": "Hunting Queries (Examples)",
                "codeBlock": {
                    "language": "kql",
                    "code": "// Detect suspicious LSASS access\nSecurityEvent\n| where EventID == 10 and ProcessName contains \"lsass\"\n\n// Detect encoded PowerShell commands\nDeviceProcessEvents\n| where FileName == \"powershell.exe\" and ProcessCommandLine contains \"-enc\""
                }
            }
        ],
        "resources": [
            {
                "title": "Hunting Maturity Model (Sqrrl)",
                "url": "https://sqrrl.com/hunting-maturity-model",
                "type": "documentation"
            },
            {
                "title": "Microsoft Threat Hunting Queries",
                "url": "https://learn.microsoft.com/azure/sentinel/hunting",
                "type": "documentation"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "estimatedMinutes": 70,
        "prerequisites": ["Threat Hunting Fundamentals", "TTP Analysis"],
        "learningObjectives": [
            "Apply hypothesis-driven hunting",
            "Use behavioral analytics for detection",
            "Understand the Hunting Maturity Model",
            "Write advanced hunting queries"
        ],
        "tags": ["threat-hunting", "advanced", "behavioral-analytics"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🧬 Advanced Lesson (Section 28): Malware Behavior Analysis

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    28,
    'Malware Behavior Analysis',
    'Analyze malware behavior, execution flow, persistence mechanisms, and command-and-control patterns.',
    'text',
    1,
    75,
    '{
        "title": "Malware Behavior Analysis",
        "sections": [
            {
                "heading": "Static vs Dynamic Analysis",
                "list": [
                    "Static Analysis: Examining malware without executing it",
                    "Dynamic Analysis: Observing malware behavior during execution"
                ]
            },
            {
                "heading": "Common Malware Behaviors",
                "list": [
                    "Process injection",
                    "Persistence creation",
                    "Credential harvesting",
                    "C2 communication",
                    "Privilege escalation"
                ]
            },
            {
                "heading": "Persistence Mechanisms",
                "table": {
                    "headers": ["Technique", "Description"],
                    "rows": [
                        ["Registry Run Keys", "Executes malware at startup"],
                        ["Scheduled Tasks", "Creates recurring execution"],
                        ["Service Installation", "Runs malware as a system service"],
                        ["DLL Hijacking", "Loads malicious DLLs via trusted apps"]
                    ]
                }
            },
            {
                "heading": "Command and Control (C2) Patterns",
                "subsections": [
                    {
                        "subheading": "HTTP/HTTPS C2",
                        "content": "Most common; blends with normal traffic."
                    },
                    {
                        "subheading": "DNS Tunneling",
                        "content": "Encodes data in DNS queries."
                    },
                    {
                        "subheading": "Custom Encrypted Channels",
                        "content": "Used by APT groups to evade detection."
                    }
                ]
            },
            {
                "heading": "Sandboxing Example",
                "codeBlock": {
                    "language": "bash",
                    "code": "# Execute malware in a sandbox environment\ncuckoo submit sample.exe\n\n# Retrieve behavioral report\ncuckoo report <task_id> --format json"
                }
            }
        ],
        "resources": [
            {
                "title": "Malware Analysis Techniques",
                "url": "https://malwareunicorn.org",
                "type": "documentation"
            },
            {
                "title": "Cuckoo Sandbox",
                "url": "https://cuckoosandbox.org",
                "type": "tool"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "estimatedMinutes": 75,
        "prerequisites": ["Threat Actor TTP Analysis"],
        "learningObjectives": [
            "Differentiate static and dynamic analysis",
            "Identify common malware behaviors",
            "Analyze persistence mechanisms",
            "Understand C2 communication patterns"
        ],
        "tags": ["malware-analysis", "dynamic-analysis", "C2"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🌐 Advanced Lesson (Section 29): Campaign & Infrastructure Tracking

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    29,
    'Campaign & Infrastructure Tracking',
    'Track threat actor campaigns, infrastructure clusters, and long-term adversary activity.',
    'text',
    1,
    80,
    '{
        "title": "Campaign & Infrastructure Tracking",
        "sections": [
            {
                "heading": "What is Campaign Tracking?",
                "content": "Campaign tracking involves identifying and monitoring long-term adversary activity across multiple attacks, infrastructure changes, and malware variants."
            },
            {
                "heading": "Infrastructure Clustering",
                "content": "Analysts group related infrastructure using:",
                "list": [
                    "Passive DNS relationships",
                    "Shared SSL certificates",
                    "Hosting provider patterns",
                    "Domain registration similarities",
                    "C2 behavioral fingerprints"
                ]
            },
            {
                "heading": "Pivoting Techniques",
                "subsections": [
                    {
                        "subheading": "SSL Certificate Pivoting",
                        "content": "Identify other domains using the same certificate."
                    },
                    {
                        "subheading": "WHOIS Pivoting",
                        "content": "Track registrant email, phone, or address."
                    },
                    {
                        "subheading": "IP Range Pivoting",
                        "content": "Explore adjacent IPs for related infrastructure."
                    }
                ]
            },
            {
                "heading": "Campaign Timeline Example",
                "table": {
                    "headers": ["Date", "Event"],
                    "rows": [
                        ["Jan 2026", "Initial phishing campaign observed"],
                        ["Feb 2026", "New C2 servers registered"],
                        ["Mar 2026", "Malware variant updated"],
                        ["Apr 2026", "Infrastructure overlaps with APT29 cluster"]
                    ]
                }
            },
            {
                "heading": "Tools for Infrastructure Tracking",
                "list": [
                    "Maltego",
                    "OpenCTI",
                    "RiskIQ PassiveTotal",
                    "Shodan",
                    "Censys"
                ]
            }
        ],
        "resources": [
            {
                "title": "RiskIQ PassiveTotal",
                "url": "https://community.riskiq.com",
                "type": "tool"
            },
            {
                "title": "Maltego Documentation",
                "url": "https://docs.maltego.com",
                "type": "documentation"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "estimatedMinutes": 80,
        "prerequisites": ["Threat Actor TTP Analysis", "Threat Data Enrichment"],
        "learningObjectives": [
            "Track long-term adversary campaigns",
            "Cluster infrastructure using multiple data sources",
            "Apply pivoting techniques for deeper analysis",
            "Use tools like Maltego and PassiveTotal"
        ],
        "tags": ["campaign-tracking", "infrastructure", "pivoting"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--- 🛡️ Advanced Lesson (Section 30): Intelligence‑Driven Defense Architecture

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    30,
    'Intelligence-Driven Defense Architecture',
    'Learn how to design and implement security architectures that leverage threat intelligence for proactive defense.',
    'text',
    1,
    85,
    '{
        "title": "Intelligence-Driven Defense Architecture",
        "sections": [
            {
                "heading": "What is Intelligence-Driven Defense?",
                "content": "Intelligence-driven defense integrates threat intelligence into security architecture, enabling proactive detection, prevention, and response."
            },
            {
                "heading": "Core Components",
                "list": [
                    "Threat Intelligence Platform (TIP)",
                    "SIEM with behavioral analytics",
                    "SOAR automation",
                    "Endpoint Detection & Response (EDR)",
                    "Network Detection & Response (NDR)"
                ]
            },
            {
                "heading": "Architectural Model",
                "table": {
                    "headers": ["Layer", "Function"],
                    "rows": [
                        ["Intelligence Layer", "Collects and enriches threat data"],
                        ["Detection Layer", "Correlates events and identifies anomalies"],
                        ["Response Layer", "Automates containment and remediation"],
                        ["Visibility Layer", "Provides telemetry across endpoints and networks"],
                        ["Governance Layer", "Defines policies and risk management"]
                    ]
                }
            },
            {
                "heading": "Operationalizing Intelligence",
                "subsections": [
                    {
                        "subheading": "Detection Engineering",
                        "content": "Build detections based on TTPs rather than IOCs."
                    },
                    {
                        "subheading": "Threat-Informed Risk Management",
                        "content": "Prioritize controls based on real-world threats."
                    },
                    {
                        "subheading": "Feedback Loop",
                        "content": "Use incident findings to refine intelligence requirements."
                    }
                ]
            },
            {
                "heading": "Example Architecture Diagram (Text-Based)",
                "content": "TIP → SIEM → SOAR → EDR/NDR → Incident Response → Feedback to TIP"
            }
        ],
        "resources": [
            {
                "title": "MITRE CTID: Threat-Informed Defense",
                "url": "https://ctid.mitre.org",
                "type": "documentation"
            },
            {
                "title": "NIST Cybersecurity Framework",
                "url": "https://www.nist.gov/cyberframework",
                "type": "documentation"
            }
        ]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "estimatedMinutes": 85,
        "prerequisites": ["Threat Intelligence Platforms", "Advanced Threat Hunting"],
        "learningObjectives": [
            "Design intelligence-driven defense architectures",
            "Integrate TI into detection and response workflows",
            "Apply threat-informed risk management",
            "Understand multi-layered defense models"
        ],
        "tags": ["defense-architecture", "intelligence-driven", "SIEM", "SOAR"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0",
        "hasVideo": false,
        "hasLab": true,
        "hasQuiz": true
    }'::jsonb,
    'json'
);


--🧪 Section 22 Quiz — Threat Intelligence Platforms (TIPs)

--🧪 Section 22 Quiz — SQL Insert

INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    22,
    'Threat Intelligence Platforms Quiz',
    'Assess your understanding of Threat Intelligence Platforms (TIPs) and their capabilities.',
    70,
    20,
    3,
    'json',
    '{
        "title": "Threat Intelligence Platforms (TIPs) Quiz",
        "questions": [
            {
                "question": "What is the primary purpose of a Threat Intelligence Platform?",
                "type": "multiple_choice",
                "options": [
                    "To store firewall rules",
                    "To aggregate, enrich, and distribute threat intelligence",
                    "To replace SIEM systems",
                    "To perform malware reverse engineering"
                ],
                "correctAnswer": 1,
                "explanation": "TIPs centralize threat data, enrich it, and distribute it to security tools.",
                "points": 1
            },
            {
                "question": "Which of the following is an open-source TIP?",
                "type": "multiple_choice",
                "options": ["ThreatConnect", "Anomali", "MISP", "QRadar"],
                "correctAnswer": 2,
                "explanation": "MISP is a widely used open-source threat intelligence platform.",
                "points": 1
            },
            {
                "question": "Which tool category commonly integrates with TIPs?",
                "type": "multiple_choice",
                "options": ["Video editing tools", "SIEM and SOAR", "Web hosting platforms", "CRM systems"],
                "correctAnswer": 1,
                "explanation": "TIPs integrate with SIEM, SOAR, EDR, and other security tools.",
                "points": 1
            },
            {
                "question": "What is a key benefit of using a TIP?",
                "type": "multiple_choice",
                "options": [
                    "Reduced storage costs",
                    "Improved detection accuracy",
                    "Faster internet speeds",
                    "Better website performance"
                ],
                "correctAnswer": 1,
                "explanation": "TIPs improve detection by enriching and correlating threat data.",
                "points": 1
            },
            {
                "question": "Which feature is commonly found in TIPs?",
                "type": "multiple_choice",
                "options": [
                    "Automated IOC enrichment",
                    "Password cracking",
                    "Network load balancing",
                    "Web application scanning"
                ],
                "correctAnswer": 0,
                "explanation": "TIPs enrich indicators using external and internal sources.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "intermediate",
        "estimatedMinutes": 20,
        "tags": ["threat-intelligence", "TIP", "MISP", "OpenCTI"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);


--- 🧪 Section 22 Lab — SQL Insert

INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    22,
    'Using a Threat Intelligence Platform (TIP)',
    'Hands-on lab to ingest, enrich, and export threat intelligence using a TIP.',
    45,
    'json',
    '{
        "title": "Lab: Using a Threat Intelligence Platform (TIP)",
        "objective": "Learn how to ingest, enrich, and export threat intelligence using a TIP.",
        "steps": [
            {"step": 1, "instruction": "Log into the provided MISP or OpenCTI instance."},
            {"step": 2, "instruction": "Ingest a sample threat feed (CSV or STIX file)."},
            {"step": 3, "instruction": "Normalize the imported indicators and review duplicates."},
            {"step": 4, "instruction": "Perform enrichment using WHOIS, Passive DNS, and reputation lookups."},
            {"step": 5, "instruction": "Tag indicators with threat actor or malware family associations."},
            {"step": 6, "instruction": "Export enriched indicators in STIX format."}
        ],
        "validation": [
            "At least 10 indicators successfully ingested",
            "Enrichment metadata visible",
            "Exported STIX file contains enriched fields"
        ],
        "toolsRequired": ["MISP", "OpenCTI", "VirusTotal", "PassiveTotal"]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "tags": ["TIP", "threat-intelligence", "hands-on"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);


--- ✅ QUIZ + LAB FOR SECTION 23 (IOCs)

---  🧪 Section 23 Quiz — SQL Insert

INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    23,
    'Indicators of Compromise (IOCs) Quiz',
    'Test your knowledge of IOC types, enrichment, and operationalization.',
    70,
    20,
    3,
    'json',
    '{
        "title": "Indicators of Compromise (IOCs) Quiz",
        "questions": [
            {
                "question": "Which of the following is NOT an IOC?",
                "type": "multiple_choice",
                "options": ["SHA256 hash", "IP address", "Domain name", "CPU temperature"],
                "correctAnswer": 3,
                "explanation": "CPU temperature is not a forensic indicator.",
                "points": 1
            },
            {
                "question": "What is the purpose of IOC enrichment?",
                "type": "multiple_choice",
                "options": [
                    "To compress indicator data",
                    "To add context and improve detection accuracy",
                    "To remove old indicators",
                    "To anonymize threat data"
                ],
                "correctAnswer": 1,
                "explanation": "Enrichment adds context such as reputation, WHOIS, and passive DNS.",
                "points": 1
            },
            {
                "question": "Which service provides historical domain-IP relationships?",
                "type": "multiple_choice",
                "options": ["WHOIS", "Passive DNS", "SSL Pinning", "ARP Tables"],
                "correctAnswer": 1,
                "explanation": "Passive DNS shows historical DNS resolutions.",
                "points": 1
            },
            {
                "question": "Which factor is used in IOC scoring?",
                "type": "multiple_choice",
                "options": ["Indicator color", "Source reliability", "File size", "Network speed"],
                "correctAnswer": 1,
                "explanation": "Source reliability and freshness are key scoring factors.",
                "points": 1
            },
            {
                "question": "Which format is commonly used for sharing IOCs?",
                "type": "multiple_choice",
                "options": ["STIX", "JPEG", "MP3", "HTML"],
                "correctAnswer": 0,
                "explanation": "STIX/TAXII is the standard for structured threat intelligence.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "intermediate",
        "estimatedMinutes": 20,
        "tags": ["IOC", "threat-hunting", "enrichment"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

--- 🧪 Section 23 Lab — SQL Insert

INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    23,
    'IOC Enrichment and Operationalization',
    'Hands-on lab to enrich raw indicators and deploy them into detection systems.',
    50,
    'json',
    '{
        "title": "Lab: IOC Enrichment and Operationalization",
        "objective": "Enrich raw indicators and deploy them into detection systems.",
        "steps": [
            {"step": 1, "instruction": "Download the provided IOC list (hashes, domains, IPs)."},
            {"step": 2, "instruction": "Use VirusTotal to enrich file hashes and record reputation scores."},
            {"step": 3, "instruction": "Use Passive DNS to identify related domains."},
            {"step": 4, "instruction": "Assign confidence scores to each IOC."},
            {"step": 5, "instruction": "Import enriched IOCs into a SIEM or TIP."},
            {"step": 6, "instruction": "Create a detection rule using at least one enriched IOC."}
        ],
        "validation": [
            "All IOCs enriched with at least 2 data sources",
            "Confidence scores assigned",
            "Detection rule created and tested"
        ],
        "toolsRequired": ["VirusTotal", "PassiveTotal", "SIEM", "TIP"]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "tags": ["IOC", "enrichment", "hands-on"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

--- 🧪 Section 24 Quiz — SQL Insert

INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    24,
    'Threat Data Normalization & Enrichment Quiz',
    'Evaluate your understanding of normalization, enrichment, and correlation workflows.',
    70,
    20,
    3,
    'json',
    '{
        "title": "Threat Data Normalization & Enrichment Quiz",
        "questions": [
            {
                "question": "Why is normalization important in threat intelligence?",
                "type": "multiple_choice",
                "options": [
                    "It improves network speed",
                    "It ensures consistent data formats for analysis",
                    "It encrypts threat data",
                    "It deletes duplicate indicators"
                ],
                "correctAnswer": 1,
                "explanation": "Normalization ensures consistent structure across diverse data sources.",
                "points": 1
            },
            {
                "question": "Which of the following is an enrichment source?",
                "type": "multiple_choice",
                "options": ["ARP cache", "WHOIS", "DHCP logs", "File permissions"],
                "correctAnswer": 1,
                "explanation": "WHOIS provides domain ownership and registration details.",
                "points": 1
            },
            {
                "question": "What is the first step in the normalization workflow?",
                "type": "multiple_choice",
                "options": ["Enrichment", "Correlation", "Ingestion", "Distribution"],
                "correctAnswer": 2,
                "explanation": "Data must be ingested before it can be normalized.",
                "points": 1
            },
            {
                "question": "Which standard is commonly used for structured threat intelligence?",
                "type": "multiple_choice",
                "options": ["STIX", "JSON-LD", "XML", "CSV"],
                "correctAnswer": 0,
                "explanation": "STIX/TAXII is the industry standard.",
                "points": 1
            },
            {
                "question": "Which tool is commonly used for enrichment?",
                "type": "multiple_choice",
                "options": ["Nmap", "VirusTotal", "Wireshark", "Burp Suite"],
                "correctAnswer": 1,
                "explanation": "VirusTotal enriches file hashes, domains, and IPs.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "intermediate",
        "estimatedMinutes": 20,
        "tags": ["normalization", "enrichment", "STIX"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

--- 🧪 Section 24 Lab — SQL Insert

INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    24,
    'Threat Data Normalization & Enrichment Lab',
    'Normalize and enrich threat data using STIX and external enrichment sources.',
    60,
    'json',
    '{
        "title": "Lab: Threat Data Normalization & Enrichment",
        "objective": "Normalize and enrich threat data using STIX and external enrichment sources.",
        "steps": [
            {"step": 1, "instruction": "Import a raw threat feed containing mixed-format indicators."},
            {"step": 2, "instruction": "Normalize all indicators into STIX 2.1 format."},
            {"step": 3, "instruction": "Remove duplicates and stale indicators."},
            {"step": 4, "instruction": "Perform enrichment using WHOIS, Passive DNS, and reputation services."},
            {"step": 5, "instruction": "Correlate enriched indicators to identify clusters."},
            {"step": 6, "instruction": "Export the final dataset and upload it to a TIP."}
        ],
        "validation": [
            "All indicators normalized to STIX",
            "Enrichment metadata added",
            "Clusters identified and documented"
        ],
        "toolsRequired": ["MISP", "OpenCTI", "VirusTotal", "PassiveTotal"]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "tags": ["normalization", "enrichment", "hands-on"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- 🧠 SECTION 25 — Threat Actor TTP Analysis

-- Section 25 Quiz — Threat Actor TTP Analysis
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    25,
    'Threat Actor TTP Analysis Quiz',
    'Assess knowledge of TTPs, MITRE ATT&CK mapping, and campaign correlation.',
    75,
    25,
    3,
    'json',
    '{
        "title": "Threat Actor TTP Analysis Quiz",
        "questions": [
            {
                "question": "In MITRE ATT&CK, what does a \"Tactic\" represent?",
                "type": "multiple_choice",
                "options": [
                    "A specific malware sample",
                    "An attacker goal or objective",
                    "A network protocol",
                    "A defensive control"
                ],
                "correctAnswer": 1,
                "explanation": "Tactics describe the attacker’s high-level goals during an intrusion.",
                "points": 1
            },
            {
                "question": "Which of the following is an example of a technique rather than a tactic?",
                "type": "multiple_choice",
                "options": [
                    "Credential Access",
                    "Phishing",
                    "Initial Access",
                    "Exfiltration"
                ],
                "correctAnswer": 1,
                "explanation": "Phishing is a technique used to achieve a tactic like Initial Access.",
                "points": 1
            },
            {
                "question": "Mapping observed behavior to ATT&CK helps primarily with:",
                "type": "multiple_choice",
                "options": [
                    "Faster patch deployment",
                    "Attribution and detection engineering",
                    "Increasing bandwidth",
                    "User onboarding"
                ],
                "correctAnswer": 1,
                "explanation": "ATT&CK mapping supports attribution and improves detection engineering.",
                "points": 1
            },
            {
                "question": "Which data source is most useful for detecting lateral movement?",
                "type": "multiple_choice",
                "options": [
                    "DNS logs",
                    "Process creation and network connection logs",
                    "Web analytics",
                    "Email marketing logs"
                ],
                "correctAnswer": 1,
                "explanation": "Process and network telemetry reveal lateral movement behaviors.",
                "points": 1
            },
            {
                "question": "When correlating TTPs across incidents, analysts should prioritize:",
                "type": "multi_select",
                "options": [
                    "Shared infrastructure",
                    "Similar malware families",
                    "Coincidental timestamps",
                    "Common command-and-control patterns"
                ],
                "correctAnswers": [0,1,3],
                "explanation": "Shared infrastructure, malware families, and C2 patterns are meaningful correlation signals.",
                "points": 2
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 6,
        "difficulty": "intermediate",
        "estimatedMinutes": 25,
        "tags": ["TTP", "MITRE-ATT&CK", "threat-analysis"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 25 Lab — Threat Actor TTP Analysis Lab
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    25,
    'Threat Actor TTP Analysis Lab',
    'Hands-on lab to map observed behaviors to MITRE ATT&CK and produce detection recommendations.',
    60,
    'json',
    '{
        "title": "Lab: Threat Actor TTP Analysis",
        "objective": "Map telemetry to ATT&CK techniques, correlate across incidents, and propose detections.",
        "steps": [
            {"step": 1, "instruction": "Review the provided incident logs (process, network, authentication)."},
            {"step": 2, "instruction": "Identify suspicious behaviors and list candidate techniques."},
            {"step": 3, "instruction": "Map each behavior to MITRE ATT&CK technique IDs."},
            {"step": 4, "instruction": "Correlate mapped techniques across three sample incidents to identify common patterns."},
            {"step": 5, "instruction": "Draft three detection rules or analytics based on mapped TTPs."},
            {"step": 6, "instruction": "Document confidence and data sources required for each detection."}
        ],
        "validation": [
            "All major behaviors mapped to ATT&CK techniques",
            "At least two correlated patterns identified across incidents",
            "Three detection recommendations with data source justification"
        ],
        "toolsRequired": ["MITRE ATT&CK Navigator", "SIEM or log dataset", "OpenCTI (optional)"]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "tags": ["TTP", "lab", "detection-engineering"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 26 Quiz — Building Threat Intelligence Reports
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    26,
    'Threat Intelligence Reporting Quiz',
    'Evaluate skills in structuring and communicating threat intelligence findings.',
    70,
    30,
    3,
    'json',
    '{
        "title": "Building Threat Intelligence Reports Quiz",
        "questions": [
            {
                "question": "Which section of a TI report is intended for executives?",
                "type": "multiple_choice",
                "options": ["Technical Appendix", "IOC List", "Executive Summary", "Raw Logs"],
                "correctAnswer": 2,
                "explanation": "The Executive Summary provides high-level findings for leadership.",
                "points": 1
            },
            {
                "question": "A tactical report should primarily include:",
                "type": "multiple_choice",
                "options": ["Long-term geopolitical analysis", "Immediate IOCs and detection guidance", "Company financials", "HR policies"],
                "correctAnswer": 1,
                "explanation": "Tactical reports focus on immediate threats and detection guidance.",
                "points": 1
            },
            {
                "question": "Which element increases the actionability of an IOC list?",
                "type": "multiple_choice",
                "options": ["Color coding", "Context and confidence scores", "Long domain descriptions", "Large file attachments"],
                "correctAnswer": 1,
                "explanation": "Context and confidence help analysts prioritize and operationalize IOCs.",
                "points": 1
            },
            {
                "question": "When tailoring a report to a SOC audience, you should:",
                "type": "multiple_choice",
                "options": ["Remove all technical details", "Include detection playbooks and queries", "Only include executive summaries", "Use only images"],
                "correctAnswer": 1,
                "explanation": "SOC audiences need detection playbooks, queries, and technical context.",
                "points": 1
            },
            {
                "question": "Best practice for sharing sensitive intelligence externally is to:",
                "type": "multiple_choice",
                "options": ["Publish on public forums", "Use controlled sharing channels and NDAs", "Email to all employees", "Post on social media"],
                "correctAnswer": 1,
                "explanation": "Controlled channels and legal agreements protect sensitive intelligence.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "intermediate",
        "estimatedMinutes": 30,
        "tags": ["reporting", "communication", "TI"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 26 Lab — Threat Intelligence Report Lab
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    26,
    'Threat Intelligence Report Lab',
    'Create a tactical and an executive threat intelligence report from provided analysis artifacts.',
    75,
    'json',
    '{
        "title": "Lab: Building Threat Intelligence Reports",
        "objective": "Produce both a tactical report for SOC and an executive summary for leadership.",
        "steps": [
            {"step": 1, "instruction": "Review provided analysis artifacts: IOCs, TTP mappings, and campaign timeline."},
            {"step": 2, "instruction": "Draft a tactical report including IOCs, detection guidance, and playbooks."},
            {"step": 3, "instruction": "Draft an executive summary highlighting business impact and recommended actions."},
            {"step": 4, "instruction": "Create a one-page infographic summarizing key findings."},
            {"step": 5, "instruction": "Prepare a distribution plan specifying internal and external recipients and sharing controls."}
        ],
        "validation": [
            "Tactical report includes IOCs and at least two detection playbooks",
            "Executive summary concisely states impact and recommended actions",
            "Distribution plan includes sharing controls"
        ],
        "toolsRequired": ["Document editor", "Visualization tool (e.g., draw.io)", "MITRE ATT&CK Navigator"]
    }'::jsonb,
    '{
        "difficulty": "intermediate",
        "tags": ["reporting", "lab", "communication"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 27 Quiz — Advanced Threat Hunting
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    27,
    'Advanced Threat Hunting Quiz',
    'Test advanced hunting concepts: hypothesis-driven methods, behavioral analytics, and query construction.',
    75,
    30,
    3,
    'json',
    '{
        "title": "Advanced Threat Hunting Quiz",
        "questions": [
            {
                "question": "Hypothesis-driven hunting begins with:",
                "type": "multiple_choice",
                "options": ["Random queries", "A clear hypothesis based on intelligence", "Only IOC matching", "System reboots"],
                "correctAnswer": 1,
                "explanation": "Hunters form hypotheses based on intelligence and environment knowledge.",
                "points": 1
            },
            {
                "question": "Which is a behavioral indicator of compromise?",
                "type": "multiple_choice",
                "options": ["A single known malicious IP", "Unusual parent-child process relationships", "File size", "Screen resolution"],
                "correctAnswer": 1,
                "explanation": "Behavioral indicators focus on anomalous actions like parent-child process anomalies.",
                "points": 1
            },
            {
                "question": "Hunting maturity level that includes automated analytics is:",
                "type": "multiple_choice",
                "options": ["HMM1", "HMM2", "HMM3", "HMM0"],
                "correctAnswer": 2,
                "explanation": "HMM3 indicates automated hunting with analytics.",
                "points": 1
            },
            {
                "question": "Which query example is appropriate for detecting suspicious PowerShell usage?",
                "type": "multiple_choice",
                "options": [
                    "Search for all .txt files",
                    "DeviceProcessEvents | where FileName == \"powershell.exe\" and ProcessCommandLine contains \"-enc\"",
                    "List all users",
                    "Check disk free space"
                ],
                "correctAnswer": 1,
                "explanation": "The query targets encoded PowerShell commands often used by attackers.",
                "points": 1
            },
            {
                "question": "Effective hunting requires which of the following? (Select all that apply)",
                "type": "multi_select",
                "options": [
                    "High-quality telemetry",
                    "Clear hypotheses",
                    "Random guessing",
                    "Collaboration with analysts"
                ],
                "correctAnswers": [0,1,3],
                "explanation": "Telemetry, hypotheses, and collaboration are essential; random guessing is not.",
                "points": 2
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 6,
        "difficulty": "advanced",
        "estimatedMinutes": 30,
        "tags": ["hunting", "advanced", "behavioral-analytics"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 27 Lab — Advanced Threat Hunting Lab
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    27,
    'Advanced Threat Hunting Lab',
    'Perform hypothesis-driven hunts using telemetry and build analytics to detect stealthy threats.',
    90,
    'json',
    '{
        "title": "Lab: Advanced Threat Hunting",
        "objective": "Execute hypothesis-driven hunts and create detection analytics from telemetry.",
        "steps": [
            {"step": 1, "instruction": "Formulate two hunting hypotheses based on provided threat intelligence."},
            {"step": 2, "instruction": "Collect required telemetry: process, network, authentication logs."},
            {"step": 3, "instruction": "Write and run hunting queries to validate or refute hypotheses."},
            {"step": 4, "instruction": "Refine queries to reduce false positives."},
            {"step": 5, "instruction": "Create an analytic rule for one validated detection and test it."},
            {"step": 6, "instruction": "Document findings and recommended mitigations."}
        ],
        "validation": [
            "Two hypotheses documented and tested",
            "At least one validated detection with an analytic rule",
            "False positive rate documented and reduced"
        ],
        "toolsRequired": ["SIEM with query capability", "EDR telemetry", "MITRE ATT&CK Navigator"]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "tags": ["hunting", "lab", "analytics"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 28 Quiz — Malware Behavior Analysis
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    28,
    'Malware Behavior Analysis Quiz',
    'Assess understanding of static vs dynamic analysis, persistence, and C2 patterns.',
    75,
    30,
    3,
    'json',
    '{
        "title": "Malware Behavior Analysis Quiz",
        "questions": [
            {
                "question": "Which analysis type observes malware during execution?",
                "type": "multiple_choice",
                "options": ["Static Analysis", "Dynamic Analysis", "Theoretical Analysis", "Network Analysis"],
                "correctAnswer": 1,
                "explanation": "Dynamic analysis observes behavior during execution in a controlled environment.",
                "points": 1
            },
            {
                "question": "Which is a common persistence mechanism?",
                "type": "multiple_choice",
                "options": ["Registry Run Keys", "Temporary files", "Screen saver", "Printer spooler"],
                "correctAnswer": 0,
                "explanation": "Registry Run Keys are commonly used to achieve persistence.",
                "points": 1
            },
            {
                "question": "DNS tunneling is primarily used for:",
                "type": "multiple_choice",
                "options": ["Local file storage", "Command-and-control and data exfiltration", "User authentication", "Patch management"],
                "correctAnswer": 1,
                "explanation": "DNS tunneling encodes data in DNS queries for C2 or exfiltration.",
                "points": 1
            },
            {
                "question": "Which tool is commonly used for sandboxed dynamic analysis?",
                "type": "multiple_choice",
                "options": ["Cuckoo Sandbox", "Nmap", "Wireshark", "Burp Suite"],
                "correctAnswer": 0,
                "explanation": "Cuckoo Sandbox is a popular dynamic analysis platform.",
                "points": 1
            },
            {
                "question": "When performing static analysis, which artifact is most useful?",
                "type": "multiple_choice",
                "options": ["File hash", "Live network traffic", "User session logs", "Printer logs"],
                "correctAnswer": 0,
                "explanation": "File hashes and binary inspection are key static analysis artifacts.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "advanced",
        "estimatedMinutes": 30,
        "tags": ["malware", "analysis", "dynamic"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 28 Lab — Malware Behavior Analysis Lab
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    28,
    'Malware Behavior Analysis Lab',
    'Analyze a malware sample in a sandbox and produce a behavioral report with IOCs and detection guidance.',
    120,
    'json',
    '{
        "title": "Lab: Malware Behavior Analysis",
        "objective": "Perform static and dynamic analysis to extract behavior, persistence, and C2 indicators.",
        "steps": [
            {"step": 1, "instruction": "Obtain the provided malware sample in a controlled environment."},
            {"step": 2, "instruction": "Perform static analysis: compute hashes, inspect strings, and identify suspicious imports."},
            {"step": 3, "instruction": "Execute the sample in a sandbox (Cuckoo) and capture behavioral logs."},
            {"step": 4, "instruction": "Identify persistence mechanisms and C2 communication patterns."},
            {"step": 5, "instruction": "Extract IOCs (hashes, domains, IPs, mutexes) and assign confidence scores."},
            {"step": 6, "instruction": "Write detection guidance and recommended containment steps."}
        ],
        "validation": [
            "Behavioral report includes static and dynamic findings",
            "At least 5 IOCs extracted with confidence scores",
            "Detection guidance includes required telemetry and mitigation steps"
        ],
        "toolsRequired": ["Cuckoo Sandbox", "Static analysis tools (strings, radare2)", "VirusTotal"]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "tags": ["malware", "sandbox", "hands-on"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 29 Quiz — Campaign & Infrastructure Tracking
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    29,
    'Campaign & Infrastructure Tracking Quiz',
    'Test skills in tracking adversary infrastructure, pivoting, and timeline analysis.',
    75,
    30,
    3,
    'json',
    '{
        "title": "Campaign & Infrastructure Tracking Quiz",
        "questions": [
            {
                "question": "Infrastructure clustering commonly uses which data source?",
                "type": "multiple_choice",
                "options": ["Passive DNS", "Local user profiles", "Printer logs", "Browser bookmarks"],
                "correctAnswer": 0,
                "explanation": "Passive DNS helps cluster related domains and IPs.",
                "points": 1
            },
            {
                "question": "SSL certificate pivoting helps identify:",
                "type": "multiple_choice",
                "options": ["Other domains using the same certificate", "User passwords", "File permissions", "CPU usage"],
                "correctAnswer": 0,
                "explanation": "Shared SSL certificates can link multiple domains to the same infrastructure.",
                "points": 1
            },
            {
                "question": "Which tool is useful for visualizing infrastructure relationships?",
                "type": "multiple_choice",
                "options": ["Maltego", "Notepad", "Excel (only)", "Paint"],
                "correctAnswer": 0,
                "explanation": "Maltego is designed for graph-based infrastructure analysis.",
                "points": 1
            },
            {
                "question": "A campaign timeline should include:",
                "type": "multiple_choice",
                "options": ["Event dates and observed changes", "Only the final event", "Random logs", "User opinions"],
                "correctAnswer": 0,
                "explanation": "Timelines document events and infrastructure changes over time.",
                "points": 1
            },
            {
                "question": "Which pivoting technique can reveal related infrastructure?",
                "type": "multi_select",
                "options": ["WHOIS pivoting", "IP range pivoting", "Random guessing", "SSL certificate pivoting"],
                "correctAnswers": [0,1,3],
                "explanation": "WHOIS, IP range, and SSL certificate pivoting are valid techniques.",
                "points": 2
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 6,
        "difficulty": "advanced",
        "estimatedMinutes": 30,
        "tags": ["campaign-tracking", "infrastructure", "pivoting"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 29 Lab — Campaign & Infrastructure Tracking Lab
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    29,
    'Campaign & Infrastructure Tracking Lab',
    'Track a simulated adversary campaign, cluster infrastructure, and produce a timeline and attribution analysis.',
    120,
    'json',
    '{
        "title": "Lab: Campaign & Infrastructure Tracking",
        "objective": "Cluster related infrastructure, pivot across data sources, and build a campaign timeline.",
        "steps": [
            {"step": 1, "instruction": "Ingest provided domain, IP, and certificate artifacts."},
            {"step": 2, "instruction": "Use Passive DNS and WHOIS to pivot and discover related assets."},
            {"step": 3, "instruction": "Cluster assets by shared attributes (hosting, certs, registrant)."},
            {"step": 4, "instruction": "Construct a campaign timeline with key events and infrastructure changes."},
            {"step": 5, "instruction": "Assess likelihood of attribution to a known threat actor and document reasoning."},
            {"step": 6, "instruction": "Produce a short briefing summarizing findings and recommended mitigations."}
        ],
        "validation": [
            "Clusters include at least 3 related assets",
            "Timeline contains at least 4 dated events",
            "Attribution assessment includes evidence and confidence level"
        ],
        "toolsRequired": ["PassiveTotal", "Maltego", "WHOIS services", "OpenCTI (optional)"]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "tags": ["campaign", "tracking", "lab"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 30 Quiz — Intelligence-Driven Defense Architecture
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    30,
    'Intelligence-Driven Defense Architecture Quiz',
    'Evaluate understanding of integrating threat intelligence into detection, response, and architecture design.',
    75,
    30,
    3,
    'json',
    '{
        "title": "Intelligence-Driven Defense Architecture Quiz",
        "questions": [
            {
                "question": "Which layer is responsible for collecting and enriching threat data in an intelligence-driven model?",
                "type": "multiple_choice",
                "options": ["Detection Layer", "Intelligence Layer", "Response Layer", "Governance Layer"],
                "correctAnswer": 1,
                "explanation": "The Intelligence Layer collects and enriches threat data for downstream use.",
                "points": 1
            },
            {
                "question": "Detection engineering should be based on:",
                "type": "multiple_choice",
                "options": ["Random IOCs", "TTPs and behavioral patterns", "User preferences", "Marketing data"],
                "correctAnswer": 1,
                "explanation": "TTP-based detections are more resilient than IOC-only rules.",
                "points": 1
            },
            {
                "question": "SOAR platforms are primarily used to:",
                "type": "multiple_choice",
                "options": ["Store backups", "Automate response playbooks", "Design network diagrams", "Manage HR tasks"],
                "correctAnswer": 1,
                "explanation": "SOAR automates response workflows and playbooks.",
                "points": 1
            },
            {
                "question": "A feedback loop in intelligence-driven defense is used to:",
                "type": "multiple_choice",
                "options": ["Ignore incidents", "Refine intelligence and detections based on incidents", "Increase false positives", "Disable telemetry"],
                "correctAnswer": 1,
                "explanation": "Feedback from incidents improves intelligence and detection quality.",
                "points": 1
            },
            {
                "question": "Which component provides telemetry across endpoints and networks?",
                "type": "multiple_choice",
                "options": ["Governance Layer", "Visibility Layer", "Executive Layer", "Marketing Layer"],
                "correctAnswer": 1,
                "explanation": "The Visibility Layer aggregates telemetry from endpoints and networks.",
                "points": 1
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 5,
        "difficulty": "advanced",
        "estimatedMinutes": 30,
        "tags": ["architecture", "SIEM", "SOAR", "intelligence-driven"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

-- Section 30 Lab — Intelligence-Driven Defense Architecture Lab
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    30,
    'Intelligence-Driven Defense Architecture Lab',
    'Design and validate an architecture that operationalizes threat intelligence across detection and response layers.',
    120,
    'json',
    '{
        "title": "Lab: Intelligence-Driven Defense Architecture",
        "objective": "Design an architecture integrating TIP, SIEM, SOAR, EDR/NDR and demonstrate a detection-to-response workflow.",
        "steps": [
            {"step": 1, "instruction": "Review provided organizational telemetry and threat intelligence requirements."},
            {"step": 2, "instruction": "Draft an architecture diagram showing TIP, SIEM, SOAR, EDR/NDR, and feedback loops."},
            {"step": 3, "instruction": "Define data flows and integration points (STIX/TAXII, APIs)."},
            {"step": 4, "instruction": "Create a detection use case based on a TTP and implement it as a SIEM analytic and SOAR playbook."},
            {"step": 5, "instruction": "Simulate an incident and execute the playbook to validate automation and containment."},
            {"step": 6, "instruction": "Document metrics to measure effectiveness (MTTR, detection rate, false positives)."}
        ],
        "validation": [
            "Architecture diagram includes all core components and data flows",
            "One detection implemented and automated via SOAR",
            "Metrics defined for measuring effectiveness"
        ],
        "toolsRequired": ["Diagram tool", "SIEM", "SOAR", "EDR/NDR (simulated)"]
    }'::jsonb,
    '{
        "difficulty": "advanced",
        "tags": ["architecture", "lab", "SOAR", "SIEM"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);

--- 