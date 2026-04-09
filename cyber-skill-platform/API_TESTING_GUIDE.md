# CyberSkill Platform - API Testing Guide

Complete guide for testing all API endpoints with example requests and responses.

## 📋 Table of Contents

1. [Setup](#setup)
2. [Authentication Endpoints](#authentication-endpoints)
3. [Learning Path Endpoints](#learning-path-endpoints)
4. [User Endpoints](#user-endpoints)
5. [Admin Endpoints](#admin-endpoints)
6. [Testing Tools](#testing-tools)

## 🔧 Setup

### Base URL
```
http://localhost:8080
```

### Headers
```
Content-Type: application/json
Authorization: Bearer <access_token>
```

### Default Test Accounts

**Admin Account:**
- Email: `admin@cyberskill.com`
- Password: `Admin@123`

**User Account:**
- Email: `user@cyberskill.com`
- Password: `User@123`

## 🔐 Authentication Endpoints

### 1. Register New User

**Endpoint:** `POST /api/auth/register`

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "johndoe",
    "email": "john@example.com",
    "password": "SecurePass123!"
  }'
```

**Response (201 Created):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 3,
    "username": "johndoe",
    "email": "john@example.com",
    "role": "USER",
    "mfaEnabled": false
  }
}
```

**Error Response (400 Bad Request):**
```json
{
  "error": "Email already registered"
}
```

### 2. Login

**Endpoint:** `POST /api/auth/login`

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@cyberskill.com",
    "password": "Admin@123"
  }'
```

**Response (200 OK):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@cyberskill.com",
    "role": "ADMIN",
    "mfaEnabled": false
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "error": "Invalid email or password"
}
```

### 3. Refresh Token

**Endpoint:** `POST /api/auth/refresh`

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

**Response (200 OK):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "username": "admin",
    "email": "admin@cyberskill.com",
    "role": "ADMIN",
    "mfaEnabled": false
  }
}
```

### 4. Change Password

**Endpoint:** `POST /api/auth/change-password`

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/change-password \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <access_token>" \
  -d '{
    "currentPassword": "Admin@123",
    "newPassword": "NewSecure@456"
  }'
```

**Response (200 OK):**
```json
{
  "message": "Password changed successfully"
}
```

### 5. Logout

**Endpoint:** `POST /api/auth/logout`

**Request:**
```bash
curl -X POST http://localhost:8080/api/auth/logout \
  -H "Authorization: Bearer <access_token>"
```

**Response (200 OK):**
```json
{
  "message": "Logged out successfully"
}
```

## 📚 Learning Path Endpoints

### 1. Get All Learning Paths

**Endpoint:** `GET /api/paths`

**Request:**
```bash
curl http://localhost:8080/api/paths
```

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "name": "Penetration Testing",
    "slug": "penetration-testing",
    "description": "Master the art of ethical hacking...",
    "icon": "shield-check",
    "orderIndex": 1,
    "isActive": true,
    "estimatedHours": 40,
    "createdAt": "2026-03-11T10:00:00",
    "updatedAt": "2026-03-11T10:00:00"
  },
  {
    "id": 2,
    "name": "Compliance",
    "slug": "compliance",
    "description": "Navigate the complex world...",
    "icon": "clipboard-check",
    "orderIndex": 2,
    "isActive": true,
    "estimatedHours": 35,
    "createdAt": "2026-03-11T10:00:00",
    "updatedAt": "2026-03-11T10:00:00"
  }
]
```

### 2. Get Learning Path by ID

**Endpoint:** `GET /api/paths/:id`

**Request:**
```bash
curl http://localhost:8080/api/paths/1
```

**Response (200 OK):**
```json
{
  "id": 1,
  "name": "Penetration Testing",
  "slug": "penetration-testing",
  "description": "Master the art of ethical hacking and penetration testing...",
  "icon": "shield-check",
  "orderIndex": 1,
  "isActive": true,
  "estimatedHours": 40,
  "createdAt": "2026-03-11T10:00:00",
  "updatedAt": "2026-03-11T10:00:00"
}
```

**Error Response (404 Not Found):**
```json
{
  "error": "Learning path not found"
}
```

### 3. Get Learning Path by Slug

**Endpoint:** `GET /api/paths/slug/:slug`

**Request:**
```bash
curl http://localhost:8080/api/paths/slug/penetration-testing
```

**Response:** Same as Get by ID

## 👤 User Endpoints (Protected)

### 1. Get User Profile

**Endpoint:** `GET /api/user/profile`

**Request:**
```bash
curl http://localhost:8080/api/user/profile \
  -H "Authorization: Bearer <access_token>"
```

**Response (200 OK):**
```json
{
  "userId": 1,
  "message": "Profile endpoint"
}
```

### 2. Get User Progress

**Endpoint:** `GET /api/user/progress`

**Request:**
```bash
curl http://localhost:8080/api/user/progress \
  -H "Authorization: Bearer <access_token>"
```

**Response (200 OK):**
```json
{
  "message": "Progress endpoint - to be implemented"
}
```

### 3. Get User Badges

**Endpoint:** `GET /api/user/badges`

**Request:**
```bash
curl http://localhost:8080/api/user/badges \
  -H "Authorization: Bearer <access_token>"
```

**Response (200 OK):**
```json
{
  "message": "Badges endpoint - to be implemented"
}
```

### 4. Get User Certificates

**Endpoint:** `GET /api/user/certificates`

**Request:**
```bash
curl http://localhost:8080/api/user/certificates \
  -H "Authorization: Bearer <access_token>"
```

**Response (200 OK):**
```json
{
  "message": "Certificates endpoint - to be implemented"
}
```

## 🔧 Admin Endpoints (Protected - Admin Only)

### 1. Create Learning Path

**Endpoint:** `POST /api/admin/paths`

**Request:**
```bash
curl -X POST http://localhost:8080/api/admin/paths \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin_access_token>" \
  -d '{
    "name": "Cloud Security",
    "slug": "cloud-security",
    "description": "Master cloud security across AWS, Azure, and GCP",
    "icon": "cloud",
    "orderIndex": 5,
    "isActive": true,
    "estimatedHours": 30
  }'
```

**Response (201 Created):**
```json
{
  "id": 5,
  "name": "Cloud Security",
  "slug": "cloud-security",
  "description": "Master cloud security across AWS, Azure, and GCP",
  "icon": "cloud",
  "orderIndex": 5,
  "isActive": true,
  "estimatedHours": 30,
  "createdAt": "2026-03-11T18:00:00",
  "updatedAt": "2026-03-11T18:00:00"
}
```

**Error Response (403 Forbidden):**
```json
{
  "error": "Forbidden",
  "message": "Admin access required"
}
```

### 2. Update Learning Path

**Endpoint:** `PUT /api/admin/paths/:id`

**Request:**
```bash
curl -X PUT http://localhost:8080/api/admin/paths/5 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin_access_token>" \
  -d '{
    "name": "Cloud Security Advanced",
    "estimatedHours": 35
  }'
```

**Response (200 OK):**
```json
{
  "id": 5,
  "name": "Cloud Security Advanced",
  "slug": "cloud-security",
  "description": "Master cloud security across AWS, Azure, and GCP",
  "icon": "cloud",
  "orderIndex": 5,
  "isActive": true,
  "estimatedHours": 35,
  "createdAt": "2026-03-11T18:00:00",
  "updatedAt": "2026-03-11T18:05:00"
}
```

### 3. Delete Learning Path

**Endpoint:** `DELETE /api/admin/paths/:id`

**Request:**
```bash
curl -X DELETE http://localhost:8080/api/admin/paths/5 \
  -H "Authorization: Bearer <admin_access_token>"
```

**Response (204 No Content):**
```
(Empty response body)
```

### 4. Get All Users (Admin)

**Endpoint:** `GET /api/admin/users`

**Request:**
```bash
curl http://localhost:8080/api/admin/users \
  -H "Authorization: Bearer <admin_access_token>"
```

**Response (200 OK):**
```json
{
  "message": "Admin users endpoint - to be implemented"
}
```

### 5. Get Analytics Overview

**Endpoint:** `GET /api/admin/analytics/overview`

**Request:**
```bash
curl http://localhost:8080/api/admin/analytics/overview \
  -H "Authorization: Bearer <admin_access_token>"
```

**Response (200 OK):**
```json
{
  "message": "Analytics endpoint - to be implemented"
}
```

## 🧪 Testing Tools

### Using cURL

Save access token to variable:
```bash
# Login and extract token
TOKEN=$(curl -s -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@cyberskill.com","password":"Admin@123"}' \
  | jq -r '.accessToken')

# Use token in requests
curl http://localhost:8080/api/user/profile \
  -H "Authorization: Bearer $TOKEN"
```

### Using Postman

1. **Import Collection**
   - Create new collection "CyberSkill API"
   - Add base URL variable: `{{baseUrl}}` = `http://localhost:8080`

2. **Setup Environment**
   - Create environment "Local"
   - Add variable: `accessToken`
   - Add variable: `refreshToken`

3. **Auto-set Token**
   - In Login request, add to Tests tab:
   ```javascript
   pm.environment.set("accessToken", pm.response.json().accessToken);
   pm.environment.set("refreshToken", pm.response.json().refreshToken);
   ```

4. **Use Token**
   - In Authorization tab, select "Bearer Token"
   - Token: `{{accessToken}}`

### Using HTTPie

```bash
# Install HTTPie
pip install httpie

# Login
http POST localhost:8080/api/auth/login \
  email=admin@cyberskill.com \
  password=Admin@123

# Use token
http GET localhost:8080/api/user/profile \
  Authorization:"Bearer <token>"
```

### Using JavaScript/Fetch

```javascript
// Login
const login = async () => {
  const response = await fetch('http://localhost:8080/api/auth/login', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      email: 'admin@cyberskill.com',
      password: 'Admin@123'
    })
  });
  const data = await response.json();
  localStorage.setItem('accessToken', data.accessToken);
  return data;
};

// Use token
const getProfile = async () => {
  const token = localStorage.getItem('accessToken');
  const response = await fetch('http://localhost:8080/api/user/profile', {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  return response.json();
};
```

## 📊 Common HTTP Status Codes

- **200 OK** - Request successful
- **201 Created** - Resource created successfully
- **204 No Content** - Request successful, no content to return
- **400 Bad Request** - Invalid request data
- **401 Unauthorized** - Missing or invalid authentication
- **403 Forbidden** - Insufficient permissions
- **404 Not Found** - Resource not found
- **500 Internal Server Error** - Server error

## 🔍 Testing Checklist

### Authentication Flow
- [ ] Register new user
- [ ] Login with valid credentials
- [ ] Login with invalid credentials
- [ ] Refresh access token
- [ ] Change password
- [ ] Logout

### Authorization
- [ ] Access protected endpoint without token
- [ ] Access protected endpoint with valid token
- [ ] Access admin endpoint as regular user
- [ ] Access admin endpoint as admin

### Learning Paths
- [ ] Get all learning paths
- [ ] Get specific learning path
- [ ] Create learning path (admin)
- [ ] Update learning path (admin)
- [ ] Delete learning path (admin)

### Error Handling
- [ ] Invalid JSON in request body
- [ ] Missing required fields
- [ ] Invalid data types
- [ ] Expired token
- [ ] Invalid token format

## 📝 Notes

- All timestamps are in ISO 8601 format (UTC)
- Tokens expire after configured time (default: 1 hour for access, 7 days for refresh)
- Password must meet strength requirements (8+ chars, uppercase, lowercase, digit, special char)
- Admin endpoints require ADMIN role
- Rate limiting may apply (check application.properties)

---

**Last Updated**: March 2026
**Version**: 1.0.0