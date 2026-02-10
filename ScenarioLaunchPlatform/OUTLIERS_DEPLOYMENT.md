# Outliers Deployment Feature

## Overview

The Outliers Deployment feature allows you to store pre-packaged outlier script bundles on the system and deploy them with a single click, similar to how Content Packs work. This eliminates the need to manually upload ZIP files each time you want to deploy an outlier.

## Directory Structure

```
ScenarioLaunchPlatform/
├── outliers/                          # Deployment directory
│   ├── readme.md                      # Documentation
│   ├── outlier_data_tampering_mysql.zip
│   ├── outlier_account_takeover_mysql.zip
│   └── outlier_schema_tampering_mysql.zip
```

## How It Works

### 1. Store Outliers

Place your outlier ZIP files in the `outliers/` directory. Each ZIP should contain:
- Scripts (bash or Windows batch/PowerShell)
- A JSON configuration file (e.g., `outlier_data_tampering_mysql.json`)
- README.md (optional but recommended)
- Any supporting files (SQL scripts, etc.)

### 2. Deploy from UI

1. Navigate to the Outliers page
2. Click the "Deploy from Library" button
3. Select an outlier from the available list
4. Click "Deploy" to install it

The system will automatically:
- Extract the ZIP contents
- Parse the JSON configuration
- Add scripts to the library
- Configure schedules based on the JSON
- Save everything to the database
- Handle duplicates gracefully

## API Endpoints

### Get Available Outliers
```
GET /api/outliers/available
```

Returns a list of ZIP files in the `outliers/` directory with metadata:
```json
{
  "success": true,
  "count": 3,
  "outliers": [
    {
      "fileName": "outlier_data_tampering_mysql.zip",
      "displayName": "outlier data tampering mysql",
      "filePath": "/path/to/outliers/outlier_data_tampering_mysql.zip",
      "fileSize": 19423,
      "fileSizeMB": "0.02",
      "lastModified": "2026-02-10T12:00:00Z"
    }
  ]
}
```

### Deploy Outlier
```
POST /api/outliers/deploy
Content-Type: application/json

{
  "fileName": "outlier_data_tampering_mysql.zip",
  "deployedBy": "admin"
}
```

Response:
```json
{
  "success": true,
  "message": "Outlier deployed successfully",
  "fileName": "outlier_data_tampering_mysql.zip",
  "addedCount": 2,
  "skippedCount": 0,
  "totalProcessed": 2,
  "scripts": [...]
}
```

## Backend Implementation

### OutliersHandler.java

Two new methods added:

1. **`getAvailableOutliers(RoutingContext ctx)`**
   - Lists all ZIP files in the `outliers/` directory
   - Returns file metadata (name, size, last modified)
   - Handles missing directory gracefully

2. **`deployOutlier(RoutingContext ctx)`**
   - Accepts fileName in request body
   - Validates file exists
   - Calls `library.processZipUploadWithConfig()` to process the ZIP
   - Returns deployment results

### Routes Registration

```java
// Get available outliers from outliers directory
router.get("/api/outliers/available").handler(this::getAvailableOutliers);

// Deploy an outlier from the outliers directory
router.post("/api/outliers/deploy")
    .handler(io.vertx.ext.web.handler.BodyHandler.create())
    .handler(this::deployOutlier);
```

## Frontend Implementation

### UI Components

1. **Deploy Button**: Added next to the upload section
   - Green download icon
   - Opens deployment modal on click

2. **Deployment Modal**: Shows available outliers
   - Lists all ZIP files with metadata
   - Deploy button for each outlier
   - Responsive design

### JavaScript Functions

1. **`showDeployModal()`**: Opens the modal and loads available outliers
2. **`loadAvailableOutliers()`**: Fetches outliers from API
3. **`displayAvailableOutliers(outliers)`**: Renders the outlier list
4. **`deployOutlier(fileName)`**: Deploys selected outlier with confirmation

## Usage Example

### 1. Prepare Outlier Package

Create a ZIP file with this structure:
```
outlier_data_tampering_mysql/
├── outlier_data_tampering_mysql.json
├── README.md
├── generate_deletes.sh
├── run_timed_deletes_background.sh
└── execute_1000_deletes.sql
```

### 2. JSON Configuration

```json
{
  "outlierName": "Outlier Data Tampering MySQL",
  "description": "Simulates data tampering attacks",
  "version": "1.0.0",
  "author": "Security Team",
  "scripts": [
    {
      "scriptName": "generate_deletes.sh",
      "scriptType": "bash",
      "description": "Generates DELETE statements",
      "enabled": false,
      "schedules": [
        {
          "description": "Daily at 4 AM",
          "cronExpression": "0 4 * * *",
          "parameters": "param1 param2",
          "enabled": true
        }
      ]
    }
  ]
}
```

### 3. Deploy

1. Copy ZIP to `ScenarioLaunchPlatform/outliers/`
2. Open Outliers page in UI
3. Click "Deploy from Library"
4. Select your outlier
5. Click "Deploy"

## Benefits

- **One-Click Deployment**: No need to manually upload files
- **Version Control**: Store outliers in version control
- **Consistency**: Same outliers across environments
- **Efficiency**: Deploy multiple times without re-uploading
- **Organization**: Centralized storage for all outliers

## Duplicate Handling

The deployment feature uses the same duplicate detection as manual uploads:
- Scripts with the same name are skipped
- Deployment report shows added vs. skipped counts
- Existing scripts are not overwritten

## Error Handling

- Missing `outliers/` directory: Returns 404 error
- File not found: Returns 404 with specific message
- Invalid ZIP: Returns 500 with error details
- Deployment failures: Shows error in UI with details

## Future Enhancements

Potential improvements:
- Outlier versioning and updates
- Bulk deployment of multiple outliers
- Outlier categories/tags
- Deployment history tracking
- Rollback functionality
- Outlier marketplace/repository

## Related Documentation

- [OUTLIERS_JSON_CONFIG.md](OUTLIERS_JSON_CONFIG.md) - JSON configuration format
- [OUTLIERS_MULTIPLE_SCHEDULES.md](OUTLIERS_MULTIPLE_SCHEDULES.md) - Multiple schedules feature
- [DATABASE_PERSISTENCE_GUIDE.md](DATABASE_PERSISTENCE_GUIDE.md) - Database schema