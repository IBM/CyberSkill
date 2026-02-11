package com.pqc.agility;

/**
 * Result of key encapsulation operation (KEM)
 */
public class EncapsulationResult {
    private final byte[] ciphertext;
    private final byte[] sharedSecret;
    
    public EncapsulationResult(byte[] ciphertext, byte[] sharedSecret) {
        this.ciphertext = ciphertext;
        this.sharedSecret = sharedSecret;
    }
    
    public byte[] getCiphertext() {
        return ciphertext;
    }
    
    public byte[] getSharedSecret() {
        return sharedSecret;
    }
}

// Made with Bob
