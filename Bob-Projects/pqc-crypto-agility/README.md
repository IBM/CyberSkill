# Post-Quantum Crypto Agility Runtime

A drop-in runtime that lets applications switch cryptographic primitives at runtime (not compile time) based on policy, threat model, or handshake negotiation.

## 🎯 Key Features

- **Runtime Crypto Switching**: Change cryptographic algorithms on-the-fly without recompilation
- **Policy-Based Selection**: Automatically select crypto based on threat models and compliance requirements
- **Hybrid Classical + PQ**: Combine classical and post-quantum algorithms for defense-in-depth
- **Live Failover**: Automatic failover to alternative providers if one fails
- **Harvest Now, Decrypt Later Defense**: Protect against quantum threats to long-lived data
- **Multiple Provider Support**: RSA, ECDSA, Kyber, Dilithium, SPHINCS+, and hybrid combinations

## 🚀 Quick Start

### Prerequisites

- Java 17 or higher
- Maven 3.6+
- liboqs-java (for post-quantum algorithms)

### Installation

```bash
git clone <repository-url>
cd pqc-crypto-agility
mvn clean package
```

### Basic Usage

```java
// Initialize runtime with policy engine
PolicyEngine policyEngine = new PolicyEngine();
CryptoAgilityRuntime runtime = new CryptoAgilityRuntime(policyEngine);

// Register providers
runtime.registerProvider(new RSAProvider(2048));
runtime.registerProvider(new KyberProvider("Kyber768"));
runtime.registerProvider(new HybridProvider(
    new RSAProvider(2048),
    new KyberProvider("Kyber768")
));

// Select provider based on threat model
CryptoProvider provider = runtime.selectProvider(ThreatModel.QUANTUM_SAFE);

// Use the provider
KeyPair keyPair = provider.generateKeyPair();
EncapsulationResult result = provider.encapsulate(keyPair.getPublic());
byte[] sharedSecret = provider.decapsulate(result.getCiphertext(), keyPair.getPrivate());
```

## 🏗️ Architecture

### Core Components

1. **CryptoProvider Interface**: Abstract interface for all cryptographic providers
2. **CryptoAgilityRuntime**: Main runtime managing provider selection and switching
3. **PolicyEngine**: Evaluates threat models and generates crypto policies
4. **Provider Implementations**:
   - `RSAProvider`: Classical RSA encryption and signatures
   - `KyberProvider`: Post-quantum KEM (NIST standardized)
   - `HybridProvider`: Combines classical + PQ for maximum security

### Provider Types

- **CLASSICAL**: Traditional algorithms (RSA, ECDSA, AES)
- **POST_QUANTUM**: Quantum-resistant algorithms (Kyber, Dilithium, SPHINCS+)
- **HYBRID**: Combination of classical and PQ for defense-in-depth

## 📊 Threat Models

### Predefined Threat Models

```java
// Low security - short-lived data
ThreatModel.LOW_SECURITY

// Standard security - typical applications
ThreatModel.STANDARD

// High security - sensitive data
ThreatModel.HIGH_SECURITY

// Quantum-safe - protection against quantum computers
ThreatModel.QUANTUM_SAFE

// Government - highest security with compliance
ThreatModel.GOVERNMENT
```

### Custom Threat Models

```java
ThreatModel customThreat = new ThreatModel.Builder()
    .name("financial-services")
    .threatLevel(ThreatModel.ThreatLevel.HIGH)
    .quantumThreat(true)
    .harvestNowDecryptLater(true)
    .dataLifetimeYears(15)
    .compliance(ThreatModel.ComplianceRequirement.PCI_DSS)
    .build();
```

## 🔄 Runtime Switching

### Policy-Based Switching

```java
// Runtime automatically selects best provider
CryptoProvider provider = runtime.selectProvider(threatModel);
```

### Manual Switching

```java
// Switch to specific provider by name
runtime.switchProvider("Kyber768");
```

### Automatic Failover

```java
// Enable automatic failover
runtime.setFailoverEnabled(true);

// If active provider fails, runtime automatically switches to alternative
try {
    result = provider.encapsulate(publicKey);
} catch (CryptoException e) {
    // Runtime has already failed over to alternative provider
    provider = runtime.getActiveProvider();
}
```

## 🛡️ Hybrid Cryptography

Hybrid mode combines classical and post-quantum algorithms for maximum security:

```java
HybridProvider hybrid = new HybridProvider(
    new RSAProvider(4096),      // Classical component
    new KyberProvider("Kyber1024") // PQ component
);

// Both algorithms must succeed for operations to complete
// Provides security if EITHER algorithm remains unbroken
KeyPair keyPair = hybrid.generateKeyPair();
EncapsulationResult result = hybrid.encapsulate(keyPair.getPublic());
```

### Hybrid Benefits

- **Defense-in-Depth**: Secure if either classical OR PQ algorithm is unbroken
- **Transition Safety**: Migrate to PQ without abandoning proven classical crypto
- **Live Failover**: Automatically falls back if one component fails

## 📈 Performance Metrics

Each provider exposes performance metrics:

```java
PerformanceMetrics metrics = provider.getPerformanceMetrics();
System.out.println("Key generation: " + metrics.getKeyGenTimeMs() + " ms");
System.out.println("Encryption: " + metrics.getEncryptTimeMs() + " ms");
System.out.println("Public key size: " + metrics.getPublicKeySize() + " bytes");
```

### Typical Performance (approximate)

| Provider | Key Gen | Encrypt | Decrypt | Public Key | Ciphertext |
|----------|---------|---------|---------|------------|------------|
| RSA-2048 | 500ms | 10ms | 30ms | 256 bytes | 256 bytes |
| RSA-4096 | 2000ms | 10ms | 100ms | 512 bytes | 512 bytes |
| Kyber512 | 50ms | 5ms | 5ms | 800 bytes | 768 bytes |
| Kyber768 | 80ms | 5ms | 5ms | 1184 bytes | 1088 bytes |
| Kyber1024 | 120ms | 5ms | 5ms | 1568 bytes | 1568 bytes |
| Hybrid | Sum of both | Sum | Sum | Sum | Sum |

## 🔐 Security Considerations

### Quantum Threat Timeline

- **2030-2035**: Cryptographically relevant quantum computers may emerge
- **Harvest Now, Decrypt Later**: Adversaries collect encrypted data today to decrypt with future quantum computers
- **Data Lifetime**: Consider how long your data needs to remain confidential

### Compliance Requirements

The runtime supports various compliance standards:

- **FIPS 140-2/140-3**: Federal cryptographic standards
- **CNSA 2.0**: NSA's Commercial National Security Algorithm Suite
- **PCI DSS**: Payment card industry standards
- **HIPAA**: Healthcare data protection
- **GDPR**: European data privacy

## 🧪 Running the Demo

```bash
# Build the project
mvn clean package

# Run the demo
java -jar target/pqc-crypto-agility-1.0.0-fat.jar
```

The demo showcases:
1. Policy-based provider selection
2. Runtime provider switching
3. Hybrid crypto with failover
4. Threat model evaluation
5. Performance comparison

## 📚 API Reference

### CryptoProvider Interface

```java
String getAlgorithmName();
ProviderType getProviderType();
int getSecurityLevel();
KeyPair generateKeyPair() throws CryptoException;
byte[] encrypt(byte[] data, PublicKey publicKey) throws CryptoException;
byte[] decrypt(byte[] encryptedData, PrivateKey privateKey) throws CryptoException;
byte[] sign(byte[] data, PrivateKey privateKey) throws CryptoException;
boolean verify(byte[] data, byte[] signature, PublicKey publicKey) throws CryptoException;
EncapsulationResult encapsulate(PublicKey publicKey) throws CryptoException;
byte[] decapsulate(byte[] ciphertext, PrivateKey privateKey) throws CryptoException;
boolean isQuantumSafe();
boolean supportsKEM();
```

### CryptoAgilityRuntime

```java
void registerProvider(CryptoProvider provider);
CryptoProvider selectProvider(ThreatModel threatModel);
CryptoProvider getActiveProvider();
boolean switchProvider(String providerName);
CryptoProvider failover(Exception cause);
void setFailoverEnabled(boolean enabled);
List<CryptoProvider> getAllProviders();
List<CryptoProvider> getAvailableProviders();
RuntimeStats getStats();
```

## 🎓 Use Cases

### 1. Financial Services
```java
ThreatModel financial = new ThreatModel.Builder()
    .threatLevel(ThreatModel.ThreatLevel.HIGH)
    .quantumThreat(true)
    .dataLifetimeYears(20)
    .compliance(ThreatModel.ComplianceRequirement.PCI_DSS)
    .build();
```

### 2. Healthcare Data
```java
ThreatModel healthcare = new ThreatModel.Builder()
    .threatLevel(ThreatModel.ThreatLevel.HIGH)
    .dataLifetimeYears(30)
    .compliance(ThreatModel.ComplianceRequirement.HIPAA)
    .build();
```

### 3. Government Communications
```java
ThreatModel government = ThreatModel.GOVERNMENT;
// Automatically selects quantum-safe hybrid crypto
```

### 4. IoT Devices (Performance-Constrained)
```java
ThreatModel iot = new ThreatModel.Builder()
    .threatLevel(ThreatModel.ThreatLevel.MEDIUM)
    .dataLifetimeYears(5)
    .build();
// Selects faster classical crypto for resource-constrained devices
```

## 🔧 Configuration

### Logging

Configure logging in `src/main/resources/logback.xml`:

```xml
<logger name="com.pqc.agility" level="INFO"/>
```

### Provider Registration

Register only the providers you need:

```java
// Minimal setup - classical only
runtime.registerProvider(new RSAProvider(2048));

// Quantum-safe setup
runtime.registerProvider(new KyberProvider("Kyber768"));

// Maximum security - hybrid
runtime.registerProvider(new HybridProvider(
    new RSAProvider(4096),
    new KyberProvider("Kyber1024")
));
```

## 🤝 Contributing

Contributions welcome! Areas for improvement:

- Additional provider implementations (Dilithium, SPHINCS+, Falcon)
- Handshake negotiation protocol
- Configuration file support
- Additional compliance standards
- Performance optimizations

## 📄 License

[Your License Here]

## 🙏 Acknowledgments

- **liboqs**: Open Quantum Safe project for PQ implementations
- **Bouncy Castle**: Comprehensive cryptography library
- **NIST**: Post-Quantum Cryptography standardization

## 📞 Support

For issues, questions, or contributions, please open an issue on GitHub.

---

**Built with ❤️ for a quantum-safe future**