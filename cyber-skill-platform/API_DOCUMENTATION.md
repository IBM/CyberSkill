# CyberSkill Platform - API Documentation

## Base URL
```
http://localhost:8080/api
```

## Authentication
Most endpoints require JWT authentication. Include the access token in the Authorization header:
```
Authorization: Bearer <access_token>
```

---

## Table of Contents
1. [Authentication](#authentication-endpoints)
2. [Learning Paths](#learning-path-endpoints)
3. [Modules](#module-endpoints)
4. [Sections](#section-endpoints)
5. [Lessons](#lesson-endpoints)
6. [Quizzes](#quiz-endpoints)
7. [Progress Tracking](#progress-tracking-endpoints)
8. [Badges](#badge-endpoints)
9. [Certificates](#certificate-endpoints)
10. [Analytics](#analytics-endpoints-admin)
11. [User Management](#user-management-admin)

---

## Authentication Endpoints

### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "string",
  "email": "string",
  "password": "string"
}
```

**Response (201 Created):**
```json
{
  "message": "User registered successfully",
  "userId": "uuid"
}
```

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "string",
  "password": "string"
}
```

**Response (200 OK):**
```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "expiresIn": 3600,
  "user": {
    "id": "uuid",
    "username": "string",
    "email": "string",
    "role": "USER|ADMIN"
  }
}
```

### Refresh Token
```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "string"
}
```

**Response (200 OK):**
```json
{
  "accessToken": "string",
  "expiresIn": 3600
}
```

### Logout
```http
POST /api/auth/logout
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "message": "Logged out successfully"
}
```

### Change Password
```http
POST /api/auth/change-password
Authorization: Bearer <token>
Content-Type: application/json

{
  "currentPassword": "string",
  "newPassword": "string"
}
```

---

## Learning Path Endpoints

### Get All Learning Paths
```http
GET /api/paths
```

**Response (200 OK):**
```json
{
  "paths": [
    {
      "id": "uuid",
      "name": "string",
      "slug": "string",
      "description": "string",
      "difficulty": "BEGINNER|INTERMEDIATE|ADVANCED",
      "estimatedDuration": 0,
      "createdAt": "timestamp"
    }
  ]
}
```

### Get Learning Path by ID
```http
GET /api/paths/:id
```

### Get Learning Path by Slug
```http
GET /api/paths/slug/:slug
```

### Create Learning Path (Admin)
```http
POST /api/admin/paths
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "string",
  "slug": "string",
  "description": "string",
  "difficulty": "BEGINNER|INTERMEDIATE|ADVANCED",
  "estimatedDuration": 0
}
```

### Update Learning Path (Admin)
```http
PUT /api/admin/paths/:id
Authorization: Bearer <admin_token>
```

### Delete Learning Path (Admin)
```http
DELETE /api/admin/paths/:id
Authorization: Bearer <admin_token>
```

---

## Module Endpoints

### Get Modules by Path
```http
GET /api/paths/:pathId/modules
```

**Response (200 OK):**
```json
{
  "modules": [
    {
      "id": "uuid",
      "pathId": "uuid",
      "name": "string",
      "description": "string",
      "orderIndex": 0,
      "estimatedDuration": 0
    }
  ]
}
```

### Get Module by ID
```http
GET /api/modules/:id
```

### Create Module (Admin)
```http
POST /api/admin/modules
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "pathId": "uuid",
  "name": "string",
  "description": "string",
  "orderIndex": 0,
  "estimatedDuration": 0
}
```

### Update Module (Admin)
```http
PUT /api/admin/modules/:id
Authorization: Bearer <admin_token>
```

### Delete Module (Admin)
```http
DELETE /api/admin/modules/:id
Authorization: Bearer <admin_token>
```

---

## Section Endpoints

### Get Sections by Module
```http
GET /api/modules/:moduleId/sections
```

### Get Section by ID
```http
GET /api/sections/:id
```

### Create Section (Admin)
```http
POST /api/admin/sections
Authorization: Bearer <admin_token>
```

### Update Section (Admin)
```http
PUT /api/admin/sections/:id
Authorization: Bearer <admin_token>
```

### Delete Section (Admin)
```http
DELETE /api/admin/sections/:id
Authorization: Bearer <admin_token>
```

---

## Lesson Endpoints

### Get Lessons by Section
```http
GET /api/sections/:sectionId/lessons
```

**Response (200 OK):**
```json
{
  "lessons": [
    {
      "id": "uuid",
      "sectionId": "uuid",
      "title": "string",
      "content": "string",
      "lessonType": "VIDEO|TEXT|INTERACTIVE|LAB",
      "orderIndex": 0,
      "duration": 0,
      "videoUrl": "string"
    }
  ]
}
```

### Get Lesson by ID
```http
GET /api/lessons/:id
```

### Create Lesson (Admin)
```http
POST /api/admin/lessons
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "sectionId": "uuid",
  "title": "string",
  "content": "string",
  "lessonType": "VIDEO|TEXT|INTERACTIVE|LAB",
  "orderIndex": 0,
  "duration": 0,
  "videoUrl": "string"
}
```

---

## Quiz Endpoints

### Get Quizzes by Section
```http
GET /api/sections/:sectionId/quizzes
```

### Get Quiz Metadata
```http
GET /api/quizzes/:id
```

### Get Quiz for Taking
```http
GET /api/quizzes/:id/full
```

**Response (200 OK):**
```json
{
  "quiz": {
    "id": "uuid",
    "title": "string",
    "description": "string",
    "timeLimit": 0,
    "passingScore": 0,
    "questions": [
      {
        "id": "uuid",
        "questionText": "string",
        "questionType": "MULTIPLE_CHOICE|TRUE_FALSE|SHORT_ANSWER",
        "points": 0,
        "answers": [
          {
            "id": "uuid",
            "answerText": "string"
          }
        ]
      }
    ]
  }
}
```

### Start Quiz Attempt
```http
POST /api/quizzes/:id/start
Authorization: Bearer <token>
```

**Response (201 Created):**
```json
{
  "attemptId": "uuid",
  "startedAt": "timestamp",
  "expiresAt": "timestamp"
}
```

### Submit Answer
```http
POST /api/attempts/:attemptId/answers
Authorization: Bearer <token>
Content-Type: application/json

{
  "questionId": "uuid",
  "answerId": "uuid",
  "answerText": "string"
}
```

### Complete Quiz Attempt
```http
POST /api/attempts/:attemptId/complete
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "score": 85.5,
  "passed": true,
  "totalQuestions": 10,
  "correctAnswers": 9,
  "completedAt": "timestamp"
}
```

### Get Attempt Details
```http
GET /api/attempts/:attemptId
Authorization: Bearer <token>
```

### Get User Quiz History
```http
GET /api/quizzes/:id/history
Authorization: Bearer <token>
```

---

## Progress Tracking Endpoints

### Start Lesson
```http
POST /api/progress/lessons/:lessonId/start
Authorization: Bearer <token>
```

### Complete Lesson
```http
POST /api/progress/lessons/:lessonId/complete
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "message": "Lesson completed",
  "badgesEarned": ["uuid"],
  "certificateEarned": "uuid"
}
```

### Update Time Spent
```http
POST /api/progress/lessons/:lessonId/time
Authorization: Bearer <token>
Content-Type: application/json

{
  "timeSpent": 300
}
```

### Get Lesson Progress
```http
GET /api/progress/lessons/:lessonId
Authorization: Bearer <token>
```

### Get User Progress
```http
GET /api/progress
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "progress": [
    {
      "lessonId": "uuid",
      "completed": true,
      "timeSpent": 1200,
      "lastAccessed": "timestamp"
    }
  ]
}
```

### Get Section Progress
```http
GET /api/progress/sections/:sectionId
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "sectionId": "uuid",
  "totalLessons": 10,
  "completedLessons": 7,
  "completionPercentage": 70.0
}
```

### Get Module Progress
```http
GET /api/progress/modules/:moduleId
Authorization: Bearer <token>
```

### Get Path Progress
```http
GET /api/progress/paths/:pathId
Authorization: Bearer <token>
```

### Get User Statistics
```http
GET /api/progress/statistics
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "totalLessonsCompleted": 45,
  "totalTimeSpent": 54000,
  "currentStreak": 7,
  "longestStreak": 14,
  "averageCompletionRate": 75.5
}
```

---

## Badge Endpoints

### Get All Badges
```http
GET /api/badges
```

**Response (200 OK):**
```json
{
  "badges": [
    {
      "id": "uuid",
      "name": "string",
      "description": "string",
      "type": "SECTION_COMPLETION|MODULE_COMPLETION|PATH_COMPLETION",
      "iconUrl": "string",
      "criteria": "string"
    }
  ]
}
```

### Get Badge by ID
```http
GET /api/badges/:id
```

### Get User Badges
```http
GET /api/user/badges
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "badges": [
    {
      "badgeId": "uuid",
      "badgeName": "string",
      "badgeType": "string",
      "earnedAt": "timestamp"
    }
  ]
}
```

### Get User Badge Count
```http
GET /api/user/badges/count
Authorization: Bearer <token>
```

### Create Badge (Admin)
```http
POST /api/admin/badges
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "string",
  "description": "string",
  "type": "SECTION_COMPLETION",
  "iconUrl": "string",
  "criteria": "string"
}
```

### Award Badge to User (Admin)
```http
POST /api/admin/badges/:badgeId/award/:userId
Authorization: Bearer <admin_token>
```

### Revoke Badge from User (Admin)
```http
DELETE /api/admin/badges/:badgeId/revoke/:userId
Authorization: Bearer <admin_token>
```

### Get Badge Statistics (Admin)
```http
GET /api/admin/badges/statistics
Authorization: Bearer <admin_token>
```

---

## Certificate Endpoints

### Verify Certificate
```http
GET /api/certificates/verify/:certificateNumber
```

**Response (200 OK):**
```json
{
  "valid": true,
  "certificate": {
    "certificateNumber": "string",
    "userName": "string",
    "pathName": "string",
    "issuedAt": "timestamp",
    "pdfUrl": "string"
  }
}
```

### Get Certificate by ID
```http
GET /api/certificates/:id
```

### Get User Certificates
```http
GET /api/user/certificates
Authorization: Bearer <token>
```

**Response (200 OK):**
```json
{
  "certificates": [
    {
      "id": "uuid",
      "certificateNumber": "string",
      "pathName": "string",
      "issuedAt": "timestamp",
      "pdfUrl": "string",
      "isValid": true
    }
  ]
}
```

### Get User Certificate Count
```http
GET /api/user/certificates/count
Authorization: Bearer <token>
```

### Generate Certificate
```http
POST /api/certificates/generate
Authorization: Bearer <token>
Content-Type: application/json

{
  "pathId": "uuid",
  "userName": "string",
  "pathName": "string"
}
```

**Response (201 Created):**
```json
{
  "id": "uuid",
  "certificateNumber": "CERT-2026-12345678",
  "pdfUrl": "/certificates/CERT-2026-12345678.pdf",
  "issuedAt": "timestamp"
}
```

### Get Path Certificates (Admin)
```http
GET /api/admin/certificates/path/:pathId
Authorization: Bearer <admin_token>
```

### Revoke Certificate (Admin)
```http
POST /api/admin/certificates/revoke/:id
Authorization: Bearer <admin_token>
```

### Regenerate Certificate PDF (Admin)
```http
POST /api/admin/certificates/regenerate/:id
Authorization: Bearer <admin_token>
```

### Delete Certificate (Admin)
```http
DELETE /api/admin/certificates/:id
Authorization: Bearer <admin_token>
```

### Get Certificate Statistics (Admin)
```http
GET /api/admin/certificates/statistics
Authorization: Bearer <admin_token>
```

---

## Analytics Endpoints (Admin)

### Get Platform Overview
```http
GET /api/admin/analytics/overview
Authorization: Bearer <admin_token>
```

**Response (200 OK):**
```json
{
  "totalUsers": 1250,
  "activeUsers": 450,
  "totalCertificates": 320,
  "totalBadges": 1580,
  "totalQuizAttempts": 5420,
  "averageCompletionRate": 68.5,
  "timestamp": 1234567890
}
```

### Get User Engagement Metrics
```http
GET /api/admin/analytics/engagement
Authorization: Bearer <admin_token>
```

**Response (200 OK):**
```json
{
  "activeUsers": 450,
  "totalUsers": 1250,
  "engagementRate": "36.00%",
  "averageLessonsPerUser": "12.5",
  "averageTimeSpentPerUser": "8.3 hours",
  "timestamp": 1234567890
}
```

### Get Learning Path Statistics
```http
GET /api/admin/analytics/paths
Authorization: Bearer <admin_token>
```

### Get Quiz Performance Analytics
```http
GET /api/admin/analytics/quizzes
Authorization: Bearer <admin_token>
```

**Response (200 OK):**
```json
{
  "totalAttempts": 5420,
  "averageScore": "78.5%",
  "passRate": "82.3%",
  "timestamp": 1234567890
}
```

### Get Certificate Trends
```http
GET /api/admin/analytics/certificates
Authorization: Bearer <admin_token>
```

### Get Badge Statistics
```http
GET /api/admin/analytics/badges
Authorization: Bearer <admin_token>
```

---

## User Management (Admin)

### Get All Users
```http
GET /api/admin/users
Authorization: Bearer <admin_token>
```

**Response (200 OK):**
```json
{
  "users": [
    {
      "id": "uuid",
      "username": "string",
      "email": "string",
      "role": "USER|ADMIN",
      "createdAt": "timestamp"
    }
  ]
}
```

---

## Error Responses

All endpoints may return the following error responses:

### 400 Bad Request
```json
{
  "error": "Invalid request data"
}
```

### 401 Unauthorized
```json
{
  "error": "Authentication required"
}
```

### 403 Forbidden
```json
{
  "error": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error"
}
```

---

## Rate Limiting

Currently, no rate limiting is implemented. In production, consider implementing rate limiting to prevent abuse.

---

## Pagination

For endpoints that return lists, pagination can be implemented using query parameters:
```
?page=1&limit=20
```

---

## Filtering and Sorting

Some endpoints support filtering and sorting via query parameters:
```
?sort=createdAt&order=desc&filter=completed
```

---

## WebSocket Support

Future versions may include WebSocket support for real-time updates on:
- Quiz progress
- Badge awards
- Certificate generation
- Learning progress

---

## API Versioning

Current API version: v1

Future versions will be accessible via:
```
/api/v2/...
```

---

## Support

For API support, please contact: support@cyberskill.com

---

**Last Updated**: March 12, 2026  
**API Version**: 1.0.0