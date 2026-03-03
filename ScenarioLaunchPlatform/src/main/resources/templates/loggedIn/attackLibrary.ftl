<!DOCTYPE html>
<html>
<head>
<title>Attack Pattern Library</title>
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
.stat-card.red { background: rgba(239,68,68,0.25); border-color: rgba(239,68,68,0.4); }
.stat-card.orange { background: rgba(245,158,11,0.25); border-color: rgba(245,158,11,0.4); }
.stat-card.blue { background: rgba(59,130,246,0.25); border-color: rgba(59,130,246,0.4); }
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
.search-bar { display: flex; gap: 12px; align-items: center; margin-bottom: 16px; }
.search-bar input, .search-bar select {
  padding: 9px 14px; border: 1px solid var(--border); border-radius: 8px;
  font-size: 0.9rem; color: var(--text); background: white; outline: none; transition: border-color 0.2s;
}
.search-bar input { flex: 1; }
.search-bar input:focus, .search-bar select:focus { border-color: var(--primary); }
.category-tabs { display: flex; flex-wrap: wrap; gap: 8px; }
.category-tab {
  padding: 6px 14px; border-radius: 20px; cursor: pointer; font-size: 0.82rem;
  background: #e2e8f0; color: var(--text-muted); border: 1px solid var(--border);
  transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px;
}
.category-tab:hover { background: #cbd5e1; }
.category-tab.active { background: var(--primary); color: white; border-color: var(--primary); }
.pattern-card {
  background: white; border: 1px solid var(--border); border-radius: 10px;
  margin-bottom: 12px; overflow: hidden; cursor: pointer;
  box-shadow: 0 1px 3px rgba(0,0,0,0.05); transition: box-shadow 0.2s;
  border-left: 4px solid var(--border);
}
.pattern-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
.pattern-card.severity-critical { border-left-color: #ef4444; }
.pattern-card.severity-high { border-left-color: #f59e0b; }
.pattern-card.severity-medium { border-left-color: #fbc02d; }
.pattern-card.severity-low { border-left-color: #10b981; }
.pattern-card-body { padding: 16px 20px; display: flex; align-items: flex-start; justify-content: space-between; gap: 16px; }
.pattern-card-info h5 { margin: 0 0 6px; font-size: 1rem; font-weight: 600; color: var(--text); }
.pattern-card-info p { margin: 0 0 8px; font-size: 0.85rem; color: var(--text-muted); }
.badge {
  display: inline-block; padding: 3px 10px; border-radius: 20px;
  font-size: 0.75rem; font-weight: 600; letter-spacing: 0.3px;
}
.badge-critical { background: #fef2f2; color: #dc2626; border: 1px solid #fca5a5; }
.badge-high { background: #fffbeb; color: #d97706; border: 1px solid #fcd34d; }
.badge-medium { background: #fefce8; color: #ca8a04; border: 1px solid #fde047; }
.badge-low { background: #f0fdf4; color: #16a34a; border: 1px solid #86efac; }
.tag { display: inline-block; padding: 3px 8px; margin: 2px; background: #e2e8f0; border-radius: 4px; font-size: 0.75rem; color: var(--text-muted); }
.db-tag { display: inline-block; padding: 3px 8px; margin: 2px; background: #dbeafe; border-radius: 4px; font-size: 0.75rem; color: #1e40af; }
.sql-block {
  background: #1e293b; color: #e2e8f0; border-radius: 8px; padding: 12px 16px;
  font-family: 'Courier New', monospace; font-size: 0.82rem; overflow-x: auto;
  margin: 8px 0; line-height: 1.5;
}
.alert-box {
  background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px;
  padding: 12px 16px; color: #1e40af; font-size: 0.88rem;
}
.mitigation-box {
  background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 8px;
  padding: 12px 16px; color: #166534; font-size: 0.88rem;
}
.modern-modal {
  display: none; position: fixed; z-index: 10000;
  left: 0; top: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.5); overflow: auto;
}
.modern-modal-content {
  background: white; border-radius: 12px; margin: 40px auto;
  max-width: 800px; width: 90%; box-shadow: 0 20px 60px rgba(0,0,0,0.3); overflow: hidden;
}
.modal-header-modern {
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  color: white; padding: 18px 24px; display: flex; align-items: center; justify-content: space-between;
}
.modal-header-modern h3 { margin: 0; font-size: 1.1rem; font-weight: 600; }
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
.btn { padding: 8px 16px; border-radius: 7px; border: none; cursor: pointer; font-size: 0.85rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
.btn-primary { background: var(--primary); color: white; }
.btn-primary:hover { background: var(--primary-dark); }
.btn-danger { background: var(--danger); color: white; }
.btn-danger:hover { background: #dc2626; }
.btn-secondary { background: #e2e8f0; color: var(--text); }
.btn-secondary:hover { background: #cbd5e1; }
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
.info-item { background: #f8fafc; border-radius: 8px; padding: 10px 14px; }
.info-item .info-key { font-size: 0.75rem; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
.info-item .info-val { font-size: 0.9rem; color: var(--text); margin-top: 2px; font-weight: 500; }
hr.divider { border: none; border-top: 1px solid var(--border); margin: 16px 0; }
.swal2-container { z-index: 20000 !important; }
.swal2-popup { z-index: 20001 !important; }
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">
  <div class="w3-row">
    <div id="leftColumn"></div>
    <div class="w3-col m9">

      <div class="page-header">
        <div>
          <h2><i class="fa fa-shield" style="margin-right:10px;"></i>Attack Pattern Library</h2>
          <p>Pre-built database attack patterns for security testing and Guardium validation</p>
        </div>
        <div class="stats-row">
          <div class="stat-card">
            <div class="stat-num" id="totalPatterns">0</div>
            <div class="stat-label">Total Patterns</div>
          </div>
          <div class="stat-card red">
            <div class="stat-num" id="criticalCount">0</div>
            <div class="stat-label">Critical</div>
          </div>
          <div class="stat-card orange">
            <div class="stat-num" id="highCount">0</div>
            <div class="stat-label">High</div>
          </div>
          <div class="stat-card blue">
            <div class="stat-num" id="categoryCount">0</div>
            <div class="stat-label">Categories</div>
          </div>
        </div>
      </div>

      <div class="breadcrumb-bar">
        <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
        <span>&#8250;</span>
        <span>Attack Pattern Library</span>
      </div>

      <div class="section-card" style="margin-top:16px;">
        <div class="section-card-header open" onclick="toggleSectionCard(this)">
          <h5><i class="fa fa-search"></i> Search & Filter</h5>
          <i class="fa fa-chevron-down chevron"></i>
        </div>
        <div class="section-card-body open">
          <div class="search-bar">
            <input type="text" id="searchInput" placeholder="Search patterns by name, description, or tags..." onkeyup="searchPatterns()">
            <select id="severityFilter" onchange="filterBySeverity()" style="min-width:160px;">
              <option value="">All Severities</option>
              <option value="CRITICAL">Critical</option>
              <option value="HIGH">High</option>
              <option value="MEDIUM">Medium</option>
              <option value="LOW">Low</option>
            </select>
          </div>
          <div class="category-tabs" id="categoryTabs">
            <span class="category-tab active" onclick="filterByCategory('', event)">All Categories</span>
          </div>
        </div>
      </div>

      <div id="patternsList" style="margin-top:4px;"></div>

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
    loadCategories();
    loadAllPatterns();
});

let allPatterns = [];
let currentPattern = null;

function loadStatistics() {
    $.ajax({
        url: '/api/library/stats', method: 'GET',
        success: function(response) {
            if (response.success) {
                $('#totalPatterns').text(response.totalPatterns);
                $('#categoryCount').text(response.totalCategories);
                $('#criticalCount').text(response.patternsBySeverity.CRITICAL || 0);
                $('#highCount').text(response.patternsBySeverity.HIGH || 0);
            }
        }
    });
}

function loadCategories() {
    $.ajax({
        url: '/api/library/categories', method: 'GET',
        success: function(response) {
            if (response.success) {
                const tabsContainer = $('#categoryTabs');
                response.categories.forEach(function(cat) {
                    const tab = $('<span class="category-tab">')
                        .attr('onclick', "filterByCategory('" + cat.name + "', event)")
                        .html('<i class="fa fa-tag"></i> ' + cat.name + ' <span style="background:rgba(0,0,0,0.15);border-radius:10px;padding:1px 7px;font-size:0.75rem;">' + cat.count + '</span>');
                    tabsContainer.append(tab);
                });
            }
        }
    });
}

function loadAllPatterns() {
    $.ajax({
        url: '/api/library/patterns', method: 'GET',
        success: function(response) {
            if (response.success) { allPatterns = response.patterns; displayPatterns(allPatterns); }
        },
        error: function() { $('#patternsList').html('<div style="background:#fef2f2;border:1px solid #fca5a5;border-radius:8px;padding:16px;color:#dc2626;"><i class="fa fa-exclamation-circle"></i> Error loading patterns</div>'); }
    });
}

function displayPatterns(patterns) {
    const container = $('#patternsList');
    container.empty();
    if (patterns.length === 0) {
        container.html('<div style="background:#fffbeb;border:1px solid #fcd34d;border-radius:8px;padding:20px;text-align:center;"><i class="fa fa-info-circle" style="color:var(--warning);font-size:24px;"></i><p style="margin:8px 0 0;color:var(--text-muted);">No patterns found</p></div>');
        return;
    }
    patterns.forEach(function(pattern) {
        const desc = pattern.description.length > 150 ? pattern.description.substring(0, 150) + '...' : pattern.description;
        const card = $('<div class="pattern-card severity-' + pattern.severity.toLowerCase() + '">').attr('onclick', "showPatternDetails('" + pattern.id + "')").html(
            '<div class="pattern-card-body">' +
                '<div class="pattern-card-info" style="flex:1;">' +
                    '<h5><i class="fa fa-bug" style="margin-right:8px;color:var(--primary);"></i>' + pattern.name + '</h5>' +
                    '<p>' + desc + '</p>' +
                    '<div class="pattern-tags"></div>' +
                '</div>' +
                '<div style="text-align:right;flex-shrink:0;">' +
                    '<span class="badge badge-' + pattern.severity.toLowerCase() + '">' + pattern.severity + '</span>' +
                    '<p style="font-size:0.78rem;color:var(--text-muted);margin-top:6px;">' + pattern.category + '</p>' +
                '</div>' +
            '</div>'
        );
        const tagsContainer = card.find('.pattern-tags');
        pattern.tags.forEach(function(tag) { tagsContainer.append('<span class="tag">' + tag + '</span>'); });
        container.append(card);
    });
}

function showPatternDetails(patternId) {
    $.ajax({
        url: '/api/library/patterns/' + patternId, method: 'GET',
        success: function(response) {
            if (response.success) { currentPattern = response.pattern; displayPatternDetails(currentPattern); document.getElementById('patternModal').style.display = 'block'; }
        }
    });
}

function displayPatternDetails(pattern) {
    document.getElementById('modalTitle').innerHTML = '<i class="fa fa-bug"></i> ' + pattern.name;
    let content =
        '<div class="info-grid">' +
            '<div class="info-item"><div class="info-key">ID</div><div class="info-val">' + pattern.id + '</div></div>' +
            '<div class="info-item"><div class="info-key">Category</div><div class="info-val">' + pattern.category + '</div></div>' +
            '<div class="info-item"><div class="info-key">Severity</div><div class="info-val"><span class="badge badge-' + pattern.severity.toLowerCase() + '">' + pattern.severity + '</span></div></div>' +
            '<div class="info-item"><div class="info-key">Target Databases</div><div class="info-val" id="target-databases-list"></div></div>' +
        '</div>' +
        '<hr class="divider"><strong>Description</strong><p style="font-size:0.88rem;color:var(--text-muted);margin-top:8px;">' + pattern.description + '</p>' +
        '<hr class="divider"><div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;"><strong>SQL Queries</strong><span style="font-size:0.78rem;color:var(--text-muted);">' + pattern.sqlQueries.length + ' queries</span></div>' +
        '<div id="sql-queries-list"></div>' +
        '<hr class="divider"><strong>Expected Guardium Alert</strong><div class="alert-box" style="margin-top:8px;"><i class="fa fa-bell"></i> ' + pattern.expectedGuardiumAlert + '</div>' +
        '<hr class="divider"><strong>Mitigation</strong><div class="mitigation-box" style="margin-top:8px;"><i class="fa fa-shield"></i> ' + pattern.mitigation + '</div>' +
        '<hr class="divider"><strong>Tags</strong><p id="pattern-tags-list" style="margin-top:8px;"></p>';
    document.getElementById('modalContent').innerHTML = content;
    pattern.targetDatabases.forEach(function(db) { $('#target-databases-list').append('<span class="db-tag">' + db + '</span> '); });
    pattern.sqlQueries.forEach(function(query, idx) { $('#sql-queries-list').append('<div class="sql-block"><span style="color:#94a3b8;font-size:0.75rem;">Query ' + (idx + 1) + '</span><br>' + query + '</div>'); });
    pattern.tags.forEach(function(tag) { $('#pattern-tags-list').append('<span class="tag">' + tag + '</span>'); });
}

function executePattern() {
    if (!currentPattern) { alert('No pattern selected'); return; }
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    $.ajax({
        url: '/api/getDatabaseConnections', type: 'POST', data: jsonData, contentType: 'application/json; charset=utf-8',
        success: function(connections) {
            if (connections.length === 0) { Swal.fire({ icon: 'warning', title: 'No Database Connections', text: 'Please configure database connections first' }); return; }
            const compatibleConnections = connections.filter(conn => currentPattern.targetDatabases.includes(conn.db_type.toLowerCase()));
            if (compatibleConnections.length === 0) { Swal.fire({ icon: 'warning', title: 'No Compatible Databases', text: 'This pattern requires: ' + currentPattern.targetDatabases.join(', ') }); return; }
            let options = '';
            compatibleConnections.forEach(function(conn) {
                options += '<option value="' + conn.db_connection_id + '">' + conn.db_connection_id + ' (' + conn.db_type + ')</option>';
            });
            Swal.fire({
                title: 'Select Target Database',
                html: '<select id="targetDb" class="swal2-input">' + options + '</select><p style="margin-top:15px;color:#ef4444;"><i class="fa fa-warning"></i> <strong>Warning:</strong> This will execute ' + currentPattern.sqlQueries.length + ' SQL queries against the selected database.</p>',
                showCancelButton: true, confirmButtonText: 'Execute', confirmButtonColor: '#ef4444',
                preConfirm: () => document.getElementById('targetDb').value
            }).then((result) => { if (result.isConfirmed) executePatternQueries(result.value); });
        },
        error: function() { Swal.fire({ icon: 'error', title: 'Error', text: 'Failed to load database connections' }); }
    });
}

function executePatternQueries(dbConnectionId) {
    const jwtToken = '${tokenObject.jwt}';
    Swal.fire({ title: 'Executing Pattern', html: 'Executing ' + currentPattern.sqlQueries.length + ' queries...<br><div id="progress"></div>', allowOutsideClick: false, didOpen: () => { Swal.showLoading(); } });
    let completed = 0, results = [];
    currentPattern.sqlQueries.forEach((query, index) => {
        $.ajax({
            url: '/api/runDatabaseQueryByDatasourceMap', type: 'POST',
            data: JSON.stringify({
                jwt: jwtToken,
                datasource: dbConnectionId,
                sql: query,
                query_loop: "1"
            }),
            contentType: 'application/json; charset=utf-8',
            success: function(response) {
                console.log('Query ' + (index + 1) + ' response:', response);
                results.push({ query: index + 1, status: 'success', response: response });
                completed++;
                checkCompletion();
            },
            error: function(err) {
                console.error('Query ' + (index + 1) + ' error:', err);
                results.push({ query: index + 1, status: 'error', error: err.responseText });
                completed++;
                checkCompletion();
            }
        });
    });
    function checkCompletion() {
        $('#progress').html(completed + ' / ' + currentPattern.sqlQueries.length + ' queries completed');
        if (completed === currentPattern.sqlQueries.length) {
            const successCount = results.filter(r => r.status === 'success').length;
            const errorCount = results.filter(r => r.status === 'error').length;
            
            // Build detailed results HTML with JSON data
            let resultsHtml = '<div style="text-align:left;max-height:400px;overflow-y:auto;">';
            resultsHtml += '<p><strong>Pattern:</strong> ' + currentPattern.name + '</p>';
            resultsHtml += '<p><strong>Successful:</strong> ' + successCount + ' | <strong>Failed:</strong> ' + errorCount + '</p>';
            resultsHtml += '<hr style="margin:10px 0;">';
            
            results.forEach((result, idx) => {
                resultsHtml += '<div style="margin-bottom:15px;padding:10px;background:#f8f9fa;border-radius:5px;">';
                resultsHtml += '<strong>Query ' + result.query + ':</strong> ';
                resultsHtml += '<span style="color:' + (result.status === 'success' ? '#10b981' : '#ef4444') + ';">' + result.status.toUpperCase() + '</span>';
                resultsHtml += '<div style="margin-top:5px;"><code style="font-size:11px;">' + currentPattern.sqlQueries[idx] + '</code></div>';
                
                if (result.status === 'success' && result.response) {
                    // Display JSON results if available
                    try {
                        let jsonData = result.response;
                        if (typeof jsonData === 'string') {
                            jsonData = JSON.parse(jsonData);
                        }
                        
                        // Response structure: [[{Result: [...], SQL: "...", loopIndex: 0}]]
                        // Extract the actual data
                        let actualData = null;
                        
                        if (Array.isArray(jsonData) && jsonData.length > 0) {
                            // Unwrap nested arrays
                            let innerData = jsonData[0];
                            if (Array.isArray(innerData) && innerData.length > 0) {
                                let queryResult = innerData[0];
                                if (queryResult.Result) {
                                    actualData = queryResult.Result;
                                }
                            }
                        }
                        
                        // Display the results
                        if (actualData && Array.isArray(actualData) && actualData.length > 0) {
                            resultsHtml += '<div style="margin-top:8px;"><strong>Results (' + actualData.length + ' rows):</strong></div>';
                            resultsHtml += '<pre style="background:#1e293b;color:#e2e8f0;padding:10px;border-radius:4px;font-size:11px;max-height:200px;overflow:auto;">';
                            resultsHtml += JSON.stringify(actualData.slice(0, 5), null, 2); // Show first 5 rows
                            if (actualData.length > 5) {
                                resultsHtml += '\n\n... (' + (actualData.length - 5) + ' more rows)';
                            }
                            resultsHtml += '</pre>';
                        } else if (actualData && Array.isArray(actualData) && actualData.length === 0) {
                            resultsHtml += '<div style="margin-top:5px;color:#6b7280;"><em>Query executed successfully (0 rows returned)</em></div>';
                        } else {
                            resultsHtml += '<div style="margin-top:5px;color:#6b7280;"><em>Query executed successfully</em></div>';
                        }
                    } catch (e) {
                        console.error('Error parsing response:', e);
                        resultsHtml += '<div style="margin-top:5px;color:#ef4444;"><em>Error parsing results: ' + e.message + '</em></div>';
                    }
                } else if (result.status === 'error') {
                    resultsHtml += '<div style="margin-top:5px;color:#ef4444;"><strong>Error:</strong> ' + (result.error || 'Unknown error') + '</div>';
                }
                resultsHtml += '</div>';
            });
            
            resultsHtml += '<hr style="margin:10px 0;">';
            resultsHtml += '<p style="color:var(--info);"><i class="fa fa-info-circle"></i> Check Guardium for alert: <strong>' + currentPattern.expectedGuardiumAlert + '</strong></p>';
            resultsHtml += '</div>';
            
            Swal.fire({
                icon: successCount > 0 ? 'success' : 'error',
                title: 'Execution Complete',
                html: resultsHtml,
                width: '800px',
                customClass: {
                    popup: 'attack-results-modal'
                }
            });
        }
    }
}

function searchPatterns() {
    const query = $('#searchInput').val();
    if (query.length < 2) { displayPatterns(allPatterns); return; }
    $.ajax({
        url: '/api/library/search?q=' + encodeURIComponent(query), method: 'GET',
        success: function(response) { if (response.success) displayPatterns(response.patterns); }
    });
}

function filterByCategory(category, event) {
    $('.category-tab').removeClass('active');
    if (event && event.target) event.target.classList.add('active');
    if (category === '') { displayPatterns(allPatterns); return; }
    $.ajax({
        url: '/api/library/categories/' + encodeURIComponent(category) + '/patterns', method: 'GET',
        success: function(response) { if (response.success) displayPatterns(response.patterns); }
    });
}

function filterBySeverity() {
    const severity = $('#severityFilter').val();
    if (severity === '') { displayPatterns(allPatterns); return; }
    $.ajax({
        url: '/api/library/severity/' + severity + '/patterns', method: 'GET',
        success: function(response) { if (response.success) displayPatterns(response.patterns); }
    });
}

window.onclick = function(event) {
    const modal = document.getElementById('patternModal');
    if (modal && event.target == modal) modal.style.display = 'none';
};
</script>

<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>

<!-- Pattern Detail Modal -->
<div id="patternModal" class="modern-modal">
  <div class="modern-modal-content">
    <div class="modal-header-modern">
      <h3 id="modalTitle"><i class="fa fa-bug"></i> Pattern Details</h3>
      <button class="modal-close-btn" onclick="document.getElementById('patternModal').style.display='none'">&times;</button>
    </div>
    <div class="modal-body" id="modalContent"></div>
    <div class="modal-footer-modern">
      <button class="btn btn-danger" onclick="executePattern()"><i class="fa fa-play"></i> Execute Pattern</button>
      <button class="btn btn-secondary" onclick="document.getElementById('patternModal').style.display='none'">Close</button>
    </div>
  </div>
</div>

</body>
</html>
