# DemoDepot Troubleshooting Guide

## Issue: Login Returns 401 Unauthorized

### Possible Causes & Solutions

### 1. Database Not Set Up

**Symptoms:**
- Login returns 401 Unauthorized
- No error in server logs about database connection

**Solution:**
```bash
# Check if database exists
psql -l | grep demodepot

# If not exists, create it
createdb demodepot

# Load the schema
psql -d demodepot -f src/main/resources/webroot/sql/schema.sql

# Verify users were created
psql -d demodepot -c "SELECT username, role FROM users;"
```

**Expected Output:**
```
        username        | role  
------------------------+-------
 admin@demodepot.com    | admin
 user@demodepot.com     | user
```

### 2. Wrong Credentials

**Default Accounts:**
- **Admin**: 
  - Username: `admin@demodepot.com`
  - Password: `admin123`
  
- **User**:
  - Username: `user@demodepot.com`
  - Password: `user123`

**Important:** Use the FULL email address including `@demodepot.com`

### 3. Database Connection Issues

**Check server logs for:**
```
Connection refused
Could not connect to database
```

**Solution:**
1. Verify PostgreSQL is running:
   ```bash
   pg_isready
   ```

2. Check connection settings in MainVerticle.java:
   - Host: localhost (default)
   - Port: 5432 (default)
   - Database: demodepot
   - User: postgres (default)
   - Password: postgres (default)

3. If using different credentials, update MainVerticle.java or use config:
   ```java
   PgConnectOptions connectOptions = new PgConnectOptions()
     .setHost("localhost")
     .setPort(5432)
     .setDatabase("demodepot")
     .setUser("your_user")
     .setPassword("your_password");
   ```

### 4. Users Table Doesn't Exist

**Check if table exists:**
```bash
psql -d demodepot -c "\dt"
```

**Expected Output:**
```
              List of relations
 Schema |      Name       | Type  |  Owner   
--------+-----------------+-------+----------
 public | demo_requests   | table | postgres
 public | users           | table | postgres
```

**If missing, run schema:**
```bash
psql -d demodepot -f src/main/resources/webroot/sql/schema.sql
```

### 5. Password Hash Issue

**Verify password hashes exist:**
```bash
psql -d demodepot -c "SELECT username, LENGTH(password_hash) as hash_length FROM users;"
```

**Expected Output:**
```
        username        | hash_length 
------------------------+-------------
 admin@demodepot.com    |          60
 user@demodepot.com     |          60
```

If hash_length is not 60, the BCrypt hashes are wrong. Re-run schema.

### 6. Application Not Restarted

After running schema, restart the application:
```bash
# Stop the running application (Ctrl+C)
# Restart it
java -jar target/demodepot-0.0.1-SNAPSHOT-fat.jar
```

## Complete Setup Checklist

- [ ] PostgreSQL is installed and running
- [ ] Database `demodepot` exists
- [ ] Schema loaded: `psql -d demodepot -f src/main/resources/webroot/sql/schema.sql`
- [ ] Users table has 2 rows (admin and user)
- [ ] Application built: `mvn clean package`
- [ ] Application running: `java -jar target/demodepot-0.0.1-SNAPSHOT-fat.jar`
- [ ] Server shows: "HTTP server started on port 9999"
- [ ] Using correct credentials: `admin@demodepot.com` / `admin123`

## Testing Login

### Using Browser
1. Open: http://localhost:9999/login.html
2. Enter: `admin@demodepot.com`
3. Password: `admin123`
4. Click "Sign in"
5. Should redirect and show "Signed in successfully"

### Using curl
```bash
curl -X POST http://localhost:9999/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin@demodepot.com","password":"admin123"}'
```

**Expected Response:**
```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "username": "admin@demodepot.com",
  "role": "admin"
}
```

**Error Response (401):**
```json
{
  "error": "Invalid credentials"
}
```

## Common Mistakes

1. **Forgetting @demodepot.com**: Use full email
2. **Wrong password**: Default is `admin123` not `admin`
3. **Database not created**: Must run `createdb demodepot`
4. **Schema not loaded**: Must run the SQL file
5. **Old application running**: Restart after schema changes

## Server Log Analysis

### Good Startup:
```
INFO HTTP server started on port 9999
```

### Database Connection Error:
```
ERROR Failed to connect to database
Connection refused
```
**Fix:** Start PostgreSQL

### Table Not Found:
```
ERROR relation "users" does not exist
```
**Fix:** Run schema.sql

### Authentication Error:
```
DEBUG RoutingContext failure (401)
HttpException: Unauthorized
```
**Fix:** Check credentials or database setup

## Manual User Creation

If you need to create a user manually:

```sql
-- Create a new user
INSERT INTO users (username, password_hash, role) 
VALUES (
  'newuser@example.com',
  '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- This is 'admin123'
  'user'
);
```

## Reset Everything

If nothing works, start fresh:

```bash
# 1. Stop application
# 2. Drop and recreate database
dropdb demodepot
createdb demodepot

# 3. Load schema
psql -d demodepot -f src/main/resources/webroot/sql/schema.sql

# 4. Rebuild application
mvn clean package

# 5. Start application
java -jar target/demodepot-0.0.1-SNAPSHOT-fat.jar

# 6. Test login
curl -X POST http://localhost:9999/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin@demodepot.com","password":"admin123"}'
```

## Still Having Issues?

Check:
1. Server logs for detailed error messages
2. Browser console (F12) for JavaScript errors
3. Network tab (F12) to see actual request/response
4. PostgreSQL logs for database errors

## Contact Information

For more help, check:
- README.md - Full documentation
- QUICKSTART.md - Quick setup guide
- Server logs - Detailed error information