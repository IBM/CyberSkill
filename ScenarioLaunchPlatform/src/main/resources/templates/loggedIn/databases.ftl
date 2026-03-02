<!DOCTYPE html>
<html>
<head>
  <title>SQL Queries - SLP</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/loggedIn/css/w3.css">
  <link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">
  <link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">
  <link rel="stylesheet" href="/loggedIn/css/fonts.css">
  <link rel="stylesheet" href="/loggedIn/css/datatables.min.css">
  <script src="/loggedIn/js/jquery.min.js"></script>
  <script src="/loggedIn/js/datatables.min.js"></script>
<style>
*, *::before, *::after { box-sizing: border-box; }
body { font-family: Roboto, sans-serif; background: #f1f5f9; }
.page-header { background: linear-gradient(135deg, #4d636f, #3a4f5a); border-radius: 12px; padding: 1.5rem 1.75rem; margin-bottom: 1.5rem; color: white; }
.page-header h4 { margin: 0 0 0.35rem; font-size: 1.3rem; font-weight: 700; }
.page-header p  { margin: 0; font-size: 0.875rem; opacity: 0.85; }
.breadcrumb-bar { display: flex; align-items: center; gap: 0.5rem; font-size: 0.8rem; color: #64748b; margin-bottom: 1rem; }
.breadcrumb-bar a { color: #4d636f; text-decoration: none; font-weight: 500; }
.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar .separator { color: #cbd5e1; }
.breadcrumb-bar .current { color: #374151; font-weight: 600; }
.section-card { border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden; margin-bottom: 1rem; background: white; }
.section-card-header { display: flex; justify-content: space-between; align-items: center; padding: 1rem 1.25rem; cursor: pointer; background: #f8fafc; border-bottom: 1px solid #e2e8f0; transition: background 0.15s; }
.section-card-header:hover { background: #f1f5f9; }
.section-card-title { font-size: 0.95rem; font-weight: 700; color: #374151; display: flex; align-items: center; gap: 0.5rem; }
.section-card-title i { color: #4d636f; }
.section-card-body { display: none; padding: 1.5rem; }
.section-card-body.open { display: block; }
.form-label { display: block; font-size: 0.8rem; font-weight: 600; color: #374151; margin-bottom: 0.35rem; text-transform: uppercase; letter-spacing: 0.04em; }
input[type="text"], select, textarea { width: 100%; padding: 0.55rem 0.85rem; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 0.875rem; color: #374151; background: white; transition: border-color 0.15s, box-shadow 0.15s; outline: none; }
input[type="text"]:focus, select:focus, textarea:focus { border-color: #4d636f; box-shadow: 0 0 0 3px rgba(77,99,111,0.12); }
textarea { resize: vertical; }
.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem; }
.form-row-4 { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 1rem; margin-bottom: 1rem; }
.btn-save { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.55rem 1.25rem; background: #4d636f; color: white; border: none; border-radius: 8px; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; }
.btn-save:hover { background: #3a4f5a; transform: translateY(-1px); }
.btn-run { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.55rem 1.25rem; background: #10b981; color: white; border: none; border-radius: 8px; font-size: 0.875rem; font-weight: 600; cursor: pointer; transition: all 0.2s; }
.btn-run:hover { background: #059669; transform: translateY(-1px); }
table.dataTable thead th { background: #f8fafc; color: #374151; font-weight: 700; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.04em; border-bottom: 2px solid #e2e8f0 !important; padding: 0.85rem 1rem; }
table.dataTable tbody td { padding: 0.75rem 1rem; font-size: 0.875rem; color: #374151; border-bottom: 1px solid #f1f5f9; vertical-align: middle; cursor: pointer; }
table.dataTable tbody tr:hover { background: #f8fafc; }
.w3-modal-content { border-radius: 12px; overflow: hidden; box-shadow: 0 25px 50px rgba(0,0,0,0.25); }
.modal-header-modern { background: linear-gradient(135deg, #4d636f, #3a4f5a); color: white; padding: 1.25rem 1.5rem; display: flex; justify-content: space-between; align-items: center; }
.modal-header-modern h2 { margin: 0; font-size: 1.1rem; font-weight: 700; }
.modal-close-btn { background: rgba(255,255,255,0.2); border: none; color: white; width: 32px; height: 32px; border-radius: 50%; cursor: pointer; font-size: 1.2rem; display: flex; align-items: center; justify-content: center; transition: background 0.2s; line-height: 1; }
.modal-close-btn:hover { background: rgba(255,255,255,0.35); }
.tab-bar { display: flex; border-bottom: 2px solid #e2e8f0; background: #f8fafc; }
.tab-btn { padding: 0.75rem 1.25rem; border: none; background: transparent; font-size: 0.875rem; font-weight: 600; color: #64748b; cursor: pointer; border-bottom: 2px solid transparent; margin-bottom: -2px; transition: all 0.15s; }
.tab-btn:hover { color: #4d636f; }
.tab-btn.active { color: #4d636f; border-bottom-color: #4d636f; }
.modal-footer-modern { background: #f8fafc; border-top: 1px solid #e2e8f0; padding: 1rem 1.5rem; display: flex; gap: 0.5rem; justify-content: flex-end; }
.btn-modal-action { display: inline-flex; align-items: center; gap: 0.4rem; padding: 0.5rem 1rem; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer; transition: all 0.2s; background: white; color: #374151; }
.btn-modal-action:hover { background: #f1f5f9; }
.btn-modal-action.primary { background: #4d636f; color: white; border-color: #4d636f; }
.btn-modal-action.primary:hover { background: #3a4f5a; }
.btn-modal-action.danger { background: #ef4444; color: white; border-color: #ef4444; }
.btn-modal-action.danger:hover { background: #dc2626; }
.city { display: none; height: 800px; background-color: white; }
.custom-modal { width: 70%; height: 800px; }
</style>
</head>
<body class="w3-theme-l5">
<div id="navbar"></div>
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">
  <div class="w3-row">
    <div id="leftColumn"></div>
    <div class="w3-col m9">
      <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <div class="breadcrumb-bar">
                <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
                <span class="separator">&#8250;</span>
                <span class="current"><i class="fa fa-database"></i> SQL Queries</span>
              </div>
              <div class="page-header">
                <h4><i class="fa fa-database"></i> Prepared Database Queries</h4>
                <p>Manage, run, and edit SQL queries for use in stories and testing scenarios</p>
              </div>
              <table id="example" class="display" style="width:100%">
                <thead><tr><th>ID</th><th>Query Name</th><th>DB Type</th><th>Query Type</th><th>Loop</th></tr></thead>
                <tbody></tbody>
              </table>
              <div class="section-card" style="margin-top:1.5rem;">
                <div class="section-card-header" onclick="toggleSectionCard('addSQLCard', this)">
                  <div class="section-card-title"><i class="fa fa-plus-circle"></i> Add SQL Statement</div>
                  <i class="fa fa-chevron-down" style="color:#94a3b8; transition:transform 0.2s;"></i>
                </div>
                <div class="section-card-body" id="addSQLCard">
                  <p style="color:#64748b; font-size:0.875rem; margin-bottom:1rem;">SQL can be added <code>;</code> separated for each SQL statement.</p>
                  <div id="addSQLStatementModal" class="w3-modal">
                    <div class="w3-modal-content" style="border-radius:12px; max-width:500px; margin:10% auto;">
                      <div class="modal-header-modern"><h2><i class="fa fa-check-circle"></i> SQL Added</h2><button class="modal-close-btn" onclick="document.getElementById('addSQLStatementModal').style.display='none';getSqlStatements();">&times;</button></div>
                      <div style="padding:1.5rem;"><p id="addSQLStatementResponse" style="color:#374151;"></p></div>
                    </div>
                  </div>
                  <div style="margin-bottom:1rem;"><label class="form-label">SQL Statement</label><textarea id="sqlStatementToAdd" name="sqlStatementToAdd" rows="8" style="width:100%; font-family:'Courier New',monospace; font-size:0.875rem;"></textarea></div>
                  <div class="form-row">
                    <div><label class="form-label">Database Type</label><select id="addSqlStatementDB" name="addSqlStatementDB"><option value="db2">DB2</option><option value="mysql">MySQL</option><option value="postgres">PostgreSQL</option><option value="oracle">Oracle</option></select></div>
                    <div><label class="form-label">Query Type</label><select id="addSqlStatementType" name="addSqlStatementType"><option value="Select">Select</option><option value="Update">Update</option><option value="Alert">Alert</option><option value="Delete">Delete</option></select></div>
                  </div>
                  <div class="form-row">
                    <div><label class="form-label">Loop Count (1-99)</label><input type="text" id="sqlStatementQueryLoop" placeholder="1" value="1"></div>
                    <div><label class="form-label">Use Case Name</label><input type="text" id="sqlStatementQueryUsecase" placeholder="e.g. insert_update_delete"></div>
                  </div>
                  <div style="margin-bottom:1rem;"><label class="form-label">Description</label><textarea id="sqlStatementQueryDescription" name="sqlStatementQueryDescription" placeholder="Describe what this query does..." rows="3" style="width:100%;"></textarea></div>
                  <div style="margin-bottom:1.25rem;"><label class="form-label">Video URL (optional)</label><input type="text" id="sqlStatementVideoLink" placeholder="https://..."></div>
                  <button type="button" class="btn-save" onclick="addDatabaseQuery();"><i class="fa fa-save"></i> Save SQL Statement</button>
                </div>
              </div>
              <div class="section-card">
                <div class="section-card-header" onclick="toggleSectionCard('freestyleSQLCard', this)">
                  <div class="section-card-title"><i class="fa fa-rocket"></i> Freestyle SQL</div>
                  <i class="fa fa-chevron-down" style="color:#94a3b8; transition:transform 0.2s;"></i>
                </div>
                <div class="section-card-body" id="freestyleSQLCard">
                  <p style="color:#64748b; font-size:0.875rem; margin-bottom:1rem;">Run ad-hoc SQL statements directly against a validated connection.</p>
                  <div id="freestyleStatementModal" class="w3-modal">
                    <div class="w3-modal-content" style="border-radius:12px; max-width:500px; margin:10% auto;">
                      <div class="modal-header-modern"><h2><i class="fa fa-check-circle"></i> Freestyle Result</h2><button class="modal-close-btn" onclick="document.getElementById('freestyleStatementModal').style.display='none';">&times;</button></div>
                      <div style="padding:1.5rem;"><p id="addFreestyleSQLStatementResponse" style="color:#374151;"></p></div>
                    </div>
                  </div>
                  <div style="margin-bottom:1rem;"><label class="form-label">SQL Statement</label><textarea id="freestyleSQLToRun" name="freestyleSQLToRun" rows="8" style="width:100%; font-family:'Courier New',monospace; font-size:0.875rem;"></textarea></div>
                  <div style="margin-bottom:1.25rem;"><label class="form-label">Connection</label>
                    <select id="validatedConnectionsForFreestyle" name="dropdown">
                      <#if ValidatedConnectionData?has_content>
                        <#list ValidatedConnectionData?keys as key>
                          <option value="${key}">${key}</option>
                        </#list>
                      <#else>
                        <option value="">No connections available</option>
                      </#if>
                    </select>
                  </div>
                  <button type="button" class="btn-run" onclick="runFreestyleQuery(0);"><i class="fa fa-rocket"></i> Run Query</button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<br>
<div id="freestyleModal" class="w3-modal">
  <div class="w3-modal-content w3-animate-zoom" style="max-width:90%; margin:3% auto; border-radius:12px; overflow:hidden;">
    <div class="modal-header-modern"><h2><i class="fa fa-table"></i> Freestyle Results</h2><button class="modal-close-btn" onclick="document.getElementById('freestyleModal').style.display='none';">&times;</button></div>
    <div style="padding:1.5rem; overflow-x:auto;"><table id="freestyleTable" class="display" style="width:100%"></table></div>
  </div>
</div>
<div id="footer"></div>
<div id="id_edit_modal" class="w3-modal">
  <div class="w3-modal-content w3-animate-zoom custom-modal" style="border-radius:12px; overflow:hidden;">
    <div class="modal-header-modern"><h2><i class="fa fa-code"></i> SQL Query Editor</h2><button class="modal-close-btn" onclick="closeDatabaseQuery();">&times;</button></div>
    <div class="tab-bar">
      <button id="sqlData" class="tab-btn tablink active" onclick="toggleEditResultsShowSQL()"><i class="fa fa-code"></i> SQL Data</button>
      <button id="sqlResults" class="tab-btn tablink"><i class="fa fa-table"></i> Results[0]</button>
      <button id="sqlReport" class="tab-btn tablink"><i class="fa fa-bar-chart"></i> Report</button>
      <button class="tab-btn" style="margin-left:auto; color:#10b981;" onclick="runDatabaseQueryByDatasourceMap(0)"><i class="fa fa-play"></i> Run</button>
    </div>
    <div id="edit" class="w3-container city" style="padding:1.5rem;">
      <div style="display:grid; grid-template-columns:auto 1fr; gap:1rem; align-items:end; margin-bottom:1rem;">
        <div><label class="form-label">Filter</label><input type="text" id="dropdownInput" placeholder="Filter connections..." style="width:160px;" maxlength="20" onchange="filterDropdown()"></div>
        <div><label class="form-label">Datasource</label>
          <select id="validatedConnections" name="dropdown">
            <#if ValidatedConnectionData?has_content>
              <#list ValidatedConnectionData?keys as key>
                <option value="${key}">${key} [${ValidatedConnectionData[key].status}]</option>
              </#list>
            <#else>
              <option value="">No connections available</option>
            </#if>
          </select>
        </div>
      </div>
      <div style="margin-bottom:1rem;"><label class="form-label">Query ID</label><input type="text" id="sqlStatementToEditId" value="" readonly style="background:#f8fafc; color:#64748b;"></div>
      <div id="editRow" style="margin-bottom:1rem;"><label class="form-label">SQL Statement</label><textarea id="sqlStatementToEdit" name="sqlStatementToEdit" rows="12" style="width:100%; font-family:'Courier New',monospace; font-size:0.875rem;"></textarea></div>
      <div class="form-row-4" style="margin-bottom:1rem;">
        <div><label class="form-label">Suggested DB</label><select id="sqlStatementToEditDB" name="sqlStatementToEditDB"><option value="db2">DB2</option><option value="mysql">MySQL</option><option value="postgres">PostgreSQL</option></select></div>
        <div><label class="form-label">Query Type</label><select id="sqlStatementToEditType" name="sqlStatementToEditType"><option value="Select">Select</option><option value="Update">Update</option><option value="Alert">Alert</option></select></div>
        <div><label class="form-label">Loop (default 1)</label><input type="text" id="sqlStatementToEditQueryLoop" value=""></div>
        <div><label class="form-label">Query Name</label><input type="text" id="sqlStatementToEditQueryUsecase" value=""></div>
      </div>
      <div style="margin-bottom:1rem;"><label class="form-label">Description</label><textarea id="sqlStatementToEditDescription" name="sqlStatementToEditDescription" placeholder="Description" rows="3" style="width:100%;"></textarea></div>
      <div style="display:flex; align-items:center; gap:1rem; margin-bottom:1rem;">
        <i class="fa fa-video-camera" style="font-size:2rem; color:#4d636f; cursor:pointer; transition:color 0.2s;" onmouseover="this.style.color='#10b981'" onmouseout="this.style.color='#4d636f'" onclick="watchVideo()" title="Watch video"></i>
        <div style="flex:1;"><label class="form-label">Video URL</label><input type="text" id="sqlStatementToEditVideoLink" value="" placeholder="https://..."></div>
      </div>
      <div id="resultsRow" style="display:none; overflow-y:scroll; max-height:400px;"><table id="resultsTable" class="display" style="width:100%"></table></div>
    </div>
    <div class="modal-footer-modern">
      <button id="CloseSQLButton" class="btn-modal-action" onclick="closeDatabaseQuery()"><i class="fa fa-times"></i> Close</button>
      <button id="DeleteSQLButton" class="btn-modal-action danger" onclick="deleteDatabaseQueryByQueryId()"><i class="fa fa-trash"></i> Delete</button>
      <button id="UpdateSQLButton" class="btn-modal-action" onclick="updateDatabaseQueryByQueryId()"><i class="fa fa-save"></i> Update</button>
      <button id="RunSQLButton" class="btn-modal-action primary" onclick="runDatabaseQueryByDatasourceMap(0)"><i class="fa fa-play"></i> Run</button>
    </div>
  </div>
</div>
<div id="reportsModal" class="w3-modal">
  <div class="w3-modal-content w3-animate-zoom" style="max-width:90%; margin:3% auto; border-radius:12px; overflow:hidden;">
    <div class="modal-header-modern"><h2><i class="fa fa-bar-chart"></i> Query Reports</h2><button class="modal-close-btn" onclick="closeModal()">&times;</button></div>
    <div style="padding:1.5rem; overflow-x:auto;"><table id="reportsTable" class="display" style="width:100%"></table></div>
  </div>
</div>

<script>
window.onload = function() { quickSearch(); };

function watchVideo() {
    var videoLink = document.getElementById('sqlStatementToEditVideoLink');
    if (videoLink.value === null || videoLink.value === "" || videoLink.value === undefined) {
        console.log("video value is null, empty, or undefined");
    } else {
        window.open(videoLink.value, "_blank");
    }
}

function quickSearch() {
    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('lookup')) {
        var querytype = urlParams.get('lookup');
        if (querytype) {
            var table = $('#example').DataTable();
            table.search(querytype).draw();
        }
    }
}

function toggleSectionCard(id, headerEl) {
    var body = document.getElementById(id);
    var chevron = headerEl.querySelector('.fa-chevron-down');
    var isOpen = body.classList.contains('open');
    body.classList.toggle('open', !isOpen);
    if (chevron) chevron.style.transform = isOpen ? '' : 'rotate(180deg)';
}

function myFunction(id) {
    var x = document.getElementById(id);
    if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
        x.previousElementSibling.className += " w3-theme-d1";
    } else {
        x.className = x.className.replace("w3-show", "");
        x.previousElementSibling.className = x.previousElementSibling.className.replace(" w3-theme-d1", "");
    }
}

function openNav() {
    var x = document.getElementById("navDemo");
    if (x.className.indexOf("w3-show") == -1) { x.className += " w3-show"; }
    else { x.className = x.className.replace(" w3-show", ""); }
}
</script>

<script>
function closeDatabaseQuery() {
    document.getElementById('id_edit_modal').style.display = 'none';
    $("#sqlResults").html('Results[0]');
    $('#resultsTable').DataTable().destroy();
    $('#resultsTable').empty();
    toggleEditResultsShowSQL();
    var $button = $('#sqlResults');
    $button.off('click');
}

function toggleEditResultsShowResults() {
    document.getElementById('editRow').style.display = 'none';
    document.getElementById('DeleteSQLButton').style.display = 'none';
    document.getElementById('UpdateSQLButton').style.display = 'none';
    document.getElementById('RunSQLButton').style.display = 'none';
    document.getElementById('resultsRow').style.display = 'block';
}

function toggleEditResultsShowSQL() {
    document.getElementById('editRow').style.display = 'block';
    document.getElementById('DeleteSQLButton').style.display = 'block';
    document.getElementById('UpdateSQLButton').style.display = 'block';
    document.getElementById('RunSQLButton').style.display = 'block';
    document.getElementById('resultsRow').style.display = 'none';
}

function toggleAddSqlDiv() {
    var div = document.getElementById('addSQL');
    div.style.display = (div.style.display === 'none' || div.style.display === '') ? 'block' : 'none';
}
</script>

<script>
function runFreestyleQuery(result) {
    var jwtToken = '${tokenObject.jwt}';
    var queryString = $('#freestyleSQLToRun').val();
    var dbConnection = $('#validatedConnectionsForFreestyle').val();
    var jsonData = JSON.stringify({ jwt: jwtToken, sql: queryString, datasource: dbConnection });
    $.ajax({
        url: '/api/runDatabaseQueryByDatasourceMap', type: 'POST', data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            if (!Array.isArray(response) || response.length === 0) { $('#response').text('Error: No results found'); return; }
            if (!response[result] || !Array.isArray(response[result]) || response[result].length === 0) { $('#response').text('Error: No data found'); return; }
            var firstEntry = response[result][0];
            if (!firstEntry || !firstEntry.Result || !firstEntry.SQL) { $('#response').text('Error: Invalid response format'); return; }
            var jsonData = firstEntry.Result;
            var jsonDataSQL = firstEntry.SQL;
            $("#freestyleResults").html('Results [' + jsonDataSQL + ']');
            createTableForFreestyle(jsonData);
            openFreestyleModal();
        },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}

var hold = 1;

function runDatabaseQueryByDatasourceMap(result) {
    var jwtToken = '${tokenObject.jwt}';
    var queryString = $('#sqlStatementToEdit').val();
    var dbConnection = $('#validatedConnections').val();
    var queryLoop = $('#sqlStatementToEditQueryLoop').val();
    toggleEditResultsShowResults();
    var jsonData = JSON.stringify({ jwt: jwtToken, sql: queryString, datasource: dbConnection, query_loop: queryLoop });
    $.ajax({
        url: '/api/runDatabaseQueryByDatasourceMap', type: 'POST', data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            if (!Array.isArray(response) || response.length === 0) { $('#response').text('Error: No results found'); return; }
            if (!response[result] || !Array.isArray(response[result]) || response[result].length === 0) { $('#response').text('Error: No data found'); return; }
            var firstEntry = response[result][0];
            if (!firstEntry || !firstEntry.Result || !firstEntry.SQL) { $('#response').text('Error: Invalid response format'); return; }
            var jsonData = firstEntry.Result;
            var jsonDataSQL = firstEntry.SQL;
            $("#sqlResults").html('Results [' + jsonDataSQL + ']');
            createTableFromJSON(jsonData);
            var $button = $('#sqlResults');
            $button.off('click');
            $button.on('click', function() {
                if (hold < response[result].length) {
                    var nextEntry = response[result][hold];
                    if (nextEntry && nextEntry.Result && nextEntry.SQL) {
                        jsonData = nextEntry.Result; jsonDataSQL = nextEntry.SQL;
                        $("#sqlResults").html('Results [' + jsonDataSQL + ']');
                        createTableFromJSON(jsonData);
                    }
                    hold++;
                } else { hold = 0; }
            });
            $('#sqlReport').off('click');
            $('#sqlReport').on('click', function() { createReportsTableFromJSON(response); });
        },
        error: function(xhr, status, error) { console.error("AJAX Error: ", error); $('#response').text('Error: ' + error); }
    });
}

function createTableFromJSON(jsonArray) {
    $('#resultsTable').DataTable().destroy();
    $('#resultsTable').empty();
    var columns = Object.keys(jsonArray[0]).map(function(key) { return { title: key.charAt(0).toUpperCase() + key.slice(1), data: key }; });
    $('#resultsTable').DataTable({ data: jsonArray, columns: columns });
}

function createTableForFreestyle(jsonArray) {
    $('#freestyleTable').DataTable().destroy();
    $('#freestyleTable').empty();
    var columns = Object.keys(jsonArray[0]).map(function(key) { return { title: key.charAt(0).toUpperCase() + key.slice(1), data: key }; });
    $('#freestyleTable').DataTable({ data: jsonArray, columns: columns });
}

function createReportsTableFromJSON(jsonArray) {
    var rows = []; var columnsSet = new Set(); var rowNumber = 1;
    jsonArray.forEach(function(iteration, iterationIndex) {
        iteration.forEach(function(entry) {
            var Result = entry.Result; var SQL = entry.SQL;
            if (Array.isArray(Result)) {
                var errorValue = null;
                var containsError = Result.some(function(item) {
                    return Object.values(item).some(function(value) {
                        if (typeof value === "string" && (value.toLowerCase().includes("error") || value.toLowerCase().includes("fatal") || value.toLowerCase().includes("denied") || value.toLowerCase().includes("exception") || value.toLowerCase().includes("failed"))) {
                            errorValue = value; return true;
                        }
                        return false;
                    });
                });
                var row = { RowNumber: rowNumber++, SQL: SQL || "SQL not provided", Iteration: iterationIndex, RecordCount: Result.length, Status: containsError ? "Error found" : "Success", Error: errorValue || "No error" };
                Object.keys(row).forEach(function(key) { columnsSet.add(key); });
                rows.push(row);
            }
        });
    });
    var columnsArray = Array.from(columnsSet).map(function(col) {
        if (col === "Status") {
            return { title: col, data: col, render: function(data) {
                if (data === "Error found") return '<img src="/w3images/warning.png" alt="Error" style="width:20px;height:20px;">';
                if (data === "Success") return '<img src="/w3images/success.png" alt="Success" style="width:20px;height:20px;">';
                return data;
            }};
        }
        return { title: col, data: col };
    });
    if ($.fn.dataTable.isDataTable('#reportsTable')) { $('#reportsTable').DataTable().destroy(); }
    $('#reportsTable').DataTable({ data: rows, columns: columnsArray });
    openModal();
}

function openModal() { document.getElementById('reportsModal').style.display = 'block'; }
function closeModal() { document.getElementById('reportsModal').style.display = 'none'; }
function openFreestyleModal() { document.getElementById('freestyleModal').style.display = 'block'; }
function closeFreestyleModal() { document.getElementById('freestyleModal').style.display = 'none'; }
</script>

<script>
document.getElementsByClassName("tablink")[0].click();
function openCity(evt, cityName) {
    var i, x, tablinks;
    x = document.getElementsByClassName("city");
    for (i = 0; i < x.length; i++) { x[i].style.display = "none"; }
    tablinks = document.getElementsByClassName("tablink");
    for (i = 0; i < x.length; i++) { tablinks[i].classList.remove("w3-light-grey"); }
    document.getElementById(cityName).style.display = "block";
    evt.currentTarget.classList.add("w3-light-grey");
}
</script>

<script>

function getSqlStatements() {
    var table = $('#example').DataTable();
    var jwtToken = '${tokenObject.jwt}';
    var jsonData = JSON.stringify({ jwt: jwtToken });
    $.ajax({
        url: '/api/getDatabaseQuery', type: 'POST', data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            table.clear();
            response.forEach(function(item) { table.row.add([item.id, item.query_usecase, item.query_type, item.query_db_type, item.query_loop]); });
            table.draw();
        },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}
</script>

<script>
function addDatabaseQuery() {
    var jwtToken = '${tokenObject.jwt}';
    var jsonData = JSON.stringify({
        jwt: jwtToken, query_type: $('#addSqlStatementDB').val(), query_db_type: $('#addSqlStatementType').val(),
        query_string: $('#sqlStatementToAdd').val(), db_connection_id: "35",
        query_usecase: $('#sqlStatementQueryUsecase').val(), query_loop: $('#sqlStatementQueryLoop').val(),
        query_description: $('#sqlStatementQueryDescription').val(), video_link: $('#sqlStatementVideoLink').val()
    });
    $.ajax({
        url: '/api/addDatabaseQuery', type: 'POST', data: jsonData, contentType: 'application/json; charset=utf-8',
        success: function(response) {
            document.getElementById('addSQLStatementResponse').innerHTML = response[0].response;
            document.getElementById('addSQLStatementModal').style.display = 'block';
        },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}

function deleteDatabaseQueryByQueryId() {
    var jwtToken = '${tokenObject.jwt}';
    var jsonData = JSON.stringify({ jwt: jwtToken, query_id: $('#sqlStatementToEditId').val() });
    $.ajax({
        url: '/api/deleteDatabaseQueryByQueryId', type: 'POST', data: jsonData, contentType: 'application/json; charset=utf-8',
        success: function(response) { getSqlStatements(); },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}

function updateDatabaseQueryByQueryId() {
    var jwtToken = '${tokenObject.jwt}';
    var jsonData = JSON.stringify({
        jwt: jwtToken, query_id: $('#sqlStatementToEditId').val(), query_db_type: $('#sqlStatementToEditDB').val(),
        db_connection_id: "35", query_string: $('#sqlStatementToEdit').val(), query_type: $('#sqlStatementToEditType').val(),
        query_usecase: $('#sqlStatementToEditQueryUsecase').val(), query_loop: $('#sqlStatementToEditQueryLoop').val(),
        query_description: $('#sqlStatementToEditDescription').val(), video_link: $('#sqlStatementToEditVideoLink').val()
    });
    $.ajax({
        url: '/api/updateDatabaseQueryByQueryId', type: 'POST', data: jsonData, contentType: 'application/json; charset=utf-8',
        success: function(response) { getSqlStatements(); },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}

function getDatabaseQueryByQueryId(varId) {
    var jwtToken = '${tokenObject.jwt}';
    var jsonData = JSON.stringify({ jwt: jwtToken, query_id: varId });
    $.ajax({
        url: '/api/getDatabaseQueryByQueryId', type: 'POST', data: jsonData, contentType: 'application/json; charset=utf-8',
        success: function(response) {
            document.getElementById('sqlStatementToEdit').value = response[0].query_string;
            document.getElementById('sqlStatementToEditDB').value = response[0].query_type;
            document.getElementById('sqlStatementToEditId').value = response[0].id;
            document.getElementById('sqlStatementToEditType').value = response[0].query_db_type;
            document.getElementById('sqlStatementToEditQueryUsecase').value = response[0].query_usecase;
            document.getElementById('sqlStatementToEditQueryLoop').value = response[0].query_loop;
            document.getElementById('sqlStatementToEditDescription').value = response[0].query_description;
            document.getElementById('sqlStatementToEditVideoLink').value = response[0].video_link;
            document.getElementById('id_edit_modal').style.display = 'block';
        },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}
</script>

<script>
$(document).ready(function() {
    // Load includes
    $.ajax({ url: '/loggedIn/includes/navbar.ftl', method: 'GET',
        success: function(response) { $('#navbar').html(response); },
        error: function(err) { console.error('Error loading navbar:', err); }
    });
    $.ajax({ url: '/loggedIn/includes/leftColumn2.ftl', method: 'GET',
        success: function(response) { $('#leftColumn').html(response); getQueryTypes(); },
        error: function(err) { console.error('Error loading left column:', err); }
    });
    $.ajax({ url: '/loggedIn/includes/footer.ftl', method: 'GET',
        success: function(response) { $('#footer').html(response); },
        error: function(err) { console.error('Error loading footer:', err); }
    });

    // Initialize DataTable and load SQL statements
    getSqlStatements();
    var table = $('#example').DataTable();
    table.on('click', 'tbody tr', function() {
        getDatabaseQueryByQueryId(table.row(this).data()[0]);
    });
});
</script>

<script>
function openNewWindow() { window.open('', '_blank'); }

function getQueryTypes() {
    var var_jwt = '${tokenObject.jwt}';
    var jsonData = JSON.stringify({ jwt: var_jwt });
    $.ajax({
        url: '/api/getQueryTypes', type: 'POST', data: jsonData, contentType: 'application/json; charset=utf-8',
        success: function(response) {
            var queryTypes = document.getElementById('queryTypes');
            queryTypes.innerHTML = "";
            if (Array.isArray(response)) {
                $.each(response, function(index, item) {
                    var span = document.createElement('span');
                    span.textContent = item.query_type;
                    span.classList.add('w3-tag', 'w3-small', 'w3-theme-d' + index);
                    span.onclick = function() { window.location.href = 'databases.ftl?lookup=' + item.query_type; };
                    queryTypes.appendChild(span);
                });
            }
        },
        error: function(xhr, status, error) { $('#response').text('Error: ' + error); }
    });
}

var originalOptions = [];
$(document).ready(function() {
    var dropdown = document.getElementById('validatedConnections');
    originalOptions = Array.from(dropdown.options).map(function(option) { return option.text; });
});

function filterDropdown() {
    var filterText = document.getElementById('dropdownInput').value.toLowerCase();
    var dropdown = document.getElementById('validatedConnections');
    dropdown.innerHTML = '';
    var matches = originalOptions.filter(function(item) { return item.toLowerCase().includes(filterText); });
    if (matches.length > 0) {
        matches.forEach(function(text) { var option = document.createElement('option'); option.text = text; dropdown.appendChild(option); });
    } else {
        var noMatch = document.createElement('option'); noMatch.text = 'No matches'; noMatch.disabled = true; dropdown.appendChild(noMatch);
    }
}
</script>
</body>
</html>
