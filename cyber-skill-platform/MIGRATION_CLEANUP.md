# Database Migration Cleanup Plan

## Current Situation

The database migration directory contains multiple problematic files that need to be cleaned up:

### Existing Migrations
1. ✅ **V1__Initial_Schema.sql** - KEEP (creates all tables including JSONB columns)
2. ✅ **V2__Sample_Learning_Content.sql** - KEEP (updated with JSONB content for 4 learning paths)
3. ⚠️ **V3__Additional_Learning_Paths.sql** - NEEDS CONVERSION (3 learning paths without JSONB)
4. ❌ **V4__Add_JSONB_Content.sql** - DELETE (duplicate, already in V1)
5. ❌ **V4__Enhanced_Lesson_Content.sql** - DELETE (problematic SQL escaping)
6. ❌ **V4__Load_Enhanced_Content.sql** - DELETE (problematic SQL escaping)
7. ❌ **V5__Interactive_Content_And_Videos.sql** - DELETE (problematic SQL escaping)
8. ❌ **V5__Load_JSONB_Content.sql** - DELETE (sample content, now in V2)
9. ❌ **V6__More_Enhanced_Lessons.sql** - DELETE (problematic SQL escaping)
10. ❌ **V7__Final_Enhanced_Content.sql** - DELETE (problematic SQL escaping)

## Action Plan

### Step 1: Delete Problematic Migrations
Remove all V4, V5, V6, V7 files as they contain:
- Duplicate JSONB column additions (already in V1)
- SQL escaping issues with large text content
- Redundant sample content

### Step 2: Convert V3 to JSONB Format
Rewrite V3__Additional_Learning_Paths.sql to include JSONB content for:
- **Threat Intelligence & Hunting** (40 hours, 5 modules)
- **Security Architecture & Zero Trust** (38 hours, 5 modules)
- **AI Security & Adversarial ML** (35 hours, 5 modules)

### Step 3: Final Migration Structure
After cleanup, we'll have:
```
V1__Initial_Schema.sql          (Schema with JSONB columns)
V2__Sample_Learning_Content.sql (4 paths with JSONB content)
V3__Additional_Learning_Paths.sql (3 paths with JSONB content)
```

## Benefits of This Approach

1. **Clean Migration History**: Only 3 migrations, easy to understand
2. **No SQL Escaping Issues**: All content stored as JSONB
3. **Consistent Structure**: All lessons use the same JSONB format
4. **Easy to Extend**: Add more content by creating V4, V5, etc.
5. **Database Reset Works**: Can drop and recreate cleanly

## JSONB Content Structure

All lessons will follow this structure:

```json
{
  "title": "Lesson Title",
  "sections": [
    {
      "heading": "Section Title",
      "content": "Text content",
      "subsections": [...],
      "list": [...],
      "codeBlock": {...},
      "table": {...},
      "lab": {...}
    }
  ],
  "videoUrl": "https://...",
  "resources": [...]
}
```

## Metadata Structure

```json
{
  "difficulty": "beginner|intermediate|advanced",
  "estimatedMinutes": 25,
  "prerequisites": ["Lesson 1", "Lesson 2"],
  "learningObjectives": ["Objective 1", "Objective 2"],
  "tags": ["tag1", "tag2"],
  "author": "CyberSkill Team",
  "lastUpdated": "2026-03-12",
  "version": "1.0",
  "hasVideo": true,
  "hasLab": true
}
```

## Next Steps

1. ✅ V1 already has JSONB columns (content_json, metadata, content_source)
2. ✅ V2 updated with JSONB content for 4 learning paths
3. ⏳ Delete problematic V4-V7 migrations
4. ⏳ Rewrite V3 with JSONB content for 3 additional paths
5. ⏳ Test database reset and verify all migrations apply successfully
6. ⏳ Update frontend to render JSONB content

## Testing Procedure

```bash
# 1. Stop application
# 2. Drop database
docker-compose down -v
docker-compose up -d

# 3. Rebuild and start
cd cyber-skill-platform
mvn clean package
java -jar target/cyberskill-platform-1.0.0-fat.jar

# 4. Verify migrations
# Should see: "Applied 3 database migration(s)"

# 5. Query database
psql -U postgres -d cyberskill
SELECT name, content_source, metadata->>'difficulty' 
FROM lessons 
WHERE content_json IS NOT NULL;
```

## Expected Results

After cleanup and conversion:
- **7 Learning Paths** (243 hours total)
- **35 Modules**
- **100+ Sections**
- **300+ Lessons** (all with JSONB content)
- **Clean migration history**
- **No SQL escaping issues**
- **Consistent data structure**

---

**Status**: Ready to execute cleanup
**Created**: 2026-03-12
**Author**: Bob