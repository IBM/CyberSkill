# Migration Examples - Drop-In Integration Guide

This guide shows how to integrate the Crypto Agility Runtime into existing applications with minimal code changes.

## Table of Contents
1. [Basic Key Exchange Migration](#1-basic-key-exchange-migration)
2. [REST API Encryption](#2-rest-api-encryption)
3. [Database Encryption](#3-database-encryption)
4. [File Encryption Service](#4-file-encryption-service)
5. [Messaging System](#5-messaging-system)
6. [Session Management](#6-session-management)
7. [Spring Boot Integration](#7-spring-boot-integration)

---

## 1. Basic Key Exchange Migration

### Before (Standard Java Crypto)

```java
public class KeyExchangeService {
    public byte[] generateSharedSecret(PublicKey peerPublicKey) throws Exception {
        // Generate ephemeral key pair
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair keyPair = keyGen.generateKeyPair();
        
        // Encrypt random secret with peer's public key
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, peerPublicKey);
        
        byte[] secret = new byte[32];
        new SecureRandom().nextBytes(secret);
        
        return cipher.doFinal(secret);
    }
}
```

### After (Crypto Agility Runtime)

```java
public class KeyExchangeService {
    private final CryptoAgilityRuntime runtime;
    
    public KeyExchangeService() {
        // One-time setup
        PolicyEngine policyEngine = new PolicyEngine();
        this.runtime = new CryptoAgilityRuntime(policyEngine);
        
        // Register providers once
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new KyberProvider("Kyber768"));
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new KyberProvider("Kyber768")
        ));
        
        // Select based on security requirements
        runtime.selectProvider(ThreatModel.QUANTUM_SAFE);
    }
    
    public byte[] generateSharedSecret(PublicKey peerPublicKey) throws CryptoException {
        // Same interface, quantum-safe crypto!
        CryptoProvider provider = runtime.getActiveProvider();
        EncapsulationResult result = provider.encapsulate(peerPublicKey);
        return result.getCiphertext();
    }
    
    // Switch providers at runtime without restart
    public void upgradeToQuantumSafe() {
        runtime.switchProvider("Hybrid-RSA-2048-Kyber768");
    }
}
```

**Key Changes:**
- ✅ Initialize runtime once in constructor
- ✅ Replace `KeyPairGenerator` with `runtime.getActiveProvider()`
- ✅ Use `encapsulate()` instead of manual encryption
- ✅ Can switch providers at runtime!

---

## 2. REST API Encryption

### Before (Manual Encryption)

```java
@RestController
public class SecureApiController {
    
    @PostMapping("/api/secure-data")
    public ResponseEntity<EncryptedResponse> sendSecureData(@RequestBody DataRequest request) 
            throws Exception {
        // Hard-coded RSA encryption
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
        keyGen.initialize(2048);
        KeyPair keyPair = keyGen.generateKeyPair();
        
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, keyPair.getPublic());
        
        byte[] encrypted = cipher.doFinal(request.getData().getBytes());
        
        return ResponseEntity.ok(new EncryptedResponse(encrypted, keyPair.getPublic()));
    }
}
```

### After (Crypto Agility)

```java
@RestController
public class SecureApiController {
    private final CryptoAgilityRuntime runtime;
    
    @Autowired
    public SecureApiController(CryptoAgilityRuntime runtime) {
        this.runtime = runtime;
    }
    
    @PostMapping("/api/secure-data")
    public ResponseEntity<EncryptedResponse> sendSecureData(@RequestBody DataRequest request) 
            throws CryptoException {
        // Provider selected based on policy
        CryptoProvider provider = runtime.getActiveProvider();
        KeyPair keyPair = provider.generateKeyPair();
        
        // Same encryption interface
        EncapsulationResult result = provider.encapsulate(keyPair.getPublic());
        
        return ResponseEntity.ok(new EncryptedResponse(
            result.getCiphertext(), 
            keyPair.getPublic(),
            provider.getAlgorithmName() // Client knows which algorithm was used
        ));
    }
    
    // Admin endpoint to upgrade security
    @PostMapping("/admin/upgrade-crypto")
    public ResponseEntity<String> upgradeCrypto(@RequestParam String algorithm) {
        if (runtime.switchProvider(algorithm)) {
            return ResponseEntity.ok("Switched to " + algorithm);
        }
        return ResponseEntity.badRequest().body("Provider not available");
    }
}
```

**Spring Configuration:**

```java
@Configuration
public class CryptoConfig {
    
    @Bean
    public CryptoAgilityRuntime cryptoRuntime() {
        PolicyEngine policyEngine = new PolicyEngine();
        CryptoAgilityRuntime runtime = new CryptoAgilityRuntime(policyEngine);
        
        // Register all providers
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new KyberProvider("Kyber768"));
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new KyberProvider("Kyber768")
        ));
        
        // Start with quantum-safe by default
        runtime.selectProvider(ThreatModel.QUANTUM_SAFE);
        
        return runtime;
    }
}
```

---

## 3. Database Encryption

### Before (Fixed AES Encryption)

```java
public class DatabaseEncryptionService {
    private static final String ALGORITHM = "AES/GCM/NoPadding";
    private final SecretKey secretKey;
    
    public byte[] encryptField(String data) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        return cipher.doFinal(data.getBytes());
    }
    
    public String decryptField(byte[] encrypted) throws Exception {
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        return new String(cipher.doFinal(encrypted));
    }
}
```

### After (Crypto Agility with Key Wrapping)

```java
public class DatabaseEncryptionService {
    private final CryptoAgilityRuntime runtime;
    private final KeyPair masterKeyPair;
    
    public DatabaseEncryptionService(CryptoAgilityRuntime runtime) {
        this.runtime = runtime;
        
        // Generate master key pair once
        try {
            this.masterKeyPair = runtime.getActiveProvider().generateKeyPair();
        } catch (CryptoException e) {
            throw new RuntimeException("Failed to initialize encryption", e);
        }
    }
    
    public EncryptedData encryptField(String data) throws CryptoException {
        CryptoProvider provider = runtime.getActiveProvider();
        
        // Generate data encryption key (DEK)
        EncapsulationResult result = provider.encapsulate(masterKeyPair.getPublic());
        byte[] dek = result.getSharedSecret();
        
        // Encrypt data with DEK (using AES-GCM)
        byte[] encrypted = encryptWithAES(data.getBytes(), dek);
        
        // Store wrapped DEK with encrypted data
        return new EncryptedData(
            encrypted,
            result.getCiphertext(), // Wrapped DEK
            provider.getAlgorithmName()
        );
    }
    
    public String decryptField(EncryptedData encryptedData) throws CryptoException {
        // Get provider that was used for encryption
        CryptoProvider provider = runtime.getProvider(encryptedData.getAlgorithm());
        if (provider == null) {
            provider = runtime.getActiveProvider(); // Fallback
        }
        
        // Unwrap DEK
        byte[] dek = provider.decapsulate(
            encryptedData.getWrappedKey(),
            masterKeyPair.getPrivate()
        );
        
        // Decrypt data
        byte[] decrypted = decryptWithAES(encryptedData.getData(), dek);
        return new String(decrypted);
    }
    
    private byte[] encryptWithAES(byte[] data, byte[] key) {
        // Standard AES-GCM encryption
        // ... implementation ...
    }
    
    private byte[] decryptWithAES(byte[] encrypted, byte[] key) {
        // Standard AES-GCM decryption
        // ... implementation ...
    }
}

// Store this in your database
class EncryptedData {
    private byte[] data;
    private byte[] wrappedKey;
    private String algorithm;
    
    // Getters, setters, constructors...
}
```

**JPA Entity Example:**

```java
@Entity
public class SecureRecord {
    @Id
    private Long id;
    
    @Lob
    private byte[] encryptedData;
    
    @Lob
    private byte[] wrappedKey;
    
    private String algorithm;
    
    // Transparent encryption/decryption
    @Transient
    private String plainData;
    
    @PostLoad
    private void decrypt() throws CryptoException {
        DatabaseEncryptionService service = getEncryptionService();
        EncryptedData encrypted = new EncryptedData(encryptedData, wrappedKey, algorithm);
        this.plainData = service.decryptField(encrypted);
    }
    
    @PrePersist
    @PreUpdate
    private void encrypt() throws CryptoException {
        DatabaseEncryptionService service = getEncryptionService();
        EncryptedData encrypted = service.encryptField(plainData);
        this.encryptedData = encrypted.getData();
        this.wrappedKey = encrypted.getWrappedKey();
        this.algorithm = encrypted.getAlgorithm();
    }
}
```

---

## 4. File Encryption Service

### Before (Simple File Encryption)

```java
public class FileEncryptionService {
    public void encryptFile(File input, File output, PublicKey publicKey) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey aesKey = keyGen.generateKey();
        
        // Encrypt file with AES
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        
        try (FileInputStream fis = new FileInputStream(input);
             FileOutputStream fos = new FileOutputStream(output)) {
            // ... encryption logic ...
        }
        
        // Wrap AES key with RSA
        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        rsaCipher.init(Cipher.WRAP_MODE, publicKey);
        byte[] wrappedKey = rsaCipher.wrap(aesKey);
        
        // Store wrapped key
        Files.write(new File(output + ".key").toPath(), wrappedKey);
    }
}
```

### After (Crypto Agility)

```java
public class FileEncryptionService {
    private final CryptoAgilityRuntime runtime;
    
    public FileEncryptionService(CryptoAgilityRuntime runtime) {
        this.runtime = runtime;
    }
    
    public void encryptFile(File input, File output, PublicKey publicKey) throws Exception {
        // Get current provider (could be RSA, Kyber, or Hybrid)
        CryptoProvider provider = runtime.getActiveProvider();
        
        // Generate file encryption key using KEM
        EncapsulationResult result = provider.encapsulate(publicKey);
        byte[] fileKey = result.getSharedSecret();
        
        // Encrypt file with AES (same as before)
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKeySpec keySpec = new SecretKeySpec(fileKey, 0, 32, "AES");
        aesCipher.init(Cipher.ENCRYPT_MODE, keySpec);
        
        try (FileInputStream fis = new FileInputStream(input);
             FileOutputStream fos = new FileOutputStream(output)) {
            // ... encryption logic (unchanged) ...
        }
        
        // Store wrapped key with algorithm info
        FileMetadata metadata = new FileMetadata(
            result.getCiphertext(),
            provider.getAlgorithmName(),
            System.currentTimeMillis()
        );
        
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(new File(output + ".meta"), metadata);
    }
    
    public void decryptFile(File input, File output, PrivateKey privateKey) throws Exception {
        // Read metadata
        ObjectMapper mapper = new ObjectMapper();
        FileMetadata metadata = mapper.readValue(
            new File(input + ".meta"), 
            FileMetadata.class
        );
        
        // Get the provider that was used
        CryptoProvider provider = runtime.getProvider(metadata.getAlgorithm());
        if (provider == null) {
            throw new CryptoException("Provider not available: " + metadata.getAlgorithm());
        }
        
        // Unwrap file key
        byte[] fileKey = provider.decapsulate(metadata.getWrappedKey(), privateKey);
        
        // Decrypt file (same as before)
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKeySpec keySpec = new SecretKeySpec(fileKey, 0, 32, "AES");
        aesCipher.init(Cipher.DECRYPT_MODE, keySpec);
        
        try (FileInputStream fis = new FileInputStream(input);
             FileOutputStream fos = new FileOutputStream(output)) {
            // ... decryption logic (unchanged) ...
        }
    }
    
    // Batch re-encryption to upgrade algorithm
    public void reencryptFile(File file, PublicKey newPublicKey) throws Exception {
        File temp = File.createTempFile("reencrypt", ".tmp");
        
        // Decrypt with old algorithm
        decryptFile(file, temp, getCurrentPrivateKey());
        
        // Switch to new algorithm
        runtime.switchProvider("Hybrid-RSA-2048-Kyber768");
        
        // Re-encrypt with new algorithm
        encryptFile(temp, file, newPublicKey);
        
        temp.delete();
    }
}
```

---

## 5. Messaging System

### Before (Fixed Encryption)

```java
public class MessageEncryption {
    public EncryptedMessage encryptMessage(String message, PublicKey recipientKey) 
            throws Exception {
        // Generate session key
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey sessionKey = keyGen.generateKey();
        
        // Encrypt message
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, sessionKey);
        byte[] encrypted = cipher.doFinal(message.getBytes());
        
        // Wrap session key
        Cipher rsaCipher = Cipher.getInstance("RSA");
        rsaCipher.init(Cipher.WRAP_MODE, recipientKey);
        byte[] wrappedKey = rsaCipher.wrap(sessionKey);
        
        return new EncryptedMessage(encrypted, wrappedKey);
    }
}
```

### After (Crypto Agility with Negotiation)

```java
public class MessageEncryption {
    private final CryptoAgilityRuntime runtime;
    
    public MessageEncryption(CryptoAgilityRuntime runtime) {
        this.runtime = runtime;
    }
    
    public EncryptedMessage encryptMessage(String message, PublicKey recipientKey,
                                          String recipientPreferredAlgorithm) 
            throws CryptoException {
        // Try to use recipient's preferred algorithm
        CryptoProvider provider = runtime.getProvider(recipientPreferredAlgorithm);
        if (provider == null || !provider.isAvailable()) {
            // Fallback to current active provider
            provider = runtime.getActiveProvider();
        }
        
        // Generate session key using KEM
        EncapsulationResult result = provider.encapsulate(recipientKey);
        byte[] sessionKey = result.getSharedSecret();
        
        // Encrypt message with AES (same as before)
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKeySpec keySpec = new SecretKeySpec(sessionKey, 0, 32, "AES");
        cipher.init(Cipher.ENCRYPT_MODE, keySpec);
        byte[] encrypted = cipher.doFinal(message.getBytes());
        
        return new EncryptedMessage(
            encrypted,
            result.getCiphertext(),
            provider.getAlgorithmName(),
            System.currentTimeMillis()
        );
    }
    
    public String decryptMessage(EncryptedMessage encryptedMessage, PrivateKey privateKey) 
            throws CryptoException {
        // Get provider that was used
        CryptoProvider provider = runtime.getProvider(encryptedMessage.getAlgorithm());
        if (provider == null) {
            // Try failover
            provider = runtime.failover(
                new CryptoException("Provider not available: " + encryptedMessage.getAlgorithm())
            );
        }
        
        // Unwrap session key
        byte[] sessionKey = provider.decapsulate(
            encryptedMessage.getWrappedKey(),
            privateKey
        );
        
        // Decrypt message
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            SecretKeySpec keySpec = new SecretKeySpec(sessionKey, 0, 32, "AES");
            cipher.init(Cipher.DECRYPT_MODE, keySpec);
            byte[] decrypted = cipher.doFinal(encryptedMessage.getData());
            return new String(decrypted);
        } catch (Exception e) {
            throw new CryptoException("Decryption failed", e);
        }
    }
    
    // Capability negotiation
    public List<String> getSupportedAlgorithms() {
        return runtime.getAvailableProviders().stream()
            .map(CryptoProvider::getAlgorithmName)
            .collect(Collectors.toList());
    }
}
```

---

## 6. Session Management

### Before (Fixed Session Keys)

```java
public class SessionManager {
    private final Map<String, SecretKey> sessions = new ConcurrentHashMap<>();
    
    public String createSession(String userId) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey sessionKey = keyGen.generateKey();
        
        String sessionId = UUID.randomUUID().toString();
        sessions.put(sessionId, sessionKey);
        
        return sessionId;
    }
}
```

### After (Crypto Agility)

```java
public class SessionManager {
    private final CryptoAgilityRuntime runtime;
    private final Map<String, SessionData> sessions = new ConcurrentHashMap<>();
    private final KeyPair serverKeyPair;
    
    public SessionManager(CryptoAgilityRuntime runtime) throws CryptoException {
        this.runtime = runtime;
        this.serverKeyPair = runtime.getActiveProvider().generateKeyPair();
    }
    
    public SessionInfo createSession(String userId, PublicKey clientPublicKey) 
            throws CryptoException {
        // Generate session key using current provider
        CryptoProvider provider = runtime.getActiveProvider();
        EncapsulationResult result = provider.encapsulate(clientPublicKey);
        
        String sessionId = UUID.randomUUID().toString();
        SessionData sessionData = new SessionData(
            result.getSharedSecret(),
            provider.getAlgorithmName(),
            System.currentTimeMillis()
        );
        
        sessions.put(sessionId, sessionData);
        
        return new SessionInfo(
            sessionId,
            result.getCiphertext(),
            provider.getAlgorithmName()
        );
    }
    
    public byte[] encryptSessionData(String sessionId, byte[] data) throws CryptoException {
        SessionData session = sessions.get(sessionId);
        if (session == null) {
            throw new CryptoException("Invalid session");
        }
        
        // Use session key for encryption
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            SecretKeySpec keySpec = new SecretKeySpec(session.getSessionKey(), 0, 32, "AES");
            cipher.init(Cipher.ENCRYPT_MODE, keySpec);
            return cipher.doFinal(data);
        } catch (Exception e) {
            throw new CryptoException("Encryption failed", e);
        }
    }
    
    // Upgrade all sessions to new algorithm
    public void upgradeSessions(String newAlgorithm) {
        if (runtime.switchProvider(newAlgorithm)) {
            // New sessions will use new algorithm
            // Old sessions continue with their original algorithm
            logger.info("New sessions will use: " + newAlgorithm);
        }
    }
}
```

---

## 7. Spring Boot Integration

### Complete Spring Boot Example

```java
// Configuration
@Configuration
public class SecurityConfig {
    
    @Bean
    public CryptoAgilityRuntime cryptoRuntime(
            @Value("${crypto.default-algorithm:Hybrid-RSA-2048-Kyber768}") String defaultAlgorithm,
            @Value("${crypto.failover-enabled:true}") boolean failoverEnabled) {
        
        PolicyEngine policyEngine = new PolicyEngine();
        CryptoAgilityRuntime runtime = new CryptoAgilityRuntime(policyEngine);
        
        // Register providers
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new RSAProvider(4096));
        runtime.registerProvider(new KyberProvider("Kyber512"));
        runtime.registerProvider(new KyberProvider("Kyber768"));
        runtime.registerProvider(new KyberProvider("Kyber1024"));
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new KyberProvider("Kyber768")
        ));
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(4096),
            new KyberProvider("Kyber1024")
        ));
        
        // Configure
        runtime.setFailoverEnabled(failoverEnabled);
        runtime.switchProvider(defaultAlgorithm);
        
        return runtime;
    }
}

// Service
@Service
public class SecureDataService {
    private final CryptoAgilityRuntime runtime;
    
    @Autowired
    public SecureDataService(CryptoAgilityRuntime runtime) {
        this.runtime = runtime;
    }
    
    public EncryptedData encrypt(String data) throws CryptoException {
        CryptoProvider provider = runtime.getActiveProvider();
        KeyPair keyPair = provider.generateKeyPair();
        
        EncapsulationResult result = provider.encapsulate(keyPair.getPublic());
        
        // Use shared secret for AES encryption
        byte[] encrypted = encryptWithAES(data.getBytes(), result.getSharedSecret());
        
        return new EncryptedData(
            encrypted,
            result.getCiphertext(),
            keyPair.getPrivate().getEncoded(),
            provider.getAlgorithmName()
        );
    }
}

// Controller
@RestController
@RequestMapping("/api/crypto")
public class CryptoController {
    private final CryptoAgilityRuntime runtime;
    
    @Autowired
    public CryptoController(CryptoAgilityRuntime runtime) {
        this.runtime = runtime;
    }
    
    @GetMapping("/status")
    public ResponseEntity<CryptoStatus> getStatus() {
        CryptoAgilityRuntime.RuntimeStats stats = runtime.getStats();
        return ResponseEntity.ok(new CryptoStatus(
            stats.getActiveProvider(),
            stats.getAvailableProviders(),
            stats.isFailoverEnabled()
        ));
    }
    
    @PostMapping("/switch")
    public ResponseEntity<String> switchAlgorithm(@RequestParam String algorithm) {
        if (runtime.switchProvider(algorithm)) {
            return ResponseEntity.ok("Switched to " + algorithm);
        }
        return ResponseEntity.badRequest().body("Provider not available");
    }
}
```

**application.yml:**

```yaml
crypto:
  default-algorithm: Hybrid-RSA-2048-Kyber768
  failover-enabled: true
  
logging:
  level:
    com.pqc.agility: INFO
```

---

## Key Takeaways

### Minimal Changes Required:
1. ✅ Initialize `CryptoAgilityRuntime` once (constructor or Spring bean)
2. ✅ Replace `KeyPairGenerator` with `runtime.getActiveProvider()`
3. ✅ Use `encapsulate()/decapsulate()` instead of manual encryption
4. ✅ Store algorithm name with encrypted data for decryption

### Benefits:
- 🚀 **Zero Downtime**: Switch algorithms without restart
- 🔒 **Quantum-Safe**: Upgrade to PQ crypto when needed
- 🛡️ **Resilient**: Automatic failover on provider failure
- 📊 **Transparent**: Existing code mostly unchanged
- 🔄 **Backward Compatible**: Can decrypt old data with old algorithms

### Migration Strategy:
1. **Phase 1**: Add runtime alongside existing code
2. **Phase 2**: Migrate new features to use runtime
3. **Phase 3**: Gradually migrate existing features
4. **Phase 4**: Re-encrypt old data with new algorithms
5. **Phase 5**: Remove old crypto code

---

**The SDK is designed as a true drop-in replacement - minimal code changes, maximum security benefits!**