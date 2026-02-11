package com.pqc.agility.providers;

import com.pqc.agility.*;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import org.bouncycastle.pqc.jcajce.spec.KyberParameterSpec;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.KeyAgreement;
import java.security.*;
import java.security.spec.AlgorithmParameterSpec;
import java.util.HashMap;

/**
 * Pure Java Kyber provider using Bouncy Castle PQC.
 * No native libraries required!
 * 
 * This is the recommended provider for production use due to:
 * - No native dependencies
 * - Cross-platform compatibility
 * - Easy deployment
 * - Full Java debugging support
 */
public class BouncyCastleKyberProvider implements CryptoProvider {
    private static final Logger logger = LoggerFactory.getLogger(BouncyCastleKyberProvider.class);
    
    private final String variant;
    private final String algorithmName;
    private final KyberParameterSpec parameterSpec;
    private final boolean available;
    private final int securityLevel;
    
    static {
        // Register Bouncy Castle providers
        Security.addProvider(new BouncyCastleProvider());
        Security.addProvider(new BouncyCastlePQCProvider());
    }
    
    /**
     * Create a Kyber provider with specified variant
     * @param variant "Kyber512", "Kyber768", or "Kyber1024"
     */
    public BouncyCastleKyberProvider(String variant) {
        this.variant = variant;
        this.algorithmName = "BC-" + variant; // Prefix to distinguish from liboqs version
        this.parameterSpec = getParameterSpec(variant);
        this.securityLevel = getSecurityLevelForVariant(variant);
        this.available = checkAvailability();
    }
    
    private KyberParameterSpec getParameterSpec(String variant) {
        return switch (variant) {
            case "Kyber512" -> KyberParameterSpec.kyber512;
            case "Kyber768" -> KyberParameterSpec.kyber768;
            case "Kyber1024" -> KyberParameterSpec.kyber1024;
            default -> KyberParameterSpec.kyber768;
        };
    }
    
    private int getSecurityLevelForVariant(String variant) {
        return switch (variant) {
            case "Kyber512" -> 128;
            case "Kyber768" -> 192;
            case "Kyber1024" -> 256;
            default -> 128;
        };
    }
    
    private boolean checkAvailability() {
        try {
            // Test if we can create a KeyPairGenerator
            KeyPairGenerator keyGen = KeyPairGenerator.getInstance("Kyber", "BCPQC");
            keyGen.initialize(parameterSpec, new SecureRandom());
            return true;
        } catch (Exception e) {
            logger.error("Bouncy Castle Kyber provider not available", e);
            return false;
        }
    }
    
    @Override
    public String getAlgorithmName() {
        return algorithmName;
    }
    
    @Override
    public ProviderType getProviderType() {
        return ProviderType.POST_QUANTUM;
    }
    
    @Override
    public int getSecurityLevel() {
        return securityLevel;
    }
    
    @Override
    public KeyPair generateKeyPair() throws CryptoException {
        try {
            KeyPairGenerator keyGen = KeyPairGenerator.getInstance("Kyber", "BCPQC");
            keyGen.initialize(parameterSpec, new SecureRandom());
            return keyGen.generateKeyPair();
        } catch (Exception e) {
            throw new CryptoException("Failed to generate Kyber key pair", e);
        }
    }
    
    @Override
    public byte[] encrypt(byte[] data, PublicKey publicKey) throws CryptoException {
        // Kyber is a KEM, not encryption. Use encapsulate() instead
        throw new CryptoException("Kyber is a KEM - use encapsulate() instead of encrypt()");
    }
    
    @Override
    public byte[] decrypt(byte[] encryptedData, PrivateKey privateKey) throws CryptoException {
        throw new CryptoException("Kyber is a KEM - use decapsulate() instead of decrypt()");
    }
    
    @Override
    public byte[] sign(byte[] data, PrivateKey privateKey) throws CryptoException {
        throw new CryptoException("Kyber is a KEM - use Dilithium for signatures");
    }
    
    @Override
    public boolean verify(byte[] data, byte[] signature, PublicKey publicKey) throws CryptoException {
        throw new CryptoException("Kyber is a KEM - use Dilithium for signatures");
    }
    
    @Override
    public EncapsulationResult encapsulate(PublicKey publicKey) throws CryptoException {
        try {
            // Use KeyAgreement for KEM operations
            KeyAgreement keyAgreement = KeyAgreement.getInstance("Kyber", "BCPQC");
            
            // Generate ephemeral key pair
            KeyPair ephemeralKeyPair = generateKeyPair();
            
            // Initialize with our private key
            keyAgreement.init(ephemeralKeyPair.getPrivate());
            
            // Do key agreement with peer's public key
            keyAgreement.doPhase(publicKey, true);
            
            // Generate shared secret
            byte[] sharedSecret = keyAgreement.generateSecret();
            
            // The "ciphertext" is our ephemeral public key
            byte[] ciphertext = ephemeralKeyPair.getPublic().getEncoded();
            
            return new EncapsulationResult(ciphertext, sharedSecret);
        } catch (Exception e) {
            throw new CryptoException("Kyber encapsulation failed", e);
        }
    }
    
    @Override
    public byte[] decapsulate(byte[] ciphertext, PrivateKey privateKey) throws CryptoException {
        try {
            // Reconstruct the ephemeral public key from ciphertext
            KeyFactory keyFactory = KeyFactory.getInstance("Kyber", "BCPQC");
            PublicKey ephemeralPublicKey = keyFactory.generatePublic(
                new java.security.spec.X509EncodedKeySpec(ciphertext)
            );
            
            // Use KeyAgreement to recover shared secret
            KeyAgreement keyAgreement = KeyAgreement.getInstance("Kyber", "BCPQC");
            keyAgreement.init(privateKey);
            keyAgreement.doPhase(ephemeralPublicKey, true);
            
            return keyAgreement.generateSecret();
        } catch (Exception e) {
            throw new CryptoException("Kyber decapsulation failed", e);
        }
    }
    
    @Override
    public boolean isQuantumSafe() {
        return true;
    }
    
    @Override
    public boolean supportsKEM() {
        return true;
    }
    
    @Override
    public PerformanceMetrics getPerformanceMetrics() {
        // Approximate metrics for Bouncy Castle Kyber
        // Slightly slower than native but still very fast
        int keyGenTime = switch (variant) {
            case "Kyber512" -> 80;   // vs 50ms native
            case "Kyber768" -> 120;  // vs 80ms native
            case "Kyber1024" -> 180; // vs 120ms native
            default -> 120;
        };
        
        int publicKeySize = switch (variant) {
            case "Kyber512" -> 800;
            case "Kyber768" -> 1184;
            case "Kyber1024" -> 1568;
            default -> 1184;
        };
        
        int privateKeySize = switch (variant) {
            case "Kyber512" -> 1632;
            case "Kyber768" -> 2400;
            case "Kyber1024" -> 3168;
            default -> 2400;
        };
        
        int ciphertextSize = switch (variant) {
            case "Kyber512" -> 768;
            case "Kyber768" -> 1088;
            case "Kyber1024" -> 1568;
            default -> 1088;
        };
        
        return new PerformanceMetrics.Builder()
            .keyGenTimeMs(keyGenTime)
            .encryptTimeMs(8)  // vs 5ms native
            .decryptTimeMs(8)  // vs 5ms native
            .publicKeySize(publicKeySize)
            .privateKeySize(privateKeySize)
            .ciphertextSize(ciphertextSize)
            .build();
    }
    
    @Override
    public boolean isAvailable() {
        return available;
    }
    
    @Override
    public ProviderMetadata getMetadata() {
        return new ProviderMetadata.Builder()
            .name(algorithmName)
            .version("1.0")
            .description("Bouncy Castle Pure Java Kyber - NIST PQC standardized (no native dependencies)")
            .type(ProviderType.POST_QUANTUM)
            .securityLevel(securityLevel)
            .quantumSafe(true)
            .supportsKEM(true)
            .supportsSignatures(false)
            .additionalInfo(new HashMap<>() {{
                put("variant", variant);
                put("standard", "NIST FIPS 203");
                put("type", "Lattice-based KEM");
                put("implementation", "Bouncy Castle Pure Java");
                put("nativeDependencies", "none");
            }})
            .build();
    }
}

// Made with Bob
