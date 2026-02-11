# File-Based Storage Solution

## Overview

The PQC File Encryptor now uses a **reliable file-based storage system** instead of PostgreSQL to store encryption metadata and statistics. This eliminates database compatibility issues while providing persistent data storage.

## Why File-Based Storage?

### Problem Solved
- **Java 24/Vert.x PostgreSQL Incompatibility**: The PostgreSQL driver had date parsing issues with Java 24
- **Simplified Deployment**: No database setup required
- **Zero Configuration**: Works out of the box
- **Reliable Persistence**: Data stored in JSON files

### Benefits
✅ **No Database Required** - Eliminates PostgreSQL dependency  
✅ **Instant Setup** - No schema creation or connection configuration  
✅ **Human-Readable** - Data stored in JSON format  
✅ **Portable** - Easy to backup and transfer  
✅ **Fast** - In-memory cache with file persistence  
✅ **Reliable** - No network or connection issues  

## Architecture

### FileStorageService

**Location**: `src/main/java/com/pqc/encryptor/FileStorageService.java`

**Features**:
- In-memory cache for fast access
- Async file I/O using Vert.x
- Automatic data persistence
- Thread-safe operations
- Graceful error handling

### Storage Structure

```
pqc-file-encryptor/
├── data/                              # Storage directory
│   ├── encryption_records.json        # All encryption records
│   └── key_statistics.json            # Algorithm statistics
├── encrypted/                         # Encrypted files
└── uploads/                           # Original files
```

## Data Format

### Encryption Records (`encryption_records.json`)

```json
[
  {
    "record_id": "1738596281697",
    "original_file": "test.txt",
    "encrypted_file": "test.txt.enc",
    "kem_algorithm": "KYBER_1024",
    "aes_key_size": 256,
    "public_key_size": 1568,
    "private_key_size": 3168,
    "encapsulated_key_size": 1568,
    "original_size": 1024,
    "encrypted_size": 1088,
    "status": "encrypted",
    "created_at": "2026-02-03T16:24:41.697Z",
    "notes": "Private key: base64encodedkey..."
  }
]
```

### Key Statistics (`key_statistics.json`)

```json
[
  {
    "algorithm": "KYBER_1024",
    "total_uses": 5,
    "avg_public_key_size": 1568,
    "avg_private_key_size": 3168,
    "avg_encapsulated_key_size": 1568,
    "last_used": "2026-02-03T16:24:41.697Z"
  },
  {
    "algorithm": "KYBER_768",
    "total_uses": 3,
    "avg_public_key_size": 1184,
    "avg_private_key_size": 2400,
    "avg_encapsulated_key_size": 1088,
    "last_used": "2026-02-03T16:20:15.123Z"
  }
]
```

## API Methods

### Store Encryption Record
```java
Future<Void> storeEncryptionRecord(JsonObject record)
```
Stores a new encryption record with metadata.

### Update Key Statistics
```java
Future<Void> updateKeyStatistics(
    String algorithm, 
    int publicKeySize, 
    int privateKeySize, 
    int encapsulatedKeySize
)
```
Updates running averages for algorithm key sizes.

### Get Encryption Records
```java
Future<JsonArray> getEncryptionRecords(int limit, int offset)
```
Retrieves paginated encryption records (sorted by date, newest first).

### Get Single Record
```java
Future<JsonObject> getEncryptionRecord(String recordId)
```
Retrieves a specific encryption record by ID.

### Get Key Statistics
```java
Future<JsonArray> getKeyStatistics()
```
Returns statistics for all algorithms used.

### Get Overall Statistics
```java
Future<JsonObject> getStatistics()
```
Returns summary statistics including:
- Total encryptions
- Algorithms used
- Algorithm distribution
- Average key sizes

## Performance

### In-Memory Cache
- **Read Operations**: Instant (from cache)
- **Write Operations**: Async (non-blocking)
- **Startup**: Fast (loads existing data)

### File Operations
- **Persistence**: Async using Vert.x `executeBlocking`
- **Format**: Pretty-printed JSON for readability
- **Safety**: Atomic writes with `TRUNCATE_EXISTING`

## Data Persistence

### Automatic Saving
Data is automatically saved to disk after every operation:
- New encryption record → saves `encryption_records.json`
- Statistics update → saves `key_statistics.json`

### Data Loading
On startup, FileStorageService:
1. Creates `data/` directory if needed
2. Loads existing records into cache
3. Loads existing statistics into cache
4. Logs number of records loaded

### Backup Strategy
Simply copy the `data/` directory:
```bash
# Backup
cp -r data/ data_backup_2026-02-03/

# Restore
cp -r data_backup_2026-02-03/ data/
```

## UI Integration

### Dashboard Display
The web UI automatically displays:
- **Records Tab**: All encryption records with pagination
- **Dashboard Tab**: Statistics and charts
- **Comparison Tab**: Key size comparisons

### Real-Time Updates
- New encryptions appear immediately
- Statistics update in real-time
- No page refresh needed

## Migration from Database

If you previously used PostgreSQL:

1. **Export Data** (if needed):
   ```sql
   COPY encryption_records TO '/path/to/export.json' WITH (FORMAT json);
   ```

2. **Convert Format**: Match the JSON structure above

3. **Import**: Place files in `data/` directory

4. **Restart**: Application loads data automatically

## Troubleshooting

### Data Not Persisting
**Check**: `data/` directory permissions
```bash
ls -la data/
chmod 755 data/
```

### Records Not Showing in UI
**Check**: Browser console for API errors
**Verify**: `data/encryption_records.json` exists and is valid JSON

### Statistics Not Updating
**Check**: Application logs for write errors
**Verify**: `data/key_statistics.json` is writable

### Corrupted JSON Files
**Fix**: Delete corrupted file, application will recreate:
```bash
rm data/encryption_records.json
# Restart application
```

## Advantages Over Database

| Feature | File Storage | PostgreSQL |
|---------|-------------|------------|
| Setup Time | 0 seconds | 5-10 minutes |
| Dependencies | None | PostgreSQL server |
| Configuration | None | Connection strings, credentials |
| Portability | Copy files | Dump/restore |
| Debugging | View JSON | SQL queries |
| Backup | Copy directory | pg_dump |
| Compatibility | Always works | Version-dependent |

## Future Enhancements

Possible improvements:
- **Compression**: Gzip JSON files for large datasets
- **Rotation**: Archive old records automatically
- **Search**: Index records for faster queries
- **Export**: CSV/Excel export functionality
- **Encryption**: Encrypt storage files themselves

## Conclusion

The file-based storage solution provides:
- ✅ **Reliability**: No database connection issues
- ✅ **Simplicity**: Zero configuration required
- ✅ **Performance**: Fast in-memory cache
- ✅ **Portability**: Easy backup and transfer
- ✅ **Transparency**: Human-readable JSON format

**Perfect for demonstration and production use!**