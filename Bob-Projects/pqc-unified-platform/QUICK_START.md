# 🚀 Quick Start Guide - PQC Unified Platform

## Get Started in 3 Steps

### Step 1: Run the Application

```bash
cd pqc-unified-platform
build-and-run.bat
```

Wait for:
```
╔════════════════════════════════════════════════════════════╗
║   PQC UNIFIED PLATFORM - Successfully Started              ║
╠════════════════════════════════════════════════════════════╣
║   Port:              8080                                  ║
║   URL:               http://localhost:8080                 ║
╚════════════════════════════════════════════════════════════╝
```

### Step 2: Open in Browser

```
http://localhost:8080
```

### Step 3: Explore Features

## 🔍 Feature 1: Domain Scanner

**Scan a Domain:**
1. Click "Domain Scanner" tab (default)
2. Enter: `google.com`
3. Click "Scan Domain"
4. View results:
   - PQC Status
   - Certificate details
   - Risk assessment
   - TLS information

**Try These Domains:**
- `google.com` - Standard TLS
- `cloudflare.com` - Modern security
- `github.com` - Developer platform

## 📁 Feature 2: File Encryptor

**Encrypt a File:**
1. Click "File Encryptor" tab
2. Drag & drop any file OR click "Browse Files"
3. File encrypts automatically with ML-KEM-768
4. See encrypted file in list below

**Decrypt a File:**
1. Select encrypted file from dropdown
2. Click "Decrypt File"
3. File downloads automatically

**Test Files:**
- Create a text file: `test.txt`
- Try a PDF document
- Upload an image

## 💬 Feature 3: Secure Messaging

**Start a Chat (User 1):**
1. Click "Secure Chat" tab
2. Session ID: `demo-chat`
3. Username: `Alice`
4. Click "Join Session"

**Watch the Magic:**
The debug panel shows 7 PQC handshake steps:
```
✅ Step 1: Session Created
✅ Step 2: User 1 Joined (Alice)
   - ML-KEM-768 key pair generated
   - Public key: 1,184 bytes
```

**Join as Second User:**
1. Open http://localhost:8080 in another browser/tab
2. Click "Secure Chat" tab
3. Session ID: `demo-chat` (same as Alice)
4. Username: `Bob` (different from Alice)
5. Click "Join Session"

**Complete Handshake:**
```
✅ Step 3: User 2 Joined (Bob)
✅ Step 4: Public Keys Exchanged
✅ Step 5: Key Encapsulation
✅ Step 6: Key Decapsulation
✅ Step 7: Secure Channel Established
```

**Send Encrypted Messages:**
1. Type: `Hello from Alice!`
2. Press Enter
3. Message appears encrypted
4. Click message to view encryption details

## 🎯 What's Happening?

### Domain Scanner
```
1. Connects to domain:443
2. Performs TLS handshake
3. Extracts certificate info
4. Checks for PQC algorithms
5. Calculates risk score
6. Displays results
```

### File Encryptor
```
1. Generates ML-KEM-768 key pair
2. Performs key encapsulation
3. Derives AES-256 key
4. Encrypts file with AES-GCM
5. Saves encrypted file + metadata
6. Allows decryption with same keys
```

### Secure Messaging
```
1. User 1 generates ML-KEM key pair
2. User 2 generates ML-KEM key pair
3. Users exchange public keys
4. User 1 encapsulates shared secret
5. User 2 decapsulates shared secret
6. Both derive same AES-256 key
7. Messages encrypted with AES-GCM
```

## 🔐 Cryptography in Action

### ML-KEM-768 (Kyber)
- **Quantum-Safe**: Resistant to quantum attacks
- **NIST Standard**: FIPS 203 (2024)
- **Fast**: ~1ms operations
- **Secure**: NIST Level 3 (AES-192 equivalent)

### AES-256-GCM
- **Symmetric**: Same key for encrypt/decrypt
- **Authenticated**: Prevents tampering
- **Fast**: <1ms for messages
- **Secure**: 256-bit key strength

## 📊 Try These Scenarios

### Scenario 1: Security Assessment
```
1. Scan 5 different domains
2. Compare PQC status
3. Review risk scores
4. Check certificate validity
```

### Scenario 2: Secure File Sharing
```
1. Encrypt a confidential document
2. Note the encrypted filename
3. Decrypt it back
4. Verify content integrity
```

### Scenario 3: Private Chat
```
1. Create session as Alice
2. Join as Bob (different browser)
3. Exchange 10 messages
4. Click messages to see encryption
5. Watch debug panel updates
```

## 🎓 Learning Points

### You'll See:
✅ Real PQC key exchange in action
✅ Quantum-safe encryption working
✅ NIST-standardized algorithms
✅ Java 24 native crypto APIs
✅ Modern web application design
✅ RESTful API architecture
✅ Responsive UI/UX

### You'll Learn:
✅ How ML-KEM (Kyber) works
✅ Key encapsulation vs key agreement
✅ Hybrid cryptography (PQC + AES)
✅ Certificate analysis
✅ Risk assessment
✅ Secure messaging protocols

## 🐛 Troubleshooting

### Application won't start?
```bash
# Check Java version
java -version  # Should be 24.0.2+

# Set JAVA_HOME
set "JAVA_HOME=C:\Program Files\Java\jdk-24"
```

### Port 8080 in use?
```bash
# Find process
netstat -ano | findstr :8080

# Kill process
taskkill /PID <pid> /F

# Or change port in config.json
```

### Can't upload files?
```bash
# Create directories
mkdir uploads
mkdir uploads\encrypted
```

### Chat not working?
- Use exact same Session ID
- Use different Usernames
- Wait for both users to join
- Refresh page if needed

## 📚 Next Steps

1. **Read README.md** - Full documentation
2. **Check PROJECT_SUMMARY.md** - Technical details
3. **Explore Source Code** - Learn implementation
4. **Try Database** - Enable persistence
5. **Customize** - Modify for your needs

## 🎉 Success Indicators

You're successful when you:
- ✅ Scan a domain and see results
- ✅ Encrypt and decrypt a file
- ✅ Complete a chat handshake
- ✅ Send encrypted messages
- ✅ Understand the debug panel
- ✅ See PQC in action

## 💡 Pro Tips

1. **Open DevTools (F12)** - See API calls
2. **Check Network Tab** - View requests/responses
3. **Monitor Console** - See JavaScript logs
4. **Try Multiple Tabs** - Test concurrent sessions
5. **Click Everything** - Discover features

## 🔗 Quick Links

- **Application**: http://localhost:8080
- **Health Check**: http://localhost:8080/api/health
- **Scanner API**: http://localhost:8080/api/scanner/stats
- **File List**: http://localhost:8080/api/file/list
- **Sessions**: http://localhost:8080/api/chat/sessions

## 📞 Need Help?

1. Check error messages in browser
2. Review server logs in terminal
3. Read README.md troubleshooting section
4. Check configuration in config.json
5. Verify Java 24 is installed

## 🎊 Congratulations!

You're now running a quantum-safe security platform with:
- 🔍 Domain scanning
- 📁 File encryption
- 💬 Secure messaging

All powered by **Java 24 Native ML-KEM**!

---

**Ready to explore quantum-safe security? Start now!**

Made with ❤️ by Bob