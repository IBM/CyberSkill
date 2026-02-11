# 🔐 PQC Unified Platform

**A comprehensive quantum-safe security suite combining three powerful PQC applications into one unified platform.**

## 🌟 Overview

The PQC Unified Platform integrates three distinct Post-Quantum Cryptography applications:

1. **🔍 Domain Scanner** - Analyze TLS/PQC certificates and assess security risks
2. **📁 File Encryptor** - Encrypt and decrypt files using quantum-safe algorithms
3. **💬 Secure Messaging** - Real-time encrypted chat with PQC key exchange

All powered by **Java 24's native ML-KEM (Kyber)** implementation and **AES-256-GCM** encryption.

## ✨ Features

### Domain Scanner
- Scan any domain for TLS certificate information
- Detect PQC-enabled certificates (Dilithium, Falcon, SPHINCS+)
- Risk assessment and scoring
- Certificate validity checking
- Cipher suite analysis
- Recent scan history

### File Encryptor
- Drag-and-drop file encryption
- ML-KEM-768 key encapsulation
- AES-256-GCM symmetric encryption
- Secure file storage
- Easy decryption and download
- Metadata preservation

### Secure Messaging
- Two-user encrypted chat sessions
- Real-time PQC key exchange
- Debug panel showing all 7 handshake steps
- Message encryption with AES-256-GCM
- Click messages to view encryption details
- Session management

## 🚀 Quick Start

### Prerequisites

- **Java 24** (JDK 24.0.2 or later)
- **Maven 3.9+**
- **PostgreSQL** (optional, for persistent storage)

### Installation

1. **Clone or navigate to the project directory**
```bash
cd pqc-unified-platform
```

2. **Run the build script**
```bash
build-and-run.bat
```

3. **Access the application**
```
http://localhost:8080
```

## 📖 Usage Guide

### 1. Domain Scanner

**Scan a Domain:**
1. Navigate to the "Domain Scanner" tab
2. Enter a domain (e.g., `google.com`)
3. Click "Scan Domain"
4. View detailed certificate and security information
5. Check risk assessment and PQC status

**Understanding Results:**
- **PQC Status**: Shows if quantum-safe algorithms are used
- **Risk Score**: 0-100 scale (lower is better)
- **Risk Level**: LOW, MEDIUM, or HIGH
- **Certificate Details**: Subject, issuer, validity period
- **TLS Info**: Protocol version and cipher suite

### 2. File Encryptor

**Encrypt a File:**
1. Navigate to the "File Encryptor" tab
2. Drag & drop a file or click "Browse Files"
3. File is automatically encrypted with ML-KEM-768
4. Encrypted file appears in the list below

**Decrypt a File:**
1. Select an encrypted file from the dropdown
2. Click "Decrypt File"
3. File is decrypted and downloaded automatically

**Supported File Types:**
- Documents: PDF, DOCX, TXT
- Images: JPG, PNG
- Archives: ZIP
- Maximum size: 100 MB

### 3. Secure Messaging

**Start a Chat Session:**
1. Navigate to the "Secure Chat" tab
2. Enter a Session ID (e.g., `demo-chat`)
3. Enter your Username (e.g., `Alice`)
4. Click "Join Session"

**Watch the PQC Handshake:**
The debug panel shows 7 steps:
1. Session Created
2. User 1 Joined (ML-KEM key pair generated)
3. User 2 Joined (ML-KEM key pair generated)
4. Public Keys Exchanged
5. Key Encapsulation
6. Key Decapsulation
7. Secure Channel Established

**Send Encrypted Messages:**
1. Type your message
2. Press Enter or click "Send"
3. Message is encrypted with AES-256-GCM
4. Click any message to view encryption details

**Test with Two Users:**
- Open another browser/tab
- Use the same Session ID
- Use a different Username
- Watch the handshake complete automatically

## 🏗️ Architecture

### Backend (Java 24)

```
com.pqc.unified/
├── MainVerticle.java          # Main server & routing
├── PQCCryptoService.java      # Core cryptography (ML-KEM + AES)
├── ScannerHandler.java        # Domain scanning logic
├── FileEncryptorHandler.java  # File encryption/decryption
└── ChatHandler.java           # Chat session management
```

### Frontend (JavaScript)

```
webroot/
├── index.html                 # Main UI structure
├── css/styles.css            # Modern responsive design
└── js/app.js                 # Application logic
```

### API Endpoints

#### Scanner
- `POST /api/scanner/scan` - Scan a domain
- `GET /api/scanner/results` - Get recent scans
- `GET /api/scanner/result/:id` - Get specific scan
- `GET /api/scanner/stats` - Get statistics

#### File Encryptor
- `POST /api/file/encrypt` - Encrypt a file
- `POST /api/file/decrypt` - Decrypt a file
- `GET /api/file/list` - List encrypted files
- `GET /api/file/download/:filename` - Download file

#### Chat
- `POST /api/chat/session/create` - Create/join session
- `POST /api/chat/message/send` - Send encrypted message
- `GET /api/chat/session/:id` - Get session details
- `GET /api/chat/sessions` - List all sessions

## 🔒 Cryptography Details

### ML-KEM-768 (Kyber)

- **Algorithm**: NIST-standardized lattice-based KEM
- **Security Level**: NIST Level 3 (equivalent to AES-192)
- **Public Key**: 1,184 bytes
- **Private Key**: 2,400 bytes
- **Ciphertext**: 1,088 bytes
- **Shared Secret**: 32 bytes (256 bits)

### Key Encapsulation Process

```java
// Sender (User 1)
KEM kem = KEM.getInstance("ML-KEM-768");
KEM.Encapsulator encapsulator = kem.newEncapsulator(recipientPublicKey);
KEM.Encapsulated result = encapsulator.encapsulate();
byte[] encapsulatedKey = result.encapsulation();
SecretKey sharedSecret = result.key();

// Receiver (User 2)
KEM.Decapsulator decapsulator = kem.newDecapsulator(privateKey);
SecretKey sharedSecret = decapsulator.decapsulate(encapsulatedKey);
// Both now have the same 256-bit AES key!
```

### AES-256-GCM Encryption

- **Algorithm**: AES in Galois/Counter Mode
- **Key Size**: 256 bits (from ML-KEM shared secret)
- **IV Size**: 12 bytes (random per message/file)
- **Tag Size**: 128 bits (authentication)
- **Mode**: AEAD (Authenticated Encryption with Associated Data)

## ⚙️ Configuration

Edit `src/main/resources/config.json`:

```json
{
  "http.port": 8080,
  "database": {
    "host": "localhost",
    "port": 5432,
    "database": "pqc_unified",
    "user": "postgres",
    "password": "postgres"
  },
  "pqc": {
    "algorithm": "ML-KEM-768",
    "keySize": 768
  },
  "encryption": {
    "algorithm": "AES/GCM/NoPadding",
    "keySize": 256
  },
  "fileStorage": {
    "uploadDir": "uploads",
    "encryptedDir": "uploads/encrypted",
    "maxFileSize": 104857600
  },
  "chat": {
    "maxSessions": 100,
    "sessionTimeout": 3600000
  }
}
```

## 🗄️ Database Setup (Optional)

The platform works without a database, but for persistent storage:

```sql
CREATE DATABASE pqc_unified;

CREATE TABLE scan_results (
    id SERIAL PRIMARY KEY,
    domain VARCHAR(255) NOT NULL,
    host VARCHAR(255) NOT NULL,
    port INTEGER NOT NULL,
    is_pqc BOOLEAN DEFAULT FALSE,
    pqc_algorithm VARCHAR(100),
    cipher_suite VARCHAR(255),
    protocol VARCHAR(50),
    risk_score INTEGER,
    risk_level VARCHAR(20),
    scan_data JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_scan_domain ON scan_results(domain);
CREATE INDEX idx_scan_created ON scan_results(created_at DESC);
```

## 🛠️ Development

### Build Only

```bash
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
mvn clean compile
```

### Package Fat JAR

```bash
mvn clean package
```

### Run

```bash
java --enable-preview -jar target\pqc-unified-platform-1.0.0-fat.jar
```

## 🔧 Troubleshooting

### "invalid target release: 24"

**Solution**: Ensure Java 24 is installed and JAVA_HOME is set:
```bash
java -version  # Should show 24.0.2 or later
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
```

### Port 8080 already in use

**Solution**: Change port in `config.json` or kill the process:
```bash
netstat -ano | findstr :8080
taskkill /PID <pid> /F
```

### Database connection failed

**Solution**: The platform works without a database. To enable:
1. Install PostgreSQL
2. Create database: `pqc_unified`
3. Update credentials in `config.json`

### File upload fails

**Solution**: Check directory permissions:
```bash
mkdir uploads
mkdir uploads\encrypted
```

## 📊 Performance

- **Key Generation**: ~1-2ms per key pair
- **Encapsulation**: ~1ms
- **Decapsulation**: ~1ms
- **File Encryption**: ~10-50ms (depends on file size)
- **Message Encryption**: <1ms
- **Domain Scan**: ~2-5 seconds

## 🔐 Security Considerations

### ✅ Quantum-Safe
- ML-KEM (Kyber) is resistant to quantum attacks
- NIST-standardized in 2024 (FIPS 203)
- Based on lattice cryptography (Module-LWE)

### ✅ Best Practices
- Forward secrecy (new keys per session)
- Authenticated encryption (AES-GCM)
- Secure random number generation
- No key reuse

### ⚠️ Production Recommendations
- Add TLS/HTTPS for transport security
- Implement user authentication
- Add rate limiting
- Use secure key storage (HSM/KMS)
- Implement key rotation
- Add comprehensive logging
- Perform security audits

## 📚 Technology Stack

- **Java 24** - Native ML-KEM support with `--enable-preview`
- **Vert.x 4.5.1** - Reactive web framework
- **PostgreSQL** - Optional persistent storage
- **Vanilla JavaScript** - No frontend frameworks
- **Modern CSS** - Responsive gradient design

## 🎯 Use Cases

1. **Security Assessment** - Scan your domains for PQC readiness
2. **Secure File Sharing** - Encrypt sensitive documents
3. **Private Communication** - Quantum-safe messaging
4. **Education** - Learn about PQC implementation
5. **Testing** - Validate PQC integration

## 📖 References

- [NIST PQC Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [ML-KEM (FIPS 203)](https://csrc.nist.gov/pubs/fips/203/final)
- [Java 24 KEM API](https://docs.oracle.com/en/java/javase/24/docs/api/java.base/javax/crypto/KEM.html)
- [Vert.x Documentation](https://vertx.io/docs/)

## 📝 License

MIT License - Free for educational and commercial use.

## 👨‍💻 Author

**Made with Bob** - Java Modernization Assistant

## 🤝 Contributing

This is a demonstration project showcasing Java 24's native PQC capabilities. Feel free to:
- Report issues
- Suggest improvements
- Fork and extend
- Use in your projects

## 🎉 Acknowledgments

- NIST for PQC standardization
- Oracle for Java 24 PQC support
- Vert.x team for the excellent framework
- The cryptography community

---

**🔐 Unified Quantum-Safe Security Platform - Powered by Java 24 Native ML-KEM**

*Protecting your data from quantum threats, today and tomorrow.*