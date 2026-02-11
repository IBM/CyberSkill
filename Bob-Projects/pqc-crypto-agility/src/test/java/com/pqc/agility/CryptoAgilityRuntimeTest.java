package com.pqc.agility;

import com.pqc.agility.policy.PolicyEngine;
import com.pqc.agility.policy.ThreatModel;
import com.pqc.agility.providers.RSAProvider;
import com.pqc.agility.providers.Java24KyberProvider;
import com.pqc.agility.providers.HybridProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.security.KeyPair;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Tests for CryptoAgilityRuntime
 */
class CryptoAgilityRuntimeTest {
    
    private CryptoAgilityRuntime runtime;
    
    @BeforeEach
    void setUp() {
        PolicyEngine policyEngine = new PolicyEngine();
        runtime = new CryptoAgilityRuntime(policyEngine);
    }
    
    @Test
    void testProviderRegistration() {
        // Register providers
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        
        // Verify registration
        assertEquals(2, runtime.getAllProviders().size());
        assertNotNull(runtime.getProvider("RSA-2048"));
        assertNotNull(runtime.getProvider("Kyber768"));
    }
    
    @Test
    void testPolicyBasedSelection() {
        // Register providers
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        
        // Test low security selection
        CryptoProvider provider = runtime.selectProvider(ThreatModel.LOW_SECURITY);
        assertNotNull(provider);
        
        // Test quantum-safe selection
        provider = runtime.selectProvider(ThreatModel.QUANTUM_SAFE);
        assertNotNull(provider);
        assertTrue(provider.isQuantumSafe());
    }
    
    @Test
    void testRuntimeSwitching() {
        // Register providers
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        
        // Switch to RSA
        assertTrue(runtime.switchProvider("RSA-2048"));
        assertEquals("RSA-2048", runtime.getActiveProvider().getAlgorithmName());
        
        // Switch to Kyber
        assertTrue(runtime.switchProvider("Kyber768"));
        assertEquals("Kyber768", runtime.getActiveProvider().getAlgorithmName());
        
        // Try invalid provider
        assertFalse(runtime.switchProvider("NonExistent"));
    }
    
    @Test
    void testRSAProvider() throws CryptoException {
        RSAProvider rsa = new RSAProvider(2048);
        
        // Test availability
        assertTrue(rsa.isAvailable());
        assertEquals("RSA-2048", rsa.getAlgorithmName());
        assertEquals(ProviderType.CLASSICAL, rsa.getProviderType());
        assertFalse(rsa.isQuantumSafe());
        
        // Test key generation
        KeyPair keyPair = rsa.generateKeyPair();
        assertNotNull(keyPair);
        assertNotNull(keyPair.getPublic());
        assertNotNull(keyPair.getPrivate());
        
        // Test KEM
        EncapsulationResult result = rsa.encapsulate(keyPair.getPublic());
        assertNotNull(result.getCiphertext());
        assertNotNull(result.getSharedSecret());
        
        byte[] recoveredSecret = rsa.decapsulate(result.getCiphertext(), keyPair.getPrivate());
        assertArrayEquals(result.getSharedSecret(), recoveredSecret);
    }
    
    @Test
    void testJava24KyberProvider() throws CryptoException {
        Java24KyberProvider kyber = new Java24KyberProvider("Kyber768");
        
        // Test availability (may not be available without liboqs)
        if (!kyber.isAvailable()) {
            System.out.println("Kyber not available - skipping test");
            return;
        }
        
        assertEquals("Kyber768", kyber.getAlgorithmName());
        assertEquals(ProviderType.POST_QUANTUM, kyber.getProviderType());
        assertTrue(kyber.isQuantumSafe());
        assertTrue(kyber.supportsKEM());
        
        // Test key generation
        KeyPair keyPair = kyber.generateKeyPair();
        assertNotNull(keyPair);
        
        // Test KEM
        EncapsulationResult result = kyber.encapsulate(keyPair.getPublic());
        assertNotNull(result.getCiphertext());
        assertNotNull(result.getSharedSecret());
        
        byte[] recoveredSecret = kyber.decapsulate(result.getCiphertext(), keyPair.getPrivate());
        assertArrayEquals(result.getSharedSecret(), recoveredSecret);
    }
    
    @Test
    void testHybridProvider() throws CryptoException {
        HybridProvider hybrid = new HybridProvider(
            new RSAProvider(2048),
            new Java24KyberProvider("Kyber768")
        );
        
        // Test availability
        if (!hybrid.isAvailable()) {
            System.out.println("Hybrid not available - skipping test");
            return;
        }
        
        assertTrue(hybrid.getAlgorithmName().startsWith("Hybrid-"));
        assertEquals(ProviderType.HYBRID, hybrid.getProviderType());
        assertTrue(hybrid.isQuantumSafe());
        
        // Test key generation
        KeyPair keyPair = hybrid.generateKeyPair();
        assertNotNull(keyPair);
        assertTrue(keyPair.getPublic() instanceof HybridProvider.HybridPublicKey);
        assertTrue(keyPair.getPrivate() instanceof HybridProvider.HybridPrivateKey);
        
        // Test KEM
        EncapsulationResult result = hybrid.encapsulate(keyPair.getPublic());
        assertNotNull(result.getCiphertext());
        assertNotNull(result.getSharedSecret());
        
        byte[] recoveredSecret = hybrid.decapsulate(result.getCiphertext(), keyPair.getPrivate());
        assertArrayEquals(result.getSharedSecret(), recoveredSecret);
    }
    
    @Test
    void testFailover() {
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        
        // Enable failover
        runtime.setFailoverEnabled(true);
        
        // Set active provider
        runtime.switchProvider("RSA-2048");
        
        // Simulate failure and failover
        CryptoProvider fallback = runtime.failover(new Exception("Simulated failure"));
        assertNotNull(fallback);
        assertNotEquals("RSA-2048", fallback.getAlgorithmName());
    }
    
    @Test
    void testRuntimeStats() {
        runtime.registerProvider(new RSAProvider(2048));
        runtime.registerProvider(new Java24KyberProvider("Kyber768"));
        
        CryptoAgilityRuntime.RuntimeStats stats = runtime.getStats();
        assertEquals(2, stats.getTotalProviders());
        assertTrue(stats.getAvailableProviders() >= 1); // At least RSA should be available
    }
    
    @Test
    void testPerformanceMetrics() {
        RSAProvider rsa = new RSAProvider(2048);
        PerformanceMetrics metrics = rsa.getPerformanceMetrics();
        
        assertNotNull(metrics);
        assertTrue(metrics.getKeyGenTimeMs() > 0);
        assertTrue(metrics.getPublicKeySize() > 0);
        assertTrue(metrics.getPrivateKeySize() > 0);
    }
    
    @Test
    void testProviderMetadata() {
        RSAProvider rsa = new RSAProvider(2048);
        ProviderMetadata metadata = rsa.getMetadata();
        
        assertNotNull(metadata);
        assertEquals("RSA-2048", metadata.getName());
        assertEquals(ProviderType.CLASSICAL, metadata.getType());
        assertFalse(metadata.isQuantumSafe());
        assertTrue(metadata.supportsKEM());
        assertTrue(metadata.supportsSignatures());
    }
}

// Made with Bob
