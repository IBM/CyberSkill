# Outlier Detection Content Packs - ID Mapping Summary

## Overview
All 9 outlier detection content packs have been successfully migrated to high ID ranges (1000-1800+) to avoid collisions with existing Oracle, MySQL, DB2, and other database content packs.

## ID Range Mapping

| Pack Name | Old ID Range | New ID Range | Query Count | Status |
|-----------|--------------|--------------|-------------|---------|
| **outlier_schema_tampering** | 1-7 | 1001-1007 | 7 | ✅ Complete |
| **outlier_data_tampering** | 101-110 | 1101-1110 | 10 | ✅ Complete |
| **outlier_update_anomaly** | 201-210 | 1201-1210 | 10 | ✅ Complete |
| **outlier_insert_anomaly** | 401-409 | 1301-1309 | 9 | ✅ Complete |
| **outlier_revoke_anomaly** | 501-510 | 1401-1410 | 10 | ✅ Complete |
| **outlier_massive_grant_case** | 601-611 | 1501-1511 | 11 | ✅ Complete |
| **outlier_data_leak_command** | 701-710 | 1601-1610 | 10 | ✅ Complete |
| **outlier_account_take_over** | 801-814 | 1701-1714 | 14 | ✅ Complete |
| **outlier_denial_of_service** | 901-910 | 1801-1810 | 10 | ✅ Complete |

## Pack Details

### 1. Schema Tampering (1001-1007)
- **Purpose**: Detects unauthorized ALTER TABLE operations
- **Pattern**: 4 baseline hours (50 ALTERs/hour) + Hour 5 spike (1000 ALTERs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 2. Data Tampering (1101-1110)
- **Purpose**: Detects unauthorized DELETE operations
- **Pattern**: 4 baseline hours (50 DELETEs/hour) + Hour 5 spike (1000 DELETEs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 3. Update Anomaly (1201-1210)
- **Purpose**: Detects unauthorized UPDATE operations
- **Pattern**: 4 baseline hours (50 UPDATEs/hour) + Hour 5 spike (1000 UPDATEs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 4. Insert Anomaly (1301-1309)
- **Purpose**: Detects unauthorized INSERT operations
- **Pattern**: 4 baseline hours (50 INSERTs/hour) + Hour 5 spike (1000 INSERTs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 5. Revoke Anomaly (1401-1410)
- **Purpose**: Detects unauthorized REVOKE operations
- **Pattern**: 4 baseline hours (50 REVOKEs/hour) + Hour 5 spike (1000 REVOKEs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 6. Massive GRANT Case (1501-1511)
- **Purpose**: Detects privilege escalation via GRANT operations
- **Pattern**: 4 baseline hours (1 GRANT/hour) + Hour 5 spike (21 GRANTs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 7. Data Leak Command (1601-1610)
- **Purpose**: Detects unauthorized SELECT operations (data exfiltration)
- **Pattern**: 4 baseline hours (50 SELECTs/hour) + Hour 5 spike (1000 SELECTs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 8. Account Takeover (1701-1714)
- **Purpose**: Detects account takeover via excessive SELECT operations
- **Pattern**: 4 baseline hours (50 SELECTs/hour) + Hour 5 spike (1000 SELECTs)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

### 9. Denial of Service (1801-1810)
- **Purpose**: Detects DoS attacks via query flooding
- **Pattern**: 4 baseline hours (1001 queries/hour) + Hour 5 spike (205000 queries)
- **Files Updated**: query_inserts.json, story_inserts.json, uninstall.json

## Common Features

### 5-Hour Anomaly Pattern
All packs follow the same temporal pattern:
- **Hours 1-4**: Baseline activity (normal operations)
- **Hour 5**: Anomaly spike (20x increase in operations)

### Double-Cleanup Pattern
Each pack includes:
- **Pre-cleanup query** (ID X01): Drops objects from previous runs
- **Post-cleanup query** (ID X0N): Removes test objects after completion

### Story Versions
Each pack includes two story versions:
1. **Full Story**: 1-hour pauses (3600000ms) between baseline hours
2. **Quick Demo**: 5-second pauses (5000ms) for rapid testing

## File Structure
Each pack contains:
```
outlier_<pack_name>/
├── pack.json
├── scripts/
│   └── mysql_runById.sh
├── sql/
│   ├── query_inserts.json    (Query definitions)
│   ├── story_inserts.json    (Story orchestration)
│   ├── uninstall.json        (Cleanup references)
│   └── users.json            (User definitions)
└── html/
    └── index.html
```

## Migration Method
IDs were updated using a Python script (`update_ids.py`) that:
1. Recursively traverses JSON structures
2. Identifies `id` and `query_id` fields
3. Maps old IDs to new IDs based on offset calculation
4. Preserves JSON formatting and structure

## Verification
All packs have been verified to contain correct ID ranges:
- ✅ query_inserts.json: Query IDs updated
- ✅ story_inserts.json: Story and query_id references updated
- ✅ uninstall.json: Cleanup references updated

## Deployment Notes
- All packs are ready for deployment to Scenario Launch Platform
- No ID collisions with existing content packs (Oracle, MySQL, DB2)
- Each pack maintains its 5-hour anomaly detection pattern
- Compatible with Guardium outlier detection policies

## Date Completed
February 12, 2026