<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CyberSkill Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .dashboard-header {
            background: var(--secondary-color);
            color: white;
            padding: 1rem 0;
        }
        
        .dashboard-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .dashboard-content {
            padding: 2rem 0;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .stat-label {
            color: var(--text-secondary);
            margin-top: 0.5rem;
        }
        
        .section-title {
            font-size: 1.75rem;
            margin-bottom: 1.5rem;
        }
        
        .path-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .path-card-dashboard {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: var(--transition);
        }
        
        .path-card-dashboard:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }
        
        .path-card-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, #001d6c 100%);
            color: white;
            padding: 1.5rem;
        }
        
        .path-card-body {
            padding: 1.5rem;
        }
        
        .progress-section {
            margin-top: 1rem;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <header class="dashboard-header">
        <div class="container">
            <div class="dashboard-nav">
                <h1>🛡️ CyberSkill Dashboard</h1>
                <div class="user-info">
                    <span id="userName">Loading...</span>
                    <button class="btn btn-secondary" onclick="logout()">Logout</button>
                </div>
            </div>
        </div>
    </header>
    
    <main class="dashboard-content">
        <div class="container">
            <!-- Stats Overview -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value" id="completedLessons">0</div>
                    <div class="stat-label">Lessons Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="earnedBadges">0</div>
                    <div class="stat-label">Badges Earned</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="certificates">0</div>
                    <div class="stat-label">Certificates</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="completionRate">0%</div>
                    <div class="stat-label">Overall Progress</div>
                </div>
            </div>
            
            <!-- Learning Paths -->
            <h2 class="section-title">Your Learning Paths</h2>
            <div class="path-grid" id="pathsContainer">
                <div class="spinner"></div>
            </div>
        </div>
    </main>
    
    <script>
        // Check authentication
        const accessToken = localStorage.getItem('accessToken');
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        
        if (!accessToken) {
            window.location.href = '/login';
        }
        
        // Display user name
        document.getElementById('userName').textContent = user.username || user.email;
        
        // Logout function
        function logout() {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            localStorage.removeItem('user');
            window.location.href = '/login';
        }
        
        // Load learning paths
        async function loadPaths() {
            try {
                const accessToken = localStorage.getItem('accessToken');
                const response = await fetch('/api/paths', {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (response.ok) {
                    const paths = await response.json();
                    displayPaths(paths);
                } else if (response.status === 401) {
                    // Token expired
                    logout();
                } else {
                    throw new Error('Failed to load paths');
                }
            } catch (error) {
                console.error('Error loading paths:', error);
                document.getElementById('pathsContainer').innerHTML = 
                    '<p>Error loading learning paths. Please refresh the page.</p>';
            }
        }
        
        // Display learning paths
        function displayPaths(paths) {
            const container = document.getElementById('pathsContainer');
            
            if (paths.length === 0) {
                container.innerHTML = '<p>No learning paths available.</p>';
                return;
            }
            
            container.innerHTML = paths.map(path =>
                '<div class="path-card-dashboard">' +
                    '<div class="path-card-header">' +
                        '<h3>' + path.name + '</h3>' +
                        '<p style="opacity: 0.9; margin-top: 0.5rem;">' + path.estimatedHours + ' hours</p>' +
                    '</div>' +
                    '<div class="path-card-body">' +
                        '<p>' + path.description + '</p>' +
                        '<div class="progress-section">' +
                            '<div class="progress-label">' +
                                '<span>Progress</span>' +
                                '<span>0%</span>' +
                            '</div>' +
                            '<div class="progress-bar">' +
                                '<div class="progress-fill" style="width: 0%"></div>' +
                            '</div>' +
                        '</div>' +
                        '<button class="btn btn-primary mt-3" onclick="startPath(' + path.id + ')">' +
                            'Continue Learning' +
                        '</button>' +
                    '</div>' +
                '</div>'
            ).join('');
        }
        
        // Start learning path
        function startPath(pathId) {
            window.location.href = '/learning/path/' + pathId;
        }
        
        // Load data on page load
        loadPaths();
        
        // Load user stats (placeholder)
        document.getElementById('completedLessons').textContent = '0';
        document.getElementById('earnedBadges').textContent = '0';
        document.getElementById('certificates').textContent = '0';
        document.getElementById('completionRate').textContent = '0%';
    </script>
</body>
</html>