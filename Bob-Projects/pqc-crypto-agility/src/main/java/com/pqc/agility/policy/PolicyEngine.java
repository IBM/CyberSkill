package com.pqc.agility.policy;

import com.pqc.agility.ProviderType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Policy engine that evaluates threat models and generates crypto policies
 */
public class PolicyEngine {
    private static final Logger logger = LoggerFactory.getLogger(PolicyEngine.class);
    
    /**
     * Evaluate a threat model and generate appropriate crypto policy
     */
    public CryptoPolicy evaluatePolicy(ThreatModel threatModel) {
        logger.info("Evaluating policy for threat model: {}", threatModel.getName());
        
        CryptoPolicy.Builder policyBuilder = new CryptoPolicy.Builder()
            .name("policy-for-" + threatModel.getName());
        
        // Determine if quantum-safe crypto is required
        if (threatModel.requiresQuantumSafe()) {
            logger.info("Quantum-safe crypto required for threat model: {}", threatModel.getName());
            policyBuilder.requiresQuantumSafe(true);
            policyBuilder.allowClassical(false);
            
            // Prefer hybrid for transition period
            if (threatModel.getThreatLevel().ordinal() < ThreatModel.ThreatLevel.CRITICAL.ordinal()) {
                policyBuilder.requiredProviderType(ProviderType.HYBRID);
            } else {
                policyBuilder.requiredProviderType(ProviderType.POST_QUANTUM);
            }
        } else {
            policyBuilder.allowClassical(true);
            policyBuilder.allowHybrid(true);
        }
        
        // Set minimum security level based on threat level
        int minSecurityLevel = switch (threatModel.getThreatLevel()) {
            case LOW -> 128;
            case MEDIUM -> 192;
            case HIGH -> 256;
            case CRITICAL -> 256;
        };
        policyBuilder.minSecurityLevel(minSecurityLevel);
        
        // Adjust performance requirements based on threat level
        if (threatModel.getThreatLevel().ordinal() >= ThreatModel.ThreatLevel.HIGH.ordinal()) {
            // High security can tolerate slower operations
            policyBuilder.maxKeyGenTimeMs(10000);
            policyBuilder.maxEncryptTimeMs(2000);
        } else {
            // Lower security prioritizes performance
            policyBuilder.maxKeyGenTimeMs(3000);
            policyBuilder.maxEncryptTimeMs(500);
        }
        
        // Handle compliance requirements
        if (threatModel.getCompliance() != ThreatModel.ComplianceRequirement.NONE) {
            logger.info("Compliance requirement: {}", threatModel.getCompliance());
            applyComplianceRequirements(policyBuilder, threatModel.getCompliance());
        }
        
        CryptoPolicy policy = policyBuilder.build();
        logger.info("Generated policy: quantum-safe={}, minSecurity={}, providerType={}", 
            policy.requiresQuantumSafe(), policy.getMinSecurityLevel(), policy.getRequiredProviderType());
        
        return policy;
    }
    
    /**
     * Apply compliance-specific requirements to policy
     */
    private void applyComplianceRequirements(CryptoPolicy.Builder policyBuilder, 
                                            ThreatModel.ComplianceRequirement compliance) {
        switch (compliance) {
            case FIPS_140_2, FIPS_140_3 -> {
                // FIPS requires validated implementations
                policyBuilder.minSecurityLevel(128);
            }
            case CNSA_2_0 -> {
                // CNSA 2.0 requires quantum-safe crypto
                policyBuilder.requiresQuantumSafe(true);
                policyBuilder.minSecurityLevel(256);
                policyBuilder.allowClassical(false);
            }
            case PCI_DSS -> {
                // PCI DSS requires strong encryption
                policyBuilder.minSecurityLevel(128);
            }
            case HIPAA, GDPR -> {
                // Healthcare and privacy regulations
                policyBuilder.minSecurityLevel(192);
            }
        }
    }
    
    /**
     * Create a custom policy
     */
    public CryptoPolicy createCustomPolicy(String name, 
                                          boolean requiresQuantumSafe,
                                          int minSecurityLevel,
                                          ProviderType providerType) {
        return new CryptoPolicy.Builder()
            .name(name)
            .requiresQuantumSafe(requiresQuantumSafe)
            .minSecurityLevel(minSecurityLevel)
            .requiredProviderType(providerType)
            .build();
    }
}

// Made with Bob
