<!DOCTYPE html>
<html>
<head>
<title>SLP Databases</title>
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
              <h6 class="w3-opacity">Prepared database queries</h6>
              
              <table id="example" class="display" style="width:100%">
			  <thead>
			    <tr>
			    	<th>id</th>
			      	<th>query_usecase</th>
			      	<th>query_db_type</th>
			      	<th>query_type</th>
			      	<th>query_loop</th>
			    </tr>
			  </thead>
			  <tbody>
			    <!-- Data will be inserted here by DataTables -->
			  </tbody>
			</table>
              
              
              <!-- Card -->
    
    		
    
    
    
			
			<div class="w3-container w3-card w3-white w3-round w3-margin"><br>
        <i class="fa fa-plus" onclick="toggleAddSqlDiv()" style="color: gray; transition: color 0.3s ease;" 
   onmouseover="this.style.color='red'" 
   onmouseout="this.style.color='gray'"></i> Add SQL
        
        <br>
	        <hr class="w3-clear">
        <div class ="addSQL" id="addSQL" style="display: none;"> 
	        
				        
				<h2>Add SQL statement</h2>
				<p>SQL can be added ; separated for each SQL statement. You can also take advantage of <a href="help.ftl#generic">SLPs generic feature</a> to help build dynamic data</p>
				
				
				
				<!-- -->
				<div id="addSQLStatementModal" class="w3-modal">
				    <div class="w3-modal-content">
				      <div class="w3-container">
				        <span onclick="document.getElementById('addSQLStatementModal').style.display='none';getSqlStatements();" class="w3-button w3-display-topright">&times;</span>
				        <p id="addSQLStatementResponse"></p>
				        
				      </div>
				    </div>
				  </div>
			<!-- -->	
				
				<div class="container">
				    
				    
				    
				    <div class="row">
				        <p><textarea id="sqlStatementToAdd" name="sqlStatementToAdd" rows="10" cols="50"></textarea></p>
				   	</div>
				   	
				   	<div class="row">
				   	   	<div class="w3-half">
					        <p>
					        <select id="addSqlStatementDB" name="addSqlStatementDB">
					          <option value="db2">db2</option>
					          <option value="mysql">mysql</option>
					          <option value="postgres">postgres</option>
					        </select>
					        </p>
					    </div>
					    <div class="w3-half">
					   		<p>
					        <select id="addSqlStatementType" name="addSqlStatementType">
					          <option value="Select">Select</option>
					          <option value="Update">Update</option>
					          <option value="Alert">Alert</option>
					        </select>
					        </p>
					   	</div>
				    </div>    
				    
				    <div class="row">
				    	<div class="w3-half">
				    	    <p><input type="text" id="sqlStatementQueryLoop" placeholder="Add number of times to loop (1-99)" value="1" class="w3-right w3-white w3-border"></p>
				  		</div>
				  		<div class="w3-half">
				  			<p><input type="text" id="sqlStatementQueryUsecase" placeholder="Add Use Case name. Example : insert_Update_delete" value="" class="w3-right w3-white w3-border"></p>
				  		</div>
				  	</div>			 
				  			    
				    <div class="row">
				        <p><textarea id="sqlStatementQueryDescription" name="sqlStatementQueryDescription" placeholder="Description" rows="4" cols="50"></textarea></p>
				   	</div>
				   	
				   	<div class="row">
				        <p><input type="text" id="sqlStatementVideoLink" placeholder="Video URL" value="" class="w3-right w3-white w3-border"></p>
				   	</div>
				  
				    <div class="row">
				     	<div class="col-75">
				        	<button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="addDatabaseQuery();"><i class="fa fa-save"></i>  Save</button> 
				      	</div>	
				    </div>
				    </div>
				</div>
			
			</div>
			
			
			<!-- EOF Card -->  
              
              
              
              <!-- Card -->
    
    		
    
    
    
			
		<div class="w3-container w3-card w3-white w3-round w3-margin"><br>
        <i class="fa fa-plus" onclick="toggleFreeStyle()" style="color: gray; transition: color 0.3s ease;" onmouseover="this.style.color='red'" onmouseout="this.style.color='gray'"></i> Freestyle SQL
        
        <br>
	        <hr class="w3-clear">
        <div class ="freestyleSQL" id="freestyleSQL" style="display: none;"> 
	        
				        
				<h2>Create freestyle SQL statements</h2>
				<p>SQL can be added ; separated for each SQL statement</p>
				
				
				
				<!-- -->
				<div id="freestyleStatementModal" class="w3-modal">
				    <div class="w3-modal-content">
				      <div class="w3-container">
				        <span onclick="document.getElementById('freestyleStatementModal').style.display='none';" class="w3-button w3-display-topright">&times;</span>
				        <p id="addFreestyleSQLStatementResponse"></p>
				        
				      </div>
				    </div>
				  </div>
			<!-- -->	
				
				<div class="container">
				    
				    
				    <div class="row">
				        <p><textarea id="freestyleSQLToRun" name="freestyleSQLToRun" rows="10" cols="50"></textarea></p>
				   	</div>
				   	
				   	<div class="row">
				        <p>
				        <select id="validatedConnectionsForFreestyle" name="dropdown">
	            			<#if ValidatedConnectionData?has_content>
					            <#list ValidatedConnectionData?keys as key>
					                <option value="${key}">${key}</option>
					            </#list>
				            <#else>
			                	<option value="">No options available</option>
			            	</#if>
	        			</select>
				        </p>
				    </div>    
				    		  
				    <div class="row">
				     	<div class="col-75">
				        	<button type="button" class="w3-button w3-theme-d1 w3-margin-bottom w3-right-align" onclick="runFreestyleQuery(0);"><i class="fa fa-rocket"></i>  Run</button> 
				      	</div>	
				    </div>
				    </div>
				</div>
			
			</div>
			
			
			<!-- EOF Card -->  
              
              
              
              
              
              
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

<!-- Modal for freestyle -->
				<div id="freestyleModal" class="w3-modal">
				  <div class="w3-modal-content w3-animate-zoom">
				    <header class="w3-container w3-blue-grey">
				      <span onclick="document.getElementById('freestyleModal').style.display='none';" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
				      <h2>Freestyle Results</h2>
				    </header>
				    <div class="w3-container">
				      <table id="freestyleTable" class="w3-table w3-bordered"></table>
				    </div>
				  </div>
				</div>
 		<!-- EOF Modal -->
 



<!-- Footer -->
<div id="footer"></div>
 
 
 
   <!-- Modal -->
			
			<div id="id_edit_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="closeDatabaseQuery();getSqlStatements()" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>SQL Data</h2>
			  </header>
			
			  <div class="w3-bar w3-border-bottom">
			   <button id="sqlData" class="tablink w3-bar-item w3-button" onclick="toggleEditResultsShowSQL()">SQL Data</button>
			   <button id="sqlResults" class="tablink w3-bar-item w3-button" >Results[0]</button>
			   <button id="sqlReport" class="tablink w3-bar-item w3-button" >Report</button>
			   <button id="RunSQLButton"class="w3-button w3-right w3-white w3-border" onclick="runDatabaseQueryByDatasourceMap(0)">Run</button>

			  </div>
			  
			  <div id="edit" class="w3-container city">
			  
			   <div class="row">
	        		  <div class="col-25">
				         Datasource  <input type="text" id="dropdownInput" placeholder="Filter..." style="width: 120px;" maxlength="10" size="15" onchange="filterDropdown()"> 
				      </div>
				      <div class="col-75">
				        <select id="validatedConnections" name="dropdown">
	            			<#if ValidatedConnectionData?has_content>
					            <#list ValidatedConnectionData?keys as key>
					                <option value="${key}">${key}</option>
					            </#list>
				            <#else>
			                	<option value="">No options available</option>
			            	</#if>
	        			</select>
				      </div>
	        	</div>
	        
	        	<div class="row">
			   		  <div class="col-25">
				         Query Id: 
				      </div>
				      <div class="col-75">
				        <input type="text" id="sqlStatementToEditId" value="" class="w3-right w3-white w3-border" readonly>
				      </div>
			  	</div>
			  
			
			  
			 
				 <div class="row" id="editRow">
					    <p><textarea id="sqlStatementToEdit" name="sqlStatementToEdit" rows="16" cols="50"></textarea></p>
				 </div>		        
					        
					
				<div class="row">
			   		  <div class="col-25">
				         Suggested DB: 
				      </div>
				      <div class="col-75">		        
					        <select id="sqlStatementToEditDB" name="sqlStatementToEditDB">
					          <option value="db2">db2</option>
					          <option value="mysql">mysql</option>
					          <option value="postgres">postgres</option>
					        </select>
					  </div>
				</div>
				
				<div class="row">
			   		  <div class="col-25">
				         Query Type: 
				      </div>
				      <div class="col-75">			        
					          <select id="sqlStatementToEditType" name="sqlStatementToEditType">
					          <option value="Select">Select</option>
					          <option value="Update">Update</option>
					          <option value="Alert">Alert</option>
					        </select>
					   </div>
				</div>        
				<div class="row">
			   		  <div class="col-25">
				         Loop (default 1): 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="sqlStatementToEditQueryLoop" value="" class="w3-right w3-white w3-border">
					  </div>
				</div> 
			
				<div class="row">
			   		  <div class="col-25">
				         Query name 
				      </div>
				      <div class="col-75">	
						 <input type="text" id="sqlStatementToEditQueryUsecase" value="" class="w3-right w3-white w3-border">
					</div>
				</div> 
			
				<div class="row">
				        <p><textarea id="sqlStatementToEditDescription" name="sqlStatementToEditDescription" placeholder="Description" rows="4" cols="50"></textarea></p>
				</div>
					
				<div class="row">
			   		 	<div class="col-25" style="text-align:right; padding-right:20px">
				          <i class="fa fa-video-camera" aria-hidden="true" style="font-size: 50px; color: black; transition: color 0.3s ease-in-out;" onmouseover="this.style.color='teal'" onmouseout="this.style.color='black'" onclick="watchVideo()"></i>
					    </div>
					    <div class="col-75">	
							 <input type="text" id="sqlStatementToEditVideoLink" value="" class="w3-l w3-white w3-border">
						</div>
						 
				</div> 
					
					
					
					
					
					<div class="row" id="resultsRow" style="display:none;overflow-y: scroll;">
						
					
						<table id="resultsTable" class="display" style="width:100%">
						  
						</table>
					
					
					</div>
					
					
			 </div>
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button id="DeleteSQLButton" class="w3-button w3-right w3-white w3-border" onclick="deleteDatabaseQueryByQueryId()">Delete</button>
			   <button id="UpdateSQLButton" class="w3-button w3-right w3-white w3-border" onclick="updateDatabaseQueryByQueryId()">Update</button>
			   <button id="RunSQLButton"class="w3-button w3-right w3-white w3-border" onclick="runDatabaseQueryByDatasourceMap(0)">Run</button>
			   <button id="CloseSQLButton" class="w3-button w3-right w3-white w3-border" onclick="closeDatabaseQuery()">Close</button>
			  </div>
			</div>
			
			<!-- EOF Modal --> 
 
 			<!-- Modal for displaying reports -->
				<div id="reportsModal" class="w3-modal">
				  <div class="w3-modal-content w3-animate-zoom">
				    <header class="w3-container w3-blue-grey">
				      <span onclick="closeModal()" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
				      <h2>Reports</h2>
				    </header>
				    <div class="w3-container">
				      <table id="reportsTable" class="w3-table w3-bordered"></table>
				    </div>
				  </div>
				</div>
 		<!-- EOF Modal -->
 		
 		
 		
 
<script>


window.onload = function() {
    quickSearch();
};


function watchVideo()
{ 
	
	const videoLink = document.getElementById('sqlStatementToEditVideoLink'); 
	console.log("videoLink: " + videoLink.value);
	if (videoLink.value === null || videoLink.value === "" || videoLink.value === undefined) 
	{
    	console.log("video value is null, empty, or undefined - not opening video link");
	}
	else
	{
		window.open(videoLink.value, "_blank");
	}
}


function quickSearch()
{
	const urlParams = new URLSearchParams(window.location.search);

	if (urlParams.has('lookup')) 
	{
	    console.log("Parameter 'lookup' exists in the URL");
	    const querytype = urlParams.get('lookup');
		if (querytype) 
		{
		    console.log("query type:", querytype);
		    var table = $('#example').DataTable();
		  	table.search(querytype).draw();
		}
	    
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
</script>

<script>
	function closeDatabaseQuery()
	{
		document.getElementById('id_edit_modal').style.display='none'
		$("#sqlResults").html('Results[0]');
		$('#resultsTable').DataTable().destroy();
		$('#resultsTable').empty();
		toggleEditResultsShowSQL();
		//setQueryResultSearch(0);
		
		const $button = $('#sqlResults');
		$button.off('click');
	}
	function toggleFreeStyle()
	{
		const div = document.getElementById('freestyleSQL');
        if (div.style.display === 'none' || div.style.display === '') 
        {
        	div.style.display = 'block'; // Show the div
        } 
        else 
        {
        	div.style.display = 'none'; // Hide the div
        }
	}
	function toggleEditResultsShowResults()
	{
		const editRow = document.getElementById('editRow');
		const resultRow = document.getElementById('resultRow');
		
		const deleteSQLButton = document.getElementById('DeleteSQLButton');
		const updateSQLButton = document.getElementById('UpdateSQLButton');
		const runSQLButton = document.getElementById('RunSQLButton');
		
		editRow.style.display = 'none';
		deleteSQLButton.style.display = 'none';
		updateSQLButton.style.display = 'none';
		runSQLButton.style.display = 'none';
		
        resultsRow.style.display = 'block';
    }
	function toggleEditResultsShowSQL()
	{
		const editRow = document.getElementById('editRow');
		const resultRow = document.getElementById('resultRow');
		
		const deleteSQLButton = document.getElementById('DeleteSQLButton');
		const updateSQLButton = document.getElementById('UpdateSQLButton');
		const runSQLButton = document.getElementById('RunSQLButton');
		
		editRow.style.display = 'block'; 
		
		deleteSQLButton.style.display = 'block';
		updateSQLButton.style.display = 'block';
		runSQLButton.style.display = 'block';
		
		resultsRow.style.display = 'none'; 
        
	}
	function toggleAddSqlDiv() 
   	{
    	const div = document.getElementById('addSQL');
        if (div.style.display === 'none' || div.style.display === '') 
        {
        	div.style.display = 'block'; // Show the div
        } 
        else 
        {
        	div.style.display = 'none'; // Hide the div
        }
   	}
</script>


<script>
function runFreestyleQuery(result)
{
	const jwtToken = '${tokenObject.jwt}';
	const queryString = $('#freestyleSQLToRun').val();
	const dbConnection = $('#validatedConnectionsForFreestyle').val();
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          sql: queryString,
          datasource: dbConnection,
         });
         
   	$.ajax({
          url: '/api/runDatabaseQueryByDatasourceMap', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	console.log("response size: " + response.length);
             	const resultSize = response.length;
             	console.log("resultSize: " + resultSize);
             	
             	if (!Array.isArray(response) || response.length === 0) 
             	{
                	console.error("Error: Response is empty or not an array");
                	$('#response').text('Error: No results found');
                	return;
                }
                
                if (!response[result] || !Array.isArray(response[result]) || response[result].length === 0) 
                {
                	console.error("Error: response[result] is not valid");
                	$('#response').text('Error: No data found for the result');
                	return;
                }
                
                console.log("Response size: " + response.length);
            	console.log("Result index: " + result);
            	
            	// Lets get the first entry of the resposne[result] and do some checking
            	const firstEntry = response[result][0];
            	
            	if (!firstEntry || !firstEntry.Result || !firstEntry.SQL) {
                console.error("Error: Expected Result and SQL fields are missing");
                $('#response').text('Error: Invalid response format');
                return;
            }
                
             	let jsonData = firstEntry.Result;
            	let jsonDataSQL = firstEntry.SQL;
             	
             	$("#freestyleResults").html('Results ['+ jsonDataSQL + ']');
             	
             	
             	console.log("response[result][0].Result " + jsonData);
             	console.log("response[result][0].SQL: " + jsonDataSQL);
             	
             	createTableForFreestyle(jsonData);
             	
             	
             	openFreestyleModal();
             	
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });      
}

var hold = 1; //remember the initial 0 element is shown

function runDatabaseQueryByDatasourceMap(result)
{
	const jwtToken = '${tokenObject.jwt}';
	const queryString = $('#sqlStatementToEdit').val();
	const dbConnection = $('#validatedConnections').val();
	const queryLoop = $('#sqlStatementToEditQueryLoop').val();
	
	console.log("Result interested in finding: " + result);
	
	
	
	console.log("Destroying datatable");
	
	toggleEditResultsShowResults();
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          sql: queryString,
          datasource: dbConnection,
          query_loop:queryLoop
         });
     
  	$.ajax({
          url: '/api/runDatabaseQueryByDatasourceMap', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	console.log("response size: " + response.length);
             	console.log("result: " + result);
             	const resultSize = response.length;
             	console.log("resultSize: " + resultSize);
             	if (!Array.isArray(response) || response.length === 0) 
             	{
                console.error("Error: Response is empty or not an array");
                $('#response').text('Error: No results found');
                return;
                }
                
                if (!response[result] || !Array.isArray(response[result]) || response[result].length === 0) 
                {
                console.error("Error: response[result] is not valid");
                $('#response').text('Error: No data found for the result');
                return;
                }
                
                console.log("Response size: " + response.length);
            	console.log("Result index: " + result);
            	
            	// Lets get the first entry of the resposne[result] and do some checking
            	const firstEntry = response[result][0];
            	
            	if (!firstEntry || !firstEntry.Result || !firstEntry.SQL) {
                console.error("Error: Expected Result and SQL fields are missing");
                $('#response').text('Error: Invalid response format');
                return;
            }
                
             	let jsonData = firstEntry.Result;
            	let jsonDataSQL = firstEntry.SQL;
             	
             	$("#sqlResults").html('Results ['+ jsonDataSQL + ']');
             	
             	
             	console.log("response[result][0].Result " + jsonData);
             	console.log("response[result][0].SQL: " + jsonDataSQL);
             	
             	createTableFromJSON(jsonData);
             	
             	
             	const $button = $('#sqlResults');
				$button.off('click');
				
				$button.on('click', function () 
				{
				    
				    console.log("CLICKED ONCE - hold: " + hold);
				    
				    if(hold < response[result].length)
	             	{
	             		console.log("Hold index is currently: " + hold);
	             		
	             		//Now lets get the nextEntry and check if there is any data
	             		const nextEntry = response[result][hold];
	             		
                    if (nextEntry && nextEntry.Result && nextEntry.SQL) {
                        jsonData = nextEntry.Result;
                        jsonDataSQL = nextEntry.SQL;

                        console.log("response[result][" + hold + "].Result: ", jsonData);
                        console.log("response[result][" + hold + "].SQL: " + jsonDataSQL);

                        $("#sqlResults").html('Results [' + jsonDataSQL + ']');
                        createTableFromJSON(jsonData);
                    } else {
                        console.warn("Warning: Entry at index " + hold + " is missing required fields");
                    }
	             		console.log(">>>>>>>>>>>>>>>>>>result incremented :" + response[result][0]);
	             		hold ++;
	             	}
	             	else
	             	{
	             		
	             		console.log("Limit reached reset hold: " + hold);
	             		hold = 0;
	             		console.log(">>>>>>>>>>>>>>>>>>result reset");
	             	}
				});
			// Open the modal when the report button is clicked
			$('#sqlReport').off('click');
			$('#sqlReport').on('click', function () {
			    createReportsTableFromJSON(response); // Open the modal with the DataTable
			});
					           
          },
          error: function(xhr, status, error) 
          {
            console.error("AJAX Error: ", error);
            $('#response').text('Error: ' + error);
          }
        });
 }

    function createTableFromJSON(jsonArray) 
    {
       $('#resultsTable').DataTable().destroy();
	   $('#resultsTable').empty();
      
      console.log("Removed Tables");
      // Dynamically generate columns from JSON keys
      const columns = Object.keys(jsonArray[0]).map(key => ({
        title: key.charAt(0).toUpperCase() + key.slice(1), // Capitalize the header
        data: key // Map data from JSON key
      }));
	 console.log("Generated Headers");
      // Initialize DataTable
      $('#resultsTable').DataTable({
        data: jsonArray, // Pass JSON data
        columns: columns // Use dynamically generated columns
      });
     console.log("Generated Data");
    }
    
    
    
    function createTableForFreestyle(jsonArray) 
    {
       $('#freestyleTable').DataTable().destroy();
	   $('#freestyleTable').empty();
      
      console.log("Removed Tables");
      // Dynamically generate columns from JSON keys
      const columns = Object.keys(jsonArray[0]).map(key => ({
        title: key.charAt(0).toUpperCase() + key.slice(1), // Capitalize the header
        data: key // Map data from JSON key
      }));
	 console.log("Generated Headers");
      // Initialize DataTable
      $('#freestyleTable').DataTable({
        data: jsonArray, // Pass JSON data
        columns: columns // Use dynamically generated columns
      });
     console.log("Generated Data");
    }
    
    function createReportsTableFromJSON(jsonArray) {
    console.log("Creating the reports function!!");
    console.log("This is the data to work with");
    console.log(jsonArray);

    // Flatten data and extract all keys for dynamic columns
    const rows = [];
    const columnsSet = new Set();
    let rowNumber = 1; // Initialize the row number
    
    jsonArray.forEach((iteration, iterationIndex) => {
        iteration.forEach((entry, entryIndex) => {
            const { Result, SQL, loopIndex } = entry;

            if (Array.isArray(Result)) {
             let errorValue = null;
                const containsError = Result.some((item) => {
                    return Object.values(item).some((value) => {
                    	     if ((typeof value === "string" && value.toLowerCase().includes("error")) || (typeof value === "string" && value.toLowerCase().includes("fatal")) || (typeof value === "string" && value.toLowerCase().includes("denied")) || (typeof value === "string" && value.toLowerCase().includes("exception"))) {
                            errorValue = value;  // Capture the error value
                            return true;  // Stop once error is found
                        }
                        return false;
                    });
                });
				
				// Calculate the record count for the current SQL entry
                const recordCount = Result.length;
                
                // Dynamically gather columns based on the structure
                const row = {
                	RowNumber: rowNumber++, // Increment the row number
                    SQL: SQL || "SQL not provided", // Default if SQL is missing
                    Iteration: iterationIndex,
                    //LoopIndex: loopIndex,
                   // EntryIndex: entryIndex,
                    RecordCount: recordCount, // Include the count of returned records
                    Status: containsError ? "Error found" : "Success",
                    Error: errorValue || "No error",  // Add the error value or a default message
                };

                Object.keys(row).forEach((key) => columnsSet.add(key)); // Collect column names dynamically
                rows.push(row);
            }
        });
    });

    // Convert the column set to an array
    const columnsArray = Array.from(columnsSet).map((col) => {
        if (col === "Status") {
            return {
                title: col,
                data: col,
                render: (data) => {
                    if (data === "Error found") {
                        return '<img id="sqlError" src="/w3images/warning.png" alt="Error" style="width:20px;height:20px;">';
                    } else if (data === "Success") {
                        return '<img id="sqlSuccess" src="/w3images/success.png" alt="Success" style="width:20px;height:20px;">';
                    }
                    return data; // Fallback in case of unexpected values
                },
            };
        }

        return {
            title: col,
            data: col,
        };
    });
	
	 // Destroy the previous DataTable instance if it exists
    if ($.fn.dataTable.isDataTable('#reportsTable')) {
        $('#reportsTable').DataTable().destroy();
    }
    
    // Initialize DataTable with dynamic columns and rows
    $('#reportsTable').DataTable({
        data: rows,
        columns: columnsArray,
    });

    // Open the modal after the table is created
    openModal();
}

// Function to open the modal
function openModal() {
    document.getElementById('reportsModal').style.display = 'block';
}

// Function to close the modal
function closeModal() {
    document.getElementById('reportsModal').style.display = 'none';
}


function openFreestyleModal() {
	console.log("Opening freestyle modal");
    document.getElementById('freestyleModal').style.display = 'block';
}

function closeFreestyleModal() {
    document.getElementById('freestyleModal').style.display = 'none';
}
</script>



<script>
document.getElementsByClassName("tablink")[0].click();

function openCity(evt, cityName) {
  var i, x, tablinks;
  x = document.getElementsByClassName("city");
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablink");
  for (i = 0; i < x.length; i++) {
    tablinks[i].classList.remove("w3-light-grey");
  }
  document.getElementById(cityName).style.display = "block";
  evt.currentTarget.classList.add("w3-light-grey");
}
</script>

<script>



	
  $(document).ready(function() 
  {
  	getSqlStatements();
  	const table = $('#example').DataTable();
  	table.on('click', 'tbody tr', function() 
  	{
  		console.log('API rows values : ', table.row(this).data()[0]);
  		
  		getDatabaseQueryByQueryId(table.row(this).data()[0]);
  		
	})
  });
  
  function getSqlStatements()
  {
  	const table = $('#example').DataTable();
  
  	const jwtToken = '${tokenObject.jwt}';
   
  	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  
  
	$.ajax({
          url: '/api/getDatabaseQuery', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	table.clear();
            
	            response.forEach((item) => 
	            {
	                
	                
	                table.row.add([item.id, item.query_usecase, item.query_type, item.query_db_type, item.query_loop]);
	            });
            
           		table.draw();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
  }
</script>


<script>
function addDatabaseQuery()
{
	const jwtToken = '${tokenObject.jwt}';
	const queryDb = $('#addSqlStatementDB').val();
	const queryDbType = $('#addSqlStatementType').val();
	const queryString = $('#sqlStatementToAdd').val();
	const queryUsecase = $('#sqlStatementQueryUsecase').val();
	const queryLoop = $('#sqlStatementQueryLoop').val();
	const queryDescription = $('#sqlStatementQueryDescription').val();
	const queryVideoLink = $('#sqlStatementVideoLink').val();
	
    console.log("query_loop value : " + queryLoop);
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          query_type: queryDb,
          query_db_type: queryDbType,
          query_string: queryString,
          db_connection_id: "35",
          query_usecase:queryUsecase,
          query_loop: queryLoop,
          query_description: queryDescription,
          video_link: queryVideoLink
        });
  	
  	$.ajax({
          url: '/api/addDatabaseQuery', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('addSQLStatementResponse').innerHTML = response[0].response;
             	document.getElementById('addSQLStatementModal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function deleteDatabaseQueryByQueryId()
{
	const jwtToken = '${tokenObject.jwt}';
	const QueryId = $('#sqlStatementToEditId').val();
	const queryDbType = $('#addSqlStatementType').val();
	const queryString = $('#sqlStatementToAdd').val();

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          query_id: QueryId
        });
  	
  	$.ajax({
          url: '/api/deleteDatabaseQueryByQueryId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getSqlStatements();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function updateDatabaseQueryByQueryId()
{
	const jwtToken = '${tokenObject.jwt}';
	const QueryId = $('#sqlStatementToEditId').val();
	const dbConnectionId = "35";
	const queryDbType = $('#sqlStatementToEditDB').val();
	const queryString = $('#sqlStatementToEdit').val();
	const queryType = $('#sqlStatementToEditType').val();
	const queryUsecase = $('#sqlStatementToEditQueryUsecase').val();
	const queryLoop = $('#sqlStatementToEditQueryLoop').val();
	const queryDescription = $('#sqlStatementToEditDescription').val();
	const queryVideoLink = $('#sqlStatementToEditVideoLink').val();
	
	
	console.log("query_usecase: " + queryUsecase);
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          query_id: QueryId,
          query_db_type: queryDbType,
          db_connection_id: dbConnectionId,
          query_string: queryString,
          query_type: queryType,
          query_usecase: queryUsecase,
          query_loop:queryLoop,
          query_description: queryDescription,
          video_link: queryVideoLink
        });
  	
  	$.ajax({
          url: '/api/updateDatabaseQueryByQueryId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getSqlStatements();
             	//document.getElementById('addSQLStatementResponse').innerHTML = response[0].response;
             	//document.getElementById('addSQLStatementModal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}


/************************************************/
function getDatabaseQueryByQueryId(varId)
{
	const jwtToken = '${tokenObject.jwt}';
	const QueryId = varId;
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          query_id: QueryId,
         });
  	
  	$.ajax({
          url: '/api/getDatabaseQueryByQueryId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('sqlStatementToEdit').value = response[0].query_string;
             	document.getElementById('sqlStatementToEditDB').value = response[0].query_type;
             	document.getElementById('sqlStatementToEditDB').option = response[0].query_type;
             	
             	
             	document.getElementById('sqlStatementToEditId').value = response[0].id;
             	
             	document.getElementById('sqlStatementToEditType').value = response[0].query_db_type;
             	
             	document.getElementById('sqlStatementToEditQueryUsecase').value = response[0].query_usecase;
             	document.getElementById('sqlStatementToEditQueryLoop').value = response[0].query_loop;
             	document.getElementById('sqlStatementToEditDescription').value = response[0].query_description;
             	document.getElementById('sqlStatementToEditVideoLink').value = response[0].video_link;
             	
  				document.getElementById('id_edit_modal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
}
</script>
<script>
    $(document).ready(function() 
  	{
  		getQueryTypesInDatabase();
  	});
    function getQueryTypesInDatabase()
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
		             	console.log(response);
		             	
		             	if (Array.isArray(response)) 
		             	{
			             	 var sqlStatementToEdit = $('#sqlStatementToEditType')
			             	 var sqlStatementType = $('#addSqlStatementType')
			             	 
			             	 $('#sqlStatementToEditType').empty();
			             	 $('#addSqlStatementType').empty();
			             	 
	      				      $.each(response, function(index, item) 
						      {
						        sqlStatementToEdit.append(new Option(item.query_type, item.query_type));
						        sqlStatementType.append(new Option(item.query_type, item.query_type));
						        
						        console.log("Added new element to SQL to Edit");
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
		const jsonData = JSON.stringify({jwt:var_jwt });
	
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
	let originalOptions = [];
	$(document).ready(function() 
  	{
  		const dropdown = document.getElementById('validatedConnections');
  		originalOptions = Array.from(dropdown.options).map(option => option.text);
  	});
 

function filterDropdown() 
{
    const filterText  = document.getElementById('dropdownInput').value.toLowerCase();
    const dropdown = document.getElementById('validatedConnections');
	
 	console.log("Ready to filter: " + originalOptions);
   // Clear existing options
    dropdown.innerHTML = '';

    // Filter and re-add
    const matches = originalOptions.filter(item =>
      item.toLowerCase().includes(filterText)
    );

    if (matches.length > 0) 
    {
      matches.forEach(text => 
      {
        const option = document.createElement('option');
        option.text = text;
        dropdown.appendChild(option);
        console.log("found match:" + text);
      });
    } else 
    {
      const noMatch = document.createElement('option');
      noMatch.text = 'No matches';
      noMatch.disabled = true;
      dropdown.appendChild(noMatch);
      console.log("No match");
    }
  }
  
</script>
</body>
</html> 
