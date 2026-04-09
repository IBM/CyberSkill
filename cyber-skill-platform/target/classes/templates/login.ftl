<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CyberSkill Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, var(--primary-color) 0%, #001d6c 100%);
        }
        
        .login-box {
            background: white;
            padding: 3rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-hover);
            width: 100%;
            max-width: 450px;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .login-header h1 {
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }
        
        .login-header p {
            color: var(--text-secondary);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .btn-full {
            width: 100%;
        }
        
        .divider {
            text-align: center;
            margin: 1.5rem 0;
            color: var(--text-secondary);
        }
        
        .register-link {
            text-align: center;
            margin-top: 1.5rem;
        }
        
        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <div class="login-header">
                <h1>🛡️ CyberSkill</h1>
                <p>Sign in to your account</p>
            </div>
            
            <div id="alert-container"></div>
            
            <form id="loginForm">
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-input" 
                        placeholder="your@email.com"
                        required
                    >
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-input" 
                        placeholder="Enter your password"
                        required
                    >
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-full">
                        Sign In
                    </button>
                </div>
            </form>
            
            <div class="register-link">
                Don't have an account? <a href="/register">Create one</a>
            </div>
            
            <div class="register-link">
                <a href="/">← Back to Home</a>
            </div>
        </div>
    </div>
    
    <script>
        console.log('🔐 Login page loaded');
        console.log('Current URL:', window.location.href);
        console.log('API endpoint:', '/api/auth/login');
        
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            console.log('📝 Login form submitted');
            
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const alertContainer = document.getElementById('alert-container');
            
            console.log('📧 Email:', email);
            console.log('🔑 Password length:', password.length);
            
            try {
                console.log('🌐 Sending POST request to /api/auth/login');
                console.log('Request payload:', JSON.stringify({ email, password: '***' }));
                
                const response = await fetch('/api/auth/login', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ email, password })
                });
                
                console.log('📡 Response status:', response.status);
                console.log('📡 Response headers:', [...response.headers.entries()]);
                
                const data = await response.json();
                console.log('📦 Response data:', data);
                
                if (response.ok) {
                    console.log('✅ Login successful!');
                    console.log('🎫 Access token received:', data.accessToken ? 'Yes' : 'No');
                    console.log('🎫 Refresh token received:', data.refreshToken ? 'Yes' : 'No');
                    
                    // Store tokens
                    localStorage.setItem('accessToken', data.accessToken);
                    localStorage.setItem('refreshToken', data.refreshToken);
                    console.log('💾 Tokens stored in localStorage');
                    localStorage.setItem('user', JSON.stringify(data.user));
                    
                    // Show success message
                    alertContainer.innerHTML = '<div class="alert alert-success">Login successful! Redirecting...</div>';
                    
                    // Redirect based on role
                    setTimeout(() => {
                        if (data.user.role === 'ADMIN') {
                            window.location.href = '/admin';
                        } else {
                            window.location.href = '/dashboard';
                        }
                    }, 1000);
                } else {
                    alertContainer.innerHTML = '<div class="alert alert-error">' + (data.error || 'Login failed') + '</div>';
                }
            } catch (error) {
                console.error('Login error:', error);
                alertContainer.innerHTML = '<div class="alert alert-error">An error occurred. Please try again.</div>';
            }
        });
    </script>
</body>
</html>