<!DOCTYPE html>
<html>
<head>
<title>Admin Functions</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/styles.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/datatables.min.css">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel='stylesheet' href='css/fonts.css'>
<script src="js/jquery.min.js"></script>
<script src="js/datatables.js"></script>
<script src="js/bootstrap.bundle.min.js"></script>




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
    .file-path-cell {
  max-width: 250px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
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
            <div class="w3-container w3-padding" style="overflow-x: auto;">
              <h6 class="w3-opacity">Current Admin Functions</h6>
               <div class="d-flex gap-2 mb-3">     
                    <!-- Trigger Button -->
                    <div id="addFunctionContainer" style="display: none;">
  <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#uploadModal">
    ➕ Add Function
  </button>
</div>
    
                    <button id="toggleAllBtn" class="btn btn-warning mb-3">Deactivate All</button>
               </div>

     
  <table id="example" class="table table-striped table-bordered" style="width:100%">
			  <thead>
			    <tr>
			    	<th>id</th>
			      	<th>function_name</th>
			      	<th>function_description</th>
			      	<th>function_script</th>
			      	<th>function_file_path</th>
			      	<th>function_os_type</th>
			      	<th>Run Button</th>
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
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <form id="adminFunctionForm" enctype="multipart/form-data">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="uploadModalLabel">Upload Script and Create Admin Function</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>

        <div class="modal-body">
          <div class="mb-3">
            <label for="function_name" class="form-label">Function Name</label>
            <input type="text" class="form-control" id="function_name" name="function_name" required>
          </div>

          <div class="mb-3">
            <label for="function_description" class="form-label">Function Description</label>
            <input type="text" class="form-control" id="function_description" name="function_description" required>
          </div>

          <div class="mb-3">
            <label for="function_script" class="form-label">Function Script Name</label>
            <input type="text" class="form-control" id="function_script" name="function_script" required>
          </div>

          <div class="mb-3">
            <label for="function_api_call" class="form-label">Function API Call</label>
            <input type="text" class="form-control" id="function_api_call" name="function_api_call" required>
          </div>

          <div class="mb-3">
            <label for="function_file_path" class="form-label">Function File Path</label>
            <input type="text" class="form-control" id="function_file_path" name="function_file_path" required>
          </div>

          <div class="mb-3">
            <label for="function_os_type" class="form-label">Operating System</label>
            <select class="form-select" id="function_os_type" name="function_os_type" required>
              <option value="" disabled selected>Select OS Type</option>
              <option value="Windows">Windows</option>
              <option value="Linux">Linux</option>
              <option value="macOS">macOS</option>
            </select>
          </div>

          <div class="mb-3">
            <label for="script_upload" class="form-label">Upload Script File</label>
            <input type="file" class="form-control" id="script_upload" name="script_upload" required>
          </div>
        </div>

        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Submit Function</button>
        </div>
      </div>
    </form>
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

<!-- Debug Modal -->
<!-- Modal HTML -->
<div id="debugModal" class="modal fade" tabindex="-1">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Debug Info</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="debugModalBody" style="white-space: pre-wrap; font-family: monospace;"></div>
    </div>
  </div>
</div>
<!-- End Modal -->

<!-- Footer -->
<div id="footer"></div>
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



	
  $(document).ready(function() 
  {
  	getAdminFunctions();
  	const table = $('#example').DataTable();
  	table.on('click', 'tbody tr', function() 
  	{
  		console.log('API rows values : ', table.row(this).data()[0]);
  		
  		
	})
  });

$('#adminFunctionForm').on('submit', function (e) {
  e.preventDefault();

  const formData = new FormData(this);
 const jwtToken = '${tokenObject.jwt}'; // Ensure tokenObject is defined
    formData.append('jwt', jwtToken);
  $.ajax({
    url: '/api/createAdminFunction', // Update this endpoint as needed
    type: 'POST',
    data: formData,
    processData: false,
    contentType: false,
    success: function (response) {
      showToast('✅ Admin Function created successfully.', 'success');
      $('#uploadModal').modal('hide');
      
      // Refresh the table
  getAdminFunctions();
      
    },
    error: function (xhr, status, error) {
      showToast('❌ Error creating function: ' + error, 'error');
    }
  });
});

  
function getAdminFunctions() {
  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken });

  const table = $('#example').DataTable({
    destroy: true,
    columns: [
      { title: 'id', data: 'id' },
      { title: 'function_name', data: 'function_name' },
      { title: 'function_description', data: 'function_description' },
      { title: 'function_script', data: 'function_script' },
      { title: 'function_file_path', data: 'function_file_path', className: 'file-path-cell' },
      { title: 'function_os_type', data: 'function_os_type' },
      {
        title: 'Run Button',
        data: null,
         render: function (data, type, row) {
  return '<button id="btn-' + row.id + '" class="btn btn-primary btn-sm me-1 run-button" data-row-id="' + row.id + '">▶ Run</button>';
}

        }
    ],
    createdRow: function (row, data, dataIndex) {
      $('td', row).eq(0).attr('id', `td-id-<#noparse>${data.id}</#noparse>`);
      $('td', row).eq(1).attr('id', `td-name-<#noparse>${data.function_name}</#noparse>`);
      $('td', row).eq(2).attr('id', `td-desc-<#noparse>${data.function_description}</#noparse>`);
      $('td', row).eq(3).attr('id', `td-script-<#noparse>${data.function_script}</#noparse>`);
      $('td', row).eq(4).attr('id', `td-path-<#noparse>${data.function_script}</#noparse>`);
      $('td', row).eq(5).attr('id', `td-os-<#noparse>${data.function_script}</#noparse>`);
      $('td', row).eq(6).attr('id', `td-btn-<#noparse>${data.function_script}</#noparse>`);
    }
  });

$.ajax({
    url: '/api/getAdminFunctions',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function (response) {
      console.log('Admin function response:', response);
      table.clear().rows.add(response).draw();
    },
    error: function (xhr, status, error) {
      $('#response').text('Error: ' + error);
    }
  });

}

</script>
<script>

function getRunAdminFunction(buttonElement) {
  const table = $('#example').DataTable();
  const $button = $(buttonElement);
console.log('[RUN FUNC] Button element:', $button[0]);
  // Store original once
  if (!$button.data('original')) {
    $button.data('original', $button.html());
  }

  const row = table.row($button.closest('tr')).data();
	
	if (!row) {
    console.warn('[RUN FUNC] No row data found for this button.');
    return;
  }

  console.table(row);
  $button.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Running...');

  const jwtToken = '${tokenObject.jwt}';
  console.log("JWT TOKEN", jwtToken);

  const payload = {
    jwt: jwtToken,
    id: row.id,
    function_name: row.function_name,
    function_description: row.function_description,
    function_script: row.function_script,
    function_file_path: row.function_file_path,
    function_os_type: row.function_os_type
  };

  console.log('[RUN FUNC] Payload:', JSON.stringify(payload));

$.ajax({
    url: '/api/runAdminFunctions',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(payload),
    success: function (data) {
     console.log('[AJAX SUCCESS]', data);
      showToast(`✅ "<#noparse>${row.function_name}</#noparse>" executed successfully.`, 'success');
      $button.html('✅ Success');
    },
    error: function (_, __, error) {
    console.log('AJAX error triggered!');
    console.error('[AJAX ERROR]', status, error);
      showToast(`❌ Failed to execute "<#noparse>${row.function_name}</#noparse>": <#noparse>${error}</#noparse>`, 'error');
      $button.html('❌ Failed');
    },
    complete: function () {
      setTimeout(() => {
      console.log('[AJAX COMPLETE]');
        $button.prop('disabled', false).html($button.data('original'));
      }, 1500);
    }
  });
}
</script>
<script>
$(document).on('click', '.run-button', function () {
 console.log('[RUN BUTTON] Clicked:', this);
  getRunAdminFunction(this);
});

$(document).on('click', '.deactivate-button', function () {
  const $button = $(this); // ✅ Capture the button
  const rowId = $button.data('row-id');
  const jwtToken = '${tokenObject.jwt}';

  $.ajax({
    url: '/api/toggleAdminFunctionsByID',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({ jwt: jwtToken, id: rowId }),
    success: function () {
      showToast(`⛔ Function ID <#noparse>${rowId}</#noparse> toggled`, 'success');
      getRunAdminFunction($button[0]); // ⏎ Pass the actual button element back
    },
    error: function (_, __, error) {
      showToast(`❌ Failed to toggle function <#noparse>${rowId}: ${error}</#noparse>`, 'error');
    }
  });
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
    function showDebugModal(title, content) {
  $('#debugModal .modal-title').text(title);
  $('#debugModalBody').text(content);
  const modal = new bootstrap.Modal(document.getElementById('debugModal'));
  modal.show();
}
let allActive = true; // assume functions start as active

$('#toggleAllBtn').on('click', function () {
  const jwtToken = '${tokenObject.jwt}';
  const newState = allActive ? 'Inactive' : 'Active';

  $.ajax({
    url: '/api/toggleAdminFunctions',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({ jwt: jwtToken, new_state: newState }),
    success: function (res) {
      showToast(`✅ All functions set to "<#noparse>${newState}</#noparse>"`, 'success');
      allActive = !allActive;
      $('#toggleAllBtn').text(allActive ? 'Deactivate All' : 'Activate All');
      getAdminFunctions();
    },
    error: function (err) {
      showToast(`❌ Failed to update all functions`, 'error');
    }
  });
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
</script>
<script>
function getQueryParam(name) {
  const urlParams = new URLSearchParams(window.location.search);
  return urlParams.get(name);
}

document.addEventListener('DOMContentLoaded', function () {
  const flag = getQueryParam('flag');

  if (flag === 'exposed') {
    document.getElementById('addFunctionContainer').style.display = 'block';
  }
});
</script>
<script>
function showToast(message, type = 'success') {
  const toastId = `toast-<#noparse>${Date.now()}</#noparse>`;
  const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';

  const toastHTML = `
    <div id="<#noparse>${toastId}</#noparse>" class="toast align-items-center text-white <#noparse>${bgClass}</#noparse> border-0 mb-2" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body"><#noparse>${message}</#noparse></div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
  `;

  $('#toast-container').append(toastHTML);
  const toastElement = document.getElementById(toastId);
  const bootstrapToast = new bootstrap.Toast(toastElement);
  bootstrapToast.show();
}
</script>
<div id="toast-container" class="position-fixed top-0 end-0 p-3" style="z-index: 1100;"></div>

</body>
</html> 
