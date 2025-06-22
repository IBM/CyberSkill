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
<script src="js/tailwindcss.js"></script>
<script src="js/chatbot.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

<#include "includes/navbar.ftl">

<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">    
  <!-- The Grid -->
  <div class="w3-row">
    <!-- Left Column -->
    <div id="leftColumn"><#include "includes/leftColumn.ftl"></div>
    
    <!-- End Left Column -->
    </div>
    
    <!-- Middle Column -->
    <div class="w3-col m9">
    
      <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">My Stories</h6>
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

<!-- Footer -->
<#include "includes/footer.ftl">
    
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
			            	Query: QUERYID
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


</body>
</html> 
