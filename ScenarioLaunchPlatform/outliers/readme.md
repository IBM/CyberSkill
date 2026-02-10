# Outliers Directory

This directory contains pre-packaged outlier script bundles that can be deployed to the system.

## Structure

Place your outlier ZIP files directly in this directory. Each ZIP should contain:
- Scripts (bash or Windows batch/PowerShell)
- A JSON configuration file (outlier-config.json or matching the ZIP name)
- README.md (optional but recommended)
- Any supporting files (SQL scripts, etc.)

## Example

```
outliers/
├── outlier_data_tampering_mysql.zip
├── outlier_account_takeover_mysql.zip
└── outlier_schema_tampering_mysql.zip
```

## Deployment

Outliers can be deployed from the UI:
1. Navigate to the Outliers page
2. Click "Deploy from Library"
3. Select an outlier from the available list
4. Click "Deploy" to install it

The system will automatically:
- Extract the ZIP contents
- Parse the configuration
- Add scripts to the library
- Configure schedules
- Save to database