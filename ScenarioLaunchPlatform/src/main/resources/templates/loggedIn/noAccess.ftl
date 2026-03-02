<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Access Denied - SLP</title>
    <link rel="stylesheet" href="css/w3.css">
    <link rel="stylesheet" href="css/w3-theme-blue-grey.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/fonts.css">
    <script src="js/jquery.min.js"></script>
    <style>
        html, body, h1, h2, h3, h4, h5 { font-family: "Roboto", sans-serif; }
        *, *::before, *::after { box-sizing: border-box; }

        body {
            background: #f0f4f7;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        /* ── Main card ── */
        .error-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.12);
            max-width: 560px;
            width: 100%;
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Card header ── */
        .error-header {
            background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
            padding: 2.5rem 2rem 2rem;
            text-align: center;
            position: relative;
        }

        .error-header::after {
            content: '';
            position: absolute;
            bottom: -1px; left: 0; right: 0;
            height: 20px;
            background: #ffffff;
            border-radius: 20px 20px 0 0;
        }

        /* ── Lock icon ── */
        .lock-icon-wrap {
            width: 90px;
            height: 90px;
            background: rgba(255,255,255,0.15);
            border: 3px solid rgba(255,255,255,0.35);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.25rem;
            animation: pulse 2.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 0 0 0 rgba(255,255,255,0.3); }
            50%       { box-shadow: 0 0 0 14px rgba(255,255,255,0); }
        }

        .lock-icon-wrap i {
            font-size: 2.5rem;
            color: #ffffff;
        }

        .error-header h1 {
            color: #ffffff;
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0 0 0.4rem;
        }

        .error-header p {
            color: rgba(255,255,255,0.8);
            font-size: 0.95rem;
            margin: 0;
        }

        /* ── Card body ── */
        .error-body {
            padding: 2rem 2rem 1.5rem;
        }

        /* ── Info box ── */
        .info-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-left: 4px solid #4d636f;
            border-radius: 8px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
        }

        .info-box i {
            color: #4d636f;
            font-size: 1.1rem;
            margin-top: 2px;
            flex-shrink: 0;
        }

        .info-box p {
            margin: 0;
            color: #475569;
            font-size: 0.9rem;
            line-height: 1.6;
        }

        /* ── Reason chips ── */
        .reason-list {
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
            margin-bottom: 1.75rem;
        }

        .reason-item {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            padding: 0.6rem 0.9rem;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.875rem;
            color: #475569;
        }

        .reason-item i {
            color: #ef4444;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        /* ── Action buttons ── */
        .action-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn-primary {
            flex: 1;
            min-width: 140px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.7rem 1.25rem;
            background: linear-gradient(135deg, #4d636f, #3a4f5a);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 6px rgba(77,99,111,0.35);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #3a4f5a, #2d3e47);
            box-shadow: 0 4px 12px rgba(77,99,111,0.45);
            transform: translateY(-1px);
            color: #ffffff;
            text-decoration: none;
        }

        .btn-secondary {
            flex: 1;
            min-width: 140px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.7rem 1.25rem;
            background: #ffffff;
            color: #4d636f;
            border: 2px solid #4d636f;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-secondary:hover {
            background: #f0f4f7;
            transform: translateY(-1px);
            color: #3a4f5a;
            text-decoration: none;
        }

        /* ── Footer strip ── */
        .error-footer {
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
            padding: 0.9rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .error-footer span {
            font-size: 0.8rem;
            color: #94a3b8;
        }

        .error-footer .error-code {
            font-family: monospace;
            background: #e2e8f0;
            color: #475569;
            padding: 0.2rem 0.6rem;
            border-radius: 4px;
            font-size: 0.78rem;
        }

        /* ── Countdown ── */
        #countdown-wrap {
            font-size: 0.82rem;
            color: #94a3b8;
            text-align: center;
            margin-top: 1rem;
        }

        #countdown-wrap span {
            color: #4d636f;
            font-weight: 700;
        }
    </style>
</head>
<body>

    <div class="error-card">

        <!-- Header -->
        <div class="error-header">
            <div class="lock-icon-wrap">
                <i class="fa fa-lock"></i>
            </div>
            <h1>Access Denied</h1>
            <p>You don't have permission to view this page</p>
        </div>

        <!-- Body -->
        <div class="error-body">

            <div class="info-box">
                <i class="fa fa-info-circle"></i>
                <p>Your account does not have the required privileges to access this section of the Scenario Launch Platform. Please contact your administrator if you believe this is an error.</p>
            </div>

            <div class="reason-list">
                <div class="reason-item">
                    <i class="fa fa-times-circle"></i>
                    Insufficient role permissions for this resource
                </div>
                <div class="reason-item">
                    <i class="fa fa-times-circle"></i>
                    Admin-only feature — elevated access required
                </div>
                <div class="reason-item">
                    <i class="fa fa-times-circle"></i>
                    Your session may have expired — try logging in again
                </div>
            </div>

            <div class="action-buttons">
                <a href="/loggedIn/dashboard.ftl" class="btn-primary">
                    <i class="fa fa-home"></i> Return to Dashboard
                </a>
                <a href="javascript:history.back()" class="btn-secondary">
                    <i class="fa fa-arrow-left"></i> Go Back
                </a>
            </div>

            <div id="countdown-wrap">
                Redirecting to dashboard in <span id="countdown">10</span>s&hellip;
            </div>

        </div>

        <!-- Footer -->
        <div class="error-footer">
            <span>Scenario Launch Platform &copy; 2025</span>
            <span class="error-code">HTTP 403 Forbidden</span>
        </div>

    </div>

<script>
    // Auto-redirect countdown
    var seconds = 10;
    var timer = setInterval(function() {
        seconds--;
        var el = document.getElementById('countdown');
        if (el) el.textContent = seconds;
        if (seconds <= 0) {
            clearInterval(timer);
            window.location.href = '/loggedIn/dashboard.ftl';
        }
    }, 1000);
</script>

</body>
</html>
