# Quick Start Guide - PQC Secured Messaging

## Prerequisites
- Java 17 or higher installed
- Maven 3.6+ installed

## Running the Application

### Option 1: Using the Run Script (Windows)
```bash
run.bat
```

### Option 2: Using Maven
```bash
mvn clean package -DskipTests
java -jar target/pqc-chat-1.0.0-fat.jar
```

### Option 3: Using Maven Exec
```bash
mvn exec:java -Dexec.mainClass="io.vertx.core.Launcher" -Dexec.args="run com.pqc.chat.MainVerticle"
```

## Accessing the Application

Once the server starts, open your browser and navigate to:
```
http://localhost:8080
```

You should see:
```
PQC Chat Server started on port 8080
Access the application at: http://localhost:8080
```

## Using the Application

### Step 1: Create a Chat Session
1. Enter names for two users (default: Alice and Bob)
2. Click "Create Session & Exchange Keys"
3. Watch the PQC handshake process in the debug panel

### Step 2: View the Debug Panel
The debug panel shows:
- Session information (Session ID, users, encryption details)
- Alice's handshake steps (key generation, exchange, derivation)
- Bob's handshake steps (key generation, exchange, derivation)

### Step 3: Send Encrypted Messages
1. Select a sender from the dropdown (Alice or Bob)
2. Type your message
3. Click "Send" or press Enter
4. The message is encrypted with AES-256-GCM and displayed

### Step 4: View Message Details
Click on any message to see:
- Original plaintext
- Encrypted ciphertext (Base64)
- Decrypted message (verification)
- Encryption algorithm details

## What's Happening Behind the Scenes

### 1. Key Exchange (Kyber-1024)
```
Alice generates key pair → Exchange public keys ← Bob generates key pair
         ↓                                              ↓
Alice derives shared secret                  Bob derives shared secret
         ↓                                              ↓
    Same AES-256 key! ←──────────────────────→  Same AES-256 key!
```

### 2. Message Encryption (AES-256-GCM)
```
Plaintext → AES-256-GCM Encrypt → Ciphertext + Auth Tag → Base64 → Transmitted
```

### 3. Message Decryption
```
Received → Base64 Decode → AES-256-GCM Decrypt + Verify → Plaintext
```

## API Testing

You can also test the API directly:

### Create Session
```bash
curl -X POST http://localhost:8080/api/sessions \
  -H "Content-Type: application/json" \
  -d '{"user1Id":"Alice","user2Id":"Bob"}'
```

### Send Message
```bash
curl -X POST http://localhost:8080/api/sessions/{sessionId}/messages \
  -H "Content-Type: application/json" \
  -d '{"from":"Alice","message":"Hello Bob!"}'
```

### Get Session Info
```bash
curl http://localhost:8080/api/sessions/{sessionId}
```

## Troubleshooting

### Port Already in Use
Edit `src/main/resources/config.json`:
```json
{
  "http.port": 8081
}
```

### Build Fails
Ensure you have Java 17+ and Maven 3.6+:
```bash
java -version
mvn -version
```

### Application Won't Start
Check the console logs for errors. Common issues:
- Port conflict (change port in config.json)
- Missing dependencies (run `mvn clean install`)

## Security Notes

- **Kyber-1024**: NIST-selected post-quantum algorithm, highest security level
- **AES-256-GCM**: Industry-standard authenticated encryption
- **Key Derivation**: SHA-256 hash of Kyber shared secret
- **Perfect Forward Secrecy**: Each session uses new keys

## Next Steps

- Try sending multiple messages
- Create multiple sessions
- Examine the encryption details of each message
- Review the handshake steps in the debug panel

## Support

For issues or questions, check:
- README.md for detailed documentation
- Console logs for error messages
- API endpoints for direct testing

Enjoy exploring Post-Quantum Cryptography! 🔐