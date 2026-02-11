package com.pqc.agility;

import com.pqc.agility.policy.CryptoPolicy;
import com.pqc.agility.policy.PolicyEngine;
import com.pqc.agility.policy.ThreatModel;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Main runtime for crypto agility.
 * Allows switching cryptographic primitives at runtime based on policy, threat model, or negotiation.
 */
public class CryptoAgilityRuntime {
    private static final Logger logger = LoggerFactory.getLogger(CryptoAgilityRuntime.class);
    
    private final Map<String, CryptoProvider> providers = new ConcurrentHashMap<>();
    private final List<CryptoProvider> availableProviders = new CopyOnWriteArrayList<>();
    private final PolicyEngine policyEngine;
    private volatile CryptoProvider activeProvider;
    private volatile boolean failoverEnabled = true;
    
    public CryptoAgilityRuntime(PolicyEngine policyEngine) {
        this.policyEngine = policyEngine;
    }
    
    /**
     * Register a cryptographic provider
     */
    public void registerProvider(CryptoProvider provider) {
        if (provider == null) {
            throw new IllegalArgumentException("Provider cannot be null");
        }
        
        String name = provider.getAlgorithmName();
        providers.put(name, provider);
        
        if (provider.isAvailable()) {
            availableProviders.add(provider);
            logger.info("Registered provider: {} (type: {}, quantum-safe: {})", 
                name, provider.getProviderType(), provider.isQuantumSafe());
        } else {
            logger.warn("Provider {} registered but not available", name);
        }
    }
    
    /**
     * Select provider based on current policy and threat model
     */
    public CryptoProvider selectProvider(ThreatModel threatModel) {
        CryptoPolicy policy = policyEngine.evaluatePolicy(threatModel);
        
        // Find best matching provider
        for (CryptoProvider provider : availableProviders) {
            if (matchesPolicy(provider, policy)) {
                logger.info("Selected provider: {} for threat model: {}", 
                    provider.getAlgorithmName(), threatModel.getName());
                activeProvider = provider;
                return provider;
            }
        }
        
        // Fallback to most secure available provider
        CryptoProvider fallback = getMostSecureProvider();
        logger.warn("No provider matches policy, using fallback: {}", 
            fallback != null ? fallback.getAlgorithmName() : "none");
        activeProvider = fallback;
        return fallback;
    }
    
    /**
     * Get currently active provider
     */
    public CryptoProvider getActiveProvider() {
        return activeProvider;
    }
    
    /**
     * Switch to a specific provider by name
     */
    public boolean switchProvider(String providerName) {
        CryptoProvider provider = providers.get(providerName);
        if (provider != null && provider.isAvailable()) {
            activeProvider = provider;
            logger.info("Switched to provider: {}", providerName);
            return true;
        }
        logger.error("Cannot switch to provider: {} (not found or unavailable)", providerName);
        return false;
    }
    
    /**
     * Attempt failover to another provider if current one fails
     */
    public CryptoProvider failover(Exception cause) {
        if (!failoverEnabled) {
            logger.warn("Failover disabled, cannot switch provider");
            return activeProvider;
        }
        
        logger.error("Provider {} failed, attempting failover", 
            activeProvider != null ? activeProvider.getAlgorithmName() : "none", cause);
        
        // Try to find alternative provider
        for (CryptoProvider provider : availableProviders) {
            if (provider != activeProvider && provider.isAvailable()) {
                activeProvider = provider;
                logger.info("Failover successful to provider: {}", provider.getAlgorithmName());
                return provider;
            }
        }
        
        logger.error("Failover failed - no alternative providers available");
        return null;
    }
    
    /**
     * Get provider by name
     */
    public CryptoProvider getProvider(String name) {
        return providers.get(name);
    }
    
    /**
     * Get all registered providers
     */
    public List<CryptoProvider> getAllProviders() {
        return List.copyOf(providers.values());
    }
    
    /**
     * Get all available (initialized) providers
     */
    public List<CryptoProvider> getAvailableProviders() {
        return List.copyOf(availableProviders);
    }
    
    /**
     * Enable or disable automatic failover
     */
    public void setFailoverEnabled(boolean enabled) {
        this.failoverEnabled = enabled;
        logger.info("Failover {}", enabled ? "enabled" : "disabled");
    }
    
    /**
     * Check if a provider matches the policy requirements
     */
    private boolean matchesPolicy(CryptoProvider provider, CryptoPolicy policy) {
        if (policy.requiresQuantumSafe() && !provider.isQuantumSafe()) {
            return false;
        }
        
        if (provider.getSecurityLevel() < policy.getMinSecurityLevel()) {
            return false;
        }
        
        if (policy.getRequiredProviderType() != null && 
            provider.getProviderType() != policy.getRequiredProviderType()) {
            return false;
        }
        
        return true;
    }
    
    /**
     * Get the most secure available provider
     */
    private CryptoProvider getMostSecureProvider() {
        CryptoProvider best = null;
        int maxSecurity = 0;
        
        for (CryptoProvider provider : availableProviders) {
            int security = provider.getSecurityLevel();
            if (provider.isQuantumSafe()) {
                security += 1000; // Prefer quantum-safe
            }
            
            if (security > maxSecurity) {
                maxSecurity = security;
                best = provider;
            }
        }
        
        return best;
    }
    
    /**
     * Get runtime statistics
     */
    public RuntimeStats getStats() {
        return new RuntimeStats(
            providers.size(),
            availableProviders.size(),
            activeProvider != null ? activeProvider.getAlgorithmName() : "none",
            failoverEnabled
        );
    }
    
    public static class RuntimeStats {
        private final int totalProviders;
        private final int availableProviders;
        private final String activeProvider;
        private final boolean failoverEnabled;
        
        public RuntimeStats(int totalProviders, int availableProviders, 
                          String activeProvider, boolean failoverEnabled) {
            this.totalProviders = totalProviders;
            this.availableProviders = availableProviders;
            this.activeProvider = activeProvider;
            this.failoverEnabled = failoverEnabled;
        }
        
        public int getTotalProviders() { return totalProviders; }
        public int getAvailableProviders() { return availableProviders; }
        public String getActiveProvider() { return activeProvider; }
        public boolean isFailoverEnabled() { return failoverEnabled; }
    }
}

// Made with Bob
