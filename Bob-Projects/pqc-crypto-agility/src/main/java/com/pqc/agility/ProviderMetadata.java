package com.pqc.agility;

import java.util.Map;

/**
 * Metadata about a cryptographic provider
 */
public class ProviderMetadata {
    private final String name;
    private final String version;
    private final String description;
    private final ProviderType type;
    private final int securityLevel;
    private final boolean quantumSafe;
    private final boolean supportsKEM;
    private final boolean supportsSignatures;
    private final Map<String, String> additionalInfo;
    
    private ProviderMetadata(Builder builder) {
        this.name = builder.name;
        this.version = builder.version;
        this.description = builder.description;
        this.type = builder.type;
        this.securityLevel = builder.securityLevel;
        this.quantumSafe = builder.quantumSafe;
        this.supportsKEM = builder.supportsKEM;
        this.supportsSignatures = builder.supportsSignatures;
        this.additionalInfo = builder.additionalInfo;
    }
    
    public String getName() { return name; }
    public String getVersion() { return version; }
    public String getDescription() { return description; }
    public ProviderType getType() { return type; }
    public int getSecurityLevel() { return securityLevel; }
    public boolean isQuantumSafe() { return quantumSafe; }
    public boolean supportsKEM() { return supportsKEM; }
    public boolean supportsSignatures() { return supportsSignatures; }
    public Map<String, String> getAdditionalInfo() { return additionalInfo; }
    
    public static class Builder {
        private String name;
        private String version;
        private String description;
        private ProviderType type;
        private int securityLevel;
        private boolean quantumSafe;
        private boolean supportsKEM;
        private boolean supportsSignatures;
        private Map<String, String> additionalInfo;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        
        public Builder version(String version) {
            this.version = version;
            return this;
        }
        
        public Builder description(String description) {
            this.description = description;
            return this;
        }
        
        public Builder type(ProviderType type) {
            this.type = type;
            return this;
        }
        
        public Builder securityLevel(int securityLevel) {
            this.securityLevel = securityLevel;
            return this;
        }
        
        public Builder quantumSafe(boolean quantumSafe) {
            this.quantumSafe = quantumSafe;
            return this;
        }
        
        public Builder supportsKEM(boolean supportsKEM) {
            this.supportsKEM = supportsKEM;
            return this;
        }
        
        public Builder supportsSignatures(boolean supportsSignatures) {
            this.supportsSignatures = supportsSignatures;
            return this;
        }
        
        public Builder additionalInfo(Map<String, String> additionalInfo) {
            this.additionalInfo = additionalInfo;
            return this;
        }
        
        public ProviderMetadata build() {
            return new ProviderMetadata(this);
        }
    }
}

// Made with Bob
