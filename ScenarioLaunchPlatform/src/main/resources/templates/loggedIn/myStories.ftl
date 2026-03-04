<!DOCTYPE html>
<html>
<head>
<title>My Stories - SLP</title>
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

.avatar {
  vertical-align: middle;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  border: 2px solid #e2e8f0;
  object-fit: cover;
}

/* Story header card */
.story-header-card {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
}

.story-header-card h4 {
    margin: 0 0 0.5rem 0;
    font-size: 1.4rem;
    font-weight: 700;
}

.story-header-card p {
    margin: 0;
    opacity: 1;
    font-size: 0.95rem;
    line-height: 1.6;
    color: #ffffff;
}

#storyMeta {
    background: rgba(0, 0, 0, 0.2);
    padding: 0.75rem;
    border-radius: 6px;
    margin-top: 0.5rem;
}

/* Chapter card */
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

.chapter-badge.success {
    background: #d1fae5;
    color: #065f46;
}

.chapter-badge.info {
    background: #dbeafe;
    color: #1e40af;
}

.query-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    padding: 0.4rem 1rem;
    background: #4d636f;
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 0.85rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
}

.query-btn:hover {
    background: #3a4f5a;
    transform: translateY(-1px);
}

/* Status indicator */
.ws-status {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    padding: 0.4rem 1rem;
    border-radius: 9999px;
    font-size: 0.8rem;
    font-weight: 600;
}

.ws-status.connected {
    background: #d1fae5;
    color: #065f46;
}

.ws-status.disconnected {
    background: #fee2e2;
    color: #991b1b;
}

.ws-status.connecting {
    background: #fef3c7;
    color: #92400e;
}

.pulse-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: currentColor;
    animation: pulse 1.5s infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.3; }
}

/* Modal */
.modern-modal-overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 10000;
    align-items: center;
    justify-content: center;
}

.modern-modal-overlay.active {
    display: flex;
}

.modern-modal {
    background: white;
    border-radius: 16px;
    width: 90%;
    max-width: 700px;
    max-height: 80vh;
    overflow: hidden;
    box-shadow: 0 25px 50px rgba(0,0,0,0.25);
    animation: modalIn 0.2s ease;
}

@keyframes modalIn {
    from { opacity: 0; transform: scale(0.95); }
    to   { opacity: 1; transform: scale(1); }
}

.modern-modal-header {
    background: linear-gradient(135deg, #4d636f, #3a4f5a);
    color: white;
    padding: 1.25rem 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modern-modal-header h5 {
    margin: 0;
    font-size: 1.1rem;
    font-weight: 600;
}

.modal-close-btn {
    background: rgba(255,255,255,0.2);
    border: none;
    color: white;
    width: 32px;
    height: 32px;
    border-radius: 50%;
    cursor: pointer;
    font-size: 1.1rem;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
}

.modal-close-btn:hover {
    background: rgba(255,255,255,0.35);
}

.modern-modal-body {
    padding: 1.5rem;
    overflow-y: auto;
    max-height: calc(80vh - 80px);
}

.sql-code-block {
    background: #1e293b;
    color: #e2e8f0;
    border-radius: 8px;
    padding: 1.25rem;
    font-family: 'Courier New', monospace;
    font-size: 0.875rem;
    line-height: 1.6;
    overflow-x: auto;
    white-space: pre-wrap;
    word-break: break-all;
}

/* Empty state */
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

.breadcrumb-bar a:hover {
    text-decoration: underline;
}

.breadcrumb-bar .separator {
    color: #94a3b8;
}

.breadcrumb-bar .current {
    color: #64748b;
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
                <a href="/loggedIn/contentpacks.ftl"><i class="fa fa-home"></i> Content Packs</a>
                <span class="separator">›</span>
                <span class="current"><i class="fa fa-book"></i> My Stories</span>
                <span style="margin-left:auto;">
                  <a href="/loggedIn/live-timeline.ftl" target="_blank" style="display:inline-flex; align-items:center; gap:0.35rem; padding:0.25rem 0.75rem; background:#4d636f; color:white; border-radius:6px; font-size:0.78rem; font-weight:600; text-decoration:none;">
                    <i class="fa fa-rss"></i> Live Timeline
                  </a>
                </span>
              </div>

              <!-- Story Header -->
              <div class="story-header-card">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                  <div>
                    <h4><i class="fa fa-book"></i> <span id="StoryTitle">Loading story...</span></h4>
                    <p id="storyMeta">Connecting to story runner...</p>
                  </div>
                  <div style="display:flex; align-items:center; gap:0.75rem;">
                    <span class="ws-status connecting" id="wsStatus">
                      <span class="pulse-dot"></span>
                      Connecting...
                    </span>
                  </div>
                </div>
              </div>

              <!-- Chapter counter -->
              <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                <h6 style="margin:0; color:#475569; font-weight:600;">
                  <i class="fa fa-list-ol"></i> Story Chapters
                  <span id="chapterCount" style="background:#f1f5f9; color:#4d636f; padding:0.2rem 0.6rem; border-radius:9999px; font-size:0.8rem; margin-left:0.5rem;">0</span>
                </h6>
              </div>

              <!-- Chapters Container -->
              <div id="StoryChaptersCompleted">
                <div class="empty-state" id="waitingState">
                  <div class="empty-state-icon"><i class="fa fa-spinner fa-spin"></i></div>
                  <div class="empty-state-title">Waiting for story chapters...</div>
                  <div class="empty-state-text">Chapters will appear here as the story executes</div>
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

<!-- Query Detail Modal -->
<div class="modern-modal-overlay" id="myModal">
  <div class="modern-modal">
    <div class="modern-modal-header">
      <h5><i class="fa fa-code"></i> Query Details</h5>
      <button class="modal-close-btn" onclick="closeModal()">×</button>
    </div>
    <div class="modern-modal-body">
      <div id="modalContent">
        <div style="text-align:center; padding:2rem; color:#64748b;">
          <i class="fa fa-spinner fa-spin" style="font-size:2rem;"></i>
          <p style="margin-top:1rem;">Loading query details...</p>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
// Load includes
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
        success: function(response) { $('#leftColumn').html(response); },
        error: function(err) { console.error('Error loading left column:', err); }
    });

    $.ajax({
        url: '/loggedIn/includes/footer.ftl',
        method: 'GET',
        success: function(response) { $('#footer').html(response); },
        error: function(err) { console.error('Error loading footer:', err); }
    });
});
</script>

<script>
var queryString = window.location.search;
var urlParams = new URLSearchParams(queryString);
var storyID = urlParams.get('storyID');
console.log("storyID: " + storyID);

runStoryById(storyID);

function runStoryById(id) {
    const storyID = +id;
    console.log("Story id to execute: " + id);

    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({
        jwt: jwtToken,
        id: storyID,
    });

    setTimeout(() => {
        $.ajax({
            url: '/api/runStoryById',
            type: 'POST',
            data: jsonData,
            contentType: false,
            processData: false,
            success: function(response) {
                if (response.length > 0) {
                    let storyData = response[0];
                    let storyName = storyData.story.name;
                    let author = storyData.story.author;
                    let description = storyData.story.description;
                    let queries = storyData.story.story;

                    $('#StoryTitle').text(storyName + ' [' + queries.length + ' chapters]');
                    $('#storyMeta').text(
                        (author ? 'By ' + author : '') +
                        (description ? ' · ' + description : '')
                    );
                }
                console.log("Response Body:", JSON.stringify(response, null, 2));
            },
            error: function(xhr, status, error) {
                $('#StoryTitle').text('Error loading story');
                $('#storyMeta').text('Failed to load story details');
            }
        });
    }, 2000);
}
</script>

<script>
var chapterCount = 0;

const relativeUrl = '/websocket/story/username';
const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
const wsUrl = protocol + "//" + window.location.host + relativeUrl;

const socket = new WebSocket(wsUrl);

// Connection opened
socket.addEventListener("open", () => {
    console.log("Connected to WebSocket server");
    $('#wsStatus').removeClass('connecting disconnected').addClass('connected').html(
        '<span class="pulse-dot"></span> Live'
    );
    // Hide waiting state if chapters arrive
});

// Listen for messages
socket.addEventListener("message", (event) => {
    console.log("Message from server:", event.data);

    let parsedMessageObject = JSON.parse(event.data);

    const parts = parsedMessageObject.datasource.split("_");
    let dbType = parts[0];
    let hostname = parts[1];
    let db = parts[2];
    let user = parts[3];

    let chapter = parsedMessageObject.chapter;
    if (chapter == null) {
        chapter = user + " does something";
    }

    // Hide waiting state on first chapter
    chapterCount++;
    $('#chapterCount').text(chapterCount);
    if (chapterCount === 1) {
        $('#waitingState').remove();
    }

    // Get initials for avatar
    const initials = user ? user.substring(0, 2).toUpperCase() : '??';

    const chapterHtml =
        '<div class="chapter-card">' +
        '<div class="chapter-card-header">' +
        '<div class="chapter-avatar">' + initials + '</div>' +
        '<div>' +
        '<div class="chapter-title"><i class="fa fa-user"></i> ' + user + '</div>' +
        '<div class="chapter-subtitle">Chapter ' + chapterCount + ' · ' + chapter + '</div>' +
        '</div>' +
        '</div>' +
        '<div class="chapter-details">' +
        '<div class="chapter-detail-item"><i class="fa fa-server"></i><span>' + dbType + '</span></div>' +
        '<div class="chapter-detail-item"><i class="fa fa-map-marker"></i><span>' + hostname + '</span></div>' +
        '<div class="chapter-detail-item"><i class="fa fa-database"></i><span>' + db + '</span></div>' +
        '</div>' +
        '<div>' +
        '<span class="chapter-badge success"><i class="fa fa-check"></i> Executed</span>' +
        '<button class="query-btn" onclick="openModal(' + parsedMessageObject.query_id + ')">' +
        '<i class="fa fa-code"></i> View Query' +
        '</button>' +
        '</div>' +
        '</div>';

    $('#StoryChaptersCompleted').append(chapterHtml);
});

// Handle errors
socket.addEventListener("error", (error) => {
    console.error("WebSocket error:", error);
    $('#wsStatus').removeClass('connecting connected').addClass('disconnected').html(
        '<span class="pulse-dot"></span> Error'
    );
});

// Handle connection close
socket.addEventListener("close", () => {
    console.log("WebSocket connection closed");
    $('#wsStatus').removeClass('connecting connected').addClass('disconnected').html(
        '<span class="pulse-dot"></span> Disconnected'
    );
});
</script>

<script>
function openModal(queryId) {
    document.getElementById('myModal').classList.add('active');
    console.log("queryId: " + queryId);
    fetchQueryData(queryId);
}

function closeModal() {
    document.getElementById('myModal').classList.remove('active');
}

// Close modal on overlay click
document.getElementById('myModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

function fetchQueryData(varqueryId) {
    const queryId = +varqueryId;
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({
        jwt: jwtToken,
        query_id: queryId,
    });

    $('#modalContent').html(
        '<div style="text-align:center; padding:2rem; color:#64748b;">' +
        '<i class="fa fa-spinner fa-spin" style="font-size:2rem;"></i>' +
        '<p style="margin-top:1rem;">Loading query details...</p>' +
        '</div>'
    );

    $.ajax({
        url: '/api/getDatabaseQueryByQueryId',
        type: 'POST',
        data: jsonData,
        contentType: false,
        processData: false,
        success: function(response) {
            if (response && response.length > 0) {
                const q = response[0];
                $('#modalContent').html(
                    '<div style="margin-bottom:1rem;">' +
                    '<div style="display:flex; gap:0.75rem; flex-wrap:wrap; margin-bottom:1rem;">' +
                    '<span class="chapter-badge info"><i class="fa fa-tag"></i> ID: ' + (q.id || queryId) + '</span>' +
                    '<span class="chapter-badge"><i class="fa fa-database"></i> ' + (q.query_db_type || 'N/A') + '</span>' +
                    '<span class="chapter-badge"><i class="fa fa-list"></i> ' + (q.query_type || 'N/A') + '</span>' +
                    '</div>' +
                    '<div class="sql-code-block">' + escapeHtml(q.query_string || '') + '</div>' +
                    '</div>'
                );
            } else {
                $('#modalContent').html('<p style="color:#64748b; text-align:center; padding:2rem;">No query data found.</p>');
            }
        },
        error: function() {
            $('#modalContent').html('<p style="color:#ef4444; text-align:center; padding:2rem;"><i class="fa fa-exclamation-triangle"></i> Error loading query data</p>');
        }
    });
}

function escapeHtml(text) {
    return text
        .replace(/&/g, '&')
        .replace(/</g, '<')
        .replace(/>/g, '>')
        .replace(/"/g, '"');
}
</script>

<!-- SweetAlert2 and notification script -->
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>
</body>
</html>
