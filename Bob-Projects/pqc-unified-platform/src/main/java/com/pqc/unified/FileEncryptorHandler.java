package com.pqc.unified;

import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.FileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

/**
 * Handler for File Encryptor functionality
 * Encrypts and decrypts files using PQC key exchange and AES-256-GCM
 */
public class FileEncryptorHandler {
    private static final Logger logger = LoggerFactory.getLogger(FileEncryptorHandler.class);
    
    private final Vertx vertx;
    private final JsonObject config;
    private final String uploadDir;
    private final String encryptedDir;
    private final PQCCryptoService cryptoService;
    
    public FileEncryptorHandler(Vertx vertx, JsonObject config) {
        this.vertx = vertx;
        this.config = config;
        
        JsonObject fileConfig = config.getJsonObject("fileStorage", new JsonObject());
        this.uploadDir = fileConfig.getString("uploadDir", "uploads");
        this.encryptedDir = fileConfig.getString("encryptedDir", "uploads/encrypted");
        
        // Initialize crypto service
        this.cryptoService = new PQCCryptoService();
        try {
            cryptoService.generateKeyPair();
            logger.info("File encryptor crypto service initialized");
        } catch (Exception e) {
            logger.error("Failed to initialize crypto service", e);
        }
    }
    
    public void handleEncrypt(RoutingContext ctx) {
        List<FileUpload> uploads = ctx.fileUploads();
        
        if (uploads == null || uploads.isEmpty()) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "No file uploaded")
                    .encode());
            return;
        }
        
        FileUpload upload = uploads.iterator().next();
        String uploadedFile = upload.uploadedFileName();
        String originalFilename = upload.fileName();
        
        logger.info("Encrypting file: {}", originalFilename);
        
        vertx.executeBlocking(promise -> {
            try {
                // Read file
                byte[] fileData = Files.readAllBytes(Paths.get(uploadedFile));
                
                // Generate new key pair for this file
                PQCCryptoService fileCrypto = new PQCCryptoService();
                fileCrypto.generateKeyPair();
                
                // Simulate key exchange (in real scenario, this would be with recipient's public key)
                byte[] publicKey = fileCrypto.getPublicKeyBytes();
                byte[] encapsulatedKey = fileCrypto.performKeyEncapsulation(publicKey);
                
                // Encrypt file
                PQCCryptoService.EncryptedData encrypted = fileCrypto.encrypt(fileData);
                
                // Generate encrypted filename
                String encryptedFilename = "enc_" + System.currentTimeMillis() + "_" + originalFilename;
                String encryptedPath = encryptedDir + "/" + encryptedFilename;
                
                // Save encrypted file
                Files.write(Paths.get(encryptedPath), encrypted.getCiphertext());
                
                // Save metadata
                JsonObject metadata = new JsonObject()
                    .put("originalFilename", originalFilename)
                    .put("encryptedFilename", encryptedFilename)
                    .put("encryptedPath", encryptedPath)
                    .put("fileSize", fileData.length)
                    .put("encryptedSize", encrypted.getCiphertext().length)
                    .put("iv", encrypted.getIvBase64())
                    .put("encapsulatedKey", Base64.getEncoder().encodeToString(encapsulatedKey))
                    .put("publicKey", fileCrypto.getPublicKeyBase64())
                    .put("timestamp", System.currentTimeMillis())
                    .put("algorithm", "ML-KEM-768 + AES-256-GCM");
                
                // Save metadata file
                String metadataPath = encryptedPath + ".meta.json";
                Files.writeString(Paths.get(metadataPath), metadata.encodePrettily());
                
                // Clean up uploaded file
                Files.deleteIfExists(Paths.get(uploadedFile));
                
                promise.complete(metadata);
                
            } catch (Exception e) {
                logger.error("Encryption failed", e);
                promise.fail(e);
            }
        }, res -> {
            if (res.succeeded()) {
                JsonObject result = (JsonObject) res.result();
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("success", true)
                        .put("message", "File encrypted successfully")
                        .put("data", result)
                        .encode());
            } else {
                ctx.response()
                    .setStatusCode(500)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Encryption failed: " + res.cause().getMessage())
                        .encode());
            }
        });
    }
    
    public void handleDecrypt(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String encryptedFilename = body.getString("filename");
        
        if (encryptedFilename == null) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Filename is required")
                    .encode());
            return;
        }
        
        logger.info("Decrypting file: {}", encryptedFilename);
        
        vertx.executeBlocking(promise -> {
            try {
                String encryptedPath = encryptedDir + "/" + encryptedFilename;
                String metadataPath = encryptedPath + ".meta.json";
                
                // Read metadata
                String metadataJson = Files.readString(Paths.get(metadataPath));
                JsonObject metadata = new JsonObject(metadataJson);
                
                // Read encrypted file
                byte[] encryptedData = Files.readAllBytes(Paths.get(encryptedPath));
                
                // Get decryption parameters
                byte[] iv = Base64.getDecoder().decode(metadata.getString("iv"));
                byte[] encapsulatedKey = Base64.getDecoder().decode(metadata.getString("encapsulatedKey"));
                
                // Create crypto service and perform decapsulation
                PQCCryptoService fileCrypto = new PQCCryptoService();
                fileCrypto.generateKeyPair(); // In real scenario, use stored private key
                fileCrypto.performKeyDecapsulation(encapsulatedKey);
                
                // Decrypt file
                byte[] decryptedData = fileCrypto.decrypt(encryptedData, iv);
                
                // Save decrypted file
                String originalFilename = metadata.getString("originalFilename");
                String decryptedFilename = "dec_" + System.currentTimeMillis() + "_" + originalFilename;
                String decryptedPath = uploadDir + "/" + decryptedFilename;
                
                Files.write(Paths.get(decryptedPath), decryptedData);
                
                JsonObject result = new JsonObject()
                    .put("originalFilename", originalFilename)
                    .put("decryptedFilename", decryptedFilename)
                    .put("decryptedPath", decryptedPath)
                    .put("fileSize", decryptedData.length)
                    .put("timestamp", System.currentTimeMillis());
                
                promise.complete(result);
                
            } catch (Exception e) {
                logger.error("Decryption failed", e);
                promise.fail(e);
            }
        }, res -> {
            if (res.succeeded()) {
                JsonObject result = (JsonObject) res.result();
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("success", true)
                        .put("message", "File decrypted successfully")
                        .put("data", result)
                        .encode());
            } else {
                ctx.response()
                    .setStatusCode(500)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Decryption failed: " + res.cause().getMessage())
                        .encode());
            }
        });
    }
    
    public void handleListFiles(RoutingContext ctx) {
        vertx.executeBlocking(promise -> {
            try {
                File encDir = new File(encryptedDir);
                File[] files = encDir.listFiles((dir, name) -> !name.endsWith(".meta.json"));
                
                JsonArray fileList = new JsonArray();
                
                if (files != null) {
                    for (File file : files) {
                        String metadataPath = file.getAbsolutePath() + ".meta.json";
                        
                        JsonObject fileInfo = new JsonObject()
                            .put("filename", file.getName())
                            .put("size", file.length())
                            .put("lastModified", file.lastModified());
                        
                        // Try to read metadata
                        if (Files.exists(Paths.get(metadataPath))) {
                            try {
                                String metadataJson = Files.readString(Paths.get(metadataPath));
                                JsonObject metadata = new JsonObject(metadataJson);
                                fileInfo.put("originalFilename", metadata.getString("originalFilename"));
                                fileInfo.put("algorithm", metadata.getString("algorithm"));
                            } catch (Exception e) {
                                logger.warn("Failed to read metadata for {}", file.getName());
                            }
                        }
                        
                        fileList.add(fileInfo);
                    }
                }
                
                promise.complete(fileList);
                
            } catch (Exception e) {
                logger.error("Failed to list files", e);
                promise.fail(e);
            }
        }, res -> {
            if (res.succeeded()) {
                JsonArray files = (JsonArray) res.result();
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("files", files)
                        .put("total", files.size())
                        .encode());
            } else {
                ctx.response()
                    .setStatusCode(500)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Failed to list files")
                        .encode());
            }
        });
    }
    
    public void handleDownload(RoutingContext ctx) {
        String filename = ctx.pathParam("filename");
        String filePath = uploadDir + "/" + filename;
        
        File file = new File(filePath);
        if (!file.exists()) {
            // Try encrypted directory
            filePath = encryptedDir + "/" + filename;
            file = new File(filePath);
        }
        
        if (!file.exists()) {
            ctx.response()
                .setStatusCode(404)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "File not found")
                    .encode());
            return;
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/octet-stream")
            .putHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"")
            .sendFile(filePath);
    }
}

// Made with Bob
