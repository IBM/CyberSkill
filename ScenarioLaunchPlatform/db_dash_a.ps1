
$f = 'src\main\resources\templates\loggedIn\database-dashboard.ftl'
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add('<!DOCTYPE html>')
$lines.Add('<html>')
$lines.Add('<head>')
$lines.Add('<title>Database Dashboard - SLP</title>')
$lines.Add('<meta charset="UTF-8">')
$lines.Add('<meta name="viewport" content="width=device-width, initial-scale=1">')
$lines.Add('<link rel="stylesheet" href="/loggedIn/css/w3.css">')
$lines.Add('<link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">')
$lines.Add('<link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">')
$lines.Add('<link rel="stylesheet" href="/loggedIn/css/fonts.css">')
$lines.Add('<link rel="stylesheet" href="/loggedIn/css/contentpacks-modern.css">')
$lines.Add('<link rel="stylesheet" href="/loggedIn/css/dashboard-modern.css">')
$lines.Add('<script src="/loggedIn/js/jquery.min.js"></script>')
$lines.Add('<style>')
$lines.Add(':root{--primary:#4d636f;--primary-dark:#3a4f5a;--success:#10b981;--danger:#ef4444;--warning:#f59e0b;--info:#3b82f6;--bg:#f0f4f7;--card-bg:#ffffff;--border:#d1dde3;--text:#1e293b;--text-muted:#64748b;}')
$lines.Add('html,body{font-family:"Roboto","Open Sans",sans-serif;background:var(--bg);color:var(--text);margin:0;}')
$lines.Add('.page-header{background:linear-gradient(135deg,var(--primary),var(--primary-dark));color:white;padding:28px 32px 20px;border-radius:0 0 12px 12px;}')
$lines.Add('.page-header h2{margin:0 0 6px;font-size:1.6rem;font-weight:700;}')
$lines.Add('.page-header p{margin:0;opacity:0.85;font-size:0.95rem;}')
$lines.Add('.breadcrumb-bar{background:white;border-bottom:1px solid var(--border);padding:10px 32px;font-size:0.85rem;color:var(--text-muted);display:flex;align-items:center;justify-content:space-between;}')
$lines.Add('.breadcrumb-bar a{color:var(--primary);text-decoration:none;}')
$lines.Add('.breadcrumb-bar a:hover{text-decoration:underline;}')
$lines.Add('.breadcrumb-bar span{margin:0 6px;}')
$lines.Add('.stats-row{display:flex;gap:16px;margin:20px 0 0;flex-wrap:wrap;}')
$lines.Add('.stat-hdr{flex:1;min-width:120px;background:rgba(255,255,255,0.15);border-radius:10px;padding:14px 18px;text-align:center;border:1px solid rgba(255,255,255,0.25);}')
$lines.Add('.stat-hdr .sn{font-size:1.8rem;font-weight:700;color:white;line-height:1;}')
$lines.Add('.stat-hdr .sl{font-size:0.78rem;color:rgba(255,255,255,0.8);margin-top:4px;}')
$lines.Add('.stat-hdr.green{background:rgba(16,185,129,0.25);border-color:rgba(16,185,129,0.4);}')
$lines.Add('.stat-hdr.orange{background:rgba(245,158,11,0.25);border-color:rgba(245,158,11,0.4);}')
$lines.Add('.stat-hdr.blue{background:rgba(59,130,246,0.25);border-color:rgba(59,130,246,0.4);}')
$lines.Add('.section-card{background:var(--card-bg);border-radius:10px;border:1px solid var(--border);margin-bottom:16px;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,0.06);}')
$lines.Add('.sc-header{display:flex;align-items:center;justify-content:space-between;padding:14px 20px;background:var(--card-bg);border-bottom:1px solid var(--border);cursor:pointer;user-select:none;}')
$lines.Add('.sc-header:hover{background:#f8fafc;}')
.sc-header h5 i{color:var(--primary);}
.sc-header .chevron{color:var(--text-muted);transition:transform 0.2s;}
.sc-header.open .chevron{transform:rotate(180deg);}
.sc-body{display:none;padding:20px;}
.sc-body.open{display:block;}
.refresh-btn{background:rgba(255,255,255,0.2);border:1px solid rgba(255,255,255,0.4);color:white;padding:8px 16px;border-radius:8px;cursor:pointer;font-size:0.85rem;display:inline-flex;align-items:center;gap:6px;transition:background 0.2s;}
.refresh-btn:hover{background:rgba(255,255,255,0.3);}
.pulse-dot{width:8px;height:8px;background:#10b981;border-radius:50%;display:inline-block;margin-right:6px;animation:pulse 2s infinite;}
@keyframes pulse{0%,100%{opacity:1;}50%{opacity:0.4;}}
.conn-card{background:#f8fafc;border:1px solid var(--border);border-radius:8px;padding:14px 16px;margin-bottom:10px;border-left:4px solid #cbd5e1;}
.conn-card.connected{border-left-color:var(--success);}
.conn-card.active-only{border-left-color:var(--warning);}
.conn-name{font-weight:600;font-size:0.95rem;color:var(--text);margin-bottom:6px;display:flex;align-items:center;justify-content:space-between;}
.conn-details{display:flex;flex-wrap:wrap;gap:8px;}
.conn-detail{font-size:0.78rem;color:var(--text-muted);display:flex;align-items:center;gap:4px;}
.badge-pill{display:inline-block;padding:2px 10px;border-radius:20px;font-size:0.72rem;font-weight:600;}
.bp-connected{background:#d1fae5;color:#065f46;}
.bp-active{background:#fef3c7;color:#92400e;}
.bp-inactive{background:#f1f5f9;color:#64748b;}
.bp-notconn{background:#fee2e2;color:#991b1b;}
.type-bar-row{margin-bottom:14px;}
.type-bar-label{display:flex;justify-content:space-between;margin-bottom:4px;font-size:0.85rem;}
.type-bar-track{background:#e2e8f0;border-radius:4px;height:10px;overflow:hidden;}
.type-bar-fill{height:100%;border-radius:4px;transition:width 0.6s ease;}
.modern-table{width:100%;border-collapse:collapse;font-size:0.85rem;}
.modern-table th{background:#f1f5f9;padding:10px 14px;text-align:left;font-weight:600;color:var(--text-muted);font-size:0.78rem;text-transform:uppercase;letter-spacing:0.4px;border-bottom:2px solid var(--border);}
.modern-table td{padding:10px 14px;border-bottom:1px solid #f1f5f9;color:var(--text);}
.modern-table tr:hover td{background:#f8fafc;}
.empty-state{text-align:center;padding:40px 20px;color:var(--text-muted);}
.empty-state i{font-size:2.5rem;margin-bottom:12px;opacity:0.4;display:block;}
.erd-wrap{background:#1e293b;border-radius:10px;padding:16px;overflow-x:auto;margin-bottom:16px;}
.erd-wrap svg{display:block;margin:0 auto;min-width:860px;}
.schema-tabs{display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap;}
.schema-tab{padding:6px 14px;border-radius:20px;cursor:pointer;font-size:0.82rem;background:#e2e8f0;color:var(--text-muted);border:1px solid var(--border);transition:all 0.2s;display:inline-flex;align-items:center;gap:6px;}
.schema-tab:hover{background:#cbd5e1;}
.schema-tab.active{background:var(--primary);color:white;border-color:var(--primary);}
.tbl-card{background:#f8fafc;border:1px solid var(--border);border-radius:8px;margin-bottom:12px;overflow:hidden;}
.tbl-card-hdr{background:var(--primary);color:white;padding:10px 16px;display:flex;align-items:center;justify-content:space-between;font-weight:600;font-size:0.9rem;}
.tbl-card-hdr .tc-badge{background:rgba(255,255,255,0.2);border-radius:12px;padding:2px 10px;font-size:0.75rem;}
.col-row{display:flex;align-items:center;padding:7px 16px;border-bottom:1px solid #e2e8f0;font-size:0.82rem;}
.col-row:last-child{border-bottom:none;}
.col-row:hover{background:#f1f5f9;}
.col-name{font-family:monospace;font-weight:600;color:var(--text);min-width:220px;}
.col-type{color:#7c3aed;font-family:monospace;min-width:160px;font-size:0.78rem;}
.col-badges{margin-left:auto;display:flex;gap:5px;flex-wrap:wrap;}
.cb-pk{background:#fef3c7;color:#92400e;border:1px solid #fcd34d;padding:1px 8px;border-radius:10px;font-size:0.7rem;font-weight:700;}
.cb-fk{background:#dbeafe;color:#1e40af;border:1px solid #93c5fd;padding:1px 8px;border-radius:10px;font-size:0.7rem;font-weight:700;}
.cb-nn{background:#f0fdf4;color:#166534;border:1px solid #86efac;padding:1px 8px;border-radius:10px;font-size:0.7rem;}
.cb-uq{background:#fdf4ff;color:#7e22ce;border:1px solid #d8b4fe;padding:1px 8px;border-radius:10px;font-size:0.7rem;}
.cb-ai{background:#fff7ed;color:#9a3412;border:1px solid #fdba74;padding:1px 8px;border-radius:10px;font-size:0.7rem;}
.info-note{background:#eff6ff;border:1px solid #bfdbfe;border-radius:8px;padding:12px 16px;color:#1e40af;font-size:0.85rem;margin-bottom:16px;}
.info-note i{margin-right:6px;}
.swal2-container{z-index:20000!important;}
</style>
</head>
<body class="w3-theme-l5">
<div id="navbar"></div>
<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">
  <div class="w3-row">
    <div id="leftColumn"></div>
    <div class="w3-col m9">
'@
Set-Content -Path $f -Value $a -Encoding UTF8
Write-Host "Part A written"
'@

# Made with Bob
