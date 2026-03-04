<!DOCTYPE html>
<html>
<head>
<title>Story Creator</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/loggedIn/css/w3.css">
<link rel="stylesheet" href="/loggedIn/css/w3-theme-blue-grey.css">
<link rel="stylesheet" href="/loggedIn/css/navbar-fix.css">
<link rel="stylesheet" href="/loggedIn/css/font-awesome.min.css">
<link rel="stylesheet" href="/loggedIn/css/fonts.css">
<script src="/loggedIn/js/jquery.min.js"></script>
<style>
:root {
  --primary: #4d636f;
  --primary-dark: #3a4f5a;
  --success: #10b981;
  --danger: #ef4444;
  --warning: #f59e0b;
  --info: #3b82f6;
  --bg: #f0f4f7;
  --card-bg: #ffffff;
  --border: #d1dde3;
  --text: #1e293b;
  --text-muted: #64748b;
}
html, body { font-family: "Roboto", "Open Sans", sans-serif; background: var(--bg); color: var(--text); margin: 0; }
.page-header {
  background: linear-gradient(135deg, var(--primary), var(--primary-dark));
  color: white; padding: 28px 32px 20px; margin-bottom: 0; border-radius: 0 0 12px 12px;
}
.page-header h2 { margin: 0 0 6px; font-size: 1.6rem; font-weight: 700; }
.page-header p { margin: 0; opacity: 0.85; font-size: 0.95rem; }
.breadcrumb-bar {
  background: white; border-bottom: 1px solid var(--border);
  padding: 10px 32px; font-size: 0.85rem; color: var(--text-muted);
}
.breadcrumb-bar a { color: var(--primary); text-decoration: none; }
.breadcrumb-bar a:hover { text-decoration: underline; }
.breadcrumb-bar span { margin: 0 6px; }
.form-card {
  background: var(--card-bg); border-radius: 10px; border: 1px solid var(--border);
  margin-bottom: 16px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.form-card-header {
  padding: 16px 24px; border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
}
.form-card-header h4 { margin: 0; font-size: 1.05rem; font-weight: 600; color: var(--text); display: flex; align-items: center; gap: 10px; }
.form-card-header h4 i { color: var(--primary); }
.form-card-body { padding: 24px; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.form-grid-1 { display: grid; grid-template-columns: 1fr; gap: 16px; }
.form-group { margin-bottom: 0; }
.form-label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--text); margin-bottom: 6px; }
.form-label .required { color: var(--danger); margin-left: 2px; }
.form-input {
  width: 100%; padding: 10px 14px; border: 1px solid var(--border); border-radius: 8px;
  font-size: 0.9rem; color: var(--text); background: white; outline: none;
  transition: border-color 0.2s, box-shadow 0.2s; box-sizing: border-box;
}
.form-input:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(77,99,111,0.1); }
.form-input::placeholder { color: #94a3b8; }
textarea.form-input { resize: vertical; min-height: 80px; }
.form-hint { font-size: 0.78rem; color: var(--text-muted); margin-top: 4px; }
/* Chapter Card */
.chapter-card {
  background: white; border: 1px solid var(--border); border-radius: 10px;
  margin-bottom: 16px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.05);
  border-left: 4px solid var(--primary);
  animation: fadeIn 0.3s ease-out forwards;
}
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
.chapter-card-header {
  padding: 14px 20px; background: #f8fafc; border-bottom: 1px solid var(--border);
  display: flex; align-items: center; justify-content: space-between;
}
.chapter-card-header h5 { margin: 0; font-size: 0.95rem; font-weight: 600; color: var(--text); }
.chapter-card-actions { display: flex; gap: 8px; }
.chapter-card-body { padding: 20px; }
/* Pause Slider */
.pause-row { display: flex; align-items: center; gap: 12px; }
.pause-row input[type="range"] { flex: 1; accent-color: var(--primary); }
.pause-row input[type="number"] { width: 100px; }
/* JSON Output */
.json-output {
  background: #1e293b; color: #e2e8f0; border-radius: 8px; padding: 20px;
  font-family: 'Courier New', monospace; font-size: 0.82rem; line-height: 1.6;
  min-height: 200px; max-height: 400px; overflow-y: auto; white-space: pre-wrap;
  word-wrap: break-word;
}
/* Buttons */
.btn { padding: 9px 18px; border-radius: 8px; border: none; cursor: pointer; font-size: 0.88rem; font-weight: 500; display: inline-flex; align-items: center; gap: 7px; transition: all 0.2s; }
.btn-primary { background: var(--primary); color: white; }
.btn-primary:hover { background: var(--primary-dark); transform: translateY(-1px); }
.btn-success { background: var(--success); color: white; }
.btn-success:hover { background: #059669; }
.btn-danger { background: var(--danger); color: white; }
.btn-danger:hover { background: #dc2626; }
.btn-info { background: var(--info); color: white; }
.btn-info:hover { background: #2563eb; }
.btn-secondary { background: #e2e8f0; color: var(--text); }
.btn-secondary:hover { background: #cbd5e1; }
.btn-sm { padding: 6px 12px; font-size: 0.8rem; }
.btn-icon { background: none; border: none; cursor: pointer; padding: 6px 8px; border-radius: 6px; transition: background 0.2s; }
.btn-icon:hover { background: #f1f5f9; }
.btn-icon.danger:hover { background: #fef2f2; color: var(--danger); }
.btn-icon.info:hover { background: #eff6ff; color: var(--info); }
/* Form Actions Bar */
.form-actions {
  display: flex; justify-content: flex-end; gap: 12px;
  padding: 16px 24px; border-top: 1px solid var(--border); background: #f8fafc;
}
/* Toast */
.toast {
  position: fixed; top: 20px; right: 20px; padding: 14px 22px;
  border-radius: 8px; color: white; font-weight: 500;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999;
  transform: translateX(200%); transition: transform 0.3s ease-out;
  display: flex; align-items: center; gap: 10px;
}
.toast.show { transform: translateX(0); }
.toast.success { background: linear-gradient(135deg, var(--success), #059669); }
.toast.error { background: linear-gradient(135deg, var(--danger), #dc2626); }
/* Section divider */
.section-divider { border: none; border-top: 1px solid var(--border); margin: 20px 0; }
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">
  <div class="w3-row">
    <div id="leftColumn"></div>
    <div class="w3-col m9">

      <div class="page-header">
        <h2><i class="fa fa-pencil-square-o" style="margin-right:10px;"></i>Story Creator</h2>
        <p>Build and configure story JSON for the Scenario Launch Platform</p>
      </div>

      <div class="breadcrumb-bar">
        <a href="/loggedIn/dashboard.ftl"><i class="fa fa-home"></i> Dashboard</a>
        <span>&#8250;</span>
        <a href="/loggedIn/myStories.ftl">My Stories</a>
        <span>&#8250;</span>
        <span>Story Creator</span>
      </div>

      <!-- Toast Notification -->
      <div id="toast" class="toast">
        <i class="fa fa-info-circle" id="toast-icon"></i>
        <span id="toast-message"></span>
      </div>

      <!-- Story Information Card -->
      <div class="form-card" style="margin-top:16px;">
        <div class="form-card-header">
          <h4><i class="fa fa-book"></i> Story Information</h4>
        </div>
        <div class="form-card-body">
          <form id="story-form">
            <div class="form-grid" style="margin-bottom:16px;">
              <div class="form-group">
                <label class="form-label" for="name">Story Name <span class="required">*</span></label>
                <input type="text" id="name" name="name" class="form-input" placeholder="e.g., Polly Sees Violations" required>
              </div>
              <div class="form-group">
                <label class="form-label" for="author">Author <span class="required">*</span></label>
                <input type="text" id="author" name="author" class="form-input" placeholder="e.g., Polly" required>
              </div>
              <div class="form-group">
                <label class="form-label" for="handbook">Handbook Path</label>
                <input type="text" id="handbook" name="handbook" class="form-input" placeholder="e.g., /handbooks/PollySeesViolations.pdf">
              </div>
              <div class="form-group">
                <label class="form-label" for="video">Video URL</label>
                <input type="url" id="video" name="video" class="form-input" placeholder="e.g., https://example.com/video.mp4">
              </div>
            </div>
            <div class="form-group" style="margin-bottom:16px;">
              <label class="form-label" for="description">Description <span class="required">*</span></label>
              <textarea id="description" name="description" rows="3" class="form-input" placeholder="Describe the story..." required></textarea>
            </div>
            <div class="form-group">
              <label class="form-label" for="outcomes">Learning Outcomes <span class="required">*</span></label>
              <textarea id="outcomes" name="outcomes" rows="2" class="form-input" placeholder="What will users learn from this story?" required></textarea>
            </div>
          </form>
        </div>
      </div>

      <!-- Chapters Card -->
      <div class="form-card">
        <div class="form-card-header">
          <h4><i class="fa fa-list-ol"></i> Chapters</h4>
          <button type="button" id="add-chapter" class="btn btn-success btn-sm">
            <i class="fa fa-plus"></i> Add Chapter
          </button>
        </div>
        <div class="form-card-body">
          <div id="chapters-container">
            <!-- Chapters added dynamically -->
          </div>
        </div>
        <div class="form-actions">
          <button type="button" id="preview-json" class="btn btn-secondary">
            <i class="fa fa-code"></i> Preview JSON
          </button>
          <button type="button" id="submit-story" class="btn btn-primary">
            <i class="fa fa-save"></i> Create Story
          </button>
        </div>
      </div>

      <!-- JSON Preview Card -->
      <div id="json-preview" class="form-card" style="display:none;">
        <div class="form-card-header">
          <h4><i class="fa fa-code"></i> JSON Output</h4>
          <div style="display:flex;gap:8px;">
            <button id="copy-json" class="btn btn-secondary btn-sm"><i class="fa fa-copy"></i> Copy JSON</button>
            <button id="close-json" class="btn btn-secondary btn-sm"><i class="fa fa-times"></i> Close</button>
          </div>
        </div>
        <div class="form-card-body">
          <pre id="json-output" class="json-output"></pre>
        </div>
      </div>

    </div>
  </div>
</div>
<br>
<div id="footer"></div>

<!-- Chapter Template -->
<template id="chapter-template">
  <div class="chapter-card">
    <div class="chapter-card-header">
      <h5><i class="fa fa-bookmark" style="color:var(--primary);margin-right:8px;"></i>Chapter <span class="chapter-number">1</span></h5>
      <div class="chapter-card-actions">
        <button type="button" class="btn-icon info duplicate-chapter" title="Duplicate chapter"><i class="fa fa-copy"></i></button>
        <button type="button" class="btn-icon danger delete-chapter" title="Delete chapter"><i class="fa fa-trash"></i></button>
      </div>
    </div>
    <div class="chapter-card-body">
      <div class="form-grid" style="margin-bottom:16px;">
        <div class="form-group" style="grid-column:1/-1;">
          <label class="form-label">Chapter Title <span class="required">*</span></label>
          <input type="text" class="chapter-title form-input" placeholder="e.g., Polly runs a basic query" required>
        </div>
        <div class="form-group">
          <label class="form-label">Datasource <span class="required">*</span></label>
          <select class="chapter-datasource form-input" required>
            <#if ValidatedConnectionData?has_content>
              <#list ValidatedConnectionData?keys as key>
                <option value="${key}">${key}</option>
              </#list>
            <#else>
              <option value="">No connections available</option>
            </#if>
          </select>
        </div>
        <div class="form-group">
          <label class="form-label">Query ID <span class="required">*</span></label>
          <input type="number" class="chapter-query_id form-input" placeholder="e.g., 500" required>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">Pause in Milliseconds <span class="required">*</span></label>
        <div class="pause-row">
          <input type="range" min="1000" max="10000" step="1000" class="chapter-pause" value="5000">
          <input type="number" min="1000" max="10000" step="1000" class="chapter-pause-value form-input" value="5000">
        </div>
        <div class="form-hint">Time to wait before next chapter (1000ms = 1 second)</div>
      </div>
    </div>
  </div>
</template>

<script>
$(document).ready(function() {
    $.ajax({ url: '/loggedIn/includes/navbar.ftl', method: 'GET', success: function(r) { $('#navbar').html(r); } });
    $.ajax({ url: '/loggedIn/includes/leftColumn2.ftl', method: 'GET', success: function(r) { $('#leftColumn').html(r); getQueryTypes(); } });
    $.ajax({ url: '/loggedIn/includes/footer.ftl', method: 'GET', success: function(r) { $('#footer').html(r); } });
});

document.addEventListener('DOMContentLoaded', function() {
    const chaptersContainer = document.getElementById('chapters-container');
    const addChapterBtn = document.getElementById('add-chapter');
    const previewJsonBtn = document.getElementById('preview-json');
    const jsonPreview = document.getElementById('json-preview');
    const jsonOutput = document.getElementById('json-output');
    const copyJsonBtn = document.getElementById('copy-json');
    const closeJsonBtn = document.getElementById('close-json');
    const submitStoryBtn = document.getElementById('submit-story');
    const chapterTemplate = document.getElementById('chapter-template').content;
    let chapterCount = 0;

    addChapter();

    addChapterBtn.addEventListener('click', addChapter);

    submitStoryBtn.addEventListener('click', function() {
        const form = document.getElementById('story-form');
        if (!form.checkValidity()) { form.reportValidity(); return; }
        addStory();
    });

    previewJsonBtn.addEventListener('click', function() {
        generateJson();
        jsonPreview.style.display = 'block';
        jsonPreview.scrollIntoView({ behavior: 'smooth' });
    });

    copyJsonBtn.addEventListener('click', function() {
        const textArea = document.createElement('textarea');
        textArea.value = jsonOutput.textContent;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        showToast('JSON copied to clipboard!', true);
    });

    closeJsonBtn.addEventListener('click', function() { jsonPreview.style.display = 'none'; });

    function addChapter() {
        chapterCount++;
        const chapterClone = document.importNode(chapterTemplate, true);
        chapterClone.querySelector('.chapter-number').textContent = chapterCount;

        chapterClone.querySelector('.duplicate-chapter').addEventListener('click', function() {
            const card = this.closest('.chapter-card');
            const title = card.querySelector('.chapter-title').value;
            const datasource = card.querySelector('.chapter-datasource').value;
            const queryId = card.querySelector('.chapter-query_id').value;
            const pauseValue = card.querySelector('.chapter-pause-value').value;
            addChapter();
            const newChapter = chaptersContainer.lastElementChild;
            newChapter.querySelector('.chapter-title').value = title;
            newChapter.querySelector('.chapter-datasource').value = datasource;
            newChapter.querySelector('.chapter-query_id').value = queryId;
            newChapter.querySelector('.chapter-pause-value').value = pauseValue;
            newChapter.querySelector('.chapter-pause').value = pauseValue;
        });

        chapterClone.querySelector('.delete-chapter').addEventListener('click', function() {
            if (chaptersContainer.children.length > 1) {
                this.closest('.chapter-card').remove();
                updateChapterNumbers();
            } else {
                showToast('A story must have at least one chapter!', false);
            }
        });

        const pauseSlider = chapterClone.querySelector('.chapter-pause');
        const pauseValueInput = chapterClone.querySelector('.chapter-pause-value');
        pauseSlider.value = 5000;
        pauseValueInput.value = 5000;
        pauseSlider.addEventListener('input', function() { pauseValueInput.value = this.value; });
        pauseValueInput.addEventListener('input', function() { pauseSlider.value = this.value; });

        chaptersContainer.appendChild(chapterClone);
    }

    function updateChapterNumbers() {
        const chapters = chaptersContainer.querySelectorAll('.chapter-card');
        chapterCount = chapters.length;
        chapters.forEach((chapter, index) => { chapter.querySelector('.chapter-number').textContent = index + 1; });
    }

    function generateJson() {
        const storyData = {
            story: {
                author: document.getElementById('author').value,
                description: document.getElementById('description').value,
                handbook: document.getElementById('handbook').value || null,
                name: document.getElementById('name').value,
                outcomes: document.getElementById('outcomes').value,
                story: [],
                video: document.getElementById('video').value || null
            }
        };
        const chapters = chaptersContainer.querySelectorAll('.chapter-card');
        chapters.forEach(chapter => {
            storyData.story.story.push({
                chapter: chapter.querySelector('.chapter-title').value,
                datasource: chapter.querySelector('.chapter-datasource').value,
                pause_in_seconds: parseInt(chapter.querySelector('.chapter-pause-value').value),
                query_id: parseInt(chapter.querySelector('.chapter-query_id').value)
            });
        });
        jsonOutput.textContent = JSON.stringify(storyData, null, 2);
        return storyData;
    }

    function addStory() {
        const jwtToken = '${tokenObject.jwt}';
        const storyData = generateJson();
        const payload = { jwt: jwtToken, story: storyData.story };
        $.ajax({
            url: '/api/addStory', type: 'POST', contentType: 'application/json',
            data: JSON.stringify(payload), processData: false,
            success: function(response) {
                showToast('Story created successfully!', true);
                document.getElementById('story-form').reset();
                chaptersContainer.innerHTML = '';
                chapterCount = 0;
                addChapter();
                jsonPreview.style.display = 'none';
            },
            error: function(xhr) { showToast('Failed to create story: ' + xhr.responseText, false); }
        });
    }
});

function showToast(message, isSuccess) {
    const toast = document.getElementById('toast');
    const toastMsg = document.getElementById('toast-message');
    const toastIcon = document.getElementById('toast-icon');
    toastMsg.textContent = message;
    toast.className = 'toast show ' + (isSuccess ? 'success' : 'error');
    toastIcon.className = 'fa ' + (isSuccess ? 'fa-check-circle' : 'fa-exclamation-circle');
    setTimeout(() => { toast.classList.remove('show'); }, 3000);
}

function getQueryTypes() {
    const var_jwt = '${tokenObject.jwt}';
    $.ajax({
        url: '/api/getQueryTypes', type: 'POST',
        data: JSON.stringify({ jwt: var_jwt }),
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            const queryTypes = document.getElementById('queryTypes');
            if (!queryTypes) return;
            queryTypes.innerHTML = '';
            if (Array.isArray(response)) {
                $.each(response, function(index, item) {
                    const span = document.createElement('span');
                    span.textContent = item.query_type;
                    span.classList.add('w3-tag', 'w3-small', 'w3-theme-d' + index);
                    span.onclick = function() { window.location.href = 'databases.ftl?lookup=' + item.query_type; };
                    queryTypes.appendChild(span);
                });
            }
        }
    });
}
</script>

<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>
</body>
</html>
