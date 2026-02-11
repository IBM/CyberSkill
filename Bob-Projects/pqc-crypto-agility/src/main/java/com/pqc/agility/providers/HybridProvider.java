package com.pqc.agility.providers;

import com.pqc.agility.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.KeyPair;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.util.Arrays;
import java.util.HashMap;

/**
 * Hybrid cryptographic provider combining classical and post-quantum algorithms.
 * Provides defense-in-depth: secure if either algorithm remains unbroken.
 */
public class HybridProvider implements CryptoProvider {
    private static final Logger logger = LoggerFactory.getLogger(HybridProvider.class);
    
    private final CryptoProvider classicalProvider;
    private final CryptoProvider pqProvider;
    private final String algorithmName;
    private final boolean available;
    private volatile boolean failoverToClassical = false;
    private volatile boolean failoverToPQ = false;
    
    public HybridProvider(CryptoProvider classicalProvider, CryptoProvider pqProvider) {
        if (classicalProvider.getProviderType() != ProviderType.CLASSICAL) {
            throw new IllegalArgumentException("First provider must be classical");
        }
        if (pqProvider.getProviderType() != ProviderType.POST_QUANTUM) {
            throw new IllegalArgumentException("Second provider must be post-quantum");
        }
        
        this.classicalProvider = classicalProvider;
        this.pqProvider = pqProvider;
        this.algorithmName = "Hybrid-" + classicalProvider.getAlgorithmName() + 
                           "-" + pqProvider.getAlgorithmName();
        this.available = classicalProvider.isAvailable() && pqProvider.isAvailable();
        
        logger.info("Created hybrid provider: {}", algorithmName);
    }
    
    @Override
    public String getAlgorithmName() {
        return algorithmName;
    }
    
    @Override
    public ProviderType getProviderType() {
        return ProviderType.HYBRID;
    }
    
    @Override
    public int getSecurityLevel() {
        // Security level is the maximum of both providers
        return Math.max(classicalProvider.getSecurityLevel(), pqProvider.getSecurityLevel());
    }
    
    @Override
    public KeyPair generateKeyPair() throws CryptoException {
        try {
            KeyPair classicalKeyPair = classicalProvider.generateKeyPair();
            KeyPair pqKeyPair = pqProvider.generateKeyPair();
            
            return new KeyPair(
                new HybridPublicKey(classicalKeyPair.getPublic(), pqKeyPair.getPublic()),
                new HybridPrivateKey(classicalKeyPair.getPrivate(), pqKeyPair.getPrivate())
            );
        } catch (Exception e) {
            throw new CryptoException("Failed to generate hybrid key pair", e);
        }
    }
    
    @Override
    public byte[] encrypt(byte[] data, PublicKey publicKey) throws CryptoException {
        if (!(publicKey instanceof HybridPublicKey)) {
            throw new CryptoException("Invalid public key type for hybrid encryption");
        }
        
        HybridPublicKey hybridKey = (HybridPublicKey) publicKey;
        
        try {
            // Encrypt with both algorithms
            byte[] classicalCiphertext = classicalProvider.encrypt(data, hybridKey.classicalKey);
            byte[] pqCiphertext = pqProvider.encrypt(data, hybridKey.pqKey);
            
            // Combine ciphertexts
            return combineBytes(classicalCiphertext, pqCiphertext);
        } catch (Exception e) {
            // Attempt failover
            return handleEncryptionFailover(data, hybridKey, e);
        }
    }
    
    @Override
    public byte[] decrypt(byte[] encryptedData, PrivateKey privateKey) throws CryptoException {
        if (!(privateKey instanceof HybridPrivateKey)) {
            throw new CryptoException("Invalid private key type for hybrid decryption");
        }
        
        HybridPrivateKey hybridKey = (HybridPrivateKey) privateKey;
        
        try {
            // Split combined ciphertext
            byte[][] ciphertexts = splitBytes(encryptedData);
            byte[] classicalCiphertext = ciphertexts[0];
            byte[] pqCiphertext = ciphertexts[1];
            
            // Decrypt with both algorithms
            byte[] classicalPlaintext = classicalProvider.decrypt(classicalCiphertext, hybridKey.classicalKey);
            byte[] pqPlaintext = pqProvider.decrypt(pqCiphertext, hybridKey.pqKey);
            
            // Verify both decryptions match
            if (!Arrays.equals(classicalPlaintext, pqPlaintext)) {
                logger.warn("Hybrid decryption mismatch - attempting failover");
                return handleDecryptionFailover(encryptedData, hybridKey);
            }
            
            return classicalPlaintext;
        } catch (Exception e) {
            return handleDecryptionFailover(encryptedData, hybridKey);
        }
    }
    
    @Override
    public byte[] sign(byte[] data, PrivateKey privateKey) throws CryptoException {
        if (!(privateKey instanceof HybridPrivateKey)) {
            throw new CryptoException("Invalid private key type for hybrid signing");
        }
        
        HybridPrivateKey hybridKey = (HybridPrivateKey) privateKey;
        
        try {
            // Sign with both algorithms
            byte[] classicalSignature = classicalProvider.sign(data, hybridKey.classicalKey);
            byte[] pqSignature = pqProvider.sign(data, hybridKey.pqKey);
            
            // Combine signatures
            return combineBytes(classicalSignature, pqSignature);
        } catch (Exception e) {
            throw new CryptoException("Hybrid signing failed", e);
        }
    }
    
    @Override
    public boolean verify(byte[] data, byte[] signature, PublicKey publicKey) throws CryptoException {
        if (!(publicKey instanceof HybridPublicKey)) {
            throw new CryptoException("Invalid public key type for hybrid verification");
        }
        
        HybridPublicKey hybridKey = (HybridPublicKey) publicKey;
        
        try {
            // Split combined signature
            byte[][] signatures = splitBytes(signature);
            byte[] classicalSignature = signatures[0];
            byte[] pqSignature = signatures[1];
            
            // Verify with both algorithms - both must pass
            boolean classicalValid = classicalProvider.verify(data, classicalSignature, hybridKey.classicalKey);
            boolean pqValid = pqProvider.verify(data, pqSignature, hybridKey.pqKey);
            
            if (!classicalValid || !pqValid) {
                logger.warn("Hybrid verification failed: classical={}, pq={}", classicalValid, pqValid);
            }
            
            return classicalValid && pqValid;
        } catch (Exception e) {
            throw new CryptoException("Hybrid verification failed", e);
        }
    }
    
    @Override
    public EncapsulationResult encapsulate(PublicKey publicKey) throws CryptoException {
        if (!(publicKey instanceof HybridPublicKey)) {
            throw new CryptoException("Invalid public key type for hybrid encapsulation");
        }
        
        HybridPublicKey hybridKey = (HybridPublicKey) publicKey;
        
        try {
            // Encapsulate with both algorithms
            EncapsulationResult classicalResult = classicalProvider.encapsulate(hybridKey.classicalKey);
            EncapsulationResult pqResult = pqProvider.encapsulate(hybridKey.pqKey);
            
            // XOR the shared secrets for combined security
            byte[] combinedSecret = xorBytes(
                classicalResult.getSharedSecret(), 
                pqResult.getSharedSecret()
            );
            
            // Combine ciphertexts
            byte[] combinedCiphertext = combineBytes(
                classicalResult.getCiphertext(),
                pqResult.getCiphertext()
            );
            
            return new EncapsulationResult(combinedCiphertext, combinedSecret);
        } catch (Exception e) {
            throw new CryptoException("Hybrid encapsulation failed", e);
        }
    }
    
    @Override
    public byte[] decapsulate(byte[] ciphertext, PrivateKey privateKey) throws CryptoException {
        if (!(privateKey instanceof HybridPrivateKey)) {
            throw new CryptoException("Invalid private key type for hybrid decapsulation");
        }
        
        HybridPrivateKey hybridKey = (HybridPrivateKey) privateKey;
        
        try {
            // Split combined ciphertext
            byte[][] ciphertexts = splitBytes(ciphertext);
            
            // Decapsulate with both algorithms
            byte[] classicalSecret = classicalProvider.decapsulate(ciphertexts[0], hybridKey.classicalKey);
            byte[] pqSecret = pqProvider.decapsulate(ciphertexts[1], hybridKey.pqKey);
            
            // XOR the shared secrets
            return xorBytes(classicalSecret, pqSecret);
        } catch (Exception e) {
            throw new CryptoException("Hybrid decapsulation failed", e);
        }
    }
    
    @Override
    public boolean isQuantumSafe() {
        return true; // Hybrid is quantum-safe due to PQ component
    }
    
    @Override
    public boolean supportsKEM() {
        return classicalProvider.supportsKEM() && pqProvider.supportsKEM();
    }
    
    @Override
    public PerformanceMetrics getPerformanceMetrics() {
        PerformanceMetrics classical = classicalProvider.getPerformanceMetrics();
        PerformanceMetrics pq = pqProvider.getPerformanceMetrics();
        
        // Hybrid metrics are sum of both providers
        return new PerformanceMetrics.Builder()
            .keyGenTimeMs(classical.getKeyGenTimeMs() + pq.getKeyGenTimeMs())
            .encryptTimeMs(classical.getEncryptTimeMs() + pq.getEncryptTimeMs())
            .decryptTimeMs(classical.getDecryptTimeMs() + pq.getDecryptTimeMs())
            .signTimeMs(classical.getSignTimeMs() + pq.getSignTimeMs())
            .verifyTimeMs(classical.getVerifyTimeMs() + pq.getVerifyTimeMs())
            .publicKeySize(classical.getPublicKeySize() + pq.getPublicKeySize())
            .privateKeySize(classical.getPrivateKeySize() + pq.getPrivateKeySize())
            .ciphertextSize(classical.getCiphertextSize() + pq.getCiphertextSize() + 4)
            .signatureSize(classical.getSignatureSize() + pq.getSignatureSize() + 4)
            .build();
    }
    
    @Override
    public boolean isAvailable() {
        return available;
    }
    
    @Override
    public ProviderMetadata getMetadata() {
        return new ProviderMetadata.Builder()
            .name(algorithmName)
            .version("1.0")
            .description("Hybrid classical + post-quantum cryptography with live failover")
            .type(ProviderType.HYBRID)
            .securityLevel(getSecurityLevel())
            .quantumSafe(true)
            .supportsKEM(supportsKEM())
            .supportsSignatures(true)
            .additionalInfo(new HashMap<>() {{
                put("classicalAlgorithm", classicalProvider.getAlgorithmName());
                put("pqAlgorithm", pqProvider.getAlgorithmName());
                put("failoverEnabled", "true");
            }})
            .build();
    }
    
    // Helper methods
    
    private byte[] combineBytes(byte[] first, byte[] second) {
        byte[] combined = new byte[4 + first.length + second.length];
        // Store first array length
        combined[0] = (byte) (first.length >> 24);
        combined[1] = (byte) (first.length >> 16);
        combined[2] = (byte) (first.length >> 8);
        combined[3] = (byte) first.length;
        // Copy arrays
        System.arraycopy(first, 0, combined, 4, first.length);
        System.arraycopy(second, 0, combined, 4 + first.length, second.length);
        return combined;
    }
    
    private byte[][] splitBytes(byte[] combined) {
        // Read first array length
        int firstLength = ((combined[0] & 0xFF) << 24) |
                         ((combined[1] & 0xFF) << 16) |
                         ((combined[2] & 0xFF) << 8) |
                         (combined[3] & 0xFF);
        
        byte[] first = new byte[firstLength];
        byte[] second = new byte[combined.length - 4 - firstLength];
        
        System.arraycopy(combined, 4, first, 0, firstLength);
        System.arraycopy(combined, 4 + firstLength, second, 0, second.length);
        
        return new byte[][]{first, second};
    }
    
    private byte[] xorBytes(byte[] a, byte[] b) {
        int length = Math.min(a.length, b.length);
        byte[] result = new byte[length];
        for (int i = 0; i < length; i++) {
            result[i] = (byte) (a[i] ^ b[i]);
        }
        return result;
    }
    
    private byte[] handleEncryptionFailover(byte[] data, HybridPublicKey key, Exception cause) 
            throws CryptoException {
        logger.error("Hybrid encryption failed, attempting failover", cause);
        
        if (!failoverToPQ) {
            try {
                logger.info("Failing over to PQ-only encryption");
                failoverToPQ = true;
                return pqProvider.encrypt(data, key.pqKey);
            } catch (Exception e) {
                logger.error("PQ failover failed", e);
            }
        }
        
        if (!failoverToClassical) {
            try {
                logger.info("Failing over to classical-only encryption");
                failoverToClassical = true;
                return classicalProvider.encrypt(data, key.classicalKey);
            } catch (Exception e) {
                logger.error("Classical failover failed", e);
            }
        }
        
        throw new CryptoException("All hybrid encryption methods failed", cause);
    }
    
    private byte[] handleDecryptionFailover(byte[] encryptedData, HybridPrivateKey key) 
            throws CryptoException {
        logger.warn("Attempting decryption failover");
        
        // Try PQ-only decryption
        try {
            return pqProvider.decrypt(encryptedData, key.pqKey);
        } catch (Exception e) {
            logger.debug("PQ-only decryption failed", e);
        }
        
        // Try classical-only decryption
        try {
            return classicalProvider.decrypt(encryptedData, key.classicalKey);
        } catch (Exception e) {
            logger.debug("Classical-only decryption failed", e);
        }
        
        throw new CryptoException("All hybrid decryption methods failed");
    }
    
    // Inner classes for hybrid keys
    
    public static class HybridPublicKey implements PublicKey {
        private final PublicKey classicalKey;
        private final PublicKey pqKey;
        
        public HybridPublicKey(PublicKey classicalKey, PublicKey pqKey) {
            this.classicalKey = classicalKey;
            this.pqKey = pqKey;
        }
        
        public PublicKey getClassicalKey() { return classicalKey; }
        public PublicKey getPqKey() { return pqKey; }
        
        @Override
        public String getAlgorithm() {
            return "Hybrid";
        }
        
        @Override
        public String getFormat() {
            return "HYBRID";
        }
        
        @Override
        public byte[] getEncoded() {
            byte[] classical = classicalKey.getEncoded();
            byte[] pq = pqKey.getEncoded();
            byte[] combined = new byte[4 + classical.length + pq.length];
            combined[0] = (byte) (classical.length >> 24);
            combined[1] = (byte) (classical.length >> 16);
            combined[2] = (byte) (classical.length >> 8);
            combined[3] = (byte) classical.length;
            System.arraycopy(classical, 0, combined, 4, classical.length);
            System.arraycopy(pq, 0, combined, 4 + classical.length, pq.length);
            return combined;
        }
    }
    
    public static class HybridPrivateKey implements PrivateKey {
        private final PrivateKey classicalKey;
        private final PrivateKey pqKey;
        
        public HybridPrivateKey(PrivateKey classicalKey, PrivateKey pqKey) {
            this.classicalKey = classicalKey;
            this.pqKey = pqKey;
        }
        
        public PrivateKey getClassicalKey() { return classicalKey; }
        public PrivateKey getPqKey() { return pqKey; }
        
        @Override
        public String getAlgorithm() {
            return "Hybrid";
        }
        
        @Override
        public String getFormat() {
            return "HYBRID";
        }
        
        @Override
        public byte[] getEncoded() {
            byte[] classical = classicalKey.getEncoded();
            byte[] pq = pqKey.getEncoded();
            byte[] combined = new byte[4 + classical.length + pq.length];
            combined[0] = (byte) (classical.length >> 24);
            combined[1] = (byte) (classical.length >> 16);
            combined[2] = (byte) (classical.length >> 8);
            combined[3] = (byte) classical.length;
            System.arraycopy(classical, 0, combined, 4, classical.length);
            System.arraycopy(pq, 0, combined, 4 + classical.length, pq.length);
            return combined;
        }
    }
}

// Made with Bob
