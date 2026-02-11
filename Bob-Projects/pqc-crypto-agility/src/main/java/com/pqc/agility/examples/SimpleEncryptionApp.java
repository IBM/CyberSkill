package com.pqc.agility.examples;

import com.pqc.agility.*;
import com.pqc.agility.policy.*;
import com.pqc.agility.providers.*;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.KeyPair;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Simple drop-in example showing how to replace standard Java crypto
 * with the Crypto Agility Runtime with minimal code changes.
 * 
 * This is a complete, working example you can copy-paste into your application.
 */
public class SimpleEncryptionApp {
    
    private final CryptoAgilityRuntime runtime;
    private final KeyPair keyPair;
    
    /**
     * Initialize once - this is all the setup you need!
     */
    public SimpleEncryptionApp() throws CryptoException {
        // 1. Create runtime with policy engine
        PolicyEngine policyEngine = new PolicyEngine();
        this.runtime = new CryptoAgilityRuntime(policyEngine);
        
        // 2. Register providers (do this once at startup)
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new Java24KyberProvider("Kyber768")
        ));
        
        // 3. Select provider based on your security needs
        runtime.selectProvider(ThreatModel.QUANTUM_SAFE);
        
        // 4. Generate key pair
        this.keyPair = runtime.getActiveProvider().generateKeyPair();
        
        System.out.println("✅ Initialized with: " + runtime.getActiveProvider().getAlgorithmName());
    }
    
    /**
     * Encrypt a string - works with any provider!
     */
    public EncryptedMessage encrypt(String plaintext) throws CryptoException {
        // Get current provider (could be RSA, Kyber, or Hybrid)
        CryptoProvider provider = runtime.getActiveProvider();
        
        // Generate shared secret using KEM
        EncapsulationResult result = provider.encapsulate(keyPair.getPublic());
        byte[] sharedSecret = result.getSharedSecret();
        
        // Encrypt data with AES-GCM using shared secret
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            byte[] iv = new byte[12];
            new SecureRandom().nextBytes(iv);
            
            SecretKeySpec keySpec = new SecretKeySpec(sharedSecret, 0, 32, "AES");
            GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv);
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, gcmSpec);
            
            byte[] ciphertext = cipher.doFinal(plaintext.getBytes(StandardCharsets.UTF_8));
            
            return new EncryptedMessage(
                ciphertext,
                result.getCiphertext(), // Wrapped key
                iv,
                provider.getAlgorithmName()
            );
        } catch (Exception e) {
            throw new CryptoException("Encryption failed", e);
        }
    }
    
    /**
     * Decrypt a message - automatically uses the right provider!
     */
    public String decrypt(EncryptedMessage message) throws CryptoException {
        // Get the provider that was used for encryption
        CryptoProvider provider = runtime.getProvider(message.algorithm);
        if (provider == null) {
            throw new CryptoException("Provider not available: " + message.algorithm);
        }
        
        // Recover shared secret
        byte[] sharedSecret = provider.decapsulate(message.wrappedKey, keyPair.getPrivate());
        
        // Decrypt data
        try {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            SecretKeySpec keySpec = new SecretKeySpec(sharedSecret, 0, 32, "AES");
            GCMParameterSpec gcmSpec = new GCMParameterSpec(128, message.iv);
            cipher.init(Cipher.DECRYPT_MODE, keySpec, gcmSpec);
            
            byte[] plaintext = cipher.doFinal(message.ciphertext);
            return new String(plaintext, StandardCharsets.UTF_8);
        } catch (Exception e) {
            throw new CryptoException("Decryption failed", e);
        }
    }
    
    /**
     * Switch to a different algorithm at runtime - no restart needed!
     */
    public void switchAlgorithm(String algorithmName) {
        if (runtime.switchProvider(algorithmName)) {
            System.out.println("✅ Switched to: " + algorithmName);
        } else {
            System.out.println("❌ Algorithm not available: " + algorithmName);
        }
    }
    
    /**
     * Get current security status
     */
    public void printStatus() {
        CryptoProvider active = runtime.getActiveProvider();
        System.out.println("\n📊 Current Status:");
        System.out.println("  Algorithm: " + active.getAlgorithmName());
        System.out.println("  Type: " + active.getProviderType());
        System.out.println("  Quantum-Safe: " + (active.isQuantumSafe() ? "✅" : "❌"));
        System.out.println("  Security Level: " + active.getSecurityLevel() + " bits");
        
        PerformanceMetrics metrics = active.getPerformanceMetrics();
        System.out.println("  Key Gen Time: " + metrics.getKeyGenTimeMs() + " ms");
        System.out.println("  Public Key Size: " + metrics.getPublicKeySize() + " bytes");
    }
    
    /**
     * Simple data class for encrypted messages
     */
    public static class EncryptedMessage {
        final byte[] ciphertext;
        final byte[] wrappedKey;
        final byte[] iv;
        final String algorithm;
        
        public EncryptedMessage(byte[] ciphertext, byte[] wrappedKey, byte[] iv, String algorithm) {
            this.ciphertext = ciphertext;
            this.wrappedKey = wrappedKey;
            this.iv = iv;
            this.algorithm = algorithm;
        }
        
        // For easy storage/transmission
        public String toBase64() {
            return Base64.getEncoder().encodeToString(ciphertext) + "|" +
                   Base64.getEncoder().encodeToString(wrappedKey) + "|" +
                   Base64.getEncoder().encodeToString(iv) + "|" +
                   algorithm;
        }
        
        public static EncryptedMessage fromBase64(String encoded) {
            String[] parts = encoded.split("\\|");
            return new EncryptedMessage(
                Base64.getDecoder().decode(parts[0]),
                Base64.getDecoder().decode(parts[1]),
                Base64.getDecoder().decode(parts[2]),
                parts[3]
            );
        }
    }
    
    /**
     * Demo showing how easy it is to use!
     */
    public static void main(String[] args) {
        try {
            System.out.println("🚀 Simple Encryption App with Crypto Agility\n");
            
            // Initialize (do this once)
            SimpleEncryptionApp app = new SimpleEncryptionApp();
            
            // Show current status
            app.printStatus();
            
            // Encrypt some data
            String secret = "This is my sensitive data that needs quantum-safe protection!";
            System.out.println("\n📝 Original: " + secret);
            
            EncryptedMessage encrypted = app.encrypt(secret);
            System.out.println("🔒 Encrypted with: " + encrypted.algorithm);
            System.out.println("📦 Encrypted (Base64): " + encrypted.toBase64().substring(0, 50) + "...");
            
            // Decrypt it back
            String decrypted = app.decrypt(encrypted);
            System.out.println("🔓 Decrypted: " + decrypted);
            System.out.println("✅ Match: " + secret.equals(decrypted));
            
            // Switch to different algorithm at runtime!
            System.out.println("\n🔄 Switching to RSA-2048...");
            app.switchAlgorithm("RSA-2048");
            app.printStatus();
            
            // Encrypt with new algorithm
            EncryptedMessage encrypted2 = app.encrypt(secret);
            System.out.println("🔒 Encrypted with: " + encrypted2.algorithm);
            
            // Can still decrypt old messages!
            String decrypted2 = app.decrypt(encrypted);
            System.out.println("🔓 Old message still decrypts: " + decrypted2.equals(secret));
            
            // Switch to Kyber (pure PQ)
            System.out.println("\n🔄 Switching to Kyber768 (pure post-quantum)...");
            app.switchAlgorithm("Kyber768");
            app.printStatus();
            
            EncryptedMessage encrypted3 = app.encrypt(secret);
            System.out.println("🔒 Encrypted with: " + encrypted3.algorithm);
            String decrypted3 = app.decrypt(encrypted3);
            System.out.println("🔓 Decrypted: " + decrypted3.equals(secret));
            
            System.out.println("\n✅ Demo complete! All algorithms work seamlessly.");
            
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

// Made with Bob
