<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CyberSkill Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 20px 0;
            border-bottom: 2px solid #667eea;
            margin-bottom: 20px;
        }

        .sidebar-header h2 {
            color: #667eea;
            font-size: 24px;
            font-weight: 700;
        }

        .sidebar-nav {
            list-style: none;
        }

        .sidebar-nav li {
            margin-bottom: 10px;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: #333;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .sidebar-nav a:hover,
        .sidebar-nav a.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .sidebar-nav a span {
            margin-right: 10px;
            font-size: 18px;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 30px;
        }

        .top-bar {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .top-bar h1 {
            color: #333;
            font-size: 28px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .logout-btn {
            padding: 8px 20px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s ease;
        }

        .logout-btn:hover {
            background: #c82333;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card h3 {
            color: #666;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .stat-value {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .stat-change {
            font-size: 14px;
            color: #28a745;
        }

        .stat-change.negative {
            color: #dc3545;
        }

        /* Content Sections */
        .content-section {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .section-header h2 {
            color: #333;
            font-size: 22px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: #28a745;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #333;
        }

        /* Tables */
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th,
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }

        .data-table th {
            background: #f8f9fa;
            color: #333;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
        }

        .data-table tr:hover {
            background: #f8f9fa;
        }

        .badge {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-success {
            background: #d4edda;
            color: #155724;
        }

        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }

        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }

        .badge-info {
            background: #d1ecf1;
            color: #0c5460;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: scale(1.05);
        }

        /* Loading State */
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Tabs */
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .tab {
            padding: 12px 24px;
            background: transparent;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }

        .tab:hover {
            color: #667eea;
        }

        .tab.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* Forms */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
        }

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            max-width: 600px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .modal-header h3 {
            color: #333;
            font-size: 20px;
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
        }

        .close-modal:hover {
            color: #333;
        }
    </style>
</head>
<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h2>🛡️ CyberSkill Admin</h2>
            </div>
            <ul class="sidebar-nav">
                <li><a href="#" class="active" data-section="overview"><span>📊</span> Overview</a></li>
                <li><a href="#" data-section="users"><span>👥</span> Users</a></li>
                <li><a href="#" data-section="paths"><span>🎯</span> Learning Paths</a></li>
                <li><a href="#" data-section="modules"><span>📚</span> Modules</a></li>
                <li><a href="#" data-section="sections"><span>📖</span> Sections</a></li>
                <li><a href="#" data-section="lessons"><span>📝</span> Lessons</a></li>
                <li><a href="#" data-section="quizzes"><span>❓</span> Quizzes</a></li>
                <li><a href="#" data-section="badges"><span>🏆</span> Badges</a></li>
                <li><a href="#" data-section="certificates"><span>🎓</span> Certificates</a></li>
                <li><a href="#" data-section="analytics"><span>📈</span> Analytics</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Top Bar -->
            <div class="top-bar">
                <h1 id="page-title">Dashboard Overview</h1>
                <div class="user-info">
                    <div class="user-avatar">A</div>
                    <span>Admin User</span>
                    <button class="logout-btn" onclick="logout()">Logout</button>
                </div>
            </div>

            <!-- Overview Section -->
            <div id="overview-section" class="section-content">
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total Users</h3>
                        <div class="stat-value" id="total-users">-</div>
                        <div class="stat-change">Loading...</div>
                    </div>
                    <div class="stat-card">
                        <h3>Active Learners</h3>
                        <div class="stat-value" id="active-learners">-</div>
                        <div class="stat-change">Loading...</div>
                    </div>
                    <div class="stat-card">
                        <h3>Certificates Issued</h3>
                        <div class="stat-value" id="total-certificates">-</div>
                        <div class="stat-change">Loading...</div>
                    </div>
                    <div class="stat-card">
                        <h3>Badges Awarded</h3>
                        <div class="stat-value" id="total-badges">-</div>
                        <div class="stat-change">Loading...</div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="content-section">
                    <div class="section-header">
                        <h2>Recent Activity</h2>
                    </div>
                    <div id="recent-activity" class="loading">
                        <div class="spinner"></div>
                        <p>Loading recent activity...</p>
                    </div>
                </div>
            </div>

            <!-- Users Section -->
            <div id="users-section" class="section-content" style="display: none;">
                <div class="content-section">
                    <div class="section-header">
                        <h2>User Management</h2>
                        <button class="btn btn-primary" onclick="showAddUserModal()">+ Add User</button>
                    </div>
                    <div id="users-list" class="loading">
                        <div class="spinner"></div>
                        <p>Loading users...</p>
                    </div>
                </div>
            </div>

            <!-- Learning Paths Section -->
            <div id="paths-section" class="section-content" style="display: none;">
                <div class="content-section">
                    <div class="section-header">
                        <h2>Learning Paths</h2>
                        <button class="btn btn-primary" onclick="showAddPathModal()">+ Add Path</button>
                    </div>
                    <div id="paths-list" class="loading">
                        <div class="spinner"></div>
                        <p>Loading learning paths...</p>
                    </div>
                </div>
            </div>

            <!-- Badges Section -->
            <div id="badges-section" class="section-content" style="display: none;">
                <div class="content-section">
                    <div class="section-header">
                        <h2>Badge Management</h2>
                        <button class="btn btn-primary" onclick="showAddBadgeModal()">+ Create Badge</button>
                    </div>
                    <div id="badges-list" class="loading">
                        <div class="spinner"></div>
                        <p>Loading badges...</p>
                    </div>
                </div>
            </div>

            <!-- Certificates Section -->
            <div id="certificates-section" class="section-content" style="display: none;">
                <div class="content-section">
                    <div class="section-header">
                        <h2>Certificate Management</h2>
                    </div>
                    <div id="certificates-list" class="loading">
                        <div class="spinner"></div>
                        <p>Loading certificates...</p>
                    </div>
                </div>
            </div>

            <!-- Analytics Section -->
            <div id="analytics-section" class="section-content" style="display: none;">
                <div class="content-section">
                    <div class="section-header">
                        <h2>Platform Analytics</h2>
                    </div>
                    <div id="analytics-content" class="loading">
                        <div class="spinner"></div>
                        <p>Loading analytics...</p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Modal Template -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modal-title">Modal Title</h3>
                <button class="close-modal" onclick="closeModal()">&times;</button>
            </div>
            <div id="modal-body">
                <!-- Dynamic content -->
            </div>
        </div>
    </div>

    <script>
        // Navigation
        document.querySelectorAll('.sidebar-nav a').forEach(function(link) {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                var section = this.getAttribute('data-section');
                switchSection(section);
            });
        });

        function switchSection(section) {
            // Update active nav link
            document.querySelectorAll('.sidebar-nav a').forEach(function(link) {
                link.classList.remove('active');
            });
            document.querySelector('[data-section="' + section + '"]').classList.add('active');

            // Hide all sections
            document.querySelectorAll('.section-content').forEach(function(content) {
                content.style.display = 'none';
            });

            // Show selected section
            var sectionElement = document.getElementById(section + '-section');
            if (sectionElement) {
                sectionElement.style.display = 'block';
            }

            // Update page title
            var titles = {
                'overview': 'Dashboard Overview',
                'users': 'User Management',
                'paths': 'Learning Paths',
                'modules': 'Modules',
                'sections': 'Sections',
                'lessons': 'Lessons',
                'quizzes': 'Quizzes',
                'badges': 'Badge Management',
                'certificates': 'Certificate Management',
                'analytics': 'Platform Analytics'
            };
            document.getElementById('page-title').textContent = titles[section] || 'Admin Dashboard';

            // Load section data
            loadSectionData(section);
        }

        function loadSectionData(section) {
            switch(section) {
                case 'overview':
                    loadOverviewData();
                    break;
                case 'users':
                    loadUsers();
                    break;
                case 'paths':
                    loadPaths();
                    break;
                case 'badges':
                    loadBadges();
                    break;
                case 'certificates':
                    loadCertificates();
                    break;
                case 'analytics':
                    loadAnalytics();
                    break;
            }
        }

        // Load Overview Data
        function loadOverviewData() {
            // Load statistics
            fetch('/api/admin/analytics/overview', {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                }
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                document.getElementById('total-users').textContent = data.totalUsers || '0';
                document.getElementById('active-learners').textContent = data.activeLearners || '0';
                document.getElementById('total-certificates').textContent = data.totalCertificates || '0';
                document.getElementById('total-badges').textContent = data.totalBadges || '0';
            })
            .catch(function(error) {
                console.error('Error loading overview:', error);
            });
        }

        // Load Users
        function loadUsers() {
            var container = document.getElementById('users-list');
            container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Loading users...</p></div>';

            fetch('/api/admin/users', {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                }
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var html = '<table class="data-table"><thead><tr><th>Username</th><th>Email</th><th>Role</th><th>Status</th><th>Actions</th></tr></thead><tbody>';
                
                if (data.users && data.users.length > 0) {
                    data.users.forEach(function(user) {
                        html += '<tr>';
                        html += '<td>' + user.username + '</td>';
                        html += '<td>' + user.email + '</td>';
                        html += '<td><span class="badge badge-info">' + user.role + '</span></td>';
                        html += '<td><span class="badge badge-success">Active</span></td>';
                        html += '<td><div class="action-buttons">';
                        html += '<button class="action-btn btn-warning" onclick="editUser(\'' + user.id + '\')">Edit</button>';
                        html += '<button class="action-btn btn-danger" onclick="deleteUser(\'' + user.id + '\')">Delete</button>';
                        html += '</div></td>';
                        html += '</tr>';
                    });
                } else {
                    html += '<tr><td colspan="5" style="text-align: center;">No users found</td></tr>';
                }
                
                html += '</tbody></table>';
                container.innerHTML = html;
            })
            .catch(function(error) {
                console.error('Error loading users:', error);
                container.innerHTML = '<p style="color: red;">Error loading users</p>';
            });
        }

        // Load Learning Paths
        function loadPaths() {
            var container = document.getElementById('paths-list');
            container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Loading paths...</p></div>';

            fetch('/api/paths')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var html = '<table class="data-table"><thead><tr><th>Name</th><th>Slug</th><th>Description</th><th>Actions</th></tr></thead><tbody>';
                
                if (data.paths && data.paths.length > 0) {
                    data.paths.forEach(function(path) {
                        html += '<tr>';
                        html += '<td>' + path.name + '</td>';
                        html += '<td>' + path.slug + '</td>';
                        html += '<td>' + (path.description || 'N/A') + '</td>';
                        html += '<td><div class="action-buttons">';
                        html += '<button class="action-btn btn-primary" onclick="viewPath(\'' + path.id + '\')">View</button>';
                        html += '<button class="action-btn btn-warning" onclick="editPath(\'' + path.id + '\')">Edit</button>';
                        html += '<button class="action-btn btn-danger" onclick="deletePath(\'' + path.id + '\')">Delete</button>';
                        html += '</div></td>';
                        html += '</tr>';
                    });
                } else {
                    html += '<tr><td colspan="4" style="text-align: center;">No learning paths found</td></tr>';
                }
                
                html += '</tbody></table>';
                container.innerHTML = html;
            })
            .catch(function(error) {
                console.error('Error loading paths:', error);
                container.innerHTML = '<p style="color: red;">Error loading learning paths</p>';
            });
        }

        // Load Badges
        function loadBadges() {
            var container = document.getElementById('badges-list');
            container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Loading badges...</p></div>';

            fetch('/api/badges')
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var html = '<table class="data-table"><thead><tr><th>Name</th><th>Type</th><th>Description</th><th>Actions</th></tr></thead><tbody>';
                
                if (data.badges && data.badges.length > 0) {
                    data.badges.forEach(function(badge) {
                        html += '<tr>';
                        html += '<td>' + badge.name + '</td>';
                        html += '<td><span class="badge badge-info">' + badge.type + '</span></td>';
                        html += '<td>' + (badge.description || 'N/A') + '</td>';
                        html += '<td><div class="action-buttons">';
                        html += '<button class="action-btn btn-warning" onclick="editBadge(\'' + badge.id + '\')">Edit</button>';
                        html += '<button class="action-btn btn-danger" onclick="deleteBadge(\'' + badge.id + '\')">Delete</button>';
                        html += '</div></td>';
                        html += '</tr>';
                    });
                } else {
                    html += '<tr><td colspan="4" style="text-align: center;">No badges found</td></tr>';
                }
                
                html += '</tbody></table>';
                container.innerHTML = html;
            })
            .catch(function(error) {
                console.error('Error loading badges:', error);
                container.innerHTML = '<p style="color: red;">Error loading badges</p>';
            });
        }

        // Load Certificates
        function loadCertificates() {
            var container = document.getElementById('certificates-list');
            container.innerHTML = '<div class="loading"><div class="spinner"></div><p>Loading certificates...</p></div>';

            fetch('/api/admin/certificates/statistics', {
                headers: {
                    'Authorization': 'Bearer ' + localStorage.getItem('accessToken')
                }
            })
            .then(function(response) { return response.json(); })
            .then(function(data) {
                var html = '<div class="stats-grid">';
                html += '<div class="stat-card"><h3>Total Issued</h3><div class="stat-value">' + (data.totalIssued || 0) + '</div></div>';
                html += '<div class="stat-card"><h3>This Month</h3><div class="stat-value">' + (data.thisMonth || 0) + '</div></div>';
                html += '<div class="stat-card"><h3>Valid</h3><div class="stat-value">' + (data.valid || 0) + '</div></div>';
                html += '<div class="stat-card"><h3>Revoked</h3><div class="stat-value">' + (data.revoked || 0) + '</div></div>';
                html += '</div>';
                container.innerHTML = html;
            })
            .catch(function(error) {
                console.error('Error loading certificates:', error);
                container.innerHTML = '<p style="color: red;">Error loading certificates</p>';
            });
        }

        // Load Analytics
        function loadAnalytics() {
            var container = document.getElementById('analytics-content');
            container.innerHTML = '<p>Analytics dashboard coming soon...</p>';
        }

        // Modal Functions
        function showModal(title, content) {
            document.getElementById('modal-title').textContent = title;
            document.getElementById('modal-body').innerHTML = content;
            document.getElementById('modal').classList.add('active');
        }

        function closeModal() {
            document.getElementById('modal').classList.remove('active');
        }

        function showAddUserModal() {
            var content = '<form onsubmit="addUser(event)"><div class="form-group"><label>Username</label><input type="text" class="form-control" name="username" required></div><div class="form-group"><label>Email</label><input type="email" class="form-control" name="email" required></div><div class="form-group"><label>Password</label><input type="password" class="form-control" name="password" required></div><div class="form-group"><label>Role</label><select class="form-control" name="role"><option value="USER">User</option><option value="ADMIN">Admin</option></select></div><button type="submit" class="btn btn-primary">Add User</button></form>';
            showModal('Add New User', content);
        }

        function showAddPathModal() {
            var content = '<form onsubmit="addPath(event)"><div class="form-group"><label>Name</label><input type="text" class="form-control" name="name" required></div><div class="form-group"><label>Slug</label><input type="text" class="form-control" name="slug" required></div><div class="form-group"><label>Description</label><textarea class="form-control" name="description"></textarea></div><button type="submit" class="btn btn-primary">Create Path</button></form>';
            showModal('Create Learning Path', content);
        }

        function showAddBadgeModal() {
            var content = '<form onsubmit="addBadge(event)"><div class="form-group"><label>Name</label><input type="text" class="form-control" name="name" required></div><div class="form-group"><label>Type</label><select class="form-control" name="type"><option value="SECTION_COMPLETION">Section Completion</option><option value="MODULE_COMPLETION">Module Completion</option><option value="PATH_COMPLETION">Path Completion</option><option value="QUIZ_MASTERY">Quiz Mastery</option><option value="STREAK_ACHIEVEMENT">Streak Achievement</option></select></div><div class="form-group"><label>Description</label><textarea class="form-control" name="description"></textarea></div><button type="submit" class="btn btn-primary">Create Badge</button></form>';
            showModal('Create Badge', content);
        }

        // Logout
        function logout() {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            window.location.href = '/login';
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            loadOverviewData();
        });
    </script>
</body>
</html>