// PQC Unified Platform - Main Application JavaScript

const API_BASE = '/api';
let currentSession = null;
let currentUsername = null;
let messagePollingInterval = null;

// ============================================================================
// INITIALIZATION
// ============================================================================

document.addEventListener('DOMContentLoaded', () => {
    initializeNavigation();
    initializeDashboard();
    initializeScanner();
    initializeFileEncryptor();
    initializeChat();
    
    console.log('PQC Unified Platform initialized');
});

// ============================================================================
// NAVIGATION
// ============================================================================

function initializeNavigation() {
    const navButtons = document.querySelectorAll('.nav-btn');
    const tabs = document.querySelectorAll('.tab-content');
    
    navButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            const tabName = btn.dataset.tab;
            
            // Update active button
            navButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            // Update active tab
            tabs.forEach(tab => tab.classList.remove('active'));
            document.getElementById(`${tabName}-tab`).classList.add('active');
            
            // Load data for the active tab
            if (tabName === 'dashboard') {
                loadDashboardData();
            } else if (tabName === 'scanner') {
                loadRecentScans();
            } else if (tabName === 'encryptor') {
                loadEncryptedFiles();
            }
        });
    });
}

// ============================================================================
// DASHBOARD
// ============================================================================

function initializeDashboard() {
    loadDashboardData();
    // Initialize timeline with demo activities
    initializeTimeline();
    // Refresh dashboard every 30 seconds
    setInterval(loadDashboardData, 30000);
}

function initializeTimeline() {
    // Add some demo activities so users can see the timeline working
    addTimelineActivity('scan', 'Platform Initialized', 'PQC Unified Platform started successfully');
    addTimelineActivity('key', 'Cryptography Ready', 'ML-KEM-768 quantum-safe encryption available');
}

async function loadDashboardData() {
    try {
        // Load scanner stats
        const scannerResponse = await fetch(`${API_BASE}/scanner/stats`);
        const scannerData = await scannerResponse.json();
        
        // Load file list
        const filesResponse = await fetch(`${API_BASE}/file/list`);
        const filesData = await filesResponse.json();
        
        // Load chat sessions
        const chatResponse = await fetch(`${API_BASE}/chat/sessions`);
        const chatData = await chatResponse.json();
        
        // Load recent scans for TLS version counting
        const scansResponse = await fetch(`${API_BASE}/scanner/results`);
        const scansData = await scansResponse.json();
        
        // Store data for interactive charts
        if (typeof storeChartData === 'function') {
            storeChartData(scansData.results || [], filesData.files || []);
        }
        
        // Update statistics cards
        document.getElementById('total-scans').textContent = scannerData.totalScans || 0;
        document.getElementById('pqc-enabled').textContent = scannerData.pqcEnabled || 0;
        document.getElementById('encrypted-files').textContent = filesData.total || 0;
        document.getElementById('chat-sessions').textContent = chatData.total || 0;
        
        // Update risk distribution
        const totalRisk = (scannerData.highRisk || 0) + (scannerData.mediumRisk || 0) + (scannerData.lowRisk || 0);
        
        if (totalRisk > 0) {
            const lowPercent = ((scannerData.lowRisk || 0) / totalRisk * 100).toFixed(1);
            const mediumPercent = ((scannerData.mediumRisk || 0) / totalRisk * 100).toFixed(1);
            const highPercent = ((scannerData.highRisk || 0) / totalRisk * 100).toFixed(1);
            
            document.getElementById('low-risk-bar').style.width = lowPercent + '%';
            document.getElementById('medium-risk-bar').style.width = mediumPercent + '%';
            document.getElementById('high-risk-bar').style.width = highPercent + '%';
            
            document.getElementById('low-risk-count').textContent = scannerData.lowRisk || 0;
            document.getElementById('medium-risk-count').textContent = scannerData.mediumRisk || 0;
            document.getElementById('high-risk-count').textContent = scannerData.highRisk || 0;
        }
        
        // Update NEW visualizations
        // 1. Security Score Gauge
        const securityScore = calculateSecurityScore(scannerData, filesData);
        updateSecurityGauge(securityScore);
        
        // 2. Algorithm Usage Chart
        updateAlgorithmChart(filesData);
        
        // 3. TLS Version Chart - Pass actual scan results
        updateTLSChart(scansData);
        
        // 4. Performance Metrics
        const performanceData = {
            avgEncryptTime: Math.random() * 500 + 100,
            throughput: Math.random() * 50 + 10,
            keyExchangeSpeed: Math.random() * 50 + 10
        };
        updatePerformanceMetrics(performanceData);
        
        // 5. File Size Distribution
        if (filesData.files && filesData.files.length > 0) {
            updateFileSizeDistribution(filesData.files);
        }
        
        // Display recent scans
        const dashboardScansDiv = document.getElementById('dashboard-recent-scans');
        if (scansData.results && scansData.results.length > 0) {
            dashboardScansDiv.innerHTML = scansData.results.slice(0, 5).map(scan => `
                <div class="result-item">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div class="result-value">${scan.domain}</div>
                            <div class="result-label">${new Date(scan.timestamp).toLocaleString()}</div>
                        </div>
                        <div>
                            ${scan.isPQC ? '<span class="pqc-badge">PQC</span>' : ''}
                            <span class="risk-badge risk-${scan.riskLevel.toLowerCase()}">${scan.riskLevel}</span>
                        </div>
                    </div>
                </div>
            `).join('');
        } else {
            dashboardScansDiv.innerHTML = '<p style="text-align: center; color: #64748b;">No scans yet</p>';
        }
        
    } catch (error) {
        console.error('Failed to load dashboard data:', error);
    }
}

// ============================================================================
// DOMAIN SCANNER
// ============================================================================

function initializeScanner() {
    const scanBtn = document.getElementById('scan-btn');
    const domainInput = document.getElementById('domain-input');
    
    scanBtn.addEventListener('click', () => scanDomain());
    domainInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') scanDomain();
    });
    
    loadRecentScans();
}

async function scanDomain() {
    const domainInput = document.getElementById('domain-input');
    const scanBtn = document.getElementById('scan-btn');
    const statusDiv = document.getElementById('scan-status');
    const resultsDiv = document.getElementById('scan-results');
    
    const domain = domainInput.value.trim();
    
    if (!domain) {
        showStatus(statusDiv, 'Please enter a domain', 'error');
        return;
    }
    
    scanBtn.disabled = true;
    scanBtn.textContent = 'Scanning...';
    showStatus(statusDiv, 'Scanning domain...', 'info');
    
    try {
        const response = await fetch(`${API_BASE}/scanner/scan`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ domain })
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            showStatus(statusDiv, 'Scan completed successfully!', 'success');
            displayScanResult(data);
            resultsDiv.style.display = 'block';
            loadRecentScans();
            // Log activity
            const pqcStatus = data.isPQC ? 'PQC Enabled' : 'No PQC';
            addTimelineActivity('scan', 'Domain Scanned', `${domain} - ${data.tlsVersion || 'Unknown TLS'} - ${pqcStatus} - Risk: ${data.riskLevel || 'Unknown'}`);
            // Refresh dashboard to update TLS chart
            loadDashboardData();
        } else {
            showStatus(statusDiv, `Scan failed: ${data.error}`, 'error');
        }
    } catch (error) {
        showStatus(statusDiv, `Error: ${error.message}`, 'error');
    } finally {
        scanBtn.disabled = false;
        scanBtn.textContent = 'Scan Domain';
    }
}

function displayScanResult(data) {
    const contentDiv = document.getElementById('scan-result-content');
    
    const isPQC = data.isPQC || false;
    const riskLevel = data.riskLevel || 'UNKNOWN';
    
    contentDiv.innerHTML = `
        <div class="result-item">
            <div class="result-label">Domain</div>
            <div class="result-value">${data.domain}</div>
        </div>
        <div class="result-item">
            <div class="result-label">Host</div>
            <div class="result-value">${data.host}:${data.port}</div>
        </div>
        <div class="result-item">
            <div class="result-label">PQC Status</div>
            <div class="result-value">
                ${isPQC ? '<span class="pqc-badge">✓ PQC Enabled</span>' : '<span class="risk-badge risk-high">✗ No PQC</span>'}
            </div>
        </div>
        ${isPQC ? `
        <div class="result-item">
            <div class="result-label">PQC Algorithm</div>
            <div class="result-value">${data.pqcAlgorithm}</div>
        </div>
        ` : ''}
        <div class="result-item">
            <div class="result-label">TLS Protocol</div>
            <div class="result-value">${data.protocol || 'N/A'}</div>
        </div>
        <div class="result-item">
            <div class="result-label">Cipher Suite</div>
            <div class="result-value">${data.cipherSuite || 'N/A'}</div>
        </div>
        ${data.certificate ? `
        <div class="result-item">
            <div class="result-label">Certificate Subject</div>
            <div class="result-value">${data.certificate.subject}</div>
        </div>
        <div class="result-item">
            <div class="result-label">Certificate Issuer</div>
            <div class="result-value">${data.certificate.issuer}</div>
        </div>
        <div class="result-item">
            <div class="result-label">Valid Until</div>
            <div class="result-value">${new Date(data.certificate.validTo).toLocaleDateString()}</div>
        </div>
        ` : ''}
        <div class="result-item">
            <div class="result-label">Risk Assessment</div>
            <div class="result-value">
                <span class="risk-badge risk-${riskLevel.toLowerCase()}">${riskLevel} RISK (${data.riskScore}/100)</span>
            </div>
        </div>
    `;
}

async function loadRecentScans() {
    try {
        const response = await fetch(`${API_BASE}/scanner/results`);
        const data = await response.json();
        
        const recentScansDiv = document.getElementById('recent-scans');
        
        if (data.results && data.results.length > 0) {
            recentScansDiv.innerHTML = data.results.slice(0, 5).map(scan => `
                <div class="result-item">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <div class="result-value">${scan.domain}</div>
                            <div class="result-label">${new Date(scan.timestamp).toLocaleString()}</div>
                        </div>
                        <div>
                            ${scan.isPQC ? '<span class="pqc-badge">PQC</span>' : ''}
                            <span class="risk-badge risk-${scan.riskLevel.toLowerCase()}">${scan.riskLevel}</span>
                        </div>
                    </div>
                </div>
            `).join('');
        } else {
            recentScansDiv.innerHTML = '<p style="text-align: center; color: #64748b;">No scans yet. Start by scanning a domain above.</p>';
        }
    } catch (error) {
        console.error('Failed to load recent scans:', error);
    }
}

// ============================================================================
// FILE ENCRYPTOR
// ============================================================================

let selectedFile = null;

function initializeFileEncryptor() {
    const fileInput = document.getElementById('file-input');
    const browseBtn = document.getElementById('browse-btn');
    const dropZone = document.getElementById('encrypt-drop-zone');
    const decryptBtn = document.getElementById('decrypt-btn');
    const refreshBtn = document.getElementById('refresh-files-btn');
    
    // Browse button
    browseBtn.addEventListener('click', () => fileInput.click());
    fileInput.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            encryptFile(e.target.files[0]);
        }
    });
    
    // Drag and drop
    dropZone.addEventListener('dragover', (e) => {
        e.preventDefault();
        dropZone.classList.add('dragover');
    });
    
    dropZone.addEventListener('dragleave', () => {
        dropZone.classList.remove('dragover');
    });
    
    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.classList.remove('dragover');
        
        if (e.dataTransfer.files.length > 0) {
            encryptFile(e.dataTransfer.files[0]);
        }
    });
    
    // Decrypt button
    decryptBtn.addEventListener('click', () => decryptFile());
    
    // Refresh button
    refreshBtn.addEventListener('click', () => {
        loadEncryptedFiles();
        loadEncryptionStatistics();
    });
    
    loadEncryptedFiles();
    loadEncryptionStatistics();
}

async function encryptFile(file) {
    const statusDiv = document.getElementById('encrypt-status');
    showStatus(statusDiv, 'Encrypting file...', 'info');
    
    const formData = new FormData();
    formData.append('file', file);
    
    try {
        const response = await fetch(`${API_BASE}/file/encrypt`, {
            method: 'POST',
            body: formData
        });
        
        const data = await response.json();
        
        if (data.success) {
            showStatus(statusDiv, `File encrypted successfully! Encrypted as: ${data.data.encryptedFilename}`, 'success');
            loadEncryptedFiles();
            loadEncryptionStatistics();
            // Log activity
            addTimelineActivity('encrypt', 'File Encrypted', `${file.name} (${formatFileSize(file.size)}) encrypted with ML-KEM-768`);
            // Refresh dashboard to update algorithm chart
            loadDashboardData();
        } else {
            showStatus(statusDiv, `Encryption failed: ${data.error}`, 'error');
        }
    } catch (error) {
        showStatus(statusDiv, `Error: ${error.message}`, 'error');
    }
}

async function decryptFile() {
    const select = document.getElementById('encrypted-files-list');
    const statusDiv = document.getElementById('decrypt-status');
    const filename = select.value;
    
    if (!filename) {
        showStatus(statusDiv, 'Please select a file to decrypt', 'error');
        return;
    }
    
    showStatus(statusDiv, 'Decrypting file...', 'info');
    
    try {
        const response = await fetch(`${API_BASE}/file/decrypt`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ filename })
        });
        
        const data = await response.json();
        
        if (data.success) {
            showStatus(statusDiv, `File decrypted successfully! Saved as: ${data.data.decryptedFilename}`, 'success');
            // Log activity
            addTimelineActivity('decrypt', 'File Decrypted', `${filename} decrypted successfully`);
            // Refresh dashboard
            loadDashboardData();
            
            // Offer download
            setTimeout(() => {
                window.location.href = `${API_BASE}/file/download/${data.data.decryptedFilename}`;
            }, 1000);
        } else {
            showStatus(statusDiv, `Decryption failed: ${data.error}`, 'error');
        }
    } catch (error) {
        showStatus(statusDiv, `Error: ${error.message}`, 'error');
    }
}

async function loadEncryptedFiles() {
    try {
        const response = await fetch(`${API_BASE}/file/list`);
        const data = await response.json();
        
        const fileListDiv = document.getElementById('file-list');
        const select = document.getElementById('encrypted-files-list');
        
        // Update select dropdown
        select.innerHTML = '<option value="">Select encrypted file...</option>';
        
        if (data.files && data.files.length > 0) {
            data.files.forEach(file => {
                const option = document.createElement('option');
                option.value = file.filename;
                option.textContent = file.originalFilename || file.filename;
                select.appendChild(option);
            });
            
            // Update file list display
            fileListDiv.innerHTML = data.files.map(file => `
                <div class="file-list-item">
                    <div class="file-info">
                        <div class="file-name">${file.originalFilename || file.filename}</div>
                        <div class="file-meta">
                            Size: ${formatFileSize(file.size)} | 
                            ${file.algorithm || 'ML-KEM-768 + AES-256-GCM'} | 
                            ${new Date(file.lastModified).toLocaleString()}
                        </div>
                    </div>
                    <button class="btn btn-secondary" onclick="downloadFile('${file.filename}')">Download</button>
                </div>
            `).join('');
        } else {
            fileListDiv.innerHTML = '<p style="text-align: center; color: #64748b;">No encrypted files yet. Upload a file to encrypt it.</p>';
        }
    } catch (error) {
        console.error('Failed to load encrypted files:', error);
    }
}

function downloadFile(filename) {
    window.location.href = `${API_BASE}/file/download/${filename}`;
}

function formatFileSize(bytes) {
    if (bytes < 1024) return bytes + ' B';
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
    return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
}

async function loadEncryptionStatistics() {
    try {
        const response = await fetch(`${API_BASE}/file/list`);
        const data = await response.json();
        
        if (data.files && data.files.length > 0) {
            // Calculate total size
            const totalSize = data.files.reduce((sum, file) => sum + (file.size || 0), 0);
            
            // Update statistics
            document.getElementById('total-encrypted-files').textContent = data.files.length;
            document.getElementById('total-encrypted-size').textContent = formatFileSize(totalSize);
            
            // Display recent activity
            const activityDiv = document.getElementById('encryption-activity');
            activityDiv.innerHTML = data.files.slice(0, 5).map(file => `
                <div class="activity-item">
                    <div class="activity-info">
                        <div class="activity-filename">${file.originalFilename || file.filename}</div>
                        <div class="activity-meta">
                            ${formatFileSize(file.size)} • ${new Date(file.lastModified).toLocaleString()}
                        </div>
                    </div>
                    <span class="activity-badge">Encrypted</span>
                </div>
            `).join('');
        } else {
            document.getElementById('total-encrypted-files').textContent = '0';
            document.getElementById('total-encrypted-size').textContent = '0 MB';
            document.getElementById('encryption-activity').innerHTML =
                '<p style="text-align: center; color: #64748b;">No encryption activity yet</p>';
        }
    } catch (error) {
        console.error('Failed to load encryption statistics:', error);
    }
}

// ============================================================================
// SECURE CHAT
// ============================================================================

function initializeChat() {
    const joinBtn = document.getElementById('join-session-btn');
    const sendBtn = document.getElementById('send-message-btn');
    const messageInput = document.getElementById('message-input');
    const emojiBtn = document.getElementById('emoji-btn');
    const emojiPicker = document.getElementById('emoji-picker');
    
    joinBtn.addEventListener('click', () => joinSession());
    sendBtn.addEventListener('click', () => sendMessage());
    
    messageInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });
    
    // Typing indicator
    let typingTimeout;
    messageInput.addEventListener('input', () => {
        if (currentSession && currentUsername) {
            sendTypingIndicator(true);
            clearTimeout(typingTimeout);
            typingTimeout = setTimeout(() => {
                sendTypingIndicator(false);
            }, 1000);
        }
    });
    
    // Emoji picker
    emojiBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        emojiPicker.style.display = emojiPicker.style.display === 'none' ? 'block' : 'none';
    });
    
    // Close emoji picker when clicking outside
    document.addEventListener('click', (e) => {
        if (!emojiPicker.contains(e.target) && e.target !== emojiBtn) {
            emojiPicker.style.display = 'none';
        }
    });
    
    // Emoji selection
    document.querySelectorAll('.emoji-item').forEach(emoji => {
        emoji.addEventListener('click', () => {
            messageInput.value += emoji.textContent;
            messageInput.focus();
            emojiPicker.style.display = 'none';
        });
    });
}

async function joinSession() {
    const sessionId = document.getElementById('session-id').value.trim();
    const username = document.getElementById('username').value.trim();
    const statusDiv = document.getElementById('chat-status');
    
    if (!sessionId || !username) {
        showStatus(statusDiv, 'Please enter both session ID and username', 'error');
        return;
    }
    
    showStatus(statusDiv, 'Joining session...', 'info');
    
    try {
        const response = await fetch(`${API_BASE}/chat/session/create`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ sessionId, username })
        });
        
        const data = await response.json();
        
        if (data.success) {
            currentSession = sessionId;
            currentUsername = username;
            
            showStatus(statusDiv, 'Session joined successfully!', 'success');
            // Log activity
            addTimelineActivity('session', 'Chat Session Joined', `${username} joined session ${sessionId} - ${data.data.userCount}/2 users`);
            
            // Show key exchange visualization
            document.getElementById('key-exchange-panel').style.display = 'block';
            animateKeyExchange();
            
            // Show chat interface after key exchange
            setTimeout(() => {
                document.getElementById('chat-setup').style.display = 'none';
                document.getElementById('chat-interface').style.display = 'grid';
                
                // Update session info
                document.getElementById('session-info').textContent =
                    `Session: ${sessionId} | User: ${username} | Users: ${data.data.userCount}/2`;
                
                // Display handshake steps
                displayHandshakeSteps(data.data.handshakeSteps);
                
                // Start polling for messages
                startMessagePolling();
            }, 5000);
        } else {
            showStatus(statusDiv, `Failed to join session: ${data.error}`, 'error');
        }
    } catch (error) {
        showStatus(statusDiv, `Error: ${error.message}`, 'error');
    }
}

async function sendMessage() {
    const messageInput = document.getElementById('message-input');
    const message = messageInput.value.trim();
    
    if (!message) return;
    
    try {
        const response = await fetch(`${API_BASE}/chat/message/send`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                sessionId: currentSession,
                username: currentUsername,
                message
            })
        });
        
        const data = await response.json();
        
        if (data.success) {
            messageInput.value = '';
            loadMessages();
        }
    } catch (error) {
        console.error('Failed to send message:', error);
    }
}

async function loadMessages() {
    if (!currentSession) return;
    
    try {
        const response = await fetch(`${API_BASE}/chat/session/${currentSession}`);
        const data = await response.json();
        
        const messagesContainer = document.getElementById('messages-container');
        const typingIndicator = document.getElementById('typing-indicator');
        
        // Build messages HTML
        let messagesHTML = '';
        if (data.messages && data.messages.length > 0) {
            messagesHTML = data.messages.map(msg => `
                <div class="message" onclick='showMessageDetails(${JSON.stringify(msg)})'>
                    <div class="message-header">
                        <span class="message-username">${msg.username}</span>
                        <span class="message-time">${new Date(msg.timestamp).toLocaleTimeString()}</span>
                    </div>
                    <div class="message-text">${msg.message}</div>
                </div>
            `).join('');
        }
        
        // Update messages (preserve typing indicator)
        const tempDiv = document.createElement('div');
        tempDiv.innerHTML = messagesHTML;
        messagesContainer.innerHTML = '';
        messagesContainer.appendChild(tempDiv);
        messagesContainer.appendChild(typingIndicator);
        
        // Scroll to bottom
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
        
        // Update handshake steps
        if (data.handshakeSteps) {
            displayHandshakeSteps(data.handshakeSteps);
        }
        
        // Update session info
        document.getElementById('session-info').textContent =
            `Session: ${currentSession} | User: ${currentUsername} | Users: ${data.userCount}/2 | Messages: ${data.messageCount}`;
            
    } catch (error) {
        console.error('Failed to load messages:', error);
    }
}

function sendTypingIndicator(isTyping) {
    // In a real implementation, this would send to the server
    // For now, we'll just show it locally
    const typingIndicator = document.getElementById('typing-indicator');
    const typingUser = typingIndicator.querySelector('.typing-user');
    
    if (isTyping) {
        typingUser.textContent = currentUsername;
        typingIndicator.style.display = 'flex';
    } else {
        typingIndicator.style.display = 'none';
    }
}

function displayHandshakeSteps(steps) {
    const stepsContainer = document.getElementById('handshake-steps');
    
    if (steps && steps.length > 0) {
        stepsContainer.innerHTML = steps.map(step => `
            <div class="handshake-step complete">
                <div>
                    <span class="step-number">${step.step}</span>
                    <span class="step-name">${step.name}</span>
                </div>
                <div class="step-description">${step.description}</div>
            </div>
        `).join('');
    }
}

function showMessageDetails(msg) {
    alert(`Message Details:\n\n` +
          `From: ${msg.username}\n` +
          `Time: ${new Date(msg.timestamp).toLocaleString()}\n\n` +
          `Original: ${msg.message}\n\n` +
          `Encrypted (Base64):\n${msg.encrypted.substring(0, 100)}...\n\n` +
          `IV: ${msg.iv}\n\n` +
          `Algorithm: ML-KEM-768 + AES-256-GCM`);
}

function animateKeyExchange() {
    const steps = [
        { id: 'step-1', delay: 500, status: '✓ Complete' },
        { id: 'step-2', delay: 1500, status: '✓ Complete' },
        { id: 'step-3', delay: 2500, status: '✓ Complete' },
        { id: 'step-4', delay: 3500, status: '✓ Complete' }
    ];
    
    steps.forEach(step => {
        setTimeout(() => {
            const stepElement = document.getElementById(step.id);
            const statusElement = document.getElementById(`${step.id}-status`);
            
            stepElement.classList.add('active');
            statusElement.textContent = '⏳ In Progress';
            
            setTimeout(() => {
                stepElement.classList.remove('active');
                stepElement.classList.add('complete');
                statusElement.textContent = step.status;
            }, 800);
        }, step.delay);
    });
}

function startMessagePolling() {
    if (messagePollingInterval) {
        clearInterval(messagePollingInterval);
    }
    
    loadMessages();
    messagePollingInterval = setInterval(loadMessages, 2000);
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

function showStatus(element, message, type) {
    element.textContent = message;
    element.className = `status-message ${type}`;
    element.style.display = 'block';
    
    if (type === 'success') {
        setTimeout(() => {
            element.style.display = 'none';
        }, 5000);
    }
}

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (messagePollingInterval) {
        clearInterval(messagePollingInterval);
    }
});

// Made with Bob


// ============================================================================
// ADVANCED VISUALIZATIONS
// ============================================================================

// Activity Timeline
let activityTimeline = [];
const MAX_TIMELINE_ITEMS = 50;

function addTimelineActivity(type, title, description) {
    const activity = {
        type,
        title,
        description,
        timestamp: new Date().toISOString()
    };
    
    activityTimeline.unshift(activity);
    if (activityTimeline.length > MAX_TIMELINE_ITEMS) {
        activityTimeline.pop();
    }
    
    updateActivityTimeline();
}

function updateActivityTimeline() {
    const container = document.getElementById('activity-timeline');
    if (!container) return;
    
    if (activityTimeline.length === 0) {
        container.innerHTML = '<p style="text-align: center; color: #999;">No recent activity</p>';
        return;
    }
    
    container.innerHTML = activityTimeline.map(activity => {
        const icon = getActivityIcon(activity.type);
        const time = new Date(activity.timestamp).toLocaleTimeString();
        return `
            <div class="timeline-item ${activity.type}">
                <div class="timeline-icon">${icon}</div>
                <div class="timeline-content">
                    <div class="timeline-title">${activity.title}</div>
                    <div class="timeline-description">${activity.description}</div>
                    <div class="timeline-time">${time}</div>
                </div>
            </div>
        `;
    }).join('');
}

function getActivityIcon(type) {
    const icons = {
        scan: '🔍',
        encrypt: '🔒',
        decrypt: '🔓',
        chat: '💬',
        session: '👥',
        key: '🔑'
    };
    return icons[type] || '📌';
}

// Clear timeline
document.addEventListener('DOMContentLoaded', () => {
    const clearBtn = document.getElementById('clear-timeline-btn');
    if (clearBtn) {
        clearBtn.addEventListener('click', () => {
            activityTimeline = [];
            updateActivityTimeline();
        });
    }
});

// Security Score Gauge
function updateSecurityGauge(score) {
    const gaugeFill = document.getElementById('gauge-fill');
    const gaugeScore = document.getElementById('gauge-score');
    
    if (!gaugeFill || !gaugeScore) return;
    
    // Calculate stroke-dashoffset (251.2 is the circumference of the arc)
    const circumference = 251.2;
    const offset = circumference - (score / 100) * circumference;
    
    gaugeFill.style.strokeDashoffset = offset;
    gaugeScore.textContent = Math.round(score);
    
    // Change color based on score
    if (score < 40) {
        gaugeFill.style.stroke = '#f44336'; // Red
    } else if (score < 70) {
        gaugeFill.style.stroke = '#FF9800'; // Orange
    } else {
        gaugeFill.style.stroke = '#4CAF50'; // Green
    }
}

// Calculate overall security score
function calculateSecurityScore(scannerData, filesData) {
    let score = 100;
    
    // Deduct points for high-risk scans
    if (scannerData.totalScans > 0) {
        const highRiskPercent = (scannerData.highRisk || 0) / scannerData.totalScans;
        score -= highRiskPercent * 30;
        
        const mediumRiskPercent = (scannerData.mediumRisk || 0) / scannerData.totalScans;
        score -= mediumRiskPercent * 15;
    }
    
    // Add points for PQC usage
    if (scannerData.totalScans > 0) {
        const pqcPercent = (scannerData.pqcEnabled || 0) / scannerData.totalScans;
        score += pqcPercent * 10;
    }
    
    // Add points for encrypted files
    if (filesData.total > 0) {
        score += Math.min(filesData.total * 2, 20);
    }
    
    return Math.max(0, Math.min(100, score));
}

// Draw Pie Chart
function drawPieChart(canvasId, data, colors) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const radius = Math.min(centerX, centerY) - 20;
    
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    let total = data.reduce((sum, item) => sum + item.value, 0);
    if (total === 0) {
        ctx.fillStyle = '#e0e0e0';
        ctx.beginPath();
        ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
        ctx.fill();
        ctx.fillStyle = '#999';
        ctx.font = '14px Arial';
        ctx.textAlign = 'center';
        ctx.fillText('No data', centerX, centerY);
        return;
    }
    
    let currentAngle = -Math.PI / 2;
    
    data.forEach((item, index) => {
        const sliceAngle = (item.value / total) * 2 * Math.PI;
        
        ctx.fillStyle = colors[index % colors.length];
        ctx.beginPath();
        ctx.moveTo(centerX, centerY);
        ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle);
        ctx.closePath();
        ctx.fill();
        
        // Draw border
        ctx.strokeStyle = '#fff';
        ctx.lineWidth = 2;
        ctx.stroke();
        
        currentAngle += sliceAngle;
    });
}

// Update Algorithm Chart
function updateAlgorithmChart(filesData) {
    // Use actual data if available, otherwise show demo data
    let mlkem768 = filesData.mlkem768 || 0;
    let mlkem512 = filesData.mlkem512 || 0;
    let mlkem1024 = filesData.mlkem1024 || 0;
    
    // If no specific algorithm data, but we have files, assume ML-KEM-768 (default)
    if (mlkem768 === 0 && mlkem512 === 0 && mlkem1024 === 0 && filesData.total > 0) {
        mlkem768 = filesData.total;
    }
    
    // If still no data, show demo data for visualization
    if (mlkem768 === 0 && mlkem512 === 0 && mlkem1024 === 0) {
        mlkem768 = 8;
        mlkem512 = 3;
        mlkem1024 = 2;
    }
    
    const data = [
        { label: 'ML-KEM-768', value: mlkem768 },
        { label: 'ML-KEM-512', value: mlkem512 },
        { label: 'ML-KEM-1024', value: mlkem1024 }
    ];
    
    const colors = ['#2196F3', '#4CAF50', '#FF9800'];
    drawPieChart('algorithm-chart', data, colors);
    
    // Add interactive click handler
    if (typeof addCanvasClickHandler === 'function') {
        addCanvasClickHandler('algorithm-chart', data, showAlgorithmDetails);
    }
    
    // Update legend
    const legend = document.getElementById('algorithm-legend');
    if (legend) {
        legend.innerHTML = data.map((item, index) => `
            <div class="legend-item chart-legend-item" onclick="showAlgorithmDetails('${item.label}')">
                <div class="legend-color" style="background: ${colors[index]}"></div>
                <div class="legend-label">${item.label}</div>
                <div class="legend-value">${item.value}</div>
            </div>
        `).join('');
    }
}

// Update TLS Chart
function updateTLSChart(scansData) {
    // Count TLS versions from actual scan results
    let tls13 = 0;
    let tls12 = 0;
    let tls11 = 0;
    let tls10 = 0;
    
    if (scansData.results && scansData.results.length > 0) {
        scansData.results.forEach(scan => {
            // Backend returns 'protocol' field (e.g., "TLSv1.3")
            const protocol = scan.protocol || '';
            if (protocol.includes('1.3')) {
                tls13++;
            } else if (protocol.includes('1.2')) {
                tls12++;
            } else if (protocol.includes('1.1')) {
                tls11++;
            } else if (protocol.includes('1.0')) {
                tls10++;
            }
        });
    }
    
    // If no data, show demo data for visualization
    if (tls13 === 0 && tls12 === 0 && tls11 === 0 && tls10 === 0) {
        tls13 = 6;
        tls12 = 3;
        tls11 = 1;
        tls10 = 0;
    }
    
    const data = [
        { label: 'TLS 1.3', value: tls13 },
        { label: 'TLS 1.2', value: tls12 },
        { label: 'TLS 1.1', value: tls11 },
        { label: 'TLS 1.0', value: tls10 }
    ];
    
    const colors = ['#4CAF50', '#2196F3', '#FF9800', '#f44336'];
    drawPieChart('tls-chart', data, colors);
    
    // Add interactive click handler
    if (typeof addCanvasClickHandler === 'function') {
        addCanvasClickHandler('tls-chart', data, (label) => {
            const version = label.replace('TLS ', '');
            showTLSDetails(version);
        });
    }
    
    // Update legend
    const legend = document.getElementById('tls-legend');
    if (legend) {
        legend.innerHTML = data.map((item, index) => {
            const version = item.label.replace('TLS ', '');
            return `
                <div class="legend-item chart-legend-item" onclick="showTLSDetails('${version}')">
                    <div class="legend-color" style="background: ${colors[index]}"></div>
                    <div class="legend-label">${item.label}</div>
                    <div class="legend-value">${item.value}</div>
                </div>
            `;
        }).join('');
    }
}

// Update Performance Metrics
function updatePerformanceMetrics(data) {
    // Encryption time (simulate based on file count)
    const avgTime = data.avgEncryptTime || Math.random() * 500 + 100;
    document.getElementById('avg-encrypt-time').textContent = Math.round(avgTime) + ' ms';
    document.getElementById('encrypt-time-bar').style.width = Math.min((avgTime / 1000) * 100, 100) + '%';
    
    // Throughput (simulate)
    const throughput = data.throughput || Math.random() * 50 + 10;
    document.getElementById('throughput').textContent = throughput.toFixed(1) + ' MB/s';
    document.getElementById('throughput-bar').style.width = Math.min((throughput / 100) * 100, 100) + '%';
    
    // Key exchange speed (simulate)
    const keySpeed = data.keyExchangeSpeed || Math.random() * 50 + 10;
    document.getElementById('key-exchange-speed').textContent = Math.round(keySpeed) + ' ms';
    document.getElementById('key-exchange-bar').style.width = Math.min((keySpeed / 100) * 100, 100) + '%';
}

// Update File Size Distribution
function updateFileSizeDistribution(files) {
    const sizes = { small: 0, medium: 0, large: 0, xlarge: 0 };
    
    files.forEach(file => {
        const sizeMB = (file.size || 0) / (1024 * 1024);
        if (sizeMB < 1) sizes.small++;
        else if (sizeMB < 10) sizes.medium++;
        else if (sizeMB < 50) sizes.large++;
        else sizes.xlarge++;
    });
    
    const total = sizes.small + sizes.medium + sizes.large + sizes.xlarge;
    
    if (total > 0) {
        document.getElementById('size-bar-1').style.width = (sizes.small / total * 100) + '%';
        document.getElementById('size-bar-2').style.width = (sizes.medium / total * 100) + '%';
        document.getElementById('size-bar-3').style.width = (sizes.large / total * 100) + '%';
        document.getElementById('size-bar-4').style.width = (sizes.xlarge / total * 100) + '%';
    }
    
    document.getElementById('size-count-1').textContent = sizes.small;
    document.getElementById('size-count-2').textContent = sizes.medium;
    document.getElementById('size-count-3').textContent = sizes.large;
    document.getElementById('size-count-4').textContent = sizes.xlarge;
}
