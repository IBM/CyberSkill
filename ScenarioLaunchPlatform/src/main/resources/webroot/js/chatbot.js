 document.addEventListener('DOMContentLoaded', function() {
            // DOM elements
            const chatbotToggle = document.getElementById('chatbot-toggle');
            const chatbotContainer = document.getElementById('chatbot-container');
            const closeChat = document.getElementById('close-chat');
            const minimizeChat = document.getElementById('minimize-chat');
            const chatMessages = document.getElementById('chat-messages');
            const chatInput = document.getElementById('chat-input');
            const sendMessage = document.getElementById('send-message');
            const typingIndicator = document.getElementById('typing-indicator');
            const quickQuestionBtns = document.querySelectorAll('.quick-question-btn');

            // Toggle chatbot visibility
            chatbotToggle.addEventListener('click', function() {
                chatbotContainer.classList.toggle('hidden');
                chatbotContainer.classList.toggle('flex');
            });

            // Close chatbot
            closeChat.addEventListener('click', function() {
                chatbotContainer.classList.add('hidden');
                chatbotContainer.classList.remove('flex');
            });

            // Minimize chatbot (just hides messages for now)
            minimizeChat.addEventListener('click', function() {
                chatMessages.classList.toggle('hidden');
                chatMessages.classList.toggle('max-h-0');
            });

            // Quick question buttons
            quickQuestionBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const question = this.getAttribute('data-question');
                    chatInput.value = question;
                    sendUserMessage(question);
                });
            });

            // Send message on Enter key
            chatInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendUserMessage(this.value);
                }
            });

            // Send message on button click
            sendMessage.addEventListener('click', function() {
                if (chatInput.value.trim() !== '') {
                    sendUserMessage(chatInput.value);
                }
            });

            // Function to send user message and get bot response
            function sendUserMessage(message) {
                if (message.trim() === '') return;
                
                // Add user message to chat
                addMessageToChat(message, 'user');
                chatInput.value = '';
                
                // Show typing indicator
                typingIndicator.classList.remove('hidden');
                chatMessages.scrollTop = chatMessages.scrollHeight;
                
                // Simulate bot thinking (in a real app, this would be an API call)
                setTimeout(() => {
                    typingIndicator.classList.add('hidden');
                    
                    // Get bot response
                    const botResponse = getBotResponse(message);
                    addMessageToChat(botResponse, 'bot');
                }, 1000 + Math.random() * 2000); // Random delay between 1-3 seconds
            }

            // Function to add message to chat
            function addMessageToChat(message, sender) {
                const now = new Date();
                const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                
                if (sender === 'user') {
                    const messageHtml = `
                        <div class="message-fade-in mb-4">
                            <div class="flex items-start justify-end space-x-2">
                                <div class="bg-blue-600 text-white rounded-lg p-3 max-w-[80%]">
                                    <p class="text-sm">${message}</p>
                                </div>
                                <div class="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center shrink-0">
                                    <i class="fas fa-user text-gray-600 text-sm"></i>
                                </div>
                            </div>
                            <p class="text-xs text-gray-400 mt-1 text-right pr-10">${timeString}</p>
                        </div>
                    `;
                    chatMessages.insertAdjacentHTML('beforeend', messageHtml);
                } else {
                    const messageHtml = `
                        <div class="message-fade-in mb-4">
                            <div class="flex items-start space-x-2">
                                <div class="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center shrink-0">
                                    <i class="fas fa-shield-alt text-blue-600 text-sm"></i>
                                </div>
                                <div class="bg-blue-50 rounded-lg p-3 max-w-[80%]">
                                    <p class="text-sm">${message}</p>
                                </div>
                            </div>
                            <p class="text-xs text-gray-400 mt-1 pl-10">${timeString}</p>
                        </div>
                    `;
                    chatMessages.insertAdjacentHTML('beforeend', messageHtml);
                }
                
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }

            // Function to generate bot responses (simplified for demo)
            function getBotResponse(userMessage) {
                const lowerMessage = userMessage.toLowerCase();
                
                 // Guardium features - MOVED HIGHER IN THE LOGIC CHAIN
    if (/\bdiscovery\b/.test(lowerMessage) || /\bclassification\b/.test(lowerMessage)) {
        return "Guardium automatically locates sensitive data across databases, big data environments, and cloud platforms, classifying it based on type and risk level";
    }
               // Data security responses
                if (/\bdata\b/.test(lowerMessage) && /\bprotect\b/.test(lowerMessage)) {
                    return "Your data is protected through multiple layers of security, regular security audits, and strict access controls. We use end-to-end encryption for all sensitive information.";
                }
                
                if (/\bencrypt\b/.test(lowerMessage) || /\bencryption\b/.test(lowerMessage)) {
                    return "We use industry-standard AES-256 encryption for data at rest and TLS 1.3 for data in transit. All encryption keys are managed through a dedicated key management service.";
                }
                
                if (/\bgdpr\b/.test(lowerMessage) || /\bcompliance\b/.test(lowerMessage)) {
                    return "Our application is fully GDPR compliant. We maintain data processing agreements, provide data portability, and have appointed a dedicated Data Protection Officer.";
                }
                
                // AI security responses
                if (/\bai\b/.test(lowerMessage) && /\bsecurity\b/.test(lowerMessage)) {
                    return "Short for artificial intelligence (AI) security, AI security is the process of using AI to enhance an organization's security posture. With AI systems, organizations can automate threat detection, prevention and remediation to better combat cyberattacks and data breaches.";
                }
                
                if (/\bbias\b/.test(lowerMessage) || /\bfair\b/.test(lowerMessage)) {
                    return "We mitigate AI bias through diverse training datasets, regular fairness testing across demographic groups, and algorithmic techniques like reweighting and adversarial debiasing. Our models undergo rigorous audits before deployment.";
                }
                
                if (/\bmodel\b/.test(lowerMessage) || /\btraining\b/.test(lowerMessage)) {
                    return "AI models are trained on secure, isolated infrastructure with strict access controls. Training data is anonymized and encrypted. We implement model versioning and maintain comprehensive audit logs of all training activities.";
                }
                
                // Application feature responses
                if (/\bfeature\b/.test(lowerMessage) || /\bfeatures\b/.test(lowerMessage) || 
                    /\bwhat\b.*\bcan\b/.test(lowerMessage)) {
                    return "Our application offers these key features:\n1. Story Mode: Interactive threat scenarios\n2. Script uploads: Custom security scripts\n3. API Suite: Integration capabilities\n4. Use cases: Industry-specific solutions\n5. Multiple connection pools: Scalable infrastructure";
                }
                
                if (/\bguardium\b/.test(lowerMessage) || /\bprotection\b/.test(lowerMessage)) {
                    return "IBM Security Guardium Data Protection offers a suite of features for securing data across various environments. These include discovering and classifying sensitive data, assessing risk with analytics, protecting data through encryption and access policies, monitoring data access, and simplifying compliance reporting.";
                }
                
                if (/\bstory\b/.test(lowerMessage) || /\bstory-mode\b/.test(lowerMessage)) {
                    return "Story Mode provides interactive scenarios that simulate real-world security threats, allowing teams to practice incident response in a safe environment. It includes guided learning paths and performance metrics.";
                }
                
                if (/\buse\s+cases\b/.test(lowerMessage) || /\bcases\b/.test(lowerMessage)) {
                    return "Our solution supports multiple use cases including:\n- Data loss prevention\n- Cloud security posture management\n- Regulatory compliance automation\n- Threat detection and response\n- User behavior analytics";
                }
                
                // Guardium-specific features
                if (/\bdiscovery\b/.test(lowerMessage) || /\bclassification\b/.test(lowerMessage)) {
                    return "Guardium automatically locates sensitive data across databases, big data environments, and cloud platforms, classifying it based on type and risk level using machine learning algorithms.";
                }
                
                if (/\bvulnerability\b/.test(lowerMessage) || /\bassessment\b/.test(lowerMessage)) {
                    return "Guardium VA identifies and assesses database vulnerabilities and configuration flaws through continuous scanning, providing prioritized remediation recommendations based on risk scoring.";
                }
                
                if (/\breal-time\b/.test(lowerMessage) || /\brealtime\b/.test(lowerMessage) || /\bmonitoring\b/.test(lowerMessage)) {
                    return "Guardium provides continuous monitoring of data access and usage patterns with sub-second latency, enabling immediate identification of suspicious activities and potential threats.";
                }
                
                if (/\baccess\b/.test(lowerMessage) || /\benforcement\b/.test(lowerMessage)) {
                    return "The solution enforces granular access control policies based on roles, contexts, and attributes, ensuring that only authorized users, applications, or systems can access sensitive data.";
                }
                
                if (/\bdetection\b/.test(lowerMessage) || /\bresponse\b/.test(lowerMessage)) {
                    return "Guardium utilizes machine learning and behavioral analytics to detect anomalous behavior patterns, triggering automated response workflows that can isolate threats within milliseconds.";
                }
                
                if (/\bcompliance\b/.test(lowerMessage) || /\bautomation\b/.test(lowerMessage)) {
                    return "Our compliance automation module simplifies regulatory workflows with pre-built templates for GDPR, HIPAA, PCI-DSS, and SOX, while providing automated evidence collection and audit reporting.";
                }
                
                // Default response
                return "I'm designed to answer questions about data security, AI security, and application features. Could you please rephrase your question or ask about one of these specific areas? For example:\n\n• 'How is my data encrypted?'\n• 'What AI security measures exist?'\n• 'What features does the dashboard have?'";
            }

             
        });