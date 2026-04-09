# CyberSkill Learning Platform

Enterprise-grade cybersecurity learning and upskilling platform built with Java Vert.x, Freemarker, and PostgreSQL.

## 🎯 Overview

CyberSkill is a comprehensive learning platform designed for cybersecurity professionals to upskill in four core domains:

1. **Penetration Testing** - Master ethical hacking and penetration testing techniques
2. **Compliance** - Navigate GDPR, ISO 27001, SOC 2, and industry standards
3. **Data Security** - Protect sensitive data with encryption and access controls
4. **Post-Quantum Computing** - Prepare for quantum threats with next-gen cryptography

## ✨ Features

### For Learners
- 📚 **Structured Learning Paths** - Follow comprehensive curricula with modules, sections, and lessons
- 📊 **Progress Tracking** - Monitor your learning journey with detailed analytics
- ✅ **Assessments** - Test knowledge with auto-graded quizzes
- 🏆 **Achievements** - Earn badges and certificates for completing milestones
- 📱 **Responsive Design** - Learn on any device

### For Administrators
- 👥 **User Management** - Add, edit, and manage user accounts
- 📝 **Content Management** - Create and update learning materials
- 📈 **Analytics Dashboard** - Track engagement and completion rates
- 🔍 **Audit Logs** - Monitor all administrative actions
- 🎯 **Role-Based Access Control** - Secure admin functions

### Security Features
- 🔐 **JWT Authentication** - Secure token-based authentication
- 🔑 **BCrypt Password Hashing** - Industry-standard password security
- 🛡️ **Role-Based Access Control** - USER and ADMIN roles
- 🔒 **Optional MFA** - Two-factor authentication support
- 📝 **Audit Logging** - Track all security-relevant events

## 🏗️ Architecture

### Technology Stack
- **Backend**: Java 17, Vert.x 4.5
- **Frontend**: Freemarker templates, HTML5, CSS3, JavaScript
- **Database**: PostgreSQL 14+
- **Migrations**: Flyway
- **Build**: Maven
- **Deployment**: Docker, Docker Compose

### Project Structure
```
CyberSkill/
├── src/
│   ├── main/
│   │   ├── java/com/cyberskill/
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── handler/         # HTTP request handlers
│   │   │   ├── model/           # Domain models
│   │   │   ├── repository/      # Database repositories
│   │   │   ├── security/        # Security utilities
│   │   │   ├── service/         # Business logic
│   │   │   ├── util/            # Utility classes
│   │   │   └── MainVerticle.java
│   │   └── resources/
│   │       ├── db/migration/    # Flyway migrations
│   │       ├── static/          # CSS, JS, images
│   │       ├── templates/       # Freemarker templates
│   │       ├── application.properties
│   │       └── logback.xml
│   └── test/                    # Unit and integration tests
├── docker-compose.yml
├── Dockerfile
├── pom.xml
└── ARCHITECTURE.md
```

## 🚀 Getting Started

### Prerequisites
- Java 17 or higher
- Maven 3.8+
- PostgreSQL 14+ (or use Docker)
- Docker & Docker Compose (optional, for containerized deployment)

### Option 1: Local Development

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/CyberSkill.git
cd CyberSkill
```

#### 2. Setup PostgreSQL Database
```bash
# Create database
createdb cyberskill

# Create user
psql -c "CREATE USER cyberskill_user WITH PASSWORD 'changeme';"
psql -c "GRANT ALL PRIVILEGES ON DATABASE cyberskill TO cyberskill_user;"
```

#### 3. Configure Application
Edit `src/main/resources/application.properties`:
```properties
database.host=localhost
database.port=5432
database.name=cyberskill
database.username=cyberskill_user
database.password=changeme
jwt.secret=YOUR_STRONG_SECRET_HERE
```

#### 4. Build and Run
```bash
# Build the project
mvn clean package

# Run the application
java -jar target/cyberskill-platform-1.0.0-fat.jar

# Or use Maven
mvn exec:java
```

#### 5. Access the Platform
- **Web Interface**: http://localhost:8080
- **API**: http://localhost:8080/api
- **Health Check**: http://localhost:8080/api/health

### Option 2: Docker Deployment

#### 1. Using Docker Compose (Recommended)
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down
```

#### 2. Build and Run Manually
```bash
# Build the image
docker build -t cyberskill-platform .

# Run PostgreSQL
docker run -d \
  --name cyberskill-db \
  -e POSTGRES_DB=cyberskill \
  -e POSTGRES_USER=cyberskill_user \
  -e POSTGRES_PASSWORD=changeme \
  -p 5432:5432 \
  postgres:14-alpine

# Run the application
docker run -d \
  --name cyberskill-app \
  -p 8080:8080 \
  -e DATABASE_HOST=cyberskill-db \
  --link cyberskill-db \
  cyberskill-platform
```

## 👤 Default Credentials

### Admin Account
- **Username**: `admin`
- **Email**: `admin@cyberskill.com`
- **Password**: `Admin@123`

### Test User Account
- **Username**: `testuser`
- **Email**: `user@cyberskill.com`
- **Password**: `User@123`

⚠️ **IMPORTANT**: Change these passwords immediately in production!

## 📚 API Documentation

### Authentication Endpoints

#### Register
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "newuser",
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

Response:
{
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": {
    "id": 1,
    "username": "newuser",
    "email": "user@example.com",
    "role": "USER"
  }
}
```

### Learning Path Endpoints

#### Get All Learning Paths
```http
GET /api/paths
Authorization: Bearer {accessToken}

Response:
[
  {
    "id": 1,
    "name": "Penetration Testing",
    "slug": "penetration-testing",
    "description": "Master ethical hacking...",
    "estimatedHours": 40
  }
]
```

#### Get Path Details
```http
GET /api/paths/{id}
Authorization: Bearer {accessToken}
```

### User Progress Endpoints

#### Get User Progress
```http
GET /api/user/progress
Authorization: Bearer {accessToken}

Response:
{
  "totalLessons": 120,
  "completedLessons": 45,
  "completionPercentage": 37.5,
  "badges": 5,
  "certificates": 1
}
```

## 🔧 Configuration

### Environment Variables
```bash
# Server
SERVER_PORT=8080
SERVER_HOST=0.0.0.0

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=cyberskill
DATABASE_USERNAME=cyberskill_user
DATABASE_PASSWORD=changeme

# Security
JWT_SECRET=your-secret-key-here
JWT_EXPIRY_ACCESS=3600
JWT_EXPIRY_REFRESH=604800

# Features
MFA_ENABLED=true
RATE_LIMIT_ENABLED=true
ANALYTICS_ENABLED=true
```

## 🧪 Testing

```bash
# Run all tests
mvn test

# Run specific test
mvn test -Dtest=UserServiceTest

# Run with coverage
mvn clean test jacoco:report
```

## 📊 Database Schema

See [ARCHITECTURE.md](ARCHITECTURE.md) for complete database schema documentation.

Key tables:
- `users` - User accounts and authentication
- `learning_paths` - Learning path definitions
- `modules` - Modules within paths
- `sections` - Sections within modules
- `lessons` - Individual lessons
- `quizzes` - Assessments
- `user_progress` - Learning progress tracking
- `badges` - Achievement definitions
- `certificates` - Completion certificates

## 🔒 Security Best Practices

1. **Change Default Passwords** - Update admin and test user passwords
2. **Use Strong JWT Secret** - Generate a strong random secret for production
3. **Enable HTTPS** - Use SSL/TLS in production
4. **Regular Updates** - Keep dependencies up to date
5. **Backup Database** - Regular automated backups
6. **Monitor Logs** - Review audit logs regularly
7. **Rate Limiting** - Enable rate limiting in production
8. **Input Validation** - All user inputs are validated

## 📈 Monitoring

### Logs
```bash
# Application logs
tail -f logs/cyberskill.log

# Error logs
tail -f logs/cyberskill-error.log

# Audit logs
tail -f logs/cyberskill-audit.log
```

### Health Check
```bash
curl http://localhost:8080/api/health
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For issues, questions, or contributions:
- **Issues**: https://github.com/yourusername/CyberSkill/issues
- **Documentation**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Email**: support@cyberskill.com

## 🗺️ Roadmap

- [ ] Real-time collaboration features
- [ ] Discussion forums
- [ ] Peer review system
- [ ] Advanced gamification
- [ ] Mobile application
- [ ] Third-party integrations
- [ ] AI-powered recommendations
- [ ] Live virtual labs
- [ ] Video conferencing integration
- [ ] Advanced analytics with ML

## 📸 Screenshots

### Home Page
![Home Page](docs/screenshots/home.png)

### Dashboard
![Dashboard](docs/screenshots/dashboard.png)

### Learning Path
![Learning Path](docs/screenshots/learning-path.png)

### Admin Dashboard
![Admin Dashboard](docs/screenshots/admin.png)

---

Built with ❤️ for the cybersecurity community