<!DOCTYPE html>
<html>
<head>
<title>SLP Health Dashboard</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/health-dashboard.css">
<script src="js/jquery.min.js"></script>
<link rel='stylesheet' href='css/fonts.css'>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Roboto", normal}
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
    <div class="w3-col m12">
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
                  <i class="fa fa-heartbeat"></i> Health Dashboard
                </span>
              </div>
              
              <h6 class="w3-opacity">Health Dashboard</h6>
              
              <!-- Health Dashboard Content -->
              <div class="health-dashboard-container">
                <div class="health-dashboard-inner">
                  <div class="health-header">
                    <h1>🏥 Scenario Launch Platform</h1>
                    <p>Health & Metrics Dashboard</p>
                    <button class="log-toggle-btn" onclick="toggleLogPanel()">📋 View Logs</button>
                  </div>

                  <div class="health-dashboard">
                    <!-- System Health Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">System Health</div>
                        <span id="health-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="health-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading health data...</span>
                        </div>
                      </div>
                    </div>

                    <!-- HTTP Metrics Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">📊 HTTP Requests</div>
                        <span id="http-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="http-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading HTTP metrics...</span>
                        </div>
                      </div>
                    </div>

                    <!-- Database Metrics Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">💾 Database</div>
                        <span id="db-metrics-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="db-metrics-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading database metrics...</span>
                        </div>
                      </div>
                    </div>

                    <!-- Story Metrics Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">📖 Story Execution</div>
                        <span id="story-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="story-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading story metrics...</span>
                        </div>
                      </div>
                    </div>

                    <!-- Error Metrics Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">⚠️ Errors</div>
                        <span id="error-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="error-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading error metrics...</span>
                        </div>
                      </div>
                    </div>

                    <!-- Memory Usage Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">💻 Memory Usage</div>
                        <span id="memory-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="memory-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading memory info...</span>
                        </div>
                      </div>
                    </div>

                    <!-- System Info Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">🖥️ System Information</div>
                        <span id="system-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="system-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading system info...</span>
                        </div>
                      </div>
                    </div>

                    <!-- Uptime Card -->
                    <div class="health-card">
                      <div class="health-card-header">
                        <div class="health-card-title">⏱️ Uptime & Performance</div>
                        <span id="uptime-status" class="health-status-badge health-status-loading">Loading...</span>
                      </div>
                      <div id="uptime-content">
                        <div class="health-metric-row health-loading">
                          <span class="health-metric-label">Loading uptime info...</span>
                        </div>
                      </div>
                    </div>
                  </div>

                  <div class="health-refresh-info">
                    ⟳ Auto-refreshing every 5 seconds
                  </div>
                  <div class="health-timestamp" id="last-update">
                    Last updated: Never
                  </div>
                </div>
              </div>
              <!-- End Health Dashboard Content -->
              
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

<!-- Log Panel -->
<div class="health-log-panel" id="logPanel">
  <div class="health-log-panel-header">
    <div class="health-log-panel-title">📋 Application Logs</div>
    <div class="health-log-panel-controls">
      <button class="health-log-btn" onclick="clearLogs()">Clear</button>
      <button class="health-log-btn" onclick="toggleAutoScroll()">
        <span id="autoscroll-text">Auto-scroll: ON</span>
      </button>
      <button class="health-log-btn close" onclick="toggleLogPanel()">✕ Close</button>
    </div>
  </div>
  <div class="health-log-content" id="logContent">
    <div class="health-log-entry">
      <span class="health-log-time">--:--:--</span>
      <span class="health-log-level INFO">INFO</span>
      <span class="health-log-message">Connecting to log stream...</span>
    </div>
  </div>
  <div class="health-log-status">
    <div>
      <span class="health-connection-status disconnected" id="connectionStatus"></span>
      <span id="connectionText">Disconnected</span>
    </div>
    <div id="logCount">0 logs</div>
  </div>
</div>

<script>
// Log Panel Management
let logPanelOpen = false;
let autoScroll = true;
let logSocket = null;
let logCount = 0;

function toggleLogPanel() {
    logPanelOpen = !logPanelOpen;
    document.getElementById('logPanel').classList.toggle('open', logPanelOpen);
    
    if (logPanelOpen && !logSocket) {
        connectLogStream();
    }
}

function toggleAutoScroll() {
    autoScroll = !autoScroll;
    document.getElementById('autoscroll-text').textContent = 'Auto-scroll: ' + (autoScroll ? 'ON' : 'OFF');
}

function clearLogs() {
    document.getElementById('logContent').innerHTML = '';
    logCount = 0;
    updateLogCount();
}

function updateLogCount() {
    document.getElementById('logCount').textContent = logCount + ' logs';
}

function connectLogStream() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = protocol + '//' + window.location.host + '/logs/stream';
    
    try {
        logSocket = new WebSocket(wsUrl);
        
        logSocket.onopen = function() {
            console.log('Log stream connected');
            document.getElementById('connectionStatus').className = 'health-connection-status connected';
            document.getElementById('connectionText').textContent = 'Connected';
            
            setInterval(function() {
                if (logSocket && logSocket.readyState === WebSocket.OPEN) {
                    logSocket.send('ping');
                }
            }, 30000);
        };
        
        logSocket.onmessage = function(event) {
            if (event.data === 'pong') {
                return;
            }
            
            try {
                const data = JSON.parse(event.data);
                
                if (data.type === 'history') {
                    data.logs.forEach(function(log) { addLogEntry(log); });
                } else if (data.type === 'log') {
                    addLogEntry(data.data);
                }
            } catch (e) {
                console.error('Failed to parse log message:', e, 'Data:', event.data);
            }
        };
        
        logSocket.onerror = function(error) {
            console.error('WebSocket error:', error);
            document.getElementById('connectionStatus').className = 'health-connection-status disconnected';
            document.getElementById('connectionText').textContent = 'Error';
        };
        
        logSocket.onclose = function() {
            console.log('Log stream disconnected');
            document.getElementById('connectionStatus').className = 'health-connection-status disconnected';
            document.getElementById('connectionText').textContent = 'Disconnected';
            logSocket = null;
            
            if (logPanelOpen) {
                setTimeout(function() {
                    if (logPanelOpen && !logSocket) {
                        connectLogStream();
                    }
                }, 5000);
            }
        };
    } catch (e) {
        console.error('Failed to connect to log stream:', e);
    }
}

function addLogEntry(log) {
    const logContent = document.getElementById('logContent');
    const logEntry = document.createElement('div');
    logEntry.className = 'health-log-entry ' + log.level;
    
    const loggerShort = log.logger.split('.').pop();
    
    let html = '<span class="health-log-time">' + log.time + '</span>' +
               '<span class="health-log-level ' + log.level + '">' + log.level + '</span>' +
               '<span class="health-log-logger">' + loggerShort + '</span>' +
               '<span class="health-log-message">' + escapeHtml(log.message) + '</span>';
    
    if (log.exception) {
        html += '<br><span class="health-log-message" style="color: #fca5a5;">↳ ' + 
                log.exception + ': ' + escapeHtml(log.exceptionMessage || '') + '</span>';
    }
    
    logEntry.innerHTML = html;
    logContent.appendChild(logEntry);
    logCount++;
    updateLogCount();
    
    while (logContent.children.length > 500) {
        logContent.removeChild(logContent.firstChild);
    }
    
    if (autoScroll) {
        logContent.scrollTop = logContent.scrollHeight;
    }
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Utility functions
function formatBytes(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

function formatUptime(ms) {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    const days = Math.floor(hours / 24);

    if (days > 0) return days + 'd ' + (hours % 24) + 'h ' + (minutes % 60) + 'm';
    if (hours > 0) return hours + 'h ' + (minutes % 60) + 'm';
    if (minutes > 0) return minutes + 'm ' + (seconds % 60) + 's';
    return seconds + 's';
}

function formatNumber(num) {
    return num.toLocaleString();
}

function getProgressClass(percent) {
    if (percent > 80) return 'danger';
    if (percent > 60) return 'warning';
    return '';
}

function getStatusClass(rate) {
    if (rate >= 95) return 'success';
    if (rate >= 80) return 'warning';
    return 'danger';
}

// Fetch health data
async function fetchHealth() {
    try {
        const response = await fetch('/health/detailed');
        const data = await response.json();
        updateHealthUI(data);
    } catch (error) {
        showError('health-content', 'Failed to fetch health data');
        document.getElementById('health-status').className = 'health-status-badge health-status-down';
        document.getElementById('health-status').textContent = 'Error';
    }
}

// Fetch all metrics data
async function fetchAllMetrics() {
    try {
        const response = await fetch('/api/metrics/all');
        const data = await response.json();
        updateAllMetricsUI(data);
    } catch (error) {
        console.error('Failed to fetch metrics:', error);
        showError('http-content', 'Metrics endpoint not available');
        showError('db-metrics-content', 'Metrics endpoint not available');
        showError('story-content', 'Metrics endpoint not available');
        showError('error-content', 'Metrics endpoint not available');
    }
}

// Fetch legacy metrics data
async function fetchMetrics() {
    try {
        const response = await fetch('/metrics');
        const data = await response.json();
        updateMetricsUI(data);
    } catch (error) {
        // Silently fail - not critical
    }
}

// Update Health UI
function updateHealthUI(data) {
    const healthStatus = document.getElementById('health-status');
    healthStatus.className = 'health-status-badge health-status-' + data.status.toLowerCase();
    healthStatus.textContent = data.status;

    const healthContent = document.getElementById('health-content');
    healthContent.innerHTML = 
        '<div class="health-metric-row">' +
        '<span class="health-metric-label">Application</span>' +
        '<span class="health-metric-value">' + data.application + '</span>' +
        '</div>' +
        '<div class="health-metric-row">' +
        '<span class="health-metric-label">Status</span>' +
        '<span class="health-metric-value">' + data.status + '</span>' +
        '</div>';

    // Memory Info
    if (data.memory) {
        const memUsed = data.memory.used;
        const memMax = data.memory.max;
        const memPercent = data.memory.usagePercent.toFixed(1);

        const memoryContent = document.getElementById('memory-content');
        memoryContent.innerHTML = 
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Used</span>' +
            '<span class="health-metric-value">' + formatBytes(memUsed) + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Max</span>' +
            '<span class="health-metric-value">' + formatBytes(memMax) + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Free</span>' +
            '<span class="health-metric-value">' + formatBytes(data.memory.free) + '</span>' +
            '</div>' +
            '<div class="health-progress-bar">' +
            '<div class="health-progress-fill ' + getProgressClass(memPercent) + '" style="width: ' + memPercent + '%">' +
            memPercent + '%' +
            '</div>' +
            '</div>';

        const memStatus = document.getElementById('memory-status');
        memStatus.className = 'health-status-badge ' + (memPercent > 80 ? 'health-status-down' : memPercent > 60 ? 'health-status-degraded' : 'health-status-up');
        memStatus.textContent = memPercent + '%';
    }

    // System Info
    if (data.system) {
        const systemContent = document.getElementById('system-content');
        systemContent.innerHTML = 
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">OS</span>' +
            '<span class="health-metric-value">' + data.system.osName + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Version</span>' +
            '<span class="health-metric-value">' + data.system.osVersion + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Java</span>' +
            '<span class="health-metric-value">' + data.system.javaVersion + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Processors</span>' +
            '<span class="health-metric-value">' + data.system.processors + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Uptime</span>' +
            '<span class="health-metric-value">' + formatUptime(data.system.uptime) + '</span>' +
            '</div>';

        document.getElementById('system-status').className = 'health-status-badge health-status-up';
        document.getElementById('system-status').textContent = 'Active';
    }
}

// Update All Metrics UI
function updateAllMetricsUI(data) {
    // HTTP Metrics
    if (data.http) {
        const http = data.http;
        const successRate = http.successRate || 0;
        
        const httpContent = document.getElementById('http-content');
        httpContent.innerHTML = 
            '<div class="health-big-number">' + formatNumber(http.totalRequests) + '</div>' +
            '<div class="health-mini-stats">' +
            '<div class="health-mini-stat">' +
            '<div class="health-mini-stat-value success">' + formatNumber(http.successfulRequests) + '</div>' +
            '<div class="health-mini-stat-label">Success</div>' +
            '</div>' +
            '<div class="health-mini-stat">' +
            '<div class="health-mini-stat-value danger">' + formatNumber(http.failedRequests) + '</div>' +
            '<div class="health-mini-stat-label">Failed</div>' +
            '</div>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Success Rate</span>' +
            '<span class="health-metric-value ' + getStatusClass(successRate) + '">' + successRate.toFixed(1) + '%</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Avg Response Time</span>' +
            '<span class="health-metric-value">' + http.averageResponseTimeMs.toFixed(0) + 'ms</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Active Requests</span>' +
            '<span class="health-metric-value">' + http.activeRequests + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Requests/sec</span>' +
            '<span class="health-metric-value">' + http.requestsPerSecond.toFixed(2) + '</span>' +
            '</div>';

        const httpStatus = document.getElementById('http-status');
        httpStatus.className = 'health-status-badge ' + (successRate >= 95 ? 'health-status-up' : successRate >= 80 ? 'health-status-degraded' : 'health-status-down');
        httpStatus.textContent = successRate.toFixed(0) + '%';
    }

    // Database Metrics
    if (data.database) {
        const db = data.database;
        const successRate = db.successRate || 0;
        
        const dbContent = document.getElementById('db-metrics-content');
        dbContent.innerHTML = 
            '<div class="health-big-number">' + formatNumber(db.totalQueries) + '</div>' +
            '<div class="health-mini-stats">' +
            '<div class="health-mini-stat">' +
            '<div class="health-mini-stat-value success">' + formatNumber(db.successfulQueries) + '</div>' +
            '<div class="health-mini-stat-label">Success</div>' +
            '</div>' +
            '<div class="health-mini-stat">' +
            '<div class="health-mini-stat-value danger">' + formatNumber(db.failedQueries) + '</div>' +
            '<div class="health-mini-stat-label">Failed</div>' +
            '</div>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Success Rate</span>' +
            '<span class="health-metric-value ' + getStatusClass(successRate) + '">' + successRate.toFixed(1) + '%</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Avg Query Time</span>' +
            '<span class="health-metric-value">' + db.averageQueryTimeMs.toFixed(0) + 'ms</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Active Connections</span>' +
            '<span class="health-metric-value">' + db.activeConnections + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Slow Queries</span>' +
            '<span class="health-metric-value ' + (db.slowQueries > 0 ? 'warning' : '') + '">' + db.slowQueries + '</span>' +
            '</div>';

        const dbStatus = document.getElementById('db-metrics-status');
        dbStatus.className = 'health-status-badge ' + (successRate >= 95 ? 'health-status-up' : successRate >= 80 ? 'health-status-degraded' : 'health-status-down');
        dbStatus.textContent = successRate.toFixed(0) + '%';
    }

    // Story Metrics
    if (data.stories) {
        const stories = data.stories;
        const successRate = stories.successRate || 0;
        
        const storyContent = document.getElementById('story-content');
        storyContent.innerHTML = 
            '<div class="health-big-number">' + formatNumber(stories.totalStories) + '</div>' +
            '<div class="health-mini-stats">' +
            '<div class="health-mini-stat">' +
            '<div class="health-mini-stat-value success">' + formatNumber(stories.successfulStories) + '</div>' +
            '<div class="health-mini-stat-label">Success</div>' +
            '</div>' +
            '<div class="health-mini-stat">' +
            '<div class="health-mini-stat-value danger">' + formatNumber(stories.failedStories) + '</div>' +
            '<div class="health-mini-stat-label">Failed</div>' +
            '</div>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Success Rate</span>' +
            '<span class="health-metric-value ' + getStatusClass(successRate) + '">' + successRate.toFixed(1) + '%</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Avg Execution Time</span>' +
            '<span class="health-metric-value">' + stories.averageExecutionTimeMs.toFixed(0) + 'ms</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Active Stories</span>' +
            '<span class="health-metric-value">' + stories.activeStories + '</span>' +
            '</div>';

        const storyStatus = document.getElementById('story-status');
        storyStatus.className = 'health-status-badge ' + (successRate >= 95 ? 'health-status-up' : successRate >= 80 ? 'health-status-degraded' : 'health-status-down');
        storyStatus.textContent = successRate.toFixed(0) + '%';
    }

    // Error Metrics
    if (data.errors) {
        const errors = data.errors;
        
        let errorListHtml = '';
        if (errors.recentErrors && errors.recentErrors.length > 0) {
            errorListHtml = '<div class="health-error-list">';
            errors.recentErrors.slice(0, 5).forEach(function(err) {
                const time = new Date(err.timestamp).toLocaleTimeString();
                errorListHtml += 
                    '<div class="health-error-item">' +
                    '<div class="health-error-type">' + err.type + '</div>' +
                    '<div class="health-error-time">' + time + '</div>' +
                    '<div>' + err.message.substring(0, 100) + (err.message.length > 100 ? '...' : '') + '</div>' +
                    '</div>';
            });
            errorListHtml += '</div>';
        }
        
        const errorContent = document.getElementById('error-content');
        errorContent.innerHTML = 
            '<div class="health-big-number ' + (errors.totalErrors > 0 ? 'danger' : 'success') + '">' + formatNumber(errors.totalErrors) + '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Total Errors</span>' +
            '<span class="health-metric-value ' + (errors.totalErrors > 0 ? 'danger' : 'success') + '">' + formatNumber(errors.totalErrors) + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Error Types</span>' +
            '<span class="health-metric-value">' + Object.keys(errors.errorsByType || {}).length + '</span>' +
            '</div>' +
            errorListHtml;

        const errorStatus = document.getElementById('error-status');
        if (errors.totalErrors === 0) {
            errorStatus.className = 'health-status-badge health-status-up';
            errorStatus.textContent = 'None';
        } else if (errors.totalErrors < 10) {
            errorStatus.className = 'health-status-badge health-status-degraded';
            errorStatus.textContent = errors.totalErrors.toString();
        } else {
            errorStatus.className = 'health-status-badge health-status-down';
            errorStatus.textContent = errors.totalErrors.toString();
        }
    }
}

// Update Legacy Metrics UI
function updateMetricsUI(data) {
    if (data.system) {
        const uptimeContent = document.getElementById('uptime-content');
        uptimeContent.innerHTML = 
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Uptime</span>' +
            '<span class="health-metric-value">' + formatUptime(data.system.uptime) + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Processors</span>' +
            '<span class="health-metric-value">' + data.system.processors + '</span>' +
            '</div>' +
            '<div class="health-metric-row">' +
            '<span class="health-metric-label">Active Threads</span>' +
            '<span class="health-metric-value">' + data.system.threads + '</span>' +
            '</div>';

        document.getElementById('uptime-status').className = 'health-status-badge health-status-up';
        document.getElementById('uptime-status').textContent = 'Running';
    }
}

function showError(elementId, message) {
    document.getElementById(elementId).innerHTML = 
        '<div class="health-error-message">' + message + '</div>';
}

function updateTimestamp() {
    const now = new Date();
    document.getElementById('last-update').textContent = 
        'Last updated: ' + now.toLocaleTimeString();
}

// Initial load
async function loadAll() {
    await Promise.all([fetchHealth(), fetchAllMetrics(), fetchMetrics()]);
    updateTimestamp();
}

// Load data immediately
loadAll();

// Refresh every 5 seconds
setInterval(loadAll, 5000);

// Load navbar and left column
$(document).ready(function() {
    $("#navbar").load("navbar.html");
    $("#leftColumn").load("leftColumn.html");
});
</script>

</body>
</html>