<!DOCTYPE html>
<html>
<head>
<title>Database Dashboard - SLP</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/loggedIn/css/w3.css">
<link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">
<link rel="stylesheet" href="/loggedIn/css/navbar-fix.css">
<link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">
<link rel="stylesheet" href="/loggedIn/css/fonts.css">
<link rel="stylesheet" href="/loggedIn/css/contentpacks-modern.css">
<link rel="stylesheet" href="/loggedIn/css/dashboard-modern.css">
<script src="/loggedIn/js/jquery.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: Roboto, sans-serif}
/* CRM Schema Tab Styles */
.crm-tab {
  padding: 7px 16px; border-radius: 20px; cursor: pointer; font-size: 0.82rem;
  background: #e2e8f0; color: #64748b; border: 1px solid #d1dde3;
  transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px;
  font-family: "Roboto", sans-serif;
}
.crm-tab:hover { background: #cbd5e1; }
.crm-tab.active { background: #4d636f; color: white; border-color: #4d636f; }
/* CRM Table Detail Cards */
.crm-tbl-card { background: #f8fafc; border: 1px solid #d1dde3; border-radius: 8px; margin-bottom: 12px; overflow: hidden; }
.crm-tbl-hdr { background: #4d636f; color: white; padding: 10px 16px; display: flex; align-items: center; justify-content: space-between; font-weight: 600; font-size: 0.9rem; }
.crm-tc-badge { background: rgba(255,255,255,0.2); border-radius: 12px; padding: 2px 10px; font-size: 0.75rem; }
.crm-col-row { display: flex; align-items: center; padding: 7px 16px; border-bottom: 1px solid #e2e8f0; font-size: 0.82rem; }
.crm-col-row:last-child { border-bottom: none; }
.crm-col-row:hover { background: #f1f5f9; }
.crm-col-name { font-family: monospace; font-weight: 600; color: #1e293b; min-width: 280px; }
.crm-col-type { color: #7c3aed; font-family: monospace; min-width: 160px; font-size: 0.78rem; }
.crm-col-badges { margin-left: auto; display: flex; gap: 5px; flex-wrap: wrap; }
.crm-cb-pk { background: #fef3c7; color: #92400e; border: 1px solid #fcd34d; padding: 1px 8px; border-radius: 10px; font-size: 0.7rem; font-weight: 700; }
.crm-cb-fk { background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd; padding: 1px 8px; border-radius: 10px; font-size: 0.7rem; font-weight: 700; }
.crm-cb-nn { background: #f0fdf4; color: #166534; border: 1px solid #86efac; padding: 1px 8px; border-radius: 10px; font-size: 0.7rem; }
.crm-cb-uq { background: #fdf4ff; color: #7e22ce; border: 1px solid #d8b4fe; padding: 1px 8px; border-radius: 10px; font-size: 0.7rem; }
.crm-cb-ai { background: #fff7ed; color: #9a3412; border: 1px solid #fdba74; padding: 1px 8px; border-radius: 10px; font-size: 0.7rem; }
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
              <!-- Breadcrumbs -->
              <div class="w3-bar w3-border w3-round w3-margin-bottom" style="padding:8px;">
                <a href="/loggedIn/dashboard.ftl" class="w3-bar-item w3-button w3-hover-light-grey">
                  <i class="fa fa-home"></i> Dashboard
                </a>
                <span class="w3-bar-item">›</span>
                <span class="w3-bar-item w3-text-grey">
                  <i class="fa fa-database"></i> Database Dashboard
                </span>
              </div>
              
              <!-- Header with Refresh -->
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <div>
                  <h4 class="w3-opacity" style="margin: 0;">
                    <i class="fa fa-database"></i> Database Dashboard
                  </h4>
                  <p style="margin: 0.5rem 0 0 0; color: #64748b;">
                    Monitor database connections, schemas, and performance metrics
                  </p>
                </div>
                <div style="display: flex; gap: 1rem; align-items: center;">
                  <div class="auto-refresh-indicator">
                    <span class="pulse"></span>
                    Auto-refresh: 10s
                  </div>
                  <button class="refresh-btn" onclick="refreshAllData()">
                    <i class="fa fa-refresh"></i> Refresh Now
                  </button>
                </div>
              </div>

              <!-- Stats Overview -->
              <div class="dashboard-grid">
                <div class="stat-card">
                  <div style="position: relative;">
                    <div class="stat-value" id="totalConnections">0</div>
                    <div class="stat-label">Total Connections</div>
                    <i class="fa fa-plug stat-icon"></i>
                  </div>
                </div>
                
                <div class="stat-card success">
                  <div style="position: relative;">
                    <div class="stat-value" id="activeConnections">0</div>
                    <div class="stat-label">Active Connections</div>
                    <i class="fa fa-check-circle stat-icon"></i>
                  </div>
                </div>
                
                <div class="stat-card warning">
                  <div style="position: relative;">
                    <div class="stat-value" id="totalSchemas">0</div>
                    <div class="stat-label">Total Schemas</div>
                    <i class="fa fa-sitemap stat-icon"></i>
                  </div>
                </div>
                
                <div class="stat-card info">
                  <div style="position: relative;">
                    <div class="stat-value" id="totalTables">0</div>
                    <div class="stat-label">Total Tables</div>
                    <i class="fa fa-table stat-icon"></i>
                  </div>
                </div>
              </div>

              <!-- Main Content Grid -->
              <div class="dashboard-grid-2col">
                <!-- Database Connections -->
                <div class="dashboard-card">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-plug"></i>
                      Database Connections
                    </div>
                    <span class="dashboard-card-badge badge-info" id="connectionCount">0</span>
                  </div>
                  <div id="connectionsContainer" style="max-height: 500px; overflow-y: auto;">
                    <div class="loading-card">
                      <div class="loading-spinner"></div>
                      <p>Loading connections...</p>
                    </div>
                  </div>
                </div>

                <!-- Connection Types -->
                <div class="dashboard-card">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-pie-chart"></i>
                      Connection Types
                    </div>
                  </div>
                  <div id="connectionTypesContainer">
                    <div class="loading-card">
                      <div class="loading-spinner"></div>
                      <p>Loading connection types...</p>
                    </div>
                  </div>
                </div>

                <!-- CRM Schema & ERD -->
                <div class="dashboard-card" style="grid-column: span 2;">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-sitemap"></i>
                      CRM Schema & Table Information
                    </div>
                    <div style="display:flex;gap:8px;align-items:center;">
                      <span class="dashboard-card-badge" style="background:#dbeafe;color:#1e40af;">schema: crm</span>
                      <span class="dashboard-card-badge badge-warning">8 tables</span>
                    </div>
                  </div>
                  <!-- Schema View Tabs -->
                  <div style="padding:16px 20px 0;border-bottom:1px solid #e2e8f0;display:flex;gap:8px;flex-wrap:wrap;">
                    <button class="crm-tab active" id="tab-erd" onclick="showCrmView('erd')"><i class="fa fa-sitemap"></i> ERD Diagram</button>
                    <button class="crm-tab" id="tab-tables" onclick="showCrmView('tables')"><i class="fa fa-table"></i> Table Details</button>
                    <button class="crm-tab" id="tab-live" onclick="showCrmView('live')"><i class="fa fa-plug"></i> Live Connections</button>
                  </div>
                  <!-- ERD View -->
                  <div id="crm-view-erd" style="padding:20px;">
                    <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:8px;padding:12px 16px;color:#1e40af;font-size:0.85rem;margin-bottom:16px;">
                      <i class="fa fa-info-circle"></i> The <strong>crm</strong> schema contains 8 tables representing a Customer Relationship Management system. Dashed arrows show foreign key relationships. <strong style="color:#92400e;">Yellow PK</strong> = Primary Key, <strong style="color:#1e40af;">Blue FK</strong> = Foreign Key.
                    </div>
                    <div style="background:#1e293b;border-radius:10px;padding:16px;overflow-x:auto;">
                      <svg width="860" height="600" viewBox="0 0 860 600" xmlns="http://www.w3.org/2000/svg">
                        <defs>
                          <marker id="arrY" markerWidth="8" markerHeight="8" refX="7" refY="3" orient="auto"><path d="M0,0 L0,6 L8,3 z" fill="#fbbf24"/></marker>
                          <marker id="arrB" markerWidth="8" markerHeight="8" refX="7" refY="3" orient="auto"><path d="M0,0 L0,6 L8,3 z" fill="#60a5fa"/></marker>
                        </defs>
                        <text x="430" y="18" text-anchor="middle" fill="#94a3b8" font-size="12" font-family="monospace" font-weight="bold">CRM Database — Entity Relationship Diagram (schema: crm)</text>
                        <!-- tbl_crm_accounts_status -->
                        <g transform="translate(10,30)">
                          <rect width="200" height="58" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="200" height="22" rx="5" fill="#4d636f"/><rect width="200" height="5" y="17" fill="#4d636f"/>
                          <text x="100" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_crm_accounts_status</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="85" y="34" fill="#94a3b8" font-size="9" font-family="monospace">INT IDENTITY</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    status</text><text x="85" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(64) NN</text>
                        </g>
                        <!-- tbl_crm_accounts -->
                        <g transform="translate(10,130)">
                          <rect width="215" height="230" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="215" height="22" rx="5" fill="#4d636f"/><rect width="215" height="5" y="17" fill="#4d636f"/>
                          <text x="107" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_crm_accounts</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    name</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(150)</text>
                          <text x="8" y="66" fill="#cbd5e1" font-size="10" font-family="monospace">    account_type</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(50)</text>
                          <text x="8" y="82" fill="#cbd5e1" font-size="10" font-family="monospace">    industry</text><text x="90" y="82" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(50)</text>
                          <text x="8" y="98" fill="#cbd5e1" font-size="10" font-family="monospace">    annual_revenue</text><text x="90" y="98" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(100)</text>
                          <text x="8" y="114" fill="#cbd5e1" font-size="10" font-family="monospace">    billing_address_*</text><text x="90" y="114" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR</text>
                          <text x="8" y="130" fill="#cbd5e1" font-size="10" font-family="monospace">    website</text><text x="90" y="130" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="146" fill="#cbd5e1" font-size="10" font-family="monospace">    employees</text><text x="90" y="146" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(10)</text>
                          <text x="8" y="162" fill="#cbd5e1" font-size="10" font-family="monospace">    ticker_symbol</text><text x="90" y="162" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(10)</text>
                          <text x="8" y="178" fill="#cbd5e1" font-size="10" font-family="monospace">    deleted</text><text x="90" y="178" fill="#94a3b8" font-size="9" font-family="monospace">SMALLINT</text>
                          <text x="8" y="194" fill="#60a5fa" font-size="10" font-family="monospace">FK  campaign_id</text><text x="90" y="194" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                          <text x="8" y="210" fill="#60a5fa" font-size="10" font-family="monospace">FK  status</text><text x="90" y="210" fill="#94a3b8" font-size="9" font-family="monospace">INT NN</text>
                          <text x="8" y="226" fill="#cbd5e1" font-size="10" font-family="monospace">    date_entered</text><text x="90" y="226" fill="#94a3b8" font-size="9" font-family="monospace">TIMESTAMP</text>
                        </g>
                        <!-- tbl_calls -->
                        <g transform="translate(10,410)">
                          <rect width="215" height="130" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="215" height="22" rx="5" fill="#4d636f"/><rect width="215" height="5" y="17" fill="#4d636f"/>
                          <text x="107" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_calls</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    name</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(50)</text>
                          <text x="8" y="66" fill="#cbd5e1" font-size="10" font-family="monospace">    status</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(100)</text>
                          <text x="8" y="82" fill="#cbd5e1" font-size="10" font-family="monospace">    direction</text><text x="90" y="82" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(100)</text>
                          <text x="8" y="98" fill="#cbd5e1" font-size="10" font-family="monospace">    duration_hours</text><text x="90" y="98" fill="#94a3b8" font-size="9" font-family="monospace">INTEGER</text>
                          <text x="8" y="114" fill="#cbd5e1" font-size="10" font-family="monospace">    parent_id</text><text x="90" y="114" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                        </g>
                        <!-- tbl_marketing_campaign -->
                        <g transform="translate(330,30)">
                          <rect width="200" height="90" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="200" height="22" rx="5" fill="#4d636f"/><rect width="200" height="5" y="17" fill="#4d636f"/>
                          <text x="100" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_marketing_campaign</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">INT IDENTITY</text>
                          <text x="8" y="50" fill="#60a5fa" font-size="10" font-family="monospace">FK  email_id</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36) NN</text>
                          <text x="8" y="66" fill="#60a5fa" font-size="10" font-family="monospace">FK  template_id</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36) NN</text>
                          <text x="8" y="82" fill="#cbd5e1" font-size="10" font-family="monospace">    campaign_date</text><text x="90" y="82" fill="#94a3b8" font-size="9" font-family="monospace">TIMESTAMP NN</text>
                        </g>
                        <!-- tbl_email_lists -->
                        <g transform="translate(330,175)">
                          <rect width="200" height="90" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="200" height="22" rx="5" fill="#4d636f"/><rect width="200" height="5" y="17" fill="#4d636f"/>
                          <text x="100" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_email_lists</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    email_address</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(150) UQ</text>
                          <text x="8" y="66" fill="#cbd5e1" font-size="10" font-family="monospace">    email_address_caps</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="82" fill="#cbd5e1" font-size="10" font-family="monospace">    opt_out</text><text x="90" y="82" fill="#94a3b8" font-size="9" font-family="monospace">SMALLINT</text>
                        </g>
                        <!-- tbl_marketing_template -->
                        <g transform="translate(330,320)">
                          <rect width="200" height="74" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="200" height="22" rx="5" fill="#4d636f"/><rect width="200" height="5" y="17" fill="#4d636f"/>
                          <text x="100" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_marketing_template</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    subject</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255) NN</text>
                          <text x="8" y="66" fill="#cbd5e1" font-size="10" font-family="monospace">    body</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">CLOB</text>
                        </g>
                        <!-- tbl_bugs -->
                        <g transform="translate(650,30)">
                          <rect width="200" height="194" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="200" height="22" rx="5" fill="#4d636f"/><rect width="200" height="5" y="17" fill="#4d636f"/>
                          <text x="100" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_bugs</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">CHAR(36)</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    name</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="66" fill="#cbd5e1" font-size="10" font-family="monospace">    bug_number</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">INTEGER</text>
                          <text x="8" y="82" fill="#cbd5e1" font-size="10" font-family="monospace">    type</text><text x="90" y="82" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="98" fill="#cbd5e1" font-size="10" font-family="monospace">    status</text><text x="90" y="98" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(100)</text>
                          <text x="8" y="114" fill="#cbd5e1" font-size="10" font-family="monospace">    priority</text><text x="90" y="114" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(100)</text>
                          <text x="8" y="130" fill="#cbd5e1" font-size="10" font-family="monospace">    resolution</text><text x="90" y="130" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="146" fill="#cbd5e1" font-size="10" font-family="monospace">    product_category</text><text x="90" y="146" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="162" fill="#cbd5e1" font-size="10" font-family="monospace">    found_in_release</text><text x="90" y="162" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(255)</text>
                          <text x="8" y="178" fill="#cbd5e1" font-size="10" font-family="monospace">    deleted</text><text x="90" y="178" fill="#94a3b8" font-size="9" font-family="monospace">SMALLINT</text>
                        </g>
                        <!-- tbl_product -->
                        <g transform="translate(650,280)">
                          <rect width="200" height="106" rx="5" fill="#2d3f4e" stroke="#4d636f" stroke-width="1.5"/>
                          <rect width="200" height="22" rx="5" fill="#4d636f"/><rect width="200" height="5" y="17" fill="#4d636f"/>
                          <text x="100" y="15" text-anchor="middle" fill="white" font-size="11" font-family="monospace" font-weight="bold">tbl_product</text>
                          <text x="8" y="34" fill="#fbbf24" font-size="10" font-family="monospace">PK  id</text><text x="90" y="34" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(25)</text>
                          <text x="8" y="50" fill="#cbd5e1" font-size="10" font-family="monospace">    name</text><text x="90" y="50" fill="#94a3b8" font-size="9" font-family="monospace">VARCHAR(150)</text>
                          <text x="8" y="66" fill="#cbd5e1" font-size="10" font-family="monospace">    description</text><text x="90" y="66" fill="#94a3b8" font-size="9" font-family="monospace">CLOB</text>
                          <text x="8" y="82" fill="#cbd5e1" font-size="10" font-family="monospace">    price</text><text x="90" y="82" fill="#94a3b8" font-size="9" font-family="monospace">DECIMAL(10,2)</text>
                          <text x="8" y="98" fill="#cbd5e1" font-size="10" font-family="monospace">    quantity</text><text x="90" y="98" fill="#94a3b8" font-size="9" font-family="monospace">INTEGER</text>
                        </g>
                        <!-- FK: accounts.status -> accounts_status.id -->
                        <path d="M 117 130 L 117 88" stroke="#fbbf24" stroke-width="1.5" stroke-dasharray="5,3" fill="none" marker-end="url(#arrY)"/>
                        <text x="122" y="112" fill="#fbbf24" font-size="9" font-family="monospace">status FK</text>
                        <!-- FK: accounts.campaign_id -> marketing_campaign.id -->
                        <path d="M 225 310 L 290 310 L 290 75 L 330 75" stroke="#60a5fa" stroke-width="1.5" stroke-dasharray="5,3" fill="none" marker-end="url(#arrB)"/>
                        <text x="238" y="304" fill="#60a5fa" font-size="9" font-family="monospace">campaign_id FK</text>
                        <!-- FK: marketing_campaign.email_id -> email_lists.id -->
                        <path d="M 430 120 L 430 175" stroke="#60a5fa" stroke-width="1.5" stroke-dasharray="5,3" fill="none" marker-end="url(#arrB)"/>
                        <text x="435" y="152" fill="#60a5fa" font-size="9" font-family="monospace">email_id FK</text>
                        <!-- FK: marketing_campaign.template_id -> marketing_template.id -->
                        <path d="M 470 120 L 470 320" stroke="#60a5fa" stroke-width="1.5" stroke-dasharray="5,3" fill="none" marker-end="url(#arrB)"/>
                        <text x="475" y="230" fill="#60a5fa" font-size="9" font-family="monospace">template_id FK</text>
                        <!-- Legend -->
                        <g transform="translate(10,555)">
                          <rect width="840" height="36" rx="5" fill="#1a2a38" stroke="#334155" stroke-width="1"/>
                          <line x1="16" y1="18" x2="46" y2="18" stroke="#fbbf24" stroke-width="1.5" stroke-dasharray="5,3"/>
                          <text x="50" y="22" fill="#fbbf24" font-size="10" font-family="monospace">FK to accounts_status</text>
                          <line x1="200" y1="18" x2="230" y2="18" stroke="#60a5fa" stroke-width="1.5" stroke-dasharray="5,3"/>
                          <text x="234" y="22" fill="#60a5fa" font-size="10" font-family="monospace">FK (campaign/email/template)</text>
                          <text x="460" y="22" fill="#fbbf24" font-size="10" font-family="monospace">PK = Primary Key</text>
                          <text x="590" y="22" fill="#60a5fa" font-size="10" font-family="monospace">FK = Foreign Key</text>
                          <text x="710" y="22" fill="#94a3b8" font-size="10" font-family="monospace">NN=NOT NULL  UQ=UNIQUE</text>
                        </g>
                      </svg>
                    </div>
                  </div>
                  <!-- Table Details View -->
                  <div id="crm-view-tables" style="display:none;padding:20px;">
                    <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:8px;padding:12px 16px;color:#1e40af;font-size:0.85rem;margin-bottom:16px;">
                      <i class="fa fa-table"></i> All 8 tables in the <strong>crm</strong> schema. Populated with ~1000 rows each via <code>PopulateTables()</code> stored procedure.
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_crm_accounts_status</span><span class="crm-tc-badge">2 cols &bull; Lookup</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">INT IDENTITY</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-ai">AUTO</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">status</span><span class="crm-col-type">VARCHAR(64)</span><div class="crm-col-badges"><span class="crm-cb-nn">NN</span></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_crm_accounts</span><span class="crm-tc-badge">33 cols &bull; Core</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">name</span><span class="crm-col-type">VARCHAR(150)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">date_entered / date_modified</span><span class="crm-col-type">TIMESTAMP</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">account_type</span><span class="crm-col-type">VARCHAR(50)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">industry</span><span class="crm-col-type">VARCHAR(50)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">annual_revenue</span><span class="crm-col-type">VARCHAR(100)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">billing_address_street/city/state/postalcode/country</span><span class="crm-col-type">VARCHAR</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">shipping_address_street/city/state/postalcode/country</span><span class="crm-col-type">VARCHAR</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">phone_office / phone_fax / phone_alternate</span><span class="crm-col-type">VARCHAR(100)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">website</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">ownership / employees / ticker_symbol / sic_code</span><span class="crm-col-type">VARCHAR</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">deleted</span><span class="crm-col-type">SMALLINT</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">campaign_id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-fk">FK</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">status</span><span class="crm-col-type">INT</span><div class="crm-col-badges"><span class="crm-cb-fk">FK</span><span class="crm-cb-nn">NN</span></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_calls</span><span class="crm-tc-badge">19 cols &bull; Activity</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">name</span><span class="crm-col-type">VARCHAR(50)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">status</span><span class="crm-col-type">VARCHAR(100)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">direction</span><span class="crm-col-type">VARCHAR(100)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">duration_hours / duration_minutes</span><span class="crm-col-type">INTEGER</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">date_start / date_end</span><span class="crm-col-type">VARCHAR(50)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">parent_type / parent_id</span><span class="crm-col-type">VARCHAR / CHAR(36)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">reminder_time</span><span class="crm-col-type">INTEGER</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">outlook_id</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_email_lists</span><span class="crm-tc-badge">5 cols &bull; Marketing</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">email_address</span><span class="crm-col-type">VARCHAR(150)</span><div class="crm-col-badges"><span class="crm-cb-nn">NN</span><span class="crm-cb-uq">UQ</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">email_address_caps</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">opt_out</span><span class="crm-col-type">SMALLINT</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">date_created</span><span class="crm-col-type">TIMESTAMP</span><div class="crm-col-badges"></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_marketing_template</span><span class="crm-tc-badge">3 cols &bull; Marketing</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">subject</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">body</span><span class="crm-col-type">CLOB</span><div class="crm-col-badges"></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_marketing_campaign</span><span class="crm-tc-badge">4 cols &bull; Marketing</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">INT IDENTITY</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-ai">AUTO</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">email_id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-fk">FK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">template_id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-fk">FK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">campaign_date</span><span class="crm-col-type">TIMESTAMP</span><div class="crm-col-badges"><span class="crm-cb-nn">NN</span></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_bugs</span><span class="crm-tc-badge">19 cols &bull; Support</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">CHAR(36)</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">name</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">bug_number</span><span class="crm-col-type">INTEGER</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">type</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">status</span><span class="crm-col-type">VARCHAR(100)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">priority</span><span class="crm-col-type">VARCHAR(100)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">resolution</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">product_category</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">found_in_release / fixed_in_release</span><span class="crm-col-type">VARCHAR(255)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">deleted</span><span class="crm-col-type">SMALLINT</span><div class="crm-col-badges"></div></div>
                    </div>
                    <div class="crm-tbl-card">
                      <div class="crm-tbl-hdr"><span><i class="fa fa-table" style="margin-right:8px;"></i>tbl_product</span><span class="crm-tc-badge">5 cols &bull; Catalogue</span></div>
                      <div class="crm-col-row"><span class="crm-col-name">id</span><span class="crm-col-type">VARCHAR(25)</span><div class="crm-col-badges"><span class="crm-cb-pk">PK</span><span class="crm-cb-nn">NN</span></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">name</span><span class="crm-col-type">VARCHAR(150)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">description</span><span class="crm-col-type">CLOB</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">price</span><span class="crm-col-type">DECIMAL(10,2)</span><div class="crm-col-badges"></div></div>
                      <div class="crm-col-row"><span class="crm-col-name">quantity</span><span class="crm-col-type">INTEGER</span><div class="crm-col-badges"></div></div>
                    </div>
                  </div>
                  <!-- Live Connections View -->
                  <div id="crm-view-live" style="display:none;padding:20px;">
                    <div style="background:#eff6ff;border:1px solid #bfdbfe;border-radius:8px;padding:12px 16px;color:#1e40af;font-size:0.85rem;margin-bottom:16px;">
                      <i class="fa fa-plug"></i> Live connection status for all configured database connections.
                    </div>
                    <div id="schemaContainer">
                      <div style="text-align:center;padding:30px;color:#64748b;"><i class="fa fa-spinner fa-spin"></i> Loading...</div>
                    </div>
                  </div>
                </div>

                <!-- Recent Database Activity -->
                <div class="dashboard-card" style="grid-column: span 2;">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-history"></i>
                      Recent Database Activity
                    </div>
                  </div>
                  <div id="activityContainer">
                    <table class="modern-table">
                      <thead>
                        <tr>
                          <th>Time</th>
                          <th>Connection</th>
                          <th>Action</th>
                          <th>Status</th>
                          <th>Duration</th>
                        </tr>
                      </thead>
                      <tbody id="activityTableBody">
                        <tr>
                          <td colspan="5" style="text-align: center; padding: 2rem; color: #64748b;">
                            <i class="fa fa-spinner fa-spin"></i> Loading activity...
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <!-- Last Updated -->
              <div style="text-align: center; margin-top: 2rem; color: #64748b; font-size: 0.875rem;">
                <i class="fa fa-clock-o"></i> Last updated: <span id="lastUpdate">Never</span>
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

<!-- Footer -->
<div id="footer"></div>

<script>
// Global variables
let refreshInterval;
const REFRESH_INTERVAL = 10000; // 10 seconds

// Initialize on page load
$(document).ready(function() {
    // Load navbar and left column
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

    // Initial data load
    refreshAllData();
    
    // Set up auto-refresh
    refreshInterval = setInterval(refreshAllData, REFRESH_INTERVAL);
});

// CRM Schema view tab switcher
function showCrmView(view) {
    document.getElementById('crm-view-erd').style.display = 'none';
    document.getElementById('crm-view-tables').style.display = 'none';
    document.getElementById('crm-view-live').style.display = 'none';
    document.getElementById('crm-view-' + view).style.display = 'block';
    document.querySelectorAll('.crm-tab').forEach(function(t) { t.classList.remove('active'); });
    var tabEl = document.getElementById('tab-' + view);
    if (tabEl) tabEl.classList.add('active');
    if (view === 'live') { loadSchemaInfo(); }
}

// Refresh all dashboard data
function refreshAllData() {
    loadConnections();
    loadConnectionTypes();
    loadRecentActivity();
    updateTimestamp();
}

// Load database connections
function loadConnections() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getDatabaseConnections',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(connections) {
            // Also get validated connections
            $.ajax({
                url: '/api/getValidatedDatabaseConnections',
                type: 'POST',
                data: jsonData,
                contentType: 'application/json; charset=utf-8',
                success: function(validatedConnections) {
                    displayConnections(connections, validatedConnections);
                },
                error: function(xhr, status, error) {
                    console.error('Error loading validated connections:', error);
                    displayConnections(connections, []);
                }
            });
        },
        error: function(xhr, status, error) {
            console.error('Error loading connections:', error);
            showError('connectionsContainer', 'Failed to load database connections');
        }
    });
}

// Display connections
function displayConnections(connections, validatedConnections) {
    const container = $('#connectionsContainer');
    
    if (!connections || connections.length === 0) {
        container.html(
            '<div class="empty-state">' +
            '<div class="empty-state-icon"><i class="fa fa-database"></i></div>' +
            '<div class="empty-state-title">No Connections Found</div>' +
            '<div class="empty-state-text">Add database connections to get started</div>' +
            '</div>'
        );
        $('#totalConnections').text('0');
        $('#activeConnections').text('0');
        $('#connectionCount').text('0');
        return;
    }
    
    // Create a map of validated connections keyed by db_connection_id
    // getValidatedDatabaseConnections returns: { connection: db_connection_id, status: 'connected' }
    const validatedMap = {};
    if (validatedConnections) {
        validatedConnections.forEach(conn => {
            validatedMap[conn.connection] = conn;
        });
    }
    
    let html = '';
    let connectedCount = 0;
    
    connections.forEach(conn => {
        // conn fields: id, db_connection_id, db_type, db_database, db_username, db_alias, status ('active'/'inactive')
        const connId = conn.db_connection_id || conn.id;
        const validated = validatedMap[connId];
        const isConnected = validated && validated.status === 'connected';
        const isActive = conn.status === 'active';
        
        if (isConnected) connectedCount++;
        
        // Determine card style: connected = green, active but not connected = orange, inactive = grey
        let cardClass = 'inactive';
        let statusClass = 'offline';
        let statusText = 'Inactive';
        if (isConnected) {
            cardClass = 'active';
            statusClass = 'online';
            statusText = 'Connected';
        } else if (isActive) {
            cardClass = 'active';
            statusClass = 'online';
            statusText = 'Active';
        }
        
        const displayName = conn.db_alias || conn.db_connection_id || conn.id || 'Unknown';
        
        html += '<div class="connection-card ' + cardClass + '">' +
            '<div class="connection-header">' +
            '<div class="connection-name">' +
            '<i class="fa fa-database"></i> ' + displayName +
            '</div>' +
            '<span class="connection-status ' + statusClass + '">' +
            '<i class="fa fa-circle"></i> ' + statusText +
            '</span>' +
            '</div>' +
            '<div class="connection-details">' +
            '<div class="connection-detail">' +
            '<i class="fa fa-server"></i>' +
            '<span>' + (conn.db_type || 'Unknown') + '</span>' +
            '</div>' +
            '<div class="connection-detail">' +
            '<i class="fa fa-user"></i>' +
            '<span>' + (conn.db_username || 'N/A') + '</span>' +
            '</div>' +
            '<div class="connection-detail">' +
            '<i class="fa fa-database"></i>' +
            '<span>' + (conn.db_database || 'N/A') + '</span>' +
            '</div>' +
            '<div class="connection-detail">' +
            '<i class="fa fa-tag"></i>' +
            '<span>ID: ' + (conn.db_connection_id || conn.id || 'N/A') + '</span>' +
            '</div>' +
            '</div>' +
            '</div>';
    });
    
    container.html(html);
    $('#totalConnections').text(connections.length);
    $('#activeConnections').text(connectedCount);
    $('#connectionCount').text(connections.length);
}

// Load connection types
function loadConnectionTypes() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getDatabaseConnections',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(connections) {
            displayConnectionTypes(connections);
        },
        error: function(xhr, status, error) {
            console.error('Error loading connection types:', error);
            showError('connectionTypesContainer', 'Failed to load connection types');
        }
    });
}

// Display connection types
function displayConnectionTypes(connections) {
    const container = $('#connectionTypesContainer');
    
    if (!connections || connections.length === 0) {
        container.html(`
            <div class="empty-state">
                <div class="empty-state-icon"><i class="fa fa-pie-chart"></i></div>
                <div class="empty-state-text">No data available</div>
            </div>
        `);
        return;
    }
    
    // Count by type
    const typeCounts = {};
    connections.forEach(conn => {
        const type = conn.db_type || 'Unknown';
        typeCounts[type] = (typeCounts[type] || 0) + 1;
    });
    
    // Create visual representation
    let html = '<div style="padding: 1rem;">';
    const colors = ['#4d636f', '#10b981', '#f59e0b', '#ef4444', '#3b82f6', '#8b5cf6'];
    let colorIndex = 0;
    
    for (const [type, count] of Object.entries(typeCounts)) {
        const percentage = ((count / connections.length) * 100).toFixed(1);
        const color = colors[colorIndex % colors.length];
        colorIndex++;
        
        html += '<div style="margin-bottom: 1.5rem;">' +
            '<div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">' +
            '<span style="font-weight: 600; color: #1e293b;">' +
            '<i class="fa fa-database" style="color: ' + color + ';"></i> ' + type +
            '</span>' +
            '<span style="color: #64748b;">' + count + ' (' + percentage + '%)</span>' +
            '</div>' +
            '<div class="progress-bar-container">' +
            '<div class="progress-bar-fill" style="width: ' + percentage + '%; background: ' + color + ';"></div>' +
            '</div>' +
            '</div>';
    }
    
    html += '</div>';
    container.html(html);
}

// Load schema information - uses getValidatedDatabaseConnections to show connection details
function loadSchemaInfo() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getDatabaseConnections',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(connections) {
            $.ajax({
                url: '/api/getValidatedDatabaseConnections',
                type: 'POST',
                data: jsonData,
                contentType: 'application/json; charset=utf-8',
                success: function(validatedConnections) {
                    displaySchemaInfo(connections, validatedConnections);
                },
                error: function() {
                    displaySchemaInfo(connections, []);
                }
            });
        },
        error: function() {
            $('#schemaContainer').html(
                '<div class="empty-state">' +
                '<div class="empty-state-icon"><i class="fa fa-sitemap"></i></div>' +
                '<div class="empty-state-title">Unable to load schema data</div>' +
                '</div>'
            );
        }
    });
}

// Display schema info as a connection detail table
function displaySchemaInfo(connections, validatedConnections) {
    const container = $('#schemaContainer');
    
    if (!connections || connections.length === 0) {
        container.html(
            '<div class="empty-state">' +
            '<div class="empty-state-icon"><i class="fa fa-sitemap"></i></div>' +
            '<div class="empty-state-title">No Schema Data Available</div>' +
            '<div class="empty-state-text">Add database connections to view schema information</div>' +
            '</div>'
        );
        $('#totalSchemas').text('0');
        $('#totalTables').text('0');
        $('#schemaCount').text('0 connections');
        return;
    }
    
    const validatedMap = {};
    if (validatedConnections) {
        validatedConnections.forEach(v => { validatedMap[v.connection] = v; });
    }
    
    let html = '<table class="modern-table"><thead><tr>' +
        '<th>Connection ID</th>' +
        '<th>Alias</th>' +
        '<th>Type</th>' +
        '<th>Database</th>' +
        '<th>Username</th>' +
        '<th>Status</th>' +
        '<th>Connected</th>' +
        '</tr></thead><tbody>';
    
    connections.forEach(conn => {
        const connId = conn.db_connection_id || conn.id;
        const validated = validatedMap[connId];
        const isConnected = validated && validated.status === 'connected';
        const isActive = conn.status === 'active';
        
        const statusBadge = isActive
            ? '<span style="padding:0.2rem 0.6rem; background:#d1fae5; color:#065f46; border-radius:9999px; font-size:0.75rem; font-weight:600;">Active</span>'
            : '<span style="padding:0.2rem 0.6rem; background:#f1f5f9; color:#64748b; border-radius:9999px; font-size:0.75rem; font-weight:600;">Inactive</span>';
        
        const connectedBadge = isConnected
            ? '<span style="padding:0.2rem 0.6rem; background:#d1fae5; color:#065f46; border-radius:9999px; font-size:0.75rem; font-weight:600;"><i class="fa fa-check"></i> Connected</span>'
            : (isActive
                ? '<span style="padding:0.2rem 0.6rem; background:#fee2e2; color:#991b1b; border-radius:9999px; font-size:0.75rem; font-weight:600;"><i class="fa fa-times"></i> Not Connected</span>'
                : '<span style="padding:0.2rem 0.6rem; background:#f1f5f9; color:#64748b; border-radius:9999px; font-size:0.75rem; font-weight:600;">-</span>');
        
        html += '<tr>' +
            '<td><code style="font-size:0.8rem;">' + (conn.db_connection_id || '-') + '</code></td>' +
            '<td><strong>' + (conn.db_alias || '-') + '</strong></td>' +
            '<td>' + (conn.db_type || '-') + '</td>' +
            '<td>' + (conn.db_database || '-') + '</td>' +
            '<td>' + (conn.db_username || '-') + '</td>' +
            '<td>' + statusBadge + '</td>' +
            '<td>' + connectedBadge + '</td>' +
            '</tr>';
    });
    
    html += '</tbody></table>';
    container.html(html);
    $('#totalSchemas').text(connections.length);
    $('#totalTables').text(validatedConnections ? validatedConnections.length : 0);
    $('#schemaCount').text(connections.length + ' connections');
}

// Load recent activity - uses getRefreshedDatabaseConnections for activity data
function loadRecentActivity() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getValidatedDatabaseConnections',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(validatedConnections) {
            const tbody = $('#activityTableBody');
            
            if (!validatedConnections || validatedConnections.length === 0) {
                tbody.html(
                    '<tr><td colspan="5" style="text-align:center; padding:2rem; color:#64748b;">' +
                    '<i class="fa fa-info-circle"></i> No active connections found' +
                    '</td></tr>'
                );
                return;
            }
            
            let rows = '';
            const now = new Date();
            validatedConnections.forEach(conn => {
                const statusColor = conn.status === 'connected' ? '#10b981' : '#ef4444';
                const statusText = conn.status === 'connected' ? 'Connected' : conn.status || 'Unknown';
                rows += '<tr>' +
                    '<td>' + now.toLocaleTimeString() + '</td>' +
                    '<td><strong>' + (conn.alias || conn.connection || 'N/A') + '</strong></td>' +
                    '<td>' + (conn.access || 'N/A') + '</td>' +
                    '<td><span style="color:' + statusColor + '; font-weight:600;">' + statusText + '</span></td>' +
                    '<td>-</td>' +
                    '</tr>';
            });
            tbody.html(rows);
        },
        error: function() {
            $('#activityTableBody').html(
                '<tr><td colspan="5" style="text-align:center; padding:2rem; color:#64748b;">' +
                '<i class="fa fa-info-circle"></i> Activity data not available' +
                '</td></tr>'
            );
        }
    });
}

// Show error message
function showError(containerId, message) {
    $('#' + containerId).html(
        '<div class="empty-state">' +
        '<div class="empty-state-icon" style="color: #ef4444;">' +
        '<i class="fa fa-exclamation-triangle"></i>' +
        '</div>' +
        '<div class="empty-state-title">Error</div>' +
        '<div class="empty-state-text">' + message + '</div>' +
        '</div>'
    );
}

// Update timestamp
function updateTimestamp() {
    const now = new Date();
    $('#lastUpdate').text(now.toLocaleTimeString());
}

// Cleanup on page unload
$(window).on('beforeunload', function() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
    }
});
</script>

<!-- SweetAlert2 and notification script -->
<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>
</body>
</html>