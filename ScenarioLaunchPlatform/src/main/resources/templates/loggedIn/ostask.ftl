<!DOCTYPE html>
<html>
<head>
<title>SLP OS Tasks</title>
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
              <h6 class="w3-opacity">OS Tasks Form</h6>
              <!-- -->
  				<form id="taskForm" enctype="multipart/form-data">
     <div id="edit" class="w3-container city">
	<div class="row">
		<div class="col-25">
				         OS Type 
				      </div>
		<div class="col-75">
			<select id="task_os_type" name="task_os_type" required>
				<option value="">Select an option</option>
				<option value="Linux">Linux</option>
				<option value="Windows">Windows</option>
			</select>
		</div>
	</div>
	<div class="row">
		<div class="col-25">
				         Task Name: 
		</div>
		<div class="col-75">
			<input type="text" id="task_name" name="task_name" class="w3-right w3-white w3-border" placeholder="Example Run_API" required>
		</div>
	</div>
	<div class="row">
		<div class="col-25">
				         Task Schedule: 
		</div>
		<div class="col-75">
				<input type="text" id="task_schedule" name="task_schedule" class="w3-right w3-white w3-border" placeholder="*****" required>
		</div>
	</div>
	<div class="row">
				<div class="col-25">
				         Task File Path: 
				      </div>
				<div class="col-75">
					<input type="text" id="task_file_path" name="task_file_path" class="w3-right w3-white w3-border" placeholder="/tmp/uploads/" required>
					</div>
	</div>
	<div class="row">
					<div class="col-25">
				         Task File 
				      </div>
					<div class="col-75">
						<input type="file" id="task_file_content" class="w3-left w3-white w3-border" name="task_file_content" required>
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
              <h6 class="w3-opacity">OS Tasks</h6>
              
              <table id="example" class="display" style="width:100%">
			  <thead>
			    <tr>
			    	<th>id</th>
			      	<th>task_name</th>
			      	<th>task_schedule</th>
			      	<th>task_file_path</th>
			      	<th>task_os_type</th>
			      	<th>created_at</th>
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
<#include "includes/footer.ftl">
 <div id="id_edit_modal" class="w3-modal">
			 <div class="w3-modal-content w3-card-4 w3-animate-zoom custom-modal">
			  <header class="w3-container w3-blue-grey"> 
			   <span onclick="closeOSTask();getOSTasks()" class="w3-buttonw3-blue-grey w3-xlarge w3-display-topright">&times;</span>
			   <h2>OS Tasks</h2>
			  </header>
			
			  <div class="w3-bar w3-border-bottom">
			   <button id="osTasks" class="tablink w3-bar-item w3-button" onclick="toggleEditResultsShowOSTasks()">OS Task</button>
			   

			  </div>
			  
			  <div id="edit" class="w3-container city">
			  <div class="row">
			   		  <div class="col-25">
				         Task Id: 
				      </div>
				      <div class="col-75">
				        <input type="text" id="osTaskIdToEditId" value="" class="w3-right w3-white w3-border" readonly>
				      </div>
			  	</div>
			  	
			  	<div class="row">
			   		  <div class="col-25">
				         OS Task Name: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="osTaskNameToEditId" value="" class="w3-right w3-white w3-border" readonly>
					  </div>
				</div> 
				
				<div class="row">
			   		  <div class="col-25">
				         OS Task Schedule: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="osTaskScheduleToEditId" value="" class="w3-right w3-white w3-border" readonly>
					  </div>
				</div> 
				<div class="row">
			   		  <div class="col-25">
				         OS Task File Path: 
				      </div>
				      <div class="col-75">		        
					       <input type="text" id="osTaskFilePathToEditId" value="" class="w3-right w3-white w3-border" readonly>
					  </div>
				</div> 
			   <div class="row">
	        		  <div class="col-25">
				         Task OS Type 
				      </div>
	        			<div class="col-75">		        
					       <input type="text" id="osTaskOSTypeToEditId" value="" class="w3-right w3-white w3-border" readonly>
					  </div>
				     
	        	</div>
		
				<div class="row">
			   		  <div class="col-25">
				         Task Active 
				      </div>
				      <div class="col-75">	
						 <input type="text" id="osTaskActiveToEditId" value="" class="w3-right w3-white w3-border" readonly>
					</div>
				</div> 
			 </div>
			  <div class="w3-container w3-blue-grey w3-padding">
			   <button id="DeleteOSTaskButton" class="w3-button w3-right w3-white w3-border" onclick="deleteOSTaskByTaskId()">Delete</button>
			   <button id="CloseOSTaskButton" class="w3-button w3-right w3-white w3-border" onclick="closeOSTask()">Close</button>
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
	function closeOSTask()
	{
		document.getElementById('id_edit_modal').style.display='none'
		
		toggleEditShowOSTask();
		
	}
	
	function toggleEditShowOSTask()
	{
		
		const deleteOSTaskButton = document.getElementById('DeleteOSTaskButton');
		const updateOSTaskButton = document.getElementById('UpdateOSTaskButton');
		
		
		deleteOSTaskButton.style.display = 'block';
		updateOSTaskButton.style.display = 'block';
		
        
	}
	</script>

<script>
function addOSTask(event) {
    event.preventDefault(); // Prevent default form submission

    // Create FormData object
    let formData = new FormData();
    
    // Append individual form fields with correct names
    formData.append('task_name', document.querySelector('[name="task_name"]').value);
    formData.append('task_schedule', document.querySelector('[name="task_schedule"]').value);
    formData.append('task_file_path', document.querySelector('[name="task_file_path"]').value);
    formData.append('task_os_type', document.querySelector('[name="task_os_type"]').value);
    
    // Append file input
    let fileInput = document.querySelector('[name="task_file_content"]');
    if (fileInput.files.length > 0) {
        formData.append('task_file_content', fileInput.files[0]);
    }
    
    // Append JWT token
    const jwtToken = '${tokenObject.jwt}'; // Ensure tokenObject is defined
    formData.append('jwt', jwtToken);

    // Send AJAX request
    $.ajax({
        url: '/api/addOSTask',
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
    document.getElementById('taskForm').addEventListener('submit', addOSTask);
});

 $(document).ready(function() 
  {
  	getOSTasks();
  	const table = $('#example').DataTable();
  	table.on('click', 'tbody tr', function() 
  	{
  		console.log('API rows values : ', table.row(this).data()[0]);
  		
  		getOSTaskByTaskID(table.row(this).data()[0]);
  		
	})
  });

 function getOSTasks()
  {
  	const table = $('#example').DataTable();
  
  	const jwtToken = '${tokenObject.jwt}';
   
  	const jsonData = JSON.stringify({
          jwt: jwtToken,
        });
  
  
	$.ajax({
          url: '/api/getOSTasks', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	table.clear();
            
	            response.forEach((item) => {
	                table.row.add([item.id, item.task_name, item.task_schedule, item.task_file_path,item.task_os_type, item.created_at]);
	            });
            
           		table.draw();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
  }
  
  /************************************************/
function deleteOSTaskByTaskId()
{
	const jwtToken = '${tokenObject.jwt}';
	const TaskId = $('#osTaskIdToEditId').val();
	const TaskName = $('#osTaskNameToEditId').val();
	const TaskSchedule = $('#osTaskScheduleToEditId').val();
	const TaskFilePath = $('#osTaskFilePathToEditId').val();
	const TaskOsType = $('#osTaskIdToEditId').val();
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          id: TaskId,
          task_name: TaskName,
          task_schedule: TaskSchedule,
          task_file_path: TaskFilePath,
          task_os_type: TaskOsType
        });
  	
  	$.ajax({
          url: '/api/deleteOSTasksByTaskId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getOSTasks();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}
/************************************************/
function updateOSTaskByTaskId()
{
	const jwtToken = '${tokenObject.jwt}';
	const TaskId = $('#osTaskIdToEditId').val();
	const TaskName = $('#osTaskNameToEditId').val();
	const TaskSchedule = $('#osTaskScheduleToEditId').val();
	const TaskOSType = $('#osTaskOSTypeToEditId').val();
	const TaskActive = $('#osTaskActiveToEditId').val();
	
	console.log("Task Name to Update: " + TaskName);
	
	const jsonData = JSON.stringify({
          jwt: jwtToken,
          task_id: TaskId,
          task_name: TaskName,
          task_schedule: TaskSchedule,
          task_os_type: TaskOSType,
          task_active: TaskActive,
        });
  	
  	$.ajax({
          url: '/api/updateOSTaskByTaskId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	getOSTasks();
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });

}

/************************************************/
function getOSTaskByTaskID(varId)
{
	const jwtToken = '${tokenObject.jwt}';
	const TaskId = varId;
	

	const jsonData = JSON.stringify({
          jwt: jwtToken,
          task_id: TaskId,
         });
  	
  	$.ajax({
          url: '/api/getOSTaskByTaskId', 
          type: 'POST',
          data: jsonData,
          contentType: 'application/json; charset=utf-8', // Set content type to JSON
          success: function(response) 
          {
             	console.log(response);
             	document.getElementById('osTaskNameToEditId').value = response[0].task_name;
             	document.getElementById('osTaskScheduleToEditId').value = response[0].task_schedule;
             	document.getElementById('osTaskFilePathToEditId').value = response[0].task_file_path;
             	document.getElementById('osTaskOSTypeToEditId').value = response[0].task_os_type;
             	document.getElementById('osTaskActiveToEditId').value = response[0].task_active;
             	
             	document.getElementById('osTaskIdToEditId').value = response[0].id;
             	
             	
  				document.getElementById('id_edit_modal').style.display='block';
          },
          error: function(xhr, status, error) 
          {
            $('#response').text('Error: ' + error);
          }
        });
}
  
  document.addEventListener("DOMContentLoaded", function() {
    getOSTasks();
});
</script>
</script>
</body>
</html> 
