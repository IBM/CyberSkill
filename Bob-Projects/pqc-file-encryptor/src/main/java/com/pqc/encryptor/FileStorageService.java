package com.pqc.encryptor;

import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * File-based storage service for encryption records.
 * Stores data in JSON files as a reliable alternative to database.
 */
public class FileStorageService {
    private static final Logger logger = LoggerFactory.getLogger(FileStorageService.class);
    private final Vertx vertx;
    private final String storageDir;
    private final String recordsFile;
    private final String statsFile;
    private final ConcurrentHashMap<String, JsonObject> recordsCache;
    private final ConcurrentHashMap<String, JsonObject> statsCache;

    public FileStorageService(Vertx vertx) {
        this.vertx = vertx;
        this.storageDir = "data";
        this.recordsFile = storageDir + "/encryption_records.json";
        this.statsFile = storageDir + "/key_statistics.json";
        this.recordsCache = new ConcurrentHashMap<>();
        this.statsCache = new ConcurrentHashMap<>();
        
        // Create storage directory
        new File(storageDir).mkdirs();
        
        // Load existing data
        loadData();
        
        logger.info("FileStorageService initialized - Storage: {}", storageDir);
    }

    private void loadData() {
        try {
            // Load records
            Path recordsPath = Paths.get(recordsFile);
            if (Files.exists(recordsPath)) {
                String content = Files.readString(recordsPath);
                JsonArray records = new JsonArray(content);
                records.forEach(obj -> {
                    JsonObject record = (JsonObject) obj;
                    recordsCache.put(record.getString("record_id"), record);
                });
                logger.info("Loaded {} encryption records from file", recordsCache.size());
            }
            
            // Load stats
            Path statsPath = Paths.get(statsFile);
            if (Files.exists(statsPath)) {
                String content = Files.readString(statsPath);
                JsonArray stats = new JsonArray(content);
                stats.forEach(obj -> {
                    JsonObject stat = (JsonObject) obj;
                    statsCache.put(stat.getString("algorithm"), stat);
                });
                logger.info("Loaded {} key statistics from file", statsCache.size());
            }
        } catch (Exception e) {
            logger.warn("Could not load existing data: {}", e.getMessage());
        }
    }

    private Future<Void> saveRecords() {
        Promise<Void> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                JsonArray records = new JsonArray(
                    new ArrayList<>(recordsCache.values())
                );
                Files.writeString(
                    Paths.get(recordsFile),
                    records.encodePrettily(),
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING
                );
                blockingPromise.complete();
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false, result -> {
            if (result.succeeded()) {
                promise.complete();
            } else {
                logger.error("Failed to save records", result.cause());
                promise.fail(result.cause());
            }
        });
        
        return promise.future();
    }

    private Future<Void> saveStats() {
        Promise<Void> promise = Promise.promise();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                JsonArray stats = new JsonArray(
                    new ArrayList<>(statsCache.values())
                );
                Files.writeString(
                    Paths.get(statsFile),
                    stats.encodePrettily(),
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING
                );
                blockingPromise.complete();
            } catch (Exception e) {
                blockingPromise.fail(e);
            }
        }, false, result -> {
            if (result.succeeded()) {
                promise.complete();
            } else {
                logger.error("Failed to save stats", result.cause());
                promise.fail(result.cause());
            }
        });
        
        return promise.future();
    }

    public Future<Void> storeEncryptionRecord(JsonObject record) {
        Promise<Void> promise = Promise.promise();
        
        try {
            String recordId = record.getString("record_id");
            
            // Generate record_id if not present
            if (recordId == null || recordId.isEmpty()) {
                recordId = String.valueOf(System.currentTimeMillis());
                record.put("record_id", recordId);
                logger.warn("Generated missing record_id: {}", recordId);
            }
            
            // Add timestamp if not present
            if (!record.containsKey("created_at")) {
                record.put("created_at", Instant.now().toString());
            }
            
            // Store in cache
            recordsCache.put(recordId, record);
            
            // Save to file (use final variable for lambda)
            final String finalRecordId = recordId;
            saveRecords().onComplete(ar -> {
                if (ar.succeeded()) {
                    logger.info("Stored encryption record: {}", finalRecordId);
                    promise.complete();
                } else {
                    logger.error("Failed to save record to file", ar.cause());
                    promise.fail(ar.cause());
                }
            });
        } catch (Exception e) {
            logger.error("Error storing encryption record", e);
            promise.fail(e);
        }
        
        return promise.future();
    }

    public Future<Void> updateKeyStatistics(String algorithm, int publicKeySize, int privateKeySize, int encapsulatedKeySize) {
        Promise<Void> promise = Promise.promise();
        
        try {
            JsonObject stat = statsCache.getOrDefault(algorithm, new JsonObject()
                .put("algorithm", algorithm)
                .put("total_uses", 0)
                .put("avg_public_key_size", 0)
                .put("avg_private_key_size", 0)
                .put("avg_encapsulated_key_size", 0)
            );
            
            int totalUses = stat.getInteger("total_uses") + 1;
            int avgPublicKeySize = ((stat.getInteger("avg_public_key_size") * (totalUses - 1)) + publicKeySize) / totalUses;
            int avgPrivateKeySize = ((stat.getInteger("avg_private_key_size") * (totalUses - 1)) + privateKeySize) / totalUses;
            int avgEncapsulatedKeySize = ((stat.getInteger("avg_encapsulated_key_size") * (totalUses - 1)) + encapsulatedKeySize) / totalUses;
            
            stat.put("total_uses", totalUses);
            stat.put("avg_public_key_size", avgPublicKeySize);
            stat.put("avg_private_key_size", avgPrivateKeySize);
            stat.put("avg_encapsulated_key_size", avgEncapsulatedKeySize);
            stat.put("last_used", Instant.now().toString());
            
            statsCache.put(algorithm, stat);
            
            saveStats().onComplete(ar -> {
                if (ar.succeeded()) {
                    logger.info("Updated statistics for algorithm: {}", algorithm);
                    promise.complete();
                } else {
                    logger.error("Failed to save stats to file", ar.cause());
                    promise.fail(ar.cause());
                }
            });
        } catch (Exception e) {
            logger.error("Error updating key statistics", e);
            promise.fail(e);
        }
        
        return promise.future();
    }

    public Future<JsonArray> getEncryptionRecords(int limit, int offset) {
        Promise<JsonArray> promise = Promise.promise();
        
        try {
            List<JsonObject> sortedRecords = recordsCache.values().stream()
                .sorted(Comparator.comparing((JsonObject r) -> r.getString("created_at", "")).reversed())
                .skip(offset)
                .limit(limit)
                .collect(Collectors.toList());
            
            JsonArray result = new JsonArray(sortedRecords);
            logger.info("Retrieved {} encryption records (offset: {}, limit: {})", result.size(), offset, limit);
            promise.complete(result);
        } catch (Exception e) {
            logger.error("Error retrieving encryption records", e);
            promise.fail(e);
        }
        
        return promise.future();
    }

    public Future<JsonObject> getEncryptionRecord(String recordId) {
        Promise<JsonObject> promise = Promise.promise();
        
        try {
            JsonObject record = recordsCache.get(recordId);
            if (record != null) {
                logger.info("Retrieved encryption record: {}", recordId);
                promise.complete(record);
            } else {
                logger.warn("Encryption record not found: {}", recordId);
                promise.fail("Record not found");
            }
        } catch (Exception e) {
            logger.error("Error retrieving encryption record", e);
            promise.fail(e);
        }
        
        return promise.future();
    }

    public Future<JsonArray> getKeyStatistics() {
        Promise<JsonArray> promise = Promise.promise();
        
        try {
            JsonArray result = new JsonArray(new ArrayList<>(statsCache.values()));
            logger.info("Retrieved {} key statistics", result.size());
            promise.complete(result);
        } catch (Exception e) {
            logger.error("Error retrieving key statistics", e);
            promise.fail(e);
        }
        
        return promise.future();
    }

    public Future<JsonObject> getStatistics() {
        Promise<JsonObject> promise = Promise.promise();
        
        try {
            int totalRecords = recordsCache.size();
            
            // Count by algorithm
            JsonObject algorithmCounts = new JsonObject();
            recordsCache.values().forEach(record -> {
                String algo = record.getString("kem_algorithm", "unknown");
                algorithmCounts.put(algo, algorithmCounts.getInteger(algo, 0) + 1);
            });
            
            // Calculate average sizes
            int totalPublicKeySize = 0;
            int totalPrivateKeySize = 0;
            int totalEncapsulatedKeySize = 0;
            
            for (JsonObject stat : statsCache.values()) {
                totalPublicKeySize += stat.getInteger("avg_public_key_size", 0);
                totalPrivateKeySize += stat.getInteger("avg_private_key_size", 0);
                totalEncapsulatedKeySize += stat.getInteger("avg_encapsulated_key_size", 0);
            }
            
            int algorithmCount = statsCache.size();
            
            JsonObject stats = new JsonObject()
                .put("total_encryptions", totalRecords)
                .put("algorithms_used", algorithmCount)
                .put("algorithm_distribution", algorithmCounts)
                .put("avg_public_key_size", algorithmCount > 0 ? totalPublicKeySize / algorithmCount : 0)
                .put("avg_private_key_size", algorithmCount > 0 ? totalPrivateKeySize / algorithmCount : 0)
                .put("avg_encapsulated_key_size", algorithmCount > 0 ? totalEncapsulatedKeySize / algorithmCount : 0);
            
            logger.info("Retrieved overall statistics");
            promise.complete(stats);
        } catch (Exception e) {
            logger.error("Error retrieving statistics", e);
            promise.fail(e);
        }
        
        return promise.future();
    }
}

// Made with Bob
