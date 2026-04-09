# CyberSkill Learning Platform - System Architecture

## Overview
Enterprise-grade cybersecurity learning platform built with Java Vert.x, Freemarker templates, PostgreSQL, and modern web technologies.

## Technology Stack

### Backend
- **Framework**: Vert.x 4.x (Reactive, non-blocking)
- **Language**: Java 17+
- **Database**: PostgreSQL 14+
- **Template Engine**: Freemarker
- **Authentication**: JWT + OAuth 2.0 / OpenID Connect
- **API**: RESTful JSON APIs
- **Logging**: SLF4J + Logback
- **Build Tool**: Maven

### Frontend
- **Templates**: Freemarker (.ftl)
- **Styling**: CSS3 (IBM Plex fonts)
- **JavaScript**: Vanilla JS + Modern ES6+
- **UI Components**: Custom components
- **Charts**: Chart.js for analytics

### Infrastructure
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **Database Migrations**: Flyway
- **Reverse Proxy**: Nginx (optional)

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Load Balancer                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Vert.x HTTP Server                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Router     │  │  Auth Filter │  │ CORS Handler │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   API Layer  │    │  Web Layer   │    │ Static Files │
│   (REST)     │    │ (Freemarker) │    │   (Assets)   │
└──────────────┘    └──────────────┘    └──────────────┘
        │                     │
        └─────────────────────┘
                    ▼
┌─────────────────────────────────────────────────────────────┐
│                      Service Layer                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │   User   │ │ Learning │ │  Quiz    │ │  Badge   │      │
│  │ Service  │ │ Service  │ │ Service  │ │ Service  │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │Progress  │ │  Admin   │ │Analytics │ │  Cert    │      │
│  │ Service  │ │ Service  │ │ Service  │ │ Service  │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Repository Layer                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │   User   │ │ Learning │ │  Quiz    │ │  Badge   │      │
│  │   Repo   │ │   Repo   │ │   Repo   │ │   Repo   │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    PostgreSQL Database                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │  Users   │ │ Paths    │ │ Modules  │ │ Sections │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │ Lessons  │ │ Quizzes  │ │ Progress │ │  Badges  │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
└─────────────────────────────────────────────────────────────┘
```

## Database Schema

### Core Tables

#### users
- id (SERIAL PRIMARY KEY)
- username (VARCHAR UNIQUE)
- email (VARCHAR UNIQUE)
- password_hash (VARCHAR)
- role (VARCHAR) - 'USER' or 'ADMIN'
- mfa_enabled (BOOLEAN)
- mfa_secret (VARCHAR)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
- last_login (TIMESTAMP)

#### learning_paths
- id (SERIAL PRIMARY KEY)
- name (VARCHAR)
- slug (VARCHAR UNIQUE)
- description (TEXT)
- icon (VARCHAR)
- order_index (INTEGER)
- is_active (BOOLEAN)
- created_at (TIMESTAMP)

#### modules
- id (SERIAL PRIMARY KEY)
- learning_path_id (INTEGER FK)
- name (VARCHAR)
- description (TEXT)
- order_index (INTEGER)
- estimated_hours (INTEGER)
- created_at (TIMESTAMP)

#### sections
- id (SERIAL PRIMARY KEY)
- module_id (INTEGER FK)
- name (VARCHAR)
- description (TEXT)
- order_index (INTEGER)
- created_at (TIMESTAMP)

#### lessons
- id (SERIAL PRIMARY KEY)
- section_id (INTEGER FK)
- name (VARCHAR)
- content (TEXT)
- content_type (VARCHAR) - 'text', 'video', 'interactive'
- video_url (VARCHAR)
- order_index (INTEGER)
- estimated_minutes (INTEGER)
- created_at (TIMESTAMP)

#### quizzes
- id (SERIAL PRIMARY KEY)
- section_id (INTEGER FK)
- name (VARCHAR)
- description (TEXT)
- passing_score (INTEGER)
- time_limit_minutes (INTEGER)
- created_at (TIMESTAMP)

#### quiz_questions
- id (SERIAL PRIMARY KEY)
- quiz_id (INTEGER FK)
- question_text (TEXT)
- question_type (VARCHAR) - 'multiple_choice', 'true_false', 'multi_select'
- order_index (INTEGER)
- points (INTEGER)

#### quiz_options
- id (SERIAL PRIMARY KEY)
- question_id (INTEGER FK)
- option_text (TEXT)
- is_correct (BOOLEAN)
- order_index (INTEGER)

#### user_progress
- id (SERIAL PRIMARY KEY)
- user_id (INTEGER FK)
- lesson_id (INTEGER FK)
- status (VARCHAR) - 'not_started', 'in_progress', 'completed'
- started_at (TIMESTAMP)
- completed_at (TIMESTAMP)
- time_spent_seconds (INTEGER)

#### quiz_attempts
- id (SERIAL PRIMARY KEY)
- user_id (INTEGER FK)
- quiz_id (INTEGER FK)
- score (INTEGER)
- max_score (INTEGER)
- passed (BOOLEAN)
- started_at (TIMESTAMP)
- completed_at (TIMESTAMP)
- answers (JSONB)

#### badges
- id (SERIAL PRIMARY KEY)
- name (VARCHAR)
- description (TEXT)
- icon (VARCHAR)
- badge_type (VARCHAR) - 'section', 'module', 'path'
- criteria (JSONB)
- created_at (TIMESTAMP)

#### user_badges
- id (SERIAL PRIMARY KEY)
- user_id (INTEGER FK)
- badge_id (INTEGER FK)
- earned_at (TIMESTAMP)

#### certificates
- id (SERIAL PRIMARY KEY)
- user_id (INTEGER FK)
- learning_path_id (INTEGER FK)
- certificate_id (VARCHAR UNIQUE)
- issued_at (TIMESTAMP)
- pdf_path (VARCHAR)

#### admin_logs
- id (SERIAL PRIMARY KEY)
- admin_id (INTEGER FK)
- action (VARCHAR)
- entity_type (VARCHAR)
- entity_id (INTEGER)
- details (JSONB)
- ip_address (VARCHAR)
- created_at (TIMESTAMP)

## API Endpoints

### Authentication
- POST /api/auth/register
- POST /api/auth/login
- POST /api/auth/logout
- POST /api/auth/refresh
- POST /api/auth/mfa/enable
- POST /api/auth/mfa/verify

### User
- GET /api/user/profile
- PUT /api/user/profile
- GET /api/user/progress
- GET /api/user/badges
- GET /api/user/certificates

### Learning Paths
- GET /api/paths
- GET /api/paths/:id
- GET /api/paths/:id/modules

### Modules
- GET /api/modules/:id
- GET /api/modules/:id/sections

### Sections
- GET /api/sections/:id
- GET /api/sections/:id/lessons

### Lessons
- GET /api/lessons/:id
- POST /api/lessons/:id/complete
- POST /api/lessons/:id/progress

### Quizzes
- GET /api/quizzes/:id
- POST /api/quizzes/:id/start
- POST /api/quizzes/:id/submit
- GET /api/quizzes/:id/results

### Admin
- GET /api/admin/users
- POST /api/admin/users
- PUT /api/admin/users/:id
- DELETE /api/admin/users/:id
- GET /api/admin/users/:id/progress
- GET /api/admin/analytics/overview
- GET /api/admin/analytics/engagement
- POST /api/admin/content/paths
- PUT /api/admin/content/paths/:id
- POST /api/admin/content/modules
- POST /api/admin/content/sections
- POST /api/admin/content/lessons
- POST /api/admin/content/quizzes

## Security Features

### Authentication
- JWT-based authentication
- Refresh token rotation
- Password hashing with BCrypt
- Optional MFA (TOTP)
- Session management

### Authorization
- Role-based access control (RBAC)
- Route-level authorization
- Resource-level permissions

### Security Headers
- CORS configuration
- CSP (Content Security Policy)
- X-Frame-Options
- X-Content-Type-Options
- HSTS

### Data Protection
- SQL injection prevention (parameterized queries)
- XSS protection (output encoding)
- CSRF protection
- Rate limiting
- Input validation

## Deployment

### Docker Compose
```yaml
services:
  app:
    - Vert.x application
    - Port 8080
  db:
    - PostgreSQL 14
    - Port 5432
  nginx:
    - Reverse proxy
    - Port 80/443
```

### Environment Variables
- DATABASE_URL
- JWT_SECRET
- JWT_EXPIRY
- ADMIN_EMAIL
- SMTP_CONFIG
- LOG_LEVEL

## Monitoring & Logging

### Logging
- Application logs (Logback)
- Access logs
- Error logs
- Audit logs (admin actions)

### Metrics
- Request count
- Response times
- Error rates
- User engagement
- Quiz completion rates

## Learning Domains

### 1. Penetration Testing
- Network scanning
- Vulnerability assessment
- Exploitation techniques
- Post-exploitation
- Reporting

### 2. Compliance
- GDPR
- ISO 27001
- SOC 2
- PCI DSS
- HIPAA

### 3. Data Security
- Encryption
- Data classification
- Access controls
- DLP strategies
- Secure storage

### 4. Post-Quantum Computing
- Quantum threats
- PQC algorithms
- Migration strategies
- Hybrid approaches
- Standards (NIST)

## Future Enhancements
- Real-time collaboration
- Discussion forums
- Peer review system
- Gamification elements
- Mobile app
- API for third-party integrations
- Advanced analytics with ML
- Content recommendation engine