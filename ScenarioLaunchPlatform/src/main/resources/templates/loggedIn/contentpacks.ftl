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
<script src="js/tailwindcss.js"></script>
<script src="js/chatbot.js"></script>
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
              <h6 class="w3-opacity">Content Packs Form</h6>
              <!-- -->
  				<form id="packForm" enctype="multipart/form-data">
     <div id="edit" class="w3-container city">
	<div class="row">
		<div class="col-25">
				         Pack Name: 
		</div>
		<div class="col-75">
			<input type="text" id="pack_name" name="pack_name" class="w3-right w3-white w3-border" placeholder="Example Run_API" required>
		</div>
	</div>
	<div class="row">
				<div class="col-25">
				         Pack File Path: 
				      </div>
				<div class="col-75">
					<input type="text" id="pack_file_path" name="pack_file_path" class="w3-right w3-white w3-border" placeholder="/opt/slp/packs" required>
					</div>
	</div>
	<div class="row">
				<div class="col-25">
				         Pack Deploy Path: 
				      </div>
				<div class="col-75">
					<input type="text" id="pack_output_path" name="pack_output_path" class="w3-right w3-white w3-border" placeholder="/opt/slp/packs/unzipped" >
					</div>
	</div>
	<div class="row">
					<div class="col-25">
				         Pack File 
				      </div>
					<div class="col-75">
						<input type="file" id="pack_file_content" class="w3-left w3-white w3-border" name="pack_file_content" accept=".zip" required>
						</div>
					</div>
	</div>
	    <div class="row">
		<div class="col-25">
	 
				      </div>
					<div class="col-75">
					<button class="w3-button w3-right w3-blue w3-border" type="submit">Submit</button>

					</div>
		</div>
		</div>
   
    
</form>


         
              <!-- -->
            </div>
          </div>
        </div>
      </div>
     <div class="w3-col m9 w3-margin-top">
     <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Packs</h6>
              
              <table id="example" class="display" style="width:100%">
			  <thead>
			    <tr>
			    	<th>id</th>
			      	<th>pack_name</th>      	
			      	<th>pack_file_path</th>
			      	<th>pack_output_path</th>
			      	<th>pack_deployed</th>
			      	<th>created_at</th>
			    </tr>
			  </thead>
			  <tbody>
			    <!-- Data will be inserted here by DataTables -->
			  </tbody>
			</table>
            </div>  
             </div> 
              </div> 
      </div>
      
    <!-- End Middle Column -->
    </div>
    
    <!-- Right Column -->
    
  
      
    <!-- End Right Column -->
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
 <div id="id_edit_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="closePack();getPacks()" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Content Packs</h2>
			  </header>
			
			  <div class="w3-bar w3-border-bottom">
			   <button id="packs" class="tablink w3-bar-item w3-button" onclick="toggleEditResultsShowPacks()">Content Pack</button>
			   

			  </div>
			  
			  <div id="edit" class="w3-container city">
			  <div class="row">
			   		  <div class="col-25">
				         Pack Id: 
				      </div>
				      <div class="col-75">
				        <input type="text" id="packIdToEditId" value="" class="w3-right w3-white w3-border" readonly>
				      </div>
			  	</div>
			  	
			  	<div class="row">
			   		  <div class="col-25">
				         Pack Name: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="packNameToEditId" value="" class="w3-right w3-white w3-border" readonly>
					  </div>
				</div> 
	
				<div class="row">
			   		  <div class="col-25">
				         Pack File Path: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="packFilePathToEditId" value="" class="w3-right w3-white w3-border" >
					  </div>
				</div> 
				<div class="row">
			   		  <div class="col-25">
				         Pack File Path: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="packOutputPathToEditId" value="" class="w3-right w3-white w3-border" >
					  </div>
				</div> 
		
				<div class="row">
			   		  <div class="col-25">
				         Pack Loaded 
				      </div>
				      <div class="col-75">	
						 <input type="text" id="packDeployedToEditId" value="" class="w3-right w3-white w3-border" >
					</div>
				</div> 
			 </div>
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button id="UpdatePackButton" class="w3-button w3-right w3-white w3-border" onclick="updatePackByPackId()">Deploy</button>
			   <button id="ClosePackButton" class="w3-button w3-right w3-white w3-border" onclick="closePack()">Close</button>
			  </div>
			</div>
			
			<!-- EOF Modal --> 
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
