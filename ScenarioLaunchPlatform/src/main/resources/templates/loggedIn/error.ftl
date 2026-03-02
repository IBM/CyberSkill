<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Page Not Found - SLP</title>
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
            max-width: 580px;
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

        /* ── 404 number display ── */
        .error-number {
            font-size: 5rem;
            font-weight: 900;
            color: rgba(255,255,255,0.15);
            line-height: 1;
            letter-spacing: -4px;
            margin-bottom: 0.5rem;
            position: relative;
        }

        .error-number::after {
            content: '404';
            position: absolute;
            top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            font-size: 5rem;
            font-weight: 900;
            color: #ffffff;
            letter-spacing: -4px;
        }

        /* ── Icon wrap ── */
        .icon-wrap {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.15);
            border: 3px solid rgba(255,255,255,0.35);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.25rem;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50%       { transform: translateY(-8px); }
        }

        .icon-wrap i {
            font-size: 2.2rem;
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

        /* ── Suggestion list ── */
        .suggestion-list {
            display: flex;
            flex-direction: column;
            gap: 0.6rem;
            margin-bottom: 1.75rem;
        }

        .suggestion-item {
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

        .suggestion-item i {
            color: #4d636f;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        /* ── Plugin hint ── */
        .plugin-hint {
            background: linear-gradient(135deg, rgba(77,99,111,0.06), rgba(58,79,90,0.06));
            border: 1px dashed #4d636f;
            border-radius: 8px;
            padding: 0.9rem 1.1rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .plugin-hint i {
            color: #4d636f;
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        .plugin-hint p {
            margin: 0;
            font-size: 0.875rem;
            color: #475569;
            line-height: 1.5;
        }

        .plugin-hint strong {
            color: #3a4f5a;
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

        .btn-warning {
            flex: 1;
            min-width: 140px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.7rem 1.25rem;
            background: #ffffff;
            color: #f59e0b;
            border: 2px solid #f59e0b;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-warning:hover {
            background: #fffbeb;
            transform: translateY(-1px);
            color: #d97706;
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

        /* ── Path display ── */
        .path-display {
            font-family: monospace;
            font-size: 0.82rem;
            color: #64748b;
            background: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 0.4rem 0.75rem;
            margin-top: 0.5rem;
            word-break: break-all;
        }
    </style>
</head>
<body>

    <div class="error-card">

        <!-- Header -->
        <div class="error-header">
            <div class="icon-wrap">
                <i class="fa fa-search"></i>
            </div>
            <h1>Page Not Found</h1>
            <p>The resource you requested could not be located</p>
        </div>

        <!-- Body -->
        <div class="error-body">

            <div class="info-box">
                <i class="fa fa-info-circle"></i>
                <div>
                    <p>The page or resource you're looking for doesn't exist, has been moved, or the URL may be incorrect.</p>
                    <div class="path-display" id="requested-path">—</div>
                </div>
            </div>

            <div class="plugin-hint">
                <i class="fa fa-plug"></i>
                <p><strong>Could this be a plugin?</strong> If you're trying to access a plugin page, make sure the plugin is installed and the heartbeat service is running. Try recalling the heartbeat from the Admin Functions page.</p>
            </div>

            <div class="suggestion-list">
                <div class="suggestion-item">
                    <i class="fa fa-check-circle"></i>
                    Check the URL for typos or incorrect path segments
                </div>
                <div class="suggestion-item">
                    <i class="fa fa-check-circle"></i>
                    Ensure the content pack or plugin is installed
                </div>
                <div class="suggestion-item">
                    <i class="fa fa-check-circle"></i>
                    Verify the heartbeat service is active in Admin Functions
                </div>
            </div>

            <div class="action-buttons">
                <a href="/loggedIn/dashboard.ftl" class="btn-primary">
                    <i class="fa fa-home"></i> Return to Dashboard
                </a>
                <a href="/loggedIn/adminFunctions.ftl" class="btn-warning">
                    <i class="fa fa-heartbeat"></i> Admin Functions
                </a>
                <a href="javascript:history.back()" class="btn-secondary">
                    <i class="fa fa-arrow-left"></i> Go Back
                </a>
            </div>

        </div>

        <!-- Footer -->
        <div class="error-footer">
            <span>Scenario Launch Platform &copy; 2025</span>
            <span class="error-code">HTTP 404 Not Found</span>
        </div>

    </div>

<script>
    // Show the requested path
    var pathEl = document.getElementById('requested-path');
    if (pathEl) {
        pathEl.textContent = window.location.pathname + (window.location.search || '');
    }
</script>

</body>
</html>