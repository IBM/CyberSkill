<!DOCTYPE html>
<html>
<head>
<title>OS Tasks - SLP</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/datatables.min.css">
<link rel='stylesheet' href='css/fonts.css'>
<link rel="stylesheet" href="css/contentpacks-modern.css">
<script src="js/jquery.min.js"></script>
<script src="js/datatables.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 { font-family: "Roboto", sans-serif; }

/* ── Page Header ── */
.page-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  border-radius: 12px; padding: 1.5rem 2rem; margin-bottom: 1.5rem;
  color: white; display: flex; justify-content: space-between; align-items: center;
  box-shadow: 0 4px 15px rgba(77,99,111,0.3);
}
.page-header-title { font-size: 1.5rem; font-weight: 700; margin: 0; }
.page-header-subtitle { font-size: 0.875rem; opacity: 0.85; margin: 0.25rem 0 0; }
.page-header-icon {
  width: 52px; height: 52px; background: rgba(255,255,255,0.15);
  border-radius: 12px; display: flex; align-items: center; justify-content: center;
  font-size: 1.5rem;
}

/* ── Breadcrumb ── */
.breadcrumb-bar {
  background: white; border: 1px solid #e2e8f0; border-radius: 8px;
  padding: 0.6rem 1rem; margin-bottom: 1.25rem;
  display: flex; align-items: center; gap: 0.5rem;
  font-size: 0.85rem; color: #64748b;
}
.breadcrumb-bar a { color: #4d636f; text-decoration: none; font-weight: 500; }
.breadcrumb-bar a:hover { color: #3a4f5a; text-decoration: underline; }
.breadcrumb-sep { color: #cbd5e1; }

/* ── Section Card ── */
.section-card {
  background: white; border: 1px solid #e2e8f0; border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 1.25rem; overflow: hidden;
}
.section-card-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  padding: 1rem 1.5rem; display: flex; align-items: center; justify-content: space-between;
}
.section-card-title {
  color: white; font-size: 1rem; font-weight: 600;
  display: flex; align-items: center; gap: 0.6rem; margin: 0;
}
.section-card-body { padding: 1.5rem; }

/* ── Modern Form ── */
.form-grid {
  display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem;
}
.form-group { display: flex; flex-direction: column; gap: 0.4rem; }
.form-group.full-width { grid-column: span 2; }
.form-label {
  font-size: 0.85rem; font-weight: 600; color: #374151;
  display: flex; align-items: center; gap: 0.4rem;
}
.form-label .required { color: #ef4444; }
.form-input, .form-select {
  padding: 0.65rem 0.9rem; border: 1.5px solid #d1d5db; border-radius: 8px;
  font-size: 0.9rem; color: #1e293b; background: white;
  transition: border-color 0.2s, box-shadow 0.2s; width: 100%;
}
.form-input:focus, .form-select:focus {
  outline: none; border-color: #4d636f;
  box-shadow: 0 0 0 3px rgba(77,99,111,0.12);
}
.form-input:hover, .form-select:hover { border-color: #9ca3af; }
.form-input::placeholder { color: #9ca3af; }
.form-file-input {
  padding: 0.5rem; border: 1.5px dashed #d1d5db; border-radius: 8px;
  font-size: 0.875rem; cursor: pointer; width: 100%; background: #f8fafc;
  transition: border-color 0.2s;
}
.form-file-input:hover { border-color: #4d636f; background: #f0f4f7; }

/* ── Buttons ── */
.btn-primary {
  background: linear-gradient(135deg, #4d636f, #3a4f5a); color: white;
  border: none; padding: 0.65rem 1.5rem; border-radius: 8px; cursor: pointer;
  font-size: 0.9rem; font-weight: 600; display: inline-flex; align-items: center;
  gap: 0.5rem; transition: all 0.2s; box-shadow: 0 2px 6px rgba(77,99,111,0.3);
}
.btn-primary:hover { background: linear-gradient(135deg, #3a4f5a, #2d3f4a); transform: translateY(-1px); }
.btn-danger {
  background: #ef4444; color: white; border: none; padding: 0.5rem 1.25rem;
  border-radius: 8px; cursor: pointer; font-size: 0.875rem; font-weight: 500;
  display: inline-flex; align-items: center; gap: 0.4rem; transition: all 0.2s;
}
.btn-danger:hover { background: #dc2626; }
.btn-secondary {
  background: #f1f5f9; color: #374151; border: 1px solid #d1d5db;
  padding: 0.5rem 1.25rem; border-radius: 8px; cursor: pointer; font-size: 0.875rem;
  font-weight: 500; display: inline-flex; align-items: center; gap: 0.4rem; transition: all 0.2s;
}
.btn-secondary:hover { background: #e2e8f0; }

/* ── DataTable Overrides ── */
.dataTables_wrapper { font-size: 0.875rem; }
table.dataTable thead th {
  background: #f8fafc; color: #374151; font-weight: 600;
  border-bottom: 2px solid #e2e8f0; padding: 0.75rem 1rem;
}
table.dataTable tbody tr { transition: background 0.15s; }
table.dataTable tbody tr:hover { background: #f0f9ff !important; cursor: pointer; }
table.dataTable tbody td { padding: 0.65rem 1rem; border-bottom: 1px solid #f1f5f9; color: #374151; }
.dataTables_filter input, .dataTables_length select {
  border: 1px solid #d1d5db; border-radius: 6px; padding: 0.35rem 0.6rem; font-size: 0.85rem;
}

/* ── Modern Modal ── */
.modern-modal-overlay {
  display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.5); z-index: 9000; align-items: center; justify-content: center;
}
.modern-modal-overlay.active { display: flex; }
.modern-modal {
  background: white; border-radius: 16px; width: 70%; max-width: 700px;
  max-height: 90vh; overflow: hidden; display: flex; flex-direction: column;
  box-shadow: 0 25px 50px rgba(0,0,0,0.25);
}
.modern-modal-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  padding: 1.25rem 1.5rem; display: flex; align-items: center; justify-content: space-between;
}
.modern-modal-header h3 { color: white; margin: 0; font-size: 1.1rem; font-weight: 600; }
.modern-modal-close {
  background: rgba(255,255,255,0.2); border: none; color: white; width: 32px; height: 32px;
  border-radius: 8px; cursor: pointer; font-size: 1.1rem; display: flex;
  align-items: center; justify-content: center; transition: background 0.2s;
}
.modern-modal-close:hover { background: rgba(255,255,255,0.35); }
.modern-modal-body { padding: 1.5rem; overflow-y: auto; flex: 1; }
.modern-modal-footer {
  padding: 1rem 1.5rem; border-top: 1px solid #e2e8f0;
  display: flex; justify-content: flex-end; gap: 0.75rem;
}

/* ── Detail Field ── */
.detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
.detail-field { display: flex; flex-direction: column; gap: 0.3rem; }
.detail-field.full-width { grid-column: span 2; }
.detail-label { font-size: 0.78rem; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; }
.detail-value {
  padding: 0.6rem 0.9rem; background: #f8fafc; border: 1px solid #e2e8f0;
  border-radius: 8px; font-size: 0.9rem; color: #1e293b; font-family: monospace;
}

/* ── OS Type Badge ── */
.os-badge {
  display: inline-flex; align-items: center; gap: 0.4rem;
  padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.78rem; font-weight: 600;
}
.os-badge.linux { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
.os-badge.windows { background: #eff6ff; color: #1e40af; border: 1px solid #bfdbfe; }

/* ── Cron hint ── */
.cron-hint {
  font-size: 0.75rem; color: #64748b; margin-top: 0.25rem;
  display: flex; align-items: center; gap: 0.3rem;
}
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px; margin-top:80px;">
  <div class="w3-row">
    <!-- Left Column -->
    <div id="leftColumn"></div>

    <!-- Middle Column -->
    <div class="w3-col m9">
      <div class="w3-row-padding">
        <div class="w3-col m12">

          <!-- Breadcrumb -->
          <div class="breadcrumb-bar">
            <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
            <span class="breadcrumb-sep">›</span>
            <span><i class="fa fa-tasks"></i> OS Tasks</span>
          </div>

          <!-- Page Header -->
          <div class="page-header">
            <div>
              <div class="page-header-title"><i class="fa fa-tasks" style="margin-right:0.5rem;"></i>OS Task Manager</div>
              <div class="page-header-subtitle">Schedule and manage operating system tasks for Linux and Windows environments</div>
            </div>
            <div class="page-header-icon"><i class="fa fa-cog"></i></div>
          </div>

          <!-- Add OS Task Form -->
          <div class="section-card">
            <div class="section-card-header">
              <h3 class="section-card-title"><i class="fa fa-plus-circle"></i> Add New OS Task</h3>
            </div>
            <div class="section-card-body">
              <form id="taskForm" enctype="multipart/form-data">
                <div class="form-grid">
                  <div class="form-group">
                    <label class="form-label"><i class="fa fa-desktop"></i> OS Type <span class="required">*</span></label>
                    <select id="task_os_type" name="task_os_type" class="form-select" required>
                      <option value="">Select OS type...</option>
                      <option value="Linux">🐧 Linux</option>
                      <option value="Windows">🪟 Windows</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label class="form-label"><i class="fa fa-tag"></i> Task Name <span class="required">*</span></label>
                    <input type="text" id="task_name" name="task_name" class="form-input" placeholder="e.g. Run_API_Backup" required>
                  </div>
                  <div class="form-group">
                    <label class="form-label"><i class="fa fa-clock-o"></i> Cron Schedule <span class="required">*</span></label>
                    <input type="text" id="task_schedule" name="task_schedule" class="form-input" placeholder="* * * * *" required>
                    <div class="cron-hint"><i class="fa fa-info-circle"></i> Format: minute hour day month weekday</div>
                  </div>
                  <div class="form-group">
                    <label class="form-label"><i class="fa fa-folder-open"></i> Task File Path <span class="required">*</span></label>
                    <input type="text" id="task_file_path" name="task_file_path" class="form-input" placeholder="/tmp/uploads/" required>
                  </div>
                  <div class="form-group full-width">
                    <label class="form-label"><i class="fa fa-file-code-o"></i> Task File <span class="required">*</span></label>
                    <input type="file" id="task_file_content" name="task_file_content" class="form-file-input" required>
                  </div>
                </div>
                <div style="margin-top:1.25rem; display:flex; justify-content:flex-end;">
                  <button type="submit" class="btn-primary">
                    <i class="fa fa-upload"></i> Submit Task
                  </button>
                </div>
              </form>
            </div>
          </div>

          <!-- OS Tasks Table -->
          <div class="section-card">
            <div class="section-card-header">
              <h3 class="section-card-title"><i class="fa fa-list"></i> Scheduled OS Tasks</h3>
              <span style="background:rgba(255,255,255,0.2);color:white;border-radius:20px;padding:3px 12px;font-size:0.78rem;">
                <i class="fa fa-mouse-pointer"></i> Click row to manage
              </span>
            </div>
            <div class="section-card-body">
              <table id="example" class="display" style="width:100%">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Task Name</th>
                    <th>Schedule</th>
                    <th>File Path</th>
                    <th>OS Type</th>
                    <th>Created At</th>
                  </tr>
                </thead>
                <tbody></tbody>
              </table>
            </div>
          </div>

        </div>
      </div>
    </div>
    <!-- End Middle Column -->
  </div>
</div>

<!-- Footer -->
<div id="footer"></div>

<!-- ── Modal: OS Task Detail ── -->
<div id="id_edit_modal" class="modern-modal-overlay">
  <div class="modern-modal">
    <div class="modern-modal-header">
      <h3><i class="fa fa-cog" style="margin-right:0.5rem;"></i>OS Task Details</h3>
      <button class="modern-modal-close" onclick="closeOSTask()">&times;</button>
    </div>
    <div class="modern-modal-body">
      <div class="detail-grid">
        <div class="detail-field">
          <div class="detail-label"><i class="fa fa-hashtag"></i> Task ID</div>
          <div class="detail-value" id="osTaskIdToEditId">—</div>
        </div>
        <div class="detail-field">
          <div class="detail-label"><i class="fa fa-tag"></i> Task Name</div>
          <div class="detail-value" id="osTaskNameToEditId">—</div>
        </div>
        <div class="detail-field">
          <div class="detail-label"><i class="fa fa-clock-o"></i> Schedule</div>
          <div class="detail-value" id="osTaskScheduleToEditId">—</div>
        </div>
        <div class="detail-field">
          <div class="detail-label"><i class="fa fa-desktop"></i> OS Type</div>
          <div class="detail-value" id="osTaskOSTypeToEditId">—</div>
        </div>
        <div class="detail-field full-width">
          <div class="detail-label"><i class="fa fa-folder-open"></i> File Path</div>
          <div class="detail-value" id="osTaskFilePathToEditId">—</div>
        </div>
        <div class="detail-field">
          <div class="detail-label"><i class="fa fa-toggle-on"></i> Active</div>
          <div class="detail-value" id="osTaskActiveToEditId">—</div>
        </div>
      </div>
    </div>
    <div class="modern-modal-footer">
      <button class="btn-danger" id="DeleteOSTaskButton" onclick="deleteOSTaskByTaskId()">
        <i class="fa fa-trash"></i> Delete Task
      </button>
      <button class="btn-secondary" id="CloseOSTaskButton" onclick="closeOSTask()">
        <i class="fa fa-times"></i> Close
      </button>
    </div>
  </div>
</div>

<script>
// Load navbar, left column, footer
$(document).ready(function() {
  $.ajax({ url: '/loggedIn/includes/navbar.ftl', method: 'GET',
    success: function(r) { $('#navbar').html(r); },
    error: function(e) { console.error('Navbar error:', e); }
  });
  $.ajax({ url: '/loggedIn/includes/leftColumn2.ftl', method: 'GET',
    success: function(r) { $('#leftColumn').html(r); },
    error: function(e) { console.error('Left column error:', e); }
  });
  $.ajax({ url: '/loggedIn/includes/footer.ftl', method: 'GET',
    success: function(r) { $('#footer').html(r); },
    error: function(e) { console.error('Footer error:', e); }
  });

  // Init DataTable and load tasks
  getOSTasks();

  const table = $('#example').DataTable();
  table.on('click', 'tbody tr', function() {
    const taskId = table.row(this).data()[0];
    console.log('Selected task ID:', taskId);
    getOSTaskByTaskID(taskId);
  });

  // Form submit
  document.getElementById('taskForm').addEventListener('submit', addOSTask);
});

function closeOSTask() {
  document.getElementById('id_edit_modal').classList.remove('active');
  getOSTasks();
}

function addOSTask(event) {
  event.preventDefault();
  const btn = event.submitter || document.querySelector('#taskForm button[type="submit"]');
  if (btn) { btn.disabled = true; btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Submitting...'; }

  let formData = new FormData();
  formData.append('task_name', document.querySelector('[name="task_name"]').value);
  formData.append('task_schedule', document.querySelector('[name="task_schedule"]').value);
  formData.append('task_file_path', document.querySelector('[name="task_file_path"]').value);
  formData.append('task_os_type', document.querySelector('[name="task_os_type"]').value);

  const fileInput = document.querySelector('[name="task_file_content"]');
  if (fileInput.files.length > 0) {
    formData.append('task_file_content', fileInput.files[0]);
  }

  const jwtToken = '${tokenObject.jwt}';
  formData.append('jwt', jwtToken);

  $.ajax({
    url: '/api/addOSTask',
    type: 'POST',
    data: formData,
    processData: false,
    contentType: false,
    success: function(response) {
      console.log('Task added:', response);
      document.getElementById('taskForm').reset();
      getOSTasks();
      if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa fa-upload"></i> Submit Task'; }
    },
    error: function(xhr, status, error) {
      console.error('Error adding task:', xhr.responseText);
      alert('Failed to submit the task. Please try again.');
      if (btn) { btn.disabled = false; btn.innerHTML = '<i class="fa fa-upload"></i> Submit Task'; }
    }
  });
}

function getOSTasks() {
  const table = $('#example').DataTable();
  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken });

  $.ajax({
    url: '/api/getOSTasks',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      table.clear();
      response.forEach(item => {
        table.row.add([item.id, item.task_name, item.task_schedule, item.task_file_path, item.task_os_type, item.created_at]);
      });
      table.draw();
    },
    error: function(xhr, status, error) {
      console.error('Error loading tasks:', error);
    }
  });
}

function getOSTaskByTaskID(varId) {
  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken, task_id: varId });

  $.ajax({
    url: '/api/getOSTaskByTaskId',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      if (response && response.length > 0) {
        const t = response[0];
        document.getElementById('osTaskIdToEditId').textContent = t.id || '—';
        document.getElementById('osTaskNameToEditId').textContent = t.task_name || '—';
        document.getElementById('osTaskScheduleToEditId').textContent = t.task_schedule || '—';
        document.getElementById('osTaskFilePathToEditId').textContent = t.task_file_path || '—';
        document.getElementById('osTaskOSTypeToEditId').textContent = t.task_os_type || '—';
        document.getElementById('osTaskActiveToEditId').textContent = t.task_active !== undefined ? t.task_active : '—';
        document.getElementById('id_edit_modal').classList.add('active');
      }
    },
    error: function(xhr, status, error) {
      console.error('Error loading task details:', error);
    }
  });
}

function deleteOSTaskByTaskId() {
  const jwtToken = '${tokenObject.jwt}';
  const TaskId = document.getElementById('osTaskIdToEditId').textContent;
  const TaskName = document.getElementById('osTaskNameToEditId').textContent;
  const TaskSchedule = document.getElementById('osTaskScheduleToEditId').textContent;
  const TaskFilePath = document.getElementById('osTaskFilePathToEditId').textContent;
  const TaskOsType = document.getElementById('osTaskOSTypeToEditId').textContent;

  if (!confirm('Delete task "' + TaskName + '"? This cannot be undone.')) return;

  const jsonData = JSON.stringify({
    jwt: jwtToken, id: TaskId, task_name: TaskName,
    task_schedule: TaskSchedule, task_file_path: TaskFilePath, task_os_type: TaskOsType
  });

  $.ajax({
    url: '/api/deleteOSTasksByTaskId',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      console.log('Task deleted:', response);
      closeOSTask();
    },
    error: function(xhr, status, error) {
      console.error('Error deleting task:', error);
      alert('Failed to delete task.');
    }
  });
}
</script>

<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>
</body>
</html>
