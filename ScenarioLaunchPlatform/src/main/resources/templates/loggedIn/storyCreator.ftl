<!DOCTYPE html>
<html>
<head>
<title>SLP Content Packs</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/datatables.min.css">
<link rel='stylesheet' href='css/fonts.css'>
<script src="js/jquery.min.js"></script>
<script src="js/datatables.js"></script>

 <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}
</style>
<style>
.city {
	display:none
	height: 800px;
	background-color:white;
}
</style>

<style>
  .custom-modal {
    width: 70%;
    height: 800px;
  }


   .full-height-textarea {
      width: 100%;         /* Ensure textarea takes full width */
      height: 500px;        /* Make textarea fill the parent's height */
      resize: none;        /* Optional: Prevent resizing the textarea */
    }


</style>
<style>
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fade-in {
            animation: fadeIn 0.3s ease-out forwards;
        }
        
        .chapter-card {
            transition: all 0.3s ease;
        }
        
        .chapter-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        
        #json-output {
            min-height: 200px;
            font-family: monospace;
            white-space: pre-wrap;
            word-wrap: break-word;
            background-color: #1e293b;
            color: #f1f5f9;
        }
        
        .form-section {
            background-color: #f8fafc;
            border-radius: 0.75rem;
            border: 1px solid #e2e8f0;
        }
        
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 1000;
            transform: translateX(200%);
            transition: transform 0.3s ease-out;
            display: flex;
            align-items: center;
        }
        
        .toast.show {
            transform: translateX(0);
        }
        
        .toast.success {
            background: linear-gradient(135deg, #10b981, #059669);
        }
        
        .toast.error {
            background: linear-gradient(135deg, #ef4444, #dc2626);
        }
        
        .toast i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 8px -1px rgba(59, 130, 246, 0.4);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #334155;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-secondary:hover {
            background: #cbd5e1;
        }
        
        .header-gradient {
            background: linear-gradient(135deg, #1e40af, #3b82f6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
    </style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>
<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">    
  <!-- The Grid -->
  <div class="w3-row">
    <!-- Left Column -->
    <div id="leftColumn"></div>
    
    <!-- End Left Column -->
    
    
    <!-- Middle Column -->
    <div class="w3-col m9">
    
      <div class="container mx-auto px-4 py-8 max-w-4xl">
     <!-- Toast Notification -->
        <div id="toast" class="toast hidden">
            <i class="fas fa-info-circle"></i>
            <span id="toast-message"></span>
        </div>
      
        <!-- Main Form -->
        <div class="bg-white rounded-xl shadow-lg p-8 mb-8 border border-slate-200">
            <form id="story-form">
                <!-- Story Metadata -->
                <div class="mb-8">
                    <h2 class="text-2xl font-semibold text-slate-800 mb-6 pb-2 border-b border-slate-200">Story Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="name" class="block text-sm font-medium text-slate-700 mb-2">Story Name*</label>
                            <input type="text" id="name" name="name" class="w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="e.g., Polly Sees Violations" required>
                        </div>
                        <div>
                            <label for="author" class="block text-sm font-medium text-slate-700 mb-2">Author*</label>
                            <input type="text" id="author" name="author" class="w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="e.g., Polly" required>
                        </div>
                        <div>
                            <label for="handbook" class="block text-sm font-medium text-slate-700 mb-2">Handbook Path</label>
                            <input type="text" id="handbook" name="handbook" class="w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="e.g., /handbooks/PollySeesViolations.pdf">
                        </div>
                        <div>
                            <label for="video" class="block text-sm font-medium text-slate-700 mb-2">Video URL</label>
                            <input type="url" id="video" name="video" class="w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="e.g., https://example.com/video.mp4">
                        </div>
                    </div>
                    
                    <div class="mt-6">
                        <label for="description" class="block text-sm font-medium text-slate-700 mb-2">Description*</label>
                        <textarea id="description" name="description" rows="3" class="w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="Describe the story..." required></textarea>
                    </div>
                    
                    <div class="mt-6">
                        <label for="outcomes" class="block text-sm font-medium text-slate-700 mb-2">Learning Outcomes*</label>
                        <textarea id="outcomes" name="outcomes" rows="2" class="w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="What will users learn from this story?" required></textarea>
                    </div>
                </div>
                
                <!-- Chapters Section -->
                <div class="mb-8">
                    <div class="flex justify-between items-center mb-6 pb-2 border-b border-slate-200">
                        <h2 class="text-2xl font-semibold text-slate-800">Chapters</h2>
                        <button type="button" id="add-chapter" class="btn-primary flex items-center">
                            <i class="fas fa-plus mr-2"></i> Add Chapter
                        </button>
                    </div>
                    
                    <div id="chapters-container" class="space-y-6">
                        <!-- Chapter template will be added here dynamically -->
                    </div>
                </div>
                
                <!-- Form Actions -->
                <div class="flex justify-end space-x-4 pt-4 border-t border-slate-200">
                    <button type="button" id="preview-json" class="btn-secondary">
                        Preview JSON
                    </button>
                    <button type="submit" class="btn-primary flex items-center">
                        <i class="fas fa-save mr-2"></i> Create Story
                    </button>
                </div>
            </form>
        </div>
        
        <!-- JSON Preview -->
        <div id="json-preview" class="bg-white rounded-xl shadow-lg p-6 hidden border border-slate-200">
            <div class="flex justify-between items-center mb-4">
                <h2 class="text-2xl font-semibold text-slate-800">JSON Output</h2>
                <div class="flex space-x-2">
                    <button id="copy-json" class="btn-secondary flex items-center">
                        <i class="fas fa-copy mr-2"></i> Copy JSON
                    </button>
                    <button id="close-json" class="btn-secondary flex items-center">
                        <i class="fas fa-times mr-2"></i> Close
                    </button>
                </div>
            </div>
            <pre id="json-output" class="p-4 rounded-lg overflow-auto max-h-96"></pre>
        </div>
    </div>

    <!-- Chapter Template (Hidden) -->
    <template id="chapter-template">
        <div class="chapter-card bg-white p-6 rounded-xl border border-slate-200 shadow-sm animate-fade-in">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-medium text-slate-800">Chapter <span class="chapter-number">1</span></h3>
                <div class="flex space-x-2">
                    <button type="button" class="duplicate-chapter text-blue-500 hover:text-blue-700" title="Duplicate this chapter">
                        <i class="fas fa-copy"></i>
                    </button>
                    <button type="button" class="delete-chapter text-red-500 hover:text-red-700" title="Delete this chapter">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
            
            <div class="grid grid-cols-1 gap-6">
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-2">Chapter Title*</label>
                    <input type="text" class="chapter-title w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="e.g., Polly runs a basic query" required>
                </div>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
    <label class="block text-sm font-medium text-slate-700 mb-2">Datasource*</label>
    <select id="validatedConnections" name="pack_name" class="chapter-datasource w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" required>
      <#if ValidatedConnectionData?has_content>
					            <#list ValidatedConnectionData?keys as key>
					                <option value="${key}">${key}</option>
					            </#list>
				            <#else>
			                	<option value="">No options available</option>
			            	</#if>
    </select>
</div>
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-2">Query ID*</label>
                        <input type="number" class="chapter-query_id w-full border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" placeholder="e.g., 500" required>
                    </div>
                </div>
                
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-2">Pause in Milliseconds*</label>
                    <div class="flex items-center">
                        <input type="range" min="1000" max="10000" step="1000" class="chapter-pause w-full mr-4">
                        <input type="number" min="1000" max="10000" step="1000" class="chapter-pause-value w-32 border border-slate-300 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" value="5000">
                    </div>
                    <p class="text-xs text-slate-500 mt-2">Time to wait before next chapter (1000ms = 1 second)</p>
                </div>
            </div>
        </div>
    </template>

</div>
  
<!-- End Page Container -->
      
      
      
    <!-- End Middle Column -->
    </div>
    
    <!-- Right Column -->
    
  
      
    <!-- End Right Column -->
    </div>
    
  <!-- End Grid -->
  </div>
 
<!-- End Page Container -->

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
</div>
<br>

<!-- Footer -->
<div id="footer"></div>
 
<script>
       document.addEventListener('DOMContentLoaded', function() {
            // DOM elements
            const storyForm = document.getElementById('story-form');
            const chaptersContainer = document.getElementById('chapters-container');
            const addChapterBtn = document.getElementById('add-chapter');
            const previewJsonBtn = document.getElementById('preview-json');
            const jsonPreview = document.getElementById('json-preview');
            const jsonOutput = document.getElementById('json-output');
            const copyJsonBtn = document.getElementById('copy-json');
            const closeJsonBtn = document.getElementById('close-json');
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toast-message');
            
            // Template
            const chapterTemplate = document.getElementById('chapter-template').content;
            
            let chapterCount = 0;
            
            // Add first chapter
            addChapter();
            
            // Add Chapter Button
            addChapterBtn.addEventListener('click', addChapter);
            
            // Form Submit
            storyForm.addEventListener('submit', function(e) {
                e.preventDefault();
                addStory(e);
            });
            
            // Preview JSON Button
            previewJsonBtn.addEventListener('click', function() {
                generateJson();
                jsonPreview.classList.remove('hidden');
            });
            
            // Copy JSON Button
            copyJsonBtn.addEventListener('click', function() {
                const textArea = document.createElement('textarea');
                textArea.value = jsonOutput.textContent;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                
                showToast('JSON copied to clipboard!', true);
            });
            
            // Close JSON Preview Button
            closeJsonBtn.addEventListener('click', function() {
                jsonPreview.classList.add('hidden');
            });
            
            // Add a new chapter
            function addChapter() {
                chapterCount++;
                const chapterClone = document.importNode(chapterTemplate, true);
                
                // Update chapter number
                chapterClone.querySelector('.chapter-number').textContent = chapterCount;
                
                // Add duplicate chapter event
                chapterClone.querySelector('.duplicate-chapter').addEventListener('click', function() {
                    const chapterCard = this.closest('.chapter-card');
                    const title = chapterCard.querySelector('.chapter-title').value;
                    const datasource = chapterCard.querySelector('.chapter-datasource').value;
                    const queryId = chapterCard.querySelector('.chapter-query_id').value;
                    const pauseValue = chapterCard.querySelector('.chapter-pause-value').value;
                    
                    addChapter();
                    const newChapter = chaptersContainer.lastElementChild;
                    newChapter.querySelector('.chapter-title').value = title;
                    newChapter.querySelector('.chapter-datasource').value = datasource;
                    newChapter.querySelector('.chapter-query_id').value = queryId;
                    newChapter.querySelector('.chapter-pause-value').value = pauseValue;
                    newChapter.querySelector('.chapter-pause').value = pauseValue;
                });
                
                // Add delete chapter event
                chapterClone.querySelector('.delete-chapter').addEventListener('click', function() {
                    if (chaptersContainer.children.length > 1) {
                        this.closest('.chapter-card').remove();
                        updateChapterNumbers();
                    } else {
                        alert("A story must have at least one chapter!");
                    }
                });
                
                // Pause slider sync
                const pauseSlider = chapterClone.querySelector('.chapter-pause');
                const pauseValue = chapterClone.querySelector('.chapter-pause-value');
                
                pauseSlider.value = 5000;
                pauseValue.value = 5000;
                
                pauseSlider.addEventListener('input', function() {
                    pauseValue.value = this.value;
                });
                
                pauseValue.addEventListener('input', function() {
                    pauseSlider.value = this.value;
                });
                
                chaptersContainer.appendChild(chapterClone);
            }
            
            // Update chapter numbers
            function updateChapterNumbers() {
                const chapters = chaptersContainer.querySelectorAll('.chapter-card');
                chapterCount = chapters.length;
                
                chapters.forEach((chapter, index) => {
                    chapter.querySelector('.chapter-number').textContent = index + 1;
                });
            }
            
            // Generate JSON from form data
            function generateJson() {
                const storyData = {
                    story: {
                        author: document.getElementById('author').value,
                        description: document.getElementById('description').value,
                        handbook: document.getElementById('handbook').value || null,
                        name: document.getElementById('name').value,
                        outcomes: document.getElementById('outcomes').value,
                        story: [],
                        video: document.getElementById('video').value || null
                    }
                };
                
                // Collect chapters
                const chapters = chaptersContainer.querySelectorAll('.chapter-card');
                chapters.forEach(chapter => {
                    const chapterData = {
                        chapter: chapter.querySelector('.chapter-title').value,
                        datasource: chapter.querySelector('.chapter-datasource').value,
                        pause_in_seconds: parseInt(chapter.querySelector('.chapter-pause-value').value),
                        query_id: parseInt(chapter.querySelector('.chapter-query_id').value)
                    };
                    
                    storyData.story.story.push(chapterData);
                });
                
                // Format and display JSON
                jsonOutput.textContent = JSON.stringify(storyData, null, 2);
                return storyData;
            }
            
            // Show toast notification 
            function showToast(message, isSuccess) {
                toastMessage.textContent = message;
                
                // Clear existing classes
                toast.className = 'toast';
                
                // Add appropriate classes
                toast.classList.add('show');
                toast.classList.add(isSuccess ? 'success' : 'error');
                
                // Set icon
                toast.querySelector('i').className = isSuccess ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';
                
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }
            
            // AJAX function to add story
            function addStory(event) {
                event.preventDefault();
                
                // Get JWT token (in a real app, this would come from authentication)
                 const jwtToken = '${tokenObject.jwt}'; // Ensure tokenObject is defined
                // Generate the story data
                const storyData = generateJson();
                
                // Create the request payload
                const payload = {
                    jwt: jwtToken,
                    story: storyData.story
                };
                
                console.log("Submitting story:", JSON.stringify(payload, null, 2));
                
                // Send AJAX request
                $.ajax({
                    url: '/api/addStory',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(payload),
                    processData: false,
                    success: function(response) {
                        console.log('Success:', response);
                        showToast('Story submitted successfully!', true);
                        
                        // Reset form after successful submission
                        storyForm.reset();
                        chaptersContainer.innerHTML = '';
                        chapterCount = 0;
                        addChapter();
                        jsonPreview.classList.add('hidden');
                    },
                    error: function(xhr, status, error) {
                        console.error('Error:', xhr.responseText);
                        showToast('Failed to submit story: ' + xhr.responseText, false);
                    }
                });
            }
        });
    </script>
    </script> 
<script>
// Accordion
function myFunction(id) {
  var x = document.getElementById(id);
  if (x.className.indexOf("w3-show") == -1) {
    x.className += " w3-show";
    x.previousElementSibling.className += " w3-theme-d1";
  } else { 
    x.className = x.className.replace("w3-show", "");
    x.previousElementSibling.className = 
    x.previousElementSibling.className.replace(" w3-theme-d1", "");
  }
}

// Used to toggle the menu on smaller screens when clicking on the menu button
function openNav() {
  var x = document.getElementById("navDemo");
  if (x.className.indexOf("w3-show") == -1) {
    x.className += " w3-show";
  } else { 
    x.className = x.className.replace(" w3-show", "");
  }
}
</script>

<script>
	function closePack()
	{
		document.getElementById('id_edit_modal').style.display='none'
		
		toggleEditShowPack();
		
	}
	
	function toggleEditShowPack()
	{
		
		const deletePackButton = document.getElementById('DeletePackButton');
		const updatePackButton = document.getElementById('UpdatePackButton');
		
		
		deletePackButton.style.display = 'block';
		updatePackButton.style.display = 'block';
		
        
	}
	</script>

<script>
function addPack(event) {
    event.preventDefault(); // Prevent default form submission

    // Create FormData object
    let formData = new FormData();
    
    // Append individual form fields with correct names
    formData.append('pack_name', document.querySelector('[name="pack_name"]').value);
    formData.append('pack_file_path', document.querySelector('[name="pack_file_path"]').value);
    formData.append('pack_output_path', document.querySelector('[name="pack_output_path"]').value);
    pack_output_path
  
    
    // Append file input
    let fileInput = document.querySelector('[name="pack_file_content"]');
    if (fileInput.files.length > 0) {
        formData.append('pack_file_content', fileInput.files[0]);
    }
    
    // Append JWT token
    const jwtToken = '${tokenObject.jwt}'; // Ensure tokenObject is defined
    formData.append('jwt', jwtToken);

    // Send AJAX request
    $.ajax({
        url: '/api/addContentPack',
        type: 'POST',
        data: formData,
        processData: false, // Ensure jQuery does not process FormData
        contentType: false, // Ensure correct content type for FormData
        success: function(response) {
            console.log('Success:', response);
            alert('Form submitted successfully!');
        },
        error: function(xhr, status, error) {
            console.error('Error:', xhr.responseText);
            alert('Failed to submit the form.');
        }
    });
}

// Attach event listener when the page loads
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById('packForm');
    if (form) {
        form.reset(); // This clears all form fields including text
        const fileInput = document.querySelector('[name="pack_file_content"]');
        if (fileInput) {
            fileInput.value = ''; // Some browsers don’t clear file inputs with .reset()
        }

        form.addEventListener('submit', addPack);
    }
});


 $(document).ready(function() 
  {
  	getPacks();
  	const table = $('#example').DataTable();
  	table.on('click', 'tbody tr', function() 
  	{
  		console.log('API rows values : ', table.row(this).data()[0]);
  		
  		getPackByPackID(table.row(this).data()[0]);
  		
	})
  });

 function getPacks()
  {
  	const table = $('#example').DataTable();
  
  	const jwtToken = '${tokenObject.jwt}';
   
  	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  
  
	$.ajax({
          url: '/api/getContentPacks', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	table.clear();
            
	            response.forEach((item) => {
	                table.row.add([item.id, item.pack_name,item.pack_file_path,item.pack_output_path,item.pack_deployed,item.created_at]);
	            });
            
           		table.draw();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
  }
  
  /************************************************/
function deletePackByPackId()
{
	const jwtToken = '${tokenObject.jwt}';
	const PackId = $('#packIdToEditId').val();
	const PackName = $('#packNameToEditId').val();
	const PackFilePath = $('#packFilePathToEditId').val();

	
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          id: PackId,
          pack_name: PackName,
          pack_schedule: PackSchedule,
          pack_file_path: PackFilePath,
          pack_os_type: PackOsType
        });
  	
  	$.ajax({
          url: '/api/deletePacksByPackId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getPacks();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function updatePackByPackId()
{
	const jwtToken = '${tokenObject.jwt}';
	const PackId = $('#packIdToEditId').val();
	const PackName = $('#packNameToEditId').val();
	const PackDeployed = $('#packDeployedToEditId').val();
	const PackZipFilePath = $('#packFilePathToEditId').val();
	const PackOutputDir = $('#packOutputPathToEditId').val();
	
	console.log("Pack Name to Update: " + PackName);
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          pack_id: PackId,
          pack_name: PackName,
          pack_loaded: PackDeployed,
          zipFilePath: PackZipFilePath,
          outputDir : PackOutputDir
          });
  	
  	$.ajax({
          url: '/api/updatePackByPackId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getPacks();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}

/************************************************/
function getPackByPackID(varId)
{
	const jwtToken = '${tokenObject.jwt}';
	const PackId = varId;
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          pack_id: PackId,
         });
  	
  	$.ajax({
          url: '/api/getPackByPackId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('packNameToEditId').value = response[0].pack_name;
             	document.getElementById('packFilePathToEditId').value = response[0].pack_file_path;
             	document.getElementById('packOutputPathToEditId').value = response[0].pack_output_path;
             	document.getElementById('packDeployedToEditId').value = response[0].pack_deployed;
             	document.getElementById('packIdToEditId').value = response[0].id;
  				document.getElementById('id_edit_modal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
}
  
  document.addEventListener("DOMContentLoaded", function() {
    getPacks();
});
</script>
<script>
 $(document).ready(function() 
 {
 	 $.ajax({
	       url: '/loggedIn/includes/navbar.ftl',  // The URL where the FreeMarker template is rendered
	       method: 'GET',
	       success: function(response) 
	       {
	          console.log("Updating Navbar");
	          $('#navbar').html(response);
	       },
	       error: function(err) 
	       {
	           console.error('Error loading template:', err);
	       }
	    });
	 $.ajax({
	       url: '/loggedIn/includes/leftColumn2.ftl',  // The URL where the FreeMarker template is rendered
	       method: 'GET',
	       success: function(response) 
	       {
	          console.log("Updating leftColumn");
	          $('#leftColumn').html(response);
	          getQueryTypes();
	       },
	       error: function(err) 
	       {
	           console.error('Error loading template:', err);
	       }
	    });
	 
	 $.ajax({
	       url: '/loggedIn/includes/footer.ftl',  // The URL where the FreeMarker template is rendered
	       method: 'GET',
	       success: function(response) 
	       {
	          console.log("Updating Footer");
	          $('#footer').html(response);
	       },
	       error: function(err) 
	       {
	           console.error('Error loading template:', err);
	       }
	    });
});
</script>


<script>

	function openNewWindow() 
	{
		window.open('', '_blank');
	}
   
    function getQueryTypes()
	{
		const var_jwt = '${tokenObject.jwt}';
		const jsonData = JSON.stringify({
		jwt:var_jwt,
	});
	
	console.log(jsonData);
		  
		  
	$.ajax({
		url: '/api/getQueryTypes', 
		type: 'POST',
		data: jsonData,
		contentType: 'application/json; charset=utf-8', // Set content type to JSON
		success: function(response) 
		{
			const queryTypes = document.getElementById('queryTypes');
		    queryTypes.innerHTML = "";
		    console.log(response);
		             	
		    if (Array.isArray(response)) 
		    {
      			$.each(response, function(index, item) 
				{
					console.log(index, item);  
					const span = document.createElement('span');
					span.textContent = item.query_type;
					span.classList.add('w3-tag');
					span.classList.add('w3-small');
					span.classList.add('w3-theme-d'+index);
							
					span.onclick = function() 
					{
                		console.log("Redirecting for: "+ item.query_type);
                		window.location.href='databases.ftl?lookup='+ item.query_type;
            		};
					queryTypes.appendChild(span);
				});
			}             	
		 },
		 error: function(xhr, status, error) 
		 {
		 	$('#response').text('Error: ' + error);
		 }
	});
}
</script>
</body>
</html> 
