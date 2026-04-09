-- CyberSkill Platform - Load Content into JSONB
-- Version: 1.3.0
-- Description: Load structured lesson content into JSONB columns

-- Update Penetration Testing Tools Overview lesson with JSONB content
UPDATE lessons SET 
    content_json = '{
        "title": "Penetration Testing Tools Overview",
        "sections": [
            {
                "heading": "Introduction",
                "content": "Professional penetration testers rely on a comprehensive toolkit to identify, exploit, and document security vulnerabilities. This lesson introduces the essential tools you will use throughout your penetration testing career."
            },
            {
                "heading": "1. Kali Linux",
                "subsections": [
                    {
                        "heading": "What is Kali Linux?",
                        "content": "Kali Linux is a Debian-based Linux distribution specifically designed for penetration testing and security auditing. It comes pre-installed with over 600 security tools."
                    },
                    {
                        "heading": "Key Features",
                        "items": [
                            "Pre-configured Environment: Ready-to-use penetration testing platform",
                            "Regular Updates: Maintained by Offensive Security",
                            "Extensive Tool Collection: Covers all phases of penetration testing",
                            "Customizable: Can be tailored to specific testing needs"
                        ]
                    },
                    {
                        "heading": "Installation Options",
                        "codeBlock": {
                            "language": "bash",
                            "code": "# Download from official website\nhttps://www.kali.org/downloads/\n\n# Installation methods:\n1. Bare metal installation\n2. Virtual machine (VMware/VirtualBox)\n3. Docker container\n4. Windows Subsystem for Linux (WSL)\n5. Cloud deployment (AWS/Azure)"
                        }
                    }
                ]
            },
            {
                "heading": "2. Metasploit Framework",
                "subsections": [
                    {
                        "heading": "Overview",
                        "content": "Metasploit is the world''s most popular penetration testing framework, providing tools for discovering, exploiting, and validating vulnerabilities."
                    },
                    {
                        "heading": "Basic Usage",
                        "codeBlock": {
                            "language": "bash",
                            "code": "# Start Metasploit console\nmsfconsole\n\n# Search for exploits\nmsf6 > search type:exploit platform:windows smb\n\n# Use an exploit\nmsf6 > use exploit/windows/smb/ms17_010_eternalblue\nmsf6 > set RHOSTS 192.168.1.100\nmsf6 > exploit"
                        }
                    }
                ]
            },
            {
                "heading": "Tool Selection Matrix",
                "table": {
                    "headers": ["Phase", "Primary Tool", "Alternative", "Purpose"],
                    "rows": [
                        ["Reconnaissance", "Nmap", "Masscan", "Network discovery"],
                        ["Web Testing", "Burp Suite", "OWASP ZAP", "Web app security"],
                        ["Exploitation", "Metasploit", "Manual exploits", "Vulnerability exploitation"],
                        ["Password Cracking", "Hashcat", "John the Ripper", "Credential attacks"],
                        ["Post-Exploitation", "Meterpreter", "PowerShell Empire", "Maintain access"]
                    ]
                }
            },
            {
                "heading": "Hands-On Lab Exercise",
                "lab": {
                    "title": "Setup Your Testing Environment",
                    "steps": [
                        {
                            "step": 1,
                            "title": "Install Kali Linux",
                            "instructions": "Download Kali Linux VM, import into VirtualBox/VMware, update system",
                            "code": "sudo apt update && sudo apt upgrade -y"
                        },
                        {
                            "step": 2,
                            "title": "Install Metasploitable 2",
                            "instructions": "Download from SourceForge, import into same virtual network as Kali",
                            "note": "Default credentials: msfadmin/msfadmin"
                        },
                        {
                            "step": 3,
                            "title": "Practice Scanning",
                            "code": "nmap -sV -A <metasploitable-ip>"
                        },
                        {
                            "step": 4,
                            "title": "Exploit a Vulnerability",
                            "code": "msfconsole\nsearch vsftpd\nuse exploit/unix/ftp/vsftpd_234_backdoor\nset RHOST <metasploitable-ip>\nexploit"
                        }
                    ]
                }
            },
            {
                "heading": "Resources",
                "links": [
                    {"title": "Kali Linux Documentation", "url": "https://www.kali.org/docs/"},
                    {"title": "Metasploit Documentation", "url": "https://docs.metasploit.com/"},
                    {"title": "Burp Suite Documentation", "url": "https://portswigger.net/burp/documentation"},
                    {"title": "Nmap Book", "url": "https://nmap.org/book/"}
                ],
                "practiceP latforms": [
                    {"name": "HackTheBox", "url": "https://www.hackthebox.eu/"},
                    {"name": "TryHackMe", "url": "https://tryhackme.com/"},
                    {"name": "PentesterLab", "url": "https://pentesterlab.com/"},
                    {"name": "VulnHub", "url": "https://www.vulnhub.com/"}
                ]
            }
        ],
        "videoUrl": "https://www.youtube.com/embed/placeholder_pentest_tools",
        "quizQuestions": [
            "What is the difference between Kali Linux and a regular Linux distribution?",
            "Name three phases of penetration testing and the primary tool for each.",
            "What is Meterpreter and why is it powerful?",
            "How does Burp Suite''s Proxy component work?",
            "What is the purpose of Nmap''s NSE scripts?"
        ]
    }'::jsonb,
    metadata = '{
        "difficulty": "intermediate",
        "estimatedMinutes": 45,
        "prerequisites": ["Basic Linux knowledge", "Networking fundamentals"],
        "learningObjectives": [
            "Understand the purpose of each penetration testing tool",
            "Install and configure Kali Linux",
            "Perform basic network scanning with Nmap",
            "Use Metasploit for exploitation",
            "Test web applications with Burp Suite"
        ],
        "tags": ["kali-linux", "metasploit", "burp-suite", "nmap", "penetration-testing"],
        "author": "CyberSkill Team",
        "lastUpdated": "2026-03-12",
        "version": "1.0"
    }'::jsonb,
    content_source = 'json',
    video_url = 'https://www.youtube.com/embed/placeholder_pentest_tools',
    estimated_minutes = 45
WHERE section_id = 3 AND name = 'Penetration Testing Tools Overview';

COMMIT;

-- Made with Bob
