# Quick Start Guide

Get the PQC Domain Scanner up and running in 5 minutes!

## Prerequisites Check

```bash
# Check Java version (need 17+)
java -version

# Check Maven
mvn -version

# Check PostgreSQL
psql --version
```

## Step-by-Step Setup

### 1. Database Setup (2 minutes)

```bash
# Create database
createdb pqc_scanner

# Initialize schema
psql -U postgres -d pqc_scanner -f database/schema.sql
```

**Windows users**: Use pgAdmin or:
```cmd
psql -U postgres
CREATE DATABASE pqc_scanner;
\c pqc_scanner
\i database/schema.sql
```

### 2. Configure (30 seconds)

Edit `src/main/resources/config.json` if needed (default works for local PostgreSQL):

```json
{
  "database": {
    "user": "postgres",
    "password": "postgres"
  }
}
```

### 3. Build & Run (2 minutes)

```bash
# Build
mvn clean package

# Run
java -jar target/pqc-domain-scanner-1.0.0.jar
```

**Alternative** - Run directly with Maven:
```bash
mvn compile exec:java -Dexec.mainClass="io.vertx.core.Launcher" -Dexec.args="run com.pqc.scanner.MainVerticle"
```

### 4. Access Dashboard

Open browser: **http://localhost:8080**

## First Scan

1. Enter a domain in the input field (e.g., `google.com`)
2. Click **"Add Domain"**
3. Click **"Scan"** button next to the domain
4. Watch the results appear in real-time!

## Test with Sample Domains

Try these domains to see different PQC readiness levels:

```
google.com
cloudflare.com
github.com
microsoft.com
amazon.com
```

## Common Issues

### Port 8080 Already in Use
Change port in `config.json`:
```json
{
  "http": {
    "port": 8081
  }
}
```

### Database Connection Failed
1. Check PostgreSQL is running: `pg_isready`
2. Verify credentials in config.json
3. Check database exists: `psql -l | grep pqc_scanner`

### Build Fails
```bash
# Clean and rebuild
mvn clean
mvn package -U
```

## What's Next?

- 📊 Explore the dashboard charts and statistics
- 🔍 View detailed certificate information
- 📈 Monitor vulnerability time windows
- 🔄 Set up batch scanning for multiple domains
- 📖 Read the full [README.md](README.md) for advanced features

## Quick Commands Reference

```bash
# Start application
java -jar target/pqc-domain-scanner-1.0.0.jar

# Rebuild after changes
mvn clean package

# Reset database
psql -U postgres -d pqc_scanner -f database/schema.sql

# Check logs
# Logs appear in console output

# Stop application
# Press Ctrl+C in terminal
```

## API Quick Test

Test the API with curl:

```bash
# Health check
curl http://localhost:8080/api/health

# Get statistics
curl http://localhost:8080/api/stats

# Add domain
curl -X POST http://localhost:8080/api/domains \
  -H "Content-Type: application/json" \
  -d '{"domain":"example.com"}'

# Scan domain
curl -X POST http://localhost:8080/api/scan/example.com

# Get results
curl http://localhost:8080/api/results
```

## Development Mode

For development with auto-reload:

```bash
# Terminal 1 - Run application
mvn compile exec:java -Dexec.mainClass="io.vertx.core.Launcher" -Dexec.args="run com.pqc.scanner.MainVerticle"

# Terminal 2 - Watch for changes and rebuild
mvn compile -Dexec.args="run com.pqc.scanner.MainVerticle" -Dvertx.disableFileCaching=true
```

## Need Help?

- Check [README.md](README.md) for detailed documentation
- Review [Troubleshooting](#common-issues) section above
- Check application logs in console
- Verify all prerequisites are installed

---

**Ready to scan!** 🚀 Open http://localhost:8080 and start monitoring your domains for quantum readiness.