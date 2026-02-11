// PQC Chat Application
class PQCChatApp {
    constructor() {
        this.sessionId = null;
        this.user1Name = 'Alice';
        this.user2Name = 'Bob';
        this.apiBase = '/api';
        
        this.initializeElements();
        this.attachEventListeners();
    }
    
    initializeElements() {
        // Session setup elements
        this.user1Input = document.getElementById('user1');
        this.user2Input = document.getElementById('user2');
        this.createSessionBtn = document.getElementById('createSessionBtn');
        this.sessionStatus = document.getElementById('sessionStatus');
        
        // Debug panel elements
        this.debugPanel = document.getElementById('debugPanel');
        this.sessionInfo = document.getElementById('sessionInfo');
        this.user1Steps = document.getElementById('user1Steps');
        this.user2Steps = document.getElementById('user2Steps');
        this.user1Title = document.getElementById('user1Title');
        this.user2Title = document.getElementById('user2Title');
        
        // Chat elements
        this.chatContainer = document.getElementById('chatContainer');
        this.messageList = document.getElementById('messageList');
        this.messageInput = document.getElementById('messageInput');
        this.sendMessageBtn = document.getElementById('sendMessageBtn');
        this.senderSelect = document.getElementById('senderSelect');
        this.chatUsers = document.getElementById('chatUsers');
        
        // Message details
        this.messageDetails = document.getElementById('messageDetails');
        this.messageDetailsContent = document.getElementById('messageDetailsContent');
    }
    
    attachEventListeners() {
        this.createSessionBtn.addEventListener('click', () => this.createSession());
        this.sendMessageBtn.addEventListener('click', () => this.sendMessage());
        this.messageInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                this.sendMessage();
            }
        });
    }
    
    async createSession() {
        this.user1Name = this.user1Input.value.trim() || 'Alice';
        this.user2Name = this.user2Input.value.trim() || 'Bob';
        
        this.createSessionBtn.disabled = true;
        this.createSessionBtn.innerHTML = '<span class="loading"></span> Creating Session...';
        
        try {
            const response = await fetch(`${this.apiBase}/sessions`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    user1Id: this.user1Name,
                    user2Id: this.user2Name
                })
            });
            
            if (!response.ok) {
                throw new Error('Failed to create session');
            }
            
            const data = await response.json();
            this.sessionId = data.sessionId;
            
            this.showSuccess('Session created successfully! Key exchange complete.');
            this.displayDebugInfo(data);
            this.setupChat();
            
        } catch (error) {
            this.showError('Failed to create session: ' + error.message);
            console.error('Error:', error);
        } finally {
            this.createSessionBtn.disabled = false;
            this.createSessionBtn.textContent = 'Create Session & Exchange Keys';
        }
    }
    
    displayDebugInfo(data) {
        // Update titles
        this.user1Title.textContent = `${this.user1Name}'s Handshake Steps`;
        this.user2Title.textContent = `${this.user2Name}'s Handshake Steps`;
        
        // Display session info
        this.sessionInfo.innerHTML = `
            <p><strong>Session ID:</strong> ${data.sessionId}</p>
            <p><strong>User 1:</strong> ${this.user1Name}</p>
            <p><strong>User 2:</strong> ${this.user2Name}</p>
            <p><strong>Key Exchange:</strong> ✅ Complete</p>
            <p><strong>Algorithm:</strong> Kyber-1024 (Post-Quantum)</p>
            <p><strong>Encryption:</strong> AES-256-GCM</p>
        `;
        
        // Display handshake steps for user 1
        this.user1Steps.innerHTML = '';
        data.user1Steps.forEach((step, index) => {
            const stepDiv = document.createElement('div');
            stepDiv.className = 'step';
            if (step.includes('ERROR')) {
                stepDiv.classList.add('error');
            } else if (step.includes('Complete')) {
                stepDiv.classList.add('success');
            }
            stepDiv.textContent = step;
            this.user1Steps.appendChild(stepDiv);
        });
        
        // Display handshake steps for user 2
        this.user2Steps.innerHTML = '';
        data.user2Steps.forEach((step, index) => {
            const stepDiv = document.createElement('div');
            stepDiv.className = 'step';
            if (step.includes('ERROR')) {
                stepDiv.classList.add('error');
            } else if (step.includes('Complete')) {
                stepDiv.classList.add('success');
            }
            stepDiv.textContent = step;
            this.user2Steps.appendChild(stepDiv);
        });
        
        // Show debug panel
        this.debugPanel.style.display = 'block';
    }
    
    setupChat() {
        // Update sender select options
        this.senderSelect.innerHTML = `
            <option value="${this.user1Name}">${this.user1Name}</option>
            <option value="${this.user2Name}">${this.user2Name}</option>
        `;
        
        // Update chat users display
        this.chatUsers.textContent = `${this.user1Name} ↔️ ${this.user2Name}`;
        
        // Show chat container
        this.chatContainer.style.display = 'block';
        
        // Focus on message input
        this.messageInput.focus();
    }
    
    async sendMessage() {
        const message = this.messageInput.value.trim();
        if (!message) {
            return;
        }
        
        const sender = this.senderSelect.value;
        
        this.sendMessageBtn.disabled = true;
        this.messageInput.disabled = true;
        
        try {
            const response = await fetch(`${this.apiBase}/sessions/${this.sessionId}/messages`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    from: sender,
                    message: message
                })
            });
            
            if (!response.ok) {
                throw new Error('Failed to send message');
            }
            
            const data = await response.json();
            this.displayMessage(data);
            
            // Clear input
            this.messageInput.value = '';
            
        } catch (error) {
            this.showError('Failed to send message: ' + error.message);
            console.error('Error:', error);
        } finally {
            this.sendMessageBtn.disabled = false;
            this.messageInput.disabled = false;
            this.messageInput.focus();
        }
    }
    
    displayMessage(messageData) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${messageData.from.toLowerCase()}`;
        
        const time = new Date(messageData.timestamp).toLocaleTimeString();
        
        messageDiv.innerHTML = `
            <div class="message-header">${messageData.from}</div>
            <div class="message-text">${this.escapeHtml(messageData.plaintext)}</div>
            <div class="message-time">${time}</div>
        `;
        
        // Add click handler to show encryption details
        messageDiv.addEventListener('click', () => {
            this.showMessageDetails(messageData);
        });
        
        this.messageList.appendChild(messageDiv);
        this.messageList.scrollTop = this.messageList.scrollHeight;
    }
    
    showMessageDetails(messageData) {
        const time = new Date(messageData.timestamp).toLocaleString();
        
        this.messageDetailsContent.innerHTML = `
            <div class="detail-item">
                <strong>Timestamp:</strong>
                <span>${time}</span>
            </div>
            <div class="detail-item">
                <strong>From:</strong>
                <span>${messageData.from}</span>
            </div>
            <div class="detail-item">
                <strong>To:</strong>
                <span>${messageData.to}</span>
            </div>
            <div class="detail-item">
                <strong>Original Message:</strong>
                <code>${this.escapeHtml(messageData.plaintext)}</code>
            </div>
            <div class="detail-item">
                <strong>Encrypted (Base64):</strong>
                <code>${messageData.encrypted}</code>
            </div>
            <div class="detail-item">
                <strong>Encrypted Size:</strong>
                <span>${messageData.encryptedSize} characters</span>
            </div>
            <div class="detail-item">
                <strong>Decrypted Message:</strong>
                <code>${this.escapeHtml(messageData.decrypted)}</code>
            </div>
            <div class="detail-item">
                <strong>Encryption Algorithm:</strong>
                <span>AES-256-GCM (Authenticated Encryption)</span>
            </div>
            <div class="detail-item">
                <strong>Key Derivation:</strong>
                <span>SHA-256 from Kyber shared secret</span>
            </div>
        `;
        
        this.messageDetails.style.display = 'block';
        this.messageDetails.scrollIntoView({ behavior: 'smooth' });
    }
    
    showSuccess(message) {
        this.sessionStatus.textContent = message;
        this.sessionStatus.className = 'status-message success';
    }
    
    showError(message) {
        this.sessionStatus.textContent = message;
        this.sessionStatus.className = 'status-message error';
    }
    
    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize app when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    new PQCChatApp();
});

// Made with Bob
