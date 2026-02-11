// PQC File Encryptor - Frontend Application v2
const API_BASE = 'http://localhost:8080/api';

// Utility Functions
function formatBytes(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

function formatDate(timestamp) {
    return new Date(parseInt(timestamp)).toLocaleString();
}

// Tab Navigation
function showTab(tabName) {
    document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
    
    document.getElementById(tabName + '-tab').classList.add('active');
    event.target.classList.add('active');
    
    if (tabName === 'records') {
        loadRecords();
    } else if (tabName === 'dashboard') {
        loadDashboard();
    }
}

// File Encryption
async function encryptFile() {
    const fileInput = document.getElementById('fileInput');
    const kemAlgorithm = document.getElementById('kemAlgorithm').value;
    
    if (!fileInput.files[0]) {
        alert('Please select a file');
        return;
    }
    
    const formData = new FormData();
    formData.append('file', fileInput.files[0]);
    formData.append('kemAlgorithm', kemAlgorithm);
    
    try {
        document.getElementById('encryptBtn').disabled = true;
        document.getElementById('encryptBtn').textContent = 'Encrypting...';
        
        const response = await fetch(`${API_BASE}/encrypt`, {
            method: 'POST',
            body: formData
        });
        
        const result = await response.json();
        
        if (result.success) {
            alert(`File encrypted successfully!\nRecord ID: ${result.data.record_id}`);
            fileInput.value = '';
            showTab('records');
        } else {
            alert(`Encryption failed: ${result.error}`);
        }
    } catch (error) {
        alert(`Encryption error: ${error.message}`);
    } finally {
        document.getElementById('encryptBtn').disabled = false;
        document.getElementById('encryptBtn').textContent = 'Encrypt File';
    }
}

// File Decryption - FIXED VERSION
async function decryptFile(recordId) {
    if (!confirm('Decrypt this file?')) return;
    
    try {
        const response = await fetch(`${API_BASE}/decrypt`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ recordId: recordId })
        });
        
        const result = await response.json();
        console.log('Full decryption response:', result);
        
        if (result.success && result.data) {
            // Extract values from the nested data object
            const decryptedFile = result.data.decrypted_file;
            const decryptedSize = result.data.decrypted_size;
            
            console.log('Decrypted file:', decryptedFile);
            console.log('Decrypted size:', decryptedSize);
            
            alert(`File decrypted successfully!\nDecrypted file: ${decryptedFile}\nSize: ${formatBytes(decryptedSize)}`);
            loadRecords();
        } else {
            alert(`Decryption failed: ${result.error || 'Unknown error'}`);
        }
    } catch (error) {
        console.error('Decryption error:', error);
        alert(`Decryption error: ${error.message}`);
    }
}

// Load Records
async function loadRecords() {
    try {
        const response = await fetch(`${API_BASE}/records`);
        const result = await response.json();
        
        const container = document.getElementById('recordsList');
        
        if (result.success && result.data && result.data.length > 0) {
            container.innerHTML = result.data.map(record => createRecordCard(record)).join('');
        } else {
            container.innerHTML = '<p class="no-data">No encryption records found</p>';
        }
    } catch (error) {
        console.error('Error loading records:', error);
        document.getElementById('recordsList').innerHTML = '<p class="error">Error loading records</p>';
    }
}

// Create Record Card
function createRecordCard(data) {
    const recordId = data.record_id || data.id;
    const fileName = data.fileName || data.file_name || 'Unknown';
    const kemAlgorithm = data.kemAlgorithm || data.kem_algorithm || 'Unknown';
    const createdAt = data.created_at || data.createdAt || Date.now();
    
    // Handle both camelCase and snake_case for key sizes
    const kyberPublicKeySize = data.kyberPublicKeySize || data.public_key_size || 0;
    const kyberPrivateKeySize = data.kyberPrivateKeySize || data.private_key_size || 0;
    const kyberCiphertextSize = data.kyberCiphertextSize || data.ciphertext_size || 0;
    
    const metrics = {
        kyberPublicKeySize,
        kyberPrivateKeySize,
        kyberCiphertextSize,
        pqcTotalKeySize: kyberPublicKeySize + kyberPrivateKeySize + kyberCiphertextSize,
        classicalTotalKeySize: 32 + 32 + 32,
        pqcOverheadBytes: (kyberPublicKeySize + kyberPrivateKeySize + kyberCiphertextSize) - 96,
        pqcOverheadPercentage: data.pqcOverheadPercentage || data.pqc_overhead_percentage || 0
    };
    
    return `
        <div class="record-card">
            <div class="record-header">
                <h3>${fileName}</h3>
                <span class="record-id">ID: ${recordId}</span>
            </div>
            
            <div class="record-info">
                <div class="info-row">
                    <span class="label">Algorithm:</span>
                    <span class="value">${kemAlgorithm}</span>
                </div>
                <div class="info-row">
                    <span class="label">Created:</span>
                    <span class="value">${formatDate(createdAt)}</span>
                </div>
            </div>
            
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
            
            <button onclick="decryptFile('${recordId}')" class="btn btn-warning">Decrypt This File</button>
        </div>
    `;
}

// Load Dashboard
async function loadDashboard() {
    try {
        const response = await fetch(`${API_BASE}/dashboard`);
        const result = await response.json();
        
        if (result.success && result.data) {
            updateDashboardCharts(result.data);
        }
    } catch (error) {
        console.error('Error loading dashboard:', error);
    }
}

// Update Dashboard Charts
function updateDashboardCharts(data) {
    // Implementation for charts...
    console.log('Dashboard data:', data);
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    console.log('PQC File Encryptor v2 loaded');
    loadRecords();
});

// Made with Bob
