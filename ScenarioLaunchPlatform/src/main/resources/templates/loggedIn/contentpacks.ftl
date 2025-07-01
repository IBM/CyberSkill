<!DOCTYPE html>
<html>
<head>
<title>SLP Content Packs</title>
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
<style>
  /* Add custom tooltip styles */
  .pack-tooltip {
    position: relative;
    display: inline-block;
    cursor: pointer;
  }
  
  .pack-tooltip .tooltip-content {
    visibility: hidden;
    background-color: white;
    color: #333;
    text-align: left;
    border-radius: 4px;
    padding: 10px;
    position: absolute;
    z-index: 1000;
    bottom: 125%;
    left: 50%;
    transform: translateX(-50%);
    min-width: 300px;
    border: 1px solid #ccc;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    opacity: 0;
    transition: opacity 0.3s;
    pointer-events: none;
  }
  
  .pack-tooltip:hover .tooltip-content {
    visibility: visible;
    opacity: 1;
    pointer-events: auto;
  }
  
  .tooltip-header {
    font-weight: bold;
    border-bottom: 1px solid #eee;
    padding-bottom: 5px;
    margin-bottom: 8px;
  }
  
  .tooltip-row {
    display: flex;
    margin-bottom: 5px;
  }
  
  .tooltip-label {
    font-weight: bold;
    width: 120px;
  }
  
  .tooltip-value {
    flex: 1;
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
              <h6 class="w3-opacity">Content Packs Form</h6>
              <!-- -->
  				<form id="packForm" enctype="multipart/form-data">
     <div id="edit" class="w3-container city">
	<div class="row">
					<div class="col-25">
				         Pack File 
				      </div>
					<div class="col-75">
						<input type="file" id="pack_file_content" class="w3-left w3-white w3-border" name="pack_file_content" accept=".zip" required>
						</div>
					</div>
	</div>
	    <div class="row">
		<div class="col-25">
	 
				      </div>
					<div class="col-75">
					<button class="w3-button w3-right w3-blue w3-border" type="submit">Submit</button>

					</div>
		</div>
		</div>
   
    
</form>


         
              <!-- -->
            </div>
          </div>
        </div>
      </div>
     <div class="w3-col m9 w3-margin-top">
     <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Packs</h6>
              
              <table id="example" class="display" style="width:100%">
			  <thead>
			    <tr>
			    	<th>id</th> 
			      	<th>pack_name</th>      	
			      	<th>version</th>
			      	<th>db_type</th>
			      	<th>build_date</th>
			      	<th>build_version</th>
			      	<th>uploaded_date</th>
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
 <div id="id_edit_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="closePack();getPacks()" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>Content Packs</h2>
			  </header>
			
			  <div class="w3-bar w3-border-bottom">
			   <button id="packs" class="tablink w3-bar-item w3-button" onclick="toggleEditResultsShowPacks()">Content Pack</button>
			   

			  </div>
			  
			  <div id="edit" class="w3-container city">
			  <div class="row">
			   		  <div class="col-25">
				         Pack Id: 
				      </div>
				      <div class="col-75">
				        <input type="text" id="packIdToEditId" value="" class="w3-right w3-white w3-border" readonly>
				      </div>
			  	</div>
			  	
			  	<div class="row">
			   		  <div class="col-25">
				         Pack Name: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="packNameToEditId" value="" class="w3-right w3-white w3-border" readonly>
					  </div>
				</div> 
	
				<div class="row">
			   		  <div class="col-25">
				         Pack File Path: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="packFilePathToEditId" value="" class="w3-right w3-white w3-border" >
					  </div>
				</div> 
				<div class="row">
			   		  <div class="col-25">
				         Pack File Path: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="packOutputPathToEditId" value="" class="w3-right w3-white w3-border" >
					  </div>
				</div> 
		
				<div class="row">
			   		  <div class="col-25">
				         Pack Loaded 
				      </div>
				      <div class="col-75">	
						 <input type="text" id="packDeployedToEditId" value="" class="w3-right w3-white w3-border" >
					</div>
				</div> 
			 </div>
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button id="UpdatePackButton" class="w3-button w3-right w3-white w3-border" onclick="updatePackByPackId()">Deploy</button>
			   <button id="ClosePackButton" class="w3-button w3-right w3-white w3-border" onclick="closePack()">Close</button>
			  </div>
			</div>
			
			<!-- EOF Modal --> 
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

<script>
	function closePack()
	{
		document.getElementById('id_edit_modal').style.display='none'
		
		toggleEditShowPack();
		
	}
	
	function toggleEditShowPack()
	{
		
		const deletePackButton = document.getElementById('DeletePackButton');
		const updatePackButton = document.getElementById('UpdatePackButton');
		
		
		deletePackButton.style.display = 'block';
		updatePackButton.style.display = 'block';
		
        
	}
	</script>

<script>
function addPack(event) {
    event.preventDefault(); // Prevent default form submission

    // Create FormData object
    let formData = new FormData();
    
    // Append individual form fields with correct names
  //  formData.append('pack_name', document.querySelector('[name="pack_name"]').value);
  //  formData.append('pack_file_path', document.querySelector('[name="pack_file_path"]').value);
  //  formData.append('pack_output_path', document.querySelector('[name="pack_output_path"]').value);
  
    
    // Append file input
    let fileInput = document.querySelector('[name="pack_file_content"]');
    if (fileInput.files.length > 0) {
    console.log("Got a file and appending" + fileInput.files.length);
        formData.append('pack_file_content', fileInput.files[0]);
    }
    console.log("File selected:", fileInput.files[0]);

    // Append JWT token
    const jwtToken = '${tokenObject.jwt}'; // Ensure tokenObject is defined
    formData.append('jwt', jwtToken);;
    // Send AJAX request
    $.ajax({
        url: '/api/addContentPack',
        type: 'POST',
        data: formData,
        processData: false, // Ensure jQuery does not process FormData
        contentType: false, // Ensure correct content type for FormData
        success: function(response) {
            console.log('Success:', response);
            alert('Form submitted successfully!');
        },
        error: function(xhr, status, error) {
            console.error('Error:', xhr.responseText);
            alert('Failed to submit the form.');
        }
    });
}

// Attach event listener when the page loads
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById('packForm');
    if (form) {
        form.reset(); // This clears all form fields including text
        const fileInput = document.querySelector('[name="pack_file_content"]');
        if (fileInput) {
            fileInput.value = ''; // Some browsers don’t clear file inputs with .reset()
        }

        form.addEventListener('submit', addPack);
    }
});


let table; //
$(document).ready(function () {
 table = $('#example').DataTable({
  columns: [
    null,                      // id
   null,         // pack_name with tooltip - removed for issues need to figure out
    null,                      // version
    null,                      // db_type
    null,                      // build_date
    null,                      // build_version
    null                       // uploaded_date
  ]
});


  getPacks(); // call function without redeclaring table

  table.on('click', 'tbody tr', function () {
    const packId = table.row(this).data()[0];
    getPackByPackID(packId);
  });
});

function getPacks() {
  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken });

  $.ajax({
    url: '/api/getContentPacks',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      table.clear();

      response.forEach((item) => {
        // Safely extract values with defaults
        const packName = item.pack_info && item.pack_info.pack_name ? item.pack_info.pack_name : 'Unnamed';
        const packVersion = item.pack_info && item.pack_info.version ? item.pack_info.version : 'n/a';
        const dbType = item.pack_info && item.pack_info.db_type ? item.pack_info.db_type : 'n/a';
        
        // Build tooltip HTML using string concatenation
        const tooltipHtml = 
          '<div class="tooltip-content">' +
            '<div class="tooltip-header">Package Details</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">ID:</div>' +
              '<div class="tooltip-value">' + item.id + '</div>' +
            '</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">Name:</div>' +
              '<div class="tooltip-value">' + packName + '</div>' +
            '</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">Version:</div>' +
              '<div class="tooltip-value">' + packVersion + '</div>' +
            '</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">DB Type:</div>' +
              '<div class="tooltip-value">' + dbType + '</div>' +
            '</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">Build Date:</div>' +
              '<div class="tooltip-value">' + (item.build_date || 'n/a') + '</div>' +
            '</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">Build Version:</div>' +
              '<div class="tooltip-value">' + (item.build_version || 'n/a') + '</div>' +
            '</div>' +
            '<div class="tooltip-row">' +
              '<div class="tooltip-label">Uploaded:</div>' +
              '<div class="tooltip-value">' + (item.uploaded_date || 'n/a') + '</div>' +
            '</div>' +
          '</div>';

        // Build the pack name cell
        const packNameCell = 
          '<div class="pack-tooltip">' +
            packName +
            tooltipHtml +
          '</div>';

        table.row.add([
          item.id,
          packNameCell,
          item.version,
          item.db_type,
          item.build_date,
          item.build_version,
          item.uploaded_date
        ]);
      });

      table.draw();
    },
    error: function(xhr, status, error) {
      $('#response').text('Error: ' + error);
    }
  });
}



 

  /************************************************/
function deletePackByPackId()
{
	const jwtToken = '${tokenObject.jwt}';
	const PackId = $('#packIdToEditId').val();
	const PackName = $('#packNameToEditId').val();
	const PackFilePath = $('#packFilePathToEditId').val();

	
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          id: PackId,
          pack_name: PackName,
          pack_schedule: PackSchedule,
          pack_file_path: PackFilePath,
          pack_os_type: PackOsType
        });
  	
  	$.ajax({
          url: '/api/deletePacksByPackId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getPacks();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function updatePackByPackId()
{
	const jwtToken = '${tokenObject.jwt}';
	const PackId = $('#packIdToEditId').val();
	const PackName = $('#packNameToEditId').val();
	const PackDeployed = $('#packDeployedToEditId').val();
	const PackZipFilePath = $('#packFilePathToEditId').val();
	const PackOutputDir = $('#packOutputPathToEditId').val();
	console.log("Pack Deployed status is : " + PackDeployed);
	
	
	console.log("Pack Name to Update: " + PackName);
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          pack_id: PackId,
          pack_name: PackName,
          pack_loaded: PackDeployed,
          zipFilePath: PackZipFilePath,
          outputDir : PackOutputDir
          });
  	
  	$.ajax({
          url: '/api/updatePackByPackId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getPacks();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}

/************************************************/
function getPackByPackID(varId)
{
	const jwtToken = '${tokenObject.jwt}';
	const PackId = varId;
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          pack_id: PackId,
         });
  	
  	$.ajax({
          url: '/api/getPackByPackId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('packNameToEditId').value = response[0].pack_name;
             	document.getElementById('packFilePathToEditId').value = response[0].pack_file_path;
             	document.getElementById('packOutputPathToEditId').value = response[0].pack_output_path;
             	document.getElementById('packDeployedToEditId').value = response[0].pack_deployed;
             	document.getElementById('packIdToEditId').value = response[0].id;
  				document.getElementById('id_edit_modal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
}
  
  document.addEventListener("DOMContentLoaded", function() {
    getPacks();
});
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
