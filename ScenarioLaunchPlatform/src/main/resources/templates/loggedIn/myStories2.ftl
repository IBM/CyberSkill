<!DOCTYPE html>
<html>
<head>
<title>Live Story Feed - SLP</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel='stylesheet' href='css/fonts.css'>
<script src="js/jquery.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 { font-family: "Roboto", sans-serif; }

/* ── Page header ── */
.page-header {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white;
    border-radius: 12px;
    padding: 1.5rem 1.75rem;
    margin-bottom: 1.25rem;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.12);
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 1rem;
}

.page-header-left h4 {
    margin: 0 0 0.35rem 0;
    font-size: 1.4rem;
    font-weight: 700;
}

.page-header-left p {
    margin: 0;
    opacity: 0.85;
    font-size: 0.9rem;
}

/* ── Breadcrumb ── */
.breadcrumb-bar {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.55rem 0.75rem;
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
.breadcrumb-bar .current  { color: #64748b; }

/* ── Stats bar ── */
.stats-bar {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    margin-bottom: 1.25rem;
}

.stat-chip {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 9999px;
    font-size: 0.85rem;
    font-weight: 600;
    color: #475569;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}

.stat-chip i { color: #4d636f; }

.stat-chip .stat-value {
    background: #f1f5f9;
    color: #4d636f;
    padding: 0.1rem 0.5rem;
    border-radius: 9999px;
    font-size: 0.8rem;
    min-width: 24px;
    text-align: center;
}

/* ── WebSocket status badge ── */
.ws-status {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.4rem 1rem;
    border-radius: 9999px;
    font-size: 0.8rem;
    font-weight: 600;
}

.ws-status.connected    { background: #d1fae5; color: #065f46; }
.ws-status.disconnected { background: #fee2e2; color: #991b1b; }
.ws-status.connecting   { background: #fef3c7; color: #92400e; }

.pulse-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: currentColor;
    animation: pulse 1.5s infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50%       { opacity: 0.3; }
}

/* ── Chapter card ── */
.chapter-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1.25rem;
    margin-bottom: 1rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    transition: all 0.2s ease;
    animation: slideIn 0.3s ease;
}

.chapter-card:hover {
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    transform: translateY(-1px);
}

@keyframes slideIn {
    from { opacity: 0; transform: translateY(10px); }
    to   { opacity: 1; transform: translateY(0); }
}

.chapter-card-header {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 1rem;
    padding-bottom: 0.75rem;
    border-bottom: 1px solid #f1f5f9;
}

.chapter-avatar {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    background: linear-gradient(135deg, #4d636f, #3a4f5a);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 700;
    font-size: 1.1rem;
    flex-shrink: 0;
}

.chapter-title {
    font-weight: 600;
    color: #1e293b;
    font-size: 1rem;
}

.chapter-subtitle {
    color: #64748b;
    font-size: 0.85rem;
    margin-top: 0.2rem;
}

.chapter-details {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 0.75rem;
    margin-bottom: 1rem;
}

.chapter-detail-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    font-size: 0.875rem;
    color: #475569;
}

.chapter-detail-item i {
    color: #4d636f;
    width: 16px;
    text-align: center;
}

.chapter-badge {
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.25rem 0.75rem;
    border-radius: 9999px;
    font-size: 0.75rem;
    font-weight: 600;
    background: #f1f5f9;
    color: #475569;
    margin-right: 0.5rem;
}

.chapter-badge.success { background: #d1fae5; color: #065f46; }
.chapter-badge.info    { background: #dbeafe; color: #1e40af; }

/* ── Empty / waiting state ── */
.empty-state {
    text-align: center;
    padding: 3rem 2rem;
    color: #64748b;
}

.empty-state-icon {
    font-size: 3rem;
    margin-bottom: 1rem;
    opacity: 0.4;
}

.empty-state-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: #475569;
    margin-bottom: 0.5rem;
}

.empty-state-text {
    font-size: 0.9rem;
    color: #94a3b8;
}

/* ── Section card wrapper ── */
.section-card {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    overflow: hidden;
    margin-bottom: 1.25rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}

.section-card-header {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white;
    padding: 0.85rem 1.25rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.section-card-header h6 {
    margin: 0;
    font-size: 0.95rem;
    font-weight: 600;
}

.section-card-body {
    padding: 1.25rem;
}

/* ── Clear button ── */
.btn-clear {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.35rem 0.9rem;
    background: rgba(255,255,255,0.15);
    color: white;
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 8px;
    font-size: 0.8rem;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
}

.btn-clear:hover { background: rgba(255,255,255,0.25); }
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1400px; margin-top:80px;">
  <div class="w3-row">

    <!-- Left Column -->
    <div id="leftColumn"></div>
    <!-- End Left Column -->

    <!-- Middle Column -->
    <div class="w3-col m9">
      <div class="w3-row-padding">
        <div class="w3-col m12">

          <!-- Breadcrumb -->
          <div class="breadcrumb-bar">
            <a href="/loggedIn/contentpacks.ftl"><i class="fa fa-home"></i> Content Packs</a>
            <span class="separator">›</span>
            <a href="/loggedIn/myStories.ftl"><i class="fa fa-book"></i> My Stories</a>
            <span class="separator">›</span>
            <span class="current"><i class="fa fa-rss"></i> Live Feed</span>
          </div>

          <!-- Page Header -->
          <div class="page-header">
            <div class="page-header-left">
              <h4><i class="fa fa-rss"></i> Live Story Feed</h4>
              <p>Real-time WebSocket stream of story chapter executions</p>
            </div>
            <div>
              <span class="ws-status connecting" id="wsStatus">
                <span class="pulse-dot"></span>
                Connecting...
              </span>
            </div>
          </div>

          <!-- Stats Bar -->
          <div class="stats-bar">
            <div class="stat-chip">
              <i class="fa fa-list-ol"></i>
              Chapters received
              <span class="stat-value" id="chapterCount">0</span>
            </div>
            <div class="stat-chip">
              <i class="fa fa-users"></i>
              Unique users
              <span class="stat-value" id="userCount">0</span>
            </div>
            <div class="stat-chip">
              <i class="fa fa-database"></i>
              Databases seen
              <span class="stat-value" id="dbCount">0</span>
            </div>
          </div>

          <!-- Live Feed Section -->
          <div class="section-card">
            <div class="section-card-header">
              <h6><i class="fa fa-rss"></i> Incoming Chapters</h6>
              <button class="btn-clear" onclick="clearFeed()">
                <i class="fa fa-trash"></i> Clear
              </button>
            </div>
            <div class="section-card-body">
              <div id="StoryChaptersCompleted">
                <div class="empty-state" id="waitingState">
                  <div class="empty-state-icon"><i class="fa fa-spinner fa-spin"></i></div>
                  <div class="empty-state-title">Waiting for story chapters...</div>
                  <div class="empty-state-text">Chapters will appear here as stories execute in real time</div>
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

<div id="footer"></div>

<script>
// ── Load includes ──────────────────────────────────────────────────────────
$(document).ready(function() {
    $.ajax({
        url: '/loggedIn/includes/navbar.ftl',
        method: 'GET',
        success: function(r) { $('#navbar').html(r); },
        error: function(e) { console.error('Error loading navbar:', e); }
    });

    $.ajax({
        url: '/loggedIn/includes/leftColumn.ftl',
        method: 'GET',
        success: function(r) { $('#leftColumn').html(r); },
        error: function(e) { console.error('Error loading left column:', e); }
    });

    $.ajax({
        url: '/loggedIn/includes/footer.ftl',
        method: 'GET',
        success: function(r) { $('#footer').html(r); },
        error: function(e) { console.error('Error loading footer:', e); }
    });
});

// ── Stats tracking ─────────────────────────────────────────────────────────
var chapterCount = 0;
var seenUsers    = new Set();
var seenDbs      = new Set();

function updateStats() {
    $('#chapterCount').text(chapterCount);
    $('#userCount').text(seenUsers.size);
    $('#dbCount').text(seenDbs.size);
}

function clearFeed() {
    chapterCount = 0;
    seenUsers.clear();
    seenDbs.clear();
    updateStats();
    $('#StoryChaptersCompleted').html(
        '<div class="empty-state" id="waitingState">' +
        '<div class="empty-state-icon"><i class="fa fa-spinner fa-spin"></i></div>' +
        '<div class="empty-state-title">Waiting for story chapters...</div>' +
        '<div class="empty-state-text">Chapters will appear here as stories execute in real time</div>' +
        '</div>'
    );
}

// ── WebSocket ──────────────────────────────────────────────────────────────
const relativeUrl = '/websocket/story/username';
const protocol    = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
const wsUrl       = protocol + '//' + window.location.host + relativeUrl;

const socket = new WebSocket(wsUrl);

socket.addEventListener('open', function() {
    console.log('Connected to WebSocket server');
    $('#wsStatus')
        .removeClass('connecting disconnected')
        .addClass('connected')
        .html('<span class="pulse-dot"></span> Live');
});

socket.addEventListener('message', function(event) {
    console.log('Message from server:', event.data);

    var msg = JSON.parse(event.data);

    var parts    = msg.datasource.split('_');
    var dbType   = parts[0] || '';
    var hostname = parts[1] || '';
    var db       = parts[2] || '';
    var user     = parts[3] || 'unknown';

    var chapter = msg.chapter || (user + ' executed a query');

    // Update stats
    chapterCount++;
    seenUsers.add(user);
    seenDbs.add(db);
    updateStats();

    // Remove waiting state on first message
    if (chapterCount === 1) {
        $('#waitingState').remove();
    }

    var initials = user.substring(0, 2).toUpperCase();

    var html =
        '<div class="chapter-card">' +
          '<div class="chapter-card-header">' +
            '<div class="chapter-avatar">' + initials + '</div>' +
            '<div>' +
              '<div class="chapter-title"><i class="fa fa-user"></i> ' + user + '</div>' +
              '<div class="chapter-subtitle">Chapter ' + chapterCount + ' &middot; ' + chapter + '</div>' +
            '</div>' +
          '</div>' +
          '<div class="chapter-details">' +
            '<div class="chapter-detail-item"><i class="fa fa-server"></i><span>' + dbType + '</span></div>' +
            '<div class="chapter-detail-item"><i class="fa fa-map-marker"></i><span>' + hostname + '</span></div>' +
            '<div class="chapter-detail-item"><i class="fa fa-database"></i><span>' + db + '</span></div>' +
            (msg.pause_in_seconds ? '<div class="chapter-detail-item"><i class="fa fa-clock-o"></i><span>Pause: ' + msg.pause_in_seconds + 's</span></div>' : '') +
          '</div>' +
          '<div>' +
            '<span class="chapter-badge success"><i class="fa fa-check"></i> Executed</span>' +
            '<span class="chapter-badge info"><i class="fa fa-hashtag"></i> Query ' + msg.query_id + '</span>' +
          '</div>' +
        '</div>';

    $('#StoryChaptersCompleted').append(html);
});

socket.addEventListener('error', function(error) {
    console.error('WebSocket error:', error);
    $('#wsStatus')
        .removeClass('connecting connected')
        .addClass('disconnected')
        .html('<span class="pulse-dot"></span> Error');
});

socket.addEventListener('close', function() {
    console.log('WebSocket connection closed');
    $('#wsStatus')
        .removeClass('connecting connected')
        .addClass('disconnected')
        .html('<span class="pulse-dot"></span> Disconnected');
});
</script>

</body>
</html>
