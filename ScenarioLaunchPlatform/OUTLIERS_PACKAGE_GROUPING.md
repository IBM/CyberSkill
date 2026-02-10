# Outliers Package Grouping Feature

## Overview

The Package Grouping feature allows you to manage multiple scripts from the same ZIP upload as a cohesive unit. This enables bulk operations like enabling/disabling all scripts in a package at once.

## Features

### 1. Hierarchical View
- **Package View**: Shows all uploaded packages with summary information
- **Script View**: Traditional view showing individual scripts
- Toggle between views using the buttons at the top of the page

### 2. Package Information
Each package displays:
- Package name (from ZIP filename or outlier-config.json)
- Total number of scripts in the package
- Number of enabled scripts
- Enable/Disable All button
- View Scripts button to drill down

### 3. Bulk Operations
- **Enable All**: Enables all scripts in the package and adds them to the system scheduler
- **Disable All**: Disables all scripts in the package and removes them from the system scheduler
- Confirmation dialog before bulk operations

## Architecture

### Backend Components

#### OutlierScript.java
Added fields:
```java
private String packageId;      // UUID identifying the package
private String packageName;    // Human-readable package name
```

#### OutliersLibrary.java
New methods:
```java
// Get all scripts belonging to a package
public List<OutlierScript> getScriptsByPackage(String packageId)

// Get all packages with their scripts
public Map<String, List<OutlierScript>> getAllPackages()

// Toggle all scripts in a package
public boolean togglePackage(String packageId, boolean enabled)
```

#### OutliersHandler.java
New API endpoints:
```
GET  /api/outliers/packages                    - Get all packages
POST /api/outliers/packages/:packageId/toggle  - Toggle package
```

### Frontend Components

#### View Toggle
```html
<button onclick="switchView('package')">Package View</button>
<button onclick="switchView('script')">Script View</button>
```

#### JavaScript Functions
- `loadPackages()` - Fetch and display packages
- `displayPackages(packages)` - Render package cards
- `togglePackage(packageId, event)` - Enable/disable all scripts in package
- `viewPackageScripts(packageId)` - Drill down to view individual scripts
- `switchView(view)` - Toggle between package and script views

## API Response Format

### GET /api/outliers/packages
```json
{
  "success": true,
  "packages": [
    {
      "packageId": "uuid-here",
      "packageName": "Backup Scripts",
      "scriptCount": 5,
      "enabledCount": 3,
      "allEnabled": false,
      "scripts": [...]
    }
  ],
  "totalPackages": 1
}
```

### POST /api/outliers/packages/:packageId/toggle
```json
{
  "success": true,
  "message": "Package enabled",
  "packageId": "uuid-here",
  "packageName": "Backup Scripts",
  "enabled": true,
  "scriptCount": 5
}
```

## Usage

### Uploading a Package
1. Upload a ZIP file containing multiple scripts
2. All scripts from the same ZIP are automatically grouped into a package
3. Package ID is generated automatically
4. Package name comes from:
   - `outlierName` field in outlier-config.json (if present)
   - ZIP filename (if no config)

### Managing Packages
1. Navigate to Outliers page
2. Click "Package View" button (default view)
3. See all packages with summary information
4. Click "Enable All" or "Disable All" to toggle entire package
5. Click "View Scripts" to see individual scripts in the package
6. Click "Back to Packages" to return to package view

### Switching Views
- **Package View**: Best for managing groups of related scripts
- **Script View**: Best for managing individual scripts
- Views are independent - changes in one reflect in the other

## Database Schema

The `packageId` and `packageName` fields are stored in the `tb_outlier_scripts` table:

```sql
ALTER TABLE tb_outlier_scripts 
ADD COLUMN package_id VARCHAR(255),
ADD COLUMN package_name VARCHAR(255);

CREATE INDEX idx_package_id ON tb_outlier_scripts(package_id);
```

## Benefits

1. **Simplified Management**: Enable/disable multiple related scripts at once
2. **Better Organization**: Group scripts by purpose or source
3. **Bulk Operations**: Perform actions on entire packages
4. **Clear Hierarchy**: Understand which scripts belong together
5. **Efficient Workflow**: Quickly manage large numbers of scripts

## Example Use Cases

### 1. Backup Scripts Package
Upload a ZIP with multiple backup scripts:
- `backup-database.sh`
- `backup-files.sh`
- `backup-logs.sh`

Enable/disable all backups at once during maintenance windows.

### 2. Monitoring Scripts Package
Upload monitoring scripts:
- `check-disk-space.sh`
- `check-memory.sh`
- `check-cpu.sh`

Toggle entire monitoring suite when troubleshooting.

### 3. Deployment Scripts Package
Upload deployment automation:
- `pre-deploy.sh`
- `deploy.sh`
- `post-deploy.sh`

Manage deployment pipeline as a unit.

## Notes

- Package grouping is automatic - no manual configuration needed
- Scripts can only belong to one package
- Deleting a script doesn't affect other scripts in the package
- Package view is the default view for better organization
- Individual script management is still available in Script View

## Future Enhancements

Potential improvements:
- Package-level scheduling (run all scripts in sequence)
- Package dependencies (run package A before package B)
- Package versioning (track changes to packages over time)
- Package export/import (share packages between systems)
- Package templates (pre-configured script collections)