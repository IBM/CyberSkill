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


</script>






</body>
</html> 
