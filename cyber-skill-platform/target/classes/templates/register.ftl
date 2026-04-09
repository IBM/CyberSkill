<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CyberSkill Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .register-container {
            max-width: 500px;
            margin: 80px auto;
            padding: 40px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h1 {
            color: #1a1a1a;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #666;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s;
            box-sizing: border-box;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #0066cc;
        }
        
        .form-group input.error {
            border-color: #dc3545;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
        
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            line-height: 1.5;
        }
        
        .password-requirements ul {
            margin: 5px 0;
            padding-left: 20px;
        }
        
        .password-requirements li {
            margin: 2px 0;
        }
        
        .password-requirements li.valid {
            color: #28a745;
        }
        
        .btn-register {
            width: 100%;
            padding: 14px;
            background: #0066cc;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .btn-register:hover {
            background: #0052a3;
        }
        
        .btn-register:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }
        
        .login-link a {
            color: #0066cc;
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert.hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>Create Account</h1>
            <p>Join CyberSkill Platform to start your learning journey</p>
        </div>
        
        <div id="alert" class="alert hidden"></div>
        
        <form id="registerForm">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required 
                       placeholder="Choose a username" minlength="3" maxlength="50">
                <div class="error-message" id="usernameError"></div>
            </div>
            
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required 
                       placeholder="your.email@example.com">
                <div class="error-message" id="emailError"></div>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required 
                       placeholder="Create a strong password" minlength="8">
                <div class="password-requirements">
                    <strong>Password must contain:</strong>
                    <ul>
                        <li id="req-length">At least 8 characters</li>
                        <li id="req-uppercase">One uppercase letter</li>
                        <li id="req-lowercase">One lowercase letter</li>
                        <li id="req-digit">One number</li>
                        <li id="req-special">One special character (!@#$%^&*)</li>
                    </ul>
                </div>
                <div class="error-message" id="passwordError"></div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required 
                       placeholder="Re-enter your password">
                <div class="error-message" id="confirmPasswordError"></div>
            </div>
            
            <button type="submit" class="btn-register" id="registerBtn">
                Create Account
            </button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="/login">Sign in</a>
        </div>
        
        <div class="login-link">
            <a href="/">← Back to Home</a>
        </div>
    </div>
    
    <script>
        console.log('📝 Register page loaded');
        console.log('Current URL:', window.location.href);
        console.log('API endpoint:', '/api/auth/register');
        
        const form = document.getElementById('registerForm');
        const usernameInput = document.getElementById('username');
        const emailInput = document.getElementById('email');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const registerBtn = document.getElementById('registerBtn');
        const alert = document.getElementById('alert');
        
        // Password validation requirements
        const requirements = {
            length: { regex: /.{8,}/, element: document.getElementById('req-length') },
            uppercase: { regex: /[A-Z]/, element: document.getElementById('req-uppercase') },
            lowercase: { regex: /[a-z]/, element: document.getElementById('req-lowercase') },
            digit: { regex: /\d/, element: document.getElementById('req-digit') },
            special: { regex: /[!@#$%^&*(),.?":{}|<>]/, element: document.getElementById('req-special') }
        };
        
        // Real-time password validation
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            console.log('🔑 Password validation - length:', password.length);
            let allValid = true;
            
            for (const [key, req] of Object.entries(requirements)) {
                if (req.regex.test(password)) {
                    req.element.classList.add('valid');
                    console.log('✅ Password requirement met:', key);
                } else {
                    req.element.classList.remove('valid');
                    allValid = false;
                    console.log('❌ Password requirement not met:', key);
                }
            }
            
            // Check confirm password match
            if (confirmPasswordInput.value && password !== confirmPasswordInput.value) {
                showFieldError('confirmPassword', 'Passwords do not match');
            } else {
                hideFieldError('confirmPassword');
            }
        });
        
        // Confirm password validation
        confirmPasswordInput.addEventListener('input', function() {
            console.log('🔄 Checking password match');
            if (this.value !== passwordInput.value) {
                showFieldError('confirmPassword', 'Passwords do not match');
            } else {
                hideFieldError('confirmPassword');
            }
        });
        
        // Form submission
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            console.log('📤 Registration form submitted');
            
            // Clear previous errors
            clearAllErrors();
            
            // Validate form
            if (!validateForm()) {
                console.log('❌ Form validation failed');
                return;
            }
            
            console.log('✅ Form validation passed');
            
            // Disable button
            registerBtn.disabled = true;
            registerBtn.textContent = 'Creating Account...';
            
            const payload = {
                username: usernameInput.value.trim(),
                email: emailInput.value.trim(),
                password: passwordInput.value
            };
            
            console.log('🌐 Sending POST request to /api/auth/register');
            console.log('Request payload:', JSON.stringify({ ...payload, password: '***' }));
            
            try {
                const response = await fetch('/api/auth/register', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(payload)
                });
                
                console.log('📡 Response status:', response.status);
                console.log('📡 Response headers:', [...response.headers.entries()]);
                
                const data = await response.json();
                console.log('📦 Response data:', data);
                
                if (response.ok) {
                    console.log('✅ Registration successful!');
                    showAlert('success', 'Account created successfully! Redirecting to login...');
                    setTimeout(() => {
                        console.log('🔄 Redirecting to /login');
                        window.location.href = '/login';
                    }, 2000);
                } else {
                    console.log('❌ Registration failed:', data.message || data.error);
                    showAlert('error', data.message || data.error || 'Registration failed. Please try again.');
                    registerBtn.disabled = false;
                    registerBtn.textContent = 'Create Account';
                }
            } catch (error) {
                console.error('❌ Registration error:', error);
                showAlert('error', 'Network error. Please check your connection and try again.');
                registerBtn.disabled = false;
                registerBtn.textContent = 'Create Account';
            }
        });
        
        function validateForm() {
            let isValid = true;
            
            // Username validation
            if (usernameInput.value.trim().length < 3) {
                showFieldError('username', 'Username must be at least 3 characters');
                isValid = false;
            }
            
            // Email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailInput.value.trim())) {
                showFieldError('email', 'Please enter a valid email address');
                isValid = false;
            }
            
            // Password validation
            const password = passwordInput.value;
            for (const [key, req] of Object.entries(requirements)) {
                if (!req.regex.test(password)) {
                    showFieldError('password', 'Password does not meet all requirements');
                    isValid = false;
                    break;
                }
            }
            
            // Confirm password validation
            if (password !== confirmPasswordInput.value) {
                showFieldError('confirmPassword', 'Passwords do not match');
                isValid = false;
            }
            
            return isValid;
        }
        
        function showFieldError(fieldName, message) {
            const input = document.getElementById(fieldName);
            const error = document.getElementById(fieldName + 'Error');
            input.classList.add('error');
            error.textContent = message;
            error.classList.add('show');
        }
        
        function hideFieldError(fieldName) {
            const input = document.getElementById(fieldName);
            const error = document.getElementById(fieldName + 'Error');
            input.classList.remove('error');
            error.classList.remove('show');
        }
        
        function clearAllErrors() {
            ['username', 'email', 'password', 'confirmPassword'].forEach(field => {
                hideFieldError(field);
            });
            alert.classList.add('hidden');
        }
        
        function showAlert(type, message) {
            alert.className = 'alert alert-' + type;
            alert.textContent = message;
            alert.classList.remove('hidden');
            console.log('📢 Alert shown:', type, message);
        }
    </script>
</body>
</html>