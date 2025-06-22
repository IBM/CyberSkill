<!DOCTYPE html>
<html>
<head>
<title>Story Builder</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<script src="js/jquery.min.js"></script>
<link rel='stylesheet' href='css/fonts.css'>
<script src="js/tailwindcss.js"></script>
<script src="js/chatbot.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}

.row {
    display: flex;
    align-items: center;
    gap: 10px; /* Adds spacing between h3 and h4 */
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
    
      <div class="w3-row-padding">
        <div class="w3-col m12" id="storyContent">
          
          
      
    
	
      
      		
      
      
      
      
    <!-- End Middle Column -->
    </div>
   
    
    <!-- Right Column -->
    
  
      
    <!-- End Right Column -->
    </div>
    
  <!-- End Grid -->
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
<!-- End Page Container -->
</div>
<br>

<!-- Footer -->
<div id="footer"></div>
 
<script>

function toggleStoryId(id)
{
	const div = document.getElementById('story'+id);
	if (div.style.display === 'none' || div.style.display === '') 
	{
    	div.style.display = 'block'; // Show the div
  	} 
  	else 
  	{
     	div.style.display = 'none'; // Hide the div
    }
}


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

function buildStory(data)
{
	console.log(data);
	
	
	
	
	
	var storyCardHtml = `
		<!-- BEGINNING OF STORY CARD -->
		<div class="w3-container w3-card w3-white w3-round w3-margin"><br>
		  <!-- The icon that toggles the help section -->
		  <i class="fa fa-plus" onclick="toggleStoryId(1)" style="color: gray; transition: color 0.3s ease;" 
		     onmouseover="this.style.color='red'" onmouseout="this.style.color='gray'"></i><strong> Story:</strong> TITLE
		     
		     
		  <span class="w3-right w3-opacity"><button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="runStoryById(STORY_ID);"><i class="fa fa-rocket"></i>  Run</button></span>
		  <br>
		  <hr class="w3-clear">
		
		  <!-- Hidden story content, initially hidden with style display: none -->
	
		<div class="story1" id="story1" style="display: none;">
    <div class="row">
        <strong>Outcome:</strong> OUTCOMES
    </div>
    <div class="row">
        <strong>Creator:</strong><i>AUTHOR</i>
    </div>
    <div class="container">
      
           <strong>Summary:</strong> DESCRIPTION
           	<div id="storyVideo">
           	<a href="VIDEOURL" target="_blank"><i class="fa fa-film"></i></a>
    		</div>
    </div>
    
</div>
		<!-- END OF STORY CARD -->
		`;
	
	var tempStoryCardHtml = storyCardHtml;
	
	
	var storyContent = document.getElementById("storyContent");
	
	for (var i = 0; i < data.length; i++) 
	{
		tempStoryCardHtml = storyCardHtml;
		console.log(data[i]);
		
		
		tempStoryCardHtml = storyCardHtml;
	    tempStoryCardHtml = tempStoryCardHtml.replace(/toggleStoryId\(1\)/g, 'toggleStoryId('+i+')');
	    tempStoryCardHtml = tempStoryCardHtml.replace(/toggleStoryId\(1\)/g, 'toggleStoryId('+i+')');
	    tempStoryCardHtml = tempStoryCardHtml.replace(/story1/g, 'story'+i);
	    
	    
	    Object.entries(data[i]).forEach(([key, value]) => 
	    {
  			console.log("key: " + key + " value:" + value );
  			if(key==="id")
  			{
  				console.log("id: " + value);
  				tempStoryCardHtml = tempStoryCardHtml.replace(/STORY_ID/g, value);
  			}
  			
  			if(key === "story")
	    	{
	    		console.log("Name:" + value.name);
	    		console.log("Author: " + value.author);
	    		console.log("Handbook: " + value.handbook);
	    		console.log("Outcomes: " + value.outcomes);
	    		console.log("description: " + value.description);
	    		
	    		
	    		
	     		tempStoryCardHtml = tempStoryCardHtml.replace(/TITLE/g, value.name);
	     		tempStoryCardHtml = tempStoryCardHtml.replace(/OUTCOMES/g, value.outcomes);     			    		
	    		tempStoryCardHtml = tempStoryCardHtml.replace(/AUTHOR/g, value.author);
	    		tempStoryCardHtml = tempStoryCardHtml.replace(/DESCRIPTION/g, value.description);
	    		tempStoryCardHtml = tempStoryCardHtml.replace(/VIDEOURL/g, value.video);
	    		
	    		
	    		let chapters = value.story;
	    		Object.entries(chapters).forEach(([key, value]) => 
	    		{
	    			console.log("queryId: " + value.query_id);
	    			console.log("datasource: " + value.datasource);
	    			console.log("pause_in_seconds: " + value.pause_in_seconds);
	    		});
	    		
	    		
	    		
	    	}
		});
	    storyContent.insertAdjacentHTML("beforeend", tempStoryCardHtml);
	 }
}
function fetchJSONData() 
{
	fetch('/api/getAllStories',{
	  method: 'POST',
	  headers: {
	    'Content-Type': 'application/json', // Set content type to JSON
	  },
	  body: JSON.stringify({
	    jwt: '${tokenObject.jwt}'
	  }),
	})
    .then(response => response.json())
	.then(data => buildStory(data))
    .catch(error => console.error("Failed to fetch data:" + error)); 
}

fetchJSONData();  

function openMyStories(storyID) {
    const width = window.innerWidth / 2; // 50% of current window width
    const height = window.innerHeight / 2; // 50% of current window height
    const left = window.screenX + (window.innerWidth - width) / 2; // Center horizontally
    const top = window.screenY + (window.innerHeight - height) / 2; // Center vertically

	const features = "width=" + width + ",height=" + height + ",top=" + top + ",left=" + left;
	
    const newWindow = window.open(
        "myStories.ftl"+"?storyID="+storyID, // Change URL as needed
        "_blank",
        features
    );

    if (newWindow) {
        newWindow.focus(); // Bring the new window to the front
    } else {
        alert("Pop-up are blocked! Please allow pop-ups ");
    }
}



function runStoryById(id)
{
	const storyID = id;
	openMyStories(storyID);
}

function getConnections()
{
  	const jwtToken = '${tokenObject.jwt}';
   	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  
  
	$.ajax({
          url: '/api/getDatabaseConnections', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
            console.log("Successfully loaded database connections");	
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
        
        $.ajax({
          url: '/api/getValidatedDatabaseConnections', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
            console.log("Successfully validated database connections");	
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
 }


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
