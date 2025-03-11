<!DOCTYPE html>
<html>
<head>
<title>Guardium Data</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/datatables.min.css">
<script src="js/jquery.min.js"></script>
<link rel='stylesheet' href='css/fonts.css'>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>



<link rel="stylesheet" href="css/datatables.min.css">
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
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Guardium Data</h6>
               
              <table id="example" class="display" style="width:100%">
			  <thead>
			    <tr>
			    	<th>Runtime</th>
			      	<th>Internal Id</th>
			      	<th>DB User</th>
			      	<th>Server IP</th>
			    </tr>
			  </thead>
			  <tbody>
			    <!-- Data will be inserted here by DataTables -->
			  </tbody>
			</table>
              
              
              
            </div>
          </div>
        </div>
      </div>
      
      <!-- Modal -->
			
			<div id="id_edit_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal" style="width:75%;">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="document.getElementById('id_edit_modal').style.display='none'" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Data by internal id</h2>
			  </header>
			
			  
			
			  <div id="edit" class="w3-container city">
			 
				 
				 <table id="SOURCE_INTERNAL_ID_TBL" class="display" style="width:100%">
				  <thead>
				    <tr>
				    	<th>Runtime</th>
				      	<th>Internal Id</th>
				      	<th>Message Id hash</th>
				      	<th>DB User</th>
				      	<th>Server IP</th>
				      	<th>Verb</th>
				      	<th>Date Created</th>
				    </tr>
				  </thead>
				  <tbody>
				    <!-- Data will be inserted here by DataTables -->
				  </tbody>
			</table>
			 
			 
			 
			  </div>
			
			  
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button class="w3-button w3-right w3-white w3-border" onclick="document.getElementById('id_edit_modal').style.display='none';">Close</button>
			  </div>
			 </div>
			</div>
			
			<!-- EOF Modal --> 
			
			
			<!-- Modal -->
			
			<div id="id_messageHash_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal" style="width:75%;">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="document.getElementById('id_messageHash_modal').style.display='none'" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Data by hash id</h2>
			  </header>
			
			  
			
			  <div id="edit" class="w3-container city">
			 
				 
				 <table id="MESSAGE_ID_HASH_TBL" class="display" style="width:100%">
				  <thead>
				    <tr>
				    	<th>Runtime</th>
				      	<th>Message Id hash</th>
				      	<th>Internal Id</th>
				      	<th>Average</th>
				      	<th>Standard Deviation</th>
				      	<th>Threshold</th>
				      	<th>Verb</th>
				      	
				    </tr>
				  </thead>
				  <tbody>
				    <!-- Data will be inserted here by DataTables -->
				  </tbody>
			</table>
			 
			 <div id="chart_div" style="width: 100%; height: 500px; text-align:center;"></div>
			 
			  </div>
			
			  
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button class="w3-button w3-right w3-white w3-border" onclick="document.getElementById('id_messageHash_modal').style.display='none';">Close</button>
			  </div>
			 </div>
			</div>
			
			<!-- EOF Modal --> 
			
				<!-- Modal -->
			
			<div id="id_Area_Chart_Modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal" style="width:75%;">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="document.getElementById('id_Area_Chart_Modal').style.display='none'" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Chart data</h2>
			  </header>
			<div id="id_Area_Chart_div"></div>
			  
			
			
			  
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button class="w3-button w3-right w3-white w3-border" onclick="document.getElementById('id_Area_Chart_Modal').style.display='none';">Close</button>
			  </div>
			 </div>
			</div>
			
			<!-- EOF Modal --> 
			
			
      
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
<div id="footer"></div>
 
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



$(document).ready(function() 
  {
  	getMonitorGuardiumSources();
  	const table = $('#example').DataTable();
  	table.on('click', 'tbody tr', function() 
  	{
  		console.log('API rows values : ', table.row(this).data()[1]);
  		
  		getMonitorGuardiumSourceMessageStatById(table.row(this).data()[1]);
  		
	})
  });
  
  function getMonitorGuardiumSources()
  {
  	const table = $('#example').DataTable();
  
  	const jwtToken = '${tokenObject.jwt}';
   
  	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  
  
	$.ajax({
          url: '/api/monitor/getMonitorGuardiumSources', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	table.clear();
             	
             	response.forEach((item) => {
	                table.row.add([item.runtime, item.source_internal_id, item.sources.DB_USER, item.sources.SERVER_IP]);
	            });
            
           		table.draw();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
  }
  function getMonitorGuardiumSourceMessageStatById(source_internal_id)
  {
  		console.log('getMonitorGuardiumSourceMessageStatById : ' + source_internal_id);
  		
  		const table = $('#SOURCE_INTERNAL_ID_TBL').DataTable();
  		table.on('click', 'tbody tr', function() 
	  	{
	  		console.log('API rows values : ', table.row(this).data()[2]);
	  		
	  		getMonitorGuardiumDataByMessageIdHash(table.row(this).data()[2]);
	  		
		});
  
	  	const jwtToken = '${tokenObject.jwt}';
	    const sourceInternalId = source_internal_id;
	    
	    
	  	const jsonData = JSON.stringify({
	          jwt: jwtToken,
	          SOURCE_INTERNAL_ID: sourceInternalId
	        });
	  
	  
		$.ajax({
	          url: '/api/monitor/getMonitorGuardiumSourceMessageStatById', 
	          type: 'POST',
	          data: jsonData,
	          contentType: 'application/json; charset=utf-8', // Set content type to JSON
	          success: function(response) 
	          {
	             	table.clear();
	            
		            response.forEach((item) => {
		            console.log("item.message_id_hash: " + item.message_id_hash);
		                table.row.add([item.runtime, item.source_internal_id, item.message_id_hash, item.source_message_stats.DB_USER, item.source_message_stats.SERVER_IP,  item.source_message_stats.VERB,  item.source_message_stats.DATE_CREATED]);
		            });
	            
	           		table.draw();
	          },
	          error: function(xhr, status, error) 
	          {
	            $('#response').text('Error: ' + error);
	          }
	        });
  		document.getElementById('id_edit_modal').style.display='block'; 	
  }

	// Load Google Charts
google.charts.load('current', { packages: ['corechart'] });
google.charts.setOnLoadCallback(() => console.log('Google Charts Loaded')); // Ensure it loads first

  function getMonitorGuardiumDataByMessageIdHash(message_id_hash)
  {
  		console.log('getMonitorGuardiumDataByMessageIdHash : ' + message_id_hash);
  		
  		const table = $('#MESSAGE_ID_HASH_TBL').DataTable();
  		table.on('click', 'tbody tr', function() 
	  	{
	  		fetchDataAndDrawChart(table.row(this).data()[1],table.row(this).data()[2]);
	  		console.log('API rows values : ', table.row(this).data()[2]);
	  		let rowData = table.row(this).data();
        	let selectedMessageIdHash = rowData[1]; // Click the hash
        	console.log('Selected Message ID Hash: ', selectedMessageIdHash);

        // Fetch data and draw chart
        fetchChartData(selectedMessageIdHash);

	  	});
  
	  	const jwtToken = '${tokenObject.jwt}';
	    const messageIdHash = message_id_hash;
	    
	    
	  	const jsonData = JSON.stringify({
	          jwt: jwtToken,
	          MESSAGE_ID_HASH: messageIdHash
	        });
	  
	  
		$.ajax({
	          url: '/api/monitor/getMonitorGuardiumDataByMessageIdHash', 
	          type: 'POST',
	          data: jsonData,
	          contentType: 'application/json; charset=utf-8', // Set content type to JSON
	          success: function(response) 
	          {
	             	table.clear();
	            
		            response.forEach((item) => {
		                table.row.add([item.runtime, item.message_id_hash, item.source_internal_id, item.average, item.standard_deviation,  item.threshold,  item.verb]);
		            });
	            	
	           		table.draw();
	           		
	          },
	          error: function(xhr, status, error) 
	          {
	            $('#response').text('Error: ' + error);
	          }
	        });
  		document.getElementById('id_edit_modal').style.display='none'; 
  		document.getElementById('id_messageHash_modal').style.display='block'; 
  }
	
	google.charts.load('current', {'packages':['corechart']});
	
	function fetchDataAndDrawChart(var_message_id_hash, var_internal_id) 
	{
            console.log("message_id_hash:" + var_message_id_hash);
            console.log("internal_id:" + var_internal_id);
            const apiUrl = '/api/monitor/getMonitorGuardiumDataByMessageIdHashAndInternalId'; 
            
            const jwtToken = '${tokenObject.jwt}';
            
            const payload = JSON.stringify({
	          jwt: jwtToken,
	          MESSAGE_ID_HASH: var_message_id_hash,
              SOURCE_INTERNAL_ID: var_internal_id
	        });
            
            
            
            fetch(apiUrl, {
                method: 'POST', 
                headers: {
                    'Content-Type': 'application/json' 
                },
                body: payload
            	})
                .then(response => response.json())
                .then(data => 
                {
                    createChart(data);
                })
                .catch(error => {
                    console.error('Error fetching data:', error);
                });
        }
	
	
	function createChart(jsonData) 
    {
            console.log("Creating new chart");
            var data = new google.visualization.DataTable();
            data.addColumn('datetime', 'runtime');
            data.addColumn('number', 'average');
            data.addColumn('number', 'standard deviation');
            data.addColumn('number', 'threshold');
            
            jsonData.forEach(item => {
                data.addRow([new Date(item.runtime), item.average, item.standard_deviation, item.threshold]);
            });

            var options = {
                title: 'Statistics',
                hAxis: { title: 'runtime,' },
                vAxis: {  }
            };

            var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
            chart.draw(data, options);
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
