<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Not Found</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            color: white;
            text-align: center;
            padding: 50px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #607d8b;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            font-size: 48px;
        }
        p {
            font-size: 18px;
        }
        a {
            color: #721c24;
            text-decoration: none;
            font-weight: bold;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>404</h1>
        <p><strong>This could be a plugin?</strong></p>
        <p>Have you tried recalling the heartbeat.</p>
        <p><a href="/loggedIn/dashboard.ftl">Return to Homepage</a></p>
    </div>
    <!-- Chatbot toggle button -->
    <div class="fixed bottom-6 right-6 z-50">
        <button id="chatbot-toggle" class="w-16 h-16 rounded-full bg-blue-600 text-white shadow-lg hover:bg-blue-700 transition-all duration-300 flex items-center justify-center">
            <i class="fas fa-robot text-2xl"></i>
            <span class="absolute -top-1 -right-1 w-5 h-5 rounded-full bg-red-500 text-xs flex items-center justify-center animate-pulse">AI</span>
        </button>
    </div>

    <!-- Chatbot container -->
    <div id="chatbot-container" class="fixed bottom-24 right-6 w-96 max-w-full bg-white rounded-xl shadow-xl z-40 hidden flex-col border border-gray-200">
        <!-- Chat header -->
        <div class="bg-blue-600 text-white rounded-t-xl p-4 flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center">
                    <i class="fas fa-shield-alt text-white"></i>
                </div>
                <div>
                    <h3 class="font-bold">SLP Assistant</h3>
                    <p class="text-xs opacity-80">AI-powered SLP expert</p>
                </div>
            </div>
            <div class="flex space-x-2">
                <button class="w-8 h-8 rounded-full bg-blue-500 hover:bg-blue-400 flex items-center justify-center transition">
                    <i class="fas fa-cog text-xs"></i>
                </button>
                <button id="minimize-chat" class="w-8 h-8 rounded-full bg-blue-500 hover:bg-blue-400 flex items-center justify-center transition">
                    <i class="fas fa-minus text-xs"></i>
                </button>
                <button id="close-chat" class="w-8 h-8 rounded-full bg-blue-500 hover:bg-blue-400 flex items-center justify-center transition">
                    <i class="fas fa-times text-xs"></i>
                </button>
            </div>
        </div>

        <!-- Chat messages area -->
        <div class="chat-container flex-1 p-4 overflow-y-auto max-h-96" id="chat-messages">
            <!-- Welcome message -->
            <div class="message-fade-in mb-4">
                <div class="flex items-start space-x-2">
                    <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center shrink-0">
                        <i class="fas fa-shield-alt text-blue-600 text-sm"></i>
                    </div>
                    <div class="bg-blue-50 rounded-lg p-3 max-w-[80%]">
                        <p class="text-sm font-medium text-gray-800">Hello! I'm your SLP Assistant. I can help with:</p>
                        <ul class="list-disc pl-5 mt-2 text-sm space-y-1">
                            <li>Data security questions</li>
                            <li>AI security concerns</li>
                            <li>Application features</li>
                        </ul>
                        <p class="text-xs mt-2 text-gray-500">How can I help you today?</p>
                    </div>
                </div>
                <p class="text-xs text-gray-400 mt-1 pl-10">Just now</p>
            </div>

            <!-- Sample questions -->
            <div class="grid grid-cols-2 gap-2 mb-4">
                <button class="quick-question-btn text-xs bg-gray-100 hover:bg-gray-200 rounded-lg px-3 py-2 text-left transition" data-question="Tell me about Data protection?">
                    <i class="fas fa-lock mr-1 text-blue-500"></i> Data protection
                </button>
                <button class="quick-question-btn text-xs bg-gray-100 hover:bg-gray-200 rounded-lg px-3 py-2 text-left transition" data-question="What is AI Security?">
                    <i class="fas fa-brain mr-1 text-purple-500"></i> AI security
                </button>
                <button class="quick-question-btn text-xs bg-gray-100 hover:bg-gray-200 rounded-lg px-3 py-2 text-left transition" data-question="How does encryption work?">
                    <i class="fas fa-key mr-1 text-green-500"></i> Encryption
                </button>
                <button class="quick-question-btn text-xs bg-gray-100 hover:bg-gray-200 rounded-lg px-3 py-2 text-left transition" data-question="What features does this application offer?">
                    <i class="fas fa-list mr-1 text-orange-500"></i> App features
                </button>
            </div>
        </div>

        <!-- Typing indicator (hidden by default) -->
        <div id="typing-indicator" class="px-4 pb-2 hidden">
            <div class="flex items-center space-x-2">
                <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center shrink-0">
                    <i class="fas fa-shield-alt text-blue-600 text-sm"></i>
                </div>
                <div class="bg-blue-50 rounded-lg p-3">
                    <div class="flex space-x-1">
                        <div class="typing-dot w-2 h-2 rounded-full bg-blue-400"></div>
                        <div class="typing-dot w-2 h-2 rounded-full bg-blue-400"></div>
                        <div class="typing-dot w-2 h-2 rounded-full bg-blue-400"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Chat input area -->
        <div class="border-t border-gray-200 p-3 bg-gray-50 rounded-b-xl">
            <div class="flex items-center space-x-2">
                <input type="text" id="chat-input" placeholder="Type your question..." class="flex-1 border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-sm">
                <button id="send-message" class="w-10 h-10 rounded-lg bg-blue-600 text-white hover:bg-blue-700 transition flex items-center justify-center">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
            <p class="text-xs text-gray-500 mt-2 text-center">This AI assistant provides general guidance only</p>
        </div>
    </div>
</body>
</html>