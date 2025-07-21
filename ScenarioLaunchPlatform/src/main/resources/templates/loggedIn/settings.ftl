<!DOCTYPE html>
<html>
<head>
<title>SLP Settings</title>
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


<script>
function getConnectionById()
  {
  	const jwtToken = '${tokenObject.jwt}';
   	const select_editConnections = document.getElementById("editConnections");
    const var_id = select_editConnections.value;
    
   
   	
  	const jsonData = JSON.stringify({
          jwt: jwtToken,
          id: var_id
        });
  
  
	$.ajax({
          url: '/api/getDatabaseConnectionsById', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	
             	response.forEach((item) => 
             	{
	            	console.log(item.id);
	            	
	            	$('#edit_status').val(item.status);
					$('#edit_db_type').val(item.db_type);
					$('#edit_db_version').val(item.db_version);
					$('#edit_db_username').val(item.db_username);
					$('#edit_db_password').val(item.db_password);
					$('#edit_db_port').val(item.db_port);
					$('#edit_db_database').val(item.db_database);
					$('#edit_db_url').val(item.db_url);
					$('#edit_db_jdbcClassName').val(item.db_jdbcclassname);
					$('#edit_db_userIcon').val(item.db_usericon);
					$('#edit_db_databaseIcon').val(item.db_databaseicon);
					$('#edit_db_alias').val(item.db_alias);
					$('#edit_db_access').val(item.db_access);
				
	            	
	            	
	            	
  				});
	            
          	document.getElementById('id_edit_modal').style.display='block'; 		
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
          
        });
  }
  
  
function refreshConnections()
{
  	
  	
  	
  	document.getElementById('refreshConnections').style.color = 'blue';
  	
  	
  	const jwtToken = '${tokenObject.jwt}';
   	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  $.ajax({
          url: '/api/getRefreshedDatabaseConnections', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	response.forEach((item) => 
             	{
	            	console.log(item.id);
	            	
	            	$('#edit_status').val(item.status);
					$('#edit_db_type').val(item.db_type);
					$('#edit_db_version').val(item.db_version);
					$('#edit_db_username').val(item.db_username);
					$('#edit_db_password').val(item.db_password);
					$('#edit_db_port').val(item.db_port);
					$('#edit_db_database').val(item.db_database);
					$('#edit_db_url').val(item.db_url);
					$('#edit_db_jdbcClassName').val(item.db_jdbcclassname);
					$('#edit_db_userIcon').val(item.db_usericon);
					$('#edit_db_databaseIcon').val(item.db_databaseicon);
					$('#edit_db_alias').val(item.db_alias);
					$('#edit_db_access').val(item.db_access);
				});
				document.getElementById('refreshConnections').style.color = 'green';
				getConnections();
	      },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
            document.getElementById('refreshConnections').style.color = 'red';
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
              <h6 class="w3-opacity"><i class="fa fa-refresh" id="refreshConnections" onclick="refreshConnections();" style="color: gray; transition: color 0.3s ease;" onmouseover="this.style.color='purple'" onmouseout="this.style.color='gray'"></i> kill all active database connections 
              <div class="tooltip">
  						Read how this works.
  						<span class="tooltiptext">This process will destroy all current database connections, and will perform a database lookup to see what connections are set to active. It will then create new connections from this updated list. This is different to verifying connections, which uses the in memory objects to recreate the connections. A brief warning - depending on the speed of the database, rapidly calling this function, can attempt to create connections before the previous connections have fully closed, potentially meaning the database will refuse new connections. In such a case - just wait a minute and try again. Let the database chill baby! </span>
				</div></h6>
              
	              <table id="connectionsTable" class="display" style="width:100%">
				  <thead>
				    <tr>
				      <th>Connection id</th>
				      <th>Alias</th>
				      <th>Access</th>
				      <th>Status</th>
				    </tr>
				  </thead>
				  <tbody>
				    <!-- Data will be inserted here by DataTables -->
				  </tbody>
				</table>
              
              
              <button type="button" class="w3-button w3-theme" onclick="getConnections();"><i class="fa fa-check"></i> Verify all active connections</button> 
            </div>
          </div>
        </div>
      </div>
      
      <div class="w3-container w3-card w3-white w3-round w3-margin"><br>
        <i class="fa fa-plus" onclick="toggleDiv()" style="color: gray; transition: color 0.3s ease;" 
   onmouseover="this.style.color='red'" 
   onmouseout="this.style.color='gray'"></i> Add New Connection
        <span class="w3-right w3-opacity"></span>
        <br>
	        <hr class="w3-clear">
        <div class ="AddNewConnection" id="AddNewConnection" style="display: none;"> 
	        
				        
				<h2>Add new connection</h2>
				<p>Add a new connection to be able to execute SQL against that connection.</p>
				
			<!-- -->
				<div id="addConnectionResponseModal" class="w3-modal">
				    <div class="w3-modal-content">
				      <div class="w3-container">
				        <span onclick="document.getElementById('addConnectionResponseModal').style.display='none';toggleDiv();" class="w3-button w3-display-topright">&times;</span>
				        <p id="addConnectionResponse"></p>
				        
				      </div>
				    </div>
				  </div>
			<!-- -->	
				
				<div class="container">
				    <div class="row">
				      <div class="col-25">
				        <label for="status">status</label>
				      </div>
				      <div class="col-75">
				        <select id="new_status" name="status">
				          <option value="active">active</option>
				          <option value="inactive">inactive</option>
				        </select>
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_type">db_type *</label>
				      </div>
				      <div class="col-75">
				        <select id="new_db_type" name="db_type">
				          <option value="mysql">mysql</option>
				          <option value="postgresql">postgresql</option>
				          <option value="db2">db2</option>
				          <option value="sqlserver">sqlserver</option>
				            <option value="oracle">oracle</option>
				        </select>
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_version">db_version</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_version" name="db_version" placeholder="db_version..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_username">db_username *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_username" name="db_username" placeholder="db_username..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_password">db_password *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_password" name="db_password" placeholder="db_password..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_port">db_port *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_port" name="db_port" placeholder="db_port..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_database">db_database *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_database" name="db_database" placeholder="db_database..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_url">db_url *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_url" name="db_url" placeholder="db_url..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_jdbcClassName">db_jdbcClassName *</label>
				      </div>
				      <div class="col-75">
				        <select id="new_db_jdbcClassName" name="db_jdbcClassName">
				          <option value="com.ibm.db2.jcc.DB2Driver">db2</option>
				          <option value="com.mysql.cj.jdbc.Driver">mysql</option>
				          <option value="org.postgresql.Driver">postgresql</option>
				          <option value="com.microsoft.sqlserver.jdbc.SQLServerDriver">sqlserver</option>
				           <option value="oracle.jdbc.driver.OracleDriver">oracle</option>
				        </select>
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_userIcon">db_userIcon</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_userIcon" name="db_userIcon" placeholder="db_userIcon..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_databaseIcon">db_databaseIcon</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_databaseIcon" name="db_databaseIcon" placeholder="db_databaseIcon..">
				      </div>
				    </div>
				      <div class="row">
				      <div class="col-25">
				        <label for="db_alias">db_alias</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_alias" name="db_alias" placeholder="db_alias..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_access">db_access</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="new_db_access" name="db_access" placeholder="db_access..">
				      </div>
				    </div>
				    <div class="row">
				     <div class="col-25">
				        
				      </div>
				     <div class="col-75">
				        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align"  onclick="addNewConnection();"><i class="fa fa-plus"></i>  Add</button> 
				      </div>	
				    </div>
				</div>
			
			</div>
		 </div>
      
    <!-- Card -->
    
    		<!-- Modal -->
			
			<div id="alert_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="document.getElementById('id_edit_modal').style.display='none'; getConnections();" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Edit Connection</h2>
			  </header>
			
			  <div class="w3-bar w3-border-bottom">
			   <button class="tablink w3-bar-item w3-button">SQL Connection Info</button>
			  </div>
			
			  <div id="edit" class="w3-container city">
		
			 
			  </div>
			
			  
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button class="w3-button w3-right w3-white w3-border" 
			   onclick="document.getElementById('id_edit_modal').style.display='none';">Close</button>
			  </div>
			 </div>
			</div>
			
			<!-- EOF Modal --> 
    
    
    
			    <!-- Modal -->
			
			<div id="id_edit_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="document.getElementById('id_edit_modal').style.display='none';" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Edit Connection</h2>
			  </header>
			
			  <div class="w3-bar w3-border-bottom">
			   <button id="updateResponse" class="tablink w3-bar-item w3-button">SQL Connection Info</button>
			  </div>
			
			  <div id="edit" class="w3-container city">
			 
			 <div class="row">
				      <div class="col-25">
				        <label for="status">status</label>
				      </div>
				      <div class="col-75">
				        <select id="edit_status" name="status">
				          <option value="active">active</option>
				          <option value="inactive">inactive</option>
				        </select>
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_type">db_type *</label>
				      </div>
				      <div class="col-75">
				        <select id="edit_db_type" name="db_type">
				          <option value="mysql">mysql</option>
				          <option value="postgresql">postgresql</option>
				          <option value="db2">db2</option>
				          <option value="sqlserver">sqlserver</option>
				           <option value="oracle">oracle</option>
				        </select>
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_version">db_version</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_version" name="db_version" placeholder="db_version..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_username">db_username *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_username" name="db_username" placeholder="db_username..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_password">db_password *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_password" name="db_password" placeholder="db_password..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_port">db_port *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_port" name="db_port" placeholder="db_port..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_database">db_database *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_database" name="db_database" placeholder="db_database..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_url">db_url *</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_url" name="db_url" placeholder="db_url..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_jdbcClassName">db_jdbcClassName *</label>
				      </div>
				      <div class="col-75">
				        <select id="edit_db_jdbcClassName" name="db_jdbcClassName">
				          <option value="com.ibm.db2.jcc.DB2Driver">db2</option>
				          <option value="com.mysql.cj.jdbc.Driver">mysql</option>
				          <option value="org.postgresql.Driver">postgresql</option>
				          <option value="com.microsoft.sqlserver.jdbc.SQLServerDriver">sqlserver</option>
				          <option value="oracle.jdbc.driver.OracleDriver">oracle</option>
				        </select>
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_userIcon">db_userIcon</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_userIcon" name="db_userIcon" placeholder="db_userIcon..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_databaseIcon">db_databaseIcon</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_databaseIcon" name="db_databaseIcon" placeholder="db_databaseIcon..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_alias">db_alias</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_alias" name="db_alias" placeholder="db_alias..">
				      </div>
				    </div>
				    <div class="row">
				      <div class="col-25">
				        <label for="db_access">db_access</label>
				      </div>
				      <div class="col-75">
				        <input type="text" id="edit_db_access" name="db_access" placeholder="db_access..">
				      </div>
				    </div>
				    <div class="row">
				     <div class="col-25">
				        
				      </div>
				     <div class="col-75">
				        <!-- <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align"  onclick="updateConnection();"><i class="fa fa-floppy-o"></i>  Save</button> -->
				        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align"  onclick="deleteConnection();"><i class="fa fa-trash-o"></i>  delete</button> 
				     
				     </div>	
				    </div>
			 	
			 
			 
			 
			  </div>
			
			  
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button class="w3-button w3-right w3-white w3-border" 
			   onclick="document.getElementById('id_edit_modal').style.display='none'">Close</button>
			  </div>
			 </div>
			</div>
			
			<!-- EOF Modal --> 
    
    
    
			
			<div class="w3-container w3-card w3-white w3-round w3-margin"><br>
        <i class="fa fa-eye" onclick="toggleEditDiv()" style="color: gray; transition: color 0.3s ease;" 
   onmouseover="this.style.color='red'" 
   onmouseout="this.style.color='gray'"></i> Manage Connection
        <span class="w3-right w3-opacity" id="editConnectionCounter"></span>
        <br>
	        <hr class="w3-clear">
        <div class ="EditConnection" id="EditConnection" style="display: none;"> 
	        
				        
				<h2>Manage connection</h2>
				<p>View an existing connection to confirm settings. Useful if you are having problems executing SQL against that connection. Or Toggle database pool connections on or off. SLP attempts to connect to all connections that are set to active, it is wise to limit the connections to only those that are needed.</p>
				
				<div class="container">
				    <div class="row">
				       <select id="editConnections" name="db_jdbcClassName">
				       </select>
				    </div>
				    
				     <div class="col-75">
				        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="getConnectionById();"><i class="fa fa-eye"></i>  View</button>
				        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="toggleConnectionStatus();"><i class="fa fa-arrows-h"></i>  Toggle</button> 
				        
				      </div>	
				    </div>
				</div>
			
			</div>
			
			
			<!-- EOF Card -->  
      		
      		<! -- BOF CARD -->
      		
		      <div class="w3-row-padding">
		        <div class="w3-col m12">
		          <div class="w3-card w3-round w3-white">
		            <div class="w3-container w3-padding">
		              <i class="fa fa-pencil" onclick="toggleQueryTypeDiv()" style="color: gray; transition: color 0.3s ease;" onmouseover="this.style.color='red'" onmouseout="this.style.color='gray'"></i> Edit Query Types
        				<span class="w3-right w3-opacity" id="editQueryTypes"></span>
        				<br>
	        			<hr class="w3-clear">
		              <!-- -->
		              <div class ="EditQueryType" id="EditQueryType" style="display: none;"> 
		             		<div class="row">
						      <div class="col-25">
						        <label for="query_type">Add Query Type</label>
						      </div>
						      <div class="col-75">
						        <input type="text" id="query_type" name="query_type" placeholder="query type">
						      </div>
						   	</div>
						   	<div class="row">
						      <div class="col-25">
						        
						      </div>
						      <div class="col-75">
						        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="addQueryType();"><i class="fa fa-plus"></i>  Add</button>
						      </div>
						   	</div>
						   	
						   	
						   	<div class="row">
						      <div class="col-25">
						        <label for="query_type_select">Remove Query Type</label>
						      </div>
						      <div class="col-75">
						        <select id="query_type_select" name="query_type_select">
							          <option value="Select">Select</option>
							          <option value="Update">Update</option>
							          <option value="Alert">Alert</option>
						        </select>
						      </div>
						   	</div>
						   	<div class="row">
						      <div class="col-25">
						        
						      </div>
						      <div class="col-75">
						        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="deleteQueryTypesByID();"><i class="fa fa-minus"></i>  Remove</button>
						      </div>
						   	</div>
						   	
						   	
						   	
		             
		             </div>
		             <!-- -->
		            </div>
		          </div>
		        </div>
		      </div>
		      		
      		<! -- EOF CARD -->
     
      
      <! -- BOF CARD -->
      		<div class="w3-container"><br>
		        <div class="w3-col m12">
		          <div class="w3-card w3-round w3-white">
		            <div class="w3-container w3-padding">
		              <i class="fa fa-pencil" onclick="toggleSystemVariableDiv()" style="color: gray; transition: color 0.3s ease;" onmouseover="this.style.color='red'" onmouseout="this.style.color='gray'"></i> Edit System Variables
        				<span class="w3-right w3-opacity" id="editSystemVariables"></span>
        				<br>
	        			<hr class="w3-clear">
		              <!-- -->
		              <div class ="EditSystemVariables" id="EditSystemVariables" style="display: none;"> 
		             		<div class="row">
						      <div class="col-25">
						        <label for="system_variablese">System Variables</label>
						      </div>
						      <div class="col-75">
						      
						      <textarea id="system_variables" name="system_variables" rows="4" cols="50">
										{}
							  </textarea>
						        
						      </div>
						   	</div>
						   	<div class="row">
						      <div class="col-25">
						        
						      </div>
						      <div class="col-75">
						        <button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="setMySystemVariables();"><i class="fa fa-plus"></i>  Update</button>
						      </div>
						   	</div>
						  </div>
		             <!-- -->
		            </div>
		          </div>
		        </div>
		      </div>
		      		
      		<! -- EOF CARD -->
      		
      
      
      
      
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

    document.getElementById("new_db_jdbcClassName").addEventListener("change", function() 
    {
        console.log("Selected value:", this.value);
        let choice = this.value;
        
        let db_type ="";
       
        
        
        if(choice === "com.mysql.cj.jdbc.Driver")
        {
        	console.log("Loading mysql defaults");
        	db_type = "mysql"
        	
        }
        if(choice === "org.postgresql.Driver")
        {
        	console.log("Loading postgres defaults");
        	db_type ="postgresql";
        	
        }
        if(choice === "com.ibm.db2.jcc.DB2Driver")
        {
        	console.log("Loading db2 defaults");
        	db_type ="db2";
        	
        }
        if(choice === "com.microsoft.sqlserver.jdbc.SQLServerDriver")
        {
        	console.log("Loading sqlserver defaults");
        	db_type ="sqlserver";
        	
        }
        if(choice === "oracle.jdbc.driver.OracleDriver")
        {
        	console.log("Loading oracle defaults");
        	db_type ="oracle";
        	
        }
        const elemnet_db_type = document.getElementById('new_db_type');
       
        
        elemnet_db_type.value = db_type;
        
        
        
    });




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
        function toggleDiv() {
            const div = document.getElementById('AddNewConnection');
            if (div.style.display === 'none' || div.style.display === '') {
                div.style.display = 'block'; // Show the div
            } else {
                div.style.display = 'none'; // Hide the div
                $('#new_status').val('');
				$('#new_db_version').val('');
				$('#new_db_username').val('');
				$('#new_db_password').val('');
				$('#new_db_database').val('');
				$('#new_db_port').val('');
				$('#new_db_url').val('');
				$('#new_db_userIcon').val('');
				$('#new_db_databaseIcon').val('');
				$('#new_db_alias').val('');
				$('#new_db_access').val('');
            }
        }
         function toggleEditDiv() {
            const div = document.getElementById('EditConnection');
            if (div.style.display === 'none' || div.style.display === '') {
                div.style.display = 'block'; // Show the div
            } else {
                div.style.display = 'none'; // Hide the div
            }
        }
        function toggleQueryTypeDiv() {
            const div = document.getElementById('EditQueryType');
            if (div.style.display === 'none' || div.style.display === '') {
                div.style.display = 'block'; // Show the div
            } else {
                div.style.display = 'none'; // Hide the div
            }
        }
        function toggleSystemVariableDiv() {
            const div = document.getElementById('EditSystemVariables');
            if (div.style.display === 'none' || div.style.display === '') {
                div.style.display = 'block'; // Show the div
            } else {
                div.style.display = 'none'; // Hide the div
            }
        }
        
    </script>


<script>
function addNewConnection()
{
	const var_new_status = $('#new_status').val();
	const var_new_db_type = $('#new_db_type').val();
	const var_new_db_version = $('#new_db_version').val();
	const var_new_db_username = $('#new_db_username').val();
	const var_new_db_password = $('#new_db_password').val();
	const var_new_db_port = $('#new_db_port').val();
	const var_new_db_database = $('#new_db_database').val();
	const var_new_db_url = $('#new_db_url').val();
	const var_new_db_jdbcClassName = $('#new_db_jdbcClassName').val();
	const var_new_db_userIcon = $('#new_db_userIcon').val();
	const var_new_db_databaseIcon = $('#new_db_databaseIcon').val();
	const var_new_db_alias = $('#new_db_alias').val();
	const var_new_db_access = $('#new_db_access').val();
	const var_jwt = '${tokenObject.jwt}';
  
  	const jsonData = JSON.stringify({
  		  jwt:var_jwt,
  		  status:var_new_status,
  		  db_type:var_new_db_type,
          db_version: var_new_db_version,
          db_username: var_new_db_username,
          db_password: var_new_db_password,
          db_port: var_new_db_port,
          db_database: var_new_db_database,
          db_url: var_new_db_url,
          db_jdbcClassName: var_new_db_jdbcClassName,
          db_userIcon: var_new_db_userIcon,
          db_databaseIcon: var_new_db_databaseIcon,
          db_alias: var_new_db_alias,
          db_access: var_new_db_access
        });
  
  console.log(jsonData);
  
  
	$.ajax({
          url: '/api/setDatabaseConnections', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('addConnectionResponse').innerHTML = response[0].response;
             	document.getElementById('addConnectionResponseModal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}



function updateConnection()
{
	const var_new_status = $('#edit_status').val();
	const var_new_db_type = $('#edit_db_type').val();
	const var_new_db_version = $('#edit_db_version').val();
	const var_new_db_username = $('#edit_db_username').val();
	const var_new_db_password = $('#edit_db_password').val();
	const var_new_db_port = $('#edit_db_port').val();
	const var_new_db_database = $('#edit_db_database').val();
	const var_new_db_url = $('#edit_db_url').val();
	const var_new_db_jdbcClassName = $('#edit_db_jdbcClassName').val();
	const var_new_db_userIcon = $('#edit_db_userIcon').val();
	const var_new_db_databaseIcon = $('#edit_db_databaseIcon').val();
	const var_new_db_alias = $('#edit_db_alias').val();
	const var_new_db_access = $('#edit_db_access').val();
	const var_jwt = '${tokenObject.jwt}';
	const var_id = $('#editConnections').val();
  
  	const jsonData = JSON.stringify({
  		  jwt:var_jwt,
  		  status:var_new_status,
  		  db_type:var_new_db_type,
          db_version: var_new_db_version,
          db_username: var_new_db_username,
          db_password: var_new_db_password,
          db_port: var_new_db_port,
          db_database: var_new_db_database,
          db_url: var_new_db_url,
          db_jdbcClassName: var_new_db_jdbcClassName,
          db_userIcon: var_new_db_userIcon,
          db_databaseIcon: var_new_db_databaseIcon,
          db_alias: var_new_db_alias,
          db_access: var_new_db_access,
          id: var_id
        });
  
  console.log(jsonData);
  
  
	$.ajax({
          url: '/api/updateDatabaseConnectionsById', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('updateResponse').innerHTML = response[0].response;
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}

function toggleConnectionStatus()
{
	
	const var_id =  $('#editConnections').val();
	const var_jwt = '${tokenObject.jwt}';
  
  	const jsonData = JSON.stringify({
  		  jwt:var_jwt,
  		  id:var_id
  		});
  
  console.log(jsonData);
  
  
	$.ajax({
          url: '/api/toggleDatabaseConnectionStatusByID', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
function deleteConnection()
{
	
	const var_id =  $('#editConnections').val();
	const var_jwt = '${tokenObject.jwt}';
  
  	const jsonData = JSON.stringify({
  		  jwt:var_jwt,
  		  id:var_id
  		});
  
  console.log(jsonData);
  
  
	$.ajax({
          url: '/api/deleteDatabaseConnectionsById', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function addQueryType()
{
	
	const var_query_type =  $('#query_type').val();
	const var_jwt = '${tokenObject.jwt}';
  
  	const jsonData = JSON.stringify({
  		  jwt:var_jwt,
  		  query_type:var_query_type
  		});
  
  	console.log(jsonData);
  
  
	$.ajax({
          url: '/api/addQueryTypes', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getQueryTypes();
             	getQueryTypesInSettings();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function deleteQueryTypesByID()
{
	const jwtToken = '${tokenObject.jwt}';
	const QueryId = $('#query_type_select').val();
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          id: QueryId
        });
  	
  	$.ajax({
          url: '/api/deleteQueryTypesByID', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getQueryTypes();
             	getQueryTypesInSettings();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
</script>




<script>
	
 $(document).ready(function() 
  {
  	getConnections();
  });
  
  function getConnections()
  {
  	const jwtToken = '${tokenObject.jwt}';
   	
    
  	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  
  	$.ajax({
          url: '/api/getAllDatabaseConnections', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	var i = 0;
             	response.forEach((item) => 
             	{
	            	var option = document.createElement("option");
  					option.text = item.db_connection_id;
  					option.value = item.id;
  					select_editConnections.add(option);
  					i = i+1;
  					
	            });
	            var_editConnectionCounter.textContent = i + " connections";
           		
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
  
 	 const select_editConnections = document.getElementById("editConnections");
   	 const var_editConnectionCounter = document.getElementById("editConnectionCounter");
   
   
   	const connectionsTable = $('#connectionsTable').DataTable();
   	
   
    $.ajax({
          url: '/api/getValidatedDatabaseConnections', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	var i = 0;
             	connectionsTable.clear();
             	
             	response.forEach((item) => 
             	{
	            	
  					connectionsTable.row.add([item.connection, item.alias, item.access, item.status]);
  					
	            });
	            connectionsTable.draw();
           		
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
        
        
        
  }
  /*****************************************************/
  
   $(document).ready(function() 
  	{
  		getMySystemVariables();
  	});
  	function getMySystemVariables()
	{
		const var_jwt = '${tokenObject.jwt}';
		const jsonData = JSON.stringify({
		  		  jwt:var_jwt,
		  		});
		console.log(jsonData);
		$.ajax({
		          url: '/api/getMySystemVariables', 
		          type: 'POST',
		          data: jsonData,
		          contentType: 'application/json; charset=utf-8', // Set content type to JSON
		          success: function(response) 
		          {
		             	console.log(response[0].data);
		             	const jsonString = JSON.stringify(response[0].data, null, 2);
		             	const textarea = document.getElementById('system_variables');
  						textarea.value = jsonString;
		             	
		          },
		          error: function(xhr, status, error) 
		          {
		            $('#response').text('Error: ' + error);
		          }
		        });
  
  
  	}
  	function setMySystemVariables()
	{
		const var_jwt = '${tokenObject.jwt}';
		const textarea = document.getElementById('system_variables');
  		const var_mySystemVariables = JSON.parse(textarea.value);
		
		console.log("var_mySystemVariables:" +var_mySystemVariables);				
		
	  	const jsonData = JSON.stringify({
  		  jwt:var_jwt,
  	      mySystemVariables:var_mySystemVariables
        });
  
  
  		console.log(jsonData);
  
  
		$.ajax({
	          url: '/api/setMySystemVariables', 
	          type: 'POST',
	          data: jsonData,
	          contentType: 'application/json; charset=utf-8', // Set content type to JSON
	          success: function(response) 
	          {
	             	console.log(response);
	          },
	          error: function(xhr, status, error) 
	          {
	            $('#response').text('Error: ' + error);
	          }
	        });
	}
  /*****************************************************/
  
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
		const jsonData = JSON.stringify({jwt:var_jwt});
	
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
