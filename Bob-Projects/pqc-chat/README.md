# PQC-Secured Messaging Application

A minimal chat application demonstrating **Post-Quantum Cryptography (PQC)** using Java 24's native ML-KEM (Kyber) implementation.

## Features

✅ **PQC Key Exchange** - Uses ML-KEM-768 (NIST-standardized lattice-based KEM)  
✅ **Symmetric Encryption** - AES-256-GCM for message encryption  
✅ **Debug Panel** - Real-time visualization of all 7 handshake steps  
✅ **Modern UI** - Clean, responsive interface with gradient design  
✅ **Session Management** - Multiple concurrent chat sessions  
✅ **Message History** - View encrypted message details

## Technology Stack

- **Java 24** with `--enable-preview` for native ML-KEM support
- **Vert.x 4.5.1** for async web server
- **ML-KEM-768** (Kyber) for quantum-safe key encapsulation
- **AES-256-GCM** for message encryption
- **Vanilla JavaScript** frontend (no frameworks)

## Prerequisites

- **Java 24** (JDK 24.0.2 or later)
- **Maven 3.9+**
- **Windows** (batch files provided) or modify for Linux/Mac

## Quick Start

### Option 1: Using Batch File (Recommended)

```bash
build-and-run.bat
```

This will:
1. Set JAVA_HOME to Java 24
2. Build the fat JAR
3. Start the application
4. Open at http://localhost:9999

### Option 2: Manual Build

```bash
# Set Java 24
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
set "PATH=%JAVA_HOME%\bin;%PATH%"

# Build
mvn clean package

# Run
java --enable-preview -jar target\pqc-chat-1.0.0-fat.jar
```

### Option 3: Compile Only

```bash
compile-java24.bat
```

## How to Use

### 1. Create a Session

1. Open http://localhost:9999 in your browser
2. Enter a **Session ID** (e.g., "chat123")
3. Enter your **Username** (e.g., "Alice" or "Bob")
4. Click **"Create/Join Session"**

### 2. Watch the PQC Handshake

The **Debug Panel** on the right shows 7 steps:

1. ✅ **Session Created** - Session initialized
2. ✅ **User 1 Joined** - First user generates ML-KEM key pair
3. ✅ **User 2 Joined** - Second user generates ML-KEM key pair
4. ✅ **Public Keys Exchanged** - Users exchange public keys
5. ✅ **Key Encapsulation** - User 1 encapsulates shared secret using User 2's public key
6. ✅ **Key Decapsulation** - User 2 decapsulates to derive same shared secret
7. ✅ **Secure Channel Established** - Both users have identical AES-256 key

### 3. Send Encrypted Messages

1. Type a message in the input box
2. Click **"Send"** or press Enter
3. Message is encrypted with AES-256-GCM
4. Click any message to view encryption details:
   - Original plaintext
   - Encrypted ciphertext (hex)
   - Initialization Vector (IV)
   - Authentication tag

### 4. Test with Multiple Users

Open the same URL in another browser/tab:
- Use the **same Session ID**
- Use a **different Username**
- Watch the handshake complete automatically
- Send messages between users

## Architecture

### Backend (Java)

```
com.pqc.chat/
├── MainVerticle.java       # Vert.x server & routing
├── ApiHandler.java         # REST API endpoints
├── PQCCryptoService.java   # ML-KEM & AES encryption
└── ChatSession.java        # Session management
```

### Frontend (JavaScript)

```
src/main/resources/webroot/
├── index.html              # UI structure
├── app.js                  # API calls & UI logic
└── styles.css              # Modern gradient design
```

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/session/create` | Create/join session |
| POST | `/api/session/join` | Join existing session |
| POST | `/api/message/send` | Send encrypted message |
| GET | `/api/session/:id` | Get session details |

## Cryptographic Details

### ML-KEM-768 (Kyber)

- **Algorithm**: NIST-standardized lattice-based KEM
- **Security Level**: NIST Level 3 (equivalent to AES-192)
- **Public Key Size**: 1,184 bytes
- **Ciphertext Size**: 1,088 bytes
- **Shared Secret**: 32 bytes (256 bits)

### Key Encapsulation Process

```java
// User 1 (Sender)
KEM kem = KEM.getInstance("ML-KEM-768");
KEM.Encapsulator encapsulator = kem.newEncapsulator(user2PublicKey);
KEM.Encapsulated result = encapsulator.encapsulate();
byte[] encapsulatedKey = result.encapsulation();  // Send to User 2
SecretKey sharedSecret = result.key();            // 256-bit AES key

// User 2 (Receiver)
KEM.Decapsulator decapsulator = kem.newDecapsulator(user2PrivateKey);
SecretKey sharedSecret = decapsulator.decapsulate(encapsulatedKey);
// Now both users have the same sharedSecret!
```

### AES-256-GCM Encryption

- **Algorithm**: AES in Galois/Counter Mode
- **Key Size**: 256 bits (derived from ML-KEM shared secret)
- **IV Size**: 12 bytes (randomly generated per message)
- **Authentication**: Built-in AEAD (Authenticated Encryption with Associated Data)

## Configuration

Edit `src/main/resources/config.json`:

```json
{
  "http.port": 9999,
  "pqc.algorithm": "ML-KEM-768",
  "encryption.algorithm": "AES/GCM/NoPadding"
}
```

## Security Notes

### ✅ Quantum-Safe

- **ML-KEM (Kyber)** is resistant to quantum computer attacks
- Standardized by NIST in 2024
- Based on lattice cryptography (Module Learning With Errors)

### ✅ Forward Secrecy

- Each session generates new ML-KEM key pairs
- Compromise of one session doesn't affect others

### ✅ Authenticated Encryption

- AES-GCM provides both confidentiality and authenticity
- Prevents tampering and forgery attacks

### ⚠️ Demo Limitations

This is a **demonstration application**. For production use:

- Add TLS/HTTPS for transport security
- Implement user authentication
- Add message persistence
- Implement key rotation
- Add rate limiting
- Use secure random number generation
- Add input validation and sanitization

## Troubleshooting

### "invalid target release: 24"

**Solution**: Ensure Java 24 is installed and JAVA_HOME is set correctly:

```bash
java -version  # Should show "24.0.2" or later
```

### "KEM not found"

**Solution**: Ensure you're using `--enable-preview` flag:

```bash
java --enable-preview -jar target\pqc-chat-1.0.0-fat.jar
```

### Port 9999 already in use

**Solution**: Change port in `config.json` or kill the process:

```bash
netstat -ano | findstr :9999
taskkill /PID <pid> /F
```

## Project Structure

```
pqc-chat/
├── src/
│   └── main/
│       ├── java/com/pqc/chat/
│       │   ├── MainVerticle.java
│       │   ├── ApiHandler.java
│       │   ├── PQCCryptoService.java
│       │   └── ChatSession.java
│       └── resources/
│           ├── config.json
│           ├── logback.xml
│           └── webroot/
│               ├── index.html
│               ├── app.js
│               └── styles.css
├── pom.xml
├── compile-java24.bat
├── build-and-run.bat
└── README.md
```

## Development

### Build Only

```bash
compile-java24.bat
```

### Run in Development Mode

```bash
mvn clean compile exec:java
```

### Package Fat JAR

```bash
mvn clean package
```

## References

- [NIST PQC Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [ML-KEM (Kyber) Specification](https://csrc.nist.gov/pubs/fips/203/final)
- [Java 24 KEM API](https://docs.oracle.com/en/java/javase/24/docs/api/java.base/javax/crypto/KEM.html)
- [Vert.x Documentation](https://vertx.io/docs/)

## License

MIT License - Feel free to use for learning and demonstration purposes.

## Author

Made with Bob - Java Modernization Assistant

---

**🔐 Quantum-Safe Messaging with Java 24 Native ML-KEM**