# Content Management Guide - JSON Approach

## Overview

The CyberSkill platform uses a **JSON-based content management system** to avoid SQL escaping issues and provide a flexible, maintainable way to manage lesson content.

## Architecture

```
lesson-content/              # JSON content files
    ├── penetration-testing-tools.json
    ├── reconnaissance-osint.json
    └── ... more lessons

ContentLoaderService.java    # Loads JSON into database
MainVerticle.java            # Calls loader after migrations
```

## How It Works

1. **Migrations run** (V1, V2, V3, V4) - Create schema and basic structure
2. **ContentLoaderService loads** - Reads JSON files and updates lesson content
3. **No SQL escaping issues** - Content stored as plain text via parameterized queries

---

## Adding New Lesson Content

### Step 1: Create JSON File

Create a new file in `src/main/resources/lesson-content/`:

```json
{
  "lessonId": 3,
  "sectionId": 3,
  "name": "Penetration Testing Tools Overview",
  "contentType": "video",
  "content": "# Your Markdown Content Here\n\n## Section 1\n\nYour content...",
  "videoUrl": "https://www.youtube.com/embed/your-video-id",
  "estimatedMinutes": 45,
  "metadata": {
    "difficulty": "intermediate",
    "prerequisites": ["Basic Linux", "Networking"],
    "learningObjectives": [
      "Objective 1",
      "Objective 2"
    ],
    "tags": ["tag1", "tag2"]
  }
}
```

### Step 2: Restart Application

The content will be automatically loaded on startup:

```bash
# Rebuild
mvn clean package

# Restart
java -jar target/cyberskill-platform-1.0.0-fat.jar
```

### Step 3: Verify

Check logs for:
```
✓ Enhanced content loaded successfully
Successfully loaded content from: your-file.json
```

---

## JSON Schema

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `lessonId` | Integer | Lesson ID (optional, for reference) |
| `sectionId` | Integer | Section ID to match lesson |
| `name` | String | Exact lesson name from database |
| `content` | String | Markdown content (use `\n` for newlines) |
| `contentType` | String | `text`, `video`, `interactive`, `pdf` |
| `estimatedMinutes` | Integer | Estimated completion time |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `videoUrl` | String | YouTube embed URL |
| `metadata` | Object | Additional metadata |

---

## Content Guidelines

### Markdown Formatting

```json
{
  "content": "# Main Title\n\n## Subtitle\n\n### Section\n\n**Bold text**\n\n*Italic text*\n\n```bash\ncode block\n```\n\n- List item 1\n- List item 2"
}
```

### Code Blocks

Use `\n` for newlines and escape backslashes:

```json
{
  "content": "```bash\n# Command\nsudo apt update\n```"
}
```

### Special Characters

- **Quotes**: Use `\"` for quotes inside strings
- **Backslashes**: Use `\\` for literal backslashes
- **Newlines**: Use `\n` for line breaks

---

## Advantages of JSON Approach

### ✅ Benefits

1. **No SQL Escaping Issues**
   - Content stored via parameterized queries
   - No need to escape quotes, backslashes, etc.

2. **Easy to Edit**
   - Standard JSON format
   - Can use any text editor
   - Version control friendly

3. **Flexible Metadata**
   - Add custom fields as needed
   - Structured data for filtering/search

4. **Hot Reload Capable**
   - Can implement API endpoint to reload content
   - No database migrations needed

5. **Portable**
   - Export/import content easily
   - Share between environments

### ❌ Old SQL Approach Problems

- SQL escaping nightmares
- Hard to update content
- Database corruption risks
- Complex migrations
- Not version control friendly

---

## API Endpoints (Future Enhancement)

### Reload Content

```http
POST /api/admin/content/reload
Authorization: Bearer <admin-token>
```

### Load Specific Lesson

```http
POST /api/admin/content/load/:lessonId
Authorization: Bearer <admin-token>
```

### Export Content

```http
GET /api/admin/content/export
Authorization: Bearer <admin-token>
```

---

## Troubleshooting

### Content Not Loading

**Check logs for errors:**
```
Failed to load content from: filename.json
```

**Common issues:**
1. Invalid JSON syntax
2. Wrong section_id or lesson name
3. File not in `lesson-content/` directory
4. Missing required fields

### Lesson Not Updating

**Verify:**
1. Section ID matches database
2. Lesson name matches exactly (case-sensitive)
3. Application restarted after adding JSON
4. No errors in logs

### Special Characters Not Displaying

**Solution:**
- Use proper JSON escaping
- Test JSON validity: https://jsonlint.com/
- Use `\n` for newlines, not actual line breaks in JSON strings

---

## Migration from Old Approach

If you have content in old V4-V7 SQL migrations:

### Step 1: Delete Old Migrations

```bash
rm src/main/resources/db/migration/V4__Enhanced_Lesson_Content.sql
rm src/main/resources/db/migration/V5__Interactive_Content_And_Videos.sql
rm src/main/resources/db/migration/V6__More_Enhanced_Lessons.sql
rm src/main/resources/db/migration/V7__Final_Enhanced_Content.sql
```

### Step 2: Create New V4

```sql
-- V4__Load_Enhanced_Content.sql
ALTER TABLE lessons ADD COLUMN IF NOT EXISTS content_loaded_from_json BOOLEAN DEFAULT FALSE;
COMMIT;
```

### Step 3: Convert Content to JSON

Extract content from old SQL files and create JSON files.

### Step 4: Reset Database

```bash
docker-compose down -v
docker-compose up -d
```

---

## Best Practices

### 1. File Naming

Use descriptive names:
```
penetration-testing-tools.json
reconnaissance-osint.json
gdpr-compliance-fundamentals.json
```

### 2. Content Organization

Group related lessons:
```
lesson-content/
  ├── penetration-testing/
  │   ├── tools-overview.json
  │   ├── reconnaissance.json
  │   └── exploitation.json
  ├── compliance/
  │   ├── gdpr.json
  │   └── iso27001.json
  └── ...
```

### 3. Version Control

- Commit JSON files to git
- Use meaningful commit messages
- Review changes in pull requests

### 4. Testing

- Validate JSON syntax before committing
- Test content rendering in browser
- Check for broken links/images

---

## Example: Complete Lesson JSON

```json
{
  "lessonId": 3,
  "sectionId": 3,
  "name": "Penetration Testing Tools Overview",
  "contentType": "video",
  "content": "# Penetration Testing Tools\n\n## Introduction\n\nThis lesson covers essential penetration testing tools.\n\n## Tools Covered\n\n1. **Kali Linux**\n   - Pre-configured environment\n   - 600+ security tools\n\n2. **Metasploit**\n   - Exploitation framework\n   - 2000+ exploits\n\n## Hands-On Lab\n\n```bash\n# Install Kali Linux\nsudo apt update\nsudo apt install kali-linux-default\n```\n\n## Resources\n\n- [Kali Docs](https://www.kali.org/docs/)\n- [Metasploit Guide](https://docs.metasploit.com/)\n\n## Quiz\n\nTest your knowledge in the section quiz!",
  "videoUrl": "https://www.youtube.com/embed/dQw4w9WgXcQ",
  "estimatedMinutes": 45,
  "metadata": {
    "difficulty": "intermediate",
    "prerequisites": [
      "Basic Linux knowledge",
      "Networking fundamentals"
    ],
    "learningObjectives": [
      "Install and configure Kali Linux",
      "Use Metasploit for exploitation",
      "Perform network scanning with Nmap"
    ],
    "tags": [
      "kali-linux",
      "metasploit",
      "penetration-testing",
      "tools"
    ],
    "author": "Security Expert",
    "lastUpdated": "2026-03-12"
  }
}
```

---

## Summary

The JSON approach provides a **clean, maintainable, and scalable** way to manage lesson content without the headaches of SQL escaping. Simply create JSON files, restart the application, and your content is loaded automatically!

**Key Points:**
- ✅ No SQL escaping issues
- ✅ Easy to edit and version control
- ✅ Flexible metadata support
- ✅ Hot reload capable
- ✅ Portable and shareable

For questions or issues, check the logs or refer to `ContentLoaderService.java` for implementation details.