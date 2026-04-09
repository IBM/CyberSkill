-- CyberSkill Platform - Interactive Content and Video Integration
-- Version: 1.3.0
-- Description: Adds video lessons, interactive scenarios, and decision-making exercises

-- ============================================================================
-- VIDEO LESSONS WITH EMBEDDED CONTENT
-- ============================================================================

-- Penetration Testing - Reconnaissance Video Lesson
UPDATE lessons SET content = '
# Reconnaissance and Information Gathering - Video Tutorial

## 📹 Watch: Advanced OSINT Techniques

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/dQw4w9WgXcQ" 
    title="Advanced OSINT and Reconnaissance Techniques" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 45 minutes  
**Difficulty**: Intermediate  
**Topics Covered**:
- Passive reconnaissance techniques
- Google dorking and advanced search operators
- Social media intelligence (SOCMINT)
- DNS enumeration and subdomain discovery
- WHOIS and domain registration analysis

---

## 📝 Video Summary

### Key Takeaways

1. **Passive vs Active Reconnaissance**
   - Passive: Gathering information without directly interacting with target
   - Active: Direct interaction that may be detected

2. **Google Dorking Examples**
```
site:example.com filetype:pdf
intitle:"index of" "parent directory"
inurl:admin site:example.com
"powered by" site:example.com
```

3. **Tools Demonstrated**
   - **theHarvester**: Email and subdomain enumeration
   - **Recon-ng**: Comprehensive OSINT framework
   - **Maltego**: Visual link analysis
   - **Shodan**: Internet-connected device search engine

### Practical Commands from Video

```bash
# theHarvester - Email enumeration
theHarvester -d example.com -b google,bing,linkedin

# Recon-ng - Subdomain discovery
recon-ng
[recon-ng][default] > use recon/domains-hosts/brute_hosts
[recon-ng][default][brute_hosts] > set SOURCE example.com
[recon-ng][default][brute_hosts] > run

# Sublist3r - Subdomain enumeration
sublist3r -d example.com -o subdomains.txt

# DNSRecon - DNS enumeration
dnsrecon -d example.com -t std

# Shodan CLI
shodan search "org:Example Company"
```

---

## 🎯 Hands-On Exercise

After watching the video, complete this exercise:

### Task: Reconnaissance on a Test Target

**Target**: scanme.nmap.org (Legal test target)

**Steps**:
1. Perform WHOIS lookup
2. Enumerate subdomains
3. Identify technologies used
4. Map the attack surface
5. Document findings

**Deliverable**: Create a reconnaissance report with:
- Domain information
- IP addresses and hosting details
- Identified subdomains
- Technologies and versions
- Potential entry points

---

## 📚 Additional Resources

### Video Tutorials
- [OSINT Framework Overview](https://www.youtube.com/placeholder1)
- [Google Dorking Masterclass](https://www.youtube.com/placeholder2)
- [Shodan Tutorial Series](https://www.youtube.com/placeholder3)

### Reading Materials
- OSINT Framework: https://osintframework.com/
- Google Hacking Database: https://www.exploit-db.com/google-hacking-database
- Shodan Documentation: https://help.shodan.io/

### Practice Platforms
- TryHackMe OSINT Room: https://tryhackme.com/room/ohsint
- HackTheBox Starting Point: https://www.hackthebox.eu/

---

## ✅ Knowledge Check

Before moving to the next lesson, ensure you can:
- [ ] Explain the difference between passive and active reconnaissance
- [ ] Use Google dorking to find sensitive information
- [ ] Enumerate subdomains using multiple tools
- [ ] Analyze WHOIS data for intelligence gathering
- [ ] Document reconnaissance findings professionally

---

## 🎬 Next Video

In the next lesson, you''ll watch a video on **Vulnerability Scanning with Nessus and OpenVAS**, where you''ll learn to identify security weaknesses in target systems.
'
WHERE section_id = 2 AND content_type = 'video' LIMIT 1;

-- ============================================================================
-- INTERACTIVE DECISION-MAKING SCENARIOS
-- ============================================================================

-- Scenario 1: Incident Response Decision Making
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes)
VALUES (
    1,
    'Interactive Scenario: Data Breach Response',
    '# 🚨 Interactive Scenario: You''re the Incident Response Lead

## Situation Briefing

**Date**: Monday, 3:47 AM  
**Your Role**: Senior Security Analyst / Incident Response Lead  
**Company**: TechCorp Inc. (5,000 employees, handles customer PII)  
**Alert**: Automated monitoring detected unusual database queries

---

## 📊 Initial Information

### What You Know:
- Unusual SQL queries detected at 3:15 AM
- Queries accessing customer database (500,000 records)
- Source IP: 203.0.113.45 (External, Russia)
- Database: Production customer database
- Data accessed: Names, emails, phone numbers, addresses
- Current time: 3:47 AM (32 minutes since detection)

### Available Resources:
- Security team (2 analysts on-call)
- Database administrator (on-call)
- Legal team (available in 4 hours)
- PR team (available in 4 hours)
- CEO (can be reached immediately)

---

## 🎯 DECISION POINT 1: Immediate Action

**You have 5 minutes to decide. What is your FIRST action?**

### Option A: Immediately Shut Down the Database
**Pros:**
- Stops potential data exfiltration immediately
- Prevents further unauthorized access
- Shows decisive action

**Cons:**
- Disrupts all business operations
- May destroy forensic evidence
- Could affect legitimate users
- Revenue impact: $50,000/hour downtime

**Choose A if**: Stopping the breach is top priority, regardless of business impact

---

### Option B: Isolate the Affected Database Server
**Pros:**
- Stops the attack while preserving evidence
- Allows forensic analysis
- Minimal business disruption (failover available)
- Can monitor attacker''s actions

**Cons:**
- Takes 10-15 minutes to implement
- Attacker might exfiltrate more data during isolation
- Requires coordination with database team

**Choose B if**: You want to balance security and business continuity

---

### Option C: Monitor and Gather Evidence First
**Pros:**
- Collect maximum forensic evidence
- Understand full scope of breach
- Identify attacker''s methods and goals
- Can build stronger legal case

**Cons:**
- Allows continued data access
- Potential for more data loss
- May violate compliance requirements
- Could be seen as negligent

**Choose C if**: Understanding the full attack is priority

---

### Option D: Immediately Notify Law Enforcement
**Pros:**
- Legal requirement in some jurisdictions
- Professional investigation
- Potential to catch attacker

**Cons:**
- May delay technical response
- Could leak information publicly
- Loss of control over investigation
- Media attention

**Choose D if**: Legal compliance is your primary concern

---

## 🤔 Make Your Decision

**What would you choose? A, B, C, or D?**

---

## 📋 DECISION POINT 2: Communication Strategy

**Assuming you chose Option B (Isolate the server), 30 minutes have passed.**

### New Information:
- Server isolated successfully
- Forensics show: 50,000 customer records accessed
- No evidence of data exfiltration yet
- Attacker used stolen credentials (employee account)
- Attack started 6 hours ago (earlier than detected)

**Who do you notify first?**

### Option A: CEO Immediately
- Required for major incidents
- Needs to make business decisions
- May want to involve board

### Option B: Legal Team First
- Assess regulatory obligations
- Determine notification requirements
- Protect company legally

### Option C: Affected Customers
- Ethical obligation
- May be legal requirement
- Builds trust

### Option D: Continue Investigation First
- Get complete picture
- Avoid premature notifications
- Ensure accuracy of information

---

## 🎓 Learning Objectives

This scenario teaches:

1. **Incident Response Priorities**
   - Containment vs. Evidence preservation
   - Business continuity considerations
   - Legal and regulatory requirements

2. **Decision-Making Under Pressure**
   - Weighing pros and cons quickly
   - Considering multiple stakeholders
   - Balancing competing priorities

3. **Communication Strategy**
   - Who to notify and when
   - Information flow management
   - Stakeholder management

---

## 📊 Industry Best Practices

### NIST Incident Response Framework

1. **Preparation**: Have plans and tools ready
2. **Detection & Analysis**: Identify and understand the incident
3. **Containment, Eradication & Recovery**: Stop the attack and restore
4. **Post-Incident Activity**: Learn and improve

### Recommended Decision for This Scenario

**Most security professionals would choose:**

**First Action**: **Option B** (Isolate the server)
- Balances containment with evidence preservation
- Allows business continuity through failover
- Enables thorough investigation

**Communication**: **Option B** (Legal team first)
- Determines legal obligations
- Guides notification strategy
- Protects company from liability

---

## 🔍 Real-World Case Study: Equifax Breach (2017)

**Similar Scenario**:
- 147 million records compromised
- Delayed response and notification
- Cost: $1.4 billion in settlements

**Key Lessons**:
- Early detection is critical
- Immediate containment saves money
- Transparent communication builds trust
- Legal compliance is non-negotiable

---

## 💡 Reflection Questions

1. What factors influenced your decision?
2. How would your decision change if this happened during business hours?
3. What if the data included credit card numbers?
4. How would you handle media inquiries?
5. What preventive measures could have stopped this?

---

## 📝 Your Action Plan

Create your own incident response plan:

```
1. Detection:
   - Monitoring tools: _______________
   - Alert thresholds: _______________

2. Initial Response:
   - First responder: _______________
   - Escalation path: _______________

3. Containment:
   - Isolation procedures: _______________
   - Evidence preservation: _______________

4. Communication:
   - Internal notifications: _______________
   - External notifications: _______________

5. Recovery:
   - Restoration steps: _______________
   - Validation process: _______________
```

---

## 🎯 Next Scenario

In the next interactive lesson, you''ll face a **Ransomware Attack Scenario** where you must decide whether to pay the ransom, negotiate, or attempt recovery.

**Remember**: There''s rarely a "perfect" decision in incident response. The goal is to make the best decision with available information under time pressure.
',
    'interactive',
    4,
    45
);

-- ============================================================================
-- COMPLIANCE PATH - GDPR VIDEO LESSON
-- ============================================================================

UPDATE lessons SET content = '
# GDPR Compliance Fundamentals - Video Course

## 📹 Watch: Understanding GDPR Requirements

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/placeholder_gdpr" 
    title="GDPR Compliance Fundamentals" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 60 minutes  
**Difficulty**: Beginner to Intermediate  
**Instructor**: EU Data Protection Expert  

---

## 📚 Video Chapters

### Chapter 1: Introduction to GDPR (0:00 - 10:00)
- What is GDPR?
- Who does it apply to?
- Key principles of data protection

### Chapter 2: Legal Basis for Processing (10:00 - 25:00)
- Consent
- Contract
- Legal obligation
- Vital interests
- Public task
- Legitimate interests

### Chapter 3: Individual Rights (25:00 - 40:00)
- Right to access
- Right to rectification
- Right to erasure ("right to be forgotten")
- Right to data portability
- Right to object

### Chapter 4: Compliance Requirements (40:00 - 55:00)
- Data Protection Impact Assessments (DPIA)
- Data Protection Officer (DPO) requirements
- Breach notification (72-hour rule)
- Record-keeping obligations

### Chapter 5: Penalties and Enforcement (55:00 - 60:00)
- Fine structure (up to €20 million or 4% of revenue)
- Recent enforcement actions
- How to avoid penalties

---

## 🎯 Interactive Exercise: GDPR Compliance Audit

### Scenario: E-Commerce Website Audit

**Company**: OnlineShop.eu  
**Data Processed**: Customer names, emails, addresses, payment info, browsing history  
**Your Task**: Identify GDPR compliance gaps

#### Audit Checklist:

**1. Legal Basis**
- [ ] Is there a clear legal basis for each type of data processing?
- [ ] Is consent obtained where required?
- [ ] Are consent mechanisms compliant (clear, specific, informed)?

**2. Transparency**
- [ ] Is there a privacy policy?
- [ ] Is it written in clear, plain language?
- [ ] Does it explain all data processing activities?

**3. Individual Rights**
- [ ] Can users access their data?
- [ ] Can users download their data (portability)?
- [ ] Can users delete their accounts and data?
- [ ] Is there a process for handling data subject requests?

**4. Security**
- [ ] Is data encrypted in transit (HTTPS)?
- [ ] Is data encrypted at rest?
- [ ] Are there access controls?
- [ ] Is there a breach response plan?

**5. Third Parties**
- [ ] Are there Data Processing Agreements with vendors?
- [ ] Are international transfers compliant?
- [ ] Are third-party processors GDPR-compliant?

---

## 📊 Real-World GDPR Fines

### Major Penalties:

| Company | Fine | Violation | Year |
|---------|------|-----------|------|
| Amazon | €746M | Improper data processing | 2021 |
| WhatsApp | €225M | Transparency violations | 2021 |
| Google | €90M | Cookie consent issues | 2020 |
| H&M | €35M | Excessive employee monitoring | 2020 |

---

## 🎓 Key Takeaways from Video

### The 7 Principles of GDPR:

1. **Lawfulness, Fairness, Transparency**
   - Process data legally and transparently

2. **Purpose Limitation**
   - Collect data for specific, explicit purposes

3. **Data Minimization**
   - Only collect necessary data

4. **Accuracy**
   - Keep data accurate and up-to-date

5. **Storage Limitation**
   - Don''t keep data longer than necessary

6. **Integrity and Confidentiality**
   - Protect data with appropriate security

7. **Accountability**
   - Demonstrate compliance

---

## 💼 Practical Implementation Guide

### Step 1: Data Mapping
```
1. Identify all personal data you collect
2. Document where it''s stored
3. Map data flows (internal and external)
4. Identify legal basis for each processing activity
```

### Step 2: Privacy by Design
```
1. Implement data protection from the start
2. Use pseudonymization where possible
3. Implement access controls
4. Enable data portability
```

### Step 3: Documentation
```
1. Maintain Records of Processing Activities (ROPA)
2. Document Data Protection Impact Assessments
3. Keep consent records
4. Document security measures
```

### Step 4: Training
```
1. Train all staff on GDPR requirements
2. Designate a Data Protection Officer (if required)
3. Create incident response procedures
4. Regular compliance reviews
```

---

## 🔍 Interactive Case Study

### Scenario: Marketing Email Campaign

**Situation**: Your company wants to send marketing emails to 100,000 customers.

**Questions**:
1. What legal basis can you use?
2. What information must be in the email?
3. How should you handle unsubscribe requests?
4. What records must you keep?

**Your Analysis**:
```
Legal Basis: _______________
Required Information: _______________
Unsubscribe Process: _______________
Record-Keeping: _______________
```

**Correct Answer**:
- **Legal Basis**: Consent (must be freely given, specific, informed)
- **Required Information**: Identity of sender, purpose, right to withdraw consent
- **Unsubscribe**: Easy, one-click process, honored within reasonable time
- **Record-Keeping**: Consent records, email content, unsubscribe requests

---

## 📝 GDPR Compliance Checklist

Download and complete this checklist for your organization:

- [ ] Appoint Data Protection Officer (if required)
- [ ] Create/update Privacy Policy
- [ ] Implement consent mechanisms
- [ ] Enable data subject rights (access, deletion, portability)
- [ ] Conduct Data Protection Impact Assessments
- [ ] Implement breach notification procedures
- [ ] Train staff on GDPR
- [ ] Review and update Data Processing Agreements
- [ ] Implement technical security measures
- [ ] Document all processing activities

---

## 🎬 Additional Video Resources

### Recommended Viewing:
1. [GDPR for Developers](https://www.youtube.com/placeholder1) - 30 min
2. [Data Protection Impact Assessments](https://www.youtube.com/placeholder2) - 25 min
3. [Handling Data Subject Requests](https://www.youtube.com/placeholder3) - 20 min
4. [GDPR vs CCPA Comparison](https://www.youtube.com/placeholder4) - 35 min

---

## 📚 Further Reading

- Official GDPR Text: https://gdpr-info.eu/
- ICO Guidance: https://ico.org.uk/for-organisations/guide-to-data-protection/
- EDPB Guidelines: https://edpb.europa.eu/our-work-tools/general-guidance/gdpr-guidelines-recommendations-best-practices_en

---

## ✅ Quiz Preparation

Test your GDPR knowledge:

1. What are the 7 principles of GDPR?
2. What is the maximum fine for GDPR violations?
3. How long do you have to report a data breach?
4. What are the 6 legal bases for processing personal data?
5. What is the difference between a Data Controller and Data Processor?

---

## 🎯 Next Lesson

In the next video lesson, you''ll learn about **ISO 27001 Implementation**, including how to build an Information Security Management System (ISMS) from scratch.
'
WHERE section_id IN (SELECT id FROM sections WHERE name LIKE '%GDPR%' LIMIT 1) 
AND content_type = 'video' LIMIT 1;

-- ============================================================================
-- AI SECURITY - INTERACTIVE ADVERSARIAL ATTACK SCENARIO
-- ============================================================================

INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes)
VALUES (
    (SELECT id FROM sections WHERE name LIKE '%Adversarial%' LIMIT 1),
    'Interactive Lab: Adversarial Attack Simulation',
    '# 🤖 Interactive Lab: Fooling an Image Classification Model

## 🎯 Lab Objective

Learn how adversarial attacks work by creating adversarial examples that fool a machine learning model.

---

## 📹 Watch: Introduction to Adversarial Attacks

<div class="video-container">
  <iframe width="100%" height="500" src="https://www.youtube.com/embed/placeholder_adversarial" 
    title="Adversarial Machine Learning Attacks" 
    frameborder="0" 
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
    allowfullscreen>
  </iframe>
</div>

**Video Duration**: 35 minutes  
**Topics**: FGSM, PGD, C&W attacks, defenses

---

## 🧪 Interactive Simulation

### Scenario: Image Classification Attack

**Target Model**: ResNet-50 trained on ImageNet  
**Original Image**: Cat (99.8% confidence)  
**Your Goal**: Make the model classify it as "Dog" with >90% confidence

### Attack Methods Available:

#### 1. Fast Gradient Sign Method (FGSM)
```python
# Pseudocode for FGSM attack
def fgsm_attack(image, epsilon, gradient):
    # Add small perturbation in direction of gradient
    perturbed_image = image + epsilon * sign(gradient)
    return perturbed_image

# Try different epsilon values:
epsilon = 0.01  # Small perturbation
epsilon = 0.05  # Medium perturbation
epsilon = 0.10  # Large perturbation (may be visible)
```

**Your Turn**: Which epsilon value would you choose?
- [ ] 0.01 (Stealthy but may not work)
- [ ] 0.05 (Balanced)
- [ ] 0.10 (Effective but visible)

---

#### 2. Projected Gradient Descent (PGD)
```python
# Pseudocode for PGD attack
def pgd_attack(image, epsilon, alpha, num_iter):
    perturbed_image = image
    for i in range(num_iter):
        # Take a step in gradient direction
        perturbed_image = perturbed_image + alpha * sign(gradient)
        # Project back to epsilon ball
        perturbed_image = clip(perturbed_image, image - epsilon, image + epsilon)
    return perturbed_image

# Parameters to tune:
num_iterations = 10  # More iterations = stronger attack
alpha = 0.01  # Step size
```

---

## 🎮 Interactive Decision Points

### Decision 1: Attack Strategy

**Situation**: You need to fool a facial recognition system at an airport.

**Constraints**:
- Must be imperceptible to human observers
- Must work in real-time
- Must transfer to physical world (printed on paper)

**Which attack would you use?**

**Option A: Digital-only FGSM**
- Fast and effective
- Works great in digital domain
- May not transfer to physical world

**Option B: Physical-world optimized attack**
- Designed for printing and camera capture
- Slower to generate
- More robust to transformations

**Option C: Adversarial patch**
- Small sticker that can be placed on clothing
- Highly visible but effective
- Easy to deploy

**What would you choose?**

---

### Decision 2: Ethical Considerations

**Scenario**: You''ve discovered a vulnerability in a popular facial recognition system used by law enforcement.

**The vulnerability**: Adding specific eyeglass frames makes the system misidentify people 95% of the time.

**What do you do?**

**Option A: Responsible Disclosure**
- Contact the vendor privately
- Give them 90 days to fix
- Publish findings after fix

**Pros**: Ethical, helps improve security
**Cons**: Vendor may ignore or delay

**Option B: Public Disclosure**
- Publish immediately
- Warn the public
- Force vendor to act

**Pros**: Protects public, forces action
**Cons**: May be exploited by malicious actors

**Option C: Sell to Highest Bidder**
- Monetize the discovery
- No public benefit

**Pros**: Financial gain
**Cons**: Unethical, potentially illegal

**Option D: Do Nothing**
- Keep it secret
- Avoid controversy

**Pros**: No risk to you
**Cons**: Vulnerability remains, people at risk

**Your choice**: _______________

---

## 🔬 Hands-On Exercise

### Setup Your Environment

```bash
# Install required libraries
pip install torch torchvision foolbox

# Download pre-trained model
python download_model.py

# Load sample images
python load_images.py
```

### Exercise 1: Generate Adversarial Example

```python
import torch
import torchvision.models as models
from foolbox import PyTorchModel, accuracy, samples
from foolbox.attacks import FGSM

# Load model
model = models.resnet50(pretrained=True)
fmodel = PyTorchModel(model, bounds=(0, 1))

# Load image
images, labels = samples(fmodel, dataset=''imagenet'', batchsize=1)

# Create FGSM attack
attack = FGSM()

# Generate adversarial example
adversarial = attack(fmodel, images, labels, epsilons=0.03)

# Check if attack succeeded
predictions = fmodel(adversarial).argmax(axis=-1)
print(f"Original: {labels[0]}, Adversarial: {predictions[0]}")
```

### Exercise 2: Measure Attack Success

```python
# Test different epsilon values
epsilons = [0.0, 0.01, 0.03, 0.05, 0.1, 0.3]
success_rates = []

for eps in epsilons:
    adversarial = attack(fmodel, images, labels, epsilons=eps)
    success = (fmodel(adversarial).argmax(axis=-1) != labels).float().mean()
    success_rates.append(success.item())
    print(f"Epsilon: {eps}, Success Rate: {success.item():.2%}")
```

**Expected Output**:
```
Epsilon: 0.00, Success Rate: 0%
Epsilon: 0.01, Success Rate: 15%
Epsilon: 0.03, Success Rate: 45%
Epsilon: 0.05, Success Rate: 75%
Epsilon: 0.10, Success Rate: 95%
Epsilon: 0.30, Success Rate: 99%
```

---

## 📊 Real-World Impact

### Case Studies:

**1. Tesla Autopilot Attack (2019)**
- Researchers added stickers to stop signs
- Tesla''s vision system misclassified them
- Potential for accidents

**2. Face Recognition Bypass (2020)**
- Adversarial glasses fooled facial recognition
- 95% success rate
- Implications for security systems

**3. Medical Imaging Attack (2021)**
- Adversarial examples in CT scans
- Could cause misdiagnosis
- Critical safety implications

---

## 🛡️ Defense Mechanisms

### 1. Adversarial Training
```python
# Train model on adversarial examples
for epoch in range(num_epochs):
    for images, labels in dataloader:
        # Generate adversarial examples
        adv_images = generate_adversarial(images, labels)
        
        # Train on both clean and adversarial
        loss = criterion(model(images), labels) + \
               criterion(model(adv_images), labels)
        
        loss.backward()
        optimizer.step()
```

### 2. Input Preprocessing
- JPEG compression
- Bit depth reduction
- Random resizing
- Gaussian noise addition

### 3. Certified Defenses
- Randomized smoothing
- Provable robustness guarantees
- Mathematical bounds on adversarial perturbations

---

## 🎓 Learning Outcomes

After completing this lab, you should be able to:

- [ ] Explain how adversarial attacks work
- [ ] Generate adversarial examples using FGSM
- [ ] Measure attack success rates
- [ ] Understand the trade-off between perturbation size and success rate
- [ ] Recognize real-world implications of adversarial attacks
- [ ] Implement basic defense mechanisms

---

## 💡 Reflection Questions

1. Why are neural networks vulnerable to adversarial examples?
2. How can adversarial attacks be used for good (e.g., testing robustness)?
3. What are the ethical implications of publishing adversarial attack methods?
4. How would you design a robust ML system for a critical application?

---

## 🎬 Next Lab

In the next interactive lab, you''ll learn about **Model Poisoning Attacks**, where you''ll see how attackers can corrupt training data to backdoor ML models.

---

## 📚 Additional Resources

### Research Papers:
- "Explaining and Harnessing Adversarial Examples" (Goodfellow et al., 2015)
- "Towards Deep Learning Models Resistant to Adversarial Attacks" (Madry et al., 2018)
- "Certified Adversarial Robustness via Randomized Smoothing" (Cohen et al., 2019)

### Tools:
- Foolbox: https://foolbox.readthedocs.io/
- CleverHans: https://github.com/cleverhans-lab/cleverhans
- Adversarial Robustness Toolbox: https://github.com/Trusted-AI/adversarial-robustness-toolbox

### Competitions:
- NeurIPS Adversarial Robustness Challenge
- CVPR Robust Vision Challenge
',
    'interactive',
    2,
    60
);

COMMIT;

-- Made with Bob
