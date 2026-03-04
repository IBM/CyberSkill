<!DOCTYPE html>
<html>
<head>
<title>Scheduler - SLP</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/loggedIn/css/w3.css">
<link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">
<link rel="stylesheet" href="/loggedIn/css/navbar-fix.css">
<link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">
<link rel="stylesheet" href="/loggedIn/css/fonts.css">
<link rel="stylesheet" href="/loggedIn/css/contentpacks-modern.css">
<script src="/loggedIn/js/jquery.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: Roboto, sans-serif}

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

.coming-soon-card {
    text-align: center;
    padding: 4rem 2rem;
    color: #64748b;
}
.coming-soon-icon {
    font-size: 4rem;
    color: #4d636f;
    opacity: 0.4;
    margin-bottom: 1.5rem;
}
.coming-soon-title {
    font-size: 1.5rem;
    font-weight: 700;
    color: #1e293b;
    margin-bottom: 0.75rem;
}
.coming-soon-text {
    font-size: 0.95rem;
    color: #64748b;
    max-width: 500px;
    margin: 0 auto 2rem auto;
    line-height: 1.6;
}

.feature-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1rem;
    margin-top: 2rem;
    text-align: left;
}

.feature-item {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    padding: 1.25rem;
    display: flex;
    align-items: flex-start;
    gap: 0.75rem;
}

.feature-item-icon {
    width: 36px;
    height: 36px;
    background: linear-gradient(135deg, #4d636f, #3a4f5a);
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 0.9rem;
    flex-shrink: 0;
}

.feature-item-title {
    font-weight: 600;
    color: #1e293b;
    font-size: 0.9rem;
    margin-bottom: 0.25rem;
}

.feature-item-text {
    font-size: 0.8rem;
    color: #64748b;
    line-height: 1.4;
}

.info-alert {
    background: #eff6ff;
    border: 1px solid #bfdbfe;
    border-left: 4px solid #3b82f6;
    border-radius: 8px;
    padding: 1rem 1.25rem;
    color: #1e40af;
    font-size: 0.875rem;
    line-height: 1.6;
    margin-top: 1.5rem;
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
            <div class="w3-container w3-padding">

              <!-- Breadcrumb -->
              <div class="breadcrumb-bar">
                <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
                <span class="separator">›</span>
                <span class="current"><i class="fa fa-calendar"></i> Scheduler</span>
              </div>

              <!-- Page Header -->
              <div class="page-header">
                <h4><i class="fa fa-calendar"></i> Scheduler</h4>
                <p>Schedule and automate story execution, database queries, and system tasks</p>
              </div>

              <!-- Coming Soon Content -->
              <div class="coming-soon-card">
                <div class="coming-soon-icon">
                  <i class="fa fa-calendar-check-o"></i>
                </div>
                <div class="coming-soon-title">Scheduler Coming Soon</div>
                <div class="coming-soon-text">
                  The Scheduler feature is currently under development. It will allow you to automate
                  story execution, schedule database queries, and manage recurring tasks with cron-style
                  scheduling.
                </div>

                <div class="feature-grid">
                  <div class="feature-item">
                    <div class="feature-item-icon"><i class="fa fa-clock-o"></i></div>
                    <div>
                      <div class="feature-item-title">Cron Scheduling</div>
                      <div class="feature-item-text">Schedule tasks using familiar cron expressions</div>
                    </div>
                  </div>
                  <div class="feature-item">
                    <div class="feature-item-icon"><i class="fa fa-book"></i></div>
                    <div>
                      <div class="feature-item-title">Story Automation</div>
                      <div class="feature-item-text">Automatically run stories at defined intervals</div>
                    </div>
                  </div>
                  <div class="feature-item">
                    <div class="feature-item-icon"><i class="fa fa-database"></i></div>
                    <div>
                      <div class="feature-item-title">Query Scheduling</div>
                      <div class="feature-item-text">Schedule database queries for periodic execution</div>
                    </div>
                  </div>
                  <div class="feature-item">
                    <div class="feature-item-icon"><i class="fa fa-bell"></i></div>
                    <div>
                      <div class="feature-item-title">Notifications</div>
                      <div class="feature-item-text">Get notified when scheduled tasks complete</div>
                    </div>
                  </div>
                </div>

                <div class="info-alert" style="text-align:left;">
                  <i class="fa fa-info-circle"></i>
                  <strong>In the meantime:</strong> Use the <a href="/loggedIn/outliers.ftl" style="color:#1e40af; font-weight:600;">Outliers</a> page
                  to manage and schedule bash/Windows scripts for automated execution.
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
