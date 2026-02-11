# PQC Crypto Agility Example Application

A complete REST API application demonstrating how to integrate the **PQC Crypto Agility Runtime** into your existing applications.

## 🎯 What This Demonstrates

This example shows you how to:

1. **Initialize the crypto runtime** in your application startup
2. **Switch cryptographic providers at runtime** via API calls
3. **Encrypt/decrypt data** using different algorithms dynamically
4. **Use policy-based provider selection** based on threat models
5. **Monitor and manage** cryptographic operations
6. **Integrate with existing REST APIs** without code changes

## 🚀 Quick Start

### Prerequisites

- Java 24 (required for native ML-KEM support)
- Maven 3.9+
- Parent crypto agility runtime built

### Build and Run

```bash
# From the example-app directory
cd example-app

# Build the application
mvn clean package

# Run the server
java -jar target/pqc-example-app-1.0.0-fat.jar
```

The server will start on `http://localhost:8080`

## 📚 API Documentation

Visit `http://localhost:8080/api/docs` for interactive API documentation.

### Key Endpoints

#### Provider Management

**List all providers:**
```bash
curl http://localhost:8080/api/providers
```

**Get active provider:**
```bash
curl http://localhost:8080/api/providers/active
```

**Switch provider at runtime:**
```bash
curl -X POST http://localhost:8080/api/providers/switch \
  -H 'Content-Type: application/json' \
  -d '{"providerId":"Java24-Kyber768"}'
```

**Select provider by policy:**
```bash
curl -X POST http://localhost:8080/api/providers/select-by-policy \
  -H 'Content-Type: application/json' \
  -d '{"threatModel":"quantum-safe"}'
```

#### Cryptographic Operations

**Generate keys:**
```bash
curl -X POST http://localhost:8080/api/crypto/generate-keys
```

**Encrypt data:**
```bash
curl -X POST http://localhost:8080/api/crypto/encrypt \
  -H 'Content-Type: application/json' \
  -d '{"data":"Hello, World!", "sessionId":"session-123"}'
```

**Decrypt data:**
```bash
curl -X POST http://localhost:8080/api/crypto/decrypt \
  -H 'Content-Type: application/json' \
  -d '{"ciphertext":"<base64-encoded>", "sessionId":"session-123"}'
```

#### Monitoring

**Get statistics:**
```bash
curl http://localhost:8080/api/stats
```

**Health check:**
```bash
curl http://localhost:8080/api/health
```

## 💡 Integration Guide

### Step 1: Add Dependency

Add the crypto agility runtime to your `pom.xml`:

```xml
<dependency>
    <groupId>com.pqc</groupId>
    <artifactId>pqc-crypto-agility</artifactId>
    <version>1.0.0</version>
</dependency>
```

### Step 2: Initialize Runtime

In your application startup code:

```java
import com.pqc.agility.CryptoAgilityRuntime;
import com.pqc.agility.providers.*;

public class YourApplication {
    private CryptoAgilityRuntime cryptoRuntime;
    
    public void initialize() {
        cryptoRuntime = new CryptoAgilityRuntime();
        
        // Register providers
        cryptoRuntime.registerProvider(new RSAProvider(2048));
        cryptoRuntime.registerProvider(new Java24KyberProvider(
            Java24KyberProvider.SecurityLevel.KYBER768));
        cryptoRuntime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new Java24KyberProvider(Java24KyberProvider.SecurityLevel.KYBER768)
        ));
        
        // Set default
        cryptoRuntime.switchProvider("RSA-2048");
    }
}
```

### Step 3: Use in Your Code

```java
// Get active provider
CryptoProvider provider = cryptoRuntime.getActiveProvider();

// Generate keys
KeyPair keyPair = provider.generateKeyPair();

// Encrypt
byte[] plaintext = "Secret data".getBytes();
byte[] ciphertext = provider.encrypt(plaintext, keyPair.getPublic());

// Decrypt
byte[] decrypted = provider.decrypt(ciphertext, keyPair.getPrivate());

// Switch provider at runtime (no recompilation needed!)
cryptoRuntime.switchProvider("Java24-Kyber768");
```

### Step 4: Policy-Based Selection

```java
import com.pqc.agility.policy.ThreatModel;

// Automatically select provider based on threat model
CryptoProvider provider = cryptoRuntime.selectProviderByPolicy(
    ThreatModel.QUANTUM_SAFE
);

// The runtime will choose the best provider for your security requirements
```

## 🔐 Use Cases

### 1. Gradual Migration to PQC

Start with classical crypto, gradually migrate to quantum-safe:

```bash
# Start with RSA
curl -X POST http://localhost:8080/api/providers/switch \
  -d '{"providerId":"RSA-2048"}'

# Later, switch to hybrid (classical + PQ)
curl -X POST http://localhost:8080/api/providers/switch \
  -d '{"providerId":"Hybrid-RSA-2048-Java24-Kyber768"}'

# Finally, pure PQ
curl -X POST http://localhost:8080/api/providers/switch \
  -d '{"providerId":"Java24-Kyber768"}'
```

### 2. Environment-Based Selection

```java
// Development: Fast classical crypto
if (environment.equals("dev")) {
    cryptoRuntime.switchProvider("RSA-2048");
}

// Production: Quantum-safe hybrid
if (environment.equals("prod")) {
    cryptoRuntime.switchProvider("Hybrid-RSA-4096-Java24-Kyber1024");
}
```

### 3. Compliance-Driven Selection

```java
// Financial services: PCI-DSS compliant
CryptoProvider provider = cryptoRuntime.selectProviderByPolicy(
    ThreatModel.FINANCIAL_SERVICES
);

// Government: CNSA 2.0 compliant
provider = cryptoRuntime.selectProviderByPolicy(
    ThreatModel.GOVERNMENT
);
```

### 4. A/B Testing Crypto Algorithms

```java
// Test performance of different algorithms
if (userId % 2 == 0) {
    cryptoRuntime.switchProvider("RSA-2048");
} else {
    cryptoRuntime.switchProvider("Java24-Kyber768");
}
```

## 📊 Example Workflow

```bash
# 1. Start server
java -jar target/pqc-example-app-1.0.0-fat.jar

# 2. Check available providers
curl http://localhost:8080/api/providers

# 3. Generate keys with default provider (RSA-2048)
curl -X POST http://localhost:8080/api/crypto/generate-keys
# Response: {"sessionId":"session-1738777200000",...}

# 4. Encrypt data
curl -X POST http://localhost:8080/api/crypto/encrypt \
  -H 'Content-Type: application/json' \
  -d '{"data":"Sensitive information", "sessionId":"session-1738777200000"}'
# Response: {"ciphertext":"<base64>",...}

# 5. Switch to quantum-safe provider
curl -X POST http://localhost:8080/api/providers/switch \
  -d '{"providerId":"Java24-Kyber768"}'

# 6. Generate new keys with PQ crypto
curl -X POST http://localhost:8080/api/crypto/generate-keys
# Response: {"sessionId":"session-1738777300000",...}

# 7. Encrypt with quantum-safe algorithm
curl -X POST http://localhost:8080/api/crypto/encrypt \
  -H 'Content-Type: application/json' \
  -d '{"data":"Quantum-safe data", "sessionId":"session-1738777300000"}'

# 8. Check statistics
curl http://localhost:8080/api/stats
```

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│     Your REST API Application       │
│  (SecureApiServer.java - this file) │
└──────────────┬──────────────────────┘
               │
               │ Uses
               ▼
┌─────────────────────────────────────┐
│   PQC Crypto Agility Runtime        │
│  - Provider Registry                │
│  - Policy Engine                    │
│  - Failover Manager                 │
└──────────────┬──────────────────────┘
               │
               │ Manages
               ▼
┌─────────────────────────────────────┐
│     Cryptographic Providers         │
│  - RSAProvider (classical)          │
│  - Java24KyberProvider (PQ)         │
│  - HybridProvider (classical + PQ)  │
└─────────────────────────────────────┘
```

## 🔧 Configuration

The runtime is configured programmatically in `SecureApiServer.java`:

```java
private void initializeCryptoRuntime() {
    cryptoRuntime = new CryptoAgilityRuntime();
    
    // Register your providers
    cryptoRuntime.registerProvider(new RSAProvider(2048));
    cryptoRuntime.registerProvider(new Java24KyberProvider(...));
    
    // Set default
    cryptoRuntime.switchProvider("RSA-2048");
}
```

## 📈 Performance Comparison

Query the `/api/stats` endpoint to see provider performance:

```json
{
  "totalProviders": 7,
  "activeProvider": "Java24-Kyber768",
  "activeSessions": 2,
  "quantumSafeProviders": 5
}
```

## 🛡️ Security Considerations

1. **Session Management**: Keys are stored in memory per session
2. **Provider Switching**: Can be done at runtime without downtime
3. **Quantum Safety**: Use `Java24-Kyber*` or `Hybrid-*` providers
4. **Compliance**: Use policy-based selection for automatic compliance

## 🚨 Common Issues

### Issue: "Provider not found"
**Solution**: Check available providers with `/api/providers`

### Issue: "Session not found"
**Solution**: Generate keys first with `/api/crypto/generate-keys`

### Issue: "Decryption failed"
**Solution**: Ensure you're using the same provider that encrypted the data

## 📝 Next Steps

1. **Customize providers**: Add your own cryptographic providers
2. **Add persistence**: Store keys in a database instead of memory
3. **Add authentication**: Secure the API endpoints
4. **Add metrics**: Track provider usage and performance
5. **Add caching**: Cache frequently used keys

## 🔗 Related Documentation

- [Main Crypto Agility Runtime](../README.md)
- [Provider Guide](../docs/PROVIDER_GUIDE.md)
- [Policy Engine](../docs/POLICY_ENGINE.md)
- [Java 24 PQC](../docs/JAVA24_PQC.md)

## 📄 License

Same as parent project.