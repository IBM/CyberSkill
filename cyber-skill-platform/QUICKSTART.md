# CyberSkill Platform - Quick Start Guide

Get the CyberSkill Learning Platform up and running in minutes!

## 🚀 Fastest Way to Start (Docker)

### Prerequisites
- Docker Desktop installed
- 4GB RAM available
- 10GB disk space

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/CyberSkill.git
cd CyberSkill
```

2. **Start the platform**
```bash
docker-compose up -d
```

3. **Wait for services to be ready** (about 30-60 seconds)
```bash
docker-compose logs -f app
# Wait for: "✓ CyberSkill Platform started successfully"
```

4. **Access the platform**
- Open browser: http://localhost:8080
- Login with default credentials:
  - **Admin**: admin@cyberskill.com / Admin@123
  - **User**: user@cyberskill.com / User@123

5. **Stop the platform**
```bash
docker-compose down
```

## 💻 Local Development Setup

### Prerequisites
- Java 17+
- Maven 3.8+
- PostgreSQL 14+

### Steps

1. **Setup Database**
```bash
# Install PostgreSQL (if not installed)
# macOS: brew install postgresql@14
# Ubuntu: sudo apt install postgresql-14
# Windows: Download from postgresql.org

# Start PostgreSQL
# macOS: brew services start postgresql@14
# Ubuntu: sudo systemctl start postgresql
# Windows: Start from Services

# Create database and user
psql postgres
CREATE DATABASE cyberskill;
CREATE USER cyberskill_user WITH PASSWORD 'changeme';
GRANT ALL PRIVILEGES ON DATABASE cyberskill TO cyberskill_user;
\q
```

2. **Configure Application**
```bash
# Edit src/main/resources/application.properties
# Update database credentials if needed
```

3. **Build and Run**
```bash
# Build
mvn clean package

# Run
java -jar target/cyberskill-platform-1.0.0-fat.jar

# Or use Maven directly
mvn exec:java
```

4. **Access the platform**
- Open browser: http://localhost:8080

## 🔧 Configuration

### Change Default Passwords

**IMPORTANT**: Change these immediately!

```sql
-- Connect to database
psql -U cyberskill_user -d cyberskill

-- Update admin password (hash for "NewSecurePassword123!")
UPDATE users 
SET password_hash = '$2a$12$YOUR_NEW_HASH_HERE' 
WHERE email = 'admin@cyberskill.com';

-- Update test user password
UPDATE users 
SET password_hash = '$2a$12$YOUR_NEW_HASH_HERE' 
WHERE email = 'user@cyberskill.com';
```

### Generate Password Hash
```bash
# Use online BCrypt generator or create a utility
# Recommended: https://bcrypt-generator.com/
# Use 12 rounds
```

### Update JWT Secret

Edit `src/main/resources/application.properties`:
```properties
jwt.secret=YOUR_STRONG_RANDOM_SECRET_HERE_AT_LEAST_32_CHARS
```

Generate a strong secret:
```bash
# Linux/macOS
openssl rand -base64 32

# Or use online generator
# https://randomkeygen.com/
```

## 📊 Verify Installation

### Check Health
```bash
curl http://localhost:8080/api/health
# Expected: {"status":"UP","service":"CyberSkill Platform"}
```

### Check Database
```bash
# Connect to database
psql -U cyberskill_user -d cyberskill

# List tables
\dt

# Check users
SELECT id, username, email, role FROM users;

# Check learning paths
SELECT id, name, slug FROM learning_paths;
```

### Check Logs
```bash
# Application logs
tail -f logs/cyberskill.log

# Docker logs
docker-compose logs -f app
```

## 🎓 First Steps

### As a Learner

1. **Login** at http://localhost:8080/login
   - Use: user@cyberskill.com / User@123

2. **Browse Learning Paths**
   - Navigate to Dashboard
   - Choose a learning path (e.g., Penetration Testing)

3. **Start Learning**
   - Select a module
   - Complete lessons
   - Take quizzes
   - Earn badges!

### As an Administrator

1. **Login** at http://localhost:8080/login
   - Use: admin@cyberskill.com / Admin@123

2. **Access Admin Dashboard**
   - Navigate to http://localhost:8080/admin

3. **Manage Users**
   - View all users
   - Add new users
   - Edit user roles
   - View user progress

4. **Manage Content**
   - Add/edit learning paths
   - Create modules and sections
   - Upload lessons
   - Create quizzes

## 🐛 Troubleshooting

### Port Already in Use
```bash
# Check what's using port 8080
# Linux/macOS
lsof -i :8080

# Windows
netstat -ano | findstr :8080

# Change port in application.properties
server.port=8081
```

### Database Connection Failed
```bash
# Check PostgreSQL is running
# macOS
brew services list

# Ubuntu
sudo systemctl status postgresql

# Check credentials in application.properties
# Verify database exists
psql -U cyberskill_user -d cyberskill
```

### Docker Issues
```bash
# Remove all containers and volumes
docker-compose down -v

# Rebuild images
docker-compose build --no-cache

# Start fresh
docker-compose up -d
```

### Migration Errors
```bash
# Check Flyway migration status
# Connect to database
psql -U cyberskill_user -d cyberskill

# Check migration history
SELECT * FROM flyway_schema_history;

# If needed, clean and restart
# WARNING: This deletes all data!
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO cyberskill_user;
```

## 📚 Next Steps

1. **Read Full Documentation**
   - [README_PLATFORM.md](README_PLATFORM.md) - Complete guide
   - [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture

2. **Explore the API**
   - API documentation at http://localhost:8080/api/docs
   - Test endpoints with Postman or curl

3. **Customize Content**
   - Add your own learning paths
   - Create custom modules
   - Upload learning materials

4. **Deploy to Production**
   - Use Docker Compose with production profile
   - Configure SSL/TLS
   - Set up monitoring
   - Configure backups

## 🆘 Getting Help

- **Documentation**: See README_PLATFORM.md
- **Issues**: https://github.com/yourusername/CyberSkill/issues
- **Email**: support@cyberskill.com

## ✅ Checklist

Before going to production:

- [ ] Changed default admin password
- [ ] Changed default user password
- [ ] Updated JWT secret
- [ ] Configured SSL/TLS
- [ ] Set up database backups
- [ ] Configured monitoring
- [ ] Reviewed security settings
- [ ] Tested all features
- [ ] Set up log rotation
- [ ] Configured email notifications (if enabled)

---

Happy Learning! 🎓🔒