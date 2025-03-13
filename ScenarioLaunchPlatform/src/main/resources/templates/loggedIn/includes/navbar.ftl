<!-- Navbar -->
<div class="w3-top">
 <div class="w3-bar w3-theme-d2 w3-left-align w3-large">
  <a class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-theme-d2" href="javascript:void(0);" onclick="openNav()"><i class="fa fa-bars"></i></a>
  <a href="/loggedIn/dashboard.ftl" class="w3-bar-item w3-button w3-padding-large w3-theme-d4"><i class="fa fa-home w3-margin-right"></i>SLP</a>
  <a href="/loggedIn/settings.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Settings"><i class="fa fa-cogs"></i></a>
  <a href="/loggedIn/user.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="User"><i class="fa fa-user"></i></a>
  <a href="/loggedIn/databases.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Access"><i class="fa fa-database"></i></a>
  <a href="/loggedIn/scheduler.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Scheduler"><i class="fa fa-clock-o"></i></a>
  <a href="/loggedIn/ostask.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="OS Task"><i class="fa fa-tasks"></i></a>
  <!-- <a href="experimental.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Experimental"><i class="fa fa-flask"></i></a> -->
  <!-- <a href="/plugin/guardium.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Insights"><i class="fa fa-dot-circle-o"></i></a> -->
  <a href="/loggedIn/storyBuilder.ftl" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Story"><i class="fa fa-book"></i></a>
  
  <#if pluginData?has_content>
	<#list pluginData?keys as key>
		<a href="${pluginData[key].url}" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="${key}"><i class="fa fa-dot-circle-o"></i></a>
	</#list>
  <#else>
        [No Active Plugins]
  </#if>
  
 
  <div class="w3-dropdown-hover w3-hide-small">
    <button class="w3-button w3-padding-large" title="Notifications"><i class="fa fa-bell"></i><span class="w3-badge w3-right w3-small w3-green">1</span></button>     
    <div class="w3-dropdown-content w3-card-4 w3-bar-block" style="width:300px">
      <a href="#" class="w3-bar-item w3-button">Welcome to the all new - turbo charged Scenario Launch Platform.</a>
    </div>
  </div>
  <a href="#" class="w3-bar-item w3-button w3-hide-small w3-right w3-padding-large w3-hover-white" title="My Account">
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