<!DOCTYPE html>
<html>
<head>
<title>Attack Pattern Library</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="css/w3-theme-blue-grey.css">
<link rel='stylesheet' href='https://fonts.googleapis.com/css?family=Open+Sans'>
<link rel="stylesheet" href="css/font-awesome.min.css">
<script src="js/jquery.min.js"></script>
<style>
html, body, h1, h2, h3, h4, h5 {font-family: "Open Sans", sans-serif}
.pattern-card {
    cursor: pointer;
    transition: all 0.3s;
}
.pattern-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}
.severity-critical { border-left: 4px solid #d32f2f; }
.severity-high { border-left: 4px solid #f57c00; }
.severity-medium { border-left: 4px solid #fbc02d; }
.severity-low { border-left: 4px solid #388e3c; }
.badge-critical { background-color: #d32f2f; color: white; }
.badge-high { background-color: #f57c00; color: white; }
.badge-medium { background-color: #fbc02d; color: black; }
.badge-low { background-color: #388e3c; color: white; }
.sql-query {
    background-color: #f5f5f5;
    border-left: 3px solid #2196F3;
    padding: 10px;
    margin: 5px 0;
    font-family: 'Courier New', monospace;
    font-size: 12px;
    overflow-x: auto;
}
.category-tab {
    cursor: pointer;
    padding: 10px 15px;
    margin: 5px;
    border-radius: 5px;
    display: inline-block;
}
.category-tab.active {
    background-color: #2196F3;
    color: white;
}
.tag {
    display: inline-block;
    padding: 3px 8px;
    margin: 2px;
    background-color: #e0e0e0;
    border-radius: 3px;
    font-size: 11px;
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
    
      <!-- Header Card -->
      <div class="w3-row-padding">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h4><i class="fa fa-shield w3-margin-right"></i>Attack Pattern Library</h4>
              <p>Pre-built database attack patterns for security testing and Guardium validation</p>
              
              <!-- Statistics -->
              <div class="w3-row-padding" style="margin-top: 10px;">
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-theme-l4">
                    <h3 id="totalPatterns">0</h3>
                    <p>Total Patterns</p>
                  </div>
                </div>
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-red">
                    <h3 id="criticalCount" style="color: white;">0</h3>
                    <p style="color: white;">Critical</p>
                  </div>
                </div>
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-orange">
                    <h3 id="highCount" style="color: white;">0</h3>
                    <p style="color: white;">High</p>
                  </div>
                </div>
                <div class="w3-col s3">
                  <div class="w3-card w3-center w3-padding w3-theme-l4">
                    <h3 id="categoryCount">0</h3>
                    <p>Categories</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Search and Filter -->
      <div class="w3-row-padding" style="margin-top: 16px;">
        <div class="w3-col m12">
          <div class="w3-card w3-round w3-white">
            <div class="w3-container w3-padding">
              <h6 class="w3-opacity">Search & Filter</h6>
              <div class="w3-row">
                <div class="w3-col s8">
                  <input type="text" id="searchInput" class="w3-input w3-border" placeholder="Search patterns by name, description, or tags..." onkeyup="searchPatterns()">
                </div>
                <div class="w3-col s4" style="padding-left: 10px;">
                  <select id="severityFilter" class="w3-select w3-border" onchange="filterBySeverity()">
                    <option value="">All Severities</option>
                    <option value="CRITICAL">Critical</option>
                    <option value="HIGH">High</option>
                    <option value="MEDIUM">Medium</option>
                    <option value="LOW">Low</option>
                  </select>
                </div>
              </div>
              
              <!-- Category Tabs -->
              <div id="categoryTabs" style="margin-top: 15px;">
                <span class="category-tab active" onclick="filterByCategory('')">All Categories</span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Patterns List -->
      <div id="patternsList" style="margin-top: 16px;">
        <!-- Patterns will be loaded here -->
      </div>
      
      <!-- Pattern Detail Modal -->
      <div id="patternModal" class="w3-modal">
        <div class="w3-modal-content w3-card-4" style="max-width: 800px;">
          <header class="w3-container w3-theme-d3">
            <span onclick="document.getElementById('patternModal').style.display='none'" 
                  class="w3-button w3-display-topright">&times;</span>
            <h3 id="modalTitle">Pattern Details</h3>
          </header>
          <div class="w3-container" style="max-height: 600px; overflow-y: auto;">
            <div id="modalContent">
              <!-- Pattern details will be loaded here -->
            </div>
          </div>
          <footer class="w3-container w3-theme-l4">
            <p>
              <button class="w3-button w3-theme" onclick="executePattern()">
                <i class="fa fa-play"></i> Execute Pattern
              </button>
              <button class="w3-button w3-light-grey" onclick="document.getElementById('patternModal').style.display='none'">
                Close
              </button>
            </p>
          </footer>
        </div>
      </div>
      
    <!-- End Middle Column -->
    </div>
    
  <!-- End Grid -->
  </div>
 
<!-- End Page Container -->
</div>
<br>

<!-- Footer -->
<div id="footer"></div>
 
<script>
// Load navbar, left column, and footer
$(document).ready(function() {
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
    
    // Load library data
    loadStatistics();
    loadCategories();
    loadAllPatterns();
});

let allPatterns = [];
let currentPattern = null;

// Load statistics
function loadStatistics() {
    $.ajax({
        url: '/api/library/stats',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                $('#totalPatterns').text(response.totalPatterns);
                $('#categoryCount').text(response.totalCategories);
                $('#criticalCount').text(response.patternsBySeverity.CRITICAL || 0);
                $('#highCount').text(response.patternsBySeverity.HIGH || 0);
            }
        },
        error: function(err) {
            console.error('Error loading statistics:', err);
        }
    });
}

// Load categories
function loadCategories() {
    $.ajax({
        url: '/api/library/categories',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                const tabsContainer = $('#categoryTabs');
                response.categories.forEach(function(cat) {
                    const tab = $('<span>')
                        .addClass('category-tab')
                        .attr('onclick', "filterByCategory('" + cat.name + "')")
                        .html(cat.name + ' <span class="w3-badge w3-theme">' + cat.count + '</span>');
                    tabsContainer.append(tab);
                });
            }
        },
        error: function(err) {
            console.error('Error loading categories:', err);
        }
    });
}

// Load all patterns
function loadAllPatterns() {
    $.ajax({
        url: '/api/library/patterns',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                allPatterns = response.patterns;
                displayPatterns(allPatterns);
            }
        },
        error: function(err) {
            console.error('Error loading patterns:', err);
            $('#patternsList').html('<div class="w3-panel w3-red"><p>Error loading patterns</p></div>');
        }
    });
}

// Display patterns
function displayPatterns(patterns) {
    const container = $('#patternsList');
    container.empty();
    
    if (patterns.length === 0) {
        container.html('<div class="w3-panel w3-pale-yellow w3-border"><p>No patterns found</p></div>');
        return;
    }
    
    patterns.forEach(function(pattern) {
        const card = $('<div>')
            .addClass('w3-card w3-round w3-white w3-margin-bottom pattern-card severity-' + pattern.severity.toLowerCase())
            .attr('onclick', "showPatternDetails('" + pattern.id + "')")
            .html(
                '<div class="w3-container w3-padding">' +
                    '<div class="w3-row">' +
                        '<div class="w3-col s9">' +
                            '<h5><i class="fa fa-bug w3-margin-right"></i>' + pattern.name + '</h5>' +
                            '<p class="w3-opacity">' + pattern.description.substring(0, 150) + '...</p>' +
                        '</div>' +
                        '<div class="w3-col s3 w3-right-align">' +
                            '<span class="w3-tag badge-' + pattern.severity.toLowerCase() + '">' + pattern.severity + '</span>' +
                            '<p class="w3-small w3-opacity">' + pattern.category + '</p>' +
                        '</div>' +
                    '</div>' +
                    '<div class="w3-row">' +
                        '<div class="w3-col s12">' +
                            '<span class="pattern-tags"></span>' +
                        '</div>' +
                    '</div>' +
                '</div>'
            );
        
        // Add tags separately to avoid FreeMarker parsing issues
        const tagsContainer = card.find('.pattern-tags');
        pattern.tags.forEach(function(tag) {
            tagsContainer.append('<span class="tag">' + tag + '</span>');
        });
        
        container.append(card);
    });
}

// Show pattern details
function showPatternDetails(patternId) {
    $.ajax({
        url: '/api/library/patterns/' + patternId,
        method: 'GET',
        success: function(response) {
            if (response.success) {
                currentPattern = response.pattern;
                displayPatternDetails(currentPattern);
                document.getElementById('patternModal').style.display = 'block';
            }
        },
        error: function(err) {
            console.error('Error loading pattern details:', err);
        }
    });
}

// Display pattern details in modal
function displayPatternDetails(pattern) {
    $('#modalTitle').html('<i class="fa fa-bug"></i> ' + pattern.name);
    
    const content =
        '<div style="padding: 20px;">' +
            '<div class="w3-row-padding">' +
                '<div class="w3-col s6">' +
                    '<p><strong>ID:</strong> ' + pattern.id + '</p>' +
                    '<p><strong>Category:</strong> ' + pattern.category + '</p>' +
                    '<p><strong>Severity:</strong> <span class="w3-tag badge-' + pattern.severity.toLowerCase() + '">' + pattern.severity + '</span></p>' +
                '</div>' +
                '<div class="w3-col s6">' +
                    '<p><strong>Target Databases:</strong></p>' +
                    '<p id="target-databases-list"></p>' +
                '</div>' +
            '</div>' +
            '<hr>' +
            '<h6><strong>Description</strong></h6>' +
            '<p>' + pattern.description + '</p>' +
            '<hr>' +
            '<h6><strong>SQL Queries</strong></h6>' +
            '<div id="sql-queries-list"></div>' +
            '<hr>' +
            '<h6><strong>Expected Guardium Alert</strong></h6>' +
            '<p class="w3-panel w3-pale-blue w3-border w3-border-blue">' +
                '<i class="fa fa-bell"></i> ' + pattern.expectedGuardiumAlert +
            '</p>' +
            '<hr>' +
            '<h6><strong>Mitigation</strong></h6>' +
            '<p class="w3-panel w3-pale-green w3-border w3-border-green">' +
                '<i class="fa fa-shield"></i> ' + pattern.mitigation +
            '</p>' +
            '<hr>' +
            '<h6><strong>Tags</strong></h6>' +
            '<p id="pattern-tags-list"></p>' +
        '</div>';
    
    $('#modalContent').html(content);
    
    // Populate target databases
    pattern.targetDatabases.forEach(function(db) {
        $('#target-databases-list').append('<span class="w3-tag w3-blue w3-small">' + db + '</span> ');
    });
    
    // Populate SQL queries
    pattern.sqlQueries.forEach(function(query, idx) {
        $('#sql-queries-list').append(
            '<div class="sql-query"><strong>Query ' + (idx + 1) + ':</strong><br>' + query + '</div>'
        );
    });
    
    // Populate tags
    pattern.tags.forEach(function(tag) {
        $('#pattern-tags-list').append('<span class="tag">' + tag + '</span>');
    });
}

// Execute pattern
function executePattern() {
    if (!currentPattern) {
        alert('No pattern selected');
        return;
    }
    
    // Get database connections
    const jwtToken = '${tokenObject.jwt}';
    const jsonData = JSON.stringify({ jwt: jwtToken });
    
    $.ajax({
        url: '/api/getDatabaseConnections',
        type: 'POST',
        data: jsonData,
        contentType: 'application/json; charset=utf-8',
        success: function(connections) {
            if (connections.length === 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'No Database Connections',
                    text: 'Please configure database connections first'
                });
                return;
            }
            
            // Filter connections by pattern's target databases
            const compatibleConnections = connections.filter(conn => 
                currentPattern.targetDatabases.includes(conn.db_type.toLowerCase())
            );
            
            if (compatibleConnections.length === 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'No Compatible Databases',
                    text: 'This pattern requires: ' + currentPattern.targetDatabases.join(', ')
                });
                return;
            }
            
            // Show connection selector
            let options = '';
            compatibleConnections.forEach(function(conn) {
                options += '<option value="' + conn.id + '">' +
                          (conn.db_connection_id || conn.connection || 'Connection') + ' (' + conn.db_type + ')</option>';
            });
            
            Swal.fire({
                title: 'Select Target Database',
                html: '<select id="targetDb" class="swal2-input">' + options + '</select>' +
                    '<p style="margin-top: 15px; color: #d32f2f;">' +
                        '<i class="fa fa-warning"></i> <strong>Warning:</strong> This will execute ' +
                        currentPattern.sqlQueries.length + ' SQL queries against the selected database.' +
                    '</p>',
                showCancelButton: true,
                confirmButtonText: 'Execute',
                confirmButtonColor: '#d32f2f',
                preConfirm: () => {
                    return document.getElementById('targetDb').value;
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    executePatternQueries(result.value);
                }
            });
        },
        error: function(err) {
            console.error('Error loading connections:', err);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to load database connections'
            });
        }
    });
}

// Execute pattern queries
function executePatternQueries(dbConnectionId) {
    const jwtToken = '${tokenObject.jwt}';
    
    Swal.fire({
        title: 'Executing Pattern',
        html: 'Executing ' + currentPattern.sqlQueries.length + ' queries...<br><div id="progress"></div>',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
    
    let completed = 0;
    let results = [];
    
    currentPattern.sqlQueries.forEach((query, index) => {
        const queryData = JSON.stringify({
            jwt: jwtToken,
            db_connection_id: dbConnectionId,
            query: query
        });
        
        $.ajax({
            url: '/api/runDatabaseQueryByDatasourceMap',
            type: 'POST',
            data: queryData,
            contentType: 'application/json; charset=utf-8',
            success: function(response) {
                results.push({ query: index + 1, status: 'success', response: response });
                completed++;
                checkCompletion();
            },
            error: function(err) {
                results.push({ query: index + 1, status: 'error', error: err.responseText });
                completed++;
                checkCompletion();
            }
        });
    });
    
    function checkCompletion() {
        $('#progress').html(completed + ' / ' + currentPattern.sqlQueries.length + ' queries completed');
        
        if (completed === currentPattern.sqlQueries.length) {
            const successCount = results.filter(r => r.status === 'success').length;
            const errorCount = results.filter(r => r.status === 'error').length;
            
            Swal.fire({
                icon: successCount > 0 ? 'success' : 'error',
                title: 'Execution Complete',
                html: '<p><strong>Pattern:</strong> ' + currentPattern.name + '</p>' +
                    '<p><strong>Successful:</strong> ' + successCount + '</p>' +
                    '<p><strong>Failed:</strong> ' + errorCount + '</p>' +
                    '<p style="margin-top: 15px; color: #2196F3;">' +
                        '<i class="fa fa-info-circle"></i> Check Guardium for alert: <strong>' + currentPattern.expectedGuardiumAlert + '</strong>' +
                    '</p>'
            });
        }
    }
}

// Search patterns
function searchPatterns() {
    const query = $('#searchInput').val();
    
    if (query.length < 2) {
        displayPatterns(allPatterns);
        return;
    }
    
    $.ajax({
        url: '/api/library/search?q=' + encodeURIComponent(query),
        method: 'GET',
        success: function(response) {
            if (response.success) {
                displayPatterns(response.patterns);
            }
        },
        error: function(err) {
            console.error('Error searching patterns:', err);
        }
    });
}

// Filter by category
function filterByCategory(category) {
    // Update active tab
    $('.category-tab').removeClass('active');
    event.target.classList.add('active');
    
    if (category === '') {
        displayPatterns(allPatterns);
        return;
    }
    
    $.ajax({
        url: '/api/library/categories/' + encodeURIComponent(category) + '/patterns',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                displayPatterns(response.patterns);
            }
        },
        error: function(err) {
            console.error('Error filtering by category:', err);
        }
    });
}

// Filter by severity
function filterBySeverity() {
    const severity = $('#severityFilter').val();
    
    if (severity === '') {
        displayPatterns(allPatterns);
        return;
    }
    
    $.ajax({
        url: '/api/library/severity/' + severity + '/patterns',
        method: 'GET',
        success: function(response) {
            if (response.success) {
                displayPatterns(response.patterns);
            }
        },
        error: function(err) {
            console.error('Error filtering by severity:', err);
        }
    });
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('patternModal');
    if (event.target == modal) {
        modal.style.display = "none";
    }
}
</script>

<!-- SweetAlert2 and notification script -->
<script src="/js/sweetalert.js"></script>
<script src="/js/notifications.js"></script>
</body>
</html>