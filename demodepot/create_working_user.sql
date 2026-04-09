-- This script will help you create a working admin user
-- First, use the signup feature to create a test account, then we'll promote it to admin

-- Step 1: After signing up with the web interface, find your user
SELECT id, username, role, LEFT(password_hash, 20) as hash_preview FROM users ORDER BY created_at DESC LIMIT 5;

-- Step 2: Promote your test user to admin (replace 'your-email@example.com' with your signup email)
-- UPDATE users SET role = 'admin' WHERE username = 'your-email@example.com';

-- Step 3: Or copy the working hash from your signup and update the admin user
-- First, signup at http://localhost:9999/login.html with email: test@test.com and password: admin123
-- Then run this to see the hash that was generated:
-- SELECT password_hash FROM users WHERE username = 'test@test.com';

-- Step 4: Copy that hash and update the admin user:
-- UPDATE users SET password_hash = 'PASTE_HASH_HERE' WHERE username = 'admin@demodepot.com';

-- Made with Bob
