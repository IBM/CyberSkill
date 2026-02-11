package com.pqc.agility.demo;

import com.pqc.agility.*;
import com.pqc.agility.policy.*;
import com.pqc.agility.providers.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.security.KeyPair;
import java.util.Arrays;

/**
 * Comprehensive demo of the Post-Quantum Crypto Agility Runtime
 */
public class CryptoAgilityDemo {
    private static final Logger logger = LoggerFactory.getLogger(CryptoAgilityDemo.class);
    
    public static void main(String[] args) {
        logger.info("=== Post-Quantum Crypto Agility Runtime Demo ===\n");
        
        try {
            // Initialize runtime
            PolicyEngine policyEngine = new PolicyEngine();
            CryptoAgilityRuntime runtime = new CryptoAgilityRuntime(policyEngine);
            
            // Register providers
            registerProviders(runtime);
            
            // Demo 1: Policy-based provider selection
            demo1_PolicyBasedSelection(runtime);
            
            // Demo 2: Runtime provider switching
            demo2_RuntimeSwitching(runtime);
            
            // Demo 3: Hybrid crypto with failover
            demo3_HybridWithFailover(runtime);
            
            // Demo 4: Threat model evaluation
            demo4_ThreatModelEvaluation(runtime);
            
            // Demo 5: Performance comparison
            demo5_PerformanceComparison(runtime);
            
            logger.info("\n=== Demo Complete ===");
            
        } catch (Exception e) {
            logger.error("Demo failed", e);
        }
    }
    
    private static void registerProviders(CryptoAgilityRuntime runtime) {
        logger.info("Registering cryptographic providers...");
        
        // Classical providers
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new RSAProvider(4096));
        
        // Post-Quantum providers (Java 24 native - no dependencies!)
        runtime.registerProvider(new Java24KyberProvider("Kyber512"));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        runtime.registerProvider(new Java24KyberProvider("Kyber1024"));
        
        // Hybrid providers (Classical + Java 24 PQC)
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new Java24KyberProvider("Kyber768")
        ));
        
        runtime.registerProvider(new HybridProvider(
            new RSAProvider(4096),
            new Java24KyberProvider("Kyber1024")
        ));
        
        logger.info("Registered {} providers (using Java 24 native PQC)\n", runtime.getAllProviders().size());
    }
    
    private static void demo1_PolicyBasedSelection(CryptoAgilityRuntime runtime) 
            throws CryptoException {
        logger.info("=== Demo 1: Policy-Based Provider Selection ===");
        
        // Low security scenario
        CryptoProvider provider = runtime.selectProvider(ThreatModel.LOW_SECURITY);
        logger.info("Low security selected: {}", provider.getAlgorithmName());
        
        // Standard scenario
        provider = runtime.selectProvider(ThreatModel.STANDARD);
        logger.info("Standard security selected: {}", provider.getAlgorithmName());
        
        // Quantum-safe scenario
        provider = runtime.selectProvider(ThreatModel.QUANTUM_SAFE);
        logger.info("Quantum-safe selected: {}", provider.getAlgorithmName());
        
        // Government scenario
        provider = runtime.selectProvider(ThreatModel.GOVERNMENT);
        logger.info("Government security selected: {}\n", provider.getAlgorithmName());
    }
    
    private static void demo2_RuntimeSwitching(CryptoAgilityRuntime runtime) 
            throws CryptoException {
        logger.info("=== Demo 2: Runtime Provider Switching ===");
        
        // Start with RSA
        runtime.switchProvider("RSA-2048");
        logger.info("Active provider: {}", runtime.getActiveProvider().getAlgorithmName());
        
        // Perform encryption
        byte[] testData = "Sensitive data".getBytes();
        KeyPair keyPair = runtime.getActiveProvider().generateKeyPair();
        EncapsulationResult result = runtime.getActiveProvider().encapsulate(keyPair.getPublic());
        logger.info("Encrypted with RSA-2048");
        
        // Switch to Kyber at runtime
        runtime.switchProvider("Kyber768");
        logger.info("Switched to: {}", runtime.getActiveProvider().getAlgorithmName());
        
        // Perform encryption with new provider
        keyPair = runtime.getActiveProvider().generateKeyPair();
        result = runtime.getActiveProvider().encapsulate(keyPair.getPublic());
        logger.info("Encrypted with Kyber768\n");
    }
    
    private static void demo3_HybridWithFailover(CryptoAgilityRuntime runtime) 
            throws CryptoException {
        logger.info("=== Demo 3: Hybrid Crypto with Live Failover ===");
        
        // Use hybrid provider
        CryptoProvider hybrid = runtime.getProvider("Hybrid-RSA-2048-Kyber768");
        if (hybrid == null) {
            logger.warn("Hybrid provider not available");
            return;
        }
        
        logger.info("Using hybrid provider: {}", hybrid.getAlgorithmName());
        logger.info("Quantum-safe: {}", hybrid.isQuantumSafe());
        logger.info("Security level: {} bits", hybrid.getSecurityLevel());
        
        // Generate hybrid key pair
        KeyPair keyPair = hybrid.generateKeyPair();
        logger.info("Generated hybrid key pair");
        
        // Perform KEM encapsulation
        EncapsulationResult result = hybrid.encapsulate(keyPair.getPublic());
        logger.info("Encapsulated shared secret (ciphertext size: {} bytes)", 
            result.getCiphertext().length);
        
        // Decapsulate
        byte[] recoveredSecret = hybrid.decapsulate(result.getCiphertext(), keyPair.getPrivate());
        logger.info("Decapsulated shared secret");
        
        // Verify secrets match
        boolean match = Arrays.equals(result.getSharedSecret(), recoveredSecret);
        logger.info("Secrets match: {}\n", match);
    }
    
    private static void demo4_ThreatModelEvaluation(CryptoAgilityRuntime runtime) {
        logger.info("=== Demo 4: Threat Model Evaluation ===");
        
        // Create custom threat model
        ThreatModel customThreat = new ThreatModel.Builder()
            .name("financial-services")
            .threatLevel(ThreatModel.ThreatLevel.HIGH)
            .quantumThreat(true)
            .harvestNowDecryptLater(true)
            .dataLifetimeYears(15)
            .compliance(ThreatModel.ComplianceRequirement.PCI_DSS)
            .build();
        
        logger.info("Custom threat model: {}", customThreat.getName());
        logger.info("Requires quantum-safe: {}", customThreat.requiresQuantumSafe());
        
        // Select provider based on threat model
        CryptoProvider provider = runtime.selectProvider(customThreat);
        logger.info("Selected provider: {}", provider.getAlgorithmName());
        logger.info("Provider type: {}", provider.getProviderType());
        logger.info("Quantum-safe: {}\n", provider.isQuantumSafe());
    }
    
    private static void demo5_PerformanceComparison(CryptoAgilityRuntime runtime) {
        logger.info("=== Demo 5: Performance Comparison ===");
        
        for (CryptoProvider provider : runtime.getAvailableProviders()) {
            PerformanceMetrics metrics = provider.getPerformanceMetrics();
            
            logger.info("\nProvider: {}", provider.getAlgorithmName());
            logger.info("  Type: {}", provider.getProviderType());
            logger.info("  Quantum-safe: {}", provider.isQuantumSafe());
            logger.info("  Key generation: {} ms", metrics.getKeyGenTimeMs());
            logger.info("  Encryption: {} ms", metrics.getEncryptTimeMs());
            logger.info("  Decryption: {} ms", metrics.getDecryptTimeMs());
            logger.info("  Public key size: {} bytes", metrics.getPublicKeySize());
            logger.info("  Private key size: {} bytes", metrics.getPrivateKeySize());
            logger.info("  Ciphertext size: {} bytes", metrics.getCiphertextSize());
        }
        
        // Display runtime stats
        CryptoAgilityRuntime.RuntimeStats stats = runtime.getStats();
        logger.info("\n=== Runtime Statistics ===");
        logger.info("Total providers: {}", stats.getTotalProviders());
        logger.info("Available providers: {}", stats.getAvailableProviders());
        logger.info("Active provider: {}", stats.getActiveProvider());
        logger.info("Failover enabled: {}", stats.isFailoverEnabled());
    }
}

// Made with Bob
