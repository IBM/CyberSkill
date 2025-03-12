<!DOCTYPE html>
<html>
<head>
<title>SLP Help</title>
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

<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}
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
        <div class="w3-col m12" id="helpContent">
          
          
      
    
	
      
      		
      
      
      
      
    <!-- End Middle Column -->
    </div>
    
   
    </div>
    
  <!-- End Grid -->
  </div>
  
<!-- End Page Container -->
</div>
<br>

<!-- Footer -->
<div id="footer"></div>
 



<script>

function toggleHelpId(id)
{
	const div = document.getElementById('help'+id);
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

function buildHelp(data)
{
	console.log(data.help);
	
	var helpCardHtml = `
		<!-- BEGINNING OF HELP CARD -->
		<div class="w3-container w3-card w3-white w3-round w3-margin"><br>
		  <!-- The icon that toggles the help section -->
		  <i class="fa fa-plus" onclick="toggleHelpId(1)" style="color: gray; transition: color 0.3s ease;" 
		     onmouseover="this.style.color='red'" onmouseout="this.style.color='gray'"></i>TITLE
		  <span class="w3-right w3-opacity"></span>
		  <br>
		  <hr class="w3-clear">
		
		  <!-- Hidden help content, initially hidden with style display: none -->
		  <div class="help1" id="help1" style="display: none;">
		    <h2>SUBTIT</h2>
		    <p>SUBTEXT</p>
		    <div class="container">
		      HELPTEXT
		    </div>
		  </div>
		</div>
		<!-- END OF HELP CARD -->
		`;
	
	var tempHelpCardHtml = helpCardHtml;
	
	
	var helpContent = document.getElementById("helpContent");
	
	for (var i = 0; i < data.help.length; i++) 
	{
		tempHelpCardHtml = helpCardHtml;
	    tempHelpCardHtml = tempHelpCardHtml.replace(/toggleHelpId\(1\)/g, 'toggleHelpId('+i+')');
	    tempHelpCardHtml = tempHelpCardHtml.replace(/toggleHelpId\(1\)/g, 'toggleHelpId('+i+')');
	    tempHelpCardHtml = tempHelpCardHtml.replace(/help1/g, 'help'+i);
	      		
		for (var key in data.help[i]) 
		{
	    	if (data.help[i].hasOwnProperty(key)) 
	    	{
	      		console.log(key + ': ' + data.help[i][key]);
	     		if(key === "Title") 
	     		{
	     			tempHelpCardHtml = tempHelpCardHtml.replace(/TITLE/g, data.help[i][key]);
	     		}	
	     		if(key === "Subtitle") 
	     		{
	     			tempHelpCardHtml = tempHelpCardHtml.replace(/SUBTIT/g, data.help[i][key]);
	     		}	
	     		if(key === "Subtext") 
	     		{
	     			tempHelpCardHtml = tempHelpCardHtml.replace(/SUBTEXT/g, data.help[i][key]);
	     		}	
	     		if(key === "Helptext") 
	     		{
	     			tempHelpCardHtml = tempHelpCardHtml.replace(/HELPTEXT/g, data.help[i][key]);
	     		}		
	      	    
	      		
	      	}
	      	
	   	}
	   	helpContent.insertAdjacentHTML("beforeend", tempHelpCardHtml);
	}
}
function fetchJSONData() 
{
	fetch('/js/help.json')
    .then(response => response.json())
	.then(data => buildHelp(data))
    .catch(error => console.error("Failed to fetch data:" + error)); 
}

fetchJSONData();  



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
    $(document).ready(function() 
  	{
  		getQueryTypes();
  	});
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
