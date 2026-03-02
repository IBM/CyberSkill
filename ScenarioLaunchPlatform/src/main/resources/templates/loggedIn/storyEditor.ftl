<!DOCTYPE html>
<html>
<head>
<title>Story Editor - SLP</title>
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
html, body, h1, h2, h3, h4, h5 { font-family: "Roboto", normal; }

/* Page header */
.editor-header-card {
    background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
    color: white;
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
}
.editor-header-card h4 { margin: 0 0 0.4rem 0; font-size: 1.4rem; font-weight: 700; }
.editor-header-card p  { margin: 0; opacity: 0.85; font-size: 0.95rem; }

/* Breadcrumb */
.breadcrumb-bar {
    display: flex; align-items: center; gap: 0.5rem;
    padding: 0.6rem 0.75rem;
    background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px;
    margin-bottom: 1.25rem; font-size: 0.875rem;
}
.breadcrumb-bar a { color: #4d636f; text-decoration: none; font-weight: 500; }
.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar .separator { color: #94a3b8; }
.breadcrumb-bar .current   { color: #64748b; }

/* Chapter card */
.chapter-card {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 12px;
    padding: 1.25rem;
    margin-bottom: 1rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    transition: box-shadow 0.2s ease;
}
.chapter-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }

.chapter-card-header {
    display: flex; align-items: center; gap: 1rem;
    margin-bottom: 1rem; padding-bottom: 0.75rem;
    border-bottom: 1px solid #f1f5f9;
}
.chapter-avatar {
    width: 44px; height: 44px; border-radius: 50%;
    background: linear-gradient(135deg, #4d636f, #3a4f5a);
    display: flex; align-items: center; justify-content: center;
    color: white; font-weight: 700; font-size: 1rem; flex-shrink: 0;
}
.chapter-title   { font-weight: 600; color: #1e293b; font-size: 0.95rem; }
.chapter-subtitle{ color: #64748b; font-size: 0.82rem; margin-top: 0.15rem; }

/* Datasource row */
.datasource-row {
    display: flex; align-items: center; gap: 0.75rem;
    flex-wrap: wrap;
}
.datasource-label {
    font-size: 0.82rem; font-weight: 600; color: #475569;
    white-space: nowrap; min-width: 90px;
}
.datasource-current {
    font-family: 'Courier New', monospace;
    font-size: 0.8rem; color: #64748b;
    background: #f1f5f9; padding: 0.3rem 0.6rem;
    border-radius: 6px; flex: 1; min-width: 180px;
    word-break: break-all;
}
.datasource-select {
    flex: 1; min-width: 220px;
    padding: 0.45rem 0.75rem;
    border: 1px solid #cbd5e1; border-radius: 8px;
    font-size: 0.875rem; color: #1e293b;
    background: white; cursor: pointer;
    transition: border-color 0.2s;
}
.datasource-select:focus { outline: none; border-color: #4d636f; }
.datasource-select.changed { border-color: #f59e0b; background: #fffbeb; }

/* Info badges */
.badge {
    display: inline-flex; align-items: center; gap: 0.3rem;
    padding: 0.2rem 0.6rem; border-radius: 9999px;
    font-size: 0.72rem; font-weight: 600;
    background: #f1f5f9; color: #475569; margin-right: 0.4rem;
}
.badge.info  { background: #dbeafe; color: #1e40af; }
.badge.warn  { background: #fef3c7; color: #92400e; }
.badge.ok    { background: #d1fae5; color: #065f46; }

/* Action buttons */
.btn-primary {
    display: inline-flex; align-items: center; gap: 0.4rem;
    padding: 0.55rem 1.4rem;
    background: #4d636f; color: white;
    border: none; border-radius: 8px;
    font-size: 0.9rem; font-weight: 600; cursor: pointer;
    transition: background 0.2s, transform 0.1s;
}
.btn-primary:hover { background: #3a4f5a; transform: translateY(-1px); }
.btn-primary:disabled { background: #94a3b8; cursor: not-allowed; transform: none; }

.btn-secondary {
    display: inline-flex; align-items: center; gap: 0.4rem;
    padding: 0.55rem 1.2rem;
    background: white; color: #4d636f;
    border: 1px solid #4d636f; border-radius: 8px;
    font-size: 0.9rem; font-weight: 600; cursor: pointer;
    transition: background 0.2s;
}
.btn-secondary:hover { background: #f1f5f9; }

.btn-run {
    display: inline-flex; align-items: center; gap: 0.4rem;
    padding: 0.55rem 1.4rem;
    background: #059669; color: white;
    border: none; border-radius: 8px;
    font-size: 0.9rem; font-weight: 600; cursor: pointer;
    transition: background 0.2s, transform 0.1s;
}
.btn-run:hover { background: #047857; transform: translateY(-1px); }
.btn-run:disabled { background: #94a3b8; cursor: not-allowed; transform: none; }

/* Action bar */
.action-bar {
    display: flex; align-items: center; gap: 0.75rem;
    flex-wrap: wrap; padding: 1rem;
    background: #f8fafc; border: 1px solid #e2e8f0;
    border-radius: 10px; margin-top: 1.5rem;
}

/* Status banner */
.status-banner {
    display: none; padding: 0.75rem 1rem;
    border-radius: 8px; margin-bottom: 1rem;
    font-size: 0.875rem; font-weight: 500;
}
.status-banner.success { display: flex; background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
.status-banner.error   { display: flex; background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
.status-banner.info    { display: flex; background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd; }

/* Empty state */
.empty-state { text-align: center; padding: 3rem 2rem; color: #64748b; }
.empty-state-icon  { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }
.empty-state-title { font-size: 1.1rem; font-weight: 600; color: #475569; margin-bottom: 0.5rem; }

/* Loading spinner */
.spinner { display: inline-block; width: 20px; height: 20px; border: 3px solid #e2e8f0; border-top-color: #4d636f; border-radius: 50%; animation: spin 0.7s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

/* Bulk-remap panel */
.bulk-panel {
    background: #f8fafc; border: 1px solid #e2e8f0;
    border-radius: 10px; padding: 1rem 1.25rem;
    margin-bottom: 1.25rem;
}
.bulk-panel h6 { margin: 0 0 0.75rem 0; font-size: 0.9rem; font-weight: 700; color: #475569; }
.bulk-row { display: flex; align-items: center; gap: 0.75rem; flex-wrap: wrap; margin-bottom: 0.5rem; }
.bulk-row label { font-size: 0.82rem; font-weight: 600; color: #475569; min-width: 130px; }
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<!-- Page Container -->
<div class="w3-container w3-content" style="max-width:1200px; margin-top:80px;">
  <div class="w3-row">
    <div id="leftColumn"></div>

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
                <a href="#" id="breadcrumbStories" onclick="history.back(); return false;"><i class="fa fa-list"></i> Stories</a>
                <span class="separator">›</span>
                <span class="current"><i class="fa fa-edit"></i> Story Editor</span>
              </div>

              <!-- Header -->
              <div class="editor-header-card">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:1rem;">
                  <div>
                    <h4><i class="fa fa-edit"></i> <span id="storyTitle">Loading story...</span></h4>
                    <p id="storyMeta">Configure which database connections each chapter uses</p>
                  </div>
                  <div>
                    <span class="badge info" id="chapterCountBadge"><i class="fa fa-list-ol"></i> 0 chapters</span>
                  </div>
                </div>
              </div>

              <!-- Status banner -->
              <div class="status-banner" id="statusBanner">
                <i class="fa fa-check-circle" style="margin-right:0.5rem;"></i>
                <span id="statusMessage"></span>
              </div>

              <!-- Bulk remap panel -->
              <div class="bulk-panel" id="bulkPanel" style="display:none;">
                <h6><i class="fa fa-magic"></i> Bulk Remap — replace all chapters using a specific datasource</h6>
                <div class="bulk-row">
                  <label>Replace datasource:</label>
                  <select id="bulkFrom" class="datasource-select" style="max-width:320px;">
                    <option value="">— select datasource to replace —</option>
                  </select>
                </div>
                <div class="bulk-row">
                  <label>With connection:</label>
                  <select id="bulkTo" class="datasource-select" style="max-width:320px;">
                    <option value="">— select new connection —</option>
                  </select>
                </div>
                <div class="bulk-row">
                  <button class="btn-secondary" onclick="applyBulkRemap()">
                    <i class="fa fa-exchange"></i> Apply Bulk Remap
                  </button>
                </div>
              </div>

              <!-- Chapters container -->
              <div id="chaptersContainer">
                <div class="empty-state" id="loadingState">
                  <div class="empty-state-icon"><span class="spinner"></span></div>
                  <div class="empty-state-title">Loading story chapters...</div>
                </div>
              </div>

              <!-- Action bar -->
              <div class="action-bar" id="actionBar" style="display:none;">
                <button class="btn-primary" id="btnSave" onclick="saveChanges()">
                  <i class="fa fa-save"></i> Save Changes
                </button>
                <button class="btn-run" id="btnSaveAndRun" onclick="saveAndRun()">
                  <i class="fa fa-play"></i> Save & Run Story
                </button>
                <button class="btn-secondary" onclick="resetToOriginal()">
                  <i class="fa fa-undo"></i> Reset
                </button>
                <span id="unsavedIndicator" style="display:none; color:#f59e0b; font-size:0.82rem; font-weight:600;">
                  <i class="fa fa-exclamation-triangle"></i> Unsaved changes
                </span>
              </div>

            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- End Middle Column -->
  </div>
</div>

<div id="footer"></div>
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>

<script>
// ─── Globals ────────────────────────────────────────────────────────────────
const JWT = '${tokenObject.jwt}';
var storyId       = null;
var originalStory = null;   // deep copy of story as loaded
var allConnections = [];    // all tb_databaseConnections rows
var hasUnsaved    = false;

// ─── Bootstrap ──────────────────────────────────────────────────────────────
$(document).ready(function() {
    loadIncludes();

    const params = new URLSearchParams(window.location.search);
    storyId = parseInt(params.get('storyID'), 10);

    if (!storyId || isNaN(storyId)) {
        showStatus('error', 'No story ID provided in URL. Use ?storyID=<id>');
        return;
    }

    // Load connections first, then story
    loadConnections().then(() => loadStory());
});

function loadIncludes() {
    $.get('/loggedIn/includes/navbar.ftl',     r => $('#navbar').html(r));
    $.get('/loggedIn/includes/leftColumn.ftl', r => $('#leftColumn').html(r));
    $.get('/loggedIn/includes/footer.ftl',     r => $('#footer').html(r));
}

// ─── Load all database connections ──────────────────────────────────────────
function loadConnections() {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: '/api/getAllDatabaseConnections',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ jwt: JWT }),
            success: function(response) {
                allConnections = Array.isArray(response) ? response : [];
                console.log('Loaded ' + allConnections.length + ' connections');
                resolve();
            },
            error: function(xhr) {
                console.error('Failed to load connections:', xhr.responseText);
                showStatus('error', 'Failed to load database connections from settings.');
                resolve(); // continue anyway
            }
        });
    });
}

// ─── Load story ──────────────────────────────────────────────────────────────
function loadStory() {
    $.ajax({
        url: '/api/getStoryById',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ jwt: JWT, id: storyId }),
        success: function(response) {
            if (!response || response.length === 0) {
                showStatus('error', 'Story not found (id=' + storyId + ')');
                $('#loadingState').html(
                    '<div class="empty-state-icon"><i class="fa fa-exclamation-triangle"></i></div>' +
                    '<div class="empty-state-title">Story not found</div>'
                );
                return;
            }

            const row = response[0];
            const story = row.story;

            // Keep a deep copy as the "original"
            originalStory = JSON.parse(JSON.stringify(story));

            // Update header
            $('#storyTitle').text(story.name || 'Story #' + storyId);
            $('#storyMeta').text(
                (story.author ? 'By ' + story.author + ' · ' : '') +
                (story.description || 'Configure which database connections each chapter uses')
            );

            const chapters = story.story || [];
            $('#chapterCountBadge').html('<i class="fa fa-list-ol"></i> ' + chapters.length + ' chapters');

            renderChapters(chapters);
            populateBulkSelects(chapters);

            $('#bulkPanel').show();
            $('#actionBar').show();
        },
        error: function(xhr) {
            showStatus('error', 'Failed to load story: ' + (xhr.responseText || xhr.statusText));
            $('#loadingState').html(
                '<div class="empty-state-icon"><i class="fa fa-exclamation-triangle"></i></div>' +
                '<div class="empty-state-title">Error loading story</div>'
            );
        }
    });
}

// ─── Render chapter cards ────────────────────────────────────────────────────
function renderChapters(chapters) {
    const container = $('#chaptersContainer');
    container.empty();

    if (chapters.length === 0) {
        container.html(
            '<div class="empty-state">' +
            '<div class="empty-state-icon"><i class="fa fa-book"></i></div>' +
            '<div class="empty-state-title">No chapters found in this story</div>' +
            '</div>'
        );
        return;
    }

    chapters.forEach(function(chapter, idx) {
        const ds = chapter.datasource || '';
        const parts = ds.split('_');
        const dbType  = parts[0] || '?';
        const host    = parts[1] || '?';
        const db      = parts[2] || '?';
        const user    = parts[3] || '?';
        const initials = user.substring(0, 2).toUpperCase();

        const selectHtml = buildConnectionSelect('ds_' + idx, ds, dbType);

        const html =
            '<div class="chapter-card" id="chapter-card-' + idx + '">' +
            '  <div class="chapter-card-header">' +
            '    <div class="chapter-avatar">' + initials + '</div>' +
            '    <div>' +
            '      <div class="chapter-title"><i class="fa fa-bookmark"></i> Chapter ' + (idx + 1) +
                     (chapter.chapter ? ' — ' + escHtml(chapter.chapter) : '') + '</div>' +
            '      <div class="chapter-subtitle">Query ID: ' + (chapter.query_id || '?') +
                     ' &nbsp;·&nbsp; Pause: ' + formatPause(chapter.pause_in_seconds) + '</div>' +
            '    </div>' +
            '  </div>' +
            '  <div class="datasource-row">' +
            '    <span class="datasource-label"><i class="fa fa-plug"></i> Datasource:</span>' +
            '    <span class="datasource-current" id="ds-current-' + idx + '" title="' + escHtml(ds) + '">' + escHtml(ds) + '</span>' +
            '    <i class="fa fa-arrow-right" style="color:#94a3b8;"></i>' +
            '    ' + selectHtml +
            '  </div>' +
            '</div>';

        container.append(html);

        // Watch for changes
        $('#ds_' + idx).on('change', function() {
            markUnsaved();
            const newVal = $(this).val();
            if (newVal !== ds) {
                $(this).addClass('changed');
            } else {
                $(this).removeClass('changed');
            }
        });
    });
}

// Build a <select> populated with all connections, pre-selected to currentDs
function buildConnectionSelect(selectId, currentDs, dbTypeHint) {
    let html = '<select id="' + selectId + '" class="datasource-select">';

    // Group by db_type for readability
    const grouped = {};
    allConnections.forEach(function(conn) {
        const t = conn.db_type || 'other';
        if (!grouped[t]) grouped[t] = [];
        grouped[t].push(conn);
    });

    // If no connections loaded, show a placeholder
    if (allConnections.length === 0) {
        html += '<option value="' + escAttr(currentDs) + '" selected>' + escHtml(currentDs) + ' (no connections loaded)</option>';
    } else {
        // Add current value first if not in list
        const found = allConnections.find(c => c.db_connection_id === currentDs);
        if (!found && currentDs) {
            html += '<option value="' + escAttr(currentDs) + '" selected>⚠ ' + escHtml(currentDs) + ' (original — not in settings)</option>';
        }

        Object.keys(grouped).sort().forEach(function(type) {
            html += '<optgroup label="' + escAttr(type.toUpperCase()) + '">';
            grouped[type].forEach(function(conn) {
                const val = conn.db_connection_id;
                const label = '[' + conn.db_type + '] ' + conn.db_url + ' / ' + conn.db_database + ' — ' + conn.db_username +
                              (conn.db_alias ? ' (' + conn.db_alias + ')' : '');
                const sel = (val === currentDs) ? ' selected' : '';
                html += '<option value="' + escAttr(val) + '"' + sel + '>' + escHtml(label) + '</option>';
            });
            html += '</optgroup>';
        });
    }

    html += '</select>';
    return html;
}

// ─── Bulk remap ──────────────────────────────────────────────────────────────
function populateBulkSelects(chapters) {
    // Unique datasources currently in the story
    const unique = [...new Set(chapters.map(c => c.datasource).filter(Boolean))];

    const $from = $('#bulkFrom');
    $from.empty().append('<option value="">— select datasource to replace —</option>');
    unique.forEach(ds => $from.append('<option value="' + escAttr(ds) + '">' + escHtml(ds) + '</option>'));

    const $to = $('#bulkTo');
    $to.empty().append('<option value="">— select new connection —</option>');
    allConnections.forEach(function(conn) {
        const val = conn.db_connection_id;
        const label = '[' + conn.db_type + '] ' + conn.db_url + ' / ' + conn.db_database + ' — ' + conn.db_username +
                      (conn.db_alias ? ' (' + conn.db_alias + ')' : '');
        $to.append('<option value="' + escAttr(val) + '">' + escHtml(label) + '</option>');
    });
}

function applyBulkRemap() {
    const fromDs = $('#bulkFrom').val();
    const toDs   = $('#bulkTo').val();

    if (!fromDs || !toDs) {
        showStatus('info', 'Please select both a datasource to replace and a new connection.');
        return;
    }
    if (fromDs === toDs) {
        showStatus('info', 'Source and target are the same — nothing to change.');
        return;
    }

    let count = 0;
    const chapters = originalStory ? (originalStory.story || []) : [];
    chapters.forEach(function(ch, idx) {
        if (ch.datasource === fromDs) {
            const $sel = $('#ds_' + idx);
            if ($sel.length) {
                $sel.val(toDs).addClass('changed');
                count++;
            }
        }
    });

    if (count > 0) {
        markUnsaved();
        showStatus('info', 'Bulk remap applied: ' + count + ' chapter(s) updated. Click "Save Changes" to persist.');
    } else {
        showStatus('info', 'No chapters found using datasource: ' + fromDs);
    }
}

// ─── Save / Run ──────────────────────────────────────────────────────────────
function collectChapterOverrides() {
    const chapters = originalStory ? (originalStory.story || []) : [];
    const overrides = [];
    chapters.forEach(function(ch, idx) {
        const newDs = $('#ds_' + idx).val();
        if (newDs && newDs !== ch.datasource) {
            overrides.push({ index: idx, datasource: newDs });
        }
    });
    return overrides;
}

function saveChanges() {
    const overrides = collectChapterOverrides();

    if (overrides.length === 0) {
        showStatus('info', 'No changes detected — all datasources are already up to date.');
        return;
    }

    $('#btnSave').prop('disabled', true).html('<span class="spinner"></span> Saving...');

    $.ajax({
        url: '/api/updateStoryChapterDatasources',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ jwt: JWT, id: storyId, chapters: overrides }),
        success: function(response) {
            $('#btnSave').prop('disabled', false).html('<i class="fa fa-save"></i> Save Changes');
            showStatus('success', 'Story chapter datasources saved successfully! (' + overrides.length + ' chapter(s) updated)');
            hasUnsaved = false;
            $('#unsavedIndicator').hide();
            // Reload story to reflect saved state
            loadStory();
        },
        error: function(xhr) {
            $('#btnSave').prop('disabled', false).html('<i class="fa fa-save"></i> Save Changes');
            showStatus('error', 'Failed to save: ' + (xhr.responseJSON && xhr.responseJSON.message ? xhr.responseJSON.message : xhr.responseText));
        }
    });
}

function saveAndRun() {
    const overrides = collectChapterOverrides();

    $('#btnSaveAndRun').prop('disabled', true).html('<span class="spinner"></span> Saving...');

    const doRun = function() {
        $('#btnSaveAndRun').prop('disabled', false).html('<i class="fa fa-play"></i> Save & Run Story');
        window.location.href = '/loggedIn/myStories.ftl?storyID=' + storyId;
    };

    if (overrides.length === 0) {
        // Nothing to save — just run
        doRun();
        return;
    }

    $.ajax({
        url: '/api/updateStoryChapterDatasources',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({ jwt: JWT, id: storyId, chapters: overrides }),
        success: function() {
            doRun();
        },
        error: function(xhr) {
            $('#btnSaveAndRun').prop('disabled', false).html('<i class="fa fa-play"></i> Save & Run Story');
            showStatus('error', 'Failed to save before running: ' + (xhr.responseJSON && xhr.responseJSON.message ? xhr.responseJSON.message : xhr.responseText));
        }
    });
}

function resetToOriginal() {
    if (!originalStory) return;
    if (hasUnsaved && !confirm('Reset all changes to the last saved state?')) return;
    renderChapters(originalStory.story || []);
    populateBulkSelects(originalStory.story || []);
    hasUnsaved = false;
    $('#unsavedIndicator').hide();
    showStatus('info', 'Reset to last saved state.');
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
function markUnsaved() {
    hasUnsaved = true;
    $('#unsavedIndicator').show();
}

function showStatus(type, msg) {
    const $b = $('#statusBanner');
    $b.removeClass('success error info').addClass(type);
    const icon = type === 'success' ? 'fa-check-circle' : type === 'error' ? 'fa-exclamation-circle' : 'fa-info-circle';
    $b.html('<i class="fa ' + icon + '" style="margin-right:0.5rem;"></i><span>' + escHtml(msg) + '</span>');
    $b.show();
    if (type !== 'error') {
        setTimeout(() => $b.fadeOut(400, () => $b.hide().removeClass('success error info')), 6000);
    }
}

function formatPause(ms) {
    if (!ms) return '0ms';
    if (ms < 1000) return ms + 'ms';
    if (ms < 60000) return (ms / 1000).toFixed(1) + 's';
    if (ms < 3600000) return (ms / 60000).toFixed(1) + 'min';
    return (ms / 3600000).toFixed(1) + 'h';
}

function escHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '\u0026amp;')
        .replace(/</g, '\u0026lt;')
        .replace(/>/g, '\u0026gt;')
        .replace(/"/g, '\u0026quot;');
}

function escAttr(str) {
    if (!str) return '';
    return String(str).replace(/"/g, '\u0026quot;').replace(/'/g, '\u0026#39;');
}

// Warn on navigation if unsaved
window.addEventListener('beforeunload', function(e) {
    if (hasUnsaved) {
        e.preventDefault();
        e.returnValue = '';
    }
});
</script>
</body>
</html>