# DemoDepot - Demo Request Management System

A comprehensive demo request management system with role-based access control, built with Vert.x and PostgreSQL.

## Features

### Authentication & Authorization
- **JWT-based authentication** with secure password hashing (BCrypt)
- **Role-based access control (RBAC)**: Admin and User roles
- **Session management** with 7-day token expiration

### User Features
- Create and submit demo requests
- View and manage own demo requests
- Edit draft requests
- Delete draft requests
- Upload supporting documents (existing docs, demo scripts)
- Track request status

### Admin Features
- View all demo requests from all users
- Update demo request statuses
- Full visibility into all submissions

### Public Features
- Read-only public dashboard
- View submitted (non-draft) demo requests
- No authentication required

## Architecture

### Backend (Vert.x)
- **MainVerticle.java**: Main application verticle with all endpoints
- **PostgreSQL**: Database for users and demo requests
- **JWT Authentication**: Secure token-based auth
- **File Upload**: Support for document attachments

### Frontend
- **login.html**: Sign up and sign in page
- **user-dashboard.html**: User's personal dashboard
- **admin-dashboard.html**: Admin dashboard with status management
- **demorequest.html**: Demo request submission form
- **demodashboard.html**: Public read-only dashboard

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'user',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Demo Requests Table
```sql
CREATE TABLE demo_requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    pm_owner VARCHAR(255),
    demo_type VARCHAR(255),
    product_name VARCHAR(255),
    delivery_date DATE,
    title VARCHAR(255),
    subtitle VARCHAR(255),
    value_proposition TEXT,
    feature_focus TEXT,
    flow_sequence TEXT,
    existing_docs_path VARCHAR(255),
    demo_url VARCHAR(255),
    demo_script_path VARCHAR(255),
    status VARCHAR(50) DEFAULT 'draft',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Setup Instructions

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- PostgreSQL 12+

### Database Setup

1. Create a PostgreSQL database:
```bash
createdb demodepot
```

2. Run the schema script:
```bash
psql -d demodepot -f src/main/resources/webroot/sql/schema.sql
```

This creates:
- Users table
- Demo requests table with user_id foreign key
- Default admin user (username: `admin@demodepot.com`, password: `admin123`)
- Default test user (username: `user@demodepot.com`, password: `user123`)

### Application Configuration

Update database connection in `MainVerticle.java` or use environment variables:
- `db.host`: localhost (default)
- `db.port`: 5432 (default)
- `db.database`: demodepot (default)
- `db.user`: postgres (default)
- `db.password`: postgres (default)

### Build and Run

1. Build the project:
```bash
mvn clean package
```

2. Run the application:
```bash
java -jar target/demodepot-0.0.1-SNAPSHOT-fat.jar
```

The server will start on port 9999 by default.

## API Endpoints

### Public Endpoints
- `POST /api/signup` - Create new user account
- `POST /api/login` - Login and get JWT token
- `GET /api/demo-requests/public` - Get all non-draft demo requests (read-only)

### Protected Endpoints (Require JWT)
- `GET /api/demo-requests` - Get user's own demo requests
- `POST /api/create-demo-requests` - Create new demo request
- `PUT /api/demo-requests/:id` - Update own demo request
- `DELETE /api/demo-requests/:id` - Delete own demo request
- `POST /api/demo-requests/draft` - Save draft
- `PUT /api/demo-requests/draft/:id` - Update draft
- `GET /api/demo-requests/draft/:id` - Get draft

### Admin-Only Endpoints
- `GET /api/admin/demo-requests` - Get all demo requests
- `PUT /api/demo-requests/:id/status` - Update request status

## Usage Guide

### For Users

1. **Sign Up**
   - Go to `/login.html`
   - Click "Sign up" tab
   - Enter email and password (min 8 characters)
   - You'll be automatically logged in

2. **Create Demo Request**
   - Navigate to `/demorequest.html`
   - Fill in all required fields
   - Upload supporting documents (optional)
   - Submit the request

3. **Manage Requests**
   - Go to `/user-dashboard.html`
   - View all your demo requests
   - Click "View" to see details
   - Delete drafts if needed

### For Admins

1. **Login**
   - Use admin credentials: `admin@demodepot.com` / `admin123`

2. **Admin Dashboard**
   - Navigate to `/admin-dashboard.html`
   - View all demo requests from all users
   - Click "Update Status" to change request status
   - Available statuses: submitted, in_progress, completed, cancelled

### For Public Viewers

1. **Public Dashboard**
   - Go to `/demodashboard.html`
   - No login required
   - View all submitted (non-draft) demo requests
   - See charts and statistics

## Security Features

- **Password Hashing**: BCrypt with salt
- **JWT Tokens**: HS256 algorithm, 7-day expiration
- **Authorization**: Role-based access control
- **Ownership Verification**: Users can only modify their own requests
- **Admin Protection**: Status updates restricted to admins

## Status Workflow

1. **draft** - Initial state, user can edit/delete
2. **submitted** - Request submitted, awaiting review
3. **in_progress** - Admin is working on the request
4. **completed** - Demo completed
5. **cancelled** - Request cancelled

## File Uploads

Uploaded files are stored in `webroot/uploads/` directory and accessible via:
```
/uploads/{filename}
```

## Troubleshooting

### "no main manifest attribute" Error
- Fixed by adding maven-shade-plugin to pom.xml
- Rebuild with `mvn clean package`

### Database Connection Issues
- Verify PostgreSQL is running
- Check database credentials in MainVerticle.java
- Ensure database exists and schema is loaded

### Authentication Issues
- Clear browser localStorage
- Check JWT token expiration
- Verify user exists in database

## Development

### Adding New Features
1. Add endpoint in MainVerticle.java
2. Implement handler method
3. Add authentication/authorization as needed
4. Update frontend to call new endpoint

### Modifying Roles
- Edit user role in database: `UPDATE users SET role='admin' WHERE username='user@example.com';`

## License

This project is for demonstration purposes.