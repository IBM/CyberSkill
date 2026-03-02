<!DOCTYPE html>
<html>
<head>
<title>Power User - SLP</title>
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

/* Page header */
.page-header {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
}

.page-header h4 {
    margin: 0 0 0.4rem 0;
    font-size: 1.3rem;
    font-weight: 700;
}

.page-header p {
    margin: 0;
    opacity: 0.85;
    font-size: 0.9rem;
}

/* Info card */
.info-card {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1.25rem;
    margin-bottom: 1.25rem;
}

.info-card-title {
    font-size: 0.8rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: #64748b;
    margin-bottom: 0.75rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

/* JWT token display */
.jwt-display {
    background: #1e293b;
    color: #94a3b8;
    border-radius: 8px;
    padding: 1rem 1.25rem;
    font-family: 'Courier New', monospace;
    font-size: 0.8rem;
    line-height: 1.6;
    word-break: break-all;
    position: relative;
    border: 1px solid #334155;
}

.jwt-display .jwt-part-header { color: #f59e0b; }
.jwt-display .jwt-part-payload { color: #10b981; }
.jwt-display .jwt-part-signature { color: #3b82f6; }

.copy-btn {
    position: absolute;
    top: 0.75rem;
    right: 0.75rem;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    color: #94a3b8;
    padding: 0.3rem 0.75rem;
    border-radius: 6px;
    font-size: 0.75rem;
    cursor: pointer;
    transition: all 0.2s;
}

.copy-btn:hover {
    background: rgba(255,255,255,0.2);
    color: white;
}

/* Form section */
.form-section {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.25rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.form-section-title {
    font-size: 1rem;
    font-weight: 600;
    color: #1e293b;
    margin-bottom: 1.25rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid #f1f5f9;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.form-group {
    margin-bottom: 1rem;
}

.form-label {
    display: block;
    font-size: 0.875rem;
    font-weight: 600;
    color: #374151;
    margin-bottom: 0.4rem;
}

.form-input {
    width: 100%;
    padding: 0.65rem 1rem;
    border: 2px solid #e2e8f0;
    border-radius: 8px;
    font-size: 0.9rem;
    transition: all 0.2s;
    background: white;
    color: #1e293b;
    box-sizing: border-box;
}

.form-input:focus {
    outline: none;
    border-color: #4d636f;
    box-shadow: 0 0 0 3px rgba(77, 99, 111, 0.1);
}

.btn-primary {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.65rem 1.5rem;
    background: #4d636f;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
}

.btn-primary:hover {
    background: #3a4f5a;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(77, 99, 111, 0.3);
}

/* Alert box */
.info-alert {
    background: #eff6ff;
    border: 1px solid #bfdbfe;
    border-left: 4px solid #3b82f6;
    border-radius: 8px;
    padding: 1rem 1.25rem;
    color: #1e40af;
    font-size: 0.875rem;
    line-height: 1.6;
}

.info-alert i {
    margin-right: 0.5rem;
}

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

.breadcrumb-bar a {
    color: #4d636f;
    text-decoration: none;
    font-weight: 500;
}

.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar .separator { color: #94a3b8; }
.breadcrumb-bar .current { color: #64748b; }
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
                <span class="current"><i class="fa fa-user"></i> Power User</span>
              </div>

              <!-- Page Header -->
              <div class="page-header">
                <h4><i class="fa fa-user-secret"></i> Power User</h4>
                <p>Manage your JWT authentication tokens and API access credentials</p>
              </div>

              <!-- Current JWT Token -->
              <div class="form-section">
                <div class="form-section-title">
                  <i class="fa fa-key" style="color:#4d636f;"></i>
                  Current JWT Token
                </div>

                <div class="info-card-title">
                  <i class="fa fa-lock"></i> Your Active Token
                </div>
                <div class="jwt-display" id="jwtDisplayBox">
                  <button class="copy-btn" onclick="copyJwt()">
                    <i class="fa fa-copy"></i> Copy
                  </button>
                  <span id="myJwtToken" contenteditable="true">${tokenObject.jwt}</span>
                </div>
                <p style="font-size:0.8rem; color:#94a3b8; margin-top:0.5rem;">
                  <i class="fa fa-info-circle"></i> Click the token to edit it manually, or generate a new one below.
                </p>
              </div>

              <!-- Generate JWT Token -->
              <div class="form-section">
                <div class="form-section-title">
                  <i class="fa fa-refresh" style="color:#4d636f;"></i>
                  Generate New JWT Token
                </div>

                <div class="form-group">
                  <label class="form-label" for="username">Username</label>
                  <input type="text" id="username" name="username" class="form-input" placeholder="Enter username...">
                </div>

                <div class="form-group">
                  <label class="form-label" for="password">Password</label>
                  <input type="password" id="password" name="password" class="form-input" placeholder="Enter password...">
                </div>

                <button type="button" class="btn-primary" onclick="validate()">
                  <i class="fa fa-key"></i> Generate Token
                </button>

                <div id="generateResult" style="margin-top:1rem; display:none;"></div>
              </div>

              <!-- Info Box -->
              <div class="info-alert">
                <i class="fa fa-info-circle"></i>
                <strong>About JWT Tokens:</strong> JWT tokens currently do not expire. This allows you to create scripts
                that leverage the APIs without needing to re-authenticate. Your scripts will continue to function with
                their first JWT token. However, good practice suggests you factor in the need to regenerate JWTs in the
                future should security requirements change.
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

function validate() {
    const var_username = $('#username').val();
    const var_password = $('#password').val();

    if (!var_username || !var_password) {
        $('#generateResult').show().html(
            '<div style="background:#fee2e2; border:1px solid #fca5a5; border-radius:8px; padding:0.75rem 1rem; color:#991b1b; font-size:0.875rem;">' +
            '<i class="fa fa-exclamation-triangle"></i> Please enter both username and password.' +
            '</div>'
        );
        return;
    }

    const jsonData = JSON.stringify({
        username: var_username,
        password: var_password
    });

    $('#generateResult').show().html(
        '<div style="color:#64748b; font-size:0.875rem;"><i class="fa fa-spinner fa-spin"></i> Generating token...</div>'
    );

    $.ajax({
        url: '/api/validateCredentials',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            console.log(response);
            document.getElementById("myJwtToken").innerHTML = response.jwt;
            $('#generateResult').html(
                '<div style="background:#d1fae5; border:1px solid #6ee7b7; border-radius:8px; padding:0.75rem 1rem; color:#065f46; font-size:0.875rem;">' +
                '<i class="fa fa-check-circle"></i> New JWT token generated successfully!' +
                '</div>'
            );
        },
        error: function(xhr, status, error) {
            $('#generateResult').html(
                '<div style="background:#fee2e2; border:1px solid #fca5a5; border-radius:8px; padding:0.75rem 1rem; color:#991b1b; font-size:0.875rem;">' +
                '<i class="fa fa-times-circle"></i> Error generating token: ' + error +
                '</div>'
            );
        }
    });
}

function copyJwt() {
    const jwtText = document.getElementById('myJwtToken').innerText;
    navigator.clipboard.writeText(jwtText).then(function() {
        const btn = document.querySelector('.copy-btn');
        btn.innerHTML = '<i class="fa fa-check"></i> Copied!';
        setTimeout(function() {
            btn.innerHTML = '<i class="fa fa-copy"></i> Copy';
        }, 2000);
    }).catch(function() {
        // Fallback
        const el = document.createElement('textarea');
        el.value = jwtText;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    });
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
</script>

<!-- SweetAlert2 and notification script -->
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>
</body>
</html>
