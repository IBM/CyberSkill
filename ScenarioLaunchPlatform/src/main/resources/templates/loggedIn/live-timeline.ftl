<!DOCTYPE html>
<html>
<head>
<title>Live Story Timeline - SLP</title>
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
*, *::before, *::after { box-sizing: border-box; }

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
.page-header h4 { margin: 0 0 0.35rem 0; font-size: 1.4rem; font-weight: 700; }
.page-header p  { margin: 0; opacity: 0.85; font-size: 0.9rem; }

/* ── Breadcrumb ── */
.breadcrumb-bar {
    display: flex; align-items: center; gap: 0.5rem;
    padding: 0.55rem 0.75rem;
    background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;
    margin-bottom: 1.25rem; font-size: 0.875rem;
}
.breadcrumb-bar a { color: #4d636f; text-decoration: none; font-weight: 500; }
.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar .separator { color: #94a3b8; }
.breadcrumb-bar .current   { color: #64748b; }

/* ── Stats bar ── */
.stats-bar { display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 1.25rem; }
.stat-chip {
    display: inline-flex; align-items: center; gap: 0.5rem;
    padding: 0.5rem 1rem;
    background: white; border: 1px solid #e2e8f0; border-radius: 9999px;
    font-size: 0.85rem; font-weight: 600; color: #475569;
    box-shadow: 0 1px 3px rgba(0,0,0,0.05);
}
.stat-chip i { color: #4d636f; }
.stat-chip .val {
    background: #f1f5f9; color: #4d636f;
    padding: 0.1rem 0.5rem; border-radius: 9999px;
    font-size: 0.8rem; min-width: 24px; text-align: center;
    transition: all 0.3s ease;
}
.stat-chip .val.bump { background: #4d636f; color: white; }

/* ── WS status ── */
.ws-badge {
    display: inline-flex; align-items: center; gap: 0.5rem;
    padding: 0.4rem 1rem; border-radius: 9999px;
    font-size: 0.8rem; font-weight: 600;
}
.ws-badge.connecting   { background: #fef3c7; color: #92400e; }
.ws-badge.connected    { background: #d1fae5; color: #065f46; }
.ws-badge.disconnected { background: #fee2e2; color: #991b1b; }
.pulse-dot {
    width: 8px; height: 8px; border-radius: 50%;
    background: currentColor; animation: pulse 1.5s infinite;
}
@keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.3} }

/* ── Story track cards ── */
.story-track {
    background: white; border: 1px solid #e2e8f0; border-radius: 12px;
    overflow: hidden; margin-bottom: 1.25rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    animation: slideIn 0.3s ease;
}
@keyframes slideIn { from{opacity:0;transform:translateY(8px)} to{opacity:1;transform:translateY(0)} }

.story-track-header {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white; padding: 0.9rem 1.25rem;
    display: flex; justify-content: space-between; align-items: center;
    flex-wrap: wrap; gap: 0.5rem;
}
.story-track-title { font-weight: 700; font-size: 1rem; }
.story-track-meta  { font-size: 0.8rem; opacity: 0.85; margin-top: 0.15rem; }

.story-track-badges { display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap; }
.badge {
    display: inline-flex; align-items: center; gap: 0.3rem;
    padding: 0.2rem 0.65rem; border-radius: 9999px;
    font-size: 0.72rem; font-weight: 600;
}
.badge-white  { background: rgba(255,255,255,0.2); color: white; }
.badge-green  { background: #d1fae5; color: #065f46; }
.badge-blue   { background: #dbeafe; color: #1e40af; }
.badge-amber  { background: #fef3c7; color: #92400e; }
.badge-red    { background: #fee2e2; color: #991b1b; }

/* ── Progress bar ── */
.progress-wrap {
    padding: 0.6rem 1.25rem;
    background: #f8fafc; border-bottom: 1px solid #e2e8f0;
    display: flex; align-items: center; gap: 1rem;
}
.progress-bar-bg {
    flex: 1; height: 8px; background: #e2e8f0; border-radius: 9999px; overflow: hidden;
}
.progress-bar-fill {
    height: 100%; background: linear-gradient(90deg, #4d636f, #10b981);
    border-radius: 9999px; transition: width 0.5s ease;
}
.progress-label { font-size: 0.78rem; font-weight: 600; color: #4d636f; white-space: nowrap; }

/* ── Timeline ── */
.timeline-container {
    padding: 1rem 1.25rem;
    max-height: 420px;
    overflow-y: auto;
}
.timeline-container::-webkit-scrollbar { width: 6px; }
.timeline-container::-webkit-scrollbar-track { background: #f1f5f9; }
.timeline-container::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

.timeline { position: relative; padding-left: 2rem; }
.timeline::before {
    content: '';
    position: absolute; left: 0.65rem; top: 0; bottom: 0;
    width: 2px; background: #e2e8f0;
}

.timeline-item {
    position: relative; margin-bottom: 1rem;
    animation: fadeIn 0.25s ease;
}
@keyframes fadeIn { from{opacity:0} to{opacity:1} }

.timeline-dot {
    position: absolute; left: -1.65rem; top: 0.2rem;
    width: 14px; height: 14px; border-radius: 50%;
    background: #4d636f; border: 2px solid white;
    box-shadow: 0 0 0 2px #4d636f;
    z-index: 1;
}
.timeline-dot.latest {
    background: #10b981;
    box-shadow: 0 0 0 2px #10b981;
    animation: glow 1.5s infinite;
}
@keyframes glow {
    0%,100% { box-shadow: 0 0 0 2px #10b981; }
    50%      { box-shadow: 0 0 0 5px rgba(16,185,129,0.3); }
}

.timeline-card {
    background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;
    padding: 0.75rem 1rem;
    transition: box-shadow 0.2s;
}
.timeline-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
.timeline-card.latest-card {
    background: #f0fdf4; border-color: #86efac;
}

.timeline-card-top {
    display: flex; justify-content: space-between; align-items: flex-start;
    margin-bottom: 0.4rem;
}
.timeline-chapter {
    font-weight: 700; color: #1e293b; font-size: 0.875rem;
}
.timeline-time {
    font-size: 0.72rem; color: #94a3b8; white-space: nowrap;
}
.timeline-user {
    font-size: 0.8rem; color: #4d636f; font-weight: 600; margin-bottom: 0.3rem;
}
.timeline-detail {
    font-size: 0.78rem; color: #64748b;
    display: flex; gap: 1rem; flex-wrap: wrap;
}
.timeline-detail span { display: flex; align-items: center; gap: 0.3rem; }
.timeline-detail i { color: #94a3b8; }

/* ── Empty state ── */
.empty-state {
    text-align: center; padding: 3rem 2rem; color: #64748b;
}
.empty-state-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.35; }
.empty-state-title { font-size: 1.1rem; font-weight: 600; color: #475569; margin-bottom: 0.5rem; }
.empty-state-text  { font-size: 0.9rem; color: #94a3b8; }

/* ── Toolbar ── */
.toolbar {
    display: flex; gap: 0.75rem; align-items: center; flex-wrap: wrap;
    margin-bottom: 1.25rem;
}
.btn {
    display: inline-flex; align-items: center; gap: 0.4rem;
    padding: 0.45rem 1rem; border-radius: 8px;
    font-size: 0.85rem; font-weight: 600; cursor: pointer;
    border: 1px solid transparent; transition: all 0.2s;
}
.btn-primary { background: #4d636f; color: white; border-color: #4d636f; }
.btn-primary:hover { background: #3a4f5a; }
.btn-outline { background: white; color: #4d636f; border-color: #e2e8f0; }
.btn-outline:hover { background: #f8fafc; border-color: #4d636f; }
.btn-danger  { background: #ef4444; color: white; border-color: #ef4444; }
.btn-danger:hover  { background: #dc2626; }

/* ── Section card ── */
.section-card {
    background: white; border: 1px solid #e2e8f0; border-radius: 12px;
    overflow: hidden; margin-bottom: 1.25rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}
.section-card-header {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white; padding: 0.85rem 1.25rem;
    display: flex; justify-content: space-between; align-items: center;
}
.section-card-header h6 { margin: 0; font-size: 0.95rem; font-weight: 600; }
.section-card-body { padding: 1.25rem; }

/* ── Elapsed timer ── */
.elapsed-timer {
    font-family: 'Courier New', monospace;
    font-size: 0.85rem; font-weight: 700;
    color: #10b981; letter-spacing: 0.05em;
}

/* ── Pause indicator ── */
.pause-indicator {
    display: inline-flex; align-items: center; gap: 0.3rem;
    font-size: 0.72rem; color: #f59e0b; font-weight: 600;
}
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<div class="w3-container w3-content" style="max-width:1400px; margin-top:80px;">
  <div class="w3-row">

    <!-- Left Column -->
    <div id="leftColumn"></div>

    <!-- Middle Column -->
    <div class="w3-col m9">
      <div class="w3-row-padding">
        <div class="w3-col m12">

          <!-- Breadcrumb -->
          <div class="breadcrumb-bar">
            <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
            <span class="separator">›</span>
            <a href="/loggedIn/analytics-dashboard.ftl"><i class="fa fa-line-chart"></i> Analytics</a>
            <span class="separator">›</span>
            <span class="current"><i class="fa fa-clock-o"></i> Live Timeline</span>
          </div>

          <!-- Page Header -->
          <div class="page-header">
            <div>
              <h4><i class="fa fa-clock-o"></i> Live Story Execution Timeline</h4>
              <p>Real-time view of running stories — chapters, queries, users and elapsed time</p>
            </div>
            <div style="display:flex; align-items:center; gap:0.75rem; flex-wrap:wrap;">
              <span class="ws-badge connecting" id="wsStatus">
                <span class="pulse-dot"></span> Connecting...
              </span>
              <span class="elapsed-timer" id="sessionTimer">00:00:00</span>
            </div>
          </div>

          <!-- Stats Bar -->
          <div class="stats-bar">
            <div class="stat-chip">
              <i class="fa fa-play-circle"></i> Active Stories
              <span class="val" id="statStories">0</span>
            </div>
            <div class="stat-chip">
              <i class="fa fa-list-ol"></i> Total Chapters
              <span class="val" id="statChapters">0</span>
            </div>
            <div class="stat-chip">
              <i class="fa fa-users"></i> Unique Users
              <span class="val" id="statUsers">0</span>
            </div>
            <div class="stat-chip">
              <i class="fa fa-database"></i> Databases
              <span class="val" id="statDbs">0</span>
            </div>
            <div class="stat-chip">
              <i class="fa fa-code"></i> Queries Run
              <span class="val" id="statQueries">0</span>
            </div>
          </div>

          <!-- Toolbar -->
          <div class="toolbar">
            <button class="btn btn-outline" onclick="toggleAutoScroll()">
              <i class="fa fa-arrow-down" id="autoScrollIcon"></i>
              <span id="autoScrollLabel">Auto-scroll: ON</span>
            </button>
            <button class="btn btn-outline" onclick="toggleCompact()">
              <i class="fa fa-compress" id="compactIcon"></i>
              <span id="compactLabel">Compact: OFF</span>
            </button>
            <button class="btn btn-danger" onclick="clearAll()" style="margin-left:auto;">
              <i class="fa fa-trash"></i> Clear All
            </button>
          </div>

          <!-- Waiting state (shown when no stories running) -->
          <div id="waitingState" class="section-card">
            <div class="section-card-body">
              <div class="empty-state">
                <div class="empty-state-icon"><i class="fa fa-spinner fa-spin"></i></div>
                <div class="empty-state-title">Waiting for story executions...</div>
                <div class="empty-state-text">
                  Run a story from <a href="/loggedIn/contentpacks.ftl" style="color:#4d636f; font-weight:600;">Content Packs</a>
                  and its chapters will appear here in real time.<br>
                  Long-running outlier stories (up to 5 hours) are fully tracked.
                </div>
              </div>
            </div>
          </div>

          <!-- Story tracks container -->
          <div id="storyTracksContainer"></div>

        </div>
      </div>
    </div>
    <!-- End Middle Column -->

  </div>
</div>
<br>

<div id="footer"></div>

<script>
// ── Load includes ──────────────────────────────────────────────────────────
$(document).ready(function() {
    $.ajax({ url: '/loggedIn/includes/navbar.ftl',     method: 'GET', success: function(r){ $('#navbar').html(r); } });
    $.ajax({ url: '/loggedIn/includes/leftColumn.ftl', method: 'GET', success: function(r){ $('#leftColumn').html(r); } });
    $.ajax({ url: '/loggedIn/includes/footer.ftl',     method: 'GET', success: function(r){ $('#footer').html(r); } });
});

// ── State ──────────────────────────────────────────────────────────────────
var stories       = {};   // key = datasource, value = story track object
var totalChapters = 0;
var totalQueries  = 0;
var seenUsers     = new Set();
var seenDbs       = new Set();
var autoScroll    = true;
var compactMode   = false;
var sessionStart  = Date.now();

// ── Session timer ──────────────────────────────────────────────────────────
setInterval(function() {
    var elapsed = Math.floor((Date.now() - sessionStart) / 1000);
    var h = Math.floor(elapsed / 3600);
    var m = Math.floor((elapsed % 3600) / 60);
    var s = elapsed % 60;
    $('#sessionTimer').text(
        pad(h) + ':' + pad(m) + ':' + pad(s)
    );
}, 1000);

function pad(n) { return n < 10 ? '0' + n : '' + n; }

// ── Stats update ───────────────────────────────────────────────────────────
function updateStats() {
    var storyCount = Object.keys(stories).length;
    animateStat('statStories',  storyCount);
    animateStat('statChapters', totalChapters);
    animateStat('statUsers',    seenUsers.size);
    animateStat('statDbs',      seenDbs.size);
    animateStat('statQueries',  totalQueries);
}

function animateStat(id, val) {
    var el = document.getElementById(id);
    if (!el) return;
    var prev = parseInt(el.textContent) || 0;
    el.textContent = val;
    if (val > prev) {
        el.classList.add('bump');
        setTimeout(function(){ el.classList.remove('bump'); }, 600);
    }
}

// ── Toolbar actions ────────────────────────────────────────────────────────
function toggleAutoScroll() {
    autoScroll = !autoScroll;
    $('#autoScrollIcon').toggleClass('fa-arrow-down fa-pause');
    $('#autoScrollLabel').text('Auto-scroll: ' + (autoScroll ? 'ON' : 'OFF'));
}

function toggleCompact() {
    compactMode = !compactMode;
    $('#compactIcon').toggleClass('fa-compress fa-expand');
    $('#compactLabel').text('Compact: ' + (compactMode ? 'ON' : 'OFF'));
    $('.timeline-detail').toggle(!compactMode);
}

function clearAll() {
    stories = {};
    totalChapters = 0;
    totalQueries  = 0;
    seenUsers.clear();
    seenDbs.clear();
    updateStats();
    $('#storyTracksContainer').empty();
    $('#waitingState').show();
}

// ── Get or create a story track ────────────────────────────────────────────
function getOrCreateTrack(datasource, dbType, hostname, db, user) {
    if (stories[datasource]) return stories[datasource];

    var trackId = 'track-' + datasource.replace(/[^a-zA-Z0-9]/g, '_');
    var startTime = new Date().toLocaleTimeString();

    stories[datasource] = {
        id:         trackId,
        datasource: datasource,
        dbType:     dbType,
        hostname:   hostname,
        db:         db,
        user:       user,
        chapters:   0,
        startTime:  startTime,
        startMs:    Date.now()
    };

    // Build the track HTML
    var html =
        '<div class="story-track" id="' + trackId + '">' +
          '<div class="story-track-header">' +
            '<div>' +
              '<div class="story-track-title">' +
                '<i class="fa fa-play-circle"></i> ' +
                '<span id="' + trackId + '-title">' + db + ' @ ' + hostname + '</span>' +
              '</div>' +
              '<div class="story-track-meta">' +
                '<i class="fa fa-clock-o"></i> Started: ' + startTime +
                ' &nbsp;|&nbsp; <i class="fa fa-server"></i> ' + dbType +
                ' &nbsp;|&nbsp; <i class="fa fa-user"></i> ' + user +
              '</div>' +
            '</div>' +
            '<div class="story-track-badges">' +
              '<span class="badge badge-white"><i class="fa fa-list-ol"></i> <span id="' + trackId + '-count">0</span> chapters</span>' +
              '<span class="badge badge-green"><i class="fa fa-circle"></i> Running</span>' +
              '<span class="elapsed-timer" id="' + trackId + '-elapsed">00:00</span>' +
            '</div>' +
          '</div>' +
          '<div class="progress-wrap">' +
            '<div class="progress-bar-bg">' +
              '<div class="progress-bar-fill" id="' + trackId + '-progress" style="width:0%"></div>' +
            '</div>' +
            '<span class="progress-label" id="' + trackId + '-pct">0%</span>' +
          '</div>' +
          '<div class="timeline-container" id="' + trackId + '-timeline">' +
            '<div class="timeline" id="' + trackId + '-tl"></div>' +
          '</div>' +
        '</div>';

    $('#waitingState').hide();
    $('#storyTracksContainer').prepend(html);

    // Start per-track elapsed timer
    var timerEl = document.getElementById(trackId + '-elapsed');
    var startMs = stories[datasource].startMs;
    stories[datasource].timerInterval = setInterval(function() {
        var sec = Math.floor((Date.now() - startMs) / 1000);
        var m = Math.floor(sec / 60);
        var s = sec % 60;
        if (timerEl) timerEl.textContent = pad(m) + ':' + pad(s);
    }, 1000);

    return stories[datasource];
}

// ── Add a chapter to a track ───────────────────────────────────────────────
function addChapterToTrack(track, msg, chapterNum) {
    var trackId  = track.id;
    var tlEl     = document.getElementById(trackId + '-tl');
    if (!tlEl) return;

    var parts    = (msg.datasource || '').split('_');
    var user     = parts[3] || 'unknown';
    var chapter  = msg.chapter || (user + ' executed a query');
    var queryId  = msg.query_id || '—';
    var pause    = msg.pause_in_seconds;
    var timeStr  = new Date().toLocaleTimeString();

    // Remove 'latest' class from previous dot
    var prevLatest = tlEl.querySelector('.timeline-dot.latest');
    if (prevLatest) prevLatest.classList.remove('latest');
    var prevCard = tlEl.querySelector('.timeline-card.latest-card');
    if (prevCard) prevCard.classList.remove('latest-card');

    var pauseHtml = pause
        ? '<span class="pause-indicator"><i class="fa fa-pause-circle"></i> Pause: ' + pause + 's</span>'
        : '';

    var detailStyle = compactMode ? 'display:none;' : '';

    var itemHtml =
        '<div class="timeline-item">' +
          '<div class="timeline-dot latest"></div>' +
          '<div class="timeline-card latest-card">' +
            '<div class="timeline-card-top">' +
              '<span class="timeline-chapter">' +
                '<i class="fa fa-bookmark" style="color:#4d636f;"></i> Chapter ' + chapterNum +
                ' &mdash; ' + chapter +
              '</span>' +
              '<span class="timeline-time">' + timeStr + '</span>' +
            '</div>' +
            '<div class="timeline-user"><i class="fa fa-user"></i> ' + user + '</div>' +
            '<div class="timeline-detail" style="' + detailStyle + '">' +
              '<span><i class="fa fa-server"></i> ' + (parts[0] || '') + '</span>' +
              '<span><i class="fa fa-map-marker"></i> ' + (parts[1] || '') + '</span>' +
              '<span><i class="fa fa-database"></i> ' + (parts[2] || '') + '</span>' +
              '<span><i class="fa fa-code"></i> Query #' + queryId + '</span>' +
              (pauseHtml ? '<span>' + pauseHtml + '</span>' : '') +
            '</div>' +
          '</div>' +
        '</div>';

    // Prepend so newest is at top
    tlEl.insertAdjacentHTML('afterbegin', itemHtml);

    // Update chapter count badge
    var countEl = document.getElementById(trackId + '-count');
    if (countEl) countEl.textContent = chapterNum;

    // Scroll to top of timeline container if auto-scroll
    if (autoScroll) {
        var container = document.getElementById(trackId + '-timeline');
        if (container) container.scrollTop = 0;
    }
}

// ── WebSocket ──────────────────────────────────────────────────────────────
var protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
var wsUrl    = protocol + '//' + window.location.host + '/websocket/story/username';
var socket;

function connectWebSocket() {
    socket = new WebSocket(wsUrl);

    socket.addEventListener('open', function() {
        $('#wsStatus')
            .removeClass('connecting disconnected')
            .addClass('connected')
            .html('<span class="pulse-dot"></span> Live');
        console.log('Live Timeline WebSocket connected');
    });

    socket.addEventListener('message', function(event) {
        try {
            var msg = JSON.parse(event.data);
            var parts    = (msg.datasource || '').split('_');
            var dbType   = parts[0] || '';
            var hostname = parts[1] || '';
            var db       = parts[2] || '';
            var user     = parts[3] || 'unknown';

            // Get or create the story track
            var track = getOrCreateTrack(msg.datasource, dbType, hostname, db, user);

            // Increment counters
            track.chapters++;
            totalChapters++;
            totalQueries++;
            seenUsers.add(user);
            seenDbs.add(db);

            // Add chapter to timeline
            addChapterToTrack(track, msg, track.chapters);

            // Update progress bar (we don't know total chapters, so use a rolling indicator)
            // Use modulo 100 to give a sense of progress
            var pct = Math.min((track.chapters % 20) * 5, 100);
            var progressEl = document.getElementById(track.id + '-progress');
            var pctEl      = document.getElementById(track.id + '-pct');
            if (progressEl) progressEl.style.width = pct + '%';
            if (pctEl)      pctEl.textContent = track.chapters + ' chapters';

            updateStats();

        } catch(e) {
            console.error('Error processing WS message:', e);
        }
    });

    socket.addEventListener('error', function(err) {
        console.error('WebSocket error:', err);
        $('#wsStatus')
            .removeClass('connecting connected')
            .addClass('disconnected')
            .html('<span class="pulse-dot"></span> Error');
    });

    socket.addEventListener('close', function() {
        $('#wsStatus')
            .removeClass('connecting connected')
            .addClass('disconnected')
            .html('<span class="pulse-dot"></span> Disconnected');

        // Auto-reconnect after 5 seconds
        setTimeout(function() {
            $('#wsStatus')
                .removeClass('disconnected')
                .addClass('connecting')
                .html('<span class="pulse-dot"></span> Reconnecting...');
            connectWebSocket();
        }, 5000);
    });
}

// Start WebSocket connection
connectWebSocket();
</script>

</body>
</html>