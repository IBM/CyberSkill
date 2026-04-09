-- CyberSkill Platform - Additional Enhanced Lessons
-- Version: 1.4.0
-- Description: More video lessons, interactive scenarios, and comprehensive content

-- ============================================================================
-- DATA SECURITY - ENCRYPTION VIDEO LESSON
-- ============================================================================

UPDATE lessons SET content = '
# Encryption Fundamentals - Complete Video Course

## 📹 Watch: Modern Cryptography Explained

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/placeholder_crypto" 
    title="Modern Cryptography and Encryption" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 75 minutes  
**Difficulty**: Intermediate  
**Prerequisites**: Basic understanding of binary and mathematics

---

## 📚 Video Chapters

### Part 1: Symmetric Encryption (0:00 - 20:00)
- AES (Advanced Encryption Standard)
- DES and 3DES (Legacy)
- Block cipher modes (ECB, CBC, GCM)
- Key management

### Part 2: Asymmetric Encryption (20:00 - 40:00)
- RSA algorithm
- Elliptic Curve Cryptography (ECC)
- Diffie-Hellman key exchange
- Public Key Infrastructure (PKI)

### Part 3: Hashing and Digital Signatures (40:00 - 55:00)
- SHA-256, SHA-3
- HMAC (Hash-based Message Authentication Code)
- Digital signatures
- Certificate authorities

### Part 4: Real-World Applications (55:00 - 75:00)
- TLS/SSL
- PGP/GPG email encryption
- Full disk encryption
- Database encryption

---

## 🎯 Hands-On Lab: Implementing Encryption

### Lab 1: AES Encryption in Python

```python
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import padding
import os

def encrypt_aes_cbc(plaintext, key):
    """
    Encrypt data using AES-256 in CBC mode
    
    Args:
        plaintext (bytes): Data to encrypt
        key (bytes): 32-byte encryption key
    
    Returns:
        tuple: (iv, ciphertext)
    """
    # Generate random IV (Initialization Vector)
    iv = os.urandom(16)
    
    # Create cipher object
    cipher = Cipher(
        algorithms.AES(key),
        modes.CBC(iv),
        backend=default_backend()
    )
    
    # Add PKCS7 padding
    padder = padding.PKCS7(128).padder()
    padded_data = padder.update(plaintext) + padder.finalize()
    
    # Encrypt
    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(padded_data) + encryptor.finalize()
    
    return iv, ciphertext

def decrypt_aes_cbc(ciphertext, key, iv):
    """
    Decrypt AES-256 CBC encrypted data
    
    Args:
        ciphertext (bytes): Encrypted data
        key (bytes): 32-byte encryption key
        iv (bytes): Initialization vector
    
    Returns:
        bytes: Decrypted plaintext
    """
    # Create cipher object
    cipher = Cipher(
        algorithms.AES(key),
        modes.CBC(iv),
        backend=default_backend()
    )
    
    # Decrypt
    decryptor = cipher.decryptor()
    padded_plaintext = decryptor.update(ciphertext) + decryptor.finalize()
    
    # Remove padding
    unpadder = padding.PKCS7(128).unpadder()
    plaintext = unpadder.update(padded_plaintext) + unpadder.finalize()
    
    return plaintext

# Example usage
key = os.urandom(32)  # 256-bit key
message = b"This is a secret message!"

# Encrypt
iv, ciphertext = encrypt_aes_cbc(message, key)
print(f"Ciphertext (hex): {ciphertext.hex()}")

# Decrypt
decrypted = decrypt_aes_cbc(ciphertext, key, iv)
print(f"Decrypted: {decrypted.decode()}")
```

### Lab 2: RSA Key Generation and Encryption

```python
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes, serialization

# Generate RSA key pair
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048
)
public_key = private_key.public_key()

# Encrypt with public key
message = b"Secret data"
ciphertext = public_key.encrypt(
    message,
    padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(),
        label=None
    )
)

# Decrypt with private key
plaintext = private_key.decrypt(
    ciphertext,
    padding.OAEP(
        mgf=padding.MGF1(algorithm=hashes.SHA256()),
        algorithm=hashes.SHA256(),
        label=None
    )
)

print(f"Decrypted: {plaintext.decode()}")

# Save keys to files
with open("private_key.pem", "wb") as f:
    f.write(private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    ))

with open("public_key.pem", "wb") as f:
    f.write(public_key.public_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PublicFormat.SubjectPublicKeyInfo
    ))
```

---

## 🎮 Interactive Scenario: Choosing the Right Encryption

### Scenario: Secure Messaging App

**Your Task**: Design encryption for a new messaging app

**Requirements**:
- End-to-end encryption
- Forward secrecy
- Group messaging support
- File sharing
- Must work on mobile devices

---

### Decision Point 1: Encryption Algorithm

**Option A: AES-256 with Shared Keys**
- **Pros**: Fast, efficient, well-tested
- **Cons**: Key distribution problem, no forward secrecy
- **Use Case**: When you have secure key exchange

**Option B: RSA-2048**
- **Pros**: Asymmetric, no key distribution problem
- **Cons**: Slow, not suitable for large messages
- **Use Case**: Key exchange, digital signatures

**Option C: Signal Protocol (Double Ratchet)**
- **Pros**: Forward secrecy, post-compromise security
- **Cons**: Complex implementation
- **Use Case**: Modern messaging apps (WhatsApp, Signal)

**Option D: Hybrid (RSA + AES)**
- **Pros**: Best of both worlds
- **Cons**: More complex
- **Use Case**: Most real-world applications

**What would you choose?** _______________

**Recommended**: Option D (Hybrid) or Option C (Signal Protocol)

---

### Decision Point 2: Key Management

**How do you handle encryption keys?**

**Option A: Store Keys on Server**
- **Pros**: Easy backup and recovery
- **Cons**: Server can read messages (no true E2E)
- **Security**: Low

**Option B: Store Keys Only on Device**
- **Pros**: True end-to-end encryption
- **Cons**: Lost device = lost messages
- **Security**: High

**Option C: Key Escrow with User Password**
- **Pros**: Backup available, user controls access
- **Cons**: Weak passwords = weak security
- **Security**: Medium

**Option D: Secure Enclave / Hardware Security**
- **Pros**: Keys never leave secure hardware
- **Cons**: Device-specific, expensive
- **Security**: Very High

**Your choice**: _______________

---

## 📊 Encryption Performance Comparison

### Benchmark Results (1MB file):

| Algorithm | Encryption Time | Decryption Time | Key Size |
|-----------|----------------|-----------------|----------|
| AES-128   | 2.3 ms         | 2.1 ms          | 128 bits |
| AES-256   | 3.1 ms         | 2.9 ms          | 256 bits |
| RSA-2048  | 145 ms         | 8.2 ms          | 2048 bits|
| RSA-4096  | 890 ms         | 32 ms           | 4096 bits|
| ChaCha20  | 2.8 ms         | 2.7 ms          | 256 bits |

**Key Takeaway**: Use symmetric encryption (AES) for data, asymmetric (RSA) for key exchange.

---

## 🔍 Real-World Case Studies

### Case Study 1: WhatsApp End-to-End Encryption

**Implementation**:
- Signal Protocol (Double Ratchet Algorithm)
- X3DH key agreement
- AES-256 for message encryption
- HMAC-SHA256 for authentication

**Result**: 2+ billion users with E2E encryption

### Case Study 2: Apple FileVault

**Implementation**:
- XTS-AES-128 for full disk encryption
- Hardware-accelerated encryption
- Key derived from user password + hardware UID

**Result**: Transparent encryption with minimal performance impact

### Case Study 3: TLS 1.3

**Improvements over TLS 1.2**:
- Removed weak cipher suites
- Mandatory forward secrecy
- Encrypted handshake
- 0-RTT resumption

---

## 🛡️ Common Encryption Mistakes

### ❌ Mistake 1: Using ECB Mode
```python
# WRONG - ECB mode reveals patterns
cipher = AES.new(key, AES.MODE_ECB)
```

**Why it''s bad**: Identical plaintext blocks produce identical ciphertext blocks

**Fix**: Use CBC, GCM, or CTR mode with random IV

---

### ❌ Mistake 2: Hardcoded Keys
```python
# WRONG - Never hardcode keys
SECRET_KEY = "my_secret_key_123"
```

**Why it''s bad**: Keys in source code can be extracted

**Fix**: Use environment variables, key management systems (KMS)

---

### ❌ Mistake 3: Weak Random Number Generation
```python
# WRONG - Predictable random numbers
import random
key = random.randint(0, 2**256)
```

**Why it''s bad**: Not cryptographically secure

**Fix**: Use `os.urandom()` or `secrets` module

---

### ❌ Mistake 4: Rolling Your Own Crypto
```python
# WRONG - Custom encryption algorithm
def my_encryption(data, key):
    return bytes([d ^ k for d, k in zip(data, key)])
```

**Why it''s bad**: Likely to have vulnerabilities

**Fix**: Use established libraries (cryptography, NaCl)

---

## 🎓 Best Practices Checklist

- [ ] Use AES-256 or ChaCha20 for symmetric encryption
- [ ] Use RSA-2048+ or ECC-256+ for asymmetric encryption
- [ ] Always use authenticated encryption (GCM, ChaCha20-Poly1305)
- [ ] Generate keys with cryptographically secure RNG
- [ ] Use unique IVs/nonces for each encryption
- [ ] Implement proper key rotation
- [ ] Store keys securely (HSM, KMS, secure enclave)
- [ ] Use TLS 1.3 for network communication
- [ ] Implement forward secrecy
- [ ] Regular security audits

---

## 💻 Practical Exercise: Secure File Storage

**Task**: Build a secure file storage system

**Requirements**:
1. Encrypt files before storing
2. Each file has unique encryption key
3. Keys encrypted with master key
4. Support key rotation
5. Audit logging

**Starter Code**:
```python
import os
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend

class SecureFileStorage:
    def __init__(self, master_key):
        self.master_key = master_key
    
    def store_file(self, filename, data):
        # TODO: Generate file-specific key
        # TODO: Encrypt data with file key
        # TODO: Encrypt file key with master key
        # TODO: Store encrypted data and encrypted key
        pass
    
    def retrieve_file(self, filename):
        # TODO: Load encrypted data and encrypted key
        # TODO: Decrypt file key with master key
        # TODO: Decrypt data with file key
        # TODO: Return plaintext data
        pass
    
    def rotate_master_key(self, new_master_key):
        # TODO: Re-encrypt all file keys with new master key
        pass
```

**Solution**: Available in next lesson

---

## 📚 Additional Resources

### Video Tutorials:
- [Cryptography Crash Course](https://www.youtube.com/placeholder1) - 45 min
- [TLS 1.3 Deep Dive](https://www.youtube.com/placeholder2) - 60 min
- [Hardware Security Modules](https://www.youtube.com/placeholder3) - 30 min

### Books:
- "Serious Cryptography" by Jean-Philippe Aumasson
- "Cryptography Engineering" by Ferguson, Schneier, Kohno
- "Applied Cryptography" by Bruce Schneier

### Online Courses:
- Coursera: Cryptography I (Stanford)
- Udacity: Applied Cryptography
- Cybrary: Cryptography Fundamentals

---

## ✅ Knowledge Check

Before proceeding, ensure you can:
- [ ] Explain the difference between symmetric and asymmetric encryption
- [ ] Implement AES encryption correctly
- [ ] Generate and use RSA key pairs
- [ ] Choose appropriate encryption for different scenarios
- [ ] Identify common encryption mistakes
- [ ] Implement secure key management

---

## 🎬 Next Video

In the next lesson, you''ll watch **"Post-Quantum Cryptography: Preparing for the Quantum Threat"**, where you''ll learn about quantum-resistant algorithms and migration strategies.
'
WHERE section_id IN (SELECT id FROM sections WHERE name LIKE '%Encryption%' LIMIT 1)
AND content_type = 'video' LIMIT 1;

-- ============================================================================
-- POST-QUANTUM COMPUTING - INTERACTIVE SCENARIO
-- ============================================================================

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes)
VALUES (
    (SELECT id FROM sections WHERE name LIKE '%Quantum%' LIMIT 1),
    'Interactive Scenario: Quantum Threat Assessment',
    '# 🔮 Interactive Scenario: Your Organization Faces the Quantum Threat

## 🎯 Scenario Overview

**Your Role**: Chief Information Security Officer (CISO)  
**Company**: GlobalBank Inc.  
**Date**: 2026  
**Situation**: Intelligence reports suggest quantum computers capable of breaking RSA-2048 may be available within 5-10 years

---

## 📊 Current State Assessment

### Your Organization''s Cryptographic Inventory:

**External Communications**:
- TLS 1.3 with RSA-2048 certificates
- 500,000 customer connections daily
- Certificate validity: 2 years

**Data at Rest**:
- AES-256 encryption for databases
- RSA-2048 for key encryption
- 50 TB of sensitive customer data
- Data retention: 10 years

**Digital Signatures**:
- RSA-2048 for document signing
- ECDSA P-256 for code signing
- 1 million signatures per month

**VPN Infrastructure**:
- IPsec with RSA-2048 key exchange
- 10,000 remote employees
- Third-party vendor access

---

## 🎮 Decision Point 1: Risk Assessment

**Question**: How urgent is the quantum threat to your organization?

### Option A: Critical - Act Immediately
**Reasoning**:
- "Harvest now, decrypt later" attacks
- Long data retention periods
- High-value targets (financial data)
- Regulatory compliance requirements

**Action**: Start migration within 6 months

---

### Option B: Important - Plan for 2-3 Years
**Reasoning**:
- Quantum computers still experimental
- Standards still evolving
- Need time for testing
- Budget constraints

**Action**: Develop migration roadmap, pilot projects

---

### Option C: Low Priority - Monitor Situation
**Reasoning**:
- Quantum computers far from practical
- Current encryption still secure
- Other priorities more urgent
- Wait for mature solutions

**Action**: Annual reviews, no immediate action

---

### Option D: Hybrid Approach
**Reasoning**:
- Protect most sensitive data now
- Gradual migration for rest
- Balance risk and resources
- Learn from early adoption

**Action**: Prioritize critical systems, phased rollout

---

## 🤔 What Would You Choose?

**Your Decision**: _______________

**Industry Recommendation**: **Option D (Hybrid Approach)**

**Why?**
- Balances urgency with practicality
- Protects most critical assets first
- Allows learning and adjustment
- Manages budget effectively

---

## 📋 Decision Point 2: Migration Strategy

**Assuming you chose Option D, which systems do you migrate first?**

### Priority 1: Long-Term Secrets
- [ ] Root CA certificates (20-year lifetime)
- [ ] Master encryption keys
- [ ] Backup encryption keys
- [ ] Hardware security modules (HSMs)

**Rationale**: These have the longest exposure window

---

### Priority 2: High-Value Data
- [ ] Customer financial records
- [ ] Intellectual property
- [ ] Trade secrets
- [ ] Executive communications

**Rationale**: Highest impact if compromised

---

### Priority 3: External Communications
- [ ] TLS certificates
- [ ] VPN infrastructure
- [ ] Email encryption
- [ ] API authentication

**Rationale**: Most vulnerable to interception

---

### Priority 4: Internal Systems
- [ ] Internal databases
- [ ] File servers
- [ ] Development systems
- [ ] Test environments

**Rationale**: Lower risk, can migrate later

---

## 💰 Budget Allocation Decision

**Total Budget**: $5 million  
**Timeline**: 3 years

**How do you allocate resources?**

### Option A: Technology-Focused
- $3M - New quantum-resistant infrastructure
- $1M - Software updates and licenses
- $500K - Training and documentation
- $500K - Consulting and audits

---

### Option B: Balanced Approach
- $2M - Infrastructure upgrades
- $1.5M - Software and integration
- $1M - Staff training and hiring
- $500K - External expertise

---

### Option C: People-First
- $2M - Hiring quantum cryptography experts
- $1.5M - Training existing staff
- $1M - Technology upgrades
- $500K - Pilot projects

---

### Option D: Phased Investment
- Year 1: $1M - Planning and pilots
- Year 2: $2M - Core infrastructure
- Year 3: $2M - Full deployment

**Your choice**: _______________

---

## 🔬 Technical Decision: Algorithm Selection

**Which post-quantum algorithms do you adopt?**

### For Key Exchange:

**Option A: CRYSTALS-Kyber**
- NIST selected for standardization
- Good performance
- Moderate key sizes
- **Status**: Recommended

**Option B: Classic McEliece**
- Very conservative security
- Large key sizes (1MB+)
- Slow key generation
- **Status**: Alternative

**Option C: NTRU**
- Fast operations
- Reasonable key sizes
- Longer history
- **Status**: Under consideration

---

### For Digital Signatures:

**Option A: CRYSTALS-Dilithium**
- NIST selected
- Good balance of size and speed
- **Status**: Recommended

**Option B: FALCON**
- Smaller signatures
- More complex implementation
- **Status**: Alternative

**Option C: SPHINCS+**
- Hash-based (very conservative)
- Large signatures
- Slow signing
- **Status**: Backup option

---

## 📊 Implementation Roadmap

### Phase 1: Preparation (Months 1-6)
```
✓ Inventory all cryptographic systems
✓ Assess quantum vulnerability
✓ Select post-quantum algorithms
✓ Develop migration plan
✓ Secure budget approval
✓ Hire/train staff
```

### Phase 2: Pilot Projects (Months 7-12)
```
✓ Deploy hybrid TLS (classical + PQC)
✓ Test performance impact
✓ Validate interoperability
✓ Measure user experience
✓ Document lessons learned
```

### Phase 3: Critical Systems (Year 2)
```
✓ Migrate root CAs
✓ Update HSMs
✓ Re-encrypt master keys
✓ Deploy new VPN infrastructure
✓ Update high-value data encryption
```

### Phase 4: Broad Deployment (Year 3)
```
✓ Migrate all TLS certificates
✓ Update all applications
✓ Migrate remaining databases
✓ Complete internal systems
✓ Decommission old systems
```

---

## 🎓 Real-World Examples

### Case Study 1: Google''s CECPQ2

**Implementation**:
- Hybrid key exchange (X25519 + NTRU-HRSS)
- Deployed in Chrome browser
- Tested with millions of users

**Results**:
- Minimal performance impact (<1ms latency)
- No compatibility issues
- Valuable operational experience

**Lesson**: Hybrid approaches work in production

---

### Case Study 2: Cloudflare''s PQC Experiment

**Implementation**:
- Tested multiple PQC algorithms
- Measured real-world performance
- Published detailed results

**Findings**:
- Key sizes matter for mobile networks
- CPU impact manageable
- Memory usage increased 2-3x

**Lesson**: Performance testing is critical

---

## 🛡️ Risk Mitigation Strategies

### Strategy 1: Crypto-Agility
```
Design systems to easily swap algorithms:
- Abstract cryptographic operations
- Use configuration-driven crypto selection
- Implement version negotiation
- Plan for future migrations
```

### Strategy 2: Hybrid Cryptography
```
Use both classical and post-quantum:
- Provides defense in depth
- Protects against PQC vulnerabilities
- Smooth transition path
- Backward compatibility
```

### Strategy 3: Data Classification
```
Prioritize based on sensitivity:
- Top Secret: Migrate immediately
- Secret: Migrate within 1 year
- Confidential: Migrate within 2 years
- Public: No urgency
```

---

## 📈 Success Metrics

**How do you measure success?**

### Technical Metrics:
- [ ] % of systems migrated to PQC
- [ ] Performance impact (<5% degradation)
- [ ] Zero security incidents
- [ ] Compatibility maintained

### Business Metrics:
- [ ] On-time delivery
- [ ] Within budget
- [ ] No customer impact
- [ ] Regulatory compliance

### Organizational Metrics:
- [ ] Staff trained (100%)
- [ ] Documentation complete
- [ ] Incident response ready
- [ ] Continuous monitoring

---

## 🎯 Final Decision: Communication Strategy

**How do you communicate this to stakeholders?**

### To Board of Directors:
**Focus on**:
- Business risk
- Regulatory compliance
- Competitive advantage
- Budget justification

**Message**: "Proactive investment to protect $X billion in assets"

---

### To Technical Teams:
**Focus on**:
- Technical details
- Implementation timeline
- Training needs
- Support resources

**Message**: "Exciting opportunity to work with cutting-edge technology"

---

### To Customers:
**Focus on**:
- Enhanced security
- Future-proofing
- No service disruption
- Continued trust

**Message**: "We''re investing in your security for the next decade"

---

### To Regulators:
**Focus on**:
- Compliance
- Risk management
- Industry leadership
- Detailed planning

**Message**: "Comprehensive approach to emerging quantum threat"

---

## 💡 Reflection Questions

1. **What surprised you most about the quantum threat?**
   - Urgency of "harvest now, decrypt later"
   - Complexity of migration
   - Cost implications
   - Organizational challenges

2. **What would you do differently?**
   - Start earlier?
   - Allocate more budget?
   - Different priorities?
   - Better communication?

3. **What are the biggest challenges?**
   - Technical complexity
   - Budget constraints
   - Staff expertise
   - Vendor readiness

4. **How confident are you in your decisions?**
   - Very confident
   - Somewhat confident
   - Need more information
   - Would seek expert advice

---

## 📚 Additional Resources

### NIST Post-Quantum Cryptography:
- https://csrc.nist.gov/projects/post-quantum-cryptography

### Migration Guides:
- "Preparing for Post-Quantum Cryptography" (NIST)
- "Quantum Threat Timeline Report" (Global Risk Institute)
- "PQC Migration Handbook" (ETSI)

### Industry Working Groups:
- Cloud Security Alliance - Quantum-Safe Security
- IETF - Post-Quantum Use in Protocols
- ISO/IEC JTC 1/SC 27 - Quantum-safe cryptography

---

## ✅ Scenario Completion

**Congratulations!** You''ve navigated a complex quantum threat scenario.

**Key Takeaways**:
- Quantum threat is real but manageable
- Hybrid approaches provide smooth transition
- Prioritization is critical
- Communication is as important as technology
- Start planning now, even if deployment is years away

---

## 🎬 Next Lesson

In the next lesson, you''ll learn about **"Implementing Quantum-Resistant Algorithms"** with hands-on coding exercises using CRYSTALS-Kyber and Dilithium.
',
    'interactive',
    3,
    50
);

-- ============================================================================
-- THREAT INTELLIGENCE - VIDEO LESSON
-- ============================================================================

UPDATE lessons SET content = '
# Threat Intelligence Analysis - Video Workshop

## 📹 Watch: Cyber Threat Intelligence Fundamentals

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/placeholder_threat_intel" 
    title="Cyber Threat Intelligence Analysis" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 90 minutes  
**Difficulty**: Intermediate to Advanced  
**Instructor**: Former NSA Threat Analyst

---

## 📚 Video Chapters

### Chapter 1: Introduction to CTI (0:00 - 15:00)
- What is Cyber Threat Intelligence?
- Strategic vs Tactical vs Operational Intelligence
- The Intelligence Cycle
- CTI Frameworks (MITRE ATT&CK, Diamond Model, Kill Chain)

### Chapter 2: Collection Methods (15:00 - 35:00)
- Open Source Intelligence (OSINT)
- Technical Intelligence (TECHINT)
- Human Intelligence (HUMINT)
- Commercial threat feeds
- Information Sharing and Analysis Centers (ISACs)

### Chapter 3: Analysis Techniques (35:00 - 60:00)
- Indicator analysis (IOCs)
- Behavioral analysis (TTPs)
- Attribution techniques
- Threat actor profiling
- Campaign tracking

### Chapter 4: Operationalizing Intelligence (60:00 - 80:00)
- Integration with SIEM
- Automated threat hunting
- Incident response integration
- Threat intelligence platforms (TIPs)

### Chapter 5: Reporting and Dissemination (80:00 - 90:00)
- Writing intelligence reports
- Tailoring to audience
- Traffic Light Protocol (TLP)
- Metrics and KPIs

---

## 🎯 Hands-On Exercise: Analyzing a Threat Campaign

### Scenario: APT29 (Cozy Bear) Campaign Analysis

**Intelligence Report**:
```
Date: 2026-01-15
Source: Multiple ISACs
Confidence: High

SUMMARY:
Advanced Persistent Threat group APT29 (aka Cozy Bear, The Dukes) 
has been observed targeting government agencies and think tanks 
in North America and Europe.

INDICATORS OF COMPROMISE (IOCs):
- IP: 185.220.101.45
- Domain: update-service[.]com
- Hash: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
- Email: admin@legitimate-looking-domain.com

TACTICS, TECHNIQUES, AND PROCEDURES (TTPs):
- Initial Access: Spear-phishing emails
- Execution: PowerShell scripts
- Persistence: Scheduled tasks
- Defense Evasion: Process injection
- C2: HTTPS to legitimate-looking domains
- Exfiltration: Encrypted archives to cloud storage
```

---

### Your Task: Complete Threat Analysis

**Step 1: Validate IOCs**
```bash
# Check IP reputation
curl -s "https://www.abuseipdb.com/check/185.220.101.45"

# Check domain registration
whois update-service.com

# Check file hash
curl -s "https://www.virustotal.com/api/v3/files/a1b2c3d4..."

# Search for related indicators
grep -r "185.220.101.45" /var/log/
```

**Step 2: Map to MITRE ATT&CK**
```
Initial Access:
- T1566.001: Phishing: Spearphishing Attachment

Execution:
- T1059.001: Command and Scripting Interpreter: PowerShell

Persistence:
- T1053.005: Scheduled Task/Job: Scheduled Task

Defense Evasion:
- T1055: Process Injection

Command and Control:
- T1071.001: Application Layer Protocol: Web Protocols

Exfiltration:
- T1567.002: Exfiltration Over Web Service: Cloud Storage
```

**Step 3: Assess Impact to Your Organization**
```
Questions to answer:
1. Do we have similar attack surface?
2. Would our controls detect this?
3. What is our exposure level?
4. What immediate actions should we take?
```

---

## 🔍 Interactive Analysis Exercise

### Exercise: Threat Actor Attribution

**Given Information**:
- Attack time: 09:00-17:00 UTC+3 (Moscow time)
- Language artifacts: Russian keyboard layout
- Targets: Government agencies, defense contractors
- Sophistication: High (custom malware, zero-days)
- Motivation: Espionage (no financial gain)

**Question**: Which threat actor group is most likely responsible?

**Option A: APT28 (Fancy Bear)**
- Russian military intelligence (GRU)
- Targets: Government, military, media
- Known for: Aggressive tactics, political targets

**Option B: APT29 (Cozy Bear)**
- Russian foreign intelligence (SVR)
- Targets: Government, think tanks, research
- Known for: Stealth, long-term access

**Option C: Lazarus Group**
- North Korean state-sponsored
- Targets: Financial, cryptocurrency, defense
- Known for: Destructive attacks, financial theft

**Option D: FIN7**
- Financially motivated cybercrime group
- Targets: Retail, hospitality, financial
- Known for: Point-of-sale malware, ransomware

**Your analysis**: _______________

**Correct Answer**: **APT29** (Cozy Bear)
- Matches operational hours (Moscow timezone)
- Espionage motivation (not financial)
- Target profile (government/research)
- High sophistication level

---

## 📊 Threat Intelligence Platforms Demo

### Popular TIP Solutions:

**1. MISP (Open Source)**
```bash
# Install MISP
git clone https://github.com/MISP/MISP.git
cd MISP
./INSTALL/INSTALL.sh

# Import threat feed
curl -X POST https://misp.local/feeds/import \
  -H "Authorization: YOUR_API_KEY" \
  -d ''{"feed_id": 1}''
```

**2. OpenCTI (Open Source)**
```yaml
# docker-compose.yml
version: ''3''
services:
  opencti:
    image: opencti/platform:latest
    environment:
      - APP__PORT=8080
      - APP__ADMIN__EMAIL=admin@opencti.io
      - APP__ADMIN__PASSWORD=ChangeMePlease
```

**3. ThreatConnect (Commercial)**
- Enterprise-grade TIP
- Integrations with 100+ security tools
- Automated playbooks
- Threat scoring and prioritization

---

## 🎓 Building a Threat Intelligence Program

### Phase 1: Foundation (Months 1-3)
```
✓ Define intelligence requirements
✓ Identify stakeholders
✓ Select tools and platforms
✓ Establish collection sources
✓ Hire/train analysts
```

### Phase 2: Operations (Months 4-6)
```
✓ Begin daily collection
✓ Develop analysis processes
✓ Create reporting templates
✓ Integrate with security tools
✓ Establish metrics
```

### Phase 3: Maturity (Months 7-12)
```
✓ Automated threat hunting
✓ Predictive analysis
✓ Threat actor tracking
✓ Information sharing
✓ Continuous improvement
```

---

## 💻 Practical Lab: Build a Threat Feed Aggregator

**Task**: Create a Python script to aggregate threat intelligence

```python
import requests
import json
from datetime import datetime

class ThreatFeedAggregator:
    def __init__(self):
        self.feeds = {
            ''abuseipdb'': ''https://api.abuseipdb.com/api/v2/blacklist'',
            ''otx'': ''https://otx.alienvault.com/api/v1/pulses/subscribed'',
            ''threatfox'': ''https://threatfox-api.abuse.ch/api/v1/''
        }
        self.indicators = []
    
    def fetch_abuseipdb(self, api_key):
        """Fetch malicious IPs from AbuseIPDB"""
        headers = {
            ''Key'': api_key,
            ''Accept'': ''application/json''
        }
        response = requests.get(
            self.feeds[''abuseipdb''],
            headers=headers,
            params={''confidenceMinimum'': 90}
        )
        data = response.json()
        
        for item in data[''data'']:
            self.indicators.append({
                ''type'': ''ip'',
                ''value'': item[''ipAddress''],
                ''confidence'': item[''abuseConfidenceScore''],
                ''source'': ''AbuseIPDB'',
                ''timestamp'': datetime.now().isoformat()
            })
    
    def fetch_otx(self, api_key):
        """Fetch indicators from AlienVault OTX"""
        headers = {''X-OTX-API-KEY'': api_key}
        response = requests.get(
            self.feeds[''otx''],
            headers=headers
        )
        data = response.json()
        
        for pulse in data[''results'']:
            for indicator in pulse[''indicators'']:
                self.indicators.append({
                    ''type'': indicator[''type''],
                    ''value'': indicator[''indicator''],
                    ''confidence'': 75,  # Default confidence
                    ''source'': ''AlienVault OTX'',
                    ''timestamp'': datetime.now().isoformat()
                })
    
    def export_to_misp(self, misp_url, misp_key):
        """Export indicators to MISP"""
        headers = {
            ''Authorization'': misp_key,
            ''Content-Type'': ''application/json''
        }
        
        event = {
            ''Event'': {
                ''info'': f''Aggregated Threat Feed - {datetime.now().date()}'',
                ''threat_level_id'': 2,
                ''analysis'': 1,
                ''Attribute'': []
            }
        }
        
        for indicator in self.indicators:
            event[''Event''][''Attribute''].append({
                ''type'': indicator[''type''],
                ''value'': indicator[''value''],
                ''comment'': f''Source: {indicator["source"]}'',
                ''to_ids'': True
            })
        
        response = requests.post(
            f''{misp_url}/events'',
            headers=headers,
            json=event
        )
        return response.json()
    
    def generate_report(self):
        """Generate intelligence report"""
        report = {
            ''title'': ''Daily Threat Intelligence Report'',
            ''date'': datetime.now().isoformat(),
            ''summary'': {
                ''total_indicators'': len(self.indicators),
                ''by_type'': {},
                ''by_source'': {}
            },
            ''indicators'': self.indicators
        }
        
        # Count by type
        for indicator in self.indicators:
            ioc_type = indicator[''type'']
            report[''summary''][''by_type''][ioc_type] = \
                report[''summary''][''by_type''].get(ioc_type, 0) + 1
        
        # Count by source
        for indicator in self.indicators:
            source = indicator[''source'']
            report[''summary''][''by_source''][source] = \
                report[''summary''][''by_source''].get(source, 0) + 1
        
        return report

# Usage example
aggregator = ThreatFeedAggregator()
aggregator.fetch_abuseipdb(''YOUR_API_KEY'')
aggregator.fetch_otx(''YOUR_API_KEY'')
report = aggregator.generate_report()
print(json.dumps(report, indent=2))
```

---

## 📈 Measuring CTI Effectiveness

### Key Performance Indicators:

**1. Detection Metrics**
- Time to detect (TTD)
- Detection rate
- False positive rate

**2. Response Metrics**
- Time to respond (TTR)
- Time to contain (TTC)
- Time to recover (TTRec)

**3. Intelligence Metrics**
- Number of IOCs collected
- Intelligence reports produced
- Actionable intelligence percentage

**4. Business Metrics**
- Incidents prevented
- Cost savings
- Risk reduction

---

## 🎬 Next Video

In the next lesson, you''ll watch **"Advanced Threat Hunting Techniques"**, where you''ll learn to proactively search for threats in your environment using hypothesis-driven hunting.

---

## 📚 Recommended Reading

- "The Threat Intelligence Handbook" by SANS
- "Intelligence-Driven Incident Response" by Scott Roberts
- "Cyber Threat Intelligence" by Martin Lee

---

## ✅ Knowledge Check

- [ ] Can you explain the intelligence cycle?
- [ ] Can you map TTPs to MITRE ATT&CK?
- [ ] Can you perform basic threat actor attribution?
- [ ] Can you write an intelligence report?
- [ ] Can you integrate threat feeds with security tools?
'
WHERE section_id IN (SELECT id FROM sections WHERE name LIKE '%Threat Intelligence%' LIMIT 1)
AND content_type = 'video' LIMIT 1;

COMMIT;

-- Made with Bob
