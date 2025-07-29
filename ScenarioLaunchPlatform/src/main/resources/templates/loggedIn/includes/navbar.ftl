<!-- Navbar -->
<div class="w3-top">
 <div class="w3-bar w3-theme-d2 w3-left-align w3-large">
  <a class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-theme-d2" href="javascript:void(0);" onclick="openNav()"><i class="fa fa-bars"></i></a>
  <a href="/loggedIn/dashboard.ftl" class="w3-bar-item w3-button w3-padding-large w3-theme-d4"><i class="fa fa-home w3-margin-right"></i>SLP</a>
  <a href="/loggedIn/settings.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Connections"><i class="fa fa-cogs"></i></a>
  <a href="/loggedIn/user.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="User"><i class="fa fa-user"></i></a>
  <a href="/loggedIn/databases.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Building Block Queries"><i class="fa fa-database"></i></a>
  <a href="https://ibm.github.io/CyberSkill/" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Support Videos" target="_blank"><i class="fa fa-film"></i></a>
  <a href="/loggedIn/contentpacks.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Content Packs"><i class="fa fa-suitcase"></i></a>
  <a href="/loggedIn/ostask.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="OS Scheduled Tasks"><i class="fa fa-tasks"></i></a>
  <a href="/loggedIn/storyRunner.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Story Runner"><i class="fa fa-book"></i></a>
   <a href="/loggedIn/storyCreator.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Story Creator"><i class="fa fa-wrench"></i></a>
  <span id="plugins">[No Active Plugins]</span>
  
 
  <div class="w3-dropdown-hover w3-hide-small">
    <button class="w3-button w3-padding-large" title="Notifications"><i class="fa fa-bell"></i><span class="w3-badge w3-right w3-small w3-green">1</span></button>     
    <div class="w3-dropdown-content w3-card-4 w3-bar-block" style="width:300px">
      <a href="#" class="w3-bar-item w3-button">Welcome to the all new - turbo charged Scenario Launch Platform.</a>
    </div>
  </div>
  <a href="/loggedIn/adminFunctions.ftl" class="w3-bar-item w3-button w3-hide-small w3-right w3-padding-large w3-hover-white" title="Account Functions">
    <img src="/w3images/avatar2.png" class="w3-circle" style="height:23px;width:23px" alt="Avatar">
  </a>
 </div>
</div>

<!-- Navbar on small screens -->
<div id="navDemo" class="w3-bar-block w3-theme-d2 w3-hide w3-hide-large w3-hide-medium w3-large">
  <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 1</a>
  <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 2</a>
  <a href="#" class="w3-bar-item w3-button w3-padding-large">Link 3</a>
  <a href="#" class="w3-bar-item w3-button w3-padding-large">My Profile</a>
</div>


<script>

	const var_jwt = '${tokenObject.jwt}';
	const jsonData = JSON.stringify({
		jwt:var_jwt
	});

	$.ajax({
		url: '/api/getAvailablePlugins', 
		type: 'POST',
		data: jsonData,
		contentType: 'application/json; charset=utf-8', // Set content type to JSON
		dataType: 'json',
		success: function(response) 
		{
			const plugins = document.getElementById('plugins');
		    plugins.innerHTML = "";
		    console.log(response);
		             	
		    if (Array.isArray(response) && response.length > 0) 
		    {
		    	console.log("Have detected an array in the response");
      			
      				$.each(response, function(index, item) 
					{
						console.log(index, item.name);  
						const span = document.createElement('span');
						// Create a new anchor element
						let link = document.createElement("a");
						link.href = item.url;
						link.classList.add("w3-bar-item");
						link.classList.add("w3-button");
						link.classList.add("w3-hide-small");
						link.classList.add("w3-padding-large");
						link.classList.add("w3-hover-white");
						
						link.target = "_blank"; // Opens in a new tab
						
						
						let icon = document.createElement("i");
						icon.className = item.icon; 
						link.prepend(icon);
						
						
						
						
						span.appendChild(link);
						plugins.appendChild(span);
					});
				
			}             	
		 },
		 error: function(xhr, status, error) 
		 {
		 	$('#response').text('Error: ' + error);
		 }
	});
	

</script>