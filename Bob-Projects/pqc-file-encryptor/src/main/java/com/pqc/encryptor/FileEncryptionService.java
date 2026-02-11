package com.pqc.encryptor;

import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.SecretKey;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.KeyPair;
import java.security.PrivateKey;
import java.util.Base64;
import java.util.Map;

/**
 * File Encryption Service - Orchestrates file encryption/decryption with PQC
 * Updated to use Java22PQCCryptoService with async operations
 */
public class FileEncryptionService {
    private static final Logger logger = LoggerFactory.getLogger(FileEncryptionService.class);
    
    private final Java22PQCCryptoService cryptoService;
    private final FileStorageService storageService;
    private final String uploadDirectory;
    private final String encryptedDirectory;
    
    public FileEncryptionService(Java22PQCCryptoService cryptoService, FileStorageService storageService, JsonObject config) {
        this.cryptoService = cryptoService;
        this.storageService = storageService;
        this.uploadDirectory = config.getString("uploadDirectory", "uploads");
        this.encryptedDirectory = config.getString("encryptedDirectory", "uploads/encrypted");
        
        // Create directories if they don't exist
        createDirectories();
        
        logger.info("File Encryption Service initialized - Upload dir: {}, Encrypted dir: {}", 
                uploadDirectory, encryptedDirectory);
    }
    
    /**
     * Encrypt a file using hybrid PQC approach (async)
     */
    public Future<JsonObject> encryptFile(String filePath, String kemAlgorithm, int aesKeySize) {
        Promise<JsonObject> promise = Promise.promise();
        
        try {
            logger.info("═══════════════════════════════════════════════════════");
            logger.info("🔐 ENCRYPTION REQUEST RECEIVED");
            logger.info("   File: {}", filePath);
            logger.info("   KEM Algorithm: {}", kemAlgorithm);
            logger.info("   AES Key Size: {} bits", aesKeySize);
            logger.info("═══════════════════════════════════════════════════════");
            
            // Read file
            Path path = Paths.get(uploadDirectory, filePath);
            byte[] fileData = Files.readAllBytes(path);
            long originalSize = fileData.length;
            logger.info("✓ Step 1: File read successfully - {} bytes", originalSize);
            
            // Parse Kyber variant - handle both "kyber512" and "kyber_512" formats
            String normalizedAlgorithm = kemAlgorithm.toUpperCase().replace("KYBER", "KYBER_");
            Java22PQCCryptoService.KyberVariant variant = Java22PQCCryptoService.KyberVariant.valueOf(normalizedAlgorithm);
            logger.info("✓ Step 2: Kyber variant parsed - {}", variant.name());
            
            // Chain async operations
            logger.info("⚙ Step 3: Generating Kyber key pair...");
            cryptoService.generateKyberKeyPair(variant)
                .<JsonObject>compose(kyberKeyPair -> {
                    // Step 2: Generate AES key
                    return cryptoService.generateAESKey()
                        .compose(aesKey -> {
                            // Step 3: Encapsulate AES key with Kyber public key
                            return cryptoService.encapsulateAESKey(aesKey, kyberKeyPair.getPublic(), variant)
                                .compose(encapsulationResult -> {
                                    // Step 4: Encrypt file data with AES
                                    return cryptoService.encryptData(fileData, aesKey)
                                        .compose(encryptionResult -> {
                                            try {
                                                // Step 5: Create encrypted file package
                                                String encryptedFileName = "enc_" + System.currentTimeMillis() + "_" + filePath;
                                                Path encryptedPath = Paths.get(encryptedDirectory, encryptedFileName);
                                                
                                                // Create package with metadata (including protected AES key for decryption)
                                                JsonObject packageData = new JsonObject()
                                                    .put("encapsulated_key", encapsulationResult.get("encapsulated_key"))
                                                    .put("protected_aes_key", encapsulationResult.get("protected_aes_key"))
                                                    .put("iv", encryptionResult.get("iv"))
                                                    .put("ciphertext", encryptionResult.get("ciphertext"))
                                                    .put("kem_algorithm", kemAlgorithm)
                                                    .put("aes_key_size", aesKeySize);
                                                
                                                // Write encrypted package to file
                                                Files.writeString(encryptedPath, packageData.encode());
                                                
                                                // Calculate sizes
                                                long encryptedSize = Files.size(encryptedPath);
                                                int publicKeySize = kyberKeyPair.getPublic().getEncoded().length;
                                                int privateKeySize = kyberKeyPair.getPrivate().getEncoded().length;
                                                int encapsulatedKeySize = Base64.getDecoder().decode(encapsulationResult.get("encapsulated_key")).length;
                                                
                                                // Store private key (Base64 encoded)
                                                String privateKeyBase64 = Base64.getEncoder().encodeToString(kyberKeyPair.getPrivate().getEncoded());
                                                
                                                // Save to database
                                                // Build metadata object
                                                JsonObject metadata = new JsonObject()
                                                    .put("fileName", filePath)
                                                    .put("originalSize", originalSize)
                                                    .put("encryptedSize", encryptedSize)
                                                    .put("encryptionAlgorithm", "AES-" + aesKeySize + "-GCM")
                                                    .put("kemAlgorithm", kemAlgorithm)
                                                    .put("aesKeySize", aesKeySize)
                                                    .put("kyberPublicKeySize", publicKeySize)
                                                    .put("kyberPrivateKeySize", privateKeySize)
                                                    .put("kyberCiphertextSize", encapsulatedKeySize)
                                                    .put("classicalKeySize", 256)
                                                    .put("pqcOverheadBytes", encapsulatedKeySize - 256)
                                                    .put("pqcOverheadPercentage", ((encapsulatedKeySize - 256) * 100.0 / 256))
                                                    .put("encryptedFilePath", encryptedFileName)
                                                    .put("status", "encrypted")
                                                    .put("notes", "Private key: " + privateKeyBase64);
                                                
                                                // Store in file-based storage
                                                return storageService.storeEncryptionRecord(metadata)
                                                    .compose(v -> {
                                                        String recordId = metadata.getString("record_id");
                                                        // Update key statistics
                                                        return storageService.updateKeyStatistics(
                                                            kemAlgorithm,
                                                            publicKeySize,
                                                            privateKeySize,
                                                            encapsulatedKeySize
                                                        ).compose(v2 -> {
                                                            // Build result
                                                            JsonObject result = new JsonObject()
                                                                .put("success", true)
                                                                .put("record_id", recordId)
                                                                .put("original_file", filePath)
                                                                .put("encrypted_file", encryptedFileName)
                                                                .put("original_size", originalSize)
                                                                .put("encrypted_size", encryptedSize)
                                                                .put("kem_algorithm", kemAlgorithm)
                                                                .put("aes_algorithm", "AES-" + aesKeySize + "-GCM")
                                                                .put("public_key_size", publicKeySize)
                                                                .put("private_key_size", privateKeySize)
                                                                .put("encapsulated_key_size", encapsulatedKeySize)
                                                                .put("size_comparison", cryptoService.getKeySizeComparison(variant));
                                                            
                                                            logger.info("File encryption completed - Record ID: {}", recordId);
                                                            return Future.succeededFuture(result);
                                                        });
                                                });
                                            } catch (Exception e) {
                                                return Future.failedFuture(e);
                                            }
                                        });
                                });
                        });
                })
                .onSuccess(promise::complete)
                .onFailure(err -> {
                    logger.error("File encryption failed", err);
                    promise.fail(err);
                });
                
        } catch (Exception e) {
            logger.error("File encryption failed", e);
            promise.fail(e);
        }
        
        return promise.future();
    }
    
    /**
     * Decrypt a file using stored private key (async)
     */
    public Future<JsonObject> decryptFile(String recordId) {
        Promise<JsonObject> promise = Promise.promise();
        
        storageService.getEncryptionRecord(recordId)
            .<JsonObject>compose(record -> {
                try {
                    // Handle both field name formats
                    String encryptedFileName = record.getString("encrypted_file_name");
                    if (encryptedFileName == null) {
                        encryptedFileName = record.getString("encryptedFilePath");
                    }
                    String kemAlgorithm = record.getString("kem_algorithm");
                    if (kemAlgorithm == null) {
                        kemAlgorithm = record.getString("kemAlgorithm");
                    }
                    String privateKeyBase64 = record.getString("private_key_base64");
                    if (privateKeyBase64 == null) {
                        privateKeyBase64 = record.getString("notes");
                        if (privateKeyBase64 != null && privateKeyBase64.startsWith("Private key: ")) {
                            privateKeyBase64 = privateKeyBase64.substring("Private key: ".length());
                        }
                    }
                    
                    logger.info("Starting file decryption - Record ID: {}, File: {}", recordId, encryptedFileName);
                    
                    // Read encrypted package
                    Path encryptedPath = Paths.get(encryptedDirectory, encryptedFileName);
                    String packageJson = Files.readString(encryptedPath);
                    JsonObject packageData = new JsonObject(packageJson);
                    
                    // Extract components
                    String encapsulatedKeyBase64 = packageData.getString("encapsulated_key");
                    String protectedAesKey = packageData.getString("protected_aes_key");
                    String ivBase64 = packageData.getString("iv");
                    String ciphertextBase64 = packageData.getString("ciphertext");
                    
                    // Decode private key - use ML-KEM algorithm for Java 24
                    byte[] privateKeyBytes = Base64.getDecoder().decode(privateKeyBase64);
                    
                    // Parse variant first to get algorithm name
                    String normalizedAlgorithm = kemAlgorithm.toUpperCase().replace("KYBER", "KYBER_");
                    Java22PQCCryptoService.KyberVariant variant = Java22PQCCryptoService.KyberVariant.valueOf(normalizedAlgorithm);
                    
                    // Use ML-KEM KeyFactory for Java 24
                    java.security.KeyFactory keyFactory = java.security.KeyFactory.getInstance(variant.getAlgorithm());
                    PrivateKey privateKey = keyFactory.generatePrivate(new java.security.spec.PKCS8EncodedKeySpec(privateKeyBytes));
                    
                    // Create encapsulation result map for decapsulation
                    java.util.Map<String, String> encapsulationResult = new java.util.HashMap<>();
                    encapsulationResult.put("encapsulated_key", encapsulatedKeyBase64);
                    encapsulationResult.put("protected_aes_key", protectedAesKey);
                    
                    // Decapsulate AES key
                    return cryptoService.decapsulateAESKey(encapsulationResult, privateKey, variant)
                        .compose(aesKey -> {
                            // Decrypt file data
                            return cryptoService.decryptData(ciphertextBase64, ivBase64, aesKey)
                                .compose(decryptedData -> {
                                    try {
                                        // Write decrypted file - handle both field name formats
                                        String originalFileName = record.getString("original_file_name");
                                        if (originalFileName == null) {
                                            originalFileName = record.getString("fileName");
                                        }
                                        
                                        logger.info("Original file name: {}", originalFileName);
                                        
                                        String decryptedFileName = "dec_" + System.currentTimeMillis() + "_" + originalFileName;
                                        Path decryptedPath = Paths.get(uploadDirectory, decryptedFileName);
                                        Files.write(decryptedPath, decryptedData);
                                        
                                        logger.info("Decrypted file written to: {}, size: {} bytes", decryptedPath, decryptedData.length);
                                        
                                        // Build result (no timestamp update needed for file storage)
                                        JsonObject result = new JsonObject()
                                            .put("success", true)
                                            .put("record_id", recordId)
                                            .put("decrypted_file", decryptedFileName)
                                            .put("original_file", originalFileName)
                                            .put("decrypted_size", decryptedData.length);
                                        
                                        logger.info("File decryption completed - Record ID: {}, Result: {}", recordId, result.encode());
                                        return Future.succeededFuture(result);
                                    } catch (Exception e) {
                                        return Future.failedFuture(e);
                                    }
                                });
                        });
                } catch (Exception e) {
                    return Future.failedFuture(e);
                }
            })
            .onSuccess(promise::complete)
            .onFailure(err -> {
                logger.error("File decryption failed", err);
                promise.fail(err);
            });
        
        return promise.future();
    }
    
    /**
     * Create necessary directories
     */
    private void createDirectories() {
        try {
            Files.createDirectories(Paths.get(uploadDirectory));
            Files.createDirectories(Paths.get(encryptedDirectory));
            logger.info("Directories created/verified");
        } catch (IOException e) {
            logger.error("Failed to create directories", e);
        }
    }
}

// Made with Bob
