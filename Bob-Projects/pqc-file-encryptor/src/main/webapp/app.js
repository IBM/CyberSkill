// PQC File Encryptor - Frontend JavaScript

const API_BASE = '/api';
let uploadedFileName = null;
let keySizeChart = null;
let comparisonChart = null;
let sizeComparisonChart = null;
// Toast Notification System
const ToastService = {
    container: null,
    
    init() {
        // Create toast container if it doesn't exist
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.id = 'toast-container';
            this.container.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 10000;
                display: flex;
                flex-direction: column;
                gap: 10px;
                max-width: 400px;
            `;
            document.body.appendChild(this.container);
        }
    },
    
    show(message, type = 'info', duration = 5000) {
        this.init();
        
        const toast = document.createElement('div');
        toast.className = `toast toast-${type}`;
        
        const icons = {
            success: '✓',
            error: '✗',
            warning: '⚠',
            info: 'ℹ'
        };
        
        const colors = {
            success: '#10b981',
            error: '#ef4444',
            warning: '#f59e0b',
            info: '#3b82f6'
        };
        
        toast.style.cssText = `
            background: ${colors[type] || colors.info};
            color: white;
            padding: 16px 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.3s ease-out;
            cursor: pointer;
            transition: transform 0.2s, opacity 0.3s;
        `;
        
        toast.innerHTML = `
            <span style="font-size: 20px; font-weight: bold;">${icons[type] || icons.info}</span>
            <span style="flex: 1;">${message}</span>
            <span style="opacity: 0.7; font-size: 12px;">×</span>
        `;
        
        // Add hover effect
        toast.onmouseenter = () => toast.style.transform = 'translateX(-5px)';
        toast.onmouseleave = () => toast.style.transform = 'translateX(0)';
        
        // Click to dismiss
        toast.onclick = () => this.remove(toast);
        
        this.container.appendChild(toast);
        
        // Auto remove
        if (duration > 0) {
            setTimeout(() => this.remove(toast), duration);
        }
        
        return toast;
    },
    
    remove(toast) {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    },
    
    success(message, duration) {
        return this.show(message, 'success', duration);
    },
    
    error(message, duration) {
        return this.show(message, 'error', duration);
    },
    
    warning(message, duration) {
        return this.show(message, 'warning', duration);
    },
    
    info(message, duration) {
        return this.show(message, 'info', duration);
    }
};

// Add CSS animation
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
`;
document.head.appendChild(style);


// Tab Management
function showTab(tabName) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Remove active class from all buttons
    document.querySelectorAll('.tab-button').forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById(`${tabName}-tab`).classList.add('active');
    event.target.classList.add('active');
    
    // Load data for specific tabs
    if (tabName === 'records') {
        loadRecords();
    } else if (tabName === 'dashboard') {
        loadDashboard();
    } else if (tabName === 'comparison') {
        loadSizeComparison();
    }
}

// File Upload
async function uploadFile() {
    const fileInput = document.getElementById('fileInput');
    const statusDiv = document.getElementById('uploadStatus');
    
    if (!fileInput.files.length) {
        showStatus(statusDiv, 'Please select a file', 'error');
        return;
    }
    
    const formData = new FormData();
    formData.append('file', fileInput.files[0]);
    
    try {
        showStatus(statusDiv, 'Uploading...', 'info');
        
        const response = await fetch(`${API_BASE}/upload`, {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        
        if (result.success) {
            uploadedFileName = result.fileName;
            showStatus(statusDiv, `File uploaded: ${result.fileName} (${formatBytes(result.size)})`, 'success');
            ToastService.success(`File uploaded successfully: ${result.fileName}`);
            document.getElementById('encryptBtn').disabled = false;
        } else {
            showStatus(statusDiv, `Upload failed: ${result.error}`, 'error');
            ToastService.error(`Upload failed: ${result.error}`);
        }
    } catch (error) {
        showStatus(statusDiv, `Upload error: ${error.message}`, 'error');
        ToastService.error(`Upload error: ${error.message}`);
    }
}

// File Encryption
async function encryptFile() {
    if (!uploadedFileName) {
        ToastService.warning('Please upload a file first');
        return;
    }
    
    const kemAlgorithm = document.getElementById('kemAlgorithm').value;
    const aesKeySize = parseInt(document.getElementById('aesKeySize').value);
    const resultDiv = document.getElementById('encryptionResult');
    
    try {
        resultDiv.innerHTML = '<div class="loading">Encrypting file... This may take a moment.</div>';
        ToastService.info(`Starting encryption with ${kemAlgorithm} and AES-${aesKeySize}...`, 3000);
        
        const response = await fetch(`${API_BASE}/encrypt`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                fileName: uploadedFileName,
                kemAlgorithm: kemAlgorithm,
                aesKeySize: aesKeySize
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            displayEncryptionResult(result.data);
            ToastService.success(`File encrypted successfully! Record ID: ${result.data.record_id}`, 6000);
        } else {
            resultDiv.innerHTML = `<div class="error">Encryption failed: ${result.error}</div>`;
            ToastService.error(`Encryption failed: ${result.error}`);
        }
    } catch (error) {
        resultDiv.innerHTML = `<div class="error">Encryption error: ${error.message}</div>`;
        ToastService.error(`Encryption error: ${error.message}`);
    }
}

// Display Encryption Result
function displayEncryptionResult(data) {
    const resultDiv = document.getElementById('encryptionResult');
    const metrics = data.metrics || {};
    
    resultDiv.innerHTML = `
        <div class="success-message">
            <h3>✅ File Encrypted Successfully!</h3>
            <div class="result-details">
                <div class="detail-row">
                    <span class="label">Record ID:</span>
                    <span class="value">${data.id}</span>
                </div>
                <div class="detail-row">
                    <span class="label">Original File:</span>
                    <span class="value">${data.fileName}</span>
                </div>
                <div class="detail-row">
                    <span class="label">Encrypted File:</span>
                    <span class="value">${data.encryptedFilePath}</span>
                </div>
                <div class="detail-row">
                    <span class="label">Original Size:</span>
                    <span class="value">${formatBytes(data.originalSize)}</span>
                </div>
                <div class="detail-row">
                    <span class="label">Encrypted Size:</span>
                    <span class="value">${formatBytes(data.encryptedSize)}</span>
                </div>
                <div class="detail-row">
                    <span class="label">Encryption Algorithm:</span>
                    <span class="value">${data.encryptionAlgorithm}</span>
                </div>
                <div class="detail-row">
                    <span class="label">KEM Algorithm:</span>
                    <span class="value">${data.kemAlgorithm}</span>
                </div>
            </div>
            
            <div class="metrics-section">
                <h4>📊 Key Size Metrics</h4>
                <div class="metrics-grid">
                    <div class="metric-card">
                        <div class="metric-label">Kyber Public Key</div>
                        <div class="metric-value">${metrics.kyberPublicKeySize} bytes</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">Kyber Private Key</div>
                        <div class="metric-value">${metrics.kyberPrivateKeySize} bytes</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">Kyber Ciphertext</div>
                        <div class="metric-value">${metrics.kyberCiphertextSize} bytes</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">PQC Total</div>
                        <div class="metric-value">${metrics.pqcTotalKeySize} bytes</div>
                    </div>
                    <div class="metric-card">
                        <div class="metric-label">Classical Total</div>
                        <div class="metric-value">${metrics.classicalTotalKeySize} bytes</div>
                    </div>
                    <div class="metric-card highlight">
                        <div class="metric-label">PQC Overhead</div>
                        <div class="metric-value">${metrics.pqcOverheadBytes} bytes (+${metrics.pqcOverheadPercentage}%)</div>
                    </div>
                </div>
            </div>
            
            <button onclick="decryptFile(${data.id})" class="btn btn-warning">Decrypt This File</button>
        </div>
    `;
}

// File Decryption
async function decryptFile(recordId) {
    if (!confirm('Decrypt this file?')) return;
    
    try {
        const response = await fetch(`${API_BASE}/decrypt`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ recordId: recordId })
        });
        
        const result = await response.json();
        
        if (result.success) {
            // Debug: log the actual response structure
            console.log('Decryption response:', result);
            console.log('Result data:', result.data);
            
            // Backend returns snake_case fields: decrypted_file, decrypted_size
            const decryptedFile = result.data.decrypted_file || result.data.decryptedFile;
            const decryptedSize = result.data.decrypted_size || result.data.decryptedSize;
            
            console.log('Extracted values:', { decryptedFile, decryptedSize });
            
            alert(`File decrypted successfully!\nDecrypted file: ${decryptedFile}\nSize: ${formatBytes(decryptedSize)}`);
            loadRecords();
        } else {
            alert(`Decryption failed: ${result.error}`);
        }
    } catch (error) {
        alert(`Decryption error: ${error.message}`);
    }
}

// Load Encryption Records
async function loadRecords() {
    const listDiv = document.getElementById('recordsList');
    
    try {
        listDiv.innerHTML = '<div class="loading">Loading records...</div>';
        
        const response = await fetch(`${API_BASE}/records`);
        const result = await response.json();
        
        if (result.success && result.data.length > 0) {
            listDiv.innerHTML = result.data.map(record => `
                <div class="record-card">
                    <div class="record-header">
                        <h4>${record.fileName}</h4>
                        <span class="status-badge ${record.status}">${record.status}</span>
                    </div>
                    <div class="record-details">
                        <div class="detail-item">
                            <strong>ID:</strong> ${record.id}
                        </div>
                        <div class="detail-item">
                            <strong>Algorithm:</strong> ${record.kemAlgorithm} + ${record.encryptionAlgorithm}
                        </div>
                        <div class="detail-item">
                            <strong>Original Size:</strong> ${formatBytes(record.originalSize)}
                        </div>
                        <div class="detail-item">
                            <strong>Encrypted Size:</strong> ${formatBytes(record.encryptedSize)}
                        </div>
                        <div class="detail-item">
                            <strong>PQC Overhead:</strong> ${record.pqcOverheadBytes} bytes (+${record.pqcOverheadPercentage}%)
                        </div>
                        <div class="detail-item">
                            <strong>Encrypted:</strong> ${new Date(record.encryptionTimestamp).toLocaleString()}
                        </div>
                        ${record.decryptionTimestamp ? `
                        <div class="detail-item">
                            <strong>Decrypted:</strong> ${new Date(record.decryptionTimestamp).toLocaleString()}
                        </div>
                        ` : ''}
                    </div>
                    ${record.status === 'encrypted' ? `
                    <button onclick="decryptFile(${record.id})" class="btn btn-sm btn-warning">Decrypt</button>
                    ` : ''}
                </div>
            `).join('');
        } else {
            listDiv.innerHTML = '<div class="empty-state">No encryption records found. Encrypt a file to get started!</div>';
        }
    } catch (error) {
        listDiv.innerHTML = `<div class="error">Failed to load records: ${error.message}</div>`;
    }
}

// Load Dashboard
async function loadDashboard() {
    try {
        const response = await fetch(`${API_BASE}/dashboard`);
        const result = await response.json();
        
        if (result.success) {
            displayDashboard(result.data);
        }
    } catch (error) {
        console.error('Failed to load dashboard:', error);
    }
}

// Display Dashboard
function displayDashboard(data) {
    // Display summary stats
    const summaryDiv = document.getElementById('summaryStats');
    const summaries = data.summary.summaries || [];
    
    if (summaries.length > 0) {
        summaryDiv.innerHTML = summaries.map(s => `
            <div class="stat-card">
                <div class="stat-label">${s.kemAlgorithm} (${s.status})</div>
                <div class="stat-value">${s.totalFiles} files</div>
                <div class="stat-detail">Total Size: ${formatBytes(s.totalOriginalSize)}</div>
                <div class="stat-detail">Avg Overhead: ${s.avgPqcOverhead.toFixed(2)}%</div>
            </div>
        `).join('');
    } else {
        summaryDiv.innerHTML = '<div class="empty-state">No data available yet</div>';
    }
    
    // Create key size chart
    createKeySizeChart(data.keyStatistics);
    
    // Create comparison chart
    createComparisonChart(data.sizeComparison);
}

// Create Key Size Chart
function createKeySizeChart(keyStats) {
    const ctx = document.getElementById('keySizeChart');
    
    if (keySizeChart) {
        keySizeChart.destroy();
    }
    
    const pqcStats = keyStats.filter(s => s.algorithmType === 'PQC');
    const classicalStats = keyStats.filter(s => s.algorithmType === 'Classical');
    
    keySizeChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [...pqcStats.map(s => s.keyType), ...classicalStats.map(s => s.keyType)],
            datasets: [{
                label: 'Average Key Size (bytes)',
                data: [...pqcStats.map(s => s.averageSize), ...classicalStats.map(s => s.averageSize)],
                backgroundColor: [
                    ...pqcStats.map(() => 'rgba(75, 192, 192, 0.6)'),
                    ...classicalStats.map(() => 'rgba(255, 159, 64, 0.6)')
                ],
                borderColor: [
                    ...pqcStats.map(() => 'rgba(75, 192, 192, 1)'),
                    ...classicalStats.map(() => 'rgba(255, 159, 64, 1)')
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Size (bytes)'
                    }
                }
            },
            plugins: {
                legend: {
                    display: false
                }
            }
        }
    });
}

// Create Comparison Chart
function createComparisonChart(sizeComparison) {
    const ctx = document.getElementById('comparisonChart');
    
    if (comparisonChart) {
        comparisonChart.destroy();
    }
    
    comparisonChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: sizeComparison.map(s => s.method),
            datasets: [{
                label: 'Total Key Size (bytes)',
                data: sizeComparison.map(s => s.totalKeySize),
                backgroundColor: [
                    'rgba(255, 159, 64, 0.6)',
                    'rgba(75, 192, 192, 0.6)',
                    'rgba(75, 192, 192, 0.6)',
                    'rgba(75, 192, 192, 0.6)'
                ],
                borderColor: [
                    'rgba(255, 159, 64, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(75, 192, 192, 1)'
                ],
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Size (bytes)'
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'Classical vs Post-Quantum Key Sizes'
                }
            }
        }
    });
}

// Load Size Comparison
async function loadSizeComparison() {
    try {
        const response = await fetch(`${API_BASE}/size-comparison`);
        const result = await response.json();
        
        if (result.success) {
            createSizeComparisonChart(result.data);
        }
    } catch (error) {
        console.error('Failed to load size comparison:', error);
    }
}

// Create Size Comparison Chart
function createSizeComparisonChart(data) {
    const ctx = document.getElementById('sizeComparisonChart');
    
    if (sizeComparisonChart) {
        sizeComparisonChart.destroy();
    }
    
    sizeComparisonChart = new Chart(ctx, {
        type: 'horizontalBar',
        data: {
            labels: data.map(d => d.method),
            datasets: [{
                label: 'Total Key Size (bytes)',
                data: data.map(d => d.totalKeySize),
                backgroundColor: data.map((d, i) => 
                    i === 0 ? 'rgba(255, 159, 64, 0.6)' : 'rgba(75, 192, 192, 0.6)'
                ),
                borderColor: data.map((d, i) => 
                    i === 0 ? 'rgba(255, 159, 64, 1)' : 'rgba(75, 192, 192, 1)'
                ),
                borderWidth: 2
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: true,
            scales: {
                x: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Size (bytes)'
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: 'Key Size Comparison: Classical vs PQC',
                    font: {
                        size: 16
                    }
                },
                legend: {
                    display: false
                }
            }
        }
    });
}

// Utility Functions
function formatBytes(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

function showStatus(element, message, type) {
    element.className = `status-message ${type}`;
    element.textContent = message;
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    console.log('PQC File Encryptor initialized');
});

// Made with Bob
