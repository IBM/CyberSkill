<!-- Navbar -->
<style>
*, *::before, *::after { box-sizing: border-box !important; }
.w3-top, .w3-top *, .w3-bar, .w3-bar *, .w3-bar-item, .w3-button,
.w3-hover-white, .w3-padding-large {
  border-radius: 0 !important;
  box-sizing: border-box !important;
}
.w3-bar .w3-button, .w3-bar .w3-bar-item {
  border-radius: 0 !important;
  box-sizing: border-box !important;
}
.w3-bar .w3-button:hover, .w3-bar .w3-bar-item:hover,
.w3-bar .w3-hover-white:hover {
  background-color: white !important;
  color: #000 !important;
  border-radius: 0 !important;
}
</style>
<div class="w3-top" style="border-radius:0 !important;">
 <div class="w3-bar w3-theme-d2 w3-left-align w3-large" style="border-radius:0 !important;">
  <a style="border-radius:0 !important;" class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-theme-d2" href="javascript:void(0);" onclick="openNav()"><i class="fa fa-bars"></i></a>
  <a style="border-radius:0 !important;" href="/loggedIn/dashboard.ftl" class="w3-bar-item w3-button w3-padding-large w3-theme-d4"><i class="fa fa-home w3-margin-right"></i>SLP</a>
  <a style="border-radius:0 !important;" href="/loggedIn/settings.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Connections"><i class="fa fa-cogs"></i></a>
  <a style="border-radius:0 !important;" href="/loggedIn/user.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="User"><i class="fa fa-user"></i></a>
  <a style="border-radius:0 !important;" href="/loggedIn/databases.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Building Block Queries"><i class="fa fa-database"></i></a>
  <a style="border-radius:0 !important;" href="https://ibm.github.io/CyberSkill/" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Support Videos" target="_blank"><i class="fa fa-film"></i></a>
  <a style="border-radius:0 !important;" href="/loggedIn/contentpacks.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Content Packs"><i class="fa fa-suitcase"></i></a>
   <#if accessFlag?? && accessFlag>
 <a style="border-radius:0 !important;" href="/loggedIn/ostask.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="OS Scheduled Tasks"><i class="fa fa-tasks"></i></a>
  <#else>
  <a style="border-radius:0 !important;" href="/loggedIn/noAccess.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="OS Scheduled Tasks"><i class="fa fa-tasks"></i></a>
  </#if>
  
  <a style="border-radius:0 !important;" href="/loggedIn/storyRunner.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Story Runner"><i class="fa fa-book"></i></a>
   <a style="border-radius:0 !important;" href="/loggedIn/storyCreator.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Story Creator"><i class="fa fa-wrench"></i></a>
   <a style="border-radius:0 !important;" href="/loggedIn/attackLibrary.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Attack Pattern Library"><i class="fa fa-bug"></i></a>
   <a style="border-radius:0 !important;" href="/loggedIn/outliers.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Outliers - Scheduled Scripts"><i class="fa fa-clock-o"></i></a>
  <span id="plugins">[No Active Plugins]</span>
  
 
  <div class="w3-dropdown-hover w3-hide-small">
    <button style="border-radius:0 !important;" class="w3-button w3-padding-large" title="Notifications"><i class="fa fa-bell"></i><span class="w3-badge w3-right w3-small w3-green">1</span></button>
    <div class="w3-dropdown-content w3-card-4 w3-bar-block" style="width:300px">
      <a style="border-radius:0 !important;" href="#" class="w3-bar-item w3-button">Welcome to the all new - turbo charged Scenario Launch Platform.</a>
    </div>
  </div>
  <#if accessFlag?? && accessFlag>
  <a style="border-radius:0 !important;" href="/loggedIn/adminFunctions.ftl" class="w3-bar-item w3-button w3-hide-small w3-right w3-padding-large w3-hover-white" title="Account Functions">
  <img src="/w3images/avatar2.png" class="w3-circle" style="height:23px;width:23px" alt="Avatar"></a>
  <#else>
  <a style="border-radius:0 !important;" href="/loggedIn/noAccess.ftl" class="w3-bar-item w3-button w3-hide-small w3-right w3-padding-large w3-hover-white" title="Account Functions No Permission">
    <img src="/w3images/avatar2.png" class="w3-circle" style="height:23px;width:23px" alt="Avatar">
  </a>
  </#if>
 </div>
</div>

<!-- Navbar on small screens -->
<div id="navDemo" class="w3-bar-block w3-theme-d2 w3-hide w3-hide-large w3-hide-medium w3-large">
  <a style="border-radius:0 !important;" href="#" class="w3-bar-item w3-button w3-padding-large">Link 1</a>
  <a style="border-radius:0 !important;" href="#" class="w3-bar-item w3-button w3-padding-large">Link 2</a>
  <a style="border-radius:0 !important;" href="#" class="w3-bar-item w3-button w3-padding-large">Link 3</a>
  <a style="border-radius:0 !important;" href="#" class="w3-bar-item w3-button w3-padding-large">My Profile</a>
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
						link.style.borderRadius = "0";
						link.style.setProperty("border-radius", "0", "important");
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