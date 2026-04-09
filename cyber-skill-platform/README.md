# 🛡️ CyberSkill Learning Platform

Enterprise-grade cybersecurity learning and upskilling platform built with Java Vert.x, Freemarker, and PostgreSQL.

## 🚀 Quick Start

```bash
# Start with Docker (Recommended)
docker-compose up -d

# Access the platform
open http://localhost:8080

# Login with default credentials
# Admin: admin@cyberskill.com / Admin@123
# User: user@cyberskill.com / User@123
```

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - Get started in 5 minutes
- **[README_PLATFORM.md](README_PLATFORM.md)** - Complete user guide
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture

## 🎯 Features

### For Learners
- 📚 4 structured learning paths (Penetration Testing, Compliance, Data Security, Post-Quantum Computing)
- 📊 Progress tracking with visual dashboards
- ✅ Auto-graded quizzes and assessments
- 🏆 Badges and certificates
- 📱 Responsive design

### For Administrators
- 👥 User management (CRUD operations)
- 📝 Content management system
- 📈 Analytics and reporting
- 🔍 Audit logging
- 🎯 Role-based access control

### Security
- 🔐 JWT authentication
- 🔑 BCrypt password hashing
- 🛡️ RBAC (USER/ADMIN roles)
- 🔒 Optional MFA support
- 📝 Comprehensive audit trails

## 🏗️ Technology Stack

- **Backend**: Java 17, Vert.x 4.5, Freemarker
- **Database**: PostgreSQL 14+, Flyway migrations
- **Security**: JWT, BCrypt, RBAC
- **Build**: Maven
- **Deployment**: Docker, Docker Compose

## 📦 Project Structure

```
cyber-skill-platform/
├── src/
│   ├── main/
│   │   ├── java/com/cyberskill/
│   │   │   ├── config/          # Configuration
│   │   │   ├── handler/         # HTTP handlers
│   │   │   ├── model/           # Domain models
│   │   │   ├── repository/      # Data access
│   │   │   ├── security/        # Security utilities
│   │   │   ├── service/         # Business logic
│   │   │   └── MainVerticle.java
│   │   └── resources/
│   │       ├── db/migration/    # Database migrations
│   │       ├── static/          # CSS, JS, images
│   │       ├── templates/       # Freemarker templates
│   │       └── application.properties
│   └── test/                    # Tests
├── docker-compose.yml           # Docker orchestration
├── Dockerfile                   # Container image
├── pom.xml                      # Maven configuration
├── ARCHITECTURE.md              # Technical docs
├── README_PLATFORM.md           # Complete guide
└── QUICKSTART.md               # Quick start guide
```

## 🎓 Learning Paths

1. **Penetration Testing** (40 hours)
   - Network scanning and reconnaissance
   - Vulnerability assessment
   - Exploitation techniques
   - Post-exploitation and reporting

2. **Compliance** (35 hours)
   - GDPR and data protection
   - ISO 27001 information security
   - SOC 2 and trust services
   - Industry-specific compliance (PCI DSS, HIPAA)

3. **Data Security** (30 hours)
   - Data classification and lifecycle
   - Encryption and cryptography
   - Access control and authentication
   - Data loss prevention

4. **Post-Quantum Computing** (25 hours)
   - Quantum computing fundamentals
   - Quantum threats to cryptography
   - Post-quantum cryptographic algorithms
   - Migration strategies

## 🔧 Installation

### Prerequisites
- Java 17+
- Maven 3.8+
- PostgreSQL 14+ (or use Docker)
- Docker & Docker Compose (optional)

### Option 1: Docker (Recommended)
```bash
docker-compose up -d
```

### Option 2: Local Development
```bash
# Setup database
createdb cyberskill
psql -c "CREATE USER cyberskill_user WITH PASSWORD 'changeme';"

# Build and run
mvn clean package
java -jar target/cyberskill-platform-1.0.0-fat.jar
```

## 🔐 Security

**⚠️ IMPORTANT**: Change default passwords before production deployment!

Default credentials:
- Admin: `admin@cyberskill.com` / `Admin@123`
- User: `user@cyberskill.com` / `User@123`

Update JWT secret in `application.properties`:
```properties
jwt.secret=YOUR_STRONG_RANDOM_SECRET_HERE
```

## 📊 Database Schema

The platform includes a comprehensive database schema with:
- User authentication and authorization
- Learning content hierarchy (paths → modules → sections → lessons)
- Quiz and assessment system
- Progress tracking
- Badges and certificates
- Admin audit logs
- Analytics tables

See [ARCHITECTURE.md](ARCHITECTURE.md) for complete schema documentation.

## 🧪 Testing

```bash
# Run all tests
mvn test

# Run with coverage
mvn clean test jacoco:report
```

## 📈 Monitoring

### Health Check
```bash
curl http://localhost:8080/api/health
```

### Logs
```bash
# Application logs
tail -f logs/cyberskill.log

# Docker logs
docker-compose logs -f app
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 🆘 Support

- **Documentation**: See [README_PLATFORM.md](README_PLATFORM.md)
- **Quick Start**: See [QUICKSTART.md](QUICKSTART.md)
- **Architecture**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Issues**: GitHub Issues
- **Email**: support@cyberskill.com

## 🗺️ Roadmap

- [ ] Real-time collaboration
- [ ] Discussion forums
- [ ] Peer review system
- [ ] Advanced gamification
- [ ] Mobile application
- [ ] Third-party integrations
- [ ] AI-powered recommendations
- [ ] Live virtual labs

---

Built with ❤️ for the cybersecurity community

**Version**: 1.0.0  
**Last Updated**: March 2026