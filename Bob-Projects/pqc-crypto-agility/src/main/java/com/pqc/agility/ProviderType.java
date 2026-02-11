package com.pqc.agility;

/**
 * Types of cryptographic providers
 */
public enum ProviderType {
    /**
     * Classical cryptography (RSA, ECDSA, AES, etc.)
     */
    CLASSICAL,
    
    /**
     * Post-Quantum cryptography (Kyber, Dilithium, SPHINCS+, etc.)
     */
    POST_QUANTUM,
    
    /**
     * Hybrid mode combining classical and post-quantum
     */
    HYBRID;
    
    public boolean isQuantumSafe() {
        return this == POST_QUANTUM || this == HYBRID;
    }
}

// Made with Bob
