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
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}
</style>
</head>
<body class="w3-theme-l5">

<#include "includes/navbar.ftl">

<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">    
  <!-- The Grid -->
  <div class="w3-row">
    <!-- Left Column -->
    <#include "includes/leftColumn.ftl">
    
    <!-- End Left Column -->
    </div>
    
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
  
<!-- End Page Container -->
</div>
<br>

<!-- Footer -->
<#include "includes/footer.ftl">
 
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
		     onmouseover="this.style.color='red'" onmouseout="this.style.color='gray'"></i>TITLE 
		     
		     
		  <span class="w3-right w3-opacity"><button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="runStoryById(STORY_ID);"><i class="fa fa-rocket"></i>  Run</button></span>
		  <br>
		  <hr class="w3-clear">
		
		  <!-- Hidden story content, initially hidden with style display: none -->
		  <div class="story1" id="story1" style="display: none;">
		    <h2>OUTCOMES</h2>
		    <p>AUTHOR</p>
		    <div class="container">
		      DESCRIPTION
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


function runStoryById(id)
{
	console.log("Story id to execute: " + id);
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

</body>
</html> 
