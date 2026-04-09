<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CyberSkill - Cybersecurity Learning Platform</title>
    <link rel="stylesheet" href="/css/styles.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="logo">
                <h1>🛡️ CyberSkill</h1>
            </div>
            <nav class="nav">
                <a href="/">Home</a>
                <a href="/login">Login</a>
                <a href="/register">Register</a>
            </nav>
        </div>
    </header>

    <main class="main">
        <section class="hero">
            <div class="container">
                <h1>Master Cybersecurity Skills</h1>
                <p class="hero-subtitle">
                    Enterprise-grade learning platform for cybersecurity professionals
                </p>
                <div class="hero-actions">
                    <a href="/register" class="btn btn-primary">Get Started</a>
                    <a href="/login" class="btn btn-secondary">Sign In</a>
                </div>
            </div>
        </section>

        <section class="learning-paths">
            <div class="container">
                <h2>Learning Paths</h2>
                <div class="paths-grid">
                    <#if learningPaths??>
                        <#list learningPaths as path>
                            <div class="path-card">
                                <div class="path-icon">${path.icon}</div>
                                <h3>${path.name}</h3>
                                <p>${path.description}</p>
                                <span class="path-duration">${path.estimatedHours} hours</span>
                            </div>
                        </#list>
                    <#else>
                        <p>No learning paths available at the moment.</p>
                    </#if>
                </div>
            </div>
        </section>

        <section class="features">
            <div class="container">
                <h2>Platform Features</h2>
                <div class="features-grid">
                    <div class="feature">
                        <h3>📚 Structured Learning</h3>
                        <p>Follow comprehensive learning paths with modules, sections, and lessons</p>
                    </div>
                    <div class="feature">
                        <h3>✅ Progress Tracking</h3>
                        <p>Monitor your progress with detailed analytics and completion metrics</p>
                    </div>
                    <div class="feature">
                        <h3>🎯 Assessments</h3>
                        <p>Test your knowledge with quizzes and earn completion certificates</p>
                    </div>
                    <div class="feature">
                        <h3>🏆 Achievements</h3>
                        <p>Earn badges and certificates as you complete learning milestones</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2026 CyberSkill Platform. All rights reserved.</p>
            <p>Built with Java Vert.x and Freemarker</p>
        </div>
    </footer>

    <script src="/js/main.js"></script>
</body>
</html>