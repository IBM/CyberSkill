<!DOCTYPE html>
<html>
<head>
<title>Outliers - Scheduled Scripts</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/loggedIn/css/w3.css">
<link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">
<link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">
<link rel="stylesheet" href="/loggedIn/css/fonts.css">
<script src="/loggedIn/js/jquery.min.js"></script>
<style>
:root {
  --primary: #4d636f;
  --primary-dark: #3a4f5a;
  --primary-light: #6b8a99;
  --success: #10b981;
  --danger: #ef4444;
  --warning: #f59e0b;
  --info: #3b82f6;
  --bg: #f0f4f7;
  --card-bg: #ffffff;
  --border: #d1dde3;
  --text: #1e293b;
  --text-muted: #64748b;
}
html, body { font-family: "Roboto", "Open Sans", sans-serif; background: var(--bg); color: var(--text); margin: 0; }
.page-header {
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  color: white; padding: 28px 32px 20px; margin-bottom: 0; border-radius: 0 0 12px 12px;
}
.page-header h2 { margin: 0 0 6px; font-size: 1.6rem; font-weight: 700; }
.page-header p { margin: 0; opacity: 0.85; font-size: 0.95rem; }
.breadcrumb-bar {
  background: white; border-bottom: 1px solid var(--border);
  padding: 10px 32px; font-size: 0.85rem; color: var(--text-muted);
}
.breadcrumb-bar a { color: var(--primary); text-decoration: none; }
.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar span { margin: 0 6px; }
.stats-row { display: flex; gap: 16px; margin: 20px 0 0; flex-wrap: wrap; }
.stat-card {
  flex: 1; min-width: 120px; background: rgba(255,255,255,0.15);
  border-radius: 10px; padding: 14px 18px; text-align: center;
  border: 1px solid rgba(255,255,255,0.25);
}
.stat-card .stat-num { font-size: 1.8rem; font-weight: 700; color: white; line-height: 1; }
.stat-card .stat-label { font-size: 0.78rem; color: rgba(255,255,255,0.8); margin-top: 4px; }
.stat-card.green { background: rgba(16,185,129,0.25); border-color: rgba(16,185,129,0.4); }
.stat-card.blue { background: rgba(59,130,246,0.25); border-color: rgba(59,130,246,0.4); }
.stat-card.teal { background: rgba(20,184,166,0.25); border-color: rgba(20,184,166,0.4); }
.section-card {
  background: var(--card-bg); border-radius: 10px; border: 1px solid var(--border);
  margin-bottom: 16px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.section-card-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 20px; background: var(--card-bg); border-bottom: 1px solid var(--border);
  cursor: pointer; user-select: none;
}
.section-card-header:hover { background: #f8fafc; }
.section-card-header h5 { margin: 0; font-size: 1rem; font-weight: 600; color: var(--text); display: flex; align-items: center; gap: 10px; }
.section-card-header h5 i { color: var(--primary); }
.section-card-header .chevron { color: var(--text-muted); transition: transform 0.2s; }
.section-card-header.open .chevron { transform: rotate(180deg); }
.section-card-body { display: none; padding: 20px; }
.section-card-body.open { display: block; }
.view-toggle { display: flex; gap: 0; border-radius: 8px; overflow: hidden; border: 1px solid var(--border); }
.view-toggle-btn {
  flex: 1; padding: 10px 20px; border: none; background: white;
  color: var(--text-muted); cursor: pointer; font-size: 0.9rem;
  transition: all 0.2s; display: flex; align-items: center; justify-content: center; gap: 8px;
}
.view-toggle-btn:hover { background: #f0f4f7; }
.view-toggle-btn.active { background: var(--primary); color: white; }
.upload-zone {
  border: 2px dashed var(--border); border-radius: 10px; padding: 32px 20px;
  text-align: center; cursor: pointer; transition: all 0.3s; background: #f8fafc;
}
.upload-zone:hover { border-color: var(--primary); background: #eef3f6; }
.upload-zone.dragover { border-color: var(--success); background: #ecfdf5; }
.upload-zone i { font-size: 40px; color: var(--primary); margin-bottom: 10px; display: block; }
.upload-zone p { margin: 4px 0; color: var(--text-muted); font-size: 0.9rem; }
.upload-zone strong { color: var(--text); }
.search-bar { display: flex; gap: 12px; align-items: center; }
.search-bar input, .search-bar select {
  padding: 9px 14px; border: 1px solid var(--border); border-radius: 8px;
  font-size: 0.9rem; color: var(--text); background: white; outline: none; transition: border-color 0.2s;
}
.search-bar input { flex: 1; }
.search-bar input:focus, .search-bar select:focus { border-color: var(--primary); }
.pkg-card {
  background: white; border: 1px solid var(--border); border-radius: 10px;
  margin-bottom: 12px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05); transition: box-shadow 0.2s;
}
.pkg-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.pkg-card-body { padding: 16px 20px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
.pkg-card-info h5 { margin: 0 0 4px; font-size: 1rem; font-weight: 600; color: var(--text); }
.pkg-card-info p { margin: 0; font-size: 0.82rem; color: var(--text-muted); }
.pkg-card-actions { display: flex; gap: 8px; flex-shrink: 0; flex-wrap: wrap; justify-content: flex-end; }
.script-card { border-left: 4px solid var(--primary); cursor: pointer; }
.script-card.script-bash { border-left-color: var(--success); }
.script-card.script-windows { border-left-color: var(--info); }
.badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; }
.badge-enabled { background: #dcfce7; color: #166534; }
.badge-disabled { background: #f1f5f9; color: #64748b; }
.badge-bash { background: #dcfce7; color: #166534; }
.badge-windows { background: #dbeafe; color: #1e40af; }
.tag { display: inline-block; padding: 3px 8px; margin: 2px; background: #e2e8f0; border-radius: 4px; font-size: 0.75rem; color: var(--text-muted); }
.btn { padding: 8px 16px; border-radius: 7px; border: none; cursor: pointer; font-size: 0.85rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
.btn-primary { background: var(--primary); color: white; }
.btn-primary:hover { background: var(--primary-dark); }
.btn-success { background: var(--success); color: white; }
.btn-success:hover { background: #059669; }
.btn-danger { background: var(--danger); color: white; }
.btn-danger:hover { background: #dc2626; }
.btn-info { background: var(--info); color: white; }
.btn-info:hover { background: #2563eb; }
.btn-secondary { background: #e2e8f0; color: var(--text); }
.btn-secondary:hover { background: #cbd5e1; }
.btn-sm { padding: 5px 12px; font-size: 0.8rem; }
.btn-warning { background: var(--warning); color: white; }
.btn-warning:hover { background: #d97706; }
.modern-modal {
  display: none; position: fixed; z-index: 10000;
  left: 0; top: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.5); overflow: auto;
}
.modern-modal-content {
  background: white; border-radius: 12px; margin: 40px auto;
  max-width: 800px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.3); overflow: hidden;
}
.modern-modal-content.narrow { max-width: 600px; }
.modal-header-modern {
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  color: white; padding: 18px 24px; display: flex; align-items: center; justify-content: space-between;
}
.modal-header-modern h3 { margin: 0; font-size: 1.1rem; font-weight: 600; }
.modal-header-modern.green { background: linear-gradient(135deg, #059669, #047857); }
.modal-close-btn {
  background: rgba(255,255,255,0.2); border: none; color: white;
  width: 30px; height: 30px; border-radius: 50%; cursor: pointer;
  font-size: 1.1rem; display: flex; align-items: center; justify-content: center; transition: background 0.2s;
}
.modal-close-btn:hover { background: rgba(255,255,255,0.35); }
.modal-body { padding: 24px; max-height: 65vh; overflow-y: auto; }
.modal-footer-modern {
  padding: 16px 24px; border-top: 1px solid var(--border);
  display: flex; gap: 10px; justify-content: flex-end; background: #f8fafc;
}
.form-label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--text); margin-bottom: 5px; }
.form-input {
  width: 100%; padding: 9px 12px; border: 1px solid var(--border); border-radius: 7px;
  font-size: 0.9rem; color: var(--text); background: white; outline: none;
  transition: border-color 0.2s; box-sizing: border-box;
}
.form-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(77,99,111,0.1); }
.form-group { margin-bottom: 16px; }
.form-hint { font-size: 0.78rem; color: var(--text-muted); margin-top: 4px; }
.schedule-item {
  background: #f8fafc; border: 1px solid var(--border); border-radius: 8px;
  padding: 14px 16px; margin-bottom: 10px;
  display: flex; align-items: flex-start; justify-content: space-between; gap: 12px;
}
.schedule-item-info p { margin: 2px 0; font-size: 0.85rem; color: var(--text-muted); }
.schedule-item-info strong { color: var(--text); }
.schedule-item-actions { display: flex; gap: 6px; flex-shrink: 0; }
.readme-pre {
  background: #1e293b; color: #e2e8f0; border-radius: 8px; padding: 16px;
  font-size: 0.82rem; line-height: 1.6; max-height: 450px; overflow-y: auto;
  white-space: pre-wrap; font-family: monospace;
}
.back-bar {
  background: var(--primary); color: white; border-radius: 8px;
  padding: 10px 16px; margin-bottom: 12px; display: flex; align-items: center; gap: 12px;
}
.back-bar button { background: rgba(255,255,255,0.2); border: none; color: white; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 0.85rem; }
.back-bar button:hover { background: rgba(255,255,255,0.35); }
.swal2-container { z-index: 20000 !important; }
.swal2-popup { z-index: 20001 !important; }
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
.info-item { background: #f8fafc; border-radius: 8px; padding: 10px 14px; }
.info-item .info-key { font-size: 0.75rem; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
.info-item .info-val { font-size: 0.9rem; color: var(--text); margin-top: 2px; font-weight: 500; }
hr.divider { border: none; border-top: 1px solid var(--border); margin: 16px 0; }
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">
  <div class="w3-row">
    <div id="leftColumn"></div>
    <div class="w3-col m9">

      <div class="page-header">
        <div style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:12px;">
          <div>
            <h2><i class="fa fa-clock-o" style="margin-right:10px;"></i>Outliers - Scheduled Scripts</h2>
            <p>Upload and manage bash or Windows scripts for scheduled execution via cron/Task Scheduler</p>
          </div>
        </div>
        <div class="stats-row">
          <div class="stat-card">
            <div class="stat-num" id="totalScripts">0</div>
            <div class="stat-label">Total Scripts</div>
          </div>
          <div class="stat-card green">
            <div class="stat-num" id="enabledCount">0</div>
            <div class="stat-label">Enabled</div>
          </div>
          <div class="stat-card teal">
            <div class="stat-num" id="bashCount">0</div>
            <div class="stat-label">Bash Scripts</div>
          </div>
          <div class="stat-card blue">
            <div class="stat-num" id="windowsCount">0</div>
            <div class="stat-label">Windows Scripts</div>
          </div>
        </div>
      </div>

      <div class="breadcrumb-bar">
        <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
        <span>&#8250;</span>
        <span>Outliers</span>
      </div>

      <div style="margin:16px 0 12px;">
        <div class="view-toggle">
          <button class="view-toggle-btn active" id="packageViewBtn" onclick="switchView('package')">
            <i class="fa fa-folder"></i> Package View
          </button>
          <button class="view-toggle-btn" id="scriptViewBtn" onclick="switchView('script')">
            <i class="fa fa-file-code-o"></i> Script View
          </button>
        </div>
      </div>

      <div class="w3-row-padding" style="margin-bottom:16px;">
        <div class="w3-col m6">
          <div class="section-card">
            <div class="section-card-header open" onclick="toggleSectionCard(this)">
              <h5><i class="fa fa-cloud-upload"></i> Upload ZIP File</h5>
              <i class="fa fa-chevron-down chevron"></i>
            </div>
            <div class="section-card-body open">
              <div class="upload-zone" id="uploadZone" onclick="document.getElementById('fileInput').click()">
                <i class="fa fa-cloud-upload"></i>
                <p><strong>Click to upload or drag and drop</strong></p>
                <p>ZIP files containing .sh, .bash, .bat, .cmd, or .ps1 scripts</p>
              </div>
              <input type="file" id="fileInput" accept=".zip" style="display:none;" onchange="handleFileSelect(event)">
            </div>
          </div>
        </div>
        <div class="w3-col m6">
          <div class="section-card">
            <div class="section-card-header open" onclick="toggleSectionCard(this)">
              <h5><i class="fa fa-download"></i> Deploy from Library</h5>
              <i class="fa fa-chevron-down chevron"></i>
            </div>
            <div class="section-card-body open">
              <div class="upload-zone" onclick="showDeployModal()">
                <i class="fa fa-download" style="color:var(--success);"></i>
                <p><strong>Deploy pre-packaged outliers</strong></p>
                <p>Select from available outlier packages</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="section-card" style="margin-bottom:16px;">
        <div class="section-card-header open" onclick="toggleSectionCard(this)">
          <h5><i class="fa fa-search"></i> Search & Filter</h5>
          <i class="fa fa-chevron-down chevron"></i>
        </div>
        <div class="section-card-body open">
          <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search scripts by name, description, or tags..." onkeyup="searchScripts()">
            <select id="typeFilter" onchange="filterByType()" style="min-width:160px;">
              <option value="">All Types</option>
              <option value="bash">Bash Scripts</option>
              <option value="windows">Windows Scripts</option>
            </select>
          </div>
        </div>
      </div>

      <div id="scriptsList"></div>

    </div>
  </div>
</div>
<br>
<div id="footer"></div>

<script>
function toggleSectionCard(header) {
    header.classList.toggle('open');
    var body = header.nextElementSibling;
    body.classList.toggle('open');
}

$(document).ready(function() {
    $.ajax({ url: '/loggedIn/includes/navbar.ftl', method: 'GET', success: function(r) { $('#navbar').html(r); } });
    $.ajax({ url: '/loggedIn/includes/leftColumn2.ftl', method: 'GET', success: function(r) { $('#leftColumn').html(r); } });
    $.ajax({ url: '/loggedIn/includes/footer.ftl', method: 'GET', success: function(r) { $('#footer').html(r); } });
    loadStatistics();
    loadPackages();
    setupDragAndDrop();
});

let allScripts = [];
let currentScript = null;
let currentView = 'package';
let allPackages = [];

function setupDragAndDrop() {
    const uploadZone = document.getElementById('uploadZone');
    uploadZone.addEventListener('dragover', function(e) { e.preventDefault(); uploadZone.classList.add('dragover'); });
    uploadZone.addEventListener('dragleave', function(e) { e.preventDefault(); uploadZone.classList.remove('dragover'); });
    uploadZone.addEventListener('drop', function(e) {
        e.preventDefault(); uploadZone.classList.remove('dragover');
        const files = e.dataTransfer.files;
        if (files.length > 0) handleFile(files[0]);
    });
}

function handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) handleFile(file);
}

function handleFile(file) {
    if (!file.name.toLowerCase().endsWith('.zip')) {
        Swal.fire({ icon: 'error', title: 'Invalid File', text: 'Please upload a ZIP file' });
        return;
    }
    const formData = new FormData();
    formData.append('file', file);
    formData.append('uploadedBy', '${tokenObject.username!"unknown"}');
    Swal.fire({ title: 'Uploading...', html: 'Processing ZIP file...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
    $.ajax({
        url: '/api/outliers/upload', type: 'POST', data: formData, processData: false, contentType: false,
        success: function(response) {
            if (response.success) {
                let message = '<p>Added <strong>' + response.addedCount + '</strong> script(s)</p>';
                if (response.skippedCount > 0) {
                    message += '<p style="color:var(--warning)"><i class="fa fa-warning"></i> Skipped <strong>' + response.skippedCount + '</strong> duplicate(s):</p>';
                    message += '<ul style="max-height:150px;overflow-y:auto;padding-left:20px;">';
                    response.skippedDuplicates.forEach(function(name) { message += '<li>' + name + '</li>'; });
                    message += '</ul>';
                }
                message += '<p style="font-size:0.85rem;color:var(--text-muted)">Scripts are disabled by default. Enable them after reviewing.</p>';
                Swal.fire({ icon: response.skippedCount > 0 ? 'warning' : 'success', title: 'Upload Complete', html: message, width: '500px' });
                loadStatistics(); loadAllScripts();
            } else {
                Swal.fire({ icon: 'error', title: 'Upload Failed', text: response.error });
            }
        },
        error: function(err) {
            Swal.fire({ icon: 'error', title: 'Upload Failed', text: 'Error uploading file: ' + (err.responseJSON ? err.responseJSON.error : err.statusText) });
        }
    });
    document.getElementById('fileInput').value = '';
}

function loadStatistics() {
    $.ajax({
        url: '/api/outliers/stats', method: 'GET',
        success: function(response) {
            if (response.success) {
                $('#totalScripts').text(response.totalScripts);
                $('#enabledCount').text(response.enabledScripts);
                $('#bashCount').text(response.scriptsByType.bash || 0);
                $('#windowsCount').text(response.scriptsByType.windows || 0);
            }
        }
    });
}

function loadAllScripts() {
    $.ajax({
        url: '/api/outliers/scripts', method: 'GET',
        success: function(response) {
            if (response.success) { allScripts = response.scripts; displayScripts(allScripts); }
        },
        error: function() { $('#scriptsList').html('<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:8px;padding:16px;color:#dc2626;"><i class="fa fa-exclamation-circle"></i> Error loading scripts</div>'); }
    });
}

function switchView(view) {
    currentView = view;
    if (view === 'package') {
        $('#packageViewBtn').addClass('active'); $('#scriptViewBtn').removeClass('active');
        loadPackages();
    } else {
        $('#scriptViewBtn').addClass('active'); $('#packageViewBtn').removeClass('active');
        loadAllScripts();
    }
}

function loadPackages() {
    $.ajax({
        url: '/api/outliers/packages', method: 'GET',
        success: function(response) {
            if (response.success) { allPackages = response.packages; displayPackages(allPackages); }
        },
        error: function() { $('#scriptsList').html('<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:8px;padding:16px;color:#dc2626;"><i class="fa fa-exclamation-circle"></i> Error loading packages</div>'); }
    });
}

function displayPackages(packages) {
    const container = $('#scriptsList');
    container.empty();
    if (packages.length === 0) {
        container.html('<div style="background:#fffbeb;border:1px solid #fcd34d;border-radius:8px;padding:20px;text-align:center;"><i class="fa fa-info-circle" style="color:var(--warning);font-size:24px;"></i><p style="margin:8px 0 0;color:var(--text-muted);">No packages found. Upload a ZIP file or deploy from library to get started.</p></div>');
        return;
    }
    packages.forEach(function(pkg) {
        const allEnabled = pkg.allEnabled;
        const hasReadme = pkg.scripts && pkg.scripts.some(s => s.readmeContent);
        const card = $('<div class="pkg-card">').html(
            '<div class="pkg-card-body">' +
                '<div class="pkg-card-info">' +
                    '<h5><i class="fa fa-folder-open" style="color:var(--primary);margin-right:8px;"></i>' + pkg.packageName + '</h5>' +
                    '<p>' + pkg.scriptCount + ' script(s) &bull; ' + pkg.enabledCount + ' enabled</p>' +
                '</div>' +
                '<div class="pkg-card-actions">' +
                    (hasReadme ? '<button class="btn btn-secondary btn-sm" onclick="showPackageReadme(\'' + pkg.packageId + '\', event)"><i class="fa fa-file-text-o"></i> README</button>' : '') +
                    '<button class="btn btn-sm ' + (allEnabled ? 'btn-success' : 'btn-secondary') + '" onclick="togglePackage(\'' + pkg.packageId + '\', event)">' +
                        '<i class="fa fa-power-off"></i> ' + (allEnabled ? 'Disable All' : 'Enable All') +
                    '</button>' +
                    '<button class="btn btn-info btn-sm" onclick="viewPackageScripts(\'' + pkg.packageId + '\')"><i class="fa fa-eye"></i> View Scripts</button>' +
                    '<button class="btn btn-danger btn-sm" onclick="undeployPackage(\'' + pkg.packageId + '\', event)"><i class="fa fa-trash"></i> Undeploy</button>' +
                '</div>' +
            '</div>'
        );
        container.append(card);
    });
}

function togglePackage(packageId, event) {
    event.stopPropagation();
    Swal.fire({ title: 'Toggle Package', text: 'This will enable/disable all scripts in this package', icon: 'question', showCancelButton: true, confirmButtonText: 'Yes, toggle it' }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/outliers/packages/' + packageId + '/toggle', method: 'POST',
                success: function(response) {
                    if (response.success) { Swal.fire({ icon: 'success', title: 'Success', text: response.message, timer: 2000 }); loadPackages(); loadStatistics(); }
                    else { Swal.fire({ icon: 'error', title: 'Error', text: response.error || 'Failed to toggle package' }); }
                },
                error: function(err) { Swal.fire({ icon: 'error', title: 'Error', text: 'Error toggling package: ' + (err.responseJSON ? err.responseJSON.error : err.statusText) }); }
            });
        }
    });
}

function viewPackageScripts(packageId) {
    const pkg = allPackages.find(p => p.packageId === packageId);
    if (!pkg) return;
    displayScripts(pkg.scripts);
    const backBar = $('<div class="back-bar"><button onclick="loadPackages()"><i class="fa fa-arrow-left"></i> Back to Packages</button><span><i class="fa fa-folder"></i> ' + pkg.packageName + '</span></div>');
    $('#scriptsList').prepend(backBar);
}

function showPackageReadme(packageId, event) {
    event.stopPropagation();
    const pkg = allPackages.find(p => p.packageId === packageId);
    if (!pkg) return;
    const scriptWithReadme = pkg.scripts.find(s => s.readmeContent);
    if (scriptWithReadme) {
        document.getElementById('packageReadmeModalTitle').innerHTML = '<i class="fa fa-file-text-o"></i> ' + pkg.packageName + ' - README';
        document.getElementById('packageReadmeContent').textContent = scriptWithReadme.readmeContent;
        document.getElementById('packageReadmeModal').style.display = 'block';
    } else {
        Swal.fire({ icon: 'info', title: 'No README', text: 'This package does not contain a README file' });
    }
}

function displayScripts(scripts) {
    const container = $('#scriptsList');
    container.empty();
    if (scripts.length === 0) {
        container.html('<div style="background:#fffbeb;border:1px solid #fcd34d;border-radius:8px;padding:20px;text-align:center;"><i class="fa fa-info-circle" style="color:var(--warning);font-size:24px;"></i><p style="margin:8px 0 0;color:var(--text-muted);">No scripts found. Upload a ZIP file to get started.</p></div>');
        return;
    }
    scripts.forEach(function(script) {
        const scheduleCount = script.schedules ? script.schedules.length : 0;
        const enabledSchedules = script.schedules ? script.schedules.filter(s => s.enabled).length : 0;
        const scheduleText = scheduleCount === 0 ? 'No schedules' : scheduleCount + ' schedule(s) (' + enabledSchedules + ' enabled)';
        const card = $('<div class="pkg-card script-card script-' + script.scriptType + '">').attr('onclick', "showScriptDetails('" + script.id + "')").html(
            '<div class="pkg-card-body">' +
                '<div class="pkg-card-info">' +
                    '<h5><i class="fa fa-file-code-o" style="margin-right:8px;"></i>' + script.name + '</h5>' +
                    '<p>' + script.description + '</p>' +
                    '<p><i class="fa fa-clock-o"></i> ' + scheduleText + '</p>' +
                '</div>' +
                '<div style="text-align:right;flex-shrink:0;">' +
                    '<span class="badge badge-' + script.scriptType + '">' + script.scriptType.toUpperCase() + '</span><br>' +
                    '<span class="badge badge-' + (script.enabled ? 'enabled' : 'disabled') + '" style="margin-top:6px;">' + (script.enabled ? 'ENABLED' : 'DISABLED') + '</span>' +
                    '<p style="font-size:0.78rem;color:var(--text-muted);margin-top:6px;">' + formatFileSize(script.fileSize) + '</p>' +
                '</div>' +
            '</div>'
        );
        container.append(card);
    });
}

function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' B';
    else if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
    else return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
}

function showScriptDetails(scriptId) {
    $.ajax({
        url: '/api/outliers/scripts/' + scriptId, method: 'GET',
        success: function(response) {
            if (response.success) { currentScript = response.script; displayScriptDetails(currentScript); document.getElementById('scriptModal').style.display = 'block'; }
        }
    });
}

function displayScriptDetails(script) {
    document.getElementById('modalTitle').innerHTML = '<i class="fa fa-file-code-o"></i> ' + script.name;
    let content = '<div class="info-grid">' +
        '<div class="info-item"><div class="info-key">ID</div><div class="info-val">' + script.id + '</div></div>' +
        '<div class="info-item"><div class="info-key">Type</div><div class="info-val"><span class="badge badge-' + script.scriptType + '">' + script.scriptType.toUpperCase() + '</span></div></div>' +
        '<div class="info-item"><div class="info-key">Status</div><div class="info-val"><span class="badge badge-' + (script.enabled ? 'enabled' : 'disabled') + '">' + (script.enabled ? 'ENABLED' : 'DISABLED') + '</span></div></div>' +
        '<div class="info-item"><div class="info-key">File Size</div><div class="info-val">' + formatFileSize(script.fileSize) + '</div></div>' +
        '<div class="info-item"><div class="info-key">Uploaded</div><div class="info-val">' + new Date(script.uploadedAt).toLocaleString() + '</div></div>' +
        '<div class="info-item"><div class="info-key">Uploaded By</div><div class="info-val">' + script.uploadedBy + '</div></div>' +
        '</div>' +
        '<hr class="divider"><p style="font-size:0.85rem;color:var(--text-muted);">' + script.description + '</p>' +
        '<hr class="divider"><div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;">' +
            '<strong>Schedules</strong>' +
            '<button class="btn btn-success btn-sm" onclick="showAddScheduleModal()"><i class="fa fa-plus"></i> Add Schedule</button>' +
        '</div>' +
        '<div id="schedules-list"></div>' +
        '<hr class="divider"><p style="font-size:0.78rem;color:var(--text-muted);">' + script.filePath + '</p>' +
        (script.folderPath ? '<p style="font-size:0.82rem;"><strong>Folder:</strong> ' + script.folderPath + '</p>' : '') +
        '<hr class="divider"><strong>Last Execution</strong><p style="font-size:0.85rem;margin-top:6px;">' + (script.lastExecuted ? new Date(script.lastExecuted).toLocaleString() : 'Never executed') + '</p>' +
        '<p style="font-size:0.82rem;color:var(--text-muted);">' + script.lastExecutionStatus + '</p>' +
        '<hr class="divider"><strong>Tags</strong><p id="script-tags-list" style="margin-top:8px;"></p>' +
        (script.relatedFiles && script.relatedFiles.length > 0 ? '<hr class="divider"><strong>Related Files</strong><p id="related-files-list" style="margin-top:8px;"></p>' : '') +
        (script.readmeContent ? '<hr class="divider"><strong>README</strong><pre class="readme-pre" style="margin-top:8px;">' + script.readmeContent + '</pre>' : '');
    document.getElementById('modalContent').innerHTML = content;
    if (script.tags && script.tags.length > 0) {
        script.tags.forEach(function(tag) { $('#script-tags-list').append('<span class="tag">' + tag + '</span>'); });
    } else { $('#script-tags-list').html('<span style="color:var(--text-muted);">No tags</span>'); }
    if (script.relatedFiles && script.relatedFiles.length > 0) {
        script.relatedFiles.forEach(function(file) {
            var icon = file.endsWith('.sql') ? 'fa-database' : (file.endsWith('.txt') || file.endsWith('.md') ? 'fa-file-text-o' : 'fa-file-o');
            $('#related-files-list').append('<span class="tag"><i class="fa ' + icon + '"></i> ' + file + '</span>');
        });
    }
    displaySchedules(script.schedules || []);
}

function displaySchedules(schedules) {
    const list = $('#schedules-list');
    list.empty();
    if (!schedules || schedules.length === 0) {
        list.html('<p style="color:var(--text-muted);font-size:0.85rem;">No schedules configured. Click "Add Schedule" to create one.</p>');
        return;
    }
    schedules.forEach(function(schedule) {
        const item = $('<div class="schedule-item">').html(
            '<div class="schedule-item-info">' +
                '<strong>' + (schedule.description || 'Schedule') + '</strong>' +
                '<p><i class="fa fa-clock-o"></i> <strong>Cron:</strong> ' + schedule.cronExpression + '</p>' +
                '<p><i class="fa fa-terminal"></i> <strong>Params:</strong> ' + (schedule.parameters || 'None') + '</p>' +
                '<p><span class="badge badge-' + (schedule.enabled ? 'enabled' : 'disabled') + '">' + (schedule.enabled ? 'ENABLED' : 'DISABLED') + '</span></p>' +
            '</div>' +
            '<div class="schedule-item-actions">' +
                '<button class="btn btn-info btn-sm" onclick="editSchedule(\'' + schedule.scheduleId + '\')"><i class="fa fa-edit"></i></button>' +
                '<button class="btn btn-success btn-sm" onclick="toggleSchedule(\'' + schedule.scheduleId + '\')"><i class="fa fa-toggle-on"></i></button>' +
                '<button class="btn btn-danger btn-sm" onclick="deleteSchedule(\'' + schedule.scheduleId + '\')"><i class="fa fa-trash"></i></button>' +
            '</div>'
        );
        list.append(item);
    });
}

function showAddScheduleModal() {
    if (!currentScript) return;
    document.getElementById('scheduleModalTitle').textContent = 'Add Schedule';
    document.getElementById('scheduleScriptId').value = currentScript.id;
    document.getElementById('scheduleId').value = '';
    document.getElementById('scheduleDescription').value = '';
    document.getElementById('scheduleCron').value = '';
    document.getElementById('scheduleParameters').value = '';
    document.getElementById('scheduleEnabled').checked = true;
    document.getElementById('scheduleModal').style.display = 'block';
}

function editSchedule(scheduleId) {
    if (!currentScript) return;
    const schedule = currentScript.schedules.find(s => s.scheduleId === scheduleId);
    if (!schedule) { Swal.fire('Error', 'Schedule not found', 'error'); return; }
    document.getElementById('scheduleModalTitle').textContent = 'Edit Schedule';
    document.getElementById('scheduleScriptId').value = currentScript.id;
    document.getElementById('scheduleId').value = schedule.scheduleId;
    document.getElementById('scheduleDescription').value = schedule.description || '';
    document.getElementById('scheduleCron').value = schedule.cronExpression;
    document.getElementById('scheduleParameters').value = schedule.parameters || '';
    document.getElementById('scheduleEnabled').checked = schedule.enabled;
    document.getElementById('scheduleModal').style.display = 'block';
}

function saveSchedule() {
    const scriptId = document.getElementById('scheduleScriptId').value;
    const scheduleId = document.getElementById('scheduleId').value;
    const cronExpression = document.getElementById('scheduleCron').value.trim();
    if (!cronExpression) { Swal.fire('Error', 'Cron expression is required', 'error'); return; }
    const scheduleData = {
        description: document.getElementById('scheduleDescription').value.trim(),
        cronExpression: cronExpression,
        parameters: document.getElementById('scheduleParameters').value.trim(),
        enabled: document.getElementById('scheduleEnabled').checked
    };
    const isUpdate = scheduleId !== '';
    const url = isUpdate ? '/api/outliers/scripts/' + scriptId + '/schedules/' + scheduleId : '/api/outliers/scripts/' + scriptId + '/schedules';
    $.ajax({
        url: url, method: isUpdate ? 'PUT' : 'POST', contentType: 'application/json', data: JSON.stringify(scheduleData),
        success: function() {
            Swal.fire('Success', isUpdate ? 'Schedule updated' : 'Schedule added', 'success');
            document.getElementById('scheduleModal').style.display = 'none';
            loadAllScripts();
            if (currentScript) setTimeout(function() { showScriptDetails(scriptId); }, 500);
        },
        error: function(xhr) { Swal.fire('Error', 'Failed to save schedule: ' + (xhr.responseText || 'Unknown error'), 'error'); }
    });
}

function deleteSchedule(scheduleId) {
    if (!currentScript) return;
    Swal.fire({ title: 'Delete Schedule?', text: 'This will remove the schedule. This action cannot be undone.', icon: 'warning', showCancelButton: true, confirmButtonColor: '#ef4444', confirmButtonText: 'Yes, delete it!' }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/outliers/scripts/' + currentScript.id + '/schedules/' + scheduleId, method: 'DELETE',
                success: function() { Swal.fire('Deleted!', 'Schedule has been deleted', 'success'); loadAllScripts(); if (currentScript) setTimeout(function() { showScriptDetails(currentScript.id); }, 500); },
                error: function(xhr) { Swal.fire('Error', 'Failed to delete schedule: ' + (xhr.responseText || 'Unknown error'), 'error'); }
            });
        }
    });
}

function toggleSchedule(scheduleId) {
    if (!currentScript) return;
    $.ajax({
        url: '/api/outliers/scripts/' + currentScript.id + '/schedules/' + scheduleId + '/toggle', method: 'POST',
        success: function() { Swal.fire('Success', 'Schedule status toggled', 'success'); loadAllScripts(); if (currentScript) setTimeout(function() { showScriptDetails(currentScript.id); }, 500); },
        error: function(xhr) { Swal.fire('Error', 'Failed to toggle schedule: ' + (xhr.responseText || 'Unknown error'), 'error'); }
    });
}

function toggleScriptStatus() {
    if (!currentScript) return;
    $.ajax({
        url: '/api/outliers/scripts/' + currentScript.id + '/toggle', type: 'POST',
        success: function(response) {
            if (response.success) {
                Swal.fire({ icon: 'success', title: 'Status Updated', text: 'Script is now ' + (response.enabled ? 'enabled' : 'disabled'), timer: 2000 });
                loadStatistics(); loadAllScripts(); document.getElementById('scriptModal').style.display = 'none';
            }
        },
        error: function() { Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to toggle script status' }); }
    });
}

function editScript() {
    if (!currentScript) return;
    document.getElementById('editName').value = currentScript.name;
    document.getElementById('editDescription').value = currentScript.description;
    document.getElementById('editCron').value = currentScript.cronExpression;
    document.getElementById('editParameters').value = currentScript.parameters || '';
    document.getElementById('editTags').value = currentScript.tags.join(', ');
    document.getElementById('editEnabled').checked = currentScript.enabled;
    document.getElementById('scriptModal').style.display = 'none';
    document.getElementById('editModal').style.display = 'block';
}

function saveScript() {
    if (!currentScript) return;
    const tags = document.getElementById('editTags').value.split(',').map(t => t.trim()).filter(t => t.length > 0);
    const updateData = {
        name: document.getElementById('editName').value,
        description: document.getElementById('editDescription').value,
        cronExpression: document.getElementById('editCron').value,
        parameters: document.getElementById('editParameters').value,
        enabled: document.getElementById('editEnabled').checked,
        tags: tags
    };
    $.ajax({
        url: '/api/outliers/scripts/' + currentScript.id, type: 'PUT', contentType: 'application/json', data: JSON.stringify(updateData),
        success: function(response) {
            if (response.success) { Swal.fire({ icon: 'success', title: 'Saved', text: 'Script updated successfully', timer: 2000 }); loadStatistics(); loadAllScripts(); document.getElementById('editModal').style.display = 'none'; }
        },
        error: function() { Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to update script' }); }
    });
}

function deleteScript() {
    if (!currentScript) return;
    Swal.fire({ title: 'Delete Script?', text: 'This will permanently delete the script file. This action cannot be undone.', icon: 'warning', showCancelButton: true, confirmButtonColor: '#ef4444', confirmButtonText: 'Yes, delete it!' }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/outliers/scripts/' + currentScript.id, type: 'DELETE',
                success: function(response) {
                    if (response.success) { Swal.fire({ icon: 'success', title: 'Deleted', text: 'Script deleted successfully', timer: 2000 }); loadStatistics(); loadAllScripts(); document.getElementById('scriptModal').style.display = 'none'; }
                },
                error: function() { Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to delete script' }); }
            });
        }
    });
}

function searchScripts() {
    const query = $('#searchInput').val();
    if (query.length < 2) { displayScripts(allScripts); return; }
    $.ajax({
        url: '/api/outliers/search?q=' + encodeURIComponent(query), method: 'GET',
        success: function(response) { if (response.success) displayScripts(response.scripts); }
    });
}

function filterByType() {
    const type = $('#typeFilter').val();
    if (type === '') { displayScripts(allScripts); return; }
    $.ajax({
        url: '/api/outliers/type/' + type + '/scripts', method: 'GET',
        success: function(response) { if (response.success) displayScripts(response.scripts); }
    });
}

function showDeployModal() {
    const modal = document.getElementById('deployModal');
    if (modal.parentElement !== document.body) document.body.appendChild(modal);
    modal.style.display = 'block';
    loadAvailableOutliers();
}

function loadAvailableOutliers() {
    $.ajax({
        url: '/api/outliers/available', method: 'GET',
        success: function(response) { displayAvailableOutliers(response.outliers); },
        error: function(err) {
            $('#availableOutliersList').html('<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:8px;padding:16px;color:#dc2626;"><i class="fa fa-exclamation-triangle"></i> Error loading outliers: ' + (err.responseJSON ? err.responseJSON.error : 'Unknown error') + '</div>');
        }
    });
}

function displayAvailableOutliers(outliers) {
    const container = $('#availableOutliersList');
    if (!outliers || outliers.length === 0) {
        container.html('<div style="background:#fffbeb;border:1px solid #fcd34d;border-radius:8px;padding:20px;text-align:center;"><i class="fa fa-info-circle" style="color:var(--warning);font-size:24px;"></i><p style="margin:8px 0 0;color:var(--text-muted);">No outliers found in the outliers directory.</p><p style="font-size:0.82rem;color:var(--text-muted);">Place ZIP files in the <code>outliers/</code> directory to deploy them.</p></div>');
        return;
    }
    let html = '';
    outliers.forEach(function(outlier) {
        html += '<div class="pkg-card" style="margin-bottom:10px;">' +
            '<div class="pkg-card-body">' +
                '<div class="pkg-card-info">' +
                    '<h5><i class="fa fa-file-archive-o" style="margin-right:8px;"></i>' + outlier.displayName + '</h5>' +
                    '<p><i class="fa fa-hdd-o"></i> ' + outlier.fileSizeMB + ' MB &bull; <i class="fa fa-clock-o"></i> ' + new Date(outlier.lastModified).toLocaleString() + '</p>' +
                '</div>' +
                '<button class="btn btn-success" onclick="deployOutlier(\'' + outlier.fileName + '\')"><i class="fa fa-download"></i> Deploy</button>' +
            '</div>' +
        '</div>';
    });
    container.html(html);
}

function deployOutlier(fileName) {
    Swal.fire({ title: 'Deploy Outlier?', text: 'Deploy ' + fileName + ' to the system?', icon: 'question', showCancelButton: true, confirmButtonText: 'Yes, deploy it!' }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({ title: 'Deploying...', text: 'Please wait...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
            $.ajax({
                url: '/api/outliers/deploy', method: 'POST', contentType: 'application/json',
                data: JSON.stringify({ fileName: fileName, deployedBy: 'admin' }),
                success: function(response) {
                    let message = response.message;
                    if (response.addedCount > 0) message += '<br><strong>' + response.addedCount + '</strong> script(s) deployed';
                    if (response.skippedCount > 0) message += '<br><strong>' + response.skippedCount + '</strong> duplicate(s) skipped';
                    Swal.fire({ title: 'Success!', html: message, icon: 'success' }).then(() => {
                        document.getElementById('deployModal').style.display = 'none';
                        loadStatistics();
                        if (currentView === 'package') loadPackages(); else loadAllScripts();
                    });
                },
                error: function(err) { Swal.fire({ title: 'Error!', text: 'Failed to deploy: ' + (err.responseJSON ? err.responseJSON.error : 'Unknown error'), icon: 'error' }); }
            });
        }
    });
}

function undeployPackage(packageId, event) {
    event.stopPropagation();
    const pkg = allPackages.find(p => p.packageId === packageId);
    if (!pkg) { Swal.fire({ icon: 'error', title: 'Error', text: 'Package not found' }); return; }
    Swal.fire({
        title: 'Undeploy Package?',
        html: '<p>This will permanently delete <strong>' + pkg.packageName + '</strong> and all its scripts (' + pkg.scriptCount + ').</p><p style="color:#ef4444;"><i class="fa fa-warning"></i> This action cannot be undone!</p>',
        icon: 'warning', showCancelButton: true, confirmButtonText: 'Yes, undeploy it!', confirmButtonColor: '#ef4444'
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({ title: 'Undeploying...', text: 'Removing package...', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
            $.ajax({
                url: '/api/outliers/packages/' + packageId, method: 'DELETE',
                success: function(response) {
                    if (response.success) { Swal.fire({ icon: 'success', title: 'Undeployed!', text: response.message || 'Package removed', timer: 2000 }).then(() => { loadStatistics(); loadPackages(); }); }
                    else { Swal.fire({ icon: 'error', title: 'Error', text: response.error || 'Failed to undeploy' }); }
                },
                error: function(err) { Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to undeploy: ' + (err.responseJSON ? err.responseJSON.error : 'Unknown error') }); }
            });
        }
    });
}

window.onclick = function(event) {
    ['scriptModal','editModal','scheduleModal','deployModal','packageReadmeModal'].forEach(function(id) {
        const m = document.getElementById(id);
        if (m && event.target == m) m.style.display = 'none';
    });
};
</script>

<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>

<!-- Script Detail Modal -->
<div id="scriptModal" class="modern-modal">
  <div class="modern-modal-content">
    <div class="modal-header-modern">
      <h3 id="modalTitle"><i class="fa fa-file-code-o"></i> Script Details</h3>
      <button class="modal-close-btn" onclick="document.getElementById('scriptModal').style.display='none'">&times;</button>
    </div>
    <div class="modal-body" id="modalContent"></div>
    <div class="modal-footer-modern">
      <button class="btn btn-success" onclick="toggleScriptStatus()"><i class="fa fa-toggle-on"></i> Toggle Enable/Disable</button>
      <button class="btn btn-info" onclick="editScript()"><i class="fa fa-edit"></i> Edit</button>
      <button class="btn btn-danger" onclick="deleteScript()"><i class="fa fa-trash"></i> Delete</button>
      <button class="btn btn-secondary" onclick="document.getElementById('scriptModal').style.display='none'">Close</button>
    </div>
  </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="modern-modal">
  <div class="modern-modal-content narrow">
    <div class="modal-header-modern">
      <h3><i class="fa fa-edit"></i> Edit Script</h3>
      <button class="modal-close-btn" onclick="document.getElementById('editModal').style.display='none'">&times;</button>
    </div>
    <div class="modal-body">
      <div class="form-group">
        <label class="form-label">Name</label>
        <input type="text" id="editName" class="form-input">
      </div>
      <div class="form-group">
        <label class="form-label">Description</label>
        <textarea id="editDescription" class="form-input" rows="3"></textarea>
      </div>
      <div class="form-group">
        <label class="form-label">Cron Expression</label>
        <input type="text" id="editCron" class="form-input" placeholder="e.g., 0 2 * * * (daily at 2 AM)">
        <div class="form-hint">Use standard cron format for Linux or Task Scheduler format for Windows</div>
      </div>
      <div class="form-group">
        <label class="form-label">Parameters</label>
        <input type="text" id="editParameters" class="form-input" placeholder="e.g., --verbose --output=/tmp/log.txt">
        <div class="form-hint">Command-line parameters to pass to the script</div>
      </div>
      <div class="form-group">
        <label class="form-label">Tags (comma-separated)</label>
        <input type="text" id="editTags" class="form-input" placeholder="e.g., backup, maintenance, daily">
      </div>
      <div class="form-group">
        <label style="display:flex;align-items:center;gap:8px;cursor:pointer;">
          <input type="checkbox" id="editEnabled" style="width:16px;height:16px;">
          <span class="form-label" style="margin:0;">Enabled</span>
        </label>
      </div>
    </div>
    <div class="modal-footer-modern">
      <button class="btn btn-success" onclick="saveScript()"><i class="fa fa-save"></i> Save Changes</button>
      <button class="btn btn-secondary" onclick="document.getElementById('editModal').style.display='none'">Cancel</button>
    </div>
  </div>
</div>

<!-- Schedule Modal -->
<div id="scheduleModal" class="modern-modal">
  <div class="modern-modal-content narrow">
    <div class="modal-header-modern">
      <h3 id="scheduleModalTitle"><i class="fa fa-clock-o"></i> Add Schedule</h3>
      <button class="modal-close-btn" onclick="document.getElementById('scheduleModal').style.display='none'">&times;</button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="scheduleScriptId">
      <input type="hidden" id="scheduleId">
      <div class="form-group">
        <label class="form-label">Description</label>
        <input class="form-input" type="text" id="scheduleDescription" placeholder="e.g., Daily backup at midnight">
      </div>
      <div class="form-group">
        <label class="form-label">Cron Expression</label>
        <input class="form-input" type="text" id="scheduleCron" placeholder="e.g., 0 0 * * *">
        <div class="form-hint">Format: minute hour day month weekday &bull; Examples: "0 0 * * *" (daily midnight), "*/15 * * * *" (every 15 min)</div>
      </div>
      <div class="form-group">
        <label class="form-label">Parameters (Optional)</label>
        <textarea class="form-input" id="scheduleParameters" rows="3" placeholder="Script parameters, one per line"></textarea>
      </div>
      <div class="form-group">
        <label style="display:flex;align-items:center;gap:8px;cursor:pointer;">
          <input type="checkbox" id="scheduleEnabled" checked style="width:16px;height:16px;">
          <span class="form-label" style="margin:0;">Enabled</span>
        </label>
      </div>
    </div>
    <div class="modal-footer-modern">
      <button class="btn btn-primary" onclick="saveSchedule()"><i class="fa fa-save"></i> Save Schedule</button>
      <button class="btn btn-secondary" onclick="document.getElementById('scheduleModal').style.display='none'">Cancel</button>
    </div>
  </div>
</div>

<!-- Deploy Modal -->
<div id="deployModal" class="modern-modal">
  <div class="modern-modal-content narrow">
    <div class="modal-header-modern green">
      <h3><i class="fa fa-download"></i> Deploy Outlier from Library</h3>
      <button class="modal-close-btn" onclick="document.getElementById('deployModal').style.display='none'">&times;</button>
    </div>
    <div class="modal-body">
      <p style="color:var(--text-muted);margin-bottom:16px;">Select an outlier package to deploy to the system:</p>
      <div id="availableOutliersList">
        <div style="text-align:center;padding:20px;color:var(--text-muted);">
          <i class="fa fa-spinner fa-spin" style="font-size:24px;"></i>
          <p>Loading available outliers...</p>
        </div>
      </div>
    </div>
    <div class="modal-footer-modern">
      <button class="btn btn-secondary" onclick="document.getElementById('deployModal').style.display='none'">Close</button>
    </div>
  </div>
</div>

<!-- Package README Modal -->
<div id="packageReadmeModal" class="modern-modal">
  <div class="modern-modal-content">
    <div class="modal-header-modern">
      <h3 id="packageReadmeModalTitle"><i class="fa fa-file-text-o"></i> Package README</h3>
      <button class="modal-close-btn" onclick="document.getElementById('packageReadmeModal').style.display='none'">&times;</button>
    </div>
    <div class="modal-body">
      <pre id="packageReadmeContent" class="readme-pre"></pre>
    </div>
    <div class="modal-footer-modern">
      <button class="btn btn-secondary" onclick="document.getElementById('packageReadmeModal').style.display='none'">Close</button>
    </div>
  </div>
</div>

</body>
</html>
