<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz - CyberSkill Platform</title>
    <link rel="stylesheet" href="/static/css/styles.css">
    <style>
        .quiz-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }

        .quiz-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
        }

        .quiz-header h1 {
            margin: 0 0 10px 0;
            font-size: 28px;
        }

        .quiz-info {
            display: flex;
            gap: 30px;
            margin-top: 15px;
            font-size: 14px;
        }

        .quiz-info-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .quiz-info-item svg {
            width: 20px;
            height: 20px;
        }

        .quiz-progress {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 10px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s ease;
        }

        .progress-text {
            font-size: 14px;
            color: #666;
        }

        .question-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .question-number {
            font-size: 14px;
            font-weight: 600;
            color: #667eea;
        }

        .question-points {
            font-size: 14px;
            color: #666;
            background: #f0f0f0;
            padding: 4px 12px;
            border-radius: 12px;
        }

        .question-text {
            font-size: 18px;
            font-weight: 500;
            color: #333;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .question-type-badge {
            display: inline-block;
            font-size: 12px;
            padding: 4px 10px;
            border-radius: 4px;
            background: #e3f2fd;
            color: #1976d2;
            margin-bottom: 15px;
        }

        .answers-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .answer-option {
            position: relative;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px 20px;
            cursor: pointer;
            transition: all 0.2s ease;
            background: white;
        }

        .answer-option:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .answer-option input[type="radio"],
        .answer-option input[type="checkbox"] {
            margin-right: 12px;
            cursor: pointer;
        }

        .answer-option.selected {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .answer-option.correct {
            border-color: #4caf50;
            background: #f1f8f4;
        }

        .answer-option.incorrect {
            border-color: #f44336;
            background: #fef5f5;
        }

        .answer-label {
            cursor: pointer;
            display: flex;
            align-items: center;
            font-size: 16px;
            color: #333;
        }

        .explanation-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            margin-top: 15px;
            border-radius: 4px;
            display: none;
        }

        .explanation-box.show {
            display: block;
        }

        .explanation-title {
            font-weight: 600;
            color: #856404;
            margin-bottom: 8px;
        }

        .explanation-text {
            color: #856404;
            line-height: 1.5;
        }

        .quiz-navigation {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f0f0f0;
            color: #333;
        }

        .btn-secondary:hover {
            background: #e0e0e0;
        }

        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .timer-container {
            position: fixed;
            top: 80px;
            right: 20px;
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            z-index: 100;
        }

        .timer-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }

        .timer-value {
            font-size: 24px;
            font-weight: 600;
            color: #667eea;
        }

        .timer-value.warning {
            color: #ff9800;
        }

        .timer-value.danger {
            color: #f44336;
        }

        .results-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }

        .results-score {
            font-size: 72px;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 20px 0;
        }

        .results-status {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 30px;
        }

        .results-status.passed {
            color: #4caf50;
        }

        .results-status.failed {
            color: #f44336;
        }

        .results-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }

        .result-detail {
            padding: 20px;
            background: #f8f9ff;
            border-radius: 8px;
        }

        .result-detail-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
        }

        .result-detail-value {
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }

        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
        }

        @media (max-width: 768px) {
            .quiz-container {
                padding: 10px;
            }

            .quiz-header {
                padding: 20px;
            }

            .quiz-info {
                flex-direction: column;
                gap: 10px;
            }

            .timer-container {
                position: static;
                margin-bottom: 20px;
            }

            .results-score {
                font-size: 48px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="/" class="nav-brand">CyberSkill Platform</a>
            <div class="nav-links">
                <a href="/dashboard">Dashboard</a>
                <a href="#" onclick="logout()">Logout</a>
            </div>
        </div>
    </nav>

    <div class="quiz-container">
        <!-- Loading State -->
        <div id="loadingState" style="text-align: center; padding: 60px;">
            <div class="loading-spinner" style="width: 50px; height: 50px; border-width: 5px; border-color: #667eea; border-top-color: transparent;"></div>
            <p style="margin-top: 20px; color: #666;">Loading quiz...</p>
        </div>

        <!-- Error State -->
        <div id="errorState" style="display: none;">
            <div class="error-message">
                <strong>Error:</strong> <span id="errorMessage"></span>
            </div>
            <button class="btn btn-secondary" onclick="window.history.back()">Go Back</button>
        </div>

        <!-- Quiz Header -->
        <div id="quizHeader" style="display: none;">
            <div class="quiz-header">
                <h1 id="quizTitle">Quiz Title</h1>
                <p id="quizDescription">Quiz description</p>
                <div class="quiz-info">
                    <div class="quiz-info-item">
                        <svg fill="currentColor" viewBox="0 0 20 20">
                            <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z"/>
                            <path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd"/>
                        </svg>
                        <span id="questionCount">0 Questions</span>
                    </div>
                    <div class="quiz-info-item">
                        <svg fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd"/>
                        </svg>
                        <span id="passingScore">Passing: 70%</span>
                    </div>
                    <div class="quiz-info-item" id="timeLimitInfo" style="display: none;">
                        <svg fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-12a1 1 0 10-2 0v4a1 1 0 00.293.707l2.828 2.829a1 1 0 101.415-1.415L11 9.586V6z" clip-rule="evenodd"/>
                        </svg>
                        <span id="timeLimit">Time Limit: 30 min</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Timer (if time limit exists) -->
        <div id="timerContainer" class="timer-container" style="display: none;">
            <div class="timer-label">Time Remaining</div>
            <div class="timer-value" id="timerValue">30:00</div>
        </div>

        <!-- Progress Bar -->
        <div id="progressContainer" class="quiz-progress" style="display: none;">
            <div class="progress-bar">
                <div class="progress-fill" id="progressFill" style="width: 0%"></div>
            </div>
            <div class="progress-text">
                Question <span id="currentQuestion">1</span> of <span id="totalQuestions">10</span>
            </div>
        </div>

        <!-- Question Container -->
        <div id="questionContainer" style="display: none;"></div>

        <!-- Navigation Buttons -->
        <div id="navigationButtons" class="quiz-navigation" style="display: none;">
            <button class="btn btn-secondary" id="prevBtn" onclick="previousQuestion()" disabled>
                Previous
            </button>
            <button class="btn btn-primary" id="nextBtn" onclick="nextQuestion()">
                Next Question
            </button>
            <button class="btn btn-primary" id="submitBtn" onclick="submitQuiz()" style="display: none;">
                Submit Quiz
            </button>
        </div>

        <!-- Results Container -->
        <div id="resultsContainer" style="display: none;"></div>
    </div>

    <script>
        const quizId = '${quizId}';
        let quizData = null;
        let attemptId = null;
        let currentQuestionIndex = 0;
        let userAnswers = {};
        let timerInterval = null;
        let timeRemaining = 0;

        // Load quiz on page load
        document.addEventListener('DOMContentLoaded', function() {
            loadQuiz();
        });

        async function loadQuiz() {
            try {
                const token = localStorage.getItem('accessToken');
                if (!token) {
                    window.location.href = '/login';
                    return;
                }

                // Fetch quiz data
                const response = await fetch('/api/quizzes/' + quizId + '/full', {
                    headers: {
                        'Authorization': 'Bearer ' + token
                    }
                });

                if (!response.ok) {
                    throw new Error('Failed to load quiz');
                }

                quizData = await response.json();
                
                // Start quiz attempt
                await startQuizAttempt();
                
                // Display quiz
                displayQuiz();
                
            } catch (error) {
                console.error('Error loading quiz:', error);
                showError(error.message);
            }
        }

        async function startQuizAttempt() {
            const token = localStorage.getItem('accessToken');
            const response = await fetch('/api/quizzes/' + quizId + '/start', {
                method: 'POST',
                headers: {
                    'Authorization': 'Bearer ' + token,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                const error = await response.json();
                throw new Error(error.error || 'Failed to start quiz');
            }

            const attempt = await response.json();
            attemptId = attempt.id;

            // Start timer if time limit exists
            if (quizData.quiz.timeLimit) {
                timeRemaining = quizData.quiz.timeLimit * 60; // Convert to seconds
                startTimer();
            }
        }

        function displayQuiz() {
            document.getElementById('loadingState').style.display = 'none';
            document.getElementById('quizHeader').style.display = 'block';
            document.getElementById('progressContainer').style.display = 'block';
            document.getElementById('navigationButtons').style.display = 'flex';

            // Set quiz info
            document.getElementById('quizTitle').textContent = quizData.quiz.title;
            document.getElementById('quizDescription').textContent = quizData.quiz.description || '';
            document.getElementById('questionCount').textContent = quizData.questions.length + ' Questions';
            document.getElementById('passingScore').textContent = 'Passing: ' + quizData.quiz.passingScore + '%';
            document.getElementById('totalQuestions').textContent = quizData.questions.length;

            if (quizData.quiz.timeLimit) {
                document.getElementById('timeLimitInfo').style.display = 'flex';
                document.getElementById('timeLimit').textContent = 'Time Limit: ' + quizData.quiz.timeLimit + ' min';
                document.getElementById('timerContainer').style.display = 'block';
            }

            // Display first question
            displayQuestion(0);
        }

        function displayQuestion(index) {
            currentQuestionIndex = index;
            const question = quizData.questions[index];
            const answers = question.answers;

            // Update progress
            const progress = ((index + 1) / quizData.questions.length) * 100;
            document.getElementById('progressFill').style.width = progress + '%';
            document.getElementById('currentQuestion').textContent = index + 1;

            // Build question HTML
            let questionTypeLabel = question.questionType.replace('_', ' ');
            let inputType = question.questionType === 'MULTIPLE_SELECT' ? 'checkbox' : 'radio';
            
            let html = '<div class="question-card">';
            html += '<div class="question-header">';
            html += '<span class="question-number">Question ' + (index + 1) + ' of ' + quizData.questions.length + '</span>';
            html += '<span class="question-points">' + question.points + ' point' + (question.points > 1 ? 's' : '') + '</span>';
            html += '</div>';
            html += '<div class="question-type-badge">' + questionTypeLabel + '</div>';
            html += '<div class="question-text">' + question.questionText + '</div>';
            html += '<div class="answers-container">';

            answers.forEach(function(answer, i) {
                const isSelected = userAnswers[question.id] && 
                    (Array.isArray(userAnswers[question.id]) ? 
                        userAnswers[question.id].includes(answer.id) : 
                        userAnswers[question.id] === answer.id);
                
                html += '<div class="answer-option ' + (isSelected ? 'selected' : '') + '" onclick="selectAnswer(\'' + question.id + '\', \'' + answer.id + '\', \'' + inputType + '\')">';
                html += '<label class="answer-label">';
                html += '<input type="' + inputType + '" name="question_' + question.id + '" value="' + answer.id + '" ' + (isSelected ? 'checked' : '') + '>';
                html += answer.answerText;
                html += '</label>';
                html += '</div>';
            });

            html += '</div>';
            html += '</div>';

            document.getElementById('questionContainer').innerHTML = html;
            document.getElementById('questionContainer').style.display = 'block';

            // Update navigation buttons
            document.getElementById('prevBtn').disabled = index === 0;
            
            if (index === quizData.questions.length - 1) {
                document.getElementById('nextBtn').style.display = 'none';
                document.getElementById('submitBtn').style.display = 'block';
            } else {
                document.getElementById('nextBtn').style.display = 'block';
                document.getElementById('submitBtn').style.display = 'none';
            }
        }

        function selectAnswer(questionId, answerId, inputType) {
            if (inputType === 'checkbox') {
                if (!userAnswers[questionId]) {
                    userAnswers[questionId] = [];
                }
                const index = userAnswers[questionId].indexOf(answerId);
                if (index > -1) {
                    userAnswers[questionId].splice(index, 1);
                } else {
                    userAnswers[questionId].push(answerId);
                }
            } else {
                userAnswers[questionId] = answerId;
            }

            // Re-render current question to update selection
            displayQuestion(currentQuestionIndex);
        }

        function previousQuestion() {
            if (currentQuestionIndex > 0) {
                displayQuestion(currentQuestionIndex - 1);
            }
        }

        function nextQuestion() {
            if (currentQuestionIndex < quizData.questions.length - 1) {
                displayQuestion(currentQuestionIndex + 1);
            }
        }

        async function submitQuiz() {
            if (!confirm('Are you sure you want to submit your quiz? You cannot change your answers after submission.')) {
                return;
            }

            try {
                const token = localStorage.getItem('accessToken');

                // Submit all answers
                for (const questionId in userAnswers) {
                    const answer = userAnswers[questionId];
                    const answerIds = Array.isArray(answer) ? answer : [answer];

                    for (const answerId of answerIds) {
                        await fetch('/api/attempts/' + attemptId + '/answers', {
                            method: 'POST',
                            headers: {
                                'Authorization': 'Bearer ' + token,
                                'Content-Type': 'application/json'
                            },
                            body: JSON.stringify({
                                questionId: questionId,
                                answerId: answerId
                            })
                        });
                    }
                }

                // Complete the quiz
                const response = await fetch('/api/attempts/' + attemptId + '/complete', {
                    method: 'POST',
                    headers: {
                        'Authorization': 'Bearer ' + token,
                        'Content-Type': 'application/json'
                    }
                });

                if (!response.ok) {
                    throw new Error('Failed to submit quiz');
                }

                const result = await response.json();
                
                // Stop timer
                if (timerInterval) {
                    clearInterval(timerInterval);
                }

                // Display results
                displayResults(result);

            } catch (error) {
                console.error('Error submitting quiz:', error);
                alert('Failed to submit quiz. Please try again.');
            }
        }

        function displayResults(result) {
            document.getElementById('quizHeader').style.display = 'none';
            document.getElementById('progressContainer').style.display = 'none';
            document.getElementById('questionContainer').style.display = 'none';
            document.getElementById('navigationButtons').style.display = 'none';
            document.getElementById('timerContainer').style.display = 'none';

            const statusClass = result.passed ? 'passed' : 'failed';
            const statusText = result.passed ? '✓ Passed!' : '✗ Failed';

            let html = '<div class="results-container">';
            html += '<h2>Quiz Complete!</h2>';
            html += '<div class="results-score">' + result.score + '%</div>';
            html += '<div class="results-status ' + statusClass + '">' + statusText + '</div>';
            html += '<div class="results-details">';
            html += '<div class="result-detail">';
            html += '<div class="result-detail-label">Your Score</div>';
            html += '<div class="result-detail-value">' + result.totalPoints + '/' + result.maxPoints + '</div>';
            html += '</div>';
            html += '<div class="result-detail">';
            html += '<div class="result-detail-label">Passing Score</div>';
            html += '<div class="result-detail-value">' + quizData.quiz.passingScore + '%</div>';
            html += '</div>';
            html += '<div class="result-detail">';
            html += '<div class="result-detail-label">Attempt Number</div>';
            html += '<div class="result-detail-value">#' + result.attemptNumber + '</div>';
            html += '</div>';
            html += '</div>';
            html += '<div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">';
            html += '<button class="btn btn-secondary" onclick="window.history.back()">Back to Course</button>';
            html += '<button class="btn btn-primary" onclick="viewDetailedResults()">View Detailed Results</button>';
            html += '</div>';
            html += '</div>';

            document.getElementById('resultsContainer').innerHTML = html;
            document.getElementById('resultsContainer').style.display = 'block';
        }

        function viewDetailedResults() {
            window.location.href = '/quiz-results/' + attemptId;
        }

        function startTimer() {
            document.getElementById('timerContainer').style.display = 'block';
            
            timerInterval = setInterval(function() {
                timeRemaining--;
                
                const minutes = Math.floor(timeRemaining / 60);
                const seconds = timeRemaining % 60;
                const display = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                
                document.getElementById('timerValue').textContent = display;
                
                // Change color based on time remaining
                const timerElement = document.getElementById('timerValue');
                if (timeRemaining <= 60) {
                    timerElement.className = 'timer-value danger';
                } else if (timeRemaining <= 300) {
                    timerElement.className = 'timer-value warning';
                }
                
                // Auto-submit when time runs out
                if (timeRemaining <= 0) {
                    clearInterval(timerInterval);
                    alert('Time is up! Your quiz will be submitted automatically.');
                    submitQuiz();
                }
            }, 1000);
        }

        function showError(message) {
            document.getElementById('loadingState').style.display = 'none';
            document.getElementById('errorState').style.display = 'block';
            document.getElementById('errorMessage').textContent = message;
        }

        function logout() {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('refreshToken');
            window.location.href = '/login';
        }
    </script>
</body>
</html>