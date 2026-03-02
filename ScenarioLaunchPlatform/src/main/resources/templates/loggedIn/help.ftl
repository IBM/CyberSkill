<!DOCTYPE html>
<html>
<head>
<title>Help - SLP</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel='stylesheet' href='css/fonts.css'>
<link rel="stylesheet" href="css/contentpacks-modern.css">
<script src="js/jquery.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}

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

/* Help accordion card */
.help-card {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    margin-bottom: 0.75rem;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    transition: box-shadow 0.2s ease;
}

.help-card:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.help-card-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 1rem 1.25rem;
    cursor: pointer;
    user-select: none;
    transition: background 0.15s ease;
}

.help-card-header:hover {
    background: #f8fafc;
}

.help-card-header.open {
    background: #f1f5f9;
    border-bottom: 1px solid #e2e8f0;
}

.help-card-title {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-weight: 600;
    color: #1e293b;
    font-size: 0.95rem;
}

.help-card-icon {
    width: 32px;
    height: 32px;
    background: linear-gradient(135deg, #4d636f, #3a4f5a);
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 0.85rem;
    flex-shrink: 0;
}

.help-card-chevron {
    color: #94a3b8;
    transition: transform 0.2s ease;
    font-size: 0.9rem;
}

.help-card-chevron.open {
    transform: rotate(180deg);
}

.help-card-body {
    display: none;
    padding: 1.25rem;
    border-top: 1px solid #f1f5f9;
    animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-4px); }
    to   { opacity: 1; transform: translateY(0); }
}

.help-card-body h2 {
    font-size: 1.1rem;
    font-weight: 700;
    color: #1e293b;
    margin: 0 0 0.5rem 0;
}

.help-card-body p {
    color: #475569;
    font-size: 0.9rem;
    margin-bottom: 1rem;
    line-height: 1.6;
}

.help-card-body .help-content {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 1rem;
    font-size: 0.875rem;
    color: #374151;
    line-height: 1.7;
}

/* Loading state */
.help-loading {
    text-align: center;
    padding: 3rem 2rem;
    color: #64748b;
}

/* Quick links */
.quick-links {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 0.75rem;
    margin-bottom: 1.5rem;
}

.quick-link-card {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    padding: 1rem;
    text-align: center;
    cursor: pointer;
    transition: all 0.2s ease;
    text-decoration: none;
    color: inherit;
    display: block;
}

.quick-link-card:hover {
    background: white;
    border-color: #4d636f;
    box-shadow: 0 4px 12px rgba(77, 99, 111, 0.15);
    transform: translateY(-2px);
    color: inherit;
    text-decoration: none;
}

.quick-link-icon {
    font-size: 1.5rem;
    color: #4d636f;
    margin-bottom: 0.5rem;
}

.quick-link-title {
    font-weight: 600;
    font-size: 0.85rem;
    color: #1e293b;
}

.quick-link-text {
    font-size: 0.75rem;
    color: #64748b;
    margin-top: 0.2rem;
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

              <!-- Breadcrumb -->
              <div class="breadcrumb-bar">
                <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
                <span class="separator">›</span>
                <span class="current"><i class="fa fa-question-circle"></i> Help</span>
              </div>

              <!-- Page Header -->
              <div class="page-header">
                <h4><i class="fa fa-question-circle"></i> Help & Documentation</h4>
                <p>Find answers, guides, and documentation for the Scenario Launch Platform</p>
              </div>

              <!-- Quick Links -->
              <div class="quick-links">
                <a href="/loggedIn/contentpacks.ftl" class="quick-link-card">
                  <div class="quick-link-icon"><i class="fa fa-cube"></i></div>
                  <div class="quick-link-title">Content Packs</div>
                  <div class="quick-link-text">Manage story packs</div>
                </a>
                <a href="/loggedIn/databases.ftl" class="quick-link-card">
                  <div class="quick-link-icon"><i class="fa fa-database"></i></div>
                  <div class="quick-link-title">Databases</div>
                  <div class="quick-link-text">SQL queries & connections</div>
                </a>
                <a href="/loggedIn/settings.ftl" class="quick-link-card">
                  <div class="quick-link-icon"><i class="fa fa-cog"></i></div>
                  <div class="quick-link-title">Settings</div>
                  <div class="quick-link-text">Configure connections</div>
                </a>
                <a href="/loggedIn/outliers.ftl" class="quick-link-card">
                  <div class="quick-link-icon"><i class="fa fa-clock-o"></i></div>
                  <div class="quick-link-title">Outliers</div>
                  <div class="quick-link-text">Scheduled scripts</div>
                </a>
                <a href="/loggedIn/documents/SLPHandbook.pdf" target="_blank" class="quick-link-card">
                  <div class="quick-link-icon"><i class="fa fa-file-pdf-o"></i></div>
                  <div class="quick-link-title">SLP Handbook</div>
                  <div class="quick-link-text">Full documentation PDF</div>
                </a>
              </div>

              <!-- Help Content (loaded from JSON) -->
              <div id="helpContent">
                <div class="help-loading">
                  <i class="fa fa-spinner fa-spin" style="font-size:2rem; color:#4d636f;"></i>
                  <p style="margin-top:1rem;">Loading help content...</p>
                </div>
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

<!-- Footer -->
<div id="footer"></div>

<script>
$(document).ready(function() {
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
});

function toggleHelpId(id) {
    const body = document.getElementById('helpBody' + id);
    const chevron = document.getElementById('helpChevron' + id);
    const header = document.getElementById('helpHeader' + id);

    if (!body) return;

    const isOpen = body.style.display === 'block';
    body.style.display = isOpen ? 'none' : 'block';

    if (chevron) chevron.classList.toggle('open', !isOpen);
    if (header) header.classList.toggle('open', !isOpen);
}

function buildHelp(data) {
    console.log(data.help);

    var helpContent = document.getElementById("helpContent");
    helpContent.innerHTML = '';

    if (!data.help || data.help.length === 0) {
        helpContent.innerHTML =
            '<div style="text-align:center; padding:3rem; color:#64748b;">' +
            '<i class="fa fa-info-circle" style="font-size:2rem; opacity:0.4;"></i>' +
            '<p style="margin-top:1rem;">No help content available.</p>' +
            '</div>';
        return;
    }

    var icons = ['fa-book', 'fa-database', 'fa-cog', 'fa-code', 'fa-shield', 'fa-clock-o', 'fa-users', 'fa-chart-bar', 'fa-plug', 'fa-file-text'];

    for (var i = 0; i < data.help.length; i++) {
        var item = data.help[i];
        var title = item.Title || 'Help Topic ' + (i + 1);
        var subtitle = item.Subtitle || '';
        var subtext = item.Subtext || '';
        var helptext = item.Helptext || '';
        var icon = icons[i % icons.length];

        var cardHtml =
            '<div class="help-card">' +
            '<div class="help-card-header" id="helpHeader' + i + '" onclick="toggleHelpId(' + i + ')">' +
            '<div class="help-card-title">' +
            '<div class="help-card-icon"><i class="fa ' + icon + '"></i></div>' +
            title +
            '</div>' +
            '<i class="fa fa-chevron-down help-card-chevron" id="helpChevron' + i + '"></i>' +
            '</div>' +
            '<div class="help-card-body" id="helpBody' + i + '">' +
            (subtitle ? '<h2>' + subtitle + '</h2>' : '') +
            (subtext ? '<p>' + subtext + '</p>' : '') +
            (helptext ? '<div class="help-content">' + helptext + '</div>' : '') +
            '</div>' +
            '</div>';

        helpContent.insertAdjacentHTML("beforeend", cardHtml);
    }
}

function fetchJSONData() {
    fetch('/js/help.json')
        .then(function(response) { return response.json(); })
        .then(function(data) { buildHelp(data); })
        .catch(function(error) {
            console.error("Failed to fetch data: " + error);
            document.getElementById("helpContent").innerHTML =
                '<div style="text-align:center; padding:3rem; color:#ef4444;">' +
                '<i class="fa fa-exclamation-triangle" style="font-size:2rem;"></i>' +
                '<p style="margin-top:1rem;">Failed to load help content. Please try refreshing the page.</p>' +
                '</div>';
        });
}

fetchJSONData();

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
</script>

<!-- SweetAlert2 and notification script -->
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>
</body>
</html>
