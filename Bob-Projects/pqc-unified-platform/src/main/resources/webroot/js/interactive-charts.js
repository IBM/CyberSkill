// ============================================================================
// INTERACTIVE CHART FEATURES - Drill-down Modals & Tooltips
// ============================================================================

// Global data storage for drill-down
let chartData = {
    scans: [],
    files: [],
    algorithms: {},
    tlsVersions: {}
};

// Modal Management
function showModal(title, content) {
    const modal = document.getElementById('drilldown-modal');
    const modalTitle = document.getElementById('modal-title');
    const modalBody = document.getElementById('modal-body');
    
    modalTitle.textContent = title;
    modalBody.innerHTML = content;
    modal.classList.add('show');
}

function hideModal() {
    const modal = document.getElementById('drilldown-modal');
    modal.classList.remove('show');
}

// Tooltip Management
function showTooltip(x, y, content) {
    const tooltip = document.getElementById('chart-tooltip');
    tooltip.innerHTML = content;
    tooltip.style.left = (x + 15) + 'px';
    tooltip.style.top = (y + 15) + 'px';
    tooltip.classList.add('show');
}

function hideTooltip() {
    const tooltip = document.getElementById('chart-tooltip');
    tooltip.classList.remove('show');
}

// Initialize Modal Event Listeners
function initializeInteractiveCharts() {
    // Close modal on X click
    const closeBtn = document.querySelector('.modal-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', hideModal);
    }
    
    // Close modal on outside click
    const modal = document.getElementById('drilldown-modal');
    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target.id === 'drilldown-modal') {
                hideModal();
            }
        });
    }
    
    // Close modal on ESC key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            hideModal();
        }
    });
    
    // Add click handlers to risk items
    setTimeout(() => {
        addRiskItemClickHandlers();
        addHistogramClickHandlers();
    }, 1000);
}

// Add click handlers to risk items
function addRiskItemClickHandlers() {
    const lowRisk = document.querySelector('.risk-item:nth-child(1)');
    const mediumRisk = document.querySelector('.risk-item:nth-child(2)');
    const highRisk = document.querySelector('.risk-item:nth-child(3)');
    
    if (lowRisk) lowRisk.addEventListener('click', () => showRiskDetails('LOW'));
    if (mediumRisk) mediumRisk.addEventListener('click', () => showRiskDetails('MEDIUM'));
    if (highRisk) highRisk.addEventListener('click', () => showRiskDetails('HIGH'));
}

// Add click handlers to histogram bars
function addHistogramClickHandlers() {
    const bars = document.querySelectorAll('.histogram-bar');
    bars.forEach((bar, index) => {
        const categories = ['small', 'medium', 'large', 'xlarge'];
        bar.addEventListener('click', () => showFileSizeDetails(categories[index]));
    });
}

// Store data for drill-down
function storeChartData(scans, files) {
    chartData.scans = scans || [];
    chartData.files = files || [];
}

// TLS Chart Drill-down
function showTLSDetails(version) {
    const scans = chartData.scans.filter(scan => {
        const protocol = scan.protocol || '';
        return protocol.includes(version);
    });
    
    let content = `
        <div style="margin-bottom: 1rem;">
            <h3>TLS ${version} Domains (${scans.length})</h3>
            <p style="color: #64748b;">Detailed information about domains using TLS ${version}</p>
        </div>
    `;
    
    if (scans.length === 0) {
        content += '<p style="text-align: center; color: #64748b; padding: 2rem;">No domains found using TLS ' + version + '</p>';
    } else {
        content += '<table class="detail-table"><thead><tr><th>Domain</th><th>Cipher Suite</th><th>Risk Level</th><th>PQC</th><th>Scanned</th></tr></thead><tbody>';
        
        scans.forEach(scan => {
            const riskBadge = scan.riskLevel === 'HIGH' ? 'badge-danger' : 
                            scan.riskLevel === 'MEDIUM' ? 'badge-warning' : 'badge-success';
            const pqcBadge = scan.isPQC ? 'badge-success' : 'badge-danger';
            const timestamp = scan.timestamp ? new Date(scan.timestamp).toLocaleString() : 'N/A';
            
            content += `
                <tr>
                    <td><strong>${scan.domain || 'N/A'}</strong></td>
                    <td style="font-size: 12px;">${scan.cipherSuite || 'N/A'}</td>
                    <td><span class="badge ${riskBadge}">${scan.riskLevel || 'UNKNOWN'}</span></td>
                    <td><span class="badge ${pqcBadge}">${scan.isPQC ? 'Yes' : 'No'}</span></td>
                    <td style="font-size: 12px;">${timestamp}</td>
                </tr>
            `;
        });
        
        content += '</tbody></table>';
    }
    
    showModal(`🔒 TLS ${version} Details`, content);
}

// Algorithm Chart Drill-down
function showAlgorithmDetails(algorithm) {
    const files = chartData.files.filter(file => file.algorithm === algorithm);
    
    let content = `
        <div style="margin-bottom: 1rem;">
            <h3>${algorithm} Encrypted Files (${files.length})</h3>
            <p style="color: #64748b;">Files encrypted using ${algorithm}</p>
        </div>
    `;
    
    if (files.length === 0) {
        content += '<p style="text-align: center; color: #64748b; padding: 2rem;">No files encrypted with ' + algorithm + '</p>';
    } else {
        content += '<table class="detail-table"><thead><tr><th>Filename</th><th>Size</th><th>AES Key Size</th><th>Encrypted</th></tr></thead><tbody>';
        
        files.forEach(file => {
            const sizeMB = ((file.size || 0) / (1024 * 1024)).toFixed(2);
            const timestamp = file.timestamp ? new Date(file.timestamp).toLocaleString() : 'N/A';
            
            content += `
                <tr>
                    <td><strong>${file.filename || 'N/A'}</strong></td>
                    <td>${sizeMB} MB</td>
                    <td><span class="badge badge-info">${file.aesKeySize || 256} bits</span></td>
                    <td style="font-size: 12px;">${timestamp}</td>
                </tr>
            `;
        });
        
        content += '</tbody></table>';
    }
    
    showModal(`🔐 ${algorithm} Details`, content);
}

// File Size Distribution Drill-down
function showFileSizeDetails(category) {
    let min = 0, max = Infinity, label = '';
    
    switch(category) {
        case 'small':
            max = 1;
            label = '< 1MB';
            break;
        case 'medium':
            min = 1;
            max = 10;
            label = '1-10MB';
            break;
        case 'large':
            min = 10;
            max = 50;
            label = '10-50MB';
            break;
        case 'xlarge':
            min = 50;
            label = '> 50MB';
            break;
    }
    
    const files = chartData.files.filter(file => {
        const sizeMB = (file.size || 0) / (1024 * 1024);
        return sizeMB >= min && sizeMB < max;
    });
    
    let content = `
        <div style="margin-bottom: 1rem;">
            <h3>Files ${label} (${files.length})</h3>
            <p style="color: #64748b;">Encrypted files in this size range</p>
        </div>
    `;
    
    if (files.length === 0) {
        content += '<p style="text-align: center; color: #64748b; padding: 2rem;">No files in this size range</p>';
    } else {
        content += '<table class="detail-table"><thead><tr><th>Filename</th><th>Size</th><th>Algorithm</th><th>Encrypted</th></tr></thead><tbody>';
        
        files.forEach(file => {
            const sizeMB = ((file.size || 0) / (1024 * 1024)).toFixed(2);
            const timestamp = file.timestamp ? new Date(file.timestamp).toLocaleString() : 'N/A';
            
            content += `
                <tr>
                    <td><strong>${file.filename || 'N/A'}</strong></td>
                    <td>${sizeMB} MB</td>
                    <td><span class="badge badge-info">${file.algorithm || 'ML-KEM-768'}</span></td>
                    <td style="font-size: 12px;">${timestamp}</td>
                </tr>
            `;
        });
        
        content += '</tbody></table>';
    }
    
    showModal(`📊 File Size: ${label}`, content);
}

// Risk Level Drill-down
function showRiskDetails(level) {
    const scans = chartData.scans.filter(scan => scan.riskLevel === level);
    
    let content = `
        <div style="margin-bottom: 1rem;">
            <h3>${level} Risk Domains (${scans.length})</h3>
            <p style="color: #64748b;">Domains classified as ${level.toLowerCase()} risk</p>
        </div>
    `;
    
    if (scans.length === 0) {
        content += '<p style="text-align: center; color: #64748b; padding: 2rem;">No ' + level.toLowerCase() + ' risk domains found</p>';
    } else {
        content += '<table class="detail-table"><thead><tr><th>Domain</th><th>Risk Score</th><th>TLS Version</th><th>PQC</th><th>Issues</th></tr></thead><tbody>';
        
        scans.forEach(scan => {
            const pqcBadge = scan.isPQC ? 'badge-success' : 'badge-danger';
            const issues = [];
            
            if (!scan.isPQC) issues.push('No PQC');
            if (scan.protocol && (scan.protocol.includes('1.0') || scan.protocol.includes('1.1'))) {
                issues.push('Outdated TLS');
            }
            
            content += `
                <tr>
                    <td><strong>${scan.domain || 'N/A'}</strong></td>
                    <td><span class="badge badge-warning">${scan.riskScore || 0}</span></td>
                    <td>${scan.protocol || 'N/A'}</td>
                    <td><span class="badge ${pqcBadge}">${scan.isPQC ? 'Yes' : 'No'}</span></td>
                    <td style="font-size: 12px;">${issues.join(', ') || 'None'}</td>
                </tr>
            `;
        });
        
        content += '</tbody></table>';
    }
    
    showModal(`⚠️ ${level} Risk Details`, content);
}

// Add canvas click handlers for pie charts
function addCanvasClickHandler(canvasId, dataArray, showDetailsFunc) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;
    
    canvas.addEventListener('click', (e) => {
        const rect = canvas.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        // Get canvas center
        const centerX = canvas.width / 2;
        const centerY = canvas.height / 2;
        
        // Calculate angle
        const angle = Math.atan2(y - centerY, x - centerX);
        let degrees = angle * (180 / Math.PI) + 90;
        if (degrees < 0) degrees += 360;
        
        // Find which slice was clicked
        let currentAngle = 0;
        const total = dataArray.reduce((sum, item) => sum + item.value, 0);
        
        for (let i = 0; i < dataArray.length; i++) {
            const sliceAngle = (dataArray[i].value / total) * 360;
            if (degrees >= currentAngle && degrees < currentAngle + sliceAngle) {
                showDetailsFunc(dataArray[i].label);
                break;
            }
            currentAngle += sliceAngle;
        }
    });
    
    // Add hover tooltip
    canvas.addEventListener('mousemove', (e) => {
        const rect = canvas.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        const centerX = canvas.width / 2;
        const centerY = canvas.height / 2;
        const distance = Math.sqrt(Math.pow(x - centerX, 2) + Math.pow(y - centerY, 2));
        
        // Check if mouse is over the chart (within radius)
        if (distance < 120 && distance > 40) {
            const angle = Math.atan2(y - centerY, x - centerX);
            let degrees = angle * (180 / Math.PI) + 90;
            if (degrees < 0) degrees += 360;
            
            let currentAngle = 0;
            const total = dataArray.reduce((sum, item) => sum + item.value, 0);
            
            for (let i = 0; i < dataArray.length; i++) {
                const sliceAngle = (dataArray[i].value / total) * 360;
                if (degrees >= currentAngle && degrees < currentAngle + sliceAngle) {
                    const percentage = ((dataArray[i].value / total) * 100).toFixed(1);
                    showTooltip(e.clientX, e.clientY, `
                        <strong>${dataArray[i].label}</strong><br>
                        Count: ${dataArray[i].value}<br>
                        Percentage: ${percentage}%<br>
                        <em>Click for details</em>
                    `);
                    return;
                }
                currentAngle += sliceAngle;
            }
        }
        hideTooltip();
    });
    
    canvas.addEventListener('mouseleave', hideTooltip);
}

// Initialize interactive features when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeInteractiveCharts);
} else {
    initializeInteractiveCharts();
}

// Made with Bob
