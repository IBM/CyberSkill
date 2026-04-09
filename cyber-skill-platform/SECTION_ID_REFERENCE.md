# Section ID Reference Guide

This document provides a complete reference of section IDs for all learning paths in the CyberSkill platform. Use these section IDs when creating new lessons with the templates in `LESSON_CONTENT_TEMPLATE.sql`.

## 📋 Quick Reference Table

| Learning Path | Path ID | Section ID Range | Total Sections |
|--------------|---------|------------------|----------------|
| Penetration Testing | 1 | 1-3 | 3 |
| Compliance | 2 | 4-6 | 3 |
| Data Security | 3 | 7-9 | 3 |
| Post-Quantum Computing | 4 | 10-12 | 3 |
| Threat Intelligence & Hunting | 5 | 13-21 | 9 |
| Security Architecture & Zero Trust | 6 | 22-30 | 9 |
| AI Security & Adversarial ML | 7 | 31-42 | 12 |

---

## 🛡️ Learning Path 1: Penetration Testing

**Path ID:** 1  
**Estimated Hours:** 40  
**Section ID Range:** 1-3

### Module 1: Introduction to Penetration Testing (Module ID: 1)
- **Section 1** - What is Penetration Testing?
- **Section 2** - Penetration Testing Methodologies
- **Section 3** - Legal and Ethical Considerations

### Module 2: Reconnaissance and Information Gathering (Module ID: 2)
- *No sections defined yet - use section IDs starting from next available*

### Module 3: Vulnerability Assessment (Module ID: 3)
- *No sections defined yet*

### Module 4: Exploitation Techniques (Module ID: 4)
- *No sections defined yet*

### Module 5: Post-Exploitation and Reporting (Module ID: 5)
- *No sections defined yet*

---

## 📋 Learning Path 2: Compliance

**Path ID:** 2  
**Estimated Hours:** 35  
**Section ID Range:** 4-6

### Module 6: Introduction to Compliance (Module ID: 6)
- **Section 4** - Why Compliance Matters
- **Section 5** - Compliance Frameworks Overview
- **Section 6** - Building a Compliance Program

### Module 7: GDPR and Data Protection (Module ID: 7)
- *No sections defined yet*

### Module 8: ISO 27001 Information Security (Module ID: 8)
- *No sections defined yet*

### Module 9: SOC 2 and Trust Services (Module ID: 9)
- *No sections defined yet*

### Module 10: Industry-Specific Compliance (Module ID: 10)
- *No sections defined yet*

---

## 🔒 Learning Path 3: Data Security

**Path ID:** 3  
**Estimated Hours:** 30  
**Section ID Range:** 7-9

### Module 11: Data Security Fundamentals (Module ID: 11)
- **Section 7** - Understanding Data Classification
- **Section 8** - Data Lifecycle Management
- **Section 9** - Regulatory Requirements

### Module 12: Encryption and Cryptography (Module ID: 12)
- *No sections defined yet*

### Module 13: Access Control and Authentication (Module ID: 13)
- *No sections defined yet*

### Module 14: Data Loss Prevention (Module ID: 14)
- *No sections defined yet*

### Module 15: Secure Data Storage and Transmission (Module ID: 15)
- *No sections defined yet*

---

## ⚛️ Learning Path 4: Post-Quantum Computing

**Path ID:** 4  
**Estimated Hours:** 25  
**Section ID Range:** 10-12

### Module 16: Introduction to Quantum Computing (Module ID: 16)
- **Section 10** - Quantum Computing Basics
- **Section 11** - Quantum vs Classical Computing
- **Section 12** - Quantum Computing Timeline

### Module 17: Quantum Threats to Cryptography (Module ID: 17)
- *No sections defined yet*

### Module 18: Post-Quantum Cryptography (Module ID: 18)
- *No sections defined yet*

### Module 19: Migration Strategies (Module ID: 19)
- *No sections defined yet*

### Module 20: Future of Quantum Security (Module ID: 20)
- *No sections defined yet*

---

## 🎯 Learning Path 5: Threat Intelligence & Hunting

**Path ID:** 5  
**Estimated Hours:** 40  
**Section ID Range:** 13-21

### Module 21: Threat Intelligence Fundamentals (Module ID: 21)
- **Section 13** - Introduction to Threat Intelligence
- **Section 14** - The Intelligence Lifecycle
- **Section 15** - Types of Threat Intelligence

### Module 22: Threat Actor Analysis (Module ID: 22)
- **Section 16** - Understanding Threat Actors
- **Section 17** - APT Groups and Nation-State Actors
- **Section 18** - MITRE ATT&CK Framework

### Module 23: Threat Intelligence Platforms & Tools (Module ID: 23)
- *No sections defined yet*

### Module 24: Threat Hunting Methodologies (Module ID: 24)
- **Section 19** - Threat Hunting Fundamentals
- **Section 20** - Hypothesis-Driven Hunting
- **Section 21** - Hunting Tools and Techniques

### Module 25: Intelligence-Driven Defense (Module ID: 25)
- *No sections defined yet*

---

## 🏗️ Learning Path 6: Security Architecture & Zero Trust

**Path ID:** 6  
**Estimated Hours:** 38  
**Section ID Range:** 22-30

### Module 26: Security Architecture Fundamentals (Module ID: 26)
- **Section 22** - Principles of Secure Design
- **Section 23** - Threat Modeling
- **Section 24** - Security Architecture Patterns

### Module 27: Zero Trust Architecture (Module ID: 27)
- **Section 25** - Zero Trust Principles
- **Section 26** - Implementing Zero Trust
- **Section 27** - Zero Trust Network Access

### Module 28: Network Security Architecture (Module ID: 28)
- *No sections defined yet*

### Module 29: Identity-Centric Security (Module ID: 29)
- **Section 28** - Identity as the New Perimeter
- **Section 29** - Privileged Access Management
- **Section 30** - Identity Governance

### Module 30: Security Architecture Frameworks (Module ID: 30)
- *No sections defined yet*

---

## 🤖 Learning Path 7: AI Security & Adversarial ML

**Path ID:** 7  
**Estimated Hours:** 35  
**Section ID Range:** 31-42

### Module 31: AI and ML Security Fundamentals (Module ID: 31)
- **Section 31** - Introduction to AI Security
- **Section 32** - AI Threat Landscape
- **Section 33** - ML Pipeline Security

### Module 32: Adversarial Machine Learning (Module ID: 32)
- **Section 34** - Types of Adversarial Attacks
- **Section 35** - Generating Adversarial Examples
- **Section 36** - Defenses Against Adversarial Attacks

### Module 33: Model Security and Privacy (Module ID: 33)
- **Section 37** - Model Intellectual Property Protection
- **Section 38** - Privacy-Preserving Machine Learning
- **Section 39** - Membership Inference Attacks

### Module 34: AI Governance and Ethics (Module ID: 34)
- **Section 40** - Responsible AI Development
- **Section 41** - Bias and Fairness in ML
- **Section 42** - AI Regulations and Compliance

### Module 35: Securing AI Systems (Module ID: 35)
- *No sections defined yet*

---

## 📝 How to Use This Reference

### When Creating New Lessons:

1. **Identify the learning path** you want to add content to
2. **Find the section ID** from the tables above
3. **Use the appropriate template** from `LESSON_CONTENT_TEMPLATE.sql`
4. **Replace the section_id** in the INSERT statement

### Example:

To add a lesson to **Penetration Testing → Module 1 → Section 2** (Penetration Testing Methodologies):

```sql
INSERT INTO lessons (section_id, name, content, content_type, order_index, estimated_minutes, content_json, metadata, content_source)
VALUES (
    2,  -- Section ID for "Penetration Testing Methodologies"
    'PTES Methodology Deep Dive',
    'Detailed exploration of the Penetration Testing Execution Standard.',
    'text',
    1,
    30,
    '{...}'::jsonb,
    '{...}'::jsonb,
    'json'
);
```

### For Sections Not Yet Defined:

If you need to add lessons to modules that don't have sections yet:

1. **First create the sections** in the appropriate migration file
2. **Note the section IDs** (they will be auto-incremented from the last section ID)
3. **Then create lessons** using those new section IDs

### Next Available Section IDs:

- **Next available section ID:** 43
- Use this for creating new sections in any module

---

## 🔍 Finding Section Details

To find more details about a specific section, refer to:
- **V2__Sample_Learning_Content.sql** - Sections 1-12
- **V3__Additional_Learning_Paths.sql** - Sections 13-42

---

## 📊 Content Gap Analysis

Based on the **CONTENT_EXPANSION_PLAN.md**, here's where content is most needed:

### High Priority (No sections defined):
- Penetration Testing: Modules 2-5 (need ~15 sections)
- Compliance: Modules 7-10 (need ~12 sections)
- Data Security: Modules 12-15 (need ~12 sections)
- Post-Quantum Computing: Modules 17-20 (need ~12 sections)
- Threat Intelligence: Modules 23, 25 (need ~6 sections)
- Security Architecture: Modules 28, 30 (need ~6 sections)
- AI Security: Module 35 (need ~3 sections)

### Medium Priority (Sections exist, need more lessons):
- All existing sections need 2-4 additional lessons each to reach target hours

---

## 💡 Tips for Content Creation

1. **Use consistent section_id values** - Don't skip numbers
2. **Follow the order_index** - Lessons should be numbered sequentially within each section
3. **Match estimated_minutes** - Ensure lesson duration aligns with module/section estimates
4. **Use appropriate difficulty levels** - beginner → intermediate → advanced
5. **Include variety** - Mix text, video, and lab lessons
6. **Add prerequisites** - Reference earlier lessons in metadata
7. **Tag appropriately** - Use relevant tags for searchability

---

## 🚀 Quick Start Commands

### To add a new section:
```sql
INSERT INTO sections (module_id, name, description, order_index)
VALUES (
    <module_id>,
    'Section Name',
    'Section description',
    <order_index>
);
```

### To find the last section ID:
```sql
SELECT MAX(id) FROM sections;
```

### To count lessons per section:
```sql
SELECT section_id, COUNT(*) as lesson_count
FROM lessons
GROUP BY section_id
ORDER BY section_id;
```

---

**Last Updated:** 2026-03-12  
**Version:** 1.0  
**Maintained by:** CyberSkill Platform Team