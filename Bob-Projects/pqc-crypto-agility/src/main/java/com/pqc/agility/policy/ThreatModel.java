package com.pqc.agility.policy;

/**
 * Represents a threat model for cryptographic operations
 */
public class ThreatModel {
    private final String name;
    private final ThreatLevel threatLevel;
    private final boolean quantumThreat;
    private final boolean harvestNowDecryptLater;
    private final int dataLifetimeYears;
    private final ComplianceRequirement compliance;
    
    private ThreatModel(Builder builder) {
        this.name = builder.name;
        this.threatLevel = builder.threatLevel;
        this.quantumThreat = builder.quantumThreat;
        this.harvestNowDecryptLater = builder.harvestNowDecryptLater;
        this.dataLifetimeYears = builder.dataLifetimeYears;
        this.compliance = builder.compliance;
    }
    
    public String getName() { return name; }
    public ThreatLevel getThreatLevel() { return threatLevel; }
    public boolean hasQuantumThreat() { return quantumThreat; }
    public boolean hasHarvestNowDecryptLater() { return harvestNowDecryptLater; }
    public int getDataLifetimeYears() { return dataLifetimeYears; }
    public ComplianceRequirement getCompliance() { return compliance; }
    
    /**
     * Check if quantum-safe crypto is required
     */
    public boolean requiresQuantumSafe() {
        return quantumThreat || harvestNowDecryptLater || 
               (dataLifetimeYears > 10 && threatLevel.ordinal() >= ThreatLevel.HIGH.ordinal());
    }
    
    public enum ThreatLevel {
        LOW,
        MEDIUM,
        HIGH,
        CRITICAL
    }
    
    public enum ComplianceRequirement {
        NONE,
        FIPS_140_2,
        FIPS_140_3,
        CNSA_2_0,
        PCI_DSS,
        HIPAA,
        GDPR
    }
    
    public static class Builder {
        private String name = "default";
        private ThreatLevel threatLevel = ThreatLevel.MEDIUM;
        private boolean quantumThreat = false;
        private boolean harvestNowDecryptLater = false;
        private int dataLifetimeYears = 5;
        private ComplianceRequirement compliance = ComplianceRequirement.NONE;
        
        public Builder name(String name) {
            this.name = name;
            return this;
        }
        
        public Builder threatLevel(ThreatLevel threatLevel) {
            this.threatLevel = threatLevel;
            return this;
        }
        
        public Builder quantumThreat(boolean quantumThreat) {
            this.quantumThreat = quantumThreat;
            return this;
        }
        
        public Builder harvestNowDecryptLater(boolean harvestNowDecryptLater) {
            this.harvestNowDecryptLater = harvestNowDecryptLater;
            return this;
        }
        
        public Builder dataLifetimeYears(int dataLifetimeYears) {
            this.dataLifetimeYears = dataLifetimeYears;
            return this;
        }
        
        public Builder compliance(ComplianceRequirement compliance) {
            this.compliance = compliance;
            return this;
        }
        
        public ThreatModel build() {
            return new ThreatModel(this);
        }
    }
    
    // Predefined threat models
    public static final ThreatModel LOW_SECURITY = new Builder()
        .name("low-security")
        .threatLevel(ThreatLevel.LOW)
        .dataLifetimeYears(1)
        .build();
    
    public static final ThreatModel STANDARD = new Builder()
        .name("standard")
        .threatLevel(ThreatLevel.MEDIUM)
        .dataLifetimeYears(5)
        .build();
    
    public static final ThreatModel HIGH_SECURITY = new Builder()
        .name("high-security")
        .threatLevel(ThreatLevel.HIGH)
        .dataLifetimeYears(10)
        .build();
    
    public static final ThreatModel QUANTUM_SAFE = new Builder()
        .name("quantum-safe")
        .threatLevel(ThreatLevel.HIGH)
        .quantumThreat(true)
        .harvestNowDecryptLater(true)
        .dataLifetimeYears(20)
        .build();
    
    public static final ThreatModel GOVERNMENT = new Builder()
        .name("government")
        .threatLevel(ThreatLevel.CRITICAL)
        .quantumThreat(true)
        .harvestNowDecryptLater(true)
        .dataLifetimeYears(30)
        .compliance(ComplianceRequirement.CNSA_2_0)
        .build();
}

// Made with Bob
