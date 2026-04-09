# CyberSkill Platform - Build and Run Guide

Complete guide to building, running, and testing the CyberSkill Learning Platform.

## 📋 Prerequisites

### Required Software
- **Java 17 or higher** - [Download](https://adoptium.net/)
- **Maven 3.8+** - [Download](https://maven.apache.org/download.cgi)
- **PostgreSQL 14+** - [Download](https://www.postgresql.org/download/)
- **Docker & Docker Compose** (Optional) - [Download](https://www.docker.com/products/docker-desktop)

### Verify Installation
```bash
java -version    # Should show Java 17+
mvn -version     # Should show Maven 3.8+
psql --version   # Should show PostgreSQL 14+
docker --version # Should show Docker 20+
```

## 🚀 Quick Start (Docker)

### 1. Start Everything with Docker Compose
```bash
cd cyber-skill-platform
docker-compose up -d
```

### 2. Check Status
```bash
docker-compose ps
docker-compose logs -f app
```

### 3. Access the Platform
- **Home**: http://localhost:8080
- **Login**: http://localhost:8080/login
- **API Health**: http://localhost:8080/api/health

### 4. Stop Services
```bash
docker-compose down
```

### 5. Clean Everything (including data)
```bash
docker-compose down -v
```

## 💻 Local Development Setup

### Step 1: Setup PostgreSQL Database

#### On macOS (using Homebrew)
```bash
# Install PostgreSQL
brew install postgresql@14

# Start PostgreSQL
brew services start postgresql@14

# Create database and user
psql postgres
```

#### On Ubuntu/Debian
```bash
# Install PostgreSQL
sudo apt update
sudo apt install postgresql-14

# Start PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Switch to postgres user
sudo -u postgres psql
```

#### On Windows
1. Download PostgreSQL installer from postgresql.org
2. Run installer and follow wizard
3. Open pgAdmin or psql command line

#### Create Database
```sql
-- In psql prompt
CREATE DATABASE cyberskill;
CREATE USER cyberskill_user WITH PASSWORD 'changeme';
GRANT ALL PRIVILEGES ON DATABASE cyberskill TO cyberskill_user;
ALTER DATABASE cyberskill OWNER TO cyberskill_user;
\q
```

### Step 2: Configure Application

Edit `src/main/resources/application.properties`:

```properties
# Database Configuration
database.host=localhost
database.port=5432
database.name=cyberskill
database.username=cyberskill_user
database.password=changeme

# JWT Secret (CHANGE THIS!)
jwt.secret=YOUR_STRONG_SECRET_KEY_HERE_AT_LEAST_32_CHARACTERS_LONG

# Server Configuration
server.port=8080
server.host=0.0.0.0
```

### Step 3: Build the Application

```bash
cd cyber-skill-platform

# Clean and build
mvn clean package

# Skip tests (faster)
mvn clean package -DskipTests
```

Expected output:
```
[INFO] BUILD SUCCESS
[INFO] Total time: 45.123 s
[INFO] Finished at: 2026-03-11T18:00:00Z
```

### Step 4: Run the Application

#### Option A: Using Maven
```bash
mvn exec:java
```

#### Option B: Using JAR file
```bash
java -jar target/cyberskill-platform-1.0.0-fat.jar
```

#### Option C: With custom JVM options
```bash
java -Xmx512m -Xms256m -jar target/cyberskill-platform-1.0.0-fat.jar
```

### Step 5: Verify Application Started

Look for these log messages:
```
✓ Applied X database migration(s)
✓ Database connection pool initialized
✓ Repositories initialized
✓ Services initialized
✓ Handlers initialized
✓ CyberSkill Platform started successfully
✓ Server listening on http://0.0.0.0:8080
```

## 🧪 Testing the Application

### 1. Health Check
```bash
curl http://localhost:8080/api/health
```

Expected response:
```json
{"status":"UP","service":"CyberSkill Platform"}
```

### 2. Test Registration
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test@123456"
  }'
```

### 3. Test Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@cyberskill.com",
    "password": "Admin@123"
  }'
```

### 4. Test Protected Endpoint
```bash
# Save token from login response
TOKEN="your_access_token_here"

curl http://localhost:8080/api/user/profile \
  -H "Authorization: Bearer $TOKEN"
```

### 5. Test Learning Paths
```bash
curl http://localhost:8080/api/paths
```

## 🔧 Development Workflow

### Hot Reload (Development Mode)

#### Using Maven with auto-reload
```bash
mvn compile exec:java
```

#### Watch for changes
```bash
# Terminal 1: Watch and compile
mvn compile -Dexec.classpathScope=compile

# Terminal 2: Run application
mvn exec:java
```

### Running Tests
```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=UserRepositoryTest

# Run with coverage
mvn clean test jacoco:report

# View coverage report
open target/site/jacoco/index.html
```

### Code Quality Checks
```bash
# Check code style
mvn checkstyle:check

# Find bugs
mvn spotbugs:check

# Dependency analysis
mvn dependency:analyze
```

## 🐛 Troubleshooting

### Problem: Port 8080 already in use

**Solution 1**: Change port in `application.properties`
```properties
server.port=8081
```

**Solution 2**: Kill process using port 8080
```bash
# On macOS/Linux
lsof -ti:8080 | xargs kill -9

# On Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Problem: Database connection failed

**Check 1**: PostgreSQL is running
```bash
# macOS
brew services list

# Linux
sudo systemctl status postgresql

# Windows
services.msc (look for PostgreSQL)
```

**Check 2**: Database exists
```bash
psql -U cyberskill_user -d cyberskill -c "SELECT 1;"
```

**Check 3**: Credentials are correct
```bash
# Test connection
psql -h localhost -p 5432 -U cyberskill_user -d cyberskill
```

### Problem: Flyway migration failed

**Solution**: Clean and restart
```bash
# Connect to database
psql -U cyberskill_user -d cyberskill

# Drop and recreate schema
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO cyberskill_user;

# Restart application
```

### Problem: Out of memory

**Solution**: Increase heap size
```bash
java -Xmx1g -Xms512m -jar target/cyberskill-platform-1.0.0-fat.jar
```

### Problem: Maven build fails

**Solution 1**: Clean Maven cache
```bash
mvn clean install -U
```

**Solution 2**: Delete local repository
```bash
rm -rf ~/.m2/repository
mvn clean install
```

## 📊 Monitoring

### View Logs
```bash
# Application logs
tail -f logs/cyberskill.log

# Error logs
tail -f logs/cyberskill-error.log

# Audit logs
tail -f logs/cyberskill-audit.log
```

### Database Monitoring
```bash
# Connect to database
psql -U cyberskill_user -d cyberskill

# Check active connections
SELECT count(*) FROM pg_stat_activity WHERE datname = 'cyberskill';

# Check table sizes
SELECT 
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;

# Check migration history
SELECT * FROM flyway_schema_history ORDER BY installed_rank;
```

### Performance Monitoring
```bash
# Check JVM stats
jstat -gc <PID> 1000

# Thread dump
jstack <PID> > thread_dump.txt

# Heap dump
jmap -dump:format=b,file=heap_dump.hprof <PID>
```

## 🔐 Security Checklist

Before deploying to production:

- [ ] Change default admin password
- [ ] Change default user password
- [ ] Update JWT secret to strong random value
- [ ] Enable HTTPS/TLS
- [ ] Configure firewall rules
- [ ] Set up database backups
- [ ] Enable rate limiting
- [ ] Review CORS settings
- [ ] Set up monitoring and alerts
- [ ] Configure log rotation
- [ ] Review and update dependencies
- [ ] Enable MFA for admin accounts

## 📦 Building for Production

### Create Production Build
```bash
# Build with production profile
mvn clean package -Pprod -DskipTests

# Verify JAR
ls -lh target/cyberskill-platform-1.0.0-fat.jar
```

### Docker Production Build
```bash
# Build image
docker build -t cyberskill-platform:1.0.0 .

# Tag for registry
docker tag cyberskill-platform:1.0.0 your-registry/cyberskill-platform:1.0.0

# Push to registry
docker push your-registry/cyberskill-platform:1.0.0
```

### Deploy with Docker Compose
```bash
# Production deployment
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## 🎯 Next Steps

1. **Test all endpoints** - Use Postman or curl
2. **Create test users** - Register and test different roles
3. **Add learning content** - Use admin endpoints
4. **Monitor performance** - Check logs and metrics
5. **Set up CI/CD** - Automate builds and deployments
6. **Configure backups** - Database and file storage
7. **Enable monitoring** - Prometheus, Grafana, etc.

## 📞 Support

- **Documentation**: See README_PLATFORM.md
- **Quick Start**: See QUICKSTART.md
- **Architecture**: See ARCHITECTURE.md
- **Issues**: GitHub Issues
- **Email**: support@cyberskill.com

---

**Last Updated**: March 2026
**Version**: 1.0.0