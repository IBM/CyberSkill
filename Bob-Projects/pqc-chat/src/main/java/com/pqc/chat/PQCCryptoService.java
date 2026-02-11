package com.pqc.chat;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Cipher;
import javax.crypto.KEM;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.*;
import java.security.spec.X509EncodedKeySpec;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

/**
 * PQC Crypto Service using Java 24's native ML-KEM (Kyber) KEM API
 * Uses ML-KEM for key encapsulation and AES-256-GCM for message encryption
 */
public class PQCCryptoService {
    private static final Logger logger = LoggerFactory.getLogger(PQCCryptoService.class);
    
    private static final String PQC_ALGORITHM = "ML-KEM-768"; // Kyber-768 (recommended)
    private static final String SYMMETRIC_ALGORITHM = "AES";
    private static final String CIPHER_TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_TAG_LENGTH = 128;
    private static final int GCM_IV_LENGTH = 12;
    
    private KeyPair keyPair;
    private SecretKey sharedSecret;
    private final List<String> handshakeSteps;
    
    public PQCCryptoService() {
        this.handshakeSteps = new ArrayList<>();
    }
    
    /**
     * Initialize ML-KEM key pair
     */
    public void initializeKeyPair() throws Exception {
        handshakeSteps.clear();
        handshakeSteps.add("Step 1: Initializing ML-KEM Key Pair Generation");
        
        try {
            // Generate ML-KEM-768 key pair using Java 24 native API
            KeyPairGenerator keyGen = KeyPairGenerator.getInstance(PQC_ALGORITHM);
            keyPair = keyGen.generateKeyPair();
            
            handshakeSteps.add("Step 2: Generated ML-KEM-768 Key Pair");
            handshakeSteps.add("  - Public Key Size: " + keyPair.getPublic().getEncoded().length + " bytes");
            handshakeSteps.add("  - Private Key Size: " + keyPair.getPrivate().getEncoded().length + " bytes");
            handshakeSteps.add("  - Algorithm: " + PQC_ALGORITHM + " (NIST-standardized)");
            
            logger.info("ML-KEM Key Pair initialized successfully");
        } catch (Exception e) {
            handshakeSteps.add("ERROR: Failed to generate key pair - " + e.getMessage());
            logger.error("Failed to initialize key pair", e);
            throw e;
        }
    }
    
    /**
     * Get the public key as Base64 string
     */
    public String getPublicKeyBase64() {
        if (keyPair == null) {
            return null;
        }
        return Base64.getEncoder().encodeToString(keyPair.getPublic().getEncoded());
    }
    
    /**
     * Perform key encapsulation with peer's public key
     * This generates a shared secret and encapsulated key
     */
    public String performKeyEncapsulation(String peerPublicKeyBase64) throws Exception {
        handshakeSteps.add("Step 3: Received Peer's Public Key");
        handshakeSteps.add("  - Peer Public Key Size: " + peerPublicKeyBase64.length() + " chars (Base64)");
        
        try {
            // Decode peer's public key
            byte[] peerPublicKeyBytes = Base64.getDecoder().decode(peerPublicKeyBase64);
            KeyFactory keyFactory = KeyFactory.getInstance(PQC_ALGORITHM);
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(peerPublicKeyBytes);
            PublicKey peerPublicKey = keyFactory.generatePublic(keySpec);
            
            handshakeSteps.add("Step 4: Decoded Peer's Public Key");
            
            // Perform ML-KEM encapsulation using Java 24 KEM API
            KEM kem = KEM.getInstance(PQC_ALGORITHM);
            KEM.Encapsulator encapsulator = kem.newEncapsulator(peerPublicKey);
            KEM.Encapsulated result = encapsulator.encapsulate();
            
            // Get the encapsulated key (ciphertext) and shared secret
            byte[] encapsulatedKey = result.encapsulation();
            SecretKey kemSharedSecret = result.key();
            
            handshakeSteps.add("Step 5: Performed ML-KEM Key Encapsulation");
            handshakeSteps.add("  - Encapsulated Key Size: " + encapsulatedKey.length + " bytes");
            
            // Derive AES-256 key from the shared secret
            byte[] aesKeyBytes = new byte[32]; // 256 bits
            System.arraycopy(kemSharedSecret.getEncoded(), 0, aesKeyBytes, 0, Math.min(32, kemSharedSecret.getEncoded().length));
            sharedSecret = new SecretKeySpec(aesKeyBytes, SYMMETRIC_ALGORITHM);
            
            handshakeSteps.add("Step 6: Derived AES-256 Symmetric Key");
            handshakeSteps.add("  - AES Key Size: 256 bits");
            handshakeSteps.add("Step 7: Handshake Complete - Ready for Secure Messaging");
            
            logger.info("Key encapsulation completed successfully");
            
            // Return the encapsulated key for the peer to decapsulate
            return Base64.getEncoder().encodeToString(encapsulatedKey);
            
        } catch (Exception e) {
            handshakeSteps.add("ERROR: Key encapsulation failed - " + e.getMessage());
            logger.error("Key encapsulation failed", e);
            throw e;
        }
    }
    
    /**
     * Decapsulate the encapsulated key to derive the shared secret
     */
    public void performKeyDecapsulation(String encapsulatedKeyBase64) throws Exception {
        handshakeSteps.add("Step 3: Received Encapsulated Key");
        
        try {
            // Decode the encapsulated key
            byte[] encapsulatedKey = Base64.getDecoder().decode(encapsulatedKeyBase64);
            
            handshakeSteps.add("Step 4: Decoded Encapsulated Key");
            handshakeSteps.add("  - Encapsulated Key Size: " + encapsulatedKey.length + " bytes");
            
            // Perform ML-KEM decapsulation using Java 24 KEM API
            KEM kem = KEM.getInstance(PQC_ALGORITHM);
            KEM.Decapsulator decapsulator = kem.newDecapsulator(keyPair.getPrivate());
            SecretKey kemSharedSecret = decapsulator.decapsulate(encapsulatedKey);
            
            handshakeSteps.add("Step 5: Performed ML-KEM Key Decapsulation");
            
            // Derive AES-256 key from the shared secret
            byte[] aesKeyBytes = new byte[32]; // 256 bits
            System.arraycopy(kemSharedSecret.getEncoded(), 0, aesKeyBytes, 0, Math.min(32, kemSharedSecret.getEncoded().length));
            sharedSecret = new SecretKeySpec(aesKeyBytes, SYMMETRIC_ALGORITHM);
            
            handshakeSteps.add("Step 6: Derived AES-256 Symmetric Key");
            handshakeSteps.add("  - AES Key Size: 256 bits");
            handshakeSteps.add("Step 7: Handshake Complete - Ready for Secure Messaging");
            
            logger.info("Key decapsulation completed successfully");
            
        } catch (Exception e) {
            handshakeSteps.add("ERROR: Key decapsulation failed - " + e.getMessage());
            logger.error("Key decapsulation failed", e);
            throw e;
        }
    }
    
    /**
     * Encrypt a message using AES-256-GCM
     */
    public String encryptMessage(String plaintext) throws Exception {
        if (sharedSecret == null) {
            throw new IllegalStateException("Key exchange not completed");
        }
        
        try {
            // Generate random IV
            byte[] iv = new byte[GCM_IV_LENGTH];
            SecureRandom random = new SecureRandom();
            random.nextBytes(iv);
            
            // Initialize cipher
            Cipher cipher = Cipher.getInstance(CIPHER_TRANSFORMATION);
            GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
            cipher.init(Cipher.ENCRYPT_MODE, sharedSecret, gcmSpec);
            
            // Encrypt
            byte[] ciphertext = cipher.doFinal(plaintext.getBytes("UTF-8"));
            
            // Combine IV and ciphertext
            byte[] combined = new byte[iv.length + ciphertext.length];
            System.arraycopy(iv, 0, combined, 0, iv.length);
            System.arraycopy(ciphertext, 0, combined, iv.length, ciphertext.length);
            
            return Base64.getEncoder().encodeToString(combined);
        } catch (Exception e) {
            logger.error("Encryption failed", e);
            throw e;
        }
    }
    
    /**
     * Decrypt a message using AES-256-GCM
     */
    public String decryptMessage(String encryptedBase64) throws Exception {
        if (sharedSecret == null) {
            throw new IllegalStateException("Key exchange not completed");
        }
        
        try {
            // Decode Base64
            byte[] combined = Base64.getDecoder().decode(encryptedBase64);
            
            // Extract IV and ciphertext
            byte[] iv = new byte[GCM_IV_LENGTH];
            byte[] ciphertext = new byte[combined.length - GCM_IV_LENGTH];
            System.arraycopy(combined, 0, iv, 0, iv.length);
            System.arraycopy(combined, iv.length, ciphertext, 0, ciphertext.length);
            
            // Initialize cipher
            Cipher cipher = Cipher.getInstance(CIPHER_TRANSFORMATION);
            GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
            cipher.init(Cipher.DECRYPT_MODE, sharedSecret, gcmSpec);
            
            // Decrypt
            byte[] plaintext = cipher.doFinal(ciphertext);
            
            return new String(plaintext, "UTF-8");
        } catch (Exception e) {
            logger.error("Decryption failed", e);
            throw e;
        }
    }
    
    /**
     * Get handshake steps for debugging
     */
    public List<String> getHandshakeSteps() {
        return new ArrayList<>(handshakeSteps);
    }
    
    /**
     * Check if key exchange is complete
     */
    public boolean isKeyExchangeComplete() {
        return sharedSecret != null;
    }
    
    /**
     * Reset the crypto service
     */
    public void reset() {
        keyPair = null;
        sharedSecret = null;
        handshakeSteps.clear();
        logger.info("Crypto service reset");
    }
}

// Made with Bob
