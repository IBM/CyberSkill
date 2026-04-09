<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Path - CyberSkill Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .learning-path-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .path-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .path-header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5em;
        }
        
        .path-meta {
            display: flex;
            gap: 30px;
            margin-top: 20px;
        }
        
        .path-meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .modules-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .module-card {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .module-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .module-title {
            font-size: 1.5em;
            color: #333;
            margin: 0;
        }
        
        .module-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
        }
        
        .status-locked {
            background: #f0f0f0;
            color: #666;
        }
        
        .status-available {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .status-in-progress {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .status-completed {
            background: #e8f5e9;
            color: #388e3c;
        }
        
        .sections-list {
            list-style: none;
            padding: 0;
            margin: 15px 0;
        }
        
        .section-item {
            padding: 15px;
            border-left: 3px solid #667eea;
            margin-bottom: 10px;
            background: #f9f9f9;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .section-item:hover {
            background: #f0f0f0;
            transform: translateX(5px);
        }
        
        .section-item.locked {
            border-left-color: #ccc;
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .section-title {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        
        .section-meta {
            display: flex;
            gap: 20px;
            font-size: 0.9em;
            color: #666;
        }
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            margin-top: 15px;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s;
        }
        
        .back-button {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
            transition: background 0.3s;
        }
        
        .back-button:hover {
            background: #5568d3;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="learning-path-container">
        <a href="/dashboard" class="back-button">← Back to Dashboard</a>
        
        <div id="loading" class="loading">
            <h2>Loading learning path...</h2>
        </div>
        
        <div id="error" class="error-message" style="display: none;"></div>
        
        <div id="pathContent" style="display: none;">
            <div class="path-header">
                <h1 id="pathName">Loading...</h1>
                <p id="pathDescription"></p>
                <div class="path-meta">
                    <div class="path-meta-item">
                        <span>📚</span>
                        <span id="moduleCount">0 modules</span>
                    </div>
                    <div class="path-meta-item">
                        <span>⏱️</span>
                        <span id="estimatedHours">0 hours</span>
                    </div>
                    <div class="path-meta-item">
                        <span>📊</span>
                        <span id="progressPercent">0% complete</span>
                    </div>
                </div>
                <div class="progress-bar">
                    <div id="progressBar" class="progress-fill" style="width: 0%"></div>
                </div>
            </div>
            
            <div id="modulesContainer" class="modules-container"></div>
        </div>
    </div>

    <script>
        const pathId = ${pathId};
        const accessToken = localStorage.getItem('accessToken');
        
        if (!accessToken) {
            window.location.href = '/login';
        }
        
        // Load learning path details
        async function loadPathDetails() {
            try {
                const response = await fetch('/api/paths/' + pathId, {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (!response.ok) {
                    throw new Error('Failed to load learning path');
                }
                
                const path = await response.json();
                displayPath(path);
            } catch (error) {
                console.error('Error loading path:', error);
                document.getElementById('loading').style.display = 'none';
                document.getElementById('error').style.display = 'block';
                document.getElementById('error').textContent = 'Failed to load learning path. Please try again.';
            }
        }
        
        // Display path information
        function displayPath(path) {
            document.getElementById('pathName').textContent = path.name;
            document.getElementById('pathDescription').textContent = path.description;
            document.getElementById('estimatedHours').textContent = path.estimatedHours + ' hours';
            
            // TODO: Get actual progress from API
            const progress = 0;
            document.getElementById('progressPercent').textContent = progress + '% complete';
            document.getElementById('progressBar').style.width = progress + '%';
            
            // Load modules
            loadModules();
        }
        
        // Load modules for this path
        async function loadModules() {
            try {
                const response = await fetch('/api/paths/' + pathId + '/modules', {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (!response.ok) {
                    throw new Error('Failed to load modules');
                }
                
                const modules = await response.json();
                displayModules(modules);
                
                document.getElementById('loading').style.display = 'none';
                document.getElementById('pathContent').style.display = 'block';
                document.getElementById('moduleCount').textContent = modules.length + ' modules';
            } catch (error) {
                console.error('Error loading modules:', error);
                document.getElementById('loading').style.display = 'none';
                document.getElementById('pathContent').style.display = 'block';
                displayNoModules();
            }
        }
        
        // Display modules
        function displayModules(modules) {
            const container = document.getElementById('modulesContainer');
            
            if (modules.length === 0) {
                displayNoModules();
                return;
            }
            
            container.innerHTML = modules.map((module, index) =>
                '<div class="module-card" id="module-' + module.id + '">' +
                    '<div class="module-header">' +
                        '<h2 class="module-title">' + (index + 1) + '. ' + module.name + '</h2>' +
                        '<span class="module-status status-available">Available</span>' +
                    '</div>' +
                    '<p>' + module.description + '</p>' +
                    '<p><strong>Duration:</strong> ' + module.estimatedHours + ' hours</p>' +
                    '<div class="sections-container" id="sections-' + module.id + '">' +
                        '<p style="color: #666; font-style: italic;">Loading sections...</p>' +
                    '</div>' +
                '</div>'
            ).join('');
            
            // Load sections for each module
            modules.forEach(module => loadSections(module.id));
        }
        
        // Load sections for a module
        async function loadSections(moduleId) {
            try {
                const response = await fetch('/api/modules/' + moduleId + '/sections', {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (!response.ok) {
                    throw new Error('Failed to load sections');
                }
                
                const sections = await response.json();
                displaySections(moduleId, sections);
            } catch (error) {
                console.error('Error loading sections for module ' + moduleId + ':', error);
                document.getElementById('sections-' + moduleId).innerHTML =
                    '<p style="color: #999;">Sections coming soon</p>';
            }
        }
        
        // Display sections for a module
        function displaySections(moduleId, sections) {
            const container = document.getElementById('sections-' + moduleId);
            
            if (sections.length === 0) {
                container.innerHTML = '<p style="color: #999;">No sections available yet</p>';
                return;
            }
            
            container.innerHTML =
                '<ul class="sections-list">' +
                sections.map(section =>
                    '<li class="section-item" onclick="loadLessons(' + section.id + ', this)">' +
                        '<div class="section-title">' + section.name + '</div>' +
                        '<div class="section-meta">' +
                            '<span>📚 Click to view lessons</span>' +
                        '</div>' +
                        '<div class="lessons-container" id="lessons-' + section.id + '" style="display: none;"></div>' +
                    '</li>'
                ).join('') +
                '</ul>';
        }
        
        // Load lessons for a section
        async function loadLessons(sectionId, element) {
            const lessonsContainer = document.getElementById('lessons-' + sectionId);
            
            // Toggle visibility
            if (lessonsContainer.style.display === 'block') {
                lessonsContainer.style.display = 'none';
                return;
            }
            
            // If already loaded, just show
            if (lessonsContainer.innerHTML) {
                lessonsContainer.style.display = 'block';
                return;
            }
            
            // Load lessons
            try {
                const response = await fetch('/api/sections/' + sectionId + '/lessons', {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (!response.ok) {
                    throw new Error('Failed to load lessons');
                }
                
                const lessons = await response.json();
                displayLessons(sectionId, lessons);
                lessonsContainer.style.display = 'block';
            } catch (error) {
                console.error('Error loading lessons:', error);
                lessonsContainer.innerHTML = '<p style="color: #999; padding: 10px;">Lessons coming soon</p>';
                lessonsContainer.style.display = 'block';
            }
        }
        
        // Display lessons
        function displayLessons(sectionId, lessons) {
            const container = document.getElementById('lessons-' + sectionId);
            
            if (lessons.length === 0) {
                container.innerHTML = '<p style="color: #999; padding: 10px;">No lessons available yet</p>';
                return;
            }
            
            container.innerHTML =
                '<ul style="list-style: none; padding: 10px 0 0 20px; margin: 0;">' +
                lessons.map((lesson, index) =>
                    '<li style="margin-bottom: 8px;">' +
                        '<a href="/lesson/' + lesson.id + '" style="color: #667eea; text-decoration: none; display: flex; align-items: center; gap: 8px;">' +
                            '<span>' + (index + 1) + '.</span>' +
                            '<span>' + lesson.name + '</span>' +
                            '<span style="color: #999; font-size: 0.85em;">(' + lesson.estimatedMinutes + ' min)</span>' +
                        '</a>' +
                    '</li>'
                ).join('') +
                '</ul>';
        }
        
        // Display no modules message
        function displayNoModules() {
            const container = document.getElementById('modulesContainer');
            document.getElementById('moduleCount').textContent = 'Coming soon';
            
            container.innerHTML =
                '<div class="module-card">' +
                    '<div class="module-header">' +
                        '<h2 class="module-title">📚 Modules Coming Soon</h2>' +
                        '<span class="module-status status-available">In Development</span>' +
                    '</div>' +
                    '<p>We are currently building the module content for this learning path.</p>' +
                    '<p>This learning path will include:</p>' +
                    '<ul style="margin-left: 20px;">' +
                        '<li>Interactive lessons and tutorials</li>' +
                        '<li>Hands-on labs and exercises</li>' +
                        '<li>Quizzes and assessments</li>' +
                        '<li>Real-world scenarios and case studies</li>' +
                        '<li>Completion badges and certificates</li>' +
                    '</ul>' +
                    '<p><em>Check back soon for updates!</em></p>' +
                '</div>';
        }
        
        // Load on page load
        loadPathDetails();
    </script>
</body>
</html>