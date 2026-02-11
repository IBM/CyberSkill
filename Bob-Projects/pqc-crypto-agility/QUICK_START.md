# Quick Start Guide

Get up and running with the Post-Quantum Crypto Agility Runtime in 5 minutes.

## Prerequisites

1. **Java 17+**
   ```bash
   java -version
   ```

2. **Maven 3.6+**
   ```bash
   mvn -version
   ```

3. **liboqs-java** (for Post-Quantum algorithms)
   - Download from: https://github.com/open-quantum-safe/liboqs-java
   - Or use the pre-built JAR in the Maven dependency

## Installation

### Step 1: Clone and Build

```bash
cd pqc-crypto-agility
mvn clean package
```

This creates:
- `target/pqc-crypto-agility-1.0.0.jar` - Library JAR
- `target/pqc-crypto-agility-1.0.0-fat.jar` - Executable demo with dependencies

### Step 2: Run the Demo

```bash
java -jar target/pqc-crypto-agility-1.0.0-fat.jar
```

You should see output demonstrating:
- Policy-based provider selection
- Runtime switching between algorithms
- Hybrid classical + PQ crypto
- Threat model evaluation
- Performance comparisons

## Basic Usage

### 1. Initialize the Runtime

```java
import com.pqc.agility.*;
import com.pqc.agility.policy.*;
import com.pqc.agility.providers.*;

// Create policy engine and runtime
PolicyEngine policyEngine = new PolicyEngine();
CryptoAgilityRuntime runtime = new CryptoAgilityRuntime(policyEngine);
```

### 2. Register Providers

```java
// Classical crypto
runtime.registerProvider(new RSAProvider(2048));

// Post-Quantum crypto
runtime.registerProvider(new KyberProvider("Kyber768"));

// Hybrid (classical + PQ)
runtime.registerProvider(new HybridProvider(
    new RSAProvider(2048),
    new KyberProvider("Kyber768")
));
```

### 3. Select Provider Based on Threat Model

```java
// Automatic selection based on threat model
CryptoProvider provider = runtime.selectProvider(ThreatModel.QUANTUM_SAFE);

System.out.println("Selected: " + provider.getAlgorithmName());
System.out.println("Quantum-safe: " + provider.isQuantumSafe());
```

### 4. Use the Provider

```java
// Generate key pair
KeyPair keyPair = provider.generateKeyPair();

// Encapsulate shared secret (KEM)
EncapsulationResult result = provider.encapsulate(keyPair.getPublic());
byte[] ciphertext = result.getCiphertext();
byte[] sharedSecret = result.getSharedSecret();

// Decapsulate to recover shared secret
byte[] recoveredSecret = provider.decapsulate(ciphertext, keyPair.getPrivate());

// Verify
assert Arrays.equals(sharedSecret, recoveredSecret);
```

### 5. Switch Providers at Runtime

```java
// Start with RSA
runtime.switchProvider("RSA-2048");
// ... perform operations ...

// Switch to Kyber without restarting
runtime.switchProvider("Kyber768");
// ... continue with new provider ...
```

## Common Scenarios

### Scenario 1: Financial Application (High Security)

```java
ThreatModel financial = new ThreatModel.Builder()
    .name("financial-app")
    .threatLevel(ThreatModel.ThreatLevel.HIGH)
    .quantumThreat(true)
    .harvestNowDecryptLater(true)
    .dataLifetimeYears(20)
    .compliance(ThreatModel.ComplianceRequirement.PCI_DSS)
    .build();

CryptoProvider provider = runtime.selectProvider(financial);
// Runtime selects hybrid or PQ provider automatically
```

### Scenario 2: IoT Device (Performance-Constrained)

```java
ThreatModel iot = new ThreatModel.Builder()
    .name("iot-device")
    .threatLevel(ThreatModel.ThreatLevel.MEDIUM)
    .dataLifetimeYears(3)
    .build();

CryptoProvider provider = runtime.selectProvider(iot);
// Runtime selects faster classical crypto
```

### Scenario 3: Government Communications (Maximum Security)

```java
CryptoProvider provider = runtime.selectProvider(ThreatModel.GOVERNMENT);
// Automatically uses quantum-safe hybrid crypto with CNSA 2.0 compliance
```

## Enable Automatic Failover

```java
// Enable failover for resilience
runtime.setFailoverEnabled(true);

try {
    result = provider.encapsulate(publicKey);
} catch (CryptoException e) {
    // Runtime automatically failed over to alternative provider
    CryptoProvider fallback = runtime.getActiveProvider();
    System.out.println("Failed over to: " + fallback.getAlgorithmName());
}
```

## Check Runtime Status

```java
CryptoAgilityRuntime.RuntimeStats stats = runtime.getStats();
System.out.println("Total providers: " + stats.getTotalProviders());
System.out.println("Available providers: " + stats.getAvailableProviders());
System.out.println("Active provider: " + stats.getActiveProvider());
System.out.println("Failover enabled: " + stats.isFailoverEnabled());
```

## Performance Comparison

```java
for (CryptoProvider p : runtime.getAvailableProviders()) {
    PerformanceMetrics metrics = p.getPerformanceMetrics();
    System.out.printf("%s: KeyGen=%dms, Encrypt=%dms, PubKey=%d bytes%n",
        p.getAlgorithmName(),
        metrics.getKeyGenTimeMs(),
        metrics.getEncryptTimeMs(),
        metrics.getPublicKeySize()
    );
}
```

## Integration with Your Application

### Maven Dependency

Add to your `pom.xml`:

```xml
<dependency>
    <groupId>com.pqc</groupId>
    <artifactId>pqc-crypto-agility</artifactId>
    <version>1.0.0</version>
</dependency>
```

### Drop-in Replacement

The runtime is designed as a drop-in replacement for standard Java crypto:

```java
// Before (standard Java crypto)
KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
keyGen.initialize(2048);
KeyPair keyPair = keyGen.generateKeyPair();

// After (crypto agility runtime)
CryptoProvider provider = runtime.getActiveProvider();
KeyPair keyPair = provider.generateKeyPair();
// Provider can be switched at runtime based on policy!
```

## Troubleshooting

### Issue: liboqs not found

**Solution**: Ensure liboqs-java is in your classpath:
```bash
export LD_LIBRARY_PATH=/path/to/liboqs/lib:$LD_LIBRARY_PATH
```

### Issue: Provider not available

**Solution**: Check provider availability:
```java
if (!provider.isAvailable()) {
    System.out.println("Provider not available: " + provider.getAlgorithmName());
    // Use alternative provider
}
```

### Issue: Performance too slow

**Solution**: Use performance metrics to select faster providers:
```java
CryptoPolicy policy = new CryptoPolicy.Builder()
    .maxKeyGenTimeMs(1000)  // Max 1 second for key generation
    .maxEncryptTimeMs(100)   // Max 100ms for encryption
    .build();
```

## Next Steps

1. **Read the full README**: `README.md`
2. **Explore the demo**: `src/main/java/com/pqc/agility/demo/CryptoAgilityDemo.java`
3. **Review provider implementations**: `src/main/java/com/pqc/agility/providers/`
4. **Customize threat models**: `src/main/java/com/pqc/agility/policy/ThreatModel.java`
5. **Add your own providers**: Implement the `CryptoProvider` interface

## Support

- **Issues**: Open an issue on GitHub
- **Documentation**: See `README.md` for full API reference
- **Examples**: Check the demo application for comprehensive examples

---

**Ready to build quantum-safe applications! 🚀**