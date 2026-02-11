# Quick Start Guide - PQC File Encryptor

Get up and running in 5 minutes!

## Prerequisites Check

```bash
# Check Java version (must be 24+)
java -version
# Should show: java version "24.0.2" or higher

# Check PostgreSQL
psql --version
# Should show: psql (PostgreSQL) 12.0 or higher

# Check Maven
mvn -version
# Should show: Apache Maven 3.9.0 or higher
```

## Step 1: Database Setup (2 minutes)

```bash
# Create database
createdb pqc_encryptor

# Navigate to project
cd pqc-file-encryptor

# Run schema
psql -d pqc_encryptor -f database/schema.sql

# Verify tables created
psql -d pqc_encryptor -c "\dt"
```

Expected output:
```
                List of relations
 Schema |         Name          | Type  |  Owner
--------+-----------------------+-------+---------
 public | encryption_metadata   | table | your_user
 public | key_statistics        | table | your_user
```

## Step 2: Configure (1 minute)

Edit `src/main/resources/config.json`:

```json
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "database": "pqc_encryptor",
    "user": "YOUR_USERNAME",
    "password": "YOUR_PASSWORD",
    "maxPoolSize": 10
  },
  "server": {
    "port": 8080,
    "host": "0.0.0.0"
  },
  "encryption": {
    "uploadDirectory": "uploads",
    "encryptedDirectory": "uploads/encrypted"
  }
}
```

## Step 3: Build (1 minute)

```bash
# Clean build
mvn clean package

# You should see:
# [INFO] BUILD SUCCESS
# [INFO] Total time: ~10 seconds
```

## Step 4: Run (30 seconds)

```bash
# Start the application
java -jar target/pqc-file-encryptor-1.0.0-fat.jar

# You should see:
# [INFO] Starting PQC File Encryptor...
# [INFO] ✓ ML-KEM (Kyber) support detected!
# [INFO] HTTP server started on port 8080
```

## Step 5: Test (30 seconds)

### Option A: Web Interface

1. Open browser: `http://localhost:8080`
2. Click "Encrypt" tab
3. Drag & drop a file
4. Select "Kyber-768" and "AES-256"
5. Click "Encrypt File"
6. View results!

### Option B: Command Line

```bash
# Create test file
echo "Hello, Post-Quantum World!" > test.txt

# Encrypt via API
curl -X POST http://localhost:8080/api/encrypt \
  -F "file=@test.txt" \
  -F "kemAlgorithm=kyber_768" \
  -F "aesKeySize=256"

# Response:
{
  "success": true,
  "record_id": 1,
  "original_file": "test.txt",
  "encrypted_file": "enc_1738593456789_test.txt",
  "kem_algorithm": "kyber_768",
  "public_key_size": 1184,
  "private_key_size": 2400,
  "size_comparison": { ... }
}
```

## Verify Everything Works

### Check Dashboard

Visit `http://localhost:8080` and verify:

- ✅ **Encrypt Tab**: File upload works
- ✅ **Records Tab**: Shows encrypted files
- ✅ **Dashboard Tab**: Charts display data
- ✅ **Comparison Tab**: Shows size differences

### Check Database

```bash
psql -d pqc_encryptor -c "SELECT * FROM encryption_metadata;"
```

Should show your encrypted file record.

### Check API

```bash
# Get all records
curl http://localhost:8080/api/records

# Get summary
curl http://localhost:8080/api/summary

# Get size comparison
curl http://localhost:8080/api/size-comparison
```

## Common Issues

### Issue: "ML-KEM not available"

**Solution**: You need Java 24. Download from:
- https://jdk.java.net/24/

### Issue: "Connection refused" to PostgreSQL

**Solution**: 
```bash
# Start PostgreSQL
sudo service postgresql start  # Linux
brew services start postgresql # macOS
```

### Issue: "Port 8080 already in use"

**Solution**: Change port in `config.json`:
```json
{
  "server": {
    "port": 8081
  }
}
```

### Issue: Build fails with "release 20 not supported"

**Solution**: Update Maven to use your Java version:
```bash
# Check JAVA_HOME
echo $JAVA_HOME

# Set to Java 24
export JAVA_HOME=/path/to/jdk-24
```

## Next Steps

### 1. Explore the Dashboard

- Try different Kyber variants (512, 768, 1024)
- Compare key sizes in the Comparison tab
- View encryption trends in Dashboard tab

### 2. Test Decryption

1. Go to "Records" tab
2. Click "Decrypt" on any record
3. Check the decrypted file in `uploads/` directory

### 3. Experiment with API

```bash
# Encrypt with different algorithms
curl -X POST http://localhost:8080/api/encrypt \
  -F "file=@largefile.pdf" \
  -F "kemAlgorithm=kyber_1024" \
  -F "aesKeySize=256"

# Get statistics
curl http://localhost:8080/api/key-statistics | jq

# Download encrypted file
curl -O http://localhost:8080/api/download/enc_1738593456789_test.txt
```

### 4. Monitor Logs

```bash
# Watch logs in real-time
tail -f logs/application.log
```

## Performance Tips

### For Large Files

1. Increase JVM heap:
```bash
java -Xmx2g -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

2. Adjust PostgreSQL pool size in `config.json`:
```json
{
  "database": {
    "maxPoolSize": 20
  }
}
```

### For High Concurrency

1. Use multiple Vert.x instances:
```bash
java -jar target/pqc-file-encryptor-1.0.0-fat.jar -instances 4
```

2. Enable PostgreSQL connection pooling

## Development Mode

### Hot Reload

```bash
# Use Maven exec plugin
mvn clean compile exec:java
```

### Debug Mode

```bash
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005 \
  -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

Then attach your IDE debugger to port 5005.

## Production Deployment

### 1. Build Production JAR

```bash
mvn clean package -DskipTests
```

### 2. Configure Production Settings

Create `config.prod.json`:
```json
{
  "database": {
    "host": "prod-db.example.com",
    "ssl": true,
    "maxPoolSize": 50
  },
  "server": {
    "port": 8080,
    "host": "0.0.0.0"
  }
}
```

### 3. Run with Production Config

```bash
java -jar target/pqc-file-encryptor-1.0.0-fat.jar \
  -conf config.prod.json
```

### 4. Setup as Service (Linux)

Create `/etc/systemd/system/pqc-encryptor.service`:
```ini
[Unit]
Description=PQC File Encryptor
After=network.target postgresql.service

[Service]
Type=simple
User=pqc
WorkingDirectory=/opt/pqc-encryptor
ExecStart=/usr/bin/java -jar pqc-file-encryptor-1.0.0-fat.jar
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable pqc-encryptor
sudo systemctl start pqc-encryptor
sudo systemctl status pqc-encryptor
```

## Getting Help

- **Documentation**: See `README.md` for detailed info
- **API Reference**: See `API_REFERENCE.md`
- **Architecture**: See `ARCHITECTURE.md`
- **Issues**: Check existing documentation first

## Success Checklist

- [ ] Java 24 installed and verified
- [ ] PostgreSQL running and accessible
- [ ] Database schema created successfully
- [ ] Application builds without errors
- [ ] Application starts and shows "ML-KEM support detected"
- [ ] Web interface accessible at http://localhost:8080
- [ ] Can encrypt a test file
- [ ] Can decrypt the encrypted file
- [ ] Dashboard shows statistics
- [ ] API endpoints respond correctly

If all checked, you're ready to go! 🎉

---

**Estimated Total Time**: 5 minutes
**Difficulty**: Easy
**Prerequisites**: Java 24, PostgreSQL, Maven