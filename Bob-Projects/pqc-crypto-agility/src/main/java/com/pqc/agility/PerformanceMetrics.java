package com.pqc.agility;

/**
 * Performance metrics for cryptographic operations
 */
public class PerformanceMetrics {
    private final long keyGenTimeMs;
    private final long encryptTimeMs;
    private final long decryptTimeMs;
    private final long signTimeMs;
    private final long verifyTimeMs;
    private final int publicKeySize;
    private final int privateKeySize;
    private final int ciphertextSize;
    private final int signatureSize;
    
    private PerformanceMetrics(Builder builder) {
        this.keyGenTimeMs = builder.keyGenTimeMs;
        this.encryptTimeMs = builder.encryptTimeMs;
        this.decryptTimeMs = builder.decryptTimeMs;
        this.signTimeMs = builder.signTimeMs;
        this.verifyTimeMs = builder.verifyTimeMs;
        this.publicKeySize = builder.publicKeySize;
        this.privateKeySize = builder.privateKeySize;
        this.ciphertextSize = builder.ciphertextSize;
        this.signatureSize = builder.signatureSize;
    }
    
    public long getKeyGenTimeMs() { return keyGenTimeMs; }
    public long getEncryptTimeMs() { return encryptTimeMs; }
    public long getDecryptTimeMs() { return decryptTimeMs; }
    public long getSignTimeMs() { return signTimeMs; }
    public long getVerifyTimeMs() { return verifyTimeMs; }
    public int getPublicKeySize() { return publicKeySize; }
    public int getPrivateKeySize() { return privateKeySize; }
    public int getCiphertextSize() { return ciphertextSize; }
    public int getSignatureSize() { return signatureSize; }
    
    public static class Builder {
        private long keyGenTimeMs;
        private long encryptTimeMs;
        private long decryptTimeMs;
        private long signTimeMs;
        private long verifyTimeMs;
        private int publicKeySize;
        private int privateKeySize;
        private int ciphertextSize;
        private int signatureSize;
        
        public Builder keyGenTimeMs(long keyGenTimeMs) {
            this.keyGenTimeMs = keyGenTimeMs;
            return this;
        }
        
        public Builder encryptTimeMs(long encryptTimeMs) {
            this.encryptTimeMs = encryptTimeMs;
            return this;
        }
        
        public Builder decryptTimeMs(long decryptTimeMs) {
            this.decryptTimeMs = decryptTimeMs;
            return this;
        }
        
        public Builder signTimeMs(long signTimeMs) {
            this.signTimeMs = signTimeMs;
            return this;
        }
        
        public Builder verifyTimeMs(long verifyTimeMs) {
            this.verifyTimeMs = verifyTimeMs;
            return this;
        }
        
        public Builder publicKeySize(int publicKeySize) {
            this.publicKeySize = publicKeySize;
            return this;
        }
        
        public Builder privateKeySize(int privateKeySize) {
            this.privateKeySize = privateKeySize;
            return this;
        }
        
        public Builder ciphertextSize(int ciphertextSize) {
            this.ciphertextSize = ciphertextSize;
            return this;
        }
        
        public Builder signatureSize(int signatureSize) {
            this.signatureSize = signatureSize;
            return this;
        }
        
        public PerformanceMetrics build() {
            return new PerformanceMetrics(this);
        }
    }
}

// Made with Bob
