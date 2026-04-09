<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lesson - CyberSkill Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        .lesson-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .lesson-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .lesson-header h1 {
            margin: 0 0 10px 0;
            font-size: 2em;
        }
        
        .breadcrumb {
            display: flex;
            gap: 10px;
            align-items: center;
            font-size: 0.9em;
            margin-bottom: 20px;
            color: rgba(255,255,255,0.9);
        }
        
        .breadcrumb a {
            color: white;
            text-decoration: none;
            transition: opacity 0.3s;
        }
        
        .breadcrumb a:hover {
            opacity: 0.8;
        }
        
        .breadcrumb-separator {
            opacity: 0.6;
        }
        
        .lesson-meta {
            display: flex;
            gap: 20px;
            margin-top: 15px;
        }
        
        .lesson-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .lesson-content-area {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .main-content {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .content-type-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            margin-bottom: 20px;
        }
        
        .type-text {
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .type-video {
            background: #fce4ec;
            color: #c2185b;
        }
        
        .type-interactive {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .type-pdf {
            background: #fff3e0;
            color: #f57c00;
        }
        
        .lesson-text-content {
            line-height: 1.8;
            font-size: 1.1em;
            color: #333;
        }
        
        .lesson-text-content h2 {
            color: #667eea;
            margin-top: 30px;
            margin-bottom: 15px;
        }
        
        .lesson-text-content h3 {
            color: #764ba2;
            margin-top: 25px;
            margin-bottom: 12px;
        }
        
        .lesson-text-content p {
            margin-bottom: 15px;
        }
        
        .lesson-text-content ul, .lesson-text-content ol {
            margin-left: 30px;
            margin-bottom: 15px;
        }
        
        .lesson-text-content li {
            margin-bottom: 8px;
        }
        
        .lesson-text-content code {
            background: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
        }
        
        .lesson-text-content pre {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            margin: 20px 0;
        }
        
        .video-container {
            position: relative;
            padding-bottom: 56.25%;
            height: 0;
            overflow: hidden;
            margin: 20px 0;
            border-radius: 8px;
        }
        
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .sidebar {
            position: sticky;
            top: 20px;
            height: fit-content;
        }
        
        .progress-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .progress-card h3 {
            margin: 0 0 15px 0;
            font-size: 1.1em;
            color: #333;
        }
        
        .complete-button {
            width: 100%;
            padding: 15px;
            background: #4caf50;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .complete-button:hover {
            background: #45a049;
        }
        
        .complete-button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        .complete-button.completed {
            background: #2196f3;
        }
        
        .navigation-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .navigation-card h3 {
            margin: 0 0 15px 0;
            font-size: 1.1em;
            color: #333;
        }
        
        .nav-button {
            width: 100%;
            padding: 12px;
            margin-bottom: 10px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 0.95em;
            cursor: pointer;
            transition: background 0.3s;
            text-align: left;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .nav-button:hover {
            background: #5568d3;
        }
        
        .nav-button:disabled {
            background: #ccc;
            cursor: not-allowed;
            opacity: 0.6;
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
        
        @media (max-width: 968px) {
            .lesson-content-area {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                position: static;
            }
        }
    </style>
</head>
<body>
    <div class="lesson-container">
        <a href="/dashboard" class="back-button">← Back to Dashboard</a>
        
        <div id="loading" class="loading">
            <h2>Loading lesson...</h2>
        </div>
        
        <div id="error" class="error-message" style="display: none;"></div>
        
        <div id="lessonContent" style="display: none;">
            <div class="lesson-header">
                <div class="breadcrumb">
                    <a href="/dashboard">Dashboard</a>
                    <span class="breadcrumb-separator">›</span>
                    <a href="#" id="pathLink">Loading...</a>
                    <span class="breadcrumb-separator">›</span>
                    <span id="lessonBreadcrumb">Lesson</span>
                </div>
                <h1 id="lessonName">Loading...</h1>
                <div class="lesson-meta">
                    <div class="lesson-meta-item">
                        <span>⏱️</span>
                        <span id="estimatedTime">0 minutes</span>
                    </div>
                    <div class="lesson-meta-item">
                        <span>📄</span>
                        <span id="contentTypeDisplay">Text</span>
                    </div>
                </div>
            </div>
            
            <div class="lesson-content-area">
                <div class="main-content">
                    <div id="contentTypeBadge" class="content-type-badge type-text">TEXT</div>
                    <div id="lessonContentDisplay"></div>
                </div>
                
                <div class="sidebar">
                    <div class="progress-card">
                        <h3>Your Progress</h3>
                        <button id="completeButton" class="complete-button">
                            ✓ Mark as Complete
                        </button>
                    </div>
                    
                    <div class="navigation-card">
                        <h3>Navigation</h3>
                        <button id="prevButton" class="nav-button">
                            ← Previous Lesson
                        </button>
                        <button id="nextButton" class="nav-button">
                            Next Lesson →
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const lessonId = ${lessonId};
        const accessToken = localStorage.getItem('accessToken');
        
        if (!accessToken) {
            window.location.href = '/login';
        }
        
        let currentLesson = null;
        let allLessons = [];
        let currentIndex = -1;
        
        // Load lesson details
        async function loadLesson() {
            try {
                const response = await fetch('/api/lessons/' + lessonId, {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (!response.ok) {
                    throw new Error('Failed to load lesson');
                }
                
                currentLesson = await response.json();
                displayLesson(currentLesson);
                loadSectionLessons(currentLesson.sectionId);
            } catch (error) {
                console.error('Error loading lesson:', error);
                document.getElementById('loading').style.display = 'none';
                document.getElementById('error').style.display = 'block';
                document.getElementById('error').textContent = 'Failed to load lesson. Please try again.';
            }
        }
        
        // Load all lessons in the section for navigation
        async function loadSectionLessons(sectionId) {
            try {
                const response = await fetch('/api/sections/' + sectionId + '/lessons', {
                    headers: {
                        'Authorization': 'Bearer ' + accessToken
                    }
                });
                
                if (response.ok) {
                    allLessons = await response.json();
                    currentIndex = allLessons.findIndex(l => l.id === lessonId);
                    updateNavigationButtons();
                }
            } catch (error) {
                console.error('Error loading section lessons:', error);
            }
        }
        
        // Display lesson content
        function displayLesson(lesson) {
            document.getElementById('lessonName').textContent = lesson.name;
            document.getElementById('lessonBreadcrumb').textContent = lesson.name;
            document.getElementById('estimatedTime').textContent = lesson.estimatedMinutes + ' minutes';
            document.getElementById('contentTypeDisplay').textContent = lesson.contentType.toUpperCase();
            
            // Update content type badge
            const badge = document.getElementById('contentTypeBadge');
            badge.textContent = lesson.contentType.toUpperCase();
            badge.className = 'content-type-badge type-' + lesson.contentType;
            
            // Display content based on type
            const contentDisplay = document.getElementById('lessonContentDisplay');
            
            if (lesson.contentType === 'video' && lesson.videoUrl) {
                contentDisplay.innerHTML = 
                    '<div class="video-container">' +
                        '<iframe src="' + lesson.videoUrl + '" allowfullscreen></iframe>' +
                    '</div>' +
                    '<div class="lesson-text-content">' + formatContent(lesson.content) + '</div>';
            } else if (lesson.contentType === 'pdf') {
                contentDisplay.innerHTML = 
                    '<p><strong>PDF Document:</strong></p>' +
                    '<p><a href="' + lesson.content + '" target="_blank">Open PDF in new tab</a></p>';
            } else {
                contentDisplay.innerHTML = 
                    '<div class="lesson-text-content">' + formatContent(lesson.content) + '</div>';
            }
            
            document.getElementById('loading').style.display = 'none';
            document.getElementById('lessonContent').style.display = 'block';
        }
        
        // Format content (convert markdown-like syntax to HTML)
        function formatContent(content) {
            if (!content) return '<p>No content available.</p>';
            
            // Simple formatting - in production, use a proper markdown parser
            return content
                .replace(/\n\n/g, '</p><p>')
                .replace(/\n/g, '<br>')
                .replace(/^(.+)$/, '<p>' + content + '</p>');
        }
        
        // Update navigation buttons
        function updateNavigationButtons() {
            const prevButton = document.getElementById('prevButton');
            const nextButton = document.getElementById('nextButton');
            
            if (currentIndex > 0) {
                prevButton.disabled = false;
                prevButton.onclick = () => navigateToLesson(allLessons[currentIndex - 1].id);
            } else {
                prevButton.disabled = true;
            }
            
            if (currentIndex < allLessons.length - 1) {
                nextButton.disabled = false;
                nextButton.onclick = () => navigateToLesson(allLessons[currentIndex + 1].id);
            } else {
                nextButton.disabled = true;
            }
        }
        
        // Navigate to another lesson
        function navigateToLesson(newLessonId) {
            window.location.href = '/lesson/' + newLessonId;
        }
        
        // Mark lesson as complete
        document.getElementById('completeButton').onclick = function() {
            // TODO: Implement progress tracking API call
            const button = this;
            button.textContent = '✓ Completed!';
            button.classList.add('completed');
            button.disabled = true;
            
            // Navigate to next lesson after 1 second
            if (currentIndex < allLessons.length - 1) {
                setTimeout(() => {
                    navigateToLesson(allLessons[currentIndex + 1].id);
                }, 1000);
            }
        };
        
        // Load lesson on page load
        loadLesson();
    </script>
</body>
</html>