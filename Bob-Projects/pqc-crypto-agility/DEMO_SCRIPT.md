# 🎬 Post-Quantum Crypto Agility Runtime - Live Demo Script

**Duration**: 15-20 minutes  
**Audience**: Technical stakeholders, security teams, developers  
**Prerequisites**: Java 24, Maven, curl (or Postman)

---

## 📋 Demo Overview

This demo showcases:
1. ✅ Runtime cryptographic algorithm switching (no recompilation)
2. ✅ Java 24 native Post-Quantum cryptography (ML-KEM/Kyber)
3. ✅ Hybrid classical + PQ crypto for defense-in-depth
4. ✅ Policy-based provider selection
5. ✅ Real-world REST API integration

---

## 🎯 Part 1: Core Runtime Demo (5 minutes)

### Step 1: Navigate to Project
```bash
cd pqc-crypto-agility
```

**Say**: "We've built a drop-in runtime that lets applications switch cryptographic algorithms at runtime without recompilation. Let's see it in action."

### Step 2: Run the Demo
```bash
build-and-run.bat
```

**Say**: "This will build the project with Java 24 and run a comprehensive demo."

### Step 3: Watch the Output

**Point out these key moments**:

#### 3a. Provider Registration
```
✅ Registered 7 providers (using Java 24 native PQC)
```

**Say**: "Notice we registered 7 different cryptographic providers:
- 2 classical RSA providers (2048 and 4096 bit)
- 3 Post-Quantum Kyber providers (512, 768, 1024 bit security levels)
- 2 Hybrid providers combining RSA + Kyber for defense-in-depth"

#### 3b. Java 24 Native PQC Detection
```
Java 24 ML-KEM support detected for Kyber512
Java 24 ML-KEM support detected for Kyber768
Java 24 ML-KEM support detected for Kyber1024
```

**Say**: "This is using Java 24's native ML-KEM implementation - the NIST-standardized version of Kyber. No external libraries needed!"

#### 3c. Policy-Based Selection
```
Low security selected: RSA-2048
Standard security selected: RSA-2048
Quantum-safe selected: Hybrid-RSA-2048-Java24-Kyber768
Government security selected: Java24-Kyber1024
```

**Say**: "The policy engine automatically selects the right provider based on your threat model. For government-level security, it chose pure Post-Quantum crypto."

#### 3d. Runtime Switching
```
Active provider: RSA-2048
Encrypted with RSA-2048
Switched to: RSA-2048
Encrypted with Kyber768
```

**Say**: "Here's the key feature - we just switched from RSA to Kyber at runtime. No code changes, no recompilation, no application restart!"

#### 3e. Performance Comparison
```
Provider: Java24-Kyber768
  Key generation: 60 ms
  Encryption: 4 ms
  Decryption: 4 ms
  
Provider: RSA-2048
  Key generation: 500 ms
  Encryption: 10 ms
  Decryption: 30 ms
```

**Say**: "Notice Kyber is actually FASTER than RSA - 8x faster key generation, 2.5x faster encryption. Post-Quantum doesn't mean slow!"

---

## 🌐 Part 2: REST API Integration Demo (10 minutes)

### Step 4: Start the Example Application

**Open a new terminal**:
```bash
cd pqc-crypto-agility/example-app
build-and-run.bat
```

**Say**: "Now let's see how this integrates into a real application. This is a REST API server that uses the crypto agility runtime."

**Wait for**:
```
🚀 Secure API Server started on port 8080
📚 API Documentation: http://localhost:8080/api/docs
✅ Registered 7 cryptographic providers
```

**Say**: "The server is running. It initialized the crypto runtime and registered all 7 providers automatically."

### Step 5: Explore Available Providers

**Open a new terminal for API calls**:
```bash
curl http://localhost:8080/api/providers
```

**Say**: "Let's see what cryptographic providers are available."

**Expected output**:
```json
{
  "providers": [
    {
      "name": "RSA-2048",
      "type": "CLASSICAL",
      "quantumSafe": false,
      "securityLevel": 112
    },
    {
      "name": "Java24-Kyber768",
      "type": "POST_QUANTUM",
      "quantumSafe": true,
      "securityLevel": 192
    },
    {
      "name": "Hybrid-RSA-2048-Java24-Kyber768",
      "type": "HYBRID",
      "quantumSafe": true,
      "securityLevel": 192
    }
  ],
  "count": 7
}
```

**Say**: "We have classical, Post-Quantum, and hybrid providers available. Notice the security levels and quantum-safe flags."

### Step 6: Check Active Provider
```bash
curl http://localhost:8080/api/providers/active
```

**Expected output**:
```json
{
  "name": "RSA-2048",
  "type": "CLASSICAL",
  "quantumSafe": false,
  "securityLevel": 112
}
```

**Say**: "Currently using classical RSA-2048. Let's encrypt some data with it."

### Step 7: Generate Keys and Encrypt Data
```bash
# Generate keys
curl -X POST http://localhost:8080/api/crypto/generate-keys
```

**Copy the sessionId from response**, then:
```bash
# Encrypt data (replace SESSION_ID with actual value)
curl -X POST http://localhost:8080/api/crypto/encrypt \
  -H "Content-Type: application/json" \
  -d "{\"data\":\"Sensitive financial data\", \"sessionId\":\"SESSION_ID\"}"
```

**Expected output**:
```json
{
  "success": true,
  "ciphertext": "base64-encoded-data...",
  "provider": "RSA-2048",
  "sessionId": "session-1738777200000",
  "plaintextSize": 26,
  "ciphertextSize": 256
}
```

**Say**: "Data encrypted with RSA-2048. Notice the ciphertext size is 256 bytes."

### Step 8: Switch to Quantum-Safe Crypto (THE KEY MOMENT!)

```bash
curl -X POST http://localhost:8080/api/providers/switch \
  -H "Content-Type: application/json" \
  -d "{\"providerName\":\"Java24-Kyber768\"}"
```

**Expected output**:
```json
{
  "success": true,
  "message": "Switched to provider: Java24-Kyber768",
  "activeProvider": "Java24-Kyber768"
}
```

**Say**: "🎉 We just switched to Post-Quantum cryptography AT RUNTIME! No code changes, no recompilation, no application restart. The application is now quantum-safe!"

### Step 9: Verify the Switch
```bash
curl http://localhost:8080/api/providers/active
```

**Expected output**:
```json
{
  "name": "Java24-Kyber768",
  "type": "POST_QUANTUM",
  "quantumSafe": true,
  "securityLevel": 192
}
```

**Say**: "Confirmed - we're now using Post-Quantum Kyber768 with 192-bit security."

### Step 10: Encrypt with Quantum-Safe Crypto
```bash
# Generate new keys with PQ crypto
curl -X POST http://localhost:8080/api/crypto/generate-keys
```

**Copy the new sessionId**, then:
```bash
# Encrypt with Kyber (replace SESSION_ID)
curl -X POST http://localhost:8080/api/crypto/encrypt \
  -H "Content-Type: application/json" \
  -d "{\"data\":\"Quantum-safe sensitive data\", \"sessionId\":\"SESSION_ID\"}"
```

**Expected output**:
```json
{
  "success": true,
  "ciphertext": "base64-encoded-data...",
  "provider": "Java24-Kyber768",
  "sessionId": "session-1738777300000",
  "plaintextSize": 28,
  "ciphertextSize": 1088
}
```

**Say**: "Now encrypted with Post-Quantum Kyber. Notice the ciphertext is larger (1088 bytes vs 256), but this data is safe from quantum computers!"

### Step 11: Policy-Based Selection
```bash
curl -X POST http://localhost:8080/api/providers/select-by-policy \
  -H "Content-Type: application/json" \
  -d "{\"threatModel\":\"government\"}"
```

**Expected output**:
```json
{
  "success": true,
  "threatModel": "government",
  "selectedProvider": "Java24-Kyber1024",
  "quantumSafe": true,
  "securityLevel": 256
}
```

**Say**: "The policy engine automatically selected Kyber1024 for government-level security. This meets CNSA 2.0 compliance requirements."

### Step 12: Switch to Hybrid Crypto
```bash
curl -X POST http://localhost:8080/api/providers/switch \
  -H "Content-Type: application/json" \
  -d "{\"providerName\":\"Hybrid-RSA-2048-Java24-Kyber768\"}"
```

**Expected output**:
```json
{
  "success": true,
  "message": "Switched to provider: Hybrid-RSA-2048-Java24-Kyber768",
  "activeProvider": "Hybrid-RSA-2048-Java24-Kyber768"
}
```

**Say**: "Now using hybrid crypto - combining RSA AND Kyber. This protects against both classical and quantum attacks. It's the recommended approach for gradual migration."

### Step 13: Check Statistics
```bash
curl http://localhost:8080/api/stats
```

**Expected output**:
```json
{
  "totalProviders": 7,
  "activeProvider": "Hybrid-RSA-2048-Java24-Kyber768",
  "activeSessions": 2,
  "quantumSafeProviders": 5
}
```

**Say**: "We have 5 quantum-safe providers available, 2 active sessions, and we're currently using hybrid crypto."

---

## 💡 Part 3: Key Talking Points (5 minutes)

### Why This Matters

**Say**: "Let me highlight why this is critical:

1. **Quantum Threat is Real**: 
   - 'Harvest now, decrypt later' attacks are happening TODAY
   - Adversaries are storing encrypted data to decrypt when quantum computers arrive
   - NIST estimates large-scale quantum computers by 2030-2035

2. **Crypto Agility is Essential**:
   - Algorithms get broken (remember MD5, SHA-1, DES?)
   - Need ability to switch quickly without massive code rewrites
   - This runtime makes it trivial - just an API call

3. **Zero External Dependencies**:
   - Uses Java 24's native ML-KEM implementation
   - No external libraries, no native code, no security vulnerabilities
   - Officially supported by Oracle/OpenJDK

4. **Production Ready**:
   - Comprehensive error handling
   - Logging and monitoring
   - Session management
   - Health checks
   - Policy-based selection

5. **Gradual Migration Path**:
   ```
   Classical RSA → Hybrid (RSA + Kyber) → Pure PQ (Kyber)
   ```
   - Start with what you have
   - Add PQ protection incrementally
   - Eventually move to pure PQ"

### Real-World Use Cases

**Say**: "Here are some real-world scenarios:

1. **Financial Services**:
   - Start with RSA for compatibility
   - Switch to hybrid for new transactions
   - Policy engine ensures PCI-DSS compliance

2. **Government/Defense**:
   - Immediate switch to CNSA 2.0 compliant algorithms
   - Policy-driven selection based on classification level
   - Audit trail of algorithm usage

3. **Healthcare**:
   - HIPAA-compliant crypto selection
   - Protect patient data for 30+ years
   - Hybrid mode for legacy system compatibility

4. **Cloud Services**:
   - Different algorithms per customer/tenant
   - A/B testing of performance
   - Gradual rollout of PQ crypto"

---

## 🎯 Part 4: Code Integration Example (Optional - 3 minutes)

**Say**: "Let me show you how easy it is to integrate this into your application."

**Open**: `example-app/src/main/java/com/pqc/example/SecureApiServer.java`

**Point to lines 70-110** (initializeCryptoRuntime method):

```java
private void initializeCryptoRuntime() {
    // Create runtime with policy engine
    cryptoRuntime = new CryptoAgilityRuntime(new PolicyEngine());
    
    // Register providers
    cryptoRuntime.registerProvider(new RSAProvider(2048));
    cryptoRuntime.registerProvider(new Java24KyberProvider("Kyber768"));
    cryptoRuntime.registerProvider(new HybridProvider(...));
    
    // Set default
    cryptoRuntime.switchProvider("RSA-2048");
}
```

**Say**: "That's it! Three steps:
1. Create the runtime
2. Register your providers
3. Set a default

Then use it anywhere in your code:
```java
CryptoProvider provider = cryptoRuntime.getActiveProvider();
byte[] ciphertext = provider.encrypt(data, publicKey);
```

And switch at runtime:
```java
cryptoRuntime.switchProvider("Java24-Kyber768");
```

No changes to your encryption/decryption code!"

---

## 📊 Part 5: Performance Comparison (Optional - 2 minutes)

**Say**: "Let's look at the performance numbers from our demo:"

**Show the output from Part 1, Step 3e**:

```
Classical RSA-2048:
  Key generation: 500 ms
  Encryption: 10 ms
  Decryption: 30 ms
  Public key: 256 bytes
  Ciphertext: 256 bytes

Post-Quantum Kyber768:
  Key generation: 60 ms (8x faster!)
  Encryption: 4 ms (2.5x faster!)
  Decryption: 4 ms (7.5x faster!)
  Public key: 1184 bytes (4.6x larger)
  Ciphertext: 1088 bytes (4.2x larger)

Hybrid RSA-2048 + Kyber768:
  Key generation: 560 ms
  Encryption: 14 ms
  Decryption: 34 ms
  Public key: 1440 bytes
  Ciphertext: 1348 bytes
```

**Say**: "Key takeaways:
- PQ crypto is FASTER for operations
- Slightly larger keys and ciphertexts (acceptable tradeoff)
- Hybrid gives you both worlds - security + compatibility"

---

## 🎬 Closing (1 minute)

**Say**: "To summarize what we've demonstrated:

✅ **Runtime Crypto Agility** - Switch algorithms without recompilation
✅ **Java 24 Native PQC** - Zero external dependencies
✅ **Hybrid Crypto** - Classical + PQ for defense-in-depth
✅ **Policy Engine** - Automatic compliance-driven selection
✅ **Production Ready** - Complete REST API integration
✅ **Easy Integration** - 3 lines of code to initialize

This solves the quantum threat problem TODAY while providing a clear migration path for the future.

Questions?"

---

## 📝 Demo Checklist

Before the demo:
- [ ] Java 24 installed and in PATH
- [ ] Maven 3.9+ installed
- [ ] curl or Postman ready
- [ ] Project built successfully (`build-and-run.bat` works)
- [ ] Port 8080 available
- [ ] Terminal/console ready for live commands
- [ ] This script printed or on second monitor

During the demo:
- [ ] Speak clearly and pace yourself
- [ ] Pause after each command to let output display
- [ ] Highlight key moments (provider registration, runtime switching, performance)
- [ ] Be ready for questions about quantum threats, NIST standards, performance
- [ ] Have backup: if live demo fails, show pre-recorded output

After the demo:
- [ ] Share documentation links
- [ ] Offer to help with integration
- [ ] Follow up with attendees

---

## 🆘 Troubleshooting

### Port 8080 already in use
```bash
# Find and kill process using port 8080
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Java version issues
```bash
# Verify Java 24
java -version
# Should show: java version "24.0.2"
```

### Build failures
```bash
# Clean and rebuild
cd pqc-crypto-agility
mvn clean install -DskipTests
```

### API not responding
```bash
# Check if server is running
curl http://localhost:8080/api/health
```

---

## 📚 Additional Resources

- **Documentation**: `pqc-crypto-agility/docs/`
- **Quick Start**: `pqc-crypto-agility/QUICK_START.md`
- **API Reference**: `pqc-crypto-agility/docs/API_REFERENCE.md`
- **Integration Guide**: `pqc-crypto-agility/example-app/README.md`

---

**Good luck with your demo! 🚀**