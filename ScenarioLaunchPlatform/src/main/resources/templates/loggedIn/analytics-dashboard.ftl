<!DOCTYPE html>
<html>
<head>
<title>Analytics Dashboard - SLP</title>
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
                  <i class="fa fa-line-chart"></i> Analytics Dashboard
                </span>
              </div>
              
              <!-- Header with Refresh -->
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                <div>
                  <h4 class="w3-opacity" style="margin: 0;">
                    <i class="fa fa-line-chart"></i> Analytics Dashboard
                  </h4>
                  <p style="margin: 0.5rem 0 0 0; color: #64748b;">
                    Monitor stories, queries, users, and active executions in real-time
                  </p>
                </div>
                <div style="display: flex; gap: 1rem; align-items: center;">
                  <div class="auto-refresh-indicator">
                    <span class="pulse"></span>
                    Auto-refresh: 5s
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
                    <div class="stat-value" id="totalStories">0</div>
                    <div class="stat-label">Total Stories</div>
                    <i class="fa fa-book stat-icon"></i>
                  </div>
                </div>
                
                <div class="stat-card info">
                  <div style="position: relative;">
                    <div class="stat-value" id="activeExecutions">0</div>
                    <div class="stat-label">Active Executions</div>
                    <i class="fa fa-play-circle stat-icon"></i>
                  </div>
                </div>
                
                <div class="stat-card warning">
                  <div style="position: relative;">
                    <div class="stat-value" id="totalQueries">0</div>
                    <div class="stat-label">Total Queries</div>
                    <i class="fa fa-code stat-icon"></i>
                  </div>
                </div>
                
                <div class="stat-card success">
                  <div style="position: relative;">
                    <div class="stat-value" id="totalUsers">0</div>
                    <div class="stat-label">Active Users</div>
                    <i class="fa fa-users stat-icon"></i>
                  </div>
                </div>
              </div>

              <!-- Active Story Executions -->
              <div class="dashboard-card" style="margin-top: 1.5rem;">
                <div class="dashboard-card-header">
                  <div class="dashboard-card-title">
                    <i class="fa fa-play-circle"></i>
                    Active Story Executions
                  </div>
                  <span class="dashboard-card-badge badge-info" id="activeCount">0 running</span>
                </div>
                <div id="activeExecutionsContainer">
                  <div class="loading-card">
                    <div class="loading-spinner"></div>
                    <p>Loading active executions...</p>
                  </div>
                </div>
              </div>

              <!-- Main Content Grid -->
              <div class="dashboard-grid-2col">
                <!-- Story Statistics -->
                <div class="dashboard-card">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-book"></i>
                      Story Statistics
                    </div>
                  </div>
                  <div id="storyStatsContainer">
                    <div class="loading-card">
                      <div class="loading-spinner"></div>
                      <p>Loading story statistics...</p>
                    </div>
                  </div>
                </div>

                <!-- Query Statistics -->
                <div class="dashboard-card">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-code"></i>
                      Query Statistics
                    </div>
                  </div>
                  <div id="queryStatsContainer">
                    <div class="loading-card">
                      <div class="loading-spinner"></div>
                      <p>Loading query statistics...</p>
                    </div>
                  </div>
                </div>

                <!-- User Activity -->
                <div class="dashboard-card">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-users"></i>
                      User Activity
                    </div>
                    <span class="dashboard-card-badge badge-success" id="userCount">0 users</span>
                  </div>
                  <div id="userActivityContainer" style="max-height: 400px; overflow-y: auto;">
                    <div class="loading-card">
                      <div class="loading-spinner"></div>
                      <p>Loading user activity...</p>
                    </div>
                  </div>
                </div>

                <!-- Attack Patterns -->
                <div class="dashboard-card">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-shield"></i>
                      Attack Patterns
                    </div>
                  </div>
                  <div id="attackPatternsContainer">
                    <div class="loading-card">
                      <div class="loading-spinner"></div>
                      <p>Loading attack patterns...</p>
                    </div>
                  </div>
                </div>

                <!-- Recent Completions -->
                <div class="dashboard-card" style="grid-column: span 2;">
                  <div class="dashboard-card-header">
                    <div class="dashboard-card-title">
                      <i class="fa fa-check-circle"></i>
                      Recently Completed Stories
                    </div>
                  </div>
                  <div id="recentCompletionsContainer">
                    <table class="modern-table">
                      <thead>
                        <tr>
                          <th>Story Name</th>
                          <th>User</th>
                          <th>Status</th>
                          <th>Duration</th>
                          <th>Completed</th>
                        </tr>
                      </thead>
                      <tbody id="completionsTableBody">
                        <tr>
                          <td colspan="5" style="text-align: center; padding: 2rem; color: #64748b;">
                            <i class="fa fa-spinner fa-spin"></i> Loading completions...
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <!-- Live Timeline CTA -->
              <div style="background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%); border-radius: 12px; padding: 1.25rem 1.5rem; margin-top: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                <div style="color: white;">
                  <div style="font-weight: 700; font-size: 1rem; margin-bottom: 0.25rem;">
                    <i class="fa fa-rss"></i> Live Story Timeline
                  </div>
                  <div style="font-size: 0.85rem; opacity: 0.85;">
                    Watch story chapters execute in real time — chapter by chapter, query by query, user by user
                  </div>
                </div>
                <a href="/loggedIn/live-timeline.ftl" style="display:inline-flex; align-items:center; gap:0.4rem; padding:0.6rem 1.25rem; background:white; color:#4d636f; border-radius:8px; font-weight:700; font-size:0.875rem; text-decoration:none; transition:all 0.2s;" onmouseover="this.style.background='#f1f5f9'" onmouseout="this.style.background='white'">
                  <i class="fa fa-clock-o"></i> Open Timeline
                </a>
              </div>

              <!-- Last Updated -->
              <div style="text-align: center; margin-top: 1.5rem; color: #64748b; font-size: 0.875rem;">
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
const REFRESH_INTERVAL = 5000; // 5 seconds

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

// Refresh all dashboard data
function refreshAllData() {
    loadStoryStatistics();
    loadQueryStatistics();
    loadUserActivity();
    loadActiveExecutions();
    loadAttackPatterns();
    loadRecentCompletions();
    updateTimestamp();
}

// Load story statistics
function loadStoryStatistics() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getAllStories',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(stories) {
            displayStoryStatistics(stories);
        },
        error: function(xhr, status, error) {
            console.error('Error loading stories:', error);
            showError('storyStatsContainer', 'Failed to load story statistics');
        }
    });
}

// Display story statistics
function displayStoryStatistics(stories) {
    const container = $('#storyStatsContainer');
    
    if (!stories || stories.length === 0) {
        container.html(`
            <div class="empty-state">
                <div class="empty-state-icon"><i class="fa fa-book"></i></div>
                <div class="empty-state-title">No Stories Found</div>
                <div class="empty-state-text">Create stories to see statistics</div>
            </div>
        `);
        $('#totalStories').text('0');
        return;
    }
    
    // Count by type
    const typeCounts = {};
    stories.forEach(story => {
        const type = story.story_type || 'Unknown';
        typeCounts[type] = (typeCounts[type] || 0) + 1;
    });
    
    let html = '<div style="padding: 1rem;">';
    html += '<div style="text-align: center; margin-bottom: 1.5rem;">' +
        '<div style="font-size: 2.5rem; font-weight: 700; color: #4d636f;">' + stories.length + '</div>' +
        '<div style="font-size: 0.875rem; color: #64748b;">Total Stories</div>' +
        '</div>';
    
    const colors = ['#4d636f', '#10b981', '#f59e0b', '#ef4444', '#3b82f6'];
    let colorIndex = 0;
    
    for (const [type, count] of Object.entries(typeCounts)) {
        const percentage = ((count / stories.length) * 100).toFixed(1);
        const color = colors[colorIndex % colors.length];
        colorIndex++;
        
        html += '<div style="margin-bottom: 1rem;">' +
            '<div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">' +
            '<span style="font-weight: 600; color: #1e293b;">' +
            '<i class="fa fa-bookmark" style="color: ' + color + ';"></i> ' + type +
            '</span>' +
            '<span style="color: #64748b;">' + count + '</span>' +
            '</div>' +
            '<div class="progress-bar-container">' +
            '<div class="progress-bar-fill" style="width: ' + percentage + '%; background: ' + color + ';"></div>' +
            '</div>' +
            '</div>';
    }
    
    html += '</div>';
    container.html(html);
    $('#totalStories').text(stories.length);
}

// Load query statistics
function loadQueryStatistics() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getQueryTypes',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(queryTypes) {
            // Also get all queries using the correct endpoint
            $.ajax({
                url: '/api/getDatabaseQuery',
                type: 'POST',
                data: jsonData,
                contentType: 'application/json; charset=utf-8',
                success: function(queries) {
                    displayQueryStatistics(queryTypes, queries);
                },
                error: function(xhr, status, error) {
                    console.error('Error loading queries:', error);
                    displayQueryStatistics(queryTypes, []);
                }
            });
        },
        error: function(xhr, status, error) {
            console.error('Error loading query types:', error);
            showError('queryStatsContainer', 'Failed to load query statistics');
        }
    });
}

// Display query statistics
function displayQueryStatistics(queryTypes, queries) {
    const container = $('#queryStatsContainer');
    
    const totalQueries = queries ? queries.length : 0;
    const totalTypes = queryTypes ? queryTypes.length : 0;
    
    let html = '<div style="padding: 1rem;">';
    html += '<div style="text-align: center; margin-bottom: 1.5rem;">' +
        '<div style="font-size: 2.5rem; font-weight: 700; color: #f59e0b;">' + totalQueries + '</div>' +
        '<div style="font-size: 0.875rem; color: #64748b;">Total Queries</div>' +
        '</div>' +
        '<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem; margin-bottom: 1rem;">' +
        '<div style="text-align: center; padding: 1rem; background: #f8fafc; border-radius: 8px;">' +
        '<div style="font-size: 1.5rem; font-weight: 600; color: #4d636f;">' + totalTypes + '</div>' +
        '<div style="font-size: 0.75rem; color: #64748b;">Query Types</div>' +
        '</div>' +
        '<div style="text-align: center; padding: 1rem; background: #f8fafc; border-radius: 8px;">' +
        '<div style="font-size: 1.5rem; font-weight: 600; color: #4d636f;">' + totalQueries + '</div>' +
        '<div style="font-size: 0.75rem; color: #64748b;">Statements</div>' +
        '</div>' +
        '</div>';
    
    if (queryTypes && queryTypes.length > 0) {
        html += '<div style="margin-top: 1rem;">';
        html += '<div style="font-weight: 600; margin-bottom: 0.5rem; color: #1e293b;">Query Types:</div>';
        queryTypes.slice(0, 5).forEach((type, index) => {
            const colors = ['#4d636f', '#10b981', '#f59e0b', '#ef4444', '#3b82f6'];
            html += '<div style="display: inline-block; margin: 0.25rem; padding: 0.25rem 0.75rem; background: ' +
                colors[index % colors.length] + '; color: white; border-radius: 9999px; font-size: 0.75rem;">' +
                type.query_type +
                '</div>';
        });
        html += '</div>';
    }
    
    html += '</div>';
    container.html(html);
    $('#totalQueries').text(totalQueries);
}

// Load user activity - uses database connections as proxy for active users
function loadUserActivity() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getAllDatabaseConnections',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(connections) {
            displayUserActivity(connections);
        },
        error: function(xhr, status, error) {
            console.error('Error loading connections:', error);
            showError('userActivityContainer', 'Failed to load connection activity');
        }
    });
}

// Display user activity (database connections)
function displayUserActivity(connections) {
    const container = $('#userActivityContainer');
    
    if (!connections || connections.length === 0) {
        container.html(
            '<div class="empty-state">' +
            '<div class="empty-state-icon"><i class="fa fa-plug"></i></div>' +
            '<div class="empty-state-title">No Connections Found</div>' +
            '<div class="empty-state-text">Add database connections to see activity</div>' +
            '</div>'
        );
        $('#totalUsers').text('0');
        $('#userCount').text('0 connections');
        return;
    }
    
    let html = '';
    connections.forEach(function(conn) {
        const isActive = conn.status === 'active' || conn.status === 'validated' || conn.validated;
        const dbType = conn.db_type || conn.dbType || conn.type || 'DB';
        const initial = dbType.charAt(0).toUpperCase();
        const name = conn.db_connection_name || conn.name || conn.hostname || 'Connection';
        const host = conn.hostname || conn.host || '';
        const statusStyle = isActive
            ? 'background: #d1fae5; color: #065f46;'
            : 'background: #fee2e2; color: #991b1b;';
        const statusText = isActive ? 'Active' : 'Inactive';
        
        html += '<div style="padding: 0.85rem 1rem; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center;">' +
            '<div style="display: flex; align-items: center; gap: 0.75rem;">' +
            '<div style="width: 38px; height: 38px; border-radius: 50%; background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 0.85rem;">' +
            initial +
            '</div>' +
            '<div>' +
            '<div style="font-weight: 600; color: #1e293b; font-size: 0.875rem;">' + name + '</div>' +
            '<div style="font-size: 0.75rem; color: #64748b;">' + dbType + (host ? ' · ' + host : '') + '</div>' +
            '</div>' +
            '</div>' +
            '<span style="padding: 0.2rem 0.65rem; border-radius: 9999px; font-size: 0.72rem; font-weight: 600; ' + statusStyle + '">' +
            statusText +
            '</span>' +
            '</div>';
    });
    
    container.html(html);
    $('#totalUsers').text(connections.length);
    $('#userCount').text(connections.length + ' connections');
}

// Live execution tracking via WebSocket
var liveExecutions = {};
var wsConnected = false;

function loadActiveExecutions() {
    if (!wsConnected) {
        connectExecutionWebSocket();
    }
}

function connectExecutionWebSocket() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = protocol + '//' + window.location.host + '/websocket/story/username';
    
    try {
        const ws = new WebSocket(wsUrl);
        
        ws.addEventListener('open', function() {
            wsConnected = true;
            console.log('Analytics WebSocket connected');
        });
        
        ws.addEventListener('message', function(event) {
            try {
                const msg = JSON.parse(event.data);
                const parts = (msg.datasource || '').split('_');
                const dbType   = parts[0] || '';
                const hostname = parts[1] || '';
                const db       = parts[2] || '';
                const user     = parts[3] || 'unknown';
                const key = msg.datasource || 'unknown';
                
                if (!liveExecutions[key]) {
                    liveExecutions[key] = { user: user, db: db, dbType: dbType, hostname: hostname, queryCount: 0, lastSeen: new Date() };
                }
                liveExecutions[key].queryCount++;
                liveExecutions[key].lastSeen = new Date();
                
                renderActiveExecutions();
            } catch(e) {
                console.error('Error parsing WS message:', e);
            }
        });
        
        ws.addEventListener('close', function() {
            wsConnected = false;
        });
        
        ws.addEventListener('error', function() {
            wsConnected = false;
        });
    } catch(e) {
        console.error('WebSocket connection failed:', e);
    }
}

function renderActiveExecutions() {
    const container = $('#activeExecutionsContainer');
    const keys = Object.keys(liveExecutions);
    
    if (keys.length === 0) {
        container.html(
            '<div class="empty-state">' +
            '<div class="empty-state-icon"><i class="fa fa-play-circle"></i></div>' +
            '<div class="empty-state-title">No Active Executions</div>' +
            '<div class="empty-state-text">Stories will appear here when running</div>' +
            '</div>'
        );
        $('#activeExecutions').text('0');
        $('#activeCount').text('0 running');
        return;
    }
    
    let html = '';
    keys.forEach(function(key) {
        const exec = liveExecutions[key];
        html += '<div style="padding: 0.85rem 1rem; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center;">' +
            '<div>' +
            '<div style="font-weight: 600; color: #1e293b; font-size: 0.875rem;"><i class="fa fa-user" style="color:#4d636f;"></i> ' + exec.user + '</div>' +
            '<div style="font-size: 0.75rem; color: #64748b;">' + exec.dbType + ' · ' + exec.hostname + ' · ' + exec.db + '</div>' +
            '</div>' +
            '<div style="text-align:right;">' +
            '<span style="background:#dbeafe; color:#1e40af; padding:0.2rem 0.65rem; border-radius:9999px; font-size:0.72rem; font-weight:600;">' +
            '<i class="fa fa-spinner fa-spin"></i> ' + exec.queryCount + ' queries</span>' +
            '</div>' +
            '</div>';
    });
    
    container.html(html);
    $('#activeExecutions').text(keys.length);
    $('#activeCount').text(keys.length + ' running');
}

// Load attack patterns - uses outlier scripts stats
function loadAttackPatterns() {
    const container = $('#attackPatternsContainer');
    
    $.ajax({
        url: '/api/outliers/stats',
        type: 'GET',
        success: function(stats) {
            if (!stats) {
                showOutlierPlaceholder(container);
                return;
            }
            let html = '<div style="padding: 1rem;">';
            const items = [
                { label: 'Total Scripts',   value: stats.totalScripts   || 0, color: '#4d636f',  icon: 'fa-code' },
                { label: 'Enabled Scripts', value: stats.enabledScripts || 0, color: '#10b981',  icon: 'fa-check-circle' },
                { label: 'Script Types',    value: stats.totalTypes     || 0, color: '#f59e0b',  icon: 'fa-tags' },
                { label: 'Packages',        value: stats.totalPackages  || 0, color: '#3b82f6',  icon: 'fa-cube' }
            ];
            items.forEach(function(item) {
                html += '<div style="display:flex; justify-content:space-between; align-items:center; padding:0.75rem 0; border-bottom:1px solid #f1f5f9;">' +
                    '<span style="color:#475569; font-size:0.875rem;"><i class="fa ' + item.icon + '" style="color:' + item.color + '; width:18px;"></i> ' + item.label + '</span>' +
                    '<span style="font-weight:700; color:' + item.color + ';">' + item.value + '</span>' +
                    '</div>';
            });
            html += '</div>';
            container.html(html);
        },
        error: function() {
            showOutlierPlaceholder(container);
        }
    });
}

function showOutlierPlaceholder(container) {
    container.html(
        '<div class="empty-state">' +
        '<div class="empty-state-icon"><i class="fa fa-shield"></i></div>' +
        '<div class="empty-state-title">Outlier Scripts</div>' +
        '<div class="empty-state-text">No outlier data available</div>' +
        '</div>'
    );
}

// Load recent completions - shows stories list
function loadRecentCompletions() {
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    const tbody = $('#completionsTableBody');
    
    $.ajax({
        url: '/api/getAllStories',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(stories) {
            if (!stories || stories.length === 0) {
                tbody.html(
                    '<tr><td colspan="5" style="text-align:center; padding:2rem; color:#64748b;">' +
                    '<i class="fa fa-book"></i> No stories found. Create stories to see them here.' +
                    '</td></tr>'
                );
                return;
            }
            let html = '';
            // Show up to 10 most recent stories
            stories.slice(0, 10).forEach(function(story) {
                // Story metadata is nested in story.story object
                const storyData = story.story || {};
                const name   = storyData.name        || story.name        || story.story_name  || 'Unnamed Story';
                const author = storyData.author      || story.author      || story.created_by  || '—';
                const type   = storyData.story_type  || story.story_type  || story.type        || 'Standard';
                const id     = story.id              || story.story_id    || '';
                const chapters = (storyData.story && Array.isArray(storyData.story)) ? storyData.story.length : (story.chapter_count || '—');
                
                html += '<tr>' +
                    '<td style="font-weight:600; color:#1e293b;">' + name + '</td>' +
                    '<td style="color:#64748b;">' + author + '</td>' +
                    '<td><span style="background:#dbeafe; color:#1e40af; padding:0.2rem 0.6rem; border-radius:9999px; font-size:0.75rem; font-weight:600;">' + type + '</span></td>' +
                    '<td style="color:#64748b;">' + chapters + ' chapters</td>' +
                    '<td><a href="/loggedIn/myStories.ftl?storyID=' + id + '" style="color:#4d636f; font-weight:600; text-decoration:none;"><i class="fa fa-play"></i> Run</a></td>' +
                    '</tr>';
            });
            tbody.html(html);
        },
        error: function(xhr, status, error) {
            tbody.html(
                '<tr><td colspan="5" style="text-align:center; padding:2rem; color:#ef4444;">' +
                '<i class="fa fa-exclamation-triangle"></i> Failed to load stories: ' + error +
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
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>
</body>
</html>