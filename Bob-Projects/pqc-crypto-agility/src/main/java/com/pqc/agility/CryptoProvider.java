package com.pqc.agility;

import java.security.KeyPair;
import java.security.PrivateKey;
import java.security.PublicKey;

/**
 * Abstract interface for cryptographic providers.
 * Supports both classical and post-quantum algorithms with runtime switching.
 */
public interface CryptoProvider {
    
    /**
     * Get the algorithm name (e.g., "RSA-2048", "Kyber512", "Hybrid-RSA-Kyber")
     */
    String getAlgorithmName();
    
    /**
     * Get the provider type (CLASSICAL, POST_QUANTUM, HYBRID)
     */
    ProviderType getProviderType();
    
    /**
     * Get the security level in bits
     */
    int getSecurityLevel();
    
    /**
     * Generate a key pair
     */
    KeyPair generateKeyPair() throws CryptoException;
    
    /**
     * Encrypt data with a public key
     */
    byte[] encrypt(byte[] data, PublicKey publicKey) throws CryptoException;
    
    /**
     * Decrypt data with a private key
     */
    byte[] decrypt(byte[] encryptedData, PrivateKey privateKey) throws CryptoException;
    
    /**
     * Sign data with a private key
     */
    byte[] sign(byte[] data, PrivateKey privateKey) throws CryptoException;
    
    /**
     * Verify signature with a public key
     */
    boolean verify(byte[] data, byte[] signature, PublicKey publicKey) throws CryptoException;
    
    /**
     * Perform key encapsulation (KEM) - generate shared secret
     */
    EncapsulationResult encapsulate(PublicKey publicKey) throws CryptoException;
    
    /**
     * Perform key decapsulation (KEM) - recover shared secret
     */
    byte[] decapsulate(byte[] ciphertext, PrivateKey privateKey) throws CryptoException;
    
    /**
     * Check if this provider is quantum-safe
     */
    boolean isQuantumSafe();
    
    /**
     * Check if this provider supports key encapsulation mechanism
     */
    boolean supportsKEM();
    
    /**
     * Get performance metrics for this provider
     */
    PerformanceMetrics getPerformanceMetrics();
    
    /**
     * Check if provider is available and properly initialized
     */
    boolean isAvailable();
    
    /**
     * Get provider metadata
     */
    ProviderMetadata getMetadata();
}

// Made with Bob
