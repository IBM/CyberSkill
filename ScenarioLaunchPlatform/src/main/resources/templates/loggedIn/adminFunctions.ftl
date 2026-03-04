<!DOCTYPE html>
<html>
<head>
<title>Admin Functions - SLP</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/loggedIn/css/w3.css">
<link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">
<link rel="stylesheet" href="/loggedIn/css/navbar-fix.css">
<link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">
<link rel="stylesheet" href="/loggedIn/css/datatables.min.css">
<link rel="stylesheet" href="/loggedIn/css/bootstrap.min.css">
<link rel="stylesheet" href="/loggedIn/css/fonts.css">
<link rel="stylesheet" href="/loggedIn/css/contentpacks-modern.css">
<script src="/loggedIn/js/jquery.min.js"></script>
<script src="/loggedIn/js/datatables.js"></script>
<script src="/loggedIn/js/bootstrap.bundle.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: Roboto, sans-serif}

/* Page header */
.page-header {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
}
.page-header h4 { margin: 0 0 0.4rem 0; font-size: 1.3rem; font-weight: 700; }
.page-header p { margin: 0; opacity: 0.85; font-size: 0.9rem; }

/* Breadcrumb */
.breadcrumb-bar {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.6rem 0.75rem;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    margin-bottom: 1.25rem;
    font-size: 0.875rem;
}
.breadcrumb-bar a { color: #4d636f; text-decoration: none; font-weight: 500; }
.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar .separator { color: #94a3b8; }
.breadcrumb-bar .current { color: #64748b; }

/* Action bar */
.action-bar {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    margin-bottom: 1.25rem;
    flex-wrap: wrap;
}

/* Modern buttons */
.btn-modern {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.55rem 1.25rem;
    border: none;
    border-radius: 8px;
    font-size: 0.875rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
    text-decoration: none;
}
.btn-modern:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }
.btn-modern-primary { background: #4d636f; color: white; }
.btn-modern-primary:hover { background: #3a4f5a; color: white; }
.btn-modern-warning { background: #f59e0b; color: white; }
.btn-modern-warning:hover { background: #d97706; color: white; }
.btn-modern-success { background: #10b981; color: white; }
.btn-modern-success:hover { background: #059669; color: white; }
.btn-modern-danger { background: #ef4444; color: white; }
.btn-modern-danger:hover { background: #dc2626; color: white; }

/* Table wrapper */
.table-wrapper {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

/* Override DataTables to match theme */
.dataTables_wrapper .dataTables_filter input {
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    padding: 0.4rem 0.75rem;
    font-size: 0.875rem;
    transition: border-color 0.2s;
}
.dataTables_wrapper .dataTables_filter input:focus {
    outline: none;
    border-color: #4d636f;
}
.dataTables_wrapper .dataTables_length select {
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    padding: 0.3rem 0.5rem;
}

table.dataTable thead th {
    background: #f8fafc;
    color: #374151;
    font-weight: 700;
    font-size: 0.8rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    border-bottom: 2px solid #e2e8f0 !important;
    padding: 0.85rem 1rem;
}

table.dataTable tbody td {
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
    color: #374151;
    border-bottom: 1px solid #f1f5f9;
    vertical-align: middle;
}

table.dataTable tbody tr:hover {
    background: #f8fafc;
}

.file-path-cell {
    max-width: 200px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* Modal overrides */
.modal-header {
    background: linear-gradient(135deg, #4d636f, #3a4f5a);
    color: white;
    border-radius: 12px 12px 0 0;
}
.modal-header .btn-close { filter: invert(1); }
.modal-title { font-weight: 700; }
.modal-content { border-radius: 12px; border: none; box-shadow: 0 25px 50px rgba(0,0,0,0.25); }
.modal-footer { border-top: 1px solid #e2e8f0; }

/* Form controls in modal */
.modal .form-label { font-weight: 600; font-size: 0.875rem; color: #374151; }
.modal .form-control, .modal .form-select {
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.9rem;
    transition: border-color 0.2s;
}
.modal .form-control:focus, .modal .form-select:focus {
    border-color: #4d636f;
    box-shadow: 0 0 0 3px rgba(77, 99, 111, 0.1);
}

/* Toast container */
#toast-container {
    z-index: 9999;
}
</style>
<style>
*, *::before, *::after { box-sizing: border-box; }
.w3-top, .w3-top *, .w3-bar, .w3-bar *, .w3-bar-item, .w3-button { 
  border-radius: 0 !important; 
}
.w3-bar .w3-button:hover, .w3-bar .w3-bar-item:hover {
  background-color: white !important;
  color: #000 !important;
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

              <!-- Breadcrumb -->
              <div class="breadcrumb-bar">
                <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
                <span class="separator">›</span>
                <span class="current"><i class="fa fa-cogs"></i> Admin Functions</span>
              </div>

              <!-- Page Header -->
              <div class="page-header">
                <h4><i class="fa fa-cogs"></i> Admin Functions</h4>
                <p>Manage and execute administrative scripts and automation functions</p>
              </div>

              <!-- Action Bar -->
              <div class="action-bar">
                <div id="addFunctionContainer" style="display: none;">
                  <button class="btn-modern btn-modern-success" data-bs-toggle="modal" data-bs-target="#uploadModal">
                    <i class="fa fa-plus"></i> Add Function
                  </button>
                </div>
                <button id="toggleAllBtn" class="btn-modern btn-modern-warning">
                  <i class="fa fa-toggle-off"></i> Deactivate All
                </button>
              </div>

              <!-- DataTable -->
              <div class="table-wrapper">
                <table id="example" class="table table-striped table-bordered" style="width:100%">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Function Name</th>
                      <th>Description</th>
                      <th>Script</th>
                      <th>File Path</th>
                      <th>OS Type</th>
                      <th>Action</th>
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
      </div>
    </div>
    <!-- End Middle Column -->
  </div>
  <!-- End Grid -->
</div>
<!-- End Page Container -->
<br>

<!-- Add Function Modal -->
<div class="modal fade" id="uploadModal" tabindex="-1" aria-labelledby="uploadModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <form id="adminFunctionForm" enctype="multipart/form-data">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="uploadModalLabel"><i class="fa fa-plus-circle"></i> Add Admin Function</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="function_name" class="form-label">Function Name</label>
            <input type="text" class="form-control" id="function_name" name="function_name" placeholder="e.g. backup_database" required>
          </div>
          <div class="mb-3">
            <label for="function_description" class="form-label">Function Description</label>
            <input type="text" class="form-control" id="function_description" name="function_description" placeholder="Brief description of what this function does" required>
          </div>
          <div class="mb-3">
            <label for="function_script" class="form-label">Function Script Name</label>
            <input type="text" class="form-control" id="function_script" name="function_script" placeholder="e.g. backup.sh" required>
          </div>
          <div class="mb-3">
            <label for="function_api_call" class="form-label">Function API Call</label>
            <input type="text" class="form-control" id="function_api_call" name="function_api_call" placeholder="API endpoint to trigger this function" required>
          </div>
          <div class="mb-3">
            <label for="function_file_path" class="form-label">Function File Path</label>
            <input type="text" class="form-control" id="function_file_path" name="function_file_path" placeholder="/path/to/script" required>
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
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">
            <i class="fa fa-save"></i> Submit Function
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- Debug Modal -->
<div id="debugModal" class="modal fade" tabindex="-1">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fa fa-bug"></i> Debug Info</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="debugModalBody" style="white-space: pre-wrap; font-family: monospace; font-size: 0.85rem; background: #1e293b; color: #e2e8f0; border-radius: 8px; padding: 1rem;"></div>
    </div>
  </div>
</div>

<!-- Footer -->
<div id="footer"></div>

<!-- Toast Container -->
<div id="toast-container" class="position-fixed top-0 end-0 p-3" style="z-index: 9999;"></div>

<script>
window.onload = function() {
    quickSearch();
};

function quickSearch() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('lookup')) {
        const querytype = urlParams.get('lookup');
        if (querytype) {
            var table = $('#example').DataTable();
            table.search(querytype).draw();
        }
    }
}

$(document).ready(function() {
    // Load includes
    $.ajax({
        url: '/loggedIn/includes/navbar.ftl',
        method: 'GET',
        success: function(response) { $('#navbar').html(response); },
        error: function(err) { console.error('Error loading navbar:', err); }
    });

    $.ajax({
        url: '/loggedIn/includes/leftColumn2.ftl',
        method: 'GET',
        success: function(response) {
            $('#leftColumn').html(response);
            getQueryTypes();
        },
        error: function(err) { console.error('Error loading left column:', err); }
    });

    $.ajax({
        url: '/loggedIn/includes/footer.ftl',
        method: 'GET',
        success: function(response) { $('#footer').html(response); },
        error: function(err) { console.error('Error loading footer:', err); }
    });

    getAdminFunctions();

    const table = $('#example').DataTable();
    table.on('click', 'tbody tr', function() {
        console.log('Row values:', table.row(this).data()[0]);
    });
});

$('#adminFunctionForm').on('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    const jwtToken = '${tokenObject.jwt}';
    formData.append('jwt', jwtToken);

    $.ajax({
        url: '/api/createAdminFunction',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            showToast('Admin Function created successfully.', 'success');
            $('#uploadModal').modal('hide');
            getAdminFunctions();
        },
        error: function(xhr, status, error) {
            showToast('Error creating function: ' + error, 'error');
        }
    });
});

function getAdminFunctions() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });

    const table = $('#example').DataTable({
        destroy: true,
        columns: [
            { title: 'ID', data: 'id' },
            { title: 'Function Name', data: 'function_name' },
            { title: 'Description', data: 'function_description' },
            { title: 'Script', data: 'function_script' },
            { title: 'File Path', data: 'function_file_path', className: 'file-path-cell' },
            { title: 'OS Type', data: 'function_os_type' },
            {
                title: 'Action',
                data: null,
                render: function(data, type, row) {
                    return '<button id="btn-' + row.id + '" class="btn btn-primary btn-sm run-button" data-row-id="' + row.id + '">' +
                           '<i class="fa fa-play"></i> Run</button>';
                }
            }
        ],
        createdRow: function(row, data, dataIndex) {
            $('td', row).eq(0).attr('id', 'td-id-' + data.id);
            $('td', row).eq(1).attr('id', 'td-name-' + data.function_name);
            $('td', row).eq(2).attr('id', 'td-desc-' + data.function_description);
            $('td', row).eq(3).attr('id', 'td-script-' + data.function_script);
            $('td', row).eq(4).attr('id', 'td-path-' + data.function_script);
            $('td', row).eq(5).attr('id', 'td-os-' + data.function_script);
            $('td', row).eq(6).attr('id', 'td-btn-' + data.function_script);
        }
    });

    $.ajax({
        url: '/api/getAdminFunctions',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            console.log('Admin function response:', response);
            table.clear().rows.add(response).draw();
        },
        error: function(xhr, status, error) {
            console.error('Error loading admin functions:', error);
        }
    });
}
</script>

<script>
function getRunAdminFunction(buttonElement) {
    const table = $('#example').DataTable();
    const $button = $(buttonElement);

    if (!$button.data('original')) {
        $button.data('original', $button.html());
    }

    const row = table.row($button.closest('tr')).data();
    if (!row) {
        console.warn('No row data found for this button.');
        return;
    }

    $button.prop('disabled', true).html(
        '<span class="spinner-border spinner-border-sm me-1" role="status" aria-hidden="true"></span>Running...'
    );

    const jwtToken = '${tokenObject.jwt}';
    const payload = {
        jwt: jwtToken,
        id: row.id,
        function_name: row.function_name,
        function_description: row.function_description,
        function_script: row.function_script,
        function_file_path: row.function_file_path,
        function_os_type: row.function_os_type
    };

    $.ajax({
        url: '/api/runAdminFunctions',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(payload),
        success: function(data) {
            showToast(row.function_name + ' executed successfully.', 'success');
            $button.html('<i class="fa fa-check"></i> Done');
        },
        error: function(_, __, error) {
            showToast('Failed to execute ' + row.function_name + ': ' + error, 'error');
            $button.html('<i class="fa fa-times"></i> Failed');
        },
        complete: function() {
            setTimeout(function() {
                $button.prop('disabled', false).html($button.data('original'));
            }, 1500);
        }
    });
}

$(document).on('click', '.run-button', function() {
    getRunAdminFunction(this);
});

$(document).on('click', '.deactivate-button', function() {
    const $button = $(this);
    const rowId = $button.data('row-id');
    const jwtToken = '${tokenObject.jwt}';

    $.ajax({
        url: '/api/toggleAdminFunctionsByID',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ jwt: jwtToken, id: rowId }),
        success: function() {
            showToast('Function ID ' + rowId + ' toggled', 'success');
            getAdminFunctions();
        },
        error: function(_, __, error) {
            showToast('Failed to toggle function ' + rowId + ': ' + error, 'error');
        }
    });
});

let allActive = true;

$('#toggleAllBtn').on('click', function() {
    const jwtToken = '${tokenObject.jwt}';
    const newState = allActive ? 'Inactive' : 'Active';

    $.ajax({
        url: '/api/toggleAdminFunctions',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ jwt: jwtToken, new_state: newState }),
        success: function(res) {
            showToast('All functions set to "' + newState + '"', 'success');
            allActive = !allActive;
            $('#toggleAllBtn').html(
                allActive
                    ? '<i class="fa fa-toggle-off"></i> Deactivate All'
                    : '<i class="fa fa-toggle-on"></i> Activate All'
            );
            getAdminFunctions();
        },
        error: function(err) {
            showToast('Failed to update all functions', 'error');
        }
    });
});

function showDebugModal(title, content) {
    $('#debugModal .modal-title').text(title);
    $('#debugModalBody').text(content);
    const modal = new bootstrap.Modal(document.getElementById('debugModal'));
    modal.show();
}

function getQueryTypes() {
    const var_jwt = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: var_jwt });

    $.ajax({
        url: '/api/getQueryTypes',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            const queryTypes = document.getElementById('queryTypes');
            if (!queryTypes) return;
            queryTypes.innerHTML = "";
            if (Array.isArray(response)) {
                $.each(response, function(index, item) {
                    const span = document.createElement('span');
                    span.textContent = item.query_type;
                    span.classList.add('w3-tag', 'w3-small', 'w3-theme-d' + index);
                    span.onclick = function() {
                        window.location.href = 'databases.ftl?lookup=' + item.query_type;
                    };
                    queryTypes.appendChild(span);
                });
            }
        },
        error: function(xhr, status, error) {
            console.log('Error: ' + error);
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    const flag = new URLSearchParams(window.location.search).get('flag');
    if (flag === 'exposed') {
        document.getElementById('addFunctionContainer').style.display = 'block';
    }
});

function showToast(message, type) {
    type = type || 'success';
    const toastId = 'toast-' + Date.now();
    const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-times-circle';

    const toastHTML =
        '<div id="' + toastId + '" class="toast align-items-center text-white ' + bgClass + ' border-0 mb-2" role="alert" aria-live="assertive" aria-atomic="true">' +
        '<div class="d-flex">' +
        '<div class="toast-body"><i class="fa ' + icon + ' me-2"></i>' + message + '</div>' +
        '<button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
        '</div>' +
        '</div>';

    $('#toast-container').append(toastHTML);
    const toastElement = document.getElementById(toastId);
    const bootstrapToast = new bootstrap.Toast(toastElement);
    bootstrapToast.show();
}
</script>

<!-- SweetAlert2 and notification script -->
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>
</body>
</html>
