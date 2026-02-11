package com.pqc.unified;

import javax.crypto.*;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.*;
import java.security.spec.AlgorithmParameterSpec;
import java.util.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Unified PQC Cryptography Service using Java 24 native ML-KEM
 * Provides quantum-safe key exchange and symmetric encryption
 */
public class PQCCryptoService {
    private static final Logger logger = LoggerFactory.getLogger(PQCCryptoService.class);
    
    private static final String KEM_ALGORITHM = "ML-KEM-768";
    private static final String CIPHER_ALGORITHM = "AES/GCM/NoPadding";
    private static final int GCM_TAG_LENGTH = 128;
    private static final int GCM_IV_LENGTH = 12;
    
    private KeyPair keyPair;
    private SecretKey sharedSecret;
    
    /**
     * Generate ML-KEM key pair
     */
    public void generateKeyPair() throws Exception {
        logger.debug("Generating ML-KEM-768 key pair...");
        KeyPairGenerator keyGen = KeyPairGenerator.getInstance(KEM_ALGORITHM);
        this.keyPair = keyGen.generateKeyPair();
        logger.info("ML-KEM key pair generated successfully");
    }
    
    /**
     * Get public key as Base64 string
     */
    public String getPublicKeyBase64() {
        if (keyPair == null) {
            throw new IllegalStateException("Key pair not generated");
        }
        return Base64.getEncoder().encodeToString(keyPair.getPublic().getEncoded());
    }
    
    /**
     * Get public key bytes
     */
    public byte[] getPublicKeyBytes() {
        if (keyPair == null) {
            throw new IllegalStateException("Key pair not generated");
        }
        return keyPair.getPublic().getEncoded();
    }
    
    /**
     * Perform key encapsulation (sender side)
     * @param peerPublicKeyBytes Peer's public key
     * @return Encapsulated key bytes
     */
    public byte[] performKeyEncapsulation(byte[] peerPublicKeyBytes) throws Exception {
        logger.debug("Performing ML-KEM key encapsulation...");
        
        // Reconstruct peer's public key
        KeyFactory keyFactory = KeyFactory.getInstance(KEM_ALGORITHM);
        PublicKey peerPublicKey = keyFactory.generatePublic(
            new java.security.spec.X509EncodedKeySpec(peerPublicKeyBytes)
        );
        
        // Perform encapsulation
        KEM kem = KEM.getInstance(KEM_ALGORITHM);
        KEM.Encapsulator encapsulator = kem.newEncapsulator(peerPublicKey);
        KEM.Encapsulated result = encapsulator.encapsulate();
        
        // Convert shared secret to AES key
        byte[] sharedSecretBytes = result.key().getEncoded();
        this.sharedSecret = new SecretKeySpec(sharedSecretBytes, "AES");
        
        logger.info("Key encapsulation successful, shared secret size: {} bytes",
                   sharedSecretBytes.length);
        
        // Return encapsulated key to send to peer
        return result.encapsulation();
    }
    
    /**
     * Perform key decapsulation (receiver side)
     * @param encapsulatedKey Encapsulated key from peer
     */
    public void performKeyDecapsulation(byte[] encapsulatedKey) throws Exception {
        if (keyPair == null) {
            throw new IllegalStateException("Key pair not generated");
        }
        
        logger.debug("Performing ML-KEM key decapsulation...");
        
        KEM kem = KEM.getInstance(KEM_ALGORITHM);
        KEM.Decapsulator decapsulator = kem.newDecapsulator(keyPair.getPrivate());
        SecretKey kemSecret = decapsulator.decapsulate(encapsulatedKey);
        
        // Convert shared secret to AES key
        byte[] sharedSecretBytes = kemSecret.getEncoded();
        this.sharedSecret = new SecretKeySpec(sharedSecretBytes, "AES");
        
        logger.info("Key decapsulation successful, shared secret size: {} bytes",
                   sharedSecretBytes.length);
    }
    
    /**
     * Encrypt data using AES-256-GCM with the shared secret
     */
    public EncryptedData encrypt(byte[] plaintext) throws Exception {
        if (sharedSecret == null) {
            throw new IllegalStateException("Shared secret not established");
        }
        
        // Generate random IV
        byte[] iv = new byte[GCM_IV_LENGTH];
        SecureRandom random = new SecureRandom();
        random.nextBytes(iv);
        
        // Encrypt
        Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.ENCRYPT_MODE, sharedSecret, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        
        logger.debug("Encrypted {} bytes to {} bytes", plaintext.length, ciphertext.length);
        
        return new EncryptedData(ciphertext, iv);
    }
    
    /**
     * Decrypt data using AES-256-GCM with the shared secret
     */
    public byte[] decrypt(byte[] ciphertext, byte[] iv) throws Exception {
        if (sharedSecret == null) {
            throw new IllegalStateException("Shared secret not established");
        }
        
        Cipher cipher = Cipher.getInstance(CIPHER_ALGORITHM);
        GCMParameterSpec spec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.DECRYPT_MODE, sharedSecret, spec);
        byte[] plaintext = cipher.doFinal(ciphertext);
        
        logger.debug("Decrypted {} bytes to {} bytes", ciphertext.length, plaintext.length);
        
        return plaintext;
    }
    
    /**
     * Encrypt string message
     */
    public EncryptedData encryptString(String message) throws Exception {
        return encrypt(message.getBytes("UTF-8"));
    }
    
    /**
     * Decrypt to string message
     */
    public String decryptString(byte[] ciphertext, byte[] iv) throws Exception {
        byte[] plaintext = decrypt(ciphertext, iv);
        return new String(plaintext, "UTF-8");
    }
    
    /**
     * Get shared secret (for testing/debugging)
     */
    public SecretKey getSharedSecret() {
        return sharedSecret;
    }
    
    /**
     * Set shared secret directly (for testing)
     */
    public void setSharedSecret(SecretKey secret) {
        this.sharedSecret = secret;
    }
    
    /**
     * Container for encrypted data
     */
    public static class EncryptedData {
        private final byte[] ciphertext;
        private final byte[] iv;
        
        public EncryptedData(byte[] ciphertext, byte[] iv) {
            this.ciphertext = ciphertext;
            this.iv = iv;
        }
        
        public byte[] getCiphertext() {
            return ciphertext;
        }
        
        public byte[] getIv() {
            return iv;
        }
        
        public String getCiphertextBase64() {
            return Base64.getEncoder().encodeToString(ciphertext);
        }
        
        public String getIvBase64() {
            return Base64.getEncoder().encodeToString(iv);
        }
    }
}

// Made with Bob
