# Quiz JSONB Implementation Guide

## Overview

The CyberSkill platform now supports **JSONB-based quizzes and labs**, making content creation much simpler while maintaining backward compatibility with the existing relational structure.

---

## 🎯 What Changed

### 1. Database Schema (V4 Migration)

**File:** `src/main/resources/db/migration/V4__Add_Quiz_JSONB_Support.sql`

#### Quizzes Table - New Columns:
```sql
ALTER TABLE quizzes ADD COLUMN quiz_json JSONB;
ALTER TABLE quizzes ADD COLUMN metadata JSONB;
ALTER TABLE quizzes ADD COLUMN content_source VARCHAR(50) DEFAULT 'relational';
```

#### New Labs Table:
```sql
CREATE TABLE labs (
    id SERIAL PRIMARY KEY,
    section_id INTEGER NOT NULL REFERENCES sections(id),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    estimated_minutes INTEGER,
    content_source VARCHAR(50) DEFAULT 'json',
    lab_json JSONB,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2. Java Models Updated

#### Quiz.java
Added fields:
- `String contentSource` - Tracks format: 'relational' or 'json'
- `JsonObject quizJson` - Complete quiz structure in JSON
- `JsonObject metadata` - Quiz configuration

#### Lab.java (New)
Complete model for hands-on lab exercises with JSONB support.

### 3. Repository Updates

#### QuizRepository.java
- Updated `mapRowToQuiz()` to handle JSONB fields
- Backward compatible - works with both old and new formats

---

## 📝 How to Create Quizzes

### Option 1: JSONB Format (Recommended)

```sql
INSERT INTO quizzes (section_id, name, description, passing_score, time_limit_minutes, max_attempts, content_source, quiz_json, metadata)
VALUES (
    43,  -- Your section ID
    'Threat Intelligence Platforms Quiz',
    'Test your knowledge of TIPs and IOCs.',
    70, 20, 3, 'json',
    '{
        "title": "Threat Intelligence Platforms Quiz",
        "questions": [
            {
                "question": "What is the primary purpose of a TIP?",
                "type": "multiple_choice",
                "options": [
                    "To store firewall rules",
                    "To aggregate, enrich, and distribute threat intelligence",
                    "To replace SIEM systems",
                    "To perform malware analysis"
                ],
                "correctAnswer": 1,
                "explanation": "TIPs centralize threat data, enrich it, and distribute it to security tools.",
                "points": 1
            },
            {
                "question": "TIPs integrate with SIEM and SOAR tools.",
                "type": "true_false",
                "options": ["True", "False"],
                "correctAnswer": 0,
                "explanation": "TIPs integrate with SIEM, SOAR, EDR, and other security tools.",
                "points": 1
            },
            {
                "question": "Which are open-source TIPs? (Select all)",
                "type": "multi_select",
                "options": ["MISP", "OpenCTI", "ThreatConnect", "Anomali"],
                "correctAnswers": [0, 1],
                "explanation": "MISP and OpenCTI are open-source platforms.",
                "points": 2
            }
        ]
    }'::jsonb,
    '{
        "totalPoints": 4,
        "difficulty": "intermediate",
        "estimatedMinutes": 20,
        "tags": ["threat-intelligence", "TIP", "MISP"],
        "version": "1.0",
        "createdBy": "CyberSkill Team",
        "lastUpdated": "2026-03-12"
    }'::jsonb
);
```

### Option 2: Relational Format (Legacy)

Still supported - uses `quiz_questions` and `quiz_options` tables.

---

## 🧪 How to Create Labs

```sql
INSERT INTO labs (section_id, name, description, estimated_minutes, content_source, lab_json, metadata)
VALUES (
    43,
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
```

---

## 🎨 Question Types

### 1. Multiple Choice (Single Answer)
```json
{
    "question": "Question text?",
    "type": "multiple_choice",
    "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
    "correctAnswer": 1,  // Index of correct option (0-based)
    "explanation": "Why this is correct",
    "points": 1
}
```

### 2. True/False
```json
{
    "question": "Statement to evaluate.",
    "type": "true_false",
    "options": ["True", "False"],
    "correctAnswer": 0,  // 0=True, 1=False
    "explanation": "Explanation",
    "points": 1
}
```

### 3. Multi-Select (Multiple Answers)
```json
{
    "question": "Select all that apply.",
    "type": "multi_select",
    "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
    "correctAnswers": [0, 2, 3],  // Array of correct indices
    "explanation": "Explanation",
    "points": 2
}
```

---

## 📊 Metadata Structure

```json
{
    "totalPoints": 10,
    "difficulty": "beginner" | "intermediate" | "advanced",
    "estimatedMinutes": 20,
    "tags": ["tag1", "tag2", "tag3"],
    "version": "1.0",
    "createdBy": "Author Name",
    "lastUpdated": "2026-03-12"
}
```

---

## 🔧 Backend Implementation

### Querying Quizzes

The `QuizRepository.mapRowToQuiz()` method automatically handles both formats:

```java
// Check content_source to determine format
if ("json".equals(quiz.getContentSource())) {
    // Parse quiz_json JSONB
    JsonObject quizData = quiz.getQuizJson();
    JsonArray questions = quizData.getJsonArray("questions");
    // Process questions...
} else {
    // Query quiz_questions and quiz_options tables
    // Legacy relational format...
}
```

### API Endpoints

Existing endpoints work with both formats:
- `GET /api/quizzes/:id` - Returns quiz (auto-detects format)
- `GET /api/sections/:id/quizzes` - Lists quizzes for section
- `POST /api/quiz-attempts` - Submit quiz attempt

---

## ✨ Benefits

### JSONB Format:
✅ **Much simpler** - Single INSERT vs 3+ tables  
✅ **No SQL escaping issues** - JSONB handles it  
✅ **Easier to maintain** - All quiz data in one place  
✅ **Backward compatible** - Old quizzes still work  
✅ **Fast queries** - GIN indexes on JSONB  
✅ **Flexible** - Easy to add new question types  

### Relational Format:
✅ **Normalized data** - Better for complex queries  
✅ **Referential integrity** - Foreign key constraints  
✅ **Granular updates** - Update individual questions  

---

## 📁 File Reference

### Database Migrations:
- `V1__Initial_Schema.sql` - Original schema with relational quizzes
- `V4__Add_Quiz_JSONB_Support.sql` - Adds JSONB columns and labs table

### Java Models:
- `src/main/java/com/cyberskill/model/Quiz.java` - Updated with JSONB fields
- `src/main/java/com/cyberskill/model/Lab.java` - New lab model

### Repositories:
- `src/main/java/com/cyberskill/repository/QuizRepository.java` - Updated mapper

### Content Files:
- `src/main/resources/db/NewFiles.sql` - Example quizzes and labs using JSONB format
- `SECTION_ID_REFERENCE.md` - Section ID mapping for all learning paths

---

## 🚀 Next Steps

1. **Run V4 Migration**
   ```bash
   # Migration runs automatically on application start
   mvn clean package
   docker-compose up
   ```

2. **Create Content**
   - Use `NewFiles.sql` as template
   - Reference `SECTION_ID_REFERENCE.md` for section IDs
   - Follow JSONB format examples above

3. **Test Quizzes**
   - Access quiz via API or frontend
   - Submit quiz attempts
   - Verify scoring works correctly

4. **Add Labs**
   - Create lab exercises for hands-on practice
   - Link labs to appropriate sections
   - Test lab workflow

---

## 🐛 Troubleshooting

### Issue: "Column quiz_json does not exist"
**Solution:** Run V4 migration. Check Flyway migration status.

### Issue: "Cannot parse JSONB"
**Solution:** Ensure JSON is valid. Use `::jsonb` cast in SQL.

### Issue: "Package errors in VS Code"
**Solution:** These are VS Code configuration issues, not actual compilation errors. The code will compile fine with Maven.

---

## 📚 Examples

See these files for complete examples:
- `V4__Add_Quiz_JSONB_Support.sql` - 3 sample quizzes
- `NewFiles.sql` - 9 quizzes + 9 labs with full content

---

**Created:** 2026-03-12  
**Version:** 1.0  
**Author:** CyberSkill Platform Team