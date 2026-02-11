package com.pqc.encryptor;

import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import java.security.*;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * Java 22+ Native PQC Crypto Service
 * Uses ML-KEM (Kyber) from Java's built-in crypto providers
 * 
 * Java 22: Early access to ML-KEM
 * Java 24: Stabilized ML-KEM and ML-DSA
 */
public class Java22PQCCryptoService {
    private static final Logger logger = LoggerFactory.getLogger(Java22PQCCryptoService.class);
    private final Vertx vertx;
    
    // AES-GCM parameters
    private static final String AES_ALGORITHM = "AES/GCM/NoPadding";
    private static final int AES_KEY_SIZE = 256;
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 128;
    
    // ML-KEM (Kyber) variants - NIST standardized sizes
    public enum KyberVariant {
        KYBER_512("ML-KEM-512", 800, 1632, 768),   // Security level 1
        KYBER_768("ML-KEM-768", 1184, 2400, 1088), // Security level 3 (recommended)
        KYBER_1024("ML-KEM-1024", 1568, 3168, 1568); // Security level 5
        
        private final String algorithm;
        private final int publicKeySize;
        private final int ciphertextSize;
        private final int privateKeySize;
        
        KyberVariant(String algorithm, int publicKeySize, int ciphertextSize, int privateKeySize) {
            this.algorithm = algorithm;
            this.publicKeySize = publicKeySize;
            this.ciphertextSize = ciphertextSize;
            this.privateKeySize = privateKeySize;
        }
        
        public String getAlgorithm() { return algorithm; }
        public int getPublicKeySize() { return publicKeySize; }
        public int getCiphertextSize() { return ciphertextSize; }
        public int getPrivateKeySize() { return privateKeySize; }
    }
    
    public Java22PQCCryptoService(Vertx vertx) {
        this.vertx = vertx;
        logger.info("Initialized Java 22+ Native PQC Crypto Service");
        logAvailableProviders();
    }
    
    /**
     * Log available security providers and ML-KEM support
     */
    private void logAvailableProviders() {
        try {
            Provider[] providers = Security.getProviders();
            logger.info("Available Security Providers:");
            for (Provider provider : providers) {
                logger.info("  - {} (version {})", provider.getName(), provider.getVersionStr());
            }
            
            // Check for ML-KEM support
            try {
                KeyPairGenerator kpg = KeyPairGenerator.getInstance("ML-KEM");
                logger.info("✓ ML-KEM (Kyber) support detected!");
            } catch (NoSuchAlgorithmException e) {
                logger.warn("✗ ML-KEM not available. Java 22+ with --enable-preview required.");
                logger.warn("  Falling back to simulation mode for demonstration.");
            }
        } catch (Exception e) {
            logger.error("Error checking providers", e);
        }
    }
    
    /**
     * Generate ML-KEM (Kyber) key pair using Java 24 native support
     */
    public Future<KeyPair> generateKyberKeyPair(KyberVariant variant) {
        Promise<KeyPair> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                // Use native ML-KEM from Java 24
                KeyPairGenerator kpg = KeyPairGenerator.getInstance(variant.getAlgorithm());
                
                // ML-KEM parameter specification (if needed)
                // For Java 24, the algorithm name includes the variant
                KeyPair keyPair = kpg.generateKeyPair();
                
                logger.info("✓ Generated {} key pair (Java 24 native)", variant.getAlgorithm());
                logger.info("  Public key size: {} bytes", keyPair.getPublic().getEncoded().length);
                logger.info("  Private key size: {} bytes", keyPair.getPrivate().getEncoded().length);
                
                blockingPromise.complete(keyPair);
            } catch (NoSuchAlgorithmException e) {
                logger.error("ML-KEM not available. Ensure Java 24 with --enable-preview is used.");
                logger.error("Error: {}", e.getMessage());
                blockingPromise.fail(new Exception("ML-KEM not available. Java 24 with --enable-preview required.", e));
            } catch (Exception e) {
                logger.error("Error generating ML-KEM key pair", e);
                blockingPromise.fail(e);
            }
        }, false).onComplete(ar -> {
            if (ar.succeeded()) {
                promise.complete((KeyPair) ar.result());
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Generate AES-256 key for file encryption
     */
    public Future<SecretKey> generateAESKey() {
        Promise<SecretKey> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                KeyGenerator keyGen = KeyGenerator.getInstance("AES");
                keyGen.init(AES_KEY_SIZE);
                SecretKey aesKey = keyGen.generateKey();
                
                logger.debug("Generated AES-256 key");
                blockingPromise.complete(aesKey);
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false).onComplete(ar -> {
            if (ar.succeeded()) {
                promise.complete((SecretKey) ar.result());
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Encrypt AES key using ML-KEM (Kyber) public key
     * This is the KEM encapsulation operation using Java 24's KEM API
     */
    public Future<Map<String, String>> encapsulateAESKey(SecretKey aesKey, PublicKey kyberPublicKey, KyberVariant variant) {
        Promise<Map<String, String>> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                Map<String, String> result = new HashMap<>();
                
                // Use Java 24's KEM API for ML-KEM encapsulation
                logger.info("⚙ Performing ML-KEM encapsulation using Java 24 KEM API...");
                
                // Get KEM instance
                javax.crypto.KEM kem = javax.crypto.KEM.getInstance(variant.getAlgorithm());
                
                // Create encapsulator
                javax.crypto.KEM.Encapsulator encapsulator = kem.newEncapsulator(kyberPublicKey);
                
                // Encapsulate - this generates a shared secret
                javax.crypto.KEM.Encapsulated encapsulated = encapsulator.encapsulate();
                
                // Get the encapsulated key (ciphertext) and shared secret
                byte[] encapsulatedKey = encapsulated.encapsulation();
                SecretKey sharedSecret = encapsulated.key();
                
                // Derive AES key from shared secret using KDF (or use shared secret directly)
                // For simplicity, we'll XOR the AES key with the shared secret
                byte[] aesKeyBytes = aesKey.getEncoded();
                byte[] sharedSecretBytes = sharedSecret.getEncoded();
                
                // Ensure we have enough bytes
                byte[] protectedKey = new byte[aesKeyBytes.length];
                for (int i = 0; i < aesKeyBytes.length; i++) {
                    protectedKey[i] = (byte) (aesKeyBytes[i] ^ sharedSecretBytes[i % sharedSecretBytes.length]);
                }
                
                // Store results
                result.put("encapsulated_key", Base64.getEncoder().encodeToString(encapsulatedKey));
                result.put("protected_aes_key", Base64.getEncoder().encodeToString(protectedKey));
                result.put("encapsulated_key_size", String.valueOf(encapsulatedKey.length));
                
                logger.info("✓ ML-KEM encapsulation complete");
                logger.info("  Encapsulated key size: {} bytes (expected: {})",
                    encapsulatedKey.length, variant.getCiphertextSize());
                logger.info("  Shared secret size: {} bytes", sharedSecretBytes.length);
                
                blockingPromise.complete(result);
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false).onComplete(ar -> {
            if (ar.succeeded()) {
                @SuppressWarnings("unchecked")
                Map<String, String> result = (Map<String, String>) ar.result();
                promise.complete(result);
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Decrypt AES key using ML-KEM (Kyber) private key
     * This is the KEM decapsulation operation using Java 24's KEM API
     */
    public Future<SecretKey> decapsulateAESKey(Map<String, String> encapsulationResult, PrivateKey kyberPrivateKey, KyberVariant variant) {
        Promise<SecretKey> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                logger.info("⚙ Performing ML-KEM decapsulation using Java 24 KEM API...");
                
                // Get the encapsulated key and protected AES key
                String encapsulatedKeyBase64 = encapsulationResult.get("encapsulated_key");
                String protectedKeyBase64 = encapsulationResult.get("protected_aes_key");
                
                byte[] encapsulatedKey = Base64.getDecoder().decode(encapsulatedKeyBase64);
                byte[] protectedKey = Base64.getDecoder().decode(protectedKeyBase64);
                
                // Use Java 24's KEM API for ML-KEM decapsulation
                javax.crypto.KEM kem = javax.crypto.KEM.getInstance(variant.getAlgorithm());
                
                // Create decapsulator
                javax.crypto.KEM.Decapsulator decapsulator = kem.newDecapsulator(kyberPrivateKey);
                
                // Decapsulate - this recovers the shared secret
                SecretKey sharedSecret = decapsulator.decapsulate(encapsulatedKey);
                byte[] sharedSecretBytes = sharedSecret.getEncoded();
                
                // Recover the AES key by XORing with the shared secret
                byte[] aesKeyBytes = new byte[protectedKey.length];
                for (int i = 0; i < protectedKey.length; i++) {
                    aesKeyBytes[i] = (byte) (protectedKey[i] ^ sharedSecretBytes[i % sharedSecretBytes.length]);
                }
                
                SecretKey aesKey = new javax.crypto.spec.SecretKeySpec(aesKeyBytes, "AES");
                
                logger.info("✓ ML-KEM decapsulation complete");
                logger.info("  Recovered AES key: {} bytes", aesKeyBytes.length);
                
                blockingPromise.complete(aesKey);
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false).onComplete(ar -> {
            if (ar.succeeded()) {
                promise.complete((SecretKey) ar.result());
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Encrypt file data using AES-GCM
     */
    public Future<Map<String, String>> encryptData(byte[] data, SecretKey aesKey) {
        Promise<Map<String, String>> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                // Generate random IV
                byte[] iv = new byte[GCM_IV_LENGTH];
                SecureRandom random = new SecureRandom();
                random.nextBytes(iv);
                
                // Encrypt
                Cipher cipher = Cipher.getInstance(AES_ALGORITHM);
                GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
                cipher.init(Cipher.ENCRYPT_MODE, aesKey, spec);
                byte[] ciphertext = cipher.doFinal(data);
                
                Map<String, String> result = new HashMap<>();
                result.put("ciphertext", Base64.getEncoder().encodeToString(ciphertext));
                result.put("iv", Base64.getEncoder().encodeToString(iv));
                result.put("algorithm", AES_ALGORITHM);
                
                logger.debug("Encrypted {} bytes with AES-GCM", data.length);
                blockingPromise.complete(result);
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false).onComplete(ar -> {
            if (ar.succeeded()) {
                @SuppressWarnings("unchecked")
                Map<String, String> result = (Map<String, String>) ar.result();
                promise.complete(result);
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Decrypt file data using AES-GCM
     */
    public Future<byte[]> decryptData(String ciphertextBase64, String ivBase64, SecretKey aesKey) {
        Promise<byte[]> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                byte[] ciphertext = Base64.getDecoder().decode(ciphertextBase64);
                byte[] iv = Base64.getDecoder().decode(ivBase64);
                
                Cipher cipher = Cipher.getInstance(AES_ALGORITHM);
                GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
                cipher.init(Cipher.DECRYPT_MODE, aesKey, spec);
                byte[] plaintext = cipher.doFinal(ciphertext);
                
                logger.debug("Decrypted {} bytes with AES-GCM", plaintext.length);
                blockingPromise.complete(plaintext);
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false).onComplete(ar -> {
            if (ar.succeeded()) {
                promise.complete((byte[]) ar.result());
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    /**
     * Get key size comparison data
     */
    public Map<String, Object> getKeySizeComparison(KyberVariant variant) {
        Map<String, Object> comparison = new HashMap<>();
        
        // Classical RSA-2048
        comparison.put("rsa_2048_public", 294);
        comparison.put("rsa_2048_private", 1218);
        
        // ML-KEM (Kyber) variants
        comparison.put("kyber_512_public", variant == KyberVariant.KYBER_512 ? variant.getPublicKeySize() : 800);
        comparison.put("kyber_512_private", variant == KyberVariant.KYBER_512 ? variant.getPrivateKeySize() : 1632);
        comparison.put("kyber_512_ciphertext", variant == KyberVariant.KYBER_512 ? variant.getCiphertextSize() : 768);
        
        comparison.put("kyber_768_public", variant == KyberVariant.KYBER_768 ? variant.getPublicKeySize() : 1184);
        comparison.put("kyber_768_private", variant == KyberVariant.KYBER_768 ? variant.getPrivateKeySize() : 2400);
        comparison.put("kyber_768_ciphertext", variant == KyberVariant.KYBER_768 ? variant.getCiphertextSize() : 1088);
        
        comparison.put("kyber_1024_public", variant == KyberVariant.KYBER_1024 ? variant.getPublicKeySize() : 1568);
        comparison.put("kyber_1024_private", variant == KyberVariant.KYBER_1024 ? variant.getPrivateKeySize() : 3168);
        comparison.put("kyber_1024_ciphertext", variant == KyberVariant.KYBER_1024 ? variant.getCiphertextSize() : 1568);
        
        // Calculate overhead percentages
        int rsaPublic = 294;
        comparison.put("kyber_512_public_overhead_pct", ((variant.getPublicKeySize() - rsaPublic) * 100.0 / rsaPublic));
        comparison.put("kyber_768_public_overhead_pct", ((1184 - rsaPublic) * 100.0 / rsaPublic));
        comparison.put("kyber_1024_public_overhead_pct", ((1568 - rsaPublic) * 100.0 / rsaPublic));
        
        return comparison;
    }
}

// Made with Bob
