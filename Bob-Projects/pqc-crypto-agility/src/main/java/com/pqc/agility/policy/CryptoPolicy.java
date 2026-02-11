package com.pqc.agility.policy;

import com.pqc.agility.ProviderType;

/**
 * Cryptographic policy that defines requirements for provider selection
 */
public class CryptoPolicy {
    private final String name;
    private final boolean requiresQuantumSafe;
    private final int minSecurityLevel;
    private final ProviderType requiredProviderType;
    private final boolean allowHybrid;
    private final boolean allowClassical;
    private final int maxKeyGenTimeMs;
    private final int maxEncryptTimeMs;
    
    private CryptoPolicy(Builder builder) {
        this.name = builder.name;
        this.requiresQuantumSafe = builder.requiresQuantumSafe;
        this.minSecurityLevel = builder.minSecurityLevel;
        this.requiredProviderType = builder.requiredProviderType;
        this.allowHybrid = builder.allowHybrid;
        this.allowClassical = builder.allowClassical;
        this.maxKeyGenTimeMs = builder.maxKeyGenTimeMs;
        this.maxEncryptTimeMs = builder.maxEncryptTimeMs;
    }
    
    public String getName() { return name; }
    public boolean requiresQuantumSafe() { return requiresQuantumSafe; }
    public int getMinSecurityLevel() { return minSecurityLevel; }
    public ProviderType getRequiredProviderType() { return requiredProviderType; }
    public boolean allowsHybrid() { return allowHybrid; }
    public boolean allowsClassical() { return allowClassical; }
    public int getMaxKeyGenTimeMs() { return maxKeyGenTimeMs; }
    public int getMaxEncryptTimeMs() { return maxEncryptTimeMs; }
    
    public static class Builder {
        private String name = "default";
        private boolean requiresQuantumSafe = false;
        private int minSecurityLevel = 128;
        private ProviderType requiredProviderType = null;
        private boolean allowHybrid = true;
        private boolean allowClassical = true;
        private int maxKeyGenTimeMs = 5000;
        private int maxEncryptTimeMs = 1000;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        
        public Builder requiresQuantumSafe(boolean requiresQuantumSafe) {
            this.requiresQuantumSafe = requiresQuantumSafe;
            return this;
        }
        
        public Builder minSecurityLevel(int minSecurityLevel) {
            this.minSecurityLevel = minSecurityLevel;
            return this;
        }
        
        public Builder requiredProviderType(ProviderType requiredProviderType) {
            this.requiredProviderType = requiredProviderType;
            return this;
        }
        
        public Builder allowHybrid(boolean allowHybrid) {
            this.allowHybrid = allowHybrid;
            return this;
        }
        
        public Builder allowClassical(boolean allowClassical) {
            this.allowClassical = allowClassical;
            return this;
        }
        
        public Builder maxKeyGenTimeMs(int maxKeyGenTimeMs) {
            this.maxKeyGenTimeMs = maxKeyGenTimeMs;
            return this;
        }
        
        public Builder maxEncryptTimeMs(int maxEncryptTimeMs) {
            this.maxEncryptTimeMs = maxEncryptTimeMs;
            return this;
        }
        
        public CryptoPolicy build() {
            return new CryptoPolicy(this);
        }
    }
}

// Made with Bob
