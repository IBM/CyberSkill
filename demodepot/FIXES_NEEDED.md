# Fixes Needed for DemoDepot

## Issue 1: "New Request" button logs out users

**Problem:** Clicking "New Request" redirects to login page

**Root Cause:** demorequest.html has old authentication code that conflicts with the new system

**Solution:** Update demorequest.html to use the new navbar system

### Fix for demorequest.html:

Replace the `<head>` section with:
```html
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Demo Request - DemoDepot</title>
    <link rel="stylesheet" href="/css/global.css">
    <link rel="stylesheet" href="/css/toast.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
```

Replace the `<body>` opening and navbar with:
```html
<body>
  <!-- Dynamic Navbar -->
  <div id="app-navbar"></div>
  
  <div class="page-container">
```

At the end before `</body>`, add:
```html
  <script src="/js/toast.js"></script>
  <script src="/js/navbar.js"></script>
  <script src="js/script.js"></script>
</body>
```

Remove any old authentication checks that redirect to login.

## Issue 2: Admin Portal link not visible

**Problem:** Admin users don't see the "⚙️ Admin Portal" link in navbar

**Diagnosis Steps:**
1. Open browser console (F12)
2. Check what `localStorage.getItem('role')` returns
3. Look for `[Auth Check]` log messages

**Possible Causes:**
1. Role not being saved correctly during login
2. Role value is different than expected (e.g., "Admin" vs "admin")
3. localStorage being cleared

**Solution:** 

### Check login.html saves role correctly:

In login.html, the `saveAuth` function should be:
```javascript
function saveAuth(token, username, role) {
  console.log('[Auth] Saving credentials:', { username, role, tokenLength: token?.length });
  localStorage.setItem('token', token);
  localStorage.setItem('username', username);
  localStorage.setItem('role', role);  // Make sure this is lowercase 'admin'
  toast.success(`Welcome ${username}!`);
}
```

### Verify backend returns lowercase role:

In MainVerticle.java, both handleLogin and handleSignup should return:
```java
rc.response().putHeader("content-type", "application/json")
    .end(new JsonObject()
        .put("token", token)
        .put("username", username)
        .put("role", role)  // Should be "admin" or "user" (lowercase)
        .put("message", "Login successful")
        .encode());
```

### Test in browser console:

```javascript
// Check what's stored
console.log('Token:', localStorage.getItem('token'));
console.log('Username:', localStorage.getItem('username'));
console.log('Role:', localStorage.getItem('role'));

// Check auth
const auth = checkAuth();
console.log('Auth object:', auth);

// Manually set admin role for testing
localStorage.setItem('role', 'admin');
location.reload();
```

## Issue 3: Navbar not showing at all

**Problem:** Navbar div exists but is empty

**Solution:** Make sure navbar.js is loaded and DOMContentLoaded fires

Add this debug code temporarily to navbar.js at the top:
```javascript
console.log('[Navbar] Script loaded');

// At the end of the file, add:
console.log('[Navbar] Waiting for DOMContentLoaded...');
```

## Quick Test Checklist:

1. ✅ Login as admin (admin@demodepot.com / admin123)
2. ✅ Check browser console for role value
3. ✅ Verify navbar appears
4. ✅ Look for "⚙️ Admin Portal" link
5. ✅ Click "New Request" - should NOT log out
6. ✅ Click "Admin Portal" - should go to admin dashboard

## Database Check:

Make sure the admin user has the correct role:
```sql
SELECT id, username, role FROM users WHERE username = 'admin@demodepot.com';
```

Should return: `role = 'admin'` (lowercase)

If it's uppercase or different, update it:
```sql
UPDATE users SET role = 'admin' WHERE username = 'admin@demodepot.com';