# DemoDepot Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Setup Database

```bash
# Create database
createdb demodepot

# Load schema (creates tables and default users)
psql -d demodepot -f src/main/resources/webroot/sql/schema.sql
```

### Step 2: Build Application

```bash
mvn clean package
```

### Step 3: Run Application

```bash
java -jar target/demodepot-0.0.1-SNAPSHOT-fat.jar
```

Server starts on: **http://localhost:9999**

---

## 🔐 Default Accounts

### Admin Account
- **Username**: `admin@demodepot.com`
- **Password**: `admin123`
- **Access**: Full admin dashboard, can update all request statuses

### Test User Account
- **Username**: `user@demodepot.com`
- **Password**: `user123`
- **Access**: Can create and manage own demo requests

---

## 📱 Application Pages

### Public Access (No Login Required)
- **Public Dashboard**: http://localhost:9999/demodashboard.html
  - View all submitted demo requests
  - See charts and statistics
  - Read-only access

### User Access (Login Required)
- **Login/Signup**: http://localhost:9999/login.html
- **User Dashboard**: http://localhost:9999/user-dashboard.html
  - View your demo requests
  - Edit drafts
  - Delete drafts
- **New Request**: http://localhost:9999/demorequest.html
  - Create new demo requests
  - Upload documents

### Admin Access (Admin Login Required)
- **Admin Dashboard**: http://localhost:9999/admin-dashboard.html
  - View all users' requests
  - Update request statuses
  - Full system overview

---

## 🎯 Quick Test Workflow

### 1. Test Public Dashboard
```
1. Open: http://localhost:9999/demodashboard.html
2. View demo requests (no login needed)
3. See charts and statistics
```

### 2. Test User Flow
```
1. Open: http://localhost:9999/login.html
2. Login as: user@demodepot.com / user123
3. Go to: New Request
4. Fill form and submit
5. View in: My Requests dashboard
```

### 3. Test Admin Flow
```
1. Open: http://localhost:9999/login.html
2. Login as: admin@demodepot.com / admin123
3. Go to: http://localhost:9999/admin-dashboard.html
4. View all requests
5. Click "Update Status" on any request
6. Change status to "in_progress" or "completed"
```

---

## 🔧 Common Tasks

### Create New User
```
1. Go to login page
2. Click "Sign up" tab
3. Enter email and password (min 8 chars)
4. Auto-login after signup
```

### Submit Demo Request
```
1. Login as user
2. Go to "New Request"
3. Fill required fields:
   - PM Owner Name
   - Demo Type
   - Product Name
   - Delivery Date
   - Title
   - Value Proposition
   - Feature Focus
   - Flow Sequence
4. Optional: Upload documents
5. Click "Submit Request"
```

### Update Request Status (Admin Only)
```
1. Login as admin
2. Go to admin dashboard
3. Find request in table
4. Click "Update Status"
5. Select new status:
   - submitted
   - in_progress
   - completed
   - cancelled
6. Click "Update"
```

---

## 📊 Request Status Flow

```
draft → submitted → in_progress → completed
                              ↘ cancelled
```

- **draft**: User is still editing (can delete)
- **submitted**: Awaiting admin review
- **in_progress**: Admin is working on it
- **completed**: Demo is ready
- **cancelled**: Request cancelled

---

## 🐛 Troubleshooting

### Can't Login?
- Check username/password
- Try default accounts first
- Clear browser localStorage: `localStorage.clear()`

### Database Connection Error?
- Verify PostgreSQL is running: `pg_isready`
- Check database exists: `psql -l | grep demodepot`
- Verify credentials in MainVerticle.java

### "No main manifest attribute" Error?
- Run: `mvn clean package` again
- Check pom.xml has maven-shade-plugin

### Can't See Requests?
- Public dashboard only shows non-draft requests
- Users only see their own requests
- Admins see all requests

---

## 🎨 Features Overview

### ✅ Authentication
- JWT-based secure authentication
- BCrypt password hashing
- 7-day token expiration
- Role-based access control

### ✅ User Features
- Create demo requests
- Upload documents
- Track request status
- Edit/delete drafts
- Personal dashboard

### ✅ Admin Features
- View all requests
- Update statuses
- User management
- Full system visibility

### ✅ Public Features
- Read-only dashboard
- View submitted requests
- Charts and analytics
- No login required

---

## 📝 Next Steps

1. **Customize**: Update JWT secret in MainVerticle.java
2. **Secure**: Change default admin password
3. **Configure**: Adjust database settings
4. **Deploy**: Set up production environment
5. **Monitor**: Add logging and monitoring

---

## 🆘 Need Help?

Check the full README.md for:
- Detailed API documentation
- Database schema details
- Security features
- Development guide

---

**Happy Demo Managing! 🎉**