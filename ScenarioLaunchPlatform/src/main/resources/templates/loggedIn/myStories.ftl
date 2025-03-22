<!DOCTYPE html>
<html>
<head>
<title>MyStories</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<script src="js/jquery.min.js"></script>
<link rel='stylesheet' href='css/fonts.css'>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}


.avatar {
  vertical-align: middle;
  width: 50px;
  height: 50px;
  border-radius: 50%;
}



</style>


<style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
</style>
    
    
</head>
<body class="w3-theme-l5">



<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">    
  <!-- The Grid -->
  <div class="w3-row">
    <!-- Left Column -->
    
    
    <!-- End Left Column -->
    </div>
    
    <!-- Middle Column -->
    
    <!-- Modal structure -->
    <div id="myModal" class="w3-modal">
        <div class="w3-modal-content">
            <header class="w3-container w3-blue-grey">
                <span onclick="closeModal()" class="w3-button w3-display-topright">&times;</span>
                <h2>Chapter query details </h2>
            </header>
            <div class="w3-container">
                <p id="modalContent">Loading...</p> <!-- This will be populated via AJAX -->
            </div>
        </div>
    </div>
    
    
    
    <div class=""w3-col s12 w3-container">
    
      <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity"><div id="StoryTitle"><div></h6>
              <!-- -->
              <!-- -->
            </div>
          </div>
        </div>
      </div>
     <div class="StoryChaptersCompleted" id="StoryChaptersCompleted">
     </div>
     
     
      
      
      
      
    <!-- End Middle Column -->
    </div>
    
    <!-- Right Column -->
    
  
      
    <!-- End Right Column -->
    </div>
    
  <!-- End Grid -->
  </div>
  
<!-- End Page Container -->
</div>
<br>

    
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
	var queryString = window.location.search;
	var urlParams = new URLSearchParams(queryString);
	var storyID = urlParams.get('storyID'); 
	console.log("storyID: "+ storyID);
	
	runStoryById(storyID);
	
	function runStoryById(id)
	{
		const storyID = +id;
		
		console.log("Story id to execute: " + id);
	
		const jwtToken = '${tokenObject.jwt}';
	   	const jsonData = JSON.stringify({
	          jwt: jwtToken,
	          id: storyID,
	        });
	    
	    setTimeout(() => 
	    {    
			let StoryTitle = document.getElementById("StoryTitle");
			
			
			
			$.ajax({
		          url: '/api/runStoryById', 
		          type: 'POST',
		          data: jsonData,
		          contentType: false, // Let jQuery handle it automatically
		    	processData: false, // Do not convert data to a query string
		          success: function(response) 
		          {
		          if (response.length > 0) {
		            let storyData = response[0]; // Extract first object from the array
		
		            // Extract values
		            let storyName = storyData.story.name;
		            let author = storyData.story.author;
		            let description = storyData.story.description;
		            let outcomes = storyData.story.outcomes;
		            let handbook = storyData.story.handbook;
		            let queries = storyData.story.story; // Array of queries
		
		            console.log("📌 Story Name:", storyName);
		            console.log("📌 Author:", author);
		            console.log("📌 Description:", description);
		            console.log("📌 Outcomes:", outcomes);
		            console.log("📌 Handbook:", handbook);
		            console.log("📌 Queries:", queries); // Logs full array of queries
		            
		            
		            StoryTitle.innerHTML = storyName;
		
		        }
		            console.log("Response Body:", JSON.stringify(response, null, 2));
		             
		          },
		          error: function(xhr, status, error) 
		          {
		            $('#response').text('Error: ' + error);
		          }
		        });
	   	}, 2000);
	}

</script>




<script>
 
 
 $.ajax({
       url: '/loggedIn/includes/navbar.ftl',  // The URL where the FreeMarker template is rendered
       method: 'GET',
       success: function(response) 
       {
          $('#navbar').html(response);
       },
       error: function(err) 
       {
           console.error('Error loading template:', err);
       }
    });
 
 
 $.ajax({
       url: '/loggedIn/includes/leftColumn.ftl',  // The URL where the FreeMarker template is rendered
       method: 'GET',
       success: function(response) 
       {
          $('#leftColumn').html(response);
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
          $('#footer').html(response);
       },
       error: function(err) 
       {
           console.error('Error loading template:', err);
       }
    });
 
 
</script>


<script>

const relativeUrl = '/websocket/story/username';
const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
const wsUrl = protocol+ "//" + window.location.host + relativeUrl;




 var storyChapterCard = `	<br>
      <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">My Stories</h6>
              <!-- -->
	             <table>
			        <tr>
			            <th rowspan="2"> <img src="/w3images/AVATAR.png" alt="Avatar" class="avatar"></th>
			            <th>Details</th>
			        </tr>
			        <tr>
			            <td>Database: DATABASE<br>
			            	DBTYPE<br>
			            	HOSTNAME<br>
			            	<button class="w3-button w3-blue-grey" onclick="openModal(QUERYID)">Query</button>
			            </td>
			        </tr>
			    </table>
             
              <!-- -->
            </div>
          </div>
        </div>
      </div>`;








const socket = new WebSocket(wsUrl); 

// Connection opened
socket.addEventListener("open", () => {
    console.log("Connected to WebSocket server");
    socket.send("Hello, Server!"); // Send a message to the server
});

// Listen for messages
socket.addEventListener("message", (event) => {
    console.log("Message from server:", event.data);
    
    let parsedMessageObject = JSON.parse(event.data);
    
    console.log("parsedMessageObject.query_id: ",  parsedMessageObject.query_id);
    console.log("parsedMessageObject.datasource: ",  parsedMessageObject.datasource);
    
    const parts = parsedMessageObject.datasource.split("_");
    
    let dbType = parts[0];
    let hostname = parts[1];
    let db = parts[2];
    let user = parts[3];
    
    console.log("user: " + user);
    
    
    console.log("parsedMessageObject.pause_in_seconds: ",  parsedMessageObject.pause_in_seconds);
    
    
    var tempStoryChapterCard = storyChapterCard;
	var StoryChapter = document.getElementById("StoryChaptersCompleted");
	
	tempStoryChapterCard = tempStoryChapterCard.replace(/AVATAR/g, user);
	tempStoryChapterCard = tempStoryChapterCard.replace(/DATABASE/g, db);
	tempStoryChapterCard = tempStoryChapterCard.replace(/DBTYPE/g, dbType);
	tempStoryChapterCard = tempStoryChapterCard.replace(/HOSTNAME/g, hostname);
	tempStoryChapterCard = tempStoryChapterCard.replace(/QUERYID/g, parsedMessageObject.query_id);
	
	StoryChapter.insertAdjacentHTML("beforeend", tempStoryChapterCard);
    
});

// Handle errors
socket.addEventListener("error", (error) => {
    console.error("WebSocket error:", error);
});

// Handle connection close
socket.addEventListener("close", () => {
    console.log("WebSocket connection closed");
});

</script>


<script>
        // Function to open the modal
        function openModal(queryId) 
        {
            document.getElementById('myModal').style.display = 'block';
            console.log("queryId: " + queryId);
            fetchQueryData(queryId);  // Make the AJAX request to fetch data
        }

        // Function to close the modal
        function closeModal() 
        {
            document.getElementById('myModal').style.display = 'none';
        }

        function fetchQueryData(varqueryId) 
        {
        	const queryId = +varqueryId;
        	const jwtToken = '${tokenObject.jwt}';
	   		const jsonData = JSON.stringify({
	          jwt: jwtToken,
	          query_id: queryId,
	        });
        
            $.ajax({
            	  url: '/api/getDatabaseQueryByQueryId', 
		          type: 'POST',
		          data: jsonData,
		          contentType: false, 
		    	  processData: false,
		          success: function(response) 
		          {
                    // Populate the modal with the response data
                    $('#modalContent').html('<strong>Query:</strong> ' + response[0].query_string);
	              },
	              error: function() 
	              {
	                    $('#modalContent').html('<strong>Error loading data</strong>');
	              }
            });
        }
    </script>


</body>
</html> 
