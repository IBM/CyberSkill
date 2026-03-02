<!DOCTYPE html>
<html>
<head>
<title>Guardium Data - SLP</title>
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
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="js/datatables.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 { font-family: "Roboto", sans-serif; }

/* ── Page Header ── */
.page-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  border-radius: 12px;
  padding: 1.5rem 2rem;
  margin-bottom: 1.5rem;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
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
.section-card-body { padding: 1.25rem 1.5rem; }

/* ── Info Banner ── */
.info-banner {
  background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px;
  padding: 0.75rem 1rem; color: #1e40af; font-size: 0.85rem; margin-bottom: 1rem;
  display: flex; align-items: center; gap: 0.5rem;
}

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
  background: white; border-radius: 16px; width: 85%; max-width: 1000px;
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
.btn-close-modal {
  background: #f1f5f9; color: #374151; border: 1px solid #d1d5db;
  padding: 0.5rem 1.25rem; border-radius: 8px; cursor: pointer; font-size: 0.875rem;
  font-weight: 500; transition: all 0.2s;
}
.btn-close-modal:hover { background: #e2e8f0; }

/* ── Chart Container ── */
#chart_div { width: 100%; height: 400px; margin-top: 1rem; }
#id_Area_Chart_div { width: 100%; height: 400px; }

/* ── Click hint ── */
.click-hint {
  display: inline-flex; align-items: center; gap: 0.4rem;
  background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0;
  border-radius: 20px; padding: 0.3rem 0.75rem; font-size: 0.78rem; font-weight: 500;
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
            <span><i class="fa fa-shield"></i> Guardium Data</span>
          </div>

          <!-- Page Header -->
          <div class="page-header">
            <div>
              <div class="page-header-title"><i class="fa fa-shield" style="margin-right:0.5rem;"></i>Guardium Data Monitor</div>
              <div class="page-header-subtitle">Real-time Guardium source monitoring, message statistics and anomaly detection</div>
            </div>
            <div class="page-header-icon"><i class="fa fa-bar-chart"></i></div>
          </div>

          <!-- Info Banner -->
          <div class="info-banner">
            <i class="fa fa-info-circle"></i>
            <span>Click any row to drill down into message statistics. Click a hash row to view anomaly charts.</span>
            <span class="click-hint" style="margin-left:auto;"><i class="fa fa-hand-pointer-o"></i> Row click to explore</span>
          </div>

          <!-- Guardium Sources Table -->
          <div class="section-card">
            <div class="section-card-header">
              <h3 class="section-card-title"><i class="fa fa-database"></i> Guardium Sources</h3>
              <span style="background:rgba(255,255,255,0.2);color:white;border-radius:20px;padding:3px 12px;font-size:0.78rem;">
                <i class="fa fa-circle" style="color:#10b981;font-size:0.6rem;"></i> Live
              </span>
            </div>
            <div class="section-card-body">
              <table id="example" class="display" style="width:100%">
                <thead>
                  <tr>
                    <th>Runtime</th>
                    <th>Internal ID</th>
                    <th>DB User</th>
                    <th>Server IP</th>
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

<!-- ── Modal: Source by Internal ID ── -->
<div id="id_edit_modal" class="modern-modal-overlay">
  <div class="modern-modal">
    <div class="modern-modal-header">
      <h3><i class="fa fa-search" style="margin-right:0.5rem;"></i>Data by Internal ID</h3>
      <button class="modern-modal-close" onclick="document.getElementById('id_edit_modal').classList.remove('active')">&times;</button>
    </div>
    <div class="modern-modal-body">
      <div class="info-banner" style="margin-bottom:1rem;">
        <i class="fa fa-info-circle"></i> Click a row to view message hash statistics and anomaly charts.
      </div>
      <table id="SOURCE_INTERNAL_ID_TBL" class="display" style="width:100%">
        <thead>
          <tr>
            <th>Runtime</th>
            <th>Internal ID</th>
            <th>Message ID Hash</th>
            <th>DB User</th>
            <th>Server IP</th>
            <th>Verb</th>
            <th>Date Created</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>
    <div class="modern-modal-footer">
      <button class="btn-close-modal" onclick="document.getElementById('id_edit_modal').classList.remove('active')">
        <i class="fa fa-times" style="margin-right:0.4rem;"></i>Close
      </button>
    </div>
  </div>
</div>

<!-- ── Modal: Message Hash Stats ── -->
<div id="id_messageHash_modal" class="modern-modal-overlay">
  <div class="modern-modal">
    <div class="modern-modal-header">
      <h3><i class="fa fa-hashtag" style="margin-right:0.5rem;"></i>Data by Hash ID</h3>
      <button class="modern-modal-close" onclick="document.getElementById('id_messageHash_modal').classList.remove('active')">&times;</button>
    </div>
    <div class="modern-modal-body">
      <div class="info-banner" style="margin-bottom:1rem;">
        <i class="fa fa-info-circle"></i> Click a row to view the anomaly area chart for that message hash.
      </div>
      <table id="MESSAGE_ID_HASH_TBL" class="display" style="width:100%">
        <thead>
          <tr>
            <th>Runtime</th>
            <th>Message ID Hash</th>
            <th>Internal ID</th>
            <th>Average</th>
            <th>Std Deviation</th>
            <th>Threshold</th>
            <th>Verb</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
      <div id="chart_div"></div>
    </div>
    <div class="modern-modal-footer">
      <button class="btn-close-modal" onclick="document.getElementById('id_messageHash_modal').classList.remove('active')">
        <i class="fa fa-times" style="margin-right:0.4rem;"></i>Close
      </button>
    </div>
  </div>
</div>

<!-- ── Modal: Area Chart ── -->
<div id="id_Area_Chart_Modal" class="modern-modal-overlay">
  <div class="modern-modal">
    <div class="modern-modal-header">
      <h3><i class="fa fa-area-chart" style="margin-right:0.5rem;"></i>Anomaly Chart</h3>
      <button class="modern-modal-close" onclick="document.getElementById('id_Area_Chart_Modal').classList.remove('active')">&times;</button>
    </div>
    <div class="modern-modal-body">
      <div id="id_Area_Chart_div"></div>
    </div>
    <div class="modern-modal-footer">
      <button class="btn-close-modal" onclick="document.getElementById('id_Area_Chart_Modal').classList.remove('active')">
        <i class="fa fa-times" style="margin-right:0.4rem;"></i>Close
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

  // Init main table and load data
  getMonitorGuardiumSources();

  const table = $('#example').DataTable();
  table.on('click', 'tbody tr', function() {
    const internalId = table.row(this).data()[1];
    console.log('Selected internal ID:', internalId);
    getMonitorGuardiumSourceMessageStatById(internalId);
  });
});

// Load Google Charts
google.charts.load('current', { packages: ['corechart'] });
google.charts.setOnLoadCallback(() => console.log('Google Charts loaded'));

function getMonitorGuardiumSources() {
  const table = $('#example').DataTable();
  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken });

  $.ajax({
    url: '/api/monitor/getMonitorGuardiumSources',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      table.clear();
      response.forEach(item => {
        table.row.add([item.runtime, item.source_internal_id, item.sources.DB_USER, item.sources.SERVER_IP]);
      });
      table.draw();
    },
    error: function(xhr, status, error) {
      console.error('Error loading Guardium sources:', error);
    }
  });
}

function getMonitorGuardiumSourceMessageStatById(source_internal_id) {
  console.log('getMonitorGuardiumSourceMessageStatById:', source_internal_id);

  const table = $('#SOURCE_INTERNAL_ID_TBL').DataTable();
  table.off('click', 'tbody tr');
  table.on('click', 'tbody tr', function() {
    const hash = table.row(this).data()[2];
    console.log('Selected hash:', hash);
    getMonitorGuardiumDataByMessageIdHash(hash);
  });

  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken, SOURCE_INTERNAL_ID: source_internal_id });

  $.ajax({
    url: '/api/monitor/getMonitorGuardiumSourceMessageStatById',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      table.clear();
      response.forEach(item => {
        table.row.add([
          item.runtime, item.source_internal_id, item.message_id_hash,
          item.source_message_stats.DB_USER, item.source_message_stats.SERVER_IP,
          item.source_message_stats.VERB, item.source_message_stats.DATE_CREATED
        ]);
      });
      table.draw();
      document.getElementById('id_edit_modal').classList.add('active');
    },
    error: function(xhr, status, error) {
      console.error('Error loading message stats:', error);
    }
  });
}

function getMonitorGuardiumDataByMessageIdHash(message_id_hash) {
  console.log('getMonitorGuardiumDataByMessageIdHash:', message_id_hash);

  const table = $('#MESSAGE_ID_HASH_TBL').DataTable();
  table.off('click', 'tbody tr');
  table.on('click', 'tbody tr', function() {
    const rowData = table.row(this).data();
    const selectedHash = rowData[1];
    const internalId = rowData[2];
    console.log('Chart for hash:', selectedHash, 'internal:', internalId);
    fetchDataAndDrawChart(selectedHash, internalId);
    fetchChartData(selectedHash);
  });

  const jwtToken = '${tokenObject.jwt}';
  const jsonData = JSON.stringify({ jwt: jwtToken, MESSAGE_ID_HASH: message_id_hash });

  $.ajax({
    url: '/api/monitor/getMonitorGuardiumDataByMessageIdHash',
    type: 'POST',
    data: jsonData,
    contentType: 'application/json; charset=utf-8',
    success: function(response) {
      table.clear();
      response.forEach(item => {
        table.row.add([
          item.runtime, item.message_id_hash, item.source_internal_id,
          item.average, item.standard_deviation, item.threshold, item.verb
        ]);
      });
      table.draw();
      document.getElementById('id_edit_modal').classList.remove('active');
      document.getElementById('id_messageHash_modal').classList.add('active');
    },
    error: function(xhr, status, error) {
      console.error('Error loading hash data:', error);
    }
  });
}

function fetchDataAndDrawChart(var_message_id_hash, var_internal_id) {
  console.log('fetchDataAndDrawChart hash:', var_message_id_hash, 'internal:', var_internal_id);
  const jwtToken = '${tokenObject.jwt}';
  const payload = JSON.stringify({
    jwt: jwtToken,
    MESSAGE_ID_HASH: var_message_id_hash,
    SOURCE_INTERNAL_ID: var_internal_id
  });

  fetch('/api/monitor/getMonitorGuardiumDataByMessageIdHashAndInternalId', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: payload
  })
  .then(r => r.json())
  .then(data => { createChart(data); })
  .catch(error => { console.error('Chart fetch error:', error); });
}

function createChart(jsonData) {
  console.log('Creating chart');
  var data = new google.visualization.DataTable();
  data.addColumn('datetime', 'Runtime');
  data.addColumn('number', 'Average');
  data.addColumn('number', 'Std Deviation');
  data.addColumn('number', 'Threshold');

  jsonData.forEach(item => {
    data.addRow([new Date(item.runtime), item.average, item.standard_deviation, item.threshold]);
  });

  var options = {
    title: 'Anomaly Statistics Over Time',
    titleTextStyle: { color: '#1e293b', fontSize: 14, bold: true },
    hAxis: { title: 'Runtime', titleTextStyle: { color: '#64748b' } },
    vAxis: { titleTextStyle: { color: '#64748b' } },
    colors: ['#4d636f', '#f59e0b', '#ef4444'],
    areaOpacity: 0.15,
    legend: { position: 'bottom' },
    chartArea: { width: '85%', height: '70%' },
    backgroundColor: 'transparent'
  };

  var chart = new google.visualization.AreaChart(document.getElementById('chart_div'));
  chart.draw(data, options);
}

// Stub for fetchChartData if needed
function fetchChartData(hash) {
  console.log('fetchChartData for hash:', hash);
}
</script>

<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>
</body>
</html>
