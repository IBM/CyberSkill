package com.pqc.agility.providers;

import com.pqc.agility.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Cipher;
import java.security.*;
import java.util.HashMap;

/**
 * RSA cryptographic provider (classical) - Uses Java built-in RSA
 */
public class RSAProvider implements CryptoProvider {
    private static final Logger logger = LoggerFactory.getLogger(RSAProvider.class);
    
    private final int keySize;
    private final String algorithmName;
    private final boolean available;
    
    public RSAProvider(int keySize) {
        this.keySize = keySize;
        this.algorithmName = "RSA-" + keySize;
        this.available = checkAvailability();
        logger.info("Created RSA provider with key size: {}", keySize);
    }
    
    private boolean checkAvailability() {
        try {
            KeyPairGenerator.getInstance("RSA");
            return true;
        } catch (Exception e) {
            logger.error("RSA provider not available", e);
            return false;
        }
    }
    
    @Override
    public String getAlgorithmName() {
        return algorithmName;
    }
    
    @Override
    public ProviderType getProviderType() {
        return ProviderType.CLASSICAL;
    }
    
    @Override
    public int getSecurityLevel() {
        // RSA security level approximation
        return keySize / 8;
    }
    
    @Override
    public KeyPair generateKeyPair() throws CryptoException {
        try {
            KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
            keyGen.initialize(keySize, new SecureRandom());
            return keyGen.generateKeyPair();
        } catch (Exception e) {
            throw new CryptoException("Failed to generate RSA key pair", e);
        }
    }
    
    @Override
    public byte[] encrypt(byte[] data, PublicKey publicKey) throws CryptoException {
        try {
            // Use Java built-in RSA with OAEP padding
            Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
            cipher.init(Cipher.ENCRYPT_MODE, publicKey);
            return cipher.doFinal(data);
        } catch (Exception e) {
            throw new CryptoException("RSA encryption failed", e);
        }
    }
    
    @Override
    public byte[] decrypt(byte[] encryptedData, PrivateKey privateKey) throws CryptoException {
        try {
            Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
            cipher.init(Cipher.DECRYPT_MODE, privateKey);
            return cipher.doFinal(encryptedData);
        } catch (Exception e) {
            throw new CryptoException("RSA decryption failed", e);
        }
    }
    
    @Override
    public byte[] sign(byte[] data, PrivateKey privateKey) throws CryptoException {
        try {
            // Use standard RSA signature
            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initSign(privateKey);
            signature.update(data);
            return signature.sign();
        } catch (Exception e) {
            throw new CryptoException("RSA signing failed", e);
        }
    }
    
    @Override
    public boolean verify(byte[] data, byte[] signatureBytes, PublicKey publicKey) throws CryptoException {
        try {
            Signature signature = Signature.getInstance("SHA256withRSA");
            signature.initVerify(publicKey);
            signature.update(data);
            return signature.verify(signatureBytes);
        } catch (Exception e) {
            throw new CryptoException("RSA verification failed", e);
        }
    }
    
    @Override
    public EncapsulationResult encapsulate(PublicKey publicKey) throws CryptoException {
        // RSA doesn't natively support KEM, simulate with encryption
        try {
            SecureRandom random = new SecureRandom();
            byte[] sharedSecret = new byte[32];
            random.nextBytes(sharedSecret);
            
            byte[] ciphertext = encrypt(sharedSecret, publicKey);
            return new EncapsulationResult(ciphertext, sharedSecret);
        } catch (Exception e) {
            throw new CryptoException("RSA encapsulation failed", e);
        }
    }
    
    @Override
    public byte[] decapsulate(byte[] ciphertext, PrivateKey privateKey) throws CryptoException {
        return decrypt(ciphertext, privateKey);
    }
    
    @Override
    public boolean isQuantumSafe() {
        return false;
    }
    
    @Override
    public boolean supportsKEM() {
        return true; // Simulated via encryption
    }
    
    @Override
    public PerformanceMetrics getPerformanceMetrics() {
        // Approximate metrics for RSA
        return new PerformanceMetrics.Builder()
            .keyGenTimeMs(keySize >= 4096 ? 2000 : 500)
            .encryptTimeMs(10)
            .decryptTimeMs(keySize >= 4096 ? 100 : 30)
            .signTimeMs(keySize >= 4096 ? 100 : 30)
            .verifyTimeMs(10)
            .publicKeySize(keySize / 8)
            .privateKeySize(keySize / 8)
            .ciphertextSize(keySize / 8)
            .signatureSize(keySize / 8)
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
            .description("RSA " + keySize + "-bit classical cryptography")
            .type(ProviderType.CLASSICAL)
            .securityLevel(getSecurityLevel())
            .quantumSafe(false)
            .supportsKEM(true)
            .supportsSignatures(true)
            .additionalInfo(new HashMap<>() {{
                put("keySize", String.valueOf(keySize));
                put("padding", "OAEP");
                put("signatureScheme", "RSA-PSS");
            }})
            .build();
    }
}

// Made with Bob
