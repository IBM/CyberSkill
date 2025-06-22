<!DOCTYPE html>
<html>
<head>
<title>SLP Poweruser</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel='stylesheet' href='css/fonts.css'>
<script src="js/tailwindcss.js"></script>
<script src="js/chatbot.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}
</style>


<script src="js/jquery.min.js"></script>

<script>
function validate()
{
  	
  	const var_username = $('#username').val();
    const var_password = $('#password').val();
  
  	const jsonData = JSON.stringify({
          username: var_username,
          password: var_password
        });
  
  
	$.ajax({
          url: '/api/validateCredentials', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById("myJwtToken").innerHTML = response.jwt;
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
}
</script>

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
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
            	<h6 class="w3-opacity">Current JWT Token</h6>
            	<p id="myJwtToken" contenteditable="true" class="w3-border w3-padding">${tokenObject.jwt}</p>
            
            	<h6 class="w3-opacity">Generate JWT Token</h6>
    			<input type="text" id="username" name="username" placeholder="username..">
            	<p><input type="text" id="password" name="password" placeholder="password.."></p>
              
              <button type="button" class="w3-button w3-theme" onclick="validate();"><i class="fa fa-key"></i>  Generate</button> 
               <p>
            	The JWT tokens currently do not expire, we do this so that you can create scripts that leverage the API's and unless we get to a point where we have security considerations, your scripts will continue to run and function with their first JWT without the need to re-authenticate. However should you wish to generate a JWT token of the correct format, we provide this service - for now its unnecessary, but good practice would suggest you factor in the need to regenerate JWTs in the future.
            	</p>
            </div>
           
          </div>
        </div>
      </div>
      
      
      
    <!-- End Middle Column -->
    </div>
    
   
    </div>
    
  <!-- End Grid -->
  </div>
  
<!-- End Page Container -->
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
