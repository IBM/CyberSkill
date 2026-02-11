// API Base URL
const API_BASE = '/api';

// Chart instances
let readinessChart = null;
let vulnerabilityChart = null;
let algorithmChart = null;
let riskDistributionChart = null;
let pqcAdoptionChart = null;
let riskTrendChart = null;
let tlsTrendChart = null;
let criticalTrendChart = null;

// Data cache
let allResults = [];
let riskDistributionData = null;
let trendData = null;

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    initCharts();
    refreshData();
    
    // Auto-refresh every 30 seconds
    setInterval(refreshData, 30000);
});

// Initialize all charts
function initCharts() {
    // Readiness Chart
    const readinessCtx = document.getElementById('readinessChart').getContext('2d');
    readinessChart = new Chart(readinessCtx, {
        type: 'doughnut',
        data: {
            labels: ['PQC Ready', 'Vulnerable'],
            datasets: [{
                data: [0, 0],
                backgroundColor: ['#10b981', '#ef4444'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });

    // Vulnerability Window Chart
    const vulnerabilityCtx = document.getElementById('vulnerabilityChart').getContext('2d');
    vulnerabilityChart = new Chart(vulnerabilityCtx, {
        type: 'bar',
        data: {
            labels: [],
            datasets: [{
                label: 'Number of Domains',
                data: [],
                backgroundColor: '#2563eb',
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });

    // Algorithm Distribution Chart
    const algorithmCtx = document.getElementById('algorithmChart').getContext('2d');
    algorithmChart = new Chart(algorithmCtx, {
        type: 'bar',
        data: {
            labels: [],
            datasets: [{
                label: 'Usage Count',
                data: [],
                backgroundColor: [
                    '#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899'
                ],
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            indexAxis: 'y',
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });

    // Risk Distribution Chart
    const riskDistCtx = document.getElementById('riskDistributionChart').getContext('2d');
    riskDistributionChart = new Chart(riskDistCtx, {
        type: 'pie',
        data: {
            labels: ['Critical', 'High', 'Medium', 'Low'],
            datasets: [{
                data: [0, 0, 0, 0],
                backgroundColor: ['#ef4444', '#f59e0b', '#fbbf24', '#10b981'],
                borderWidth: 2,
                borderColor: '#ffffff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });

    // PQC Adoption Trend Chart
    const pqcAdoptionCtx = document.getElementById('pqcAdoptionChart').getContext('2d');
    pqcAdoptionChart = new Chart(pqcAdoptionCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'PQC Ready Domains',
                data: [],
                borderColor: '#10b981',
                backgroundColor: 'rgba(16, 185, 129, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });

    // Risk Trend Chart
    const riskTrendCtx = document.getElementById('riskTrendChart').getContext('2d');
    riskTrendChart = new Chart(riskTrendCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Average Risk Score',
                data: [],
                borderColor: '#f59e0b',
                backgroundColor: 'rgba(245, 158, 11, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100
                }
            }
        }
    });

    // TLS Trend Chart
    const tlsTrendCtx = document.getElementById('tlsTrendChart').getContext('2d');
    tlsTrendChart = new Chart(tlsTrendCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'TLS 1.3 Adoption %',
                data: [],
                borderColor: '#2563eb',
                backgroundColor: 'rgba(37, 99, 235, 0.1)',
                tension: 0.4,
                fill: true
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 100
                }
            }
        }
    });

    // Critical Trend Chart
    const criticalTrendCtx = document.getElementById('criticalTrendChart').getContext('2d');
    criticalTrendChart = new Chart(criticalTrendCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [
                {
                    label: 'Critical Risk',
                    data: [],
                    borderColor: '#ef4444',
                    backgroundColor: 'rgba(239, 68, 68, 0.1)',
                    tension: 0.4,
                    fill: true
                },
                {
                    label: 'High Risk',
                    data: [],
                    borderColor: '#f59e0b',
                    backgroundColor: 'rgba(245, 158, 11, 0.1)',
                    tension: 0.4,
                    fill: true
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: true
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
}

// Refresh all data
async function refreshData() {
    try {
        await Promise.all([
            loadStats(),
            loadDomains(),
            loadResults(),
            loadVulnerabilityWindow(),
            loadRiskDistribution(),
            loadTrendData()
        ]);
    } catch (error) {
        console.error('Error refreshing data:', error);
        showNotification('Error loading data', 'error');
    }
}

// Load statistics
async function loadStats() {
    try {
        const response = await fetch(`${API_BASE}/stats`);
        const stats = await response.json();
        
        document.getElementById('total-domains').textContent = stats.total_domains || 0;
        document.getElementById('pqc-ready').textContent = stats.pqc_ready_domains || 0;
        document.getElementById('vulnerable').textContent = stats.vulnerable_domains || 0;
        document.getElementById('avg-response').textContent =
            stats.avg_response_time ? `${Math.round(stats.avg_response_time)}ms` : '0ms';
        document.getElementById('high-risk').textContent = stats.high_risk_domains || 0;
        
        // Update readiness chart
        readinessChart.data.datasets[0].data = [
            stats.pqc_ready_domains || 0,
            stats.vulnerable_domains || 0
        ];
        readinessChart.update();
    } catch (error) {
        console.error('Error loading stats:', error);
    }
}

// Load risk distribution
async function loadRiskDistribution() {
    try {
        const response = await fetch(`${API_BASE}/risk-distribution`);
        riskDistributionData = await response.json();
        
        const critical = riskDistributionData.find(r => r.risk_level === 'CRITICAL')?.count || 0;
        const high = riskDistributionData.find(r => r.risk_level === 'HIGH')?.count || 0;
        const medium = riskDistributionData.find(r => r.risk_level === 'MEDIUM')?.count || 0;
        const low = riskDistributionData.find(r => r.risk_level === 'LOW')?.count || 0;
        const total = critical + high + medium + low || 1;
        
        // Update summary cards
        document.getElementById('critical-count').textContent = critical;
        document.getElementById('high-count').textContent = high;
        document.getElementById('medium-count').textContent = medium;
        document.getElementById('low-count').textContent = low;
        
        document.getElementById('critical-percent').textContent = `${Math.round(critical / total * 100)}%`;
        document.getElementById('high-percent').textContent = `${Math.round(high / total * 100)}%`;
        document.getElementById('medium-percent').textContent = `${Math.round(medium / total * 100)}%`;
        document.getElementById('low-percent').textContent = `${Math.round(low / total * 100)}%`;
        
        // Update chart
        riskDistributionChart.data.datasets[0].data = [critical, high, medium, low];
        riskDistributionChart.update();
    } catch (error) {
        console.error('Error loading risk distribution:', error);
    }
}

// Load trend data
async function loadTrendData() {
    try {
        const days = document.getElementById('trend-period')?.value || 30;
        const response = await fetch(`${API_BASE}/trends?days=${days}`);
        trendData = await response.json();
        
        if (trendData.length === 0) return;
        
        const labels = trendData.map(d => new Date(d.scan_date).toLocaleDateString());
        const pqcReady = trendData.map(d => d.pqc_ready_count || 0);
        const avgRisk = trendData.map(d => d.avg_risk_score || 0);
        const tlsPercent = trendData.map(d => d.tls13_percentage || 0);
        const criticalCount = trendData.map(d => d.critical_count || 0);
        const highCount = trendData.map(d => d.high_count || 0);
        
        // Update PQC Adoption Chart
        pqcAdoptionChart.data.labels = labels;
        pqcAdoptionChart.data.datasets[0].data = pqcReady;
        pqcAdoptionChart.update();
        
        // Update Risk Trend Chart
        riskTrendChart.data.labels = labels;
        riskTrendChart.data.datasets[0].data = avgRisk;
        riskTrendChart.update();
        
        // Update TLS Trend Chart
        tlsTrendChart.data.labels = labels;
        tlsTrendChart.data.datasets[0].data = tlsPercent;
        tlsTrendChart.update();
        
        // Update Critical Trend Chart
        criticalTrendChart.data.labels = labels;
        criticalTrendChart.data.datasets[0].data = criticalCount;
        criticalTrendChart.data.datasets[1].data = highCount;
        criticalTrendChart.update();
    } catch (error) {
        console.error('Error loading trend data:', error);
    }
}

// Load domains list
async function loadDomains() {
    try {
        const response = await fetch(`${API_BASE}/domains`);
        const domains = await response.json();
        
        const domainList = document.getElementById('domain-list');
        
        if (domains.length === 0) {
            domainList.innerHTML = '<p class="loading">No domains added yet. Add a domain to get started.</p>';
            return;
        }
        
        domainList.innerHTML = domains.map(domain => `
            <div class="domain-item">
                <div class="domain-info">
                    <div class="domain-name">${domain.domain_name}</div>
                    <div class="domain-meta">
                        Last scanned: ${domain.last_scanned ? new Date(domain.last_scanned).toLocaleString() : 'Never'} | 
                        Scans: ${domain.scan_count || 0}
                        ${domain.is_pqc_ready !== null ? 
                            `<span class="status-badge ${domain.is_pqc_ready ? 'success' : 'danger'}">
                                ${domain.is_pqc_ready ? '✓ PQC Ready' : '⚠ Vulnerable'}
                            </span>` : ''}
                    </div>
                </div>
                <div class="domain-actions">
                    <button onclick="scanDomain('${domain.domain_name}')" class="btn btn-info">Scan</button>
                    <button onclick="viewCertificate('${domain.domain_name}')" class="btn btn-info">Certificate</button>
                    <button onclick="viewCertificateChain('${domain.domain_name}')" class="btn btn-info">Chain</button>
                    <button onclick="deleteDomain(${domain.id})" class="btn btn-danger">Delete</button>
                </div>
            </div>
        `).join('');
    } catch (error) {
        console.error('Error loading domains:', error);
    }
}

// Load scan results
async function loadResults() {
    try {
        const response = await fetch(`${API_BASE}/results?limit=100`);
        allResults = await response.json();
        
        displayResults(allResults);
        updateAlgorithmChart(allResults);
    } catch (error) {
        console.error('Error loading results:', error);
    }
}

// Display results in table
function displayResults(results) {
    const tbody = document.getElementById('results-body');
    
    if (results.length === 0) {
        tbody.innerHTML = '<tr><td colspan="10" class="loading">No scan results yet.</td></tr>';
        return;
    }
    
    tbody.innerHTML = results.map(result => {
        const statusClass = result.is_pqc_ready ? 'success' : 'danger';
        const statusText = result.is_pqc_ready ? '✓ PQC Ready' : '⚠ Vulnerable';
        const tlsStatus = result.supports_tls_13 ? '✓' : '✗';
        const daysText = result.days_until_vulnerable < 0 ? 'N/A' :
            result.days_until_vulnerable === 0 ? 'Expired' :
            `${result.days_until_vulnerable} days`;
        
        const riskLevel = result.risk_level || 'UNKNOWN';
        const riskClass = getRiskClass(riskLevel);
        const riskScore = result.risk_score !== undefined ? Math.round(result.risk_score) : 'N/A';
        
        return `
            <tr>
                <td><strong>${result.domain_name}</strong></td>
                <td><span class="status-badge ${statusClass}">${statusText}</span></td>
                <td><span class="risk-badge ${riskClass}" title="Risk Score: ${riskScore}">${riskLevel}</span></td>
                <td><span class="risk-score-badge">${riskScore}</span></td>
                <td>${tlsStatus}</td>
                <td>${result.pqc_algorithm_type || result.public_key_algorithm || 'N/A'}</td>
                <td>${result.public_key_size ? `${result.public_key_size} bits` : 'N/A'}</td>
                <td>${daysText}</td>
                <td>${new Date(result.scan_date).toLocaleString()}</td>
                <td>
                    <button onclick="viewCertificate('${result.domain_name}')" class="btn btn-info btn-sm">Details</button>
                    <button onclick="viewCertificateChain('${result.domain_name}')" class="btn btn-info btn-sm">Chain</button>
                </td>
            </tr>
        `;
    }).join('');
}

// Filter results
function filterResults() {
    const searchTerm = document.getElementById('search-input').value.toLowerCase();
    const riskFilter = document.getElementById('risk-filter').value;
    
    let filtered = allResults;
    
    if (searchTerm) {
        filtered = filtered.filter(r => r.domain_name.toLowerCase().includes(searchTerm));
    }
    
    if (riskFilter) {
        filtered = filtered.filter(r => r.risk_level === riskFilter);
    }
    
    displayResults(filtered);
}

// Get CSS class for risk level
function getRiskClass(riskLevel) {
    switch(riskLevel) {
        case 'CRITICAL':
            return 'risk-critical';
        case 'HIGH':
            return 'risk-high';
        case 'MEDIUM':
            return 'risk-medium';
        case 'LOW':
            return 'risk-low';
        default:
            return 'risk-unknown';
    }
}

// Update algorithm distribution chart
function updateAlgorithmChart(results) {
    const algorithmCounts = {};
    
    results.forEach(result => {
        const algo = result.pqc_algorithm_type || result.public_key_algorithm || 'Unknown';
        algorithmCounts[algo] = (algorithmCounts[algo] || 0) + 1;
    });
    
    const sortedAlgos = Object.entries(algorithmCounts)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 10);
    
    algorithmChart.data.labels = sortedAlgos.map(([algo]) => algo);
    algorithmChart.data.datasets[0].data = sortedAlgos.map(([, count]) => count);
    algorithmChart.update();
}

// Load vulnerability window data
async function loadVulnerabilityWindow() {
    try {
        const response = await fetch(`${API_BASE}/vulnerability-window`);
        const windows = await response.json();
        
        vulnerabilityChart.data.labels = windows.map(w => w.window);
        vulnerabilityChart.data.datasets[0].data = windows.map(w => w.count);
        vulnerabilityChart.update();
    } catch (error) {
        console.error('Error loading vulnerability window:', error);
    }
}

// Add a new domain
async function addDomain() {
    const input = document.getElementById('domain-input');
    const domain = input.value.trim();
    
    if (!domain) {
        showNotification('Please enter a domain name', 'error');
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE}/domains`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ domain })
        });
        
        if (response.ok) {
            input.value = '';
            showNotification(`Domain ${domain} added successfully`, 'success');
            await loadDomains();
        } else {
            const error = await response.json();
            showNotification(error.error || 'Failed to add domain', 'error');
        }
    } catch (error) {
        console.error('Error adding domain:', error);
        showNotification('Error adding domain', 'error');
    }
}

// Delete a domain
async function deleteDomain(id) {
    if (!confirm('Are you sure you want to delete this domain?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE}/domains/${id}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showNotification('Domain deleted successfully', 'success');
            await refreshData();
        } else {
            showNotification('Failed to delete domain', 'error');
        }
    } catch (error) {
        console.error('Error deleting domain:', error);
        showNotification('Error deleting domain', 'error');
    }
}

// Scan a single domain
async function scanDomain(domain) {
    showNotification(`Scanning ${domain}...`, 'info');
    
    try {
        const response = await fetch(`${API_BASE}/scan/${domain}`, {
            method: 'POST'
        });
        
        const result = await response.json();
        
        if (result.error) {
            showNotification(`Scan failed: ${result.error_message}`, 'error');
        } else {
            const status = result.is_pqc_ready ? 'PQC Ready ✓' : 'Vulnerable ⚠';
            showNotification(`Scan complete: ${domain} is ${status}`, 'success');
            await refreshData();
        }
    } catch (error) {
        console.error('Error scanning domain:', error);
        showNotification('Error scanning domain', 'error');
    }
}

// Scan all domains
async function scanAllDomains() {
    try {
        const response = await fetch(`${API_BASE}/domains`);
        const domains = await response.json();
        
        if (domains.length === 0) {
            showNotification('No domains to scan', 'error');
            return;
        }
        
        showNotification(`Scanning ${domains.length} domains...`, 'info');
        
        const domainNames = domains.map(d => d.domain_name);
        const batchResponse = await fetch(`${API_BASE}/scan-batch`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ domains: domainNames })
        });
        
        if (batchResponse.ok) {
            showNotification('Batch scan completed', 'success');
            await refreshData();
        } else {
            showNotification('Batch scan failed', 'error');
        }
    } catch (error) {
        console.error('Error scanning all domains:', error);
        showNotification('Error scanning domains', 'error');
    }
}

// View certificate details
async function viewCertificate(domain) {
    try {
        const response = await fetch(`${API_BASE}/certificate/${domain}`);
        
        if (!response.ok) {
            showNotification('Certificate details not available', 'error');
            return;
        }
        
        const cert = await response.json();
        
        const detailsHtml = `
            <div class="cert-detail-item">
                <strong>Subject:</strong>
                <span>${cert.subject || 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Issuer:</strong>
                <span>${cert.issuer || 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Serial Number:</strong>
                <span>${cert.serial_number || 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Valid From:</strong>
                <span>${cert.not_before ? new Date(cert.not_before).toLocaleString() : 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Valid Until:</strong>
                <span>${cert.not_after ? new Date(cert.not_after).toLocaleString() : 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Public Key Algorithm:</strong>
                <span>${cert.public_key_algorithm || 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Public Key Size:</strong>
                <span>${cert.public_key_size ? `${cert.public_key_size} bits` : 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Signature Algorithm:</strong>
                <span>${cert.signature_algorithm || 'N/A'}</span>
            </div>
            <div class="cert-detail-item">
                <strong>Quantum Safe:</strong>
                <span class="status-badge ${cert.is_quantum_safe ? 'success' : 'danger'}">
                    ${cert.is_quantum_safe ? '✓ Yes' : '✗ No'}
                </span>
            </div>
            <div class="cert-detail-item">
                <strong>PQC Algorithm Type:</strong>
                <span>${cert.pqc_algorithm_type || 'Classical'}</span>
            </div>
            ${cert.san_entries ? `
                <div class="cert-detail-item">
                    <strong>Subject Alternative Names:</strong>
                    <span>${cert.san_entries}</span>
                </div>
            ` : ''}
        `;
        
        document.getElementById('cert-details').innerHTML = detailsHtml;
        document.getElementById('cert-modal').style.display = 'block';
    } catch (error) {
        console.error('Error loading certificate:', error);
        showNotification('Error loading certificate details', 'error');
    }
}

// View certificate chain
async function viewCertificateChain(domain) {
    try {
        const response = await fetch(`${API_BASE}/certificate-chain/${domain}`);
        
        if (!response.ok) {
            showNotification('Certificate chain not available', 'error');
            return;
        }
        
        const chain = await response.json();
        
        if (!chain.chain || chain.chain.length === 0) {
            showNotification('No certificate chain data available', 'error');
            return;
        }
        
        let chainHtml = `
            <div class="chain-summary">
                <h3>Chain Summary</h3>
                <div class="chain-stats">
                    <div class="chain-stat">
                        <strong>Chain Length:</strong> ${chain.chain.length} certificates
                    </div>
                    <div class="chain-stat">
                        <strong>Chain Valid:</strong> 
                        <span class="status-badge ${chain.chain_valid ? 'success' : 'danger'}">
                            ${chain.chain_valid ? '✓ Valid' : '✗ Invalid'}
                        </span>
                    </div>
                    <div class="chain-stat">
                        <strong>Has Issues:</strong> 
                        <span class="status-badge ${chain.has_issues ? 'danger' : 'success'}">
                            ${chain.has_issues ? '⚠ Yes' : '✓ No'}
                        </span>
                    </div>
                    ${chain.weak_algorithms && chain.weak_algorithms.length > 0 ? `
                        <div class="chain-stat warning">
                            <strong>⚠ Weak Algorithms Detected:</strong> ${chain.weak_algorithms.join(', ')}
                        </div>
                    ` : ''}
                </div>
            </div>
            <div class="chain-certificates">
                <h3>Certificate Chain</h3>
        `;
        
        chain.chain.forEach((cert, index) => {
            const isRoot = index === chain.chain.length - 1;
            const isLeaf = index === 0;
            const certType = isRoot ? '🔐 Root CA' : isLeaf ? '📄 End Entity' : '🔗 Intermediate CA';
            
            chainHtml += `
                <div class="chain-cert-item ${isRoot ? 'root' : isLeaf ? 'leaf' : 'intermediate'}">
                    <div class="chain-cert-header">
                        <span class="chain-cert-type">${certType}</span>
                        <span class="chain-cert-level">Level ${index + 1}</span>
                    </div>
                    <div class="chain-cert-details">
                        <div class="cert-detail-row">
                            <strong>Subject:</strong>
                            <span>${cert.subject || 'N/A'}</span>
                        </div>
                        <div class="cert-detail-row">
                            <strong>Issuer:</strong>
                            <span>${cert.issuer || 'N/A'}</span>
                        </div>
                        <div class="cert-detail-row">
                            <strong>Algorithm:</strong>
                            <span class="${cert.is_quantum_safe ? 'text-success' : 'text-danger'}">
                                ${cert.public_key_algorithm || 'N/A'}
                                ${cert.is_quantum_safe ? ' ✓' : ' ⚠'}
                            </span>
                        </div>
                        <div class="cert-detail-row">
                            <strong>Key Size:</strong>
                            <span>${cert.public_key_size ? `${cert.public_key_size} bits` : 'N/A'}</span>
                        </div>
                        <div class="cert-detail-row">
                            <strong>Valid:</strong>
                            <span>${cert.not_before ? new Date(cert.not_before).toLocaleDateString() : 'N/A'} - 
                                  ${cert.not_after ? new Date(cert.not_after).toLocaleDateString() : 'N/A'}</span>
                        </div>
                        <div class="cert-detail-row">
                            <strong>Quantum Safe:</strong>
                            <span class="status-badge ${cert.is_quantum_safe ? 'success' : 'danger'}">
                                ${cert.is_quantum_safe ? '✓ Yes' : '✗ No'}
                            </span>
                        </div>
                    </div>
                </div>
                ${index < chain.chain.length - 1 ? '<div class="chain-arrow">⬇️</div>' : ''}
            `;
        });
        
        chainHtml += '</div>';
        
        document.getElementById('chain-details').innerHTML = chainHtml;
        document.getElementById('chain-modal').style.display = 'block';
    } catch (error) {
        console.error('Error loading certificate chain:', error);
        showNotification('Error loading certificate chain', 'error');
    }
}

// Close certificate modal
function closeCertModal() {
    document.getElementById('cert-modal').style.display = 'none';
}

// Close chain modal
function closeChainModal() {
    document.getElementById('chain-modal').style.display = 'none';
}

// Close export modal
function closeExportModal() {
    document.getElementById('export-modal').style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function(event) {
    const certModal = document.getElementById('cert-modal');
    const chainModal = document.getElementById('chain-modal');
    const exportModal = document.getElementById('export-modal');
    
    if (event.target === certModal) {
        certModal.style.display = 'none';
    }
    if (event.target === chainModal) {
        chainModal.style.display = 'none';
    }
    if (event.target === exportModal) {
        exportModal.style.display = 'none';
    }
}

// Export report
function exportReport() {
    document.getElementById('export-modal').style.display = 'block';
}

// Export as JSON
async function exportJSON() {
    try {
        const data = await gatherExportData();
        const json = JSON.stringify(data, null, 2);
        downloadFile(json, 'pqc-scanner-report.json', 'application/json');
        showNotification('Report exported as JSON', 'success');
        closeExportModal();
    } catch (error) {
        console.error('Error exporting JSON:', error);
        showNotification('Error exporting report', 'error');
    }
}

// Export as CSV
async function exportCSV() {
    try {
        const data = await gatherExportData();
        
        if (!data.scans || data.scans.length === 0) {
            showNotification('No scan data to export', 'error');
            return;
        }
        
        const headers = ['Domain', 'PQC Ready', 'Risk Level', 'Risk Score', 'TLS 1.3', 'Algorithm', 'Key Size', 'Days Until Vulnerable', 'Scan Date'];
        const rows = data.scans.map(scan => [
            scan.domain_name,
            scan.is_pqc_ready ? 'Yes' : 'No',
            scan.risk_level || 'N/A',
            scan.risk_score !== undefined ? Math.round(scan.risk_score) : 'N/A',
            scan.supports_tls_13 ? 'Yes' : 'No',
            scan.pqc_algorithm_type || scan.public_key_algorithm || 'N/A',
            scan.public_key_size || 'N/A',
            scan.days_until_vulnerable || 'N/A',
            new Date(scan.scan_date).toLocaleString()
        ]);
        
        const csv = [headers, ...rows].map(row => row.join(',')).join('\n');
        downloadFile(csv, 'pqc-scanner-report.csv', 'text/csv');
        showNotification('Report exported as CSV', 'success');
        closeExportModal();
    } catch (error) {
        console.error('Error exporting CSV:', error);
        showNotification('Error exporting report', 'error');
    }
}

// Export as HTML
async function exportHTML() {
    try {
        const data = await gatherExportData();
        
        const html = `
<!DOCTYPE html>
<html>
<head>
    <title>PQC Scanner Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #2563eb; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin: 20px 0; }
        .stat-card { background: #f8fafc; padding: 15px; border-radius: 8px; border-left: 4px solid #2563eb; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background: #f8fafc; font-weight: 600; }
        .success { color: #10b981; }
        .danger { color: #ef4444; }
        .warning { color: #f59e0b; }
    </style>
</head>
<body>
    <h1>🔐 PQC Domain Scanner Report</h1>
    <p>Generated: ${new Date().toLocaleString()}</p>
    
    ${data.stats ? `
    <h2>Statistics</h2>
    <div class="stats">
        <div class="stat-card">
            <h3>${data.stats.total_domains || 0}</h3>
            <p>Total Domains</p>
        </div>
        <div class="stat-card">
            <h3>${data.stats.pqc_ready_domains || 0}</h3>
            <p>PQC Ready</p>
        </div>
        <div class="stat-card">
            <h3>${data.stats.vulnerable_domains || 0}</h3>
            <p>Vulnerable</p>
        </div>
        <div class="stat-card">
            <h3>${data.stats.high_risk_domains || 0}</h3>
            <p>High Risk</p>
        </div>
    </div>
    ` : ''}
    
    ${data.risks ? `
    <h2>Risk Distribution</h2>
    <table>
        <tr>
            <th>Risk Level</th>
            <th>Count</th>
            <th>Percentage</th>
        </tr>
        ${data.risks.map(r => `
        <tr>
            <td>${r.risk_level}</td>
            <td>${r.count}</td>
            <td>${r.percentage}%</td>
        </tr>
        `).join('')}
    </table>
    ` : ''}
    
    ${data.scans ? `
    <h2>Scan Results</h2>
    <table>
        <tr>
            <th>Domain</th>
            <th>Status</th>
            <th>Risk Level</th>
            <th>Algorithm</th>
            <th>Scan Date</th>
        </tr>
        ${data.scans.map(scan => `
        <tr>
            <td>${scan.domain_name}</td>
            <td class="${scan.is_pqc_ready ? 'success' : 'danger'}">
                ${scan.is_pqc_ready ? '✓ PQC Ready' : '⚠ Vulnerable'}
            </td>
            <td>${scan.risk_level || 'N/A'}</td>
            <td>${scan.pqc_algorithm_type || scan.public_key_algorithm || 'N/A'}</td>
            <td>${new Date(scan.scan_date).toLocaleString()}</td>
        </tr>
        `).join('')}
    </table>
    ` : ''}
</body>
</html>
        `;
        
        downloadFile(html, 'pqc-scanner-report.html', 'text/html');
        showNotification('Report exported as HTML', 'success');
        closeExportModal();
    } catch (error) {
        console.error('Error exporting HTML:', error);
        showNotification('Error exporting report', 'error');
    }
}

// Gather export data
async function gatherExportData() {
    const includeStats = document.getElementById('include-stats').checked;
    const includeDomains = document.getElementById('include-domains').checked;
    const includeScans = document.getElementById('include-scans').checked;
    const includeRisks = document.getElementById('include-risks').checked;
    const includeTrends = document.getElementById('include-trends').checked;
    
    const data = {
        generated: new Date().toISOString(),
        version: '1.0'
    };
    
    if (includeStats) {
        const response = await fetch(`${API_BASE}/stats`);
        data.stats = await response.json();
    }
    
    if (includeDomains) {
        const response = await fetch(`${API_BASE}/domains`);
        data.domains = await response.json();
    }
    
    if (includeScans) {
        data.scans = allResults;
    }
    
    if (includeRisks) {
        data.risks = riskDistributionData;
    }
    
    if (includeTrends) {
        data.trends = trendData;
    }
    
    return data;
}

// Download file
function downloadFile(content, filename, mimeType) {
    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
}

// Show notification
function showNotification(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);
    
    const toast = document.createElement('div');
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 1rem 1.5rem;
        background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#2563eb'};
        color: white;
        border-radius: 0.5rem;
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        z-index: 9999;
        animation: slideIn 0.3s;
        max-width: 400px;
    `;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'fadeOut 0.3s';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Handle Enter key in domain input
document.addEventListener('DOMContentLoaded', () => {
    const input = document.getElementById('domain-input');
    if (input) {
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                addDomain();
            }
        });
    }
});

// Made with Bob
