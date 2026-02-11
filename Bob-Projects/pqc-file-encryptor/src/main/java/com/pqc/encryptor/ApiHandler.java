package com.pqc.encryptor;

import io.vertx.core.Handler;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.FileUpload;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * API Handler - Handles HTTP requests for the PQC File Encryptor
 */
public class ApiHandler {
    private static final Logger logger = LoggerFactory.getLogger(ApiHandler.class);
    
    private final FileEncryptionService encryptionService;
    private final FileStorageService storageService;
    private final String uploadDirectory;
    
    public ApiHandler(FileEncryptionService encryptionService, FileStorageService storageService, String uploadDirectory) {
        this.encryptionService = encryptionService;
        this.storageService = storageService;
        this.uploadDirectory = uploadDirectory;
    }
    
    /**
     * Handle file upload
     */
    public Handler<RoutingContext> handleFileUpload() {
        return ctx -> {
            try {
                FileUpload upload = ctx.fileUploads().iterator().next();
                String uploadedFileName = upload.fileName();
                String uploadedFilePath = upload.uploadedFileName();
                
                // Move file to upload directory
                Path source = Paths.get(uploadedFilePath);
                Path target = Paths.get(uploadDirectory, uploadedFileName);
                Files.move(source, target, StandardCopyOption.REPLACE_EXISTING);
                
                logger.info("File uploaded - Name: {}, Size: {} bytes", uploadedFileName, upload.size());
                
                ctx.response()
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject()
                                .put("success", true)
                                .put("fileName", uploadedFileName)
                                .put("size", upload.size())
                                .encode());
                
            } catch (Exception e) {
                logger.error("File upload failed", e);
                ctx.response()
                        .setStatusCode(500)
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject()
                                .put("success", false)
                                .put("error", e.getMessage())
                                .encode());
            }
        };
    }
    
    /**
     * Handle file encryption request
     */
    public Handler<RoutingContext> handleEncrypt() {
        return ctx -> {
            JsonObject body = ctx.body().asJsonObject();
            String fileName = body.getString("fileName");
            String kemAlgorithm = body.getString("kemAlgorithm", "Kyber1024");
            int aesKeySize = body.getInteger("aesKeySize", 256);
            
            logger.info("Encryption request - File: {}, KEM: {}, AES: {}", fileName, kemAlgorithm, aesKeySize);
            
            encryptionService.encryptFile(fileName, kemAlgorithm, aesKeySize)
                    .onSuccess(result -> {
                        logger.info("Encryption successful");
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", result)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Encryption failed", err);
                        ctx.response()
                                .setStatusCode(500)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
    
    /**
     * Handle file decryption request
     */
    public Handler<RoutingContext> handleDecrypt() {
        return ctx -> {
            JsonObject body = ctx.body().asJsonObject();
            String recordId = body.getString("recordId");
            
            logger.info("Decryption request - Record ID: {}", recordId);
            
            encryptionService.decryptFile(recordId)
                    .onSuccess(result -> {
                        logger.info("Decryption successful");
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", result)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Decryption failed", err);
                        ctx.response()
                                .setStatusCode(500)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
    
    /**
     * Get all encryption records
     */
    public Handler<RoutingContext> handleGetRecords() {
        return ctx -> {
            int limit = Integer.parseInt(ctx.request().getParam("limit", "100"));
            int offset = Integer.parseInt(ctx.request().getParam("offset", "0"));
            logger.info("Fetching encryption records - limit: {}, offset: {}", limit, offset);
            
            storageService.getEncryptionRecords(limit, offset)
                    .onSuccess(records -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", records)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Failed to fetch records", err);
                        ctx.response()
                                .setStatusCode(500)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
    
    /**
     * Get encryption record by ID
     */
    public Handler<RoutingContext> handleGetRecord() {
        return ctx -> {
            String id = ctx.pathParam("id");
            logger.info("Fetching encryption record - ID: {}", id);
            
            storageService.getEncryptionRecord(id)
                    .onSuccess(record -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", record)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Failed to fetch record", err);
                        ctx.response()
                                .setStatusCode(404)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
    
    /**
     * Get dashboard statistics
     */
    public Handler<RoutingContext> handleGetDashboard() {
        return ctx -> {
            logger.info("Fetching dashboard statistics");
            
            storageService.getStatistics()
                    .compose(summary ->
                        storageService.getKeyStatistics()
                                .map(stats -> new JsonObject()
                                        .put("summary", summary)
                                        .put("keyStatistics", stats))
                    )
                    .onSuccess(dashboard -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", dashboard)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Failed to fetch dashboard data", err);
                        ctx.response()
                                .setStatusCode(500)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
    
    /**
     * Get key statistics
     */
    public Handler<RoutingContext> handleGetKeyStats() {
        return ctx -> {
            logger.info("Fetching key statistics");
            
            storageService.getKeyStatistics()
                    .onSuccess(stats -> {
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", stats)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Failed to fetch key statistics", err);
                        ctx.response()
                                .setStatusCode(500)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
    
    /**
     * Get size comparison data
     */
    public Handler<RoutingContext> handleGetSizeComparison() {
        return ctx -> {
            logger.info("Fetching size comparison data");
            
            storageService.getKeyStatistics()
                    .onSuccess(stats -> {
                        // Build size comparison from key statistics
                        JsonArray comparison = new JsonArray();
                        stats.forEach(stat -> {
                            JsonObject statObj = (JsonObject) stat;
                            comparison.add(new JsonObject()
                                    .put("algorithm", statObj.getString("algorithm"))
                                    .put("publicKeySize", statObj.getInteger("avg_public_key_size"))
                                    .put("privateKeySize", statObj.getInteger("avg_private_key_size"))
                                    .put("encapsulatedKeySize", statObj.getInteger("avg_encapsulated_key_size"))
                                    .put("totalUses", statObj.getInteger("total_uses")));
                        });
                        
                        ctx.response()
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", true)
                                        .put("data", comparison)
                                        .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Failed to fetch size comparison", err);
                        ctx.response()
                                .setStatusCode(500)
                                .putHeader("Content-Type", "application/json")
                                .end(new JsonObject()
                                        .put("success", false)
                                        .put("error", err.getMessage())
                                        .encode());
                    });
        };
    }
}

// Made with Bob
