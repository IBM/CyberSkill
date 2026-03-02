<!DOCTYPE html>
<html>
<head>
<title>Experimental - SLP</title>
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
html, body, h1, h2, h3, h4, h5 { font-family: "Roboto", sans-serif; }

/* ── Page Header ── */
.page-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  border-radius: 12px; padding: 1.5rem 2rem; margin-bottom: 1.5rem;
  color: white; display: flex; justify-content: space-between; align-items: center;
  box-shadow: 0 4px 15px rgba(77,99,111,0.3);
}
.page-header-title { font-size: 1.5rem; font-weight: 700; margin: 0; }
.page-header-subtitle { font-size: 0.875rem; opacity: 0.85; margin: 0.25rem 0 0; }
.page-header-icon {
  width: 52px; height: 52px; background: rgba(255,255,255,0.15);
  border-radius: 12px; display: flex; align-items: center; justify-content: center;
  font-size: 1.5rem;
}

/* ── Breadcrumb ── */
.breadcrumb-bar {
  background: white; border: 1px solid #e2e8f0; border-radius: 8px;
  padding: 0.6rem 1rem; margin-bottom: 1.25rem;
  display: flex; align-items: center; gap: 0.5rem;
  font-size: 0.85rem; color: #64748b;
}
.breadcrumb-bar a { color: #4d636f; text-decoration: none; font-weight: 500; }
.breadcrumb-bar a:hover { color: #3a4f5a; text-decoration: underline; }
.breadcrumb-sep { color: #cbd5e1; }

/* ── Section Card ── */
.section-card {
  background: white; border: 1px solid #e2e8f0; border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 1.25rem; overflow: hidden;
}
.section-card-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  padding: 1rem 1.5rem; display: flex; align-items: center; justify-content: space-between;
}
.section-card-title {
  color: white; font-size: 1rem; font-weight: 600;
  display: flex; align-items: center; gap: 0.6rem; margin: 0;
}
.section-card-body { padding: 1.25rem 1.5rem; }

/* ── Info Banner ── */
.info-banner {
  background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px;
  padding: 0.75rem 1rem; color: #1e40af; font-size: 0.85rem; margin-bottom: 1rem;
  display: flex; align-items: center; gap: 0.5rem;
}

/* ── Image Map Container ── */
.imagemap-container {
  overflow-x: auto; border-radius: 8px;
  border: 1px solid #e2e8f0; background: #f8fafc;
}
.imagemap-container img { display: block; max-width: 100%; height: auto; }

/* ── Modern Modal ── */
.modern-modal-overlay {
  display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0,0,0,0.6); z-index: 9000; align-items: center; justify-content: center;
}
.modern-modal-overlay.active { display: flex; }
.modern-modal {
  background: white; border-radius: 16px; width: 90%; max-width: 860px;
  max-height: 90vh; overflow: hidden; display: flex; flex-direction: column;
  box-shadow: 0 25px 50px rgba(0,0,0,0.3);
}
.modern-modal-header {
  background: linear-gradient(135deg, #4d636f 0%, #3a4f5a 100%);
  padding: 1.25rem 1.5rem; display: flex; align-items: center; justify-content: space-between;
}
.modern-modal-header h3 { color: white; margin: 0; font-size: 1.1rem; font-weight: 600; }
.modern-modal-close {
  background: rgba(255,255,255,0.2); border: none; color: white; width: 32px; height: 32px;
  border-radius: 8px; cursor: pointer; font-size: 1.1rem; display: flex;
  align-items: center; justify-content: center; transition: background 0.2s;
}
.modern-modal-close:hover { background: rgba(255,255,255,0.35); }
.modern-modal-body { padding: 1.5rem; overflow-y: auto; flex: 1; text-align: center; }
.modern-modal-footer {
  padding: 1rem 1.5rem; border-top: 1px solid #e2e8f0;
  display: flex; justify-content: flex-end;
}
.btn-secondary {
  background: #f1f5f9; color: #374151; border: 1px solid #d1d5db;
  padding: 0.5rem 1.25rem; border-radius: 8px; cursor: pointer; font-size: 0.875rem;
  font-weight: 500; display: inline-flex; align-items: center; gap: 0.4rem; transition: all 0.2s;
}
.btn-secondary:hover { background: #e2e8f0; }

/* ── Beta Badge ── */
.beta-badge {
  display: inline-flex; align-items: center; gap: 0.4rem;
  background: linear-gradient(135deg, #7c3aed, #5b21b6);
  color: white; border-radius: 20px; padding: 0.3rem 0.9rem;
  font-size: 0.78rem; font-weight: 700; letter-spacing: 0.05em;
}
</style>
</head>
<body class="w3-theme-l5">

<div id="navbar"></div>

<!-- Page Container -->
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
            <span class="breadcrumb-sep">›</span>
            <span><i class="fa fa-flask"></i> Experimental</span>
          </div>

          <!-- Page Header -->
          <div class="page-header">
            <div>
              <div class="page-header-title">
                <i class="fa fa-flask" style="margin-right:0.5rem;"></i>Experimental Features
              </div>
              <div class="page-header-subtitle">Interactive Guardium product capability map — click any area to explore</div>
            </div>
            <div style="display:flex;align-items:center;gap:1rem;">
              <span class="beta-badge"><i class="fa fa-flask"></i> BETA</span>
              <div class="page-header-icon"><i class="fa fa-map"></i></div>
            </div>
          </div>

          <!-- Info Banner -->
          <div class="info-banner">
            <i class="fa fa-info-circle"></i>
            <span>Click any highlighted area on the capability map below to view detailed feature information.</span>
          </div>

          <!-- Image Map Card -->
          <div class="section-card">
            <div class="section-card-header">
              <h3 class="section-card-title"><i class="fa fa-map"></i> Guardium Capability Map</h3>
              <span style="background:rgba(255,255,255,0.2);color:white;border-radius:20px;padding:3px 12px;font-size:0.78rem;">
                <i class="fa fa-hand-pointer-o"></i> Interactive
              </span>
            </div>
            <div class="section-card-body">
              <div class="imagemap-container">
                <img name="liher4" src="w3images/liher4.png" width="970" height="610" id="liher4" usemap="#m_liher4" alt="Guardium Capability Map" style="cursor:crosshair;" />
                <map name="m_liher4" id="m_liher4">
                  <area shape="poly" coords="850,572,966,572,966,593,850,593,850,572" href="javascript:showImage('7_7')" alt="" />
                  <area shape="poly" coords="850,522,966,522,966,560,850,560,850,522" href="javascript:showImage('7_6')" alt="" />
                  <area shape="poly" coords="850,489,966,489,966,515,850,515,850,489" href="javascript:showImage('7_5')" alt="" />
                  <area shape="poly" coords="850,393,966,393,966,445,850,445,850,393" href="javascript:showImage('7_4')" alt="" />
                  <area shape="poly" coords="850,272,961,272,961,316,850,316,850,272" href="javascript:showImage('7_3')" alt="" />
                  <area shape="poly" coords="850,231,966,231,966,267,850,267,850,231" href="javascript:showImage('7_2')" alt="" />
                  <area shape="poly" coords="850,123,966,123,966,173,850,173,850,123" href="javascript:showImage('7_1')" alt="" />
                  <area shape="poly" coords="729,522,844,522,844,566,729,566,729,522" href="javascript:showImage('6_5')" alt="" />
                  <area shape="poly" coords="729,489,844,489,844,513,729,513,729,489" href="javascript:showImage('6_4')" alt="" />
                  <area shape="poly" coords="729,393,844,393,844,445,729,445,729,393" href="javascript:showImage('6_3')" alt="" />
                  <area shape="poly" coords="729,230,844,230,844,267,729,267,729,230" href="javascript:showImage('6_2')" alt="" />
                  <area shape="poly" coords="729,123,844,123,844,160,729,160,729,123" href="javascript:showImage('6_1')" alt="" />
                  <area shape="poly" coords="608,484,723,484,723,533,608,533,608,484" href="javascript:showImage('5_7')" alt="" />
                  <area shape="poly" coords="608,393,723,393,723,445,608,445,608,393" href="javascript:showImage('5_6')" alt="" />
                  <area shape="poly" coords="608,325,723,325,723,351,608,351,608,325" href="javascript:showImage('5_5')" alt="" />
                  <area shape="poly" coords="608,291,723,291,723,316,608,316,608,291" href="javascript:showImage('5_4')" alt="" />
                  <area shape="poly" coords="608,230,723,230,723,267,608,267,608,230" href="javascript:showImage('5_3')" alt="" />
                  <area shape="poly" coords="608,159,723,159,723,196,608,196,608,159" href="javascript:showImage('5_2')" alt="" />
                  <area shape="poly" coords="608,123,723,123,723,155,608,155,608,123" href="javascript:showImage('5_1')" alt="" />
                  <area shape="poly" coords="490,484,603,484,603,541,490,541,490,484" href="javascript:showImage('4_7')" alt="" />
                  <area shape="poly" coords="485,393,603,393,603,445,485,445,485,393" href="javascript:showImage('4_6')" alt="" />
                  <area shape="poly" coords="485,351,603,351,603,377,485,377,485,351" href="javascript:showImage('4_5')" alt="" />
                  <area shape="poly" coords="485,297,603,297,603,346,485,346,485,297" href="javascript:showImage('4_4')" alt="" />
                  <area shape="poly" coords="485,272,603,272,603,297,485,297,485,272" href="javascript:showImage('4_3')" alt="" />
                  <area shape="poly" coords="485,246,599,246,599,272,485,272,485,246" href="javascript:showImage('4_2')" alt="" />
                  <area shape="poly" coords="485,219,599,219,599,241,485,241,485,219" href="javascript:showImage('4_1')" alt="" />
                  <area shape="poly" coords="363,548,485,548,485,572,363,572,363,548" href="javascript:showImage('3_8')" alt="" />
                  <area shape="poly" coords="363,515,478,515,478,541,363,541,363,515" href="javascript:showImage('3_7')" alt="" />
                  <area shape="poly" coords="363,484,478,484,478,509,363,509,363,484" href="javascript:showImage('3_6')" alt="" />
                  <area shape="poly" coords="363,393,478,393,478,445,363,445,363,393" href="javascript:showImage('3_5')" alt="" />
                  <area shape="poly" coords="363,251,478,251,478,281,363,281,363,251" href="javascript:showImage('3_4')" alt="" />
                  <area shape="poly" coords="363,219,478,219,478,246,363,246,363,219" href="javascript:showImage('3_3')" alt="" />
                  <area shape="poly" coords="363,145,478,145,478,174,363,174,363,145" href="javascript:showImage('3_2')" alt="" />
                  <area shape="poly" coords="363,114,478,114,478,139,363,139,363,114" href="javascript:showImage('3_1')" alt="" />
                  <area shape="poly" coords="240,393,355,393,355,435,240,435,240,393" href="javascript:showImage('2_4')" alt="" />
                  <area shape="poly" coords="239,231,355,231,355,272,239,272,239,231" href="javascript:showImage('2_3')" alt="" />
                  <area shape="poly" coords="239,173,355,173,355,219,239,219,239,173" href="javascript:showImage('2_2')" alt="" />
                  <area shape="poly" coords="240,174,354,174,354,219,240,219,240,174" href="javascript:showImage('0')" alt="" />
                  <area shape="poly" coords="240,123,354,123,354,168,240,168,240,123" href="javascript:showImage('2_1')" alt="" />
                  <area shape="poly" coords="116,435,230,435,230,484,116,484,116,435" href="javascript:showImage('1_3')" alt="" />
                  <area shape="poly" coords="116,382,230,382,230,428,116,428,116,382" href="javascript:showImage('1_2')" alt="" />
                  <area shape="poly" coords="116,325,230,325,230,377,116,377,116,325" href="javascript:showImage('1_1')" alt="" />
                  <area shape="poly" coords="850,74,966,74,966,109,850,109,850,74" href="javascript:showImage('1')" alt="" />
                  <area shape="poly" coords="729,74,844,74,844,109,729,109,729,74" href="javascript:showImage('GuardiumAISecurity')" alt="" />
                  <area shape="poly" coords="608,74,723,74,723,109,608,109,608,74" href="javascript:showImage('GuardiumDSPM')" alt="" />
                  <area shape="poly" coords="485,74,599,74,599,109,485,109,485,74" href="javascript:showImage('GuardiumDDR')" alt="" />
                  <area shape="poly" coords="363,74,478,74,478,109,363,109,363,74" href="javascript:showImage('GuardiumDataCompliance')" alt="" />
                  <area shape="poly" coords="240,74,354,74,354,109,240,109,240,74" href="javascript:showImage('GuardiumDiscoverAndClassify')" alt="" />
                  <area shape="poly" coords="116,74,230,74,230,109,116,109,116,74" href="javascript:showImage('guardiumEncryption')" alt="" />
                </map>
              </div>
            </div>
          </div>

        </div>
      </div>
    </div>
    <!-- End Middle Column -->
  </div>
</div>

<!-- Footer -->
<div id="footer"></div>

<!-- ── Modern Feature Modal ── -->
<div id="experimentalFeatureModal" class="modern-modal-overlay">
  <div class="modern-modal">
    <div class="modern-modal-header">
      <h3><i class="fa fa-flask" style="margin-right:0.5rem;"></i>Feature Detail</h3>
      <button class="modern-modal-close" onclick="document.getElementById('experimentalFeatureModal').classList.remove('active')">&times;</button>
    </div>
    <div class="modern-modal-body">
      <div id="experimentalFeature"></div>
    </div>
    <div class="modern-modal-footer">
      <button class="btn-secondary" onclick="document.getElementById('experimentalFeatureModal').classList.remove('active')">
        <i class="fa fa-times"></i> Close
      </button>
    </div>
  </div>
</div>

<script>
// Load navbar, left column, footer
$(document).ready(function() {
  $.ajax({ url: '/loggedIn/includes/navbar.ftl', method: 'GET',
    success: function(r) { $('#navbar').html(r); },
    error: function(e) { console.error('Navbar error:', e); }
  });
  $.ajax({ url: '/loggedIn/includes/leftColumn2.ftl', method: 'GET',
    success: function(r) { $('#leftColumn').html(r); },
    error: function(e) { console.error('Left column error:', e); }
  });
  $.ajax({ url: '/loggedIn/includes/footer.ftl', method: 'GET',
    success: function(r) { $('#footer').html(r); },
    error: function(e) { console.error('Footer error:', e); }
  });
});

// Image map lookup table
const imageMap = {
  '1_1': 'w3images/slide2.png',
  '1_2': 'w3images/slide2.png',
  '1_3': 'w3images/slide2.png',
  '2_1': 'w3images/slide2.png',
  '2_2': 'w3images/slide2.png',
  '2_3': 'w3images/slide2.png',
  '2_4': 'w3images/slide2.png',
  '3_1': 'w3images/slide2.png',
  '3_2': 'w3images/slide2.png',
  '3_3': 'w3images/slide2.png',
  '3_4': 'w3images/slide2.png',
  '3_5': 'w3images/slide2.png',
  '3_6': 'w3images/slide2.png',
  '3_7': 'w3images/slide2.png',
  '3_8': 'w3images/slide2.png',
  '4_1': 'w3images/slide2.png',
  '4_2': 'w3images/slide2.png',
  '4_3': 'w3images/slide2.png',
  '4_4': 'w3images/slide2.png',
  '4_5': 'w3images/slide2.png',
  '4_6': 'w3images/slide5.png',
  '5_1': 'w3images/slide7.png',
  '5_2': 'w3images/slide7.png',
  '5_3': 'w3images/slide12.png',
  '5_4': 'w3images/slide8.png',
  '5_5': 'w3images/slide9.png',
  '5_6': 'w3images/slide10.png',
  '5_7': 'w3images/slide11.png',
  '5_8': 'w3images/slide.png',
  '6_1': 'w3images/slide14.png',
  '6_2': 'w3images/slide18.png',
  '6_3': 'w3images/slide21.png',
  '6_4': 'w3images/slide20.png',
  '7_1': 'w3images/slide2.png',
  '7_2': 'w3images/slide3.png',
  '7_3': 'w3images/slide3.png',
  '7_4': 'w3images/slide2.png',
  '7_5': 'w3images/slide2.png',
  '7_6': 'w3images/slide4.png',
  '7_7': 'w3images/slide4.png'
};

function showImage(imageRef) {
  console.log('imageRef:', imageRef);
  const image = imageMap[imageRef];
  if (image) {
    document.getElementById('experimentalFeature').innerHTML =
      "<img src='" + image + "' style='max-width:100%;height:auto;border-radius:8px;' alt='Feature slide' />";
    document.getElementById('experimentalFeatureModal').classList.add('active');
  } else {
    console.log('No image mapped for ref:', imageRef);
  }
}

// Accordion helper
function myFunction(id) {
  var x = document.getElementById(id);
  if (x.className.indexOf("w3-show") === -1) {
    x.className += " w3-show";
    x.previousElementSibling.className += " w3-theme-d1";
  } else {
    x.className = x.className.replace("w3-show", "");
    x.previousElementSibling.className = x.previousElementSibling.className.replace(" w3-theme-d1", "");
  }
}
</script>

<script src="/loggedIn/js/sweetalert.js"></script>
<script src="/loggedIn/js/notifications.js"></script>
</body>
</html>
