# How to Run the PQC File Encryptor

Follow these simple steps to run the application:

## Step 1: Create the Database (One-time setup)

```bash
# Navigate to the project directory
cd pqc-file-encryptor

# Create the database
createdb pqc_encryptor

# Create the schema
psql -d pqc_encryptor -f database/schema.sql
```

**Expected output:**
```
CREATE TABLE
CREATE TABLE
CREATE VIEW
CREATE VIEW
```

## Step 2: Configure Database Connection

Edit `src/main/resources/config.json` and update your PostgreSQL credentials:

```json
{
  "database": {
    "host": "localhost",
    "port": 5432,
    "database": "pqc_encryptor",
    "user": "YOUR_POSTGRES_USERNAME",
    "password": "YOUR_POSTGRES_PASSWORD",
    "maxPoolSize": 10
  }
}
```

**Common PostgreSQL usernames:**
- Windows: Usually your Windows username
- Linux/Mac: Usually `postgres` or your system username

## Step 3: Build the Application

```bash
# Still in pqc-file-encryptor directory
mvn clean package
```

**Expected output:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: ~10 seconds
```

This creates: `target/pqc-file-encryptor-1.0.0-fat.jar`

## Step 4: Run the Application

```bash
java -jar target/pqc-file-encryptor-1.0.0-fat.jar
```

**Expected output:**
```
[INFO] Starting PQC File Encryptor...
[INFO] Configuration loaded
[INFO] Initializing services...
[INFO] Available Security Providers:
[INFO]   - SUN (version 24.0)
[INFO] ✓ ML-KEM (Kyber) support detected!
[INFO] HTTP server started on port 8080
```

**Note:** If you see "ML-KEM not available", that's OK! The app will use RSA simulation mode for demonstration.

## Step 5: Open the Dashboard

Open your web browser and go to:

```
http://localhost:8080
```

You should see the PQC File Encryptor dashboard with 4 tabs:
- **Encrypt**: Upload and encrypt files
- **Records**: View encrypted files
- **Dashboard**: Statistics and charts
- **Comparison**: Classical vs PQC key sizes

## Quick Test

### Test via Web Interface:

1. Click the **"Encrypt"** tab
2. Drag and drop a text file (or click to browse)
3. Select **"Kyber-768"** and **"AES-256"**
4. Click **"Encrypt File"**
5. See the results with key size comparisons!

### Test via Command Line:

```bash
# Create a test file
echo "Hello, Post-Quantum World!" > test.txt

# Encrypt it
curl -X POST http://localhost:8080/api/encrypt \
  -F "file=@test.txt" \
  -F "kemAlgorithm=kyber_768" \
  -F "aesKeySize=256"

# You should get a JSON response with encryption details
```

## Troubleshooting

### Problem: "Connection refused" to PostgreSQL

**Solution:**
```bash
# Check if PostgreSQL is running
pg_isready

# If not running, start it:
# Windows (if installed as service):
net start postgresql-x64-16

# Or check Services app and start "postgresql-x64-16"
```

### Problem: "Database does not exist"

**Solution:**
```bash
# Create it again
createdb pqc_encryptor
psql -d pqc_encryptor -f database/schema.sql
```

### Problem: "Authentication failed"

**Solution:** Update `config.json` with correct PostgreSQL username/password

### Problem: "Port 8080 already in use"

**Solution:** Change the port in `config.json`:
```json
{
  "server": {
    "port": 8081
  }
}
```

Then access: `http://localhost:8081`

### Problem: Build fails

**Solution:**
```bash
# Clean everything and rebuild
mvn clean
mvn package
```

## Stopping the Application

Press `Ctrl+C` in the terminal where the application is running.

## What to Try

1. **Encrypt different file types**: Try .txt, .pdf, .jpg, .zip
2. **Compare algorithms**: Try Kyber-512, Kyber-768, and Kyber-1024
3. **View statistics**: Check the Dashboard tab for charts
4. **Decrypt files**: Go to Records tab and click "Decrypt"
5. **Compare sizes**: See the Comparison tab for visual size differences

## Next Steps

- Read `README.md` for detailed documentation
- Check `JAVA24_NATIVE_PQC.md` for technical details
- Explore the API endpoints (see README.md)

---

**Need Help?** Check the documentation files or the troubleshooting section above.