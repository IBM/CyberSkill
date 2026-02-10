<!DOCTYPE html>
<html>
<head>
<title>Outliers - Scheduled Scripts</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<script src="js/jquery.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Open Sans", sans-serif}
.script-card {
    cursor: pointer;
    transition: all 0.3s;
}
.script-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}
.script-bash { border-left: 4px solid #4CAF50; }
.script-windows { border-left: 4px solid #2196F3; }
.badge-enabled { background-color: #4CAF50; color: white; }
.badge-disabled { background-color: #9E9E9E; color: white; }
.badge-bash { background-color: #4CAF50; color: white; }
.badge-windows { background-color: #2196F3; color: white; }
.tag {
    display: inline-block;
    padding: 3px 8px;
    margin: 2px;
    background-color: #e0e0e0;
    border-radius: 3px;
    font-size: 11px;
}
.upload-zone {
    border: 2px dashed #ccc;
    border-radius: 5px;
    padding: 30px;
    text-align: center;
    cursor: pointer;
    transition: all 0.3s;
}
.upload-zone:hover {
    border-color: #2196F3;
    background-color: #f5f5f5;
}
.upload-zone.dragover {
    border-color: #4CAF50;
    background-color: #e8f5e9;
}
/* Ensure modal displays on top */
.w3-modal {
    z-index: 10000 !important;
    display: none;
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
}
.w3-modal-content {
    margin: 5% auto;
    position: relative;
}
/* Ensure SweetAlert2 appears on top of everything */
.swal2-container {
    z-index: 20000 !important;
}
.swal2-popup {
    z-index: 20001 !important;
}
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
    
      <!-- Header Card -->
      <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h4><i class="fa fa-clock-o w3-margin-right"></i>Outliers - Scheduled Scripts</h4>
              <p>Upload and manage bash or Windows scripts for scheduled execution via cron/Task Scheduler</p>
              
              <!-- Statistics -->
              <div class="w3-row-padding" style="margin-top: 10px;">
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-theme-l4">
                    <h3 id="totalScripts">0</h3>
                    <p>Total Scripts</p>
                  </div>
                </div>
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-green">
                    <h3 id="enabledCount" style="color: white;">0</h3>
                    <p style="color: white;">Enabled</p>
                  </div>
                </div>
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-light-green">
                    <h3 id="bashCount" style="color: white;">0</h3>
                    <p style="color: white;">Bash Scripts</p>
                  </div>
                </div>
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-blue">
                    <h3 id="windowsCount" style="color: white;">0</h3>
                    <p style="color: white;">Windows Scripts</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      
      <!-- View Toggle -->
      <div class="w3-row-padding" style="margin-top: 16px;">
        <div class="w3-col m12">
          <div class="w3-bar w3-white w3-round w3-card">
            <button class="w3-bar-item w3-button w3-blue" id="packageViewBtn" onclick="switchView('package')">
              <i class="fa fa-folder"></i> Package View
            </button>
            <button class="w3-bar-item w3-button" id="scriptViewBtn" onclick="switchView('script')">
              <i class="fa fa-file"></i> Script View
            </button>
          </div>
        </div>
      </div>
      </div>
      
      <!-- Upload Section -->
      <div class="w3-row-padding" style="margin-top: 16px;">
        <div class="w3-col m6">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Upload ZIP File</h6>
              <div class="upload-zone" id="uploadZone" onclick="document.getElementById('fileInput').click()">
                <i class="fa fa-cloud-upload" style="font-size: 48px; color: #2196F3;"></i>
                <p><strong>Click to upload or drag and drop</strong></p>
                <p class="w3-small w3-opacity">ZIP files containing .sh, .bash, .bat, .cmd, or .ps1 scripts</p>
              </div>
              <input type="file" id="fileInput" accept=".zip" style="display: none;" onchange="handleFileSelect(event)">
            </div>
          </div>
        </div>
        <div class="w3-col m6">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Deploy from Library</h6>
              <div class="upload-zone" onclick="showDeployModal()">
                <i class="fa fa-download" style="font-size: 48px; color: #4CAF50;"></i>
                <p><strong>Deploy pre-packaged outliers</strong></p>
                <p class="w3-small w3-opacity">Select from available outlier packages</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Search and Filter -->
      <div class="w3-row-padding" style="margin-top: 16px;">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Search & Filter</h6>
              <div class="w3-row">
                <div class="w3-col s8">
                  <input type="text" id="searchInput" class="w3-input w3-border" placeholder="Search scripts by name, description, or tags..." onkeyup="searchScripts()">
                </div>
                <div class="w3-col s4" style="padding-left: 10px;">
                  <select id="typeFilter" class="w3-select w3-border" onchange="filterByType()">
                    <option value="">All Types</option>
                    <option value="bash">Bash Scripts</option>
                    <option value="windows">Windows Scripts</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Scripts List -->
      <div id="scriptsList" style="margin-top: 16px;">
        <!-- Scripts will be loaded here -->
      </div>
      
      
    <!-- End Middle Column -->
    </div>
    
  <!-- End Grid -->
  </div>
 
<!-- End Page Container -->
</div>
<br>

<!-- Footer -->
<div id="footer"></div>
 
<script>
// Load navbar, left column, and footer
$(document).ready(function() {
    $.ajax({
        url: '/loggedIn/includes/navbar.ftl',
        method: 'GET',
        success: function(response) {
            $('#navbar').html(response);
        },
        error: function(err) {
            console.error('Error loading navbar:', err);
        }
    });
    
    $.ajax({
        url: '/loggedIn/includes/leftColumn2.ftl',
        method: 'GET',
        success: function(response) {
            $('#leftColumn').html(response);
        },
        error: function(err) {
            console.error('Error loading left column:', err);
        }
    });
    
    $.ajax({
        url: '/loggedIn/includes/footer.ftl',
        method: 'GET',
        success: function(response) {
            $('#footer').html(response);
        },
        error: function(err) {
            console.error('Error loading footer:', err);
        }
    });
    
    // Load scripts data
    loadStatistics();
    loadPackages(); // Start with package view
    
    // Setup drag and drop
    setupDragAndDrop();
});

let allScripts = [];
let currentScript = null;
let currentView = 'package'; // 'package' or 'script'
let allPackages = [];

// Setup drag and drop
function setupDragAndDrop() {
    const uploadZone = document.getElementById('uploadZone');
    
    uploadZone.addEventListener('dragover', function(e) {
        e.preventDefault();
        uploadZone.classList.add('dragover');
    });
    
    uploadZone.addEventListener('dragleave', function(e) {
        e.preventDefault();
        uploadZone.classList.remove('dragover');
    });
    
    uploadZone.addEventListener('drop', function(e) {
        e.preventDefault();
        uploadZone.classList.remove('dragover');
        
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleFile(files[0]);
        }
    });
}

// Handle file selection
function handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
        handleFile(file);
    }
}

// Handle file upload
function handleFile(file) {
    if (!file.name.toLowerCase().endsWith('.zip')) {
        Swal.fire({
            icon: 'error',
            title: 'Invalid File',
            text: 'Please upload a ZIP file'
        });
        return;
    }
    
    const formData = new FormData();
    formData.append('file', file);
    formData.append('uploadedBy', '${tokenObject.username!"unknown"}');
    
    Swal.fire({
        title: 'Uploading...',
        html: 'Processing ZIP file...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
    
    $.ajax({
        url: '/api/outliers/upload',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(response) {
            if (response.success) {
                // Build message with duplicate info if applicable
                let message = '<p>Added <strong>' + response.addedCount + '</strong> script(s)</p>';
                
                if (response.skippedCount > 0) {
                    message += '<p class="w3-text-orange"><i class="fa fa-warning"></i> Skipped <strong>' +
                               response.skippedCount + '</strong> duplicate(s):</p>';
                    message += '<ul class="w3-ul w3-small" style="max-height: 150px; overflow-y: auto;">';
                    response.skippedDuplicates.forEach(function(name) {
                        message += '<li>' + name + '</li>';
                    });
                    message += '</ul>';
                }
                
                message += '<p class="w3-small w3-opacity">Scripts are disabled by default. Enable them after reviewing.</p>';
                
                Swal.fire({
                    icon: response.skippedCount > 0 ? 'warning' : 'success',
                    title: 'Upload Complete',
                    html: message,
                    width: '500px'
                });
                loadStatistics();
                loadAllScripts();
            } else {
                Swal.fire({
                    icon: 'error',
                    title: 'Upload Failed',
                    text: response.error
                });
            }
        },
        error: function(err) {
            Swal.fire({
                icon: 'error',
                title: 'Upload Failed',
                text: 'Error uploading file: ' + (err.responseJSON ? err.responseJSON.error : err.statusText)
            });
        }
    });
    
    // Reset file input
    document.getElementById('fileInput').value = '';
}

// Load statistics
function loadStatistics() {
    $.ajax({
        url: '/api/outliers/stats',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                $('#totalScripts').text(response.totalScripts);
                $('#enabledCount').text(response.enabledScripts);
                $('#bashCount').text(response.scriptsByType.bash || 0);
                $('#windowsCount').text(response.scriptsByType.windows || 0);
            }
        },
        error: function(err) {
            console.error('Error loading statistics:', err);
        }
    });
}

// Load all scripts
function loadAllScripts() {
    $.ajax({
        url: '/api/outliers/scripts',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                allScripts = response.scripts;
                displayScripts(allScripts);
            }
        },
        error: function(err) {
            console.error('Error loading scripts:', err);
            $('#scriptsList').html('<div class="w3-panel w3-red"><p>Error loading scripts</p></div>');
        }
    });
}

// Switch between package and script view
function switchView(view) {
    currentView = view;
    
    // Update button styles
    if (view === 'package') {
        $('#packageViewBtn').addClass('w3-blue').removeClass('w3-light-grey');
        $('#scriptViewBtn').removeClass('w3-blue').addClass('w3-light-grey');
        loadPackages();
    } else {
        $('#scriptViewBtn').addClass('w3-blue').removeClass('w3-light-grey');
        $('#packageViewBtn').removeClass('w3-blue').addClass('w3-light-grey');
        loadAllScripts();
    }
}

// Load packages
function loadPackages() {
    $.ajax({
        url: '/api/outliers/packages',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                allPackages = response.packages;
                displayPackages(allPackages);
            }
        },
        error: function(err) {
            console.error('Error loading packages:', err);
            $('#scriptsList').html('<div class="w3-panel w3-red"><p>Error loading packages</p></div>');
        }
    });
}

// Display packages
function displayPackages(packages) {
    const container = $('#scriptsList');
    container.empty();
    
    if (packages.length === 0) {
        container.html('<div class="w3-panel w3-pale-yellow w3-border"><p>No packages found. Upload a ZIP file or deploy from library to get started.</p></div>');
        return;
    }
    
    packages.forEach(function(pkg) {
        const allEnabled = pkg.allEnabled;
        const enabledCount = pkg.enabledCount;
        const scriptCount = pkg.scriptCount;
        
        // Check if any script in the package has a README
        const hasReadme = pkg.scripts && pkg.scripts.some(s => s.readmeContent);
        
        const card = $('<div>')
            .addClass('w3-card w3-round w3-white w3-margin-bottom')
            .html(
                '<div class="w3-container w3-padding">' +
                    '<div class="w3-row">' +
                        '<div class="w3-col s7">' +
                            '<h5><i class="fa fa-folder-open w3-margin-right w3-text-blue"></i>' + pkg.packageName + '</h5>' +
                            '<p class="w3-opacity w3-small">' + scriptCount + ' script(s) - ' + enabledCount + ' enabled</p>' +
                        '</div>' +
                        '<div class="w3-col s5 w3-right-align">' +
                            (hasReadme ?
                                '<button class="w3-button w3-light-grey w3-small" onclick="showPackageReadme(\'' + pkg.packageId + '\', event)" ' +
                                'style="margin-bottom: 5px;">' +
                                '<i class="fa fa-file-text-o"></i> README' +
                                '</button><br>' : '') +
                            '<button class="w3-button ' + (allEnabled ? 'w3-green' : 'w3-grey') + ' w3-small" ' +
                                'onclick="togglePackage(\'' + pkg.packageId + '\', event)" ' +
                                'style="margin-bottom: 5px;">' +
                                '<i class="fa fa-power-off"></i> ' + (allEnabled ? 'Disable All' : 'Enable All') +
                            '</button><br>' +
                            '<button class="w3-button w3-blue w3-small" onclick="viewPackageScripts(\'' + pkg.packageId + '\')" ' +
                                'style="margin-bottom: 5px;">' +
                                '<i class="fa fa-eye"></i> View Scripts' +
                            '</button><br>' +
                            '<button class="w3-button w3-red w3-small" onclick="undeployPackage(\'' + pkg.packageId + '\', event)">' +
                                '<i class="fa fa-trash"></i> Undeploy' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                '</div>'
            );
        
        container.append(card);
    });
}

// Toggle package (enable/disable all scripts)
function togglePackage(packageId, event) {
    event.stopPropagation();
    
    Swal.fire({
        title: 'Toggle Package',
        text: 'This will enable/disable all scripts in this package',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, toggle it',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/outliers/packages/' + packageId + '/toggle',
                method: 'POST',
                success: function(response) {
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Success',
                            text: response.message,
                            timer: 2000
                        });
                        loadPackages();
                        loadStatistics();
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: response.error || 'Failed to toggle package'
                        });
                    }
                },
                error: function(err) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Error toggling package: ' + (err.responseJSON ? err.responseJSON.error : err.statusText)
                    });
                }
            });
        }
    });
}

// View scripts in a package
function viewPackageScripts(packageId) {
    const pkg = allPackages.find(p => p.packageId === packageId);
    if (!pkg) return;
    
    displayScripts(pkg.scripts);
    
    // Add back button
    const backButton = $('<div class="w3-panel w3-blue">' +
        '<button class="w3-button w3-white" onclick="loadPackages()">' +
        '<i class="fa fa-arrow-left"></i> Back to Packages' +
        '</button>' +
        '<span class="w3-large" style="margin-left: 20px;"><i class="fa fa-folder"></i> ' + pkg.packageName + '</span>' +
        '</div>');
    
    $('#scriptsList').prepend(backButton);
}

// Show package README in modal
function showPackageReadme(packageId, event) {
    event.stopPropagation();
    
    console.log('showPackageReadme called with packageId:', packageId);
    
    const pkg = allPackages.find(p => p.packageId === packageId);
    if (!pkg) {
        console.error('Package not found:', packageId);
        return;
    }
    
    // Find the first script with README content
    const scriptWithReadme = pkg.scripts.find(s => s.readmeContent);
    
    if (scriptWithReadme) {
        console.log('Found README for package:', pkg.packageName);
        console.log('README content length:', scriptWithReadme.readmeContent.length);
        
        const modalElement = document.getElementById('packageReadmeModal');
        const titleElement = document.getElementById('packageReadmeModalTitle');
        const contentElement = document.getElementById('packageReadmeContent');
        
        console.log('Modal element exists:', !!modalElement);
        console.log('Title element exists:', !!titleElement);
        console.log('Content element exists:', !!contentElement);
        
        if (modalElement && titleElement && contentElement) {
            titleElement.innerHTML = '<i class="fa fa-file-text-o"></i> ' + pkg.packageName + ' - README';
            contentElement.textContent = scriptWithReadme.readmeContent;
            modalElement.style.display = 'block';
            console.log('Modal display set to:', modalElement.style.display);
        } else {
            console.error('One or more modal elements not found!');
        }
    } else {
        console.log('No README found for package:', pkg.packageName);
        Swal.fire({
            icon: 'info',
            title: 'No README',
            text: 'This package does not contain a README file'
        });
    }
}

// Display scripts
function displayScripts(scripts) {
    const container = $('#scriptsList');
    container.empty();
    
    if (scripts.length === 0) {
        container.html('<div class="w3-panel w3-pale-yellow w3-border"><p>No scripts found. Upload a ZIP file to get started.</p></div>');
        return;
    }
    
    scripts.forEach(function(script) {
        // Get schedule info
        const scheduleCount = script.schedules ? script.schedules.length : 0;
        const enabledSchedules = script.schedules ? script.schedules.filter(s => s.enabled).length : 0;
        let scheduleText = scheduleCount === 0 ? 'No schedules' :
                          scheduleCount + ' schedule(s) (' + enabledSchedules + ' enabled)';
        
        const card = $('<div>')
            .addClass('w3-card w3-round w3-white w3-margin-bottom script-card script-' + script.scriptType)
            .attr('onclick', "showScriptDetails('" + script.id + "')")
            .html(
                '<div class="w3-container w3-padding">' +
                    '<div class="w3-row">' +
                        '<div class="w3-col s8">' +
                            '<h5><i class="fa fa-file-code-o w3-margin-right"></i>' + script.name + '</h5>' +
                            '<p class="w3-opacity w3-small">' + script.description + '</p>' +
                            '<p class="w3-small"><i class="fa fa-clock-o"></i> ' + scheduleText + '</p>' +
                        '</div>' +
                        '<div class="w3-col s4 w3-right-align">' +
                            '<span class="w3-tag badge-' + script.scriptType + '">' + script.scriptType.toUpperCase() + '</span><br>' +
                            '<span class="w3-tag badge-' + (script.enabled ? 'enabled' : 'disabled') + '" style="margin-top: 5px;">' +
                                (script.enabled ? 'ENABLED' : 'DISABLED') +
                            '</span>' +
                            '<p class="w3-small w3-opacity" style="margin-top: 5px;">' + formatFileSize(script.fileSize) + '</p>' +
                        '</div>' +
                    '</div>' +
                '</div>'
            );
        
        container.append(card);
    });
}

// Format file size
function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' B';
    else if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
    else return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
}

// Show script details
function showScriptDetails(scriptId) {
    $.ajax({
        url: '/api/outliers/scripts/' + scriptId,
        method: 'GET',
        success: function(response) {
            if (response.success) {
                currentScript = response.script;
                displayScriptDetails(currentScript);
                document.getElementById('scriptModal').style.display = 'block';
            }
        },
        error: function(err) {
            console.error('Error loading script details:', err);
        }
    });
}

// Display script details in modal
function displayScriptDetails(script) {
    $('#modalTitle').html('<i class="fa fa-file-code-o"></i> ' + script.name);
    
    const content =
        '<div class="w3-row-padding">' +
            '<div class="w3-col s6">' +
                '<p><strong>ID:</strong> ' + script.id + '</p>' +
                '<p><strong>Type:</strong> <span class="w3-tag badge-' + script.scriptType + '">' + script.scriptType.toUpperCase() + '</span></p>' +
                '<p><strong>Status:</strong> <span class="w3-tag badge-' + (script.enabled ? 'enabled' : 'disabled') + '">' + 
                    (script.enabled ? 'ENABLED' : 'DISABLED') + '</span></p>' +
            '</div>' +
            '<div class="w3-col s6">' +
                '<p><strong>File Size:</strong> ' + formatFileSize(script.fileSize) + '</p>' +
                '<p><strong>Uploaded:</strong> ' + new Date(script.uploadedAt).toLocaleString() + '</p>' +
                '<p><strong>Uploaded By:</strong> ' + script.uploadedBy + '</p>' +
            '</div>' +
        '</div>' +
        '<hr>' +
        '<h6><strong>Description</strong></h6>' +
        '<p>' + script.description + '</p>' +
        '<hr>' +
        '<h6><strong>Schedules</strong> ' +
            '<button class="w3-button w3-tiny w3-green" onclick="showAddScheduleModal()" style="margin-left:10px;">' +
            '<i class="fa fa-plus"></i> Add Schedule</button></h6>' +
        '<div id="schedules-list"></div>' +
        '<hr>' +
        '<h6><strong>File Path</strong></h6>' +
        '<p class="w3-small w3-opacity">' + script.filePath + '</p>' +
        (script.folderPath ? '<p class="w3-small"><strong>Folder:</strong> ' + script.folderPath + '</p>' : '') +
        '<hr>' +
        '<h6><strong>Last Execution</strong></h6>' +
        '<p>' + (script.lastExecuted ? new Date(script.lastExecuted).toLocaleString() : 'Never executed') + '</p>' +
        '<p class="w3-small">' + script.lastExecutionStatus + '</p>' +
        '<hr>' +
        '<h6><strong>Tags</strong></h6>' +
        '<p id="script-tags-list"></p>' +
        (script.relatedFiles && script.relatedFiles.length > 0 ?
            '<hr><h6><strong>Related Files</strong></h6><p id="related-files-list"></p>' : '') +
        (script.readmeContent ?
            '<hr><h6><strong>README</strong></h6><pre class="w3-panel w3-light-grey w3-border" style="max-height:200px;overflow-y:auto;white-space:pre-wrap;">' +
            script.readmeContent + '</pre>' : '');
    
    $('#modalContent').html(content);
    
    // Populate tags
    if (script.tags && script.tags.length > 0) {
        script.tags.forEach(function(tag) {
            $('#script-tags-list').append('<span class="tag">' + tag + '</span>');
        });
    } else {
        $('#script-tags-list').html('<span class="w3-opacity">No tags</span>');
    }
    
    // Populate related files
    if (script.relatedFiles && script.relatedFiles.length > 0) {
        script.relatedFiles.forEach(function(file) {
            var icon = 'fa-file-o';
            if (file.endsWith('.sql')) icon = 'fa-database';
            else if (file.endsWith('.txt') || file.endsWith('.md')) icon = 'fa-file-text-o';
            $('#related-files-list').append(
                '<span class="w3-tag w3-light-grey w3-margin-right w3-margin-bottom">' +
                '<i class="fa ' + icon + '"></i> ' + file + '</span>'
            );
        });
    }
    
    // Populate schedules
    displaySchedules(script.schedules || []);
}

// Display schedules list
function displaySchedules(schedules) {
    const schedulesList = $('#schedules-list');
    schedulesList.empty();
    
    if (!schedules || schedules.length === 0) {
        schedulesList.html('<p class="w3-opacity">No schedules configured. Click "Add Schedule" to create one.</p>');
        return;
    }
    
    schedules.forEach(function(schedule) {
        const scheduleCard = $('<div>')
            .addClass('w3-panel w3-card w3-white w3-margin-bottom')
            .html(
                '<div class="w3-row">' +
                    '<div class="w3-col s9">' +
                        '<p><strong>' + (schedule.description || 'Schedule') + '</strong></p>' +
                        '<p class="w3-small"><i class="fa fa-clock-o"></i> <strong>Cron:</strong> ' + schedule.cronExpression + '</p>' +
                        '<p class="w3-small"><i class="fa fa-terminal"></i> <strong>Parameters:</strong> ' + (schedule.parameters || 'None') + '</p>' +
                        '<p class="w3-small"><strong>Status:</strong> ' +
                            '<span class="w3-tag badge-' + (schedule.enabled ? 'enabled' : 'disabled') + '">' +
                            (schedule.enabled ? 'ENABLED' : 'DISABLED') + '</span></p>' +
                    '</div>' +
                    '<div class="w3-col s3 w3-right-align">' +
                        '<button class="w3-button w3-tiny w3-blue w3-margin-bottom" onclick="editSchedule(\'' + schedule.scheduleId + '\')">' +
                            '<i class="fa fa-edit"></i> Edit</button><br>' +
                        '<button class="w3-button w3-tiny w3-green w3-margin-bottom" onclick="toggleSchedule(\'' + schedule.scheduleId + '\')">' +
                            '<i class="fa fa-toggle-on"></i> Toggle</button><br>' +
                        '<button class="w3-button w3-tiny w3-red" onclick="deleteSchedule(\'' + schedule.scheduleId + '\')">' +
                            '<i class="fa fa-trash"></i> Delete</button>' +
                    '</div>' +
                '</div>'
            );
        schedulesList.append(scheduleCard);
    });
}

// Show add schedule modal
function showAddScheduleModal() {
    if (!currentScript) return;
    
    // Reset form
    $('#scheduleModalTitle').text('Add Schedule');
    $('#scheduleScriptId').val(currentScript.id);
    $('#scheduleId').val('');
    $('#scheduleDescription').val('');
    $('#scheduleCron').val('');
    $('#scheduleParameters').val('');
    $('#scheduleEnabled').prop('checked', true);
    
    // Show modal
    $('#scheduleModal').show();
}

// Edit existing schedule
function editSchedule(scheduleId) {
    if (!currentScript) return;
    
    // Find the schedule
    const schedule = currentScript.schedules.find(s => s.scheduleId === scheduleId);
    if (!schedule) {
        Swal.fire('Error', 'Schedule not found', 'error');
        return;
    }
    
    // Populate form
    $('#scheduleModalTitle').text('Edit Schedule');
    $('#scheduleScriptId').val(currentScript.id);
    $('#scheduleId').val(schedule.scheduleId);
    $('#scheduleDescription').val(schedule.description || '');
    $('#scheduleCron').val(schedule.cronExpression);
    $('#scheduleParameters').val(schedule.parameters || '');
    $('#scheduleEnabled').prop('checked', schedule.enabled);
    
    // Show modal
    $('#scheduleModal').show();
}

// Save schedule (add or update)
function saveSchedule() {
    const scriptId = $('#scheduleScriptId').val();
    const scheduleId = $('#scheduleId').val();
    const description = $('#scheduleDescription').val().trim();
    const cronExpression = $('#scheduleCron').val().trim();
    const parameters = $('#scheduleParameters').val().trim();
    const enabled = $('#scheduleEnabled').is(':checked');
    
    // Validate
    if (!cronExpression) {
        Swal.fire('Error', 'Cron expression is required', 'error');
        return;
    }
    
    const scheduleData = {
        description: description,
        cronExpression: cronExpression,
        parameters: parameters,
        enabled: enabled
    };
    
    // Determine if adding or updating
    const isUpdate = scheduleId !== '';
    const url = isUpdate
        ? '/api/outliers/scripts/' + scriptId + '/schedules/' + scheduleId
        : '/api/outliers/scripts/' + scriptId + '/schedules';
    const method = isUpdate ? 'PUT' : 'POST';
    
    $.ajax({
        url: url,
        method: method,
        contentType: 'application/json',
        data: JSON.stringify(scheduleData),
        success: function(response) {
            Swal.fire('Success', isUpdate ? 'Schedule updated successfully' : 'Schedule added successfully', 'success');
            $('#scheduleModal').hide();
            loadScripts(); // Reload to get updated data
            if (currentScript) {
                // Refresh the details modal
                setTimeout(function() {
                    viewScriptDetails(scriptId);
                }, 500);
            }
        },
        error: function(xhr) {
            Swal.fire('Error', 'Failed to save schedule: ' + (xhr.responseText || 'Unknown error'), 'error');
        }
    });
}

// Delete schedule
function deleteSchedule(scheduleId) {
    if (!currentScript) return;
    
    Swal.fire({
        title: 'Delete Schedule?',
        text: 'This will remove the schedule from cron/Task Scheduler. This action cannot be undone.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/outliers/scripts/' + currentScript.id + '/schedules/' + scheduleId,
                method: 'DELETE',
                success: function(response) {
                    Swal.fire('Deleted!', 'Schedule has been deleted', 'success');
                    loadScripts(); // Reload to get updated data
                    if (currentScript) {
                        // Refresh the details modal
                        setTimeout(function() {
                            viewScriptDetails(currentScript.id);
                        }, 500);
                    }
                },
                error: function(xhr) {
                    Swal.fire('Error', 'Failed to delete schedule: ' + (xhr.responseText || 'Unknown error'), 'error');
                }
            });
        }
    });
}

// Toggle schedule enabled/disabled
function toggleSchedule(scheduleId) {
    if (!currentScript) return;
    
    $.ajax({
        url: '/api/outliers/scripts/' + currentScript.id + '/schedules/' + scheduleId + '/toggle',
        method: 'POST',
        success: function(response) {
            Swal.fire('Success', 'Schedule status toggled', 'success');
            loadScripts(); // Reload to get updated data
            if (currentScript) {
                // Refresh the details modal
                setTimeout(function() {
                    viewScriptDetails(currentScript.id);
                }, 500);
            }
        },
        error: function(xhr) {
            Swal.fire('Error', 'Failed to toggle schedule: ' + (xhr.responseText || 'Unknown error'), 'error');
        }
    });
}

// Toggle script status
function toggleScriptStatus() {
    if (!currentScript) return;
    
    $.ajax({
        url: '/api/outliers/scripts/' + currentScript.id + '/toggle',
        type: 'POST',
        success: function(response) {
            if (response.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Status Updated',
                    text: 'Script is now ' + (response.enabled ? 'enabled' : 'disabled'),
                    timer: 2000
                });
                loadStatistics();
                loadAllScripts();
                document.getElementById('scriptModal').style.display = 'none';
            }
        },
        error: function(err) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to toggle script status'
            });
        }
    });
}

// Edit script
function editScript() {
    if (!currentScript) return;
    
    $('#editName').val(currentScript.name);
    $('#editDescription').val(currentScript.description);
    $('#editCron').val(currentScript.cronExpression);
    $('#editParameters').val(currentScript.parameters || '');
    $('#editTags').val(currentScript.tags.join(', '));
    $('#editEnabled').prop('checked', currentScript.enabled);
    
    document.getElementById('scriptModal').style.display = 'none';
    document.getElementById('editModal').style.display = 'block';
}

// Save script
function saveScript() {
    if (!currentScript) return;
    
    const tags = $('#editTags').val().split(',').map(t => t.trim()).filter(t => t.length > 0);
    
    const updateData = {
        name: $('#editName').val(),
        description: $('#editDescription').val(),
        cronExpression: $('#editCron').val(),
        parameters: $('#editParameters').val(),
        enabled: $('#editEnabled').is(':checked'),
        tags: tags
    };
    
    $.ajax({
        url: '/api/outliers/scripts/' + currentScript.id,
        type: 'PUT',
        contentType: 'application/json',
        data: JSON.stringify(updateData),
        success: function(response) {
            if (response.success) {
                Swal.fire({
                    icon: 'success',
                    title: 'Saved',
                    text: 'Script updated successfully',
                    timer: 2000
                });
                loadStatistics();
                loadAllScripts();
                document.getElementById('editModal').style.display = 'none';
            }
        },
        error: function(err) {
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to update script'
            });
        }
    });
}

// Delete script
function deleteScript() {
    if (!currentScript) return;
    
    Swal.fire({
        title: 'Delete Script?',
        text: 'This will permanently delete the script file. This action cannot be undone.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: '/api/outliers/scripts/' + currentScript.id,
                type: 'DELETE',
                success: function(response) {
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Deleted',
                            text: 'Script deleted successfully',
                            timer: 2000
                        });
                        loadStatistics();
                        loadAllScripts();
                        document.getElementById('scriptModal').style.display = 'none';
                    }
                },
                error: function(err) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to delete script'
                    });
                }
            });
        }
    });
}

// Search scripts
function searchScripts() {
    const query = $('#searchInput').val();
    
    if (query.length < 2) {
        displayScripts(allScripts);
        return;
    }
    
    $.ajax({
        url: '/api/outliers/search?q=' + encodeURIComponent(query),
        method: 'GET',
        success: function(response) {
            if (response.success) {
                displayScripts(response.scripts);
            }
        },
        error: function(err) {
            console.error('Error searching scripts:', err);
        }
    });
}

// Filter by type
function filterByType() {
    const type = $('#typeFilter').val();
    
    if (type === '') {
        displayScripts(allScripts);
        return;
    }
    
    $.ajax({
        url: '/api/outliers/type/' + type + '/scripts',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                displayScripts(response.scripts);
            }
        },
        error: function(err) {
            console.error('Error filtering scripts:', err);
        }
    });
}

// Close modal when clicking outside
window.onclick = function(event) {
    const scriptModal = document.getElementById('scriptModal');
    const editModal = document.getElementById('editModal');
    if (event.target == scriptModal) {
        scriptModal.style.display = "none";
    }
    if (event.target == editModal) {
        editModal.style.display = "none";
    }
}

// Show deploy modal and load available outliers
function showDeployModal() {
    console.log('=== showDeployModal() called ===');
    
    const modal = document.getElementById('deployModal');
    console.log('Modal element:', modal);
    
    if (!modal) {
        console.error('ERROR: deployModal element not found in DOM!');
        alert('Error: Deploy modal not found. Please refresh the page.');
        return;
    }
    
    console.log('Modal parent before move:', modal.parentElement);
    console.log('Modal parent tag:', modal.parentElement ? modal.parentElement.tagName : 'none');
    
    // CRITICAL FIX: Move modal to document.body to escape any collapsed containers
    if (modal.parentElement !== document.body) {
        console.log('Moving modal to document.body...');
        document.body.appendChild(modal);
        console.log('Modal moved to body');
    }
    
    // Force all styles via JavaScript
    modal.style.cssText = 'display: block !important; position: fixed !important; z-index: 10000 !important; left: 0 !important; top: 0 !important; width: 100% !important; height: 100% !important; overflow: auto !important; background-color: rgba(0,0,0,0.4) !important;';
    
    console.log('Modal display set to block with forced CSS');
    
    // Force dimensions on modal content too
    const modalContent = modal.querySelector('.w3-modal-content');
    if (modalContent) {
        modalContent.style.cssText = 'max-width: 700px !important; min-width: 500px !important; min-height: 300px !important; margin: 50px auto !important; position: relative !important; background-color: white !important; display: block !important;';
        console.log('Modal content styles forced');
    }
    
    // Check if modal is visible
    setTimeout(function() {
        const rect = modal.getBoundingClientRect();
        console.log('Modal bounding rect (after timeout):', rect);
        console.log('Modal parent after move:', modal.parentElement.tagName);
        console.log('Modal width:', window.getComputedStyle(modal).width);
        console.log('Modal height:', window.getComputedStyle(modal).height);
        
        if (modalContent) {
            const contentRect = modalContent.getBoundingClientRect();
            console.log('Modal content bounding rect:', contentRect);
        }
        
        if (rect.width === 0 || rect.height === 0) {
            console.error('MODAL STILL HAS ZERO DIMENSIONS!');
            alert('Modal display issue detected. The modal exists but cannot be rendered. This may be a browser-specific CSS issue.');
        }
    }, 100);
    
    loadAvailableOutliers();
}

// Load available outliers from the outliers directory
function loadAvailableOutliers() {
    console.log('Loading available outliers...');
    $.ajax({
        url: '/api/outliers/available',
        method: 'GET',
        success: function(response) {
            console.log('Available outliers loaded:', response);
            displayAvailableOutliers(response.outliers);
        },
        error: function(err) {
            console.error('Error loading available outliers:', err);
            $('#availableOutliersList').html(
                '<div class="w3-panel w3-red"><p><i class="fa fa-exclamation-triangle"></i> Error loading outliers: ' + 
                (err.responseJSON ? err.responseJSON.error : 'Unknown error') + '</p></div>'
            );
        }
    });
}

// Display available outliers in the modal
function displayAvailableOutliers(outliers) {
    const container = $('#availableOutliersList');
    
    if (!outliers || outliers.length === 0) {
        container.html(
            '<div class="w3-panel w3-pale-yellow w3-border">' +
            '<p><i class="fa fa-info-circle"></i> No outliers found in the outliers directory.</p>' +
            '<p class="w3-small">Place ZIP files in the <code>outliers/</code> directory to deploy them.</p>' +
            '</div>'
        );
        return;
    }
    
    let html = '<div class="w3-row-padding">';
    
    outliers.forEach(function(outlier) {
        html += '<div class="w3-col m12" style="margin-bottom: 10px;">';
        html += '  <div class="w3-card w3-white w3-hover-shadow" style="padding: 15px;">';
        html += '    <div class="w3-row">';
        html += '      <div class="w3-col s9">';
        html += '        <h5 style="margin: 0;"><i class="fa fa-file-archive-o"></i> ' + outlier.displayName + '</h5>';
        html += '        <p class="w3-small w3-text-grey" style="margin: 5px 0;">';
        html += '          <i class="fa fa-hdd-o"></i> Size: ' + outlier.fileSizeMB + ' MB | ';
        html += '          <i class="fa fa-clock-o"></i> Modified: ' + new Date(outlier.lastModified).toLocaleString();
        html += '        </p>';
        html += '      </div>';
        html += '      <div class="w3-col s3" style="text-align: right;">';
        html += '        <button class="w3-button w3-green w3-round" onclick="deployOutlier(\'' + outlier.fileName + '\')">';
        html += '          <i class="fa fa-download"></i> Deploy';
        html += '        </button>';
        html += '      </div>';
        html += '    </div>';
        html += '  </div>';
        html += '</div>';
    });
    
    html += '</div>';
    container.html(html);
}

// Deploy an outlier
function deployOutlier(fileName) {
    console.log('Deploying outlier:', fileName);
    
    Swal.fire({
        title: 'Deploy Outlier?',
        text: 'Deploy ' + fileName + ' to the system?',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Yes, deploy it!',
        cancelButtonText: 'Cancel'
    }).then((result) => {
        if (result.isConfirmed) {
            // Show loading
            Swal.fire({
                title: 'Deploying...',
                text: 'Please wait while the outlier is being deployed',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: '/api/outliers/deploy',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    fileName: fileName,
                    deployedBy: 'admin' // You can get this from session if needed
                }),
                success: function(response) {
                    console.log('Deployment response:', response);
                    
                    let message = response.message;
                    if (response.addedCount > 0) {
                        message += '<br><br><strong>' + response.addedCount + '</strong> script(s) deployed successfully';
                    }
                    if (response.skippedCount > 0) {
                        message += '<br><strong>' + response.skippedCount + '</strong> duplicate(s) skipped';
                    }
                    
                    Swal.fire({
                        title: 'Success!',
                        html: message,
                        icon: 'success',
                        confirmButtonText: 'OK'
                    }).then(() => {
                        // Close deploy modal
                        document.getElementById('deployModal').style.display = 'none';
                        // Reload scripts
                        loadStatistics();
                        if (currentView === 'package') {
                            loadPackages();
                        } else {
                            loadAllScripts();
                        }
                    });
                },
                error: function(err) {
                    console.error('Deployment error:', err);
                    Swal.fire({
                        title: 'Error!',
                        text: 'Failed to deploy outlier: ' + (err.responseJSON ? err.responseJSON.error : 'Unknown error'),
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                }
            });
        }
    });
}

// Undeploy a package (delete all scripts in the package)
function undeployPackage(packageId, event) {
    event.stopPropagation();
    
    const pkg = allPackages.find(p => p.packageId === packageId);
    if (!pkg) {
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'Package not found'
        });
        return;
    }
    
    Swal.fire({
        title: 'Undeploy Package?',
        html: '<p>This will permanently delete <strong>' + pkg.packageName + '</strong> and all its scripts (' + pkg.scriptCount + ').</p>' +
              '<p class="w3-text-red"><i class="fa fa-warning"></i> This action cannot be undone!</p>',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, undeploy it!',
        cancelButtonText: 'Cancel',
        confirmButtonColor: '#d33'
    }).then((result) => {
        if (result.isConfirmed) {
            // Show loading
            Swal.fire({
                title: 'Undeploying...',
                text: 'Removing package and all its scripts...',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: '/api/outliers/packages/' + packageId,
                method: 'DELETE',
                success: function(response) {
                    if (response.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Undeployed!',
                            text: response.message || 'Package has been removed',
                            timer: 2000
                        }).then(() => {
                            loadStatistics();
                            loadPackages();
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: response.error || 'Failed to undeploy package'
                        });
                    }
                },
                error: function(err) {
                    console.error('Undeploy error:', err);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to undeploy package: ' + (err.responseJSON ? err.responseJSON.error : 'Unknown error')
                    });
                }
            });
        }
    });
}
</script>

<!-- SweetAlert2 and notification script -->
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>

<!-- All Modals - Placed at body level for proper display -->

<!-- Script Detail Modal -->
<div id="scriptModal" class="w3-modal">
  <div class="w3-modal-content w3-card-4" style="max-width: 800px;">
    <header class="w3-container w3-theme-d3">
      <span onclick="document.getElementById('scriptModal').style.display='none'"
            class="w3-button w3-display-topright">&times;</span>
      <h3 id="modalTitle">Script Details</h3>
    </header>
    <div class="w3-container" style="max-height: 600px; overflow-y: auto; padding: 20px;">
      <div id="modalContent">
        <!-- Script details will be loaded here -->
      </div>
    </div>
    <footer class="w3-container w3-theme-l4">
      <p>
        <button class="w3-button w3-green" onclick="toggleScriptStatus()">
          <i class="fa fa-toggle-on"></i> Toggle Enable/Disable
        </button>
        <button class="w3-button w3-blue" onclick="editScript()">
          <i class="fa fa-edit"></i> Edit
        </button>
        <button class="w3-button w3-red" onclick="deleteScript()">
          <i class="fa fa-trash"></i> Delete
        </button>
        <button class="w3-button w3-light-grey" onclick="document.getElementById('scriptModal').style.display='none'">
          Close
        </button>
      </p>
    </footer>
  </div>
</div>

<!-- Edit Modal -->
<div id="editModal" class="w3-modal">
  <div class="w3-modal-content w3-card-4" style="max-width: 600px;">
    <header class="w3-container w3-theme-d3">
      <span onclick="document.getElementById('editModal').style.display='none'"
            class="w3-button w3-display-topright">&times;</span>
      <h3>Edit Script</h3>
    </header>
    <div class="w3-container" style="padding: 20px;">
      <label><b>Name</b></label>
      <input type="text" id="editName" class="w3-input w3-border w3-margin-bottom">
      
      <label><b>Description</b></label>
      <textarea id="editDescription" class="w3-input w3-border w3-margin-bottom" rows="3"></textarea>
      
      <label><b>Cron Expression</b></label>
      <input type="text" id="editCron" class="w3-input w3-border w3-margin-bottom" placeholder="e.g., 0 2 * * * (daily at 2 AM)">
      <p class="w3-small w3-opacity">Use standard cron format for Linux or Task Scheduler format for Windows</p>
      
      <label><b>Parameters</b></label>
      <input type="text" id="editParameters" class="w3-input w3-border w3-margin-bottom" placeholder="e.g., --verbose --output=/tmp/log.txt">
      <p class="w3-small w3-opacity">Command-line parameters to pass to the script</p>
      
      <label><b>Tags (comma-separated)</b></label>
      <input type="text" id="editTags" class="w3-input w3-border w3-margin-bottom" placeholder="e.g., backup, maintenance, daily">
      
      <label>
        <input type="checkbox" id="editEnabled" class="w3-check">
        <b> Enabled</b>
      </label>
    </div>
    <footer class="w3-container w3-theme-l4">
      <p>
        <button class="w3-button w3-green" onclick="saveScript()">
          <i class="fa fa-save"></i> Save Changes
        </button>
        <button class="w3-button w3-light-grey" onclick="document.getElementById('editModal').style.display='none'">
          Cancel
        </button>
      </p>
    </footer>
  </div>
</div>

<!-- Schedule Editor Modal -->
<div id="scheduleModal" class="w3-modal">
  <div class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:600px">
    <header class="w3-container w3-blue">
      <span onclick="document.getElementById('scheduleModal').style.display='none'"
            class="w3-button w3-display-topright">&times;</span>
      <h2 id="scheduleModalTitle">Add Schedule</h2>
    </header>
    <div class="w3-container w3-padding">
      <input type="hidden" id="scheduleScriptId" />
      <input type="hidden" id="scheduleId" />
      
      <p>
        <label><b>Description</b></label>
        <input class="w3-input w3-border" type="text" id="scheduleDescription"
               placeholder="e.g., Daily backup at midnight">
      </p>
      
      <p>
        <label><b>Cron Expression</b></label>
        <input class="w3-input w3-border" type="text" id="scheduleCron"
               placeholder="e.g., 0 0 * * * (every day at midnight)">
        <small class="w3-text-grey">
          Format: minute hour day month weekday<br>
          Examples: "0 0 * * *" (daily at midnight), "*/15 * * * *" (every 15 min)
        </small>
      </p>
      
      <p>
        <label><b>Parameters (Optional)</b></label>
        <textarea class="w3-input w3-border" id="scheduleParameters" rows="3"
                  placeholder="Script parameters, one per line"></textarea>
      </p>
      
      <p>
        <label>
          <input type="checkbox" id="scheduleEnabled" checked class="w3-check">
          <b> Enabled</b>
        </label>
      </p>
    </div>
    <footer class="w3-container w3-padding">
      <p>
        <button class="w3-button w3-blue" onclick="saveSchedule()">
          <i class="fa fa-save"></i> Save Schedule
        </button>
        <button class="w3-button w3-light-grey" onclick="document.getElementById('scheduleModal').style.display='none'">
          Cancel
        </button>
      </p>
    </footer>
  </div>
<!-- Deploy Outlier Modal -->
<div id="deployModal" class="w3-modal" style="display: none; position: fixed; z-index: 10000 !important; left: 0; top: 0; width: 100% !important; height: 100% !important; overflow: auto; background-color: rgba(0,0,0,0.4) !important;">
  <div class="w3-modal-content w3-card-4 w3-animate-zoom w3-white" style="max-width:700px; min-width: 500px; min-height: 300px; margin: 50px auto; position: relative; background-color: white !important;">
    <header class="w3-container w3-green" style="padding: 16px;">
      <span onclick="document.getElementById('deployModal').style.display='none'"
            class="w3-button w3-display-topright">&times;</span>
      <h2><i class="fa fa-download"></i> Deploy Outlier from Library</h2>
    </header>
    <div class="w3-container w3-padding" style="padding: 20px; min-height: 200px;">
      <p class="w3-text-grey">Select an outlier package to deploy to the system:</p>
      <div id="availableOutliersList" style="max-height: 400px; overflow-y: auto; min-height: 100px;">
        <!-- Available outliers will be loaded here -->
        <div class="w3-center w3-padding">
          <i class="fa fa-spinner fa-spin" style="font-size: 24px;"></i>
          <p>Loading available outliers...</p>
        </div>
      </div>
    </div>
    <footer class="w3-container w3-padding" style="padding: 16px;">
      <p>
        <button class="w3-button w3-light-grey" onclick="document.getElementById('deployModal').style.display='none'">
          Close
        </button>
      </p>
    </footer>
  </div>
</div>

</div>

<!-- Package README Modal -->
<div id="packageReadmeModal" class="w3-modal">
  <div class="w3-modal-content w3-card-4 w3-animate-zoom" style="max-width:800px">
    <header class="w3-container w3-theme-d3">
      <span onclick="document.getElementById('packageReadmeModal').style.display='none'"
            class="w3-button w3-display-topright">&times;</span>
      <h2 id="packageReadmeModalTitle"><i class="fa fa-file-text-o"></i> Package README</h2>
    </header>
    <div class="w3-container w3-padding">
      <pre id="packageReadmeContent" class="w3-panel w3-light-grey w3-border"
           style="max-height:500px;overflow-y:auto;white-space:pre-wrap;"></pre>
    </div>
    <footer class="w3-container w3-padding">
      <p>
        <button class="w3-button w3-theme" onclick="document.getElementById('packageReadmeModal').style.display='none'">
          Close
        </button>
      </p>
    </footer>
  </div>
</div>

</body>
</html>