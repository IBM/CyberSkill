package com.pqc.encryptor;

import io.vertx.core.Future;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Database Service - Handles PostgreSQL operations for metadata storage
 */
public class DatabaseService {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseService.class);
    
    private final PgPool client;
    
    public DatabaseService(io.vertx.core.Vertx vertx, JsonObject config) {
        // Configure PostgreSQL connection
        PgConnectOptions connectOptions = new PgConnectOptions()
                .setHost(config.getString("host", "localhost"))
                .setPort(config.getInteger("port", 5432))
                .setDatabase(config.getString("database", "pqc_encryptor"))
                .setUser(config.getString("user", "postgres"))
                .setPassword(config.getString("password", "postgres"));
        
        // Configure connection pool
        PoolOptions poolOptions = new PoolOptions()
                .setMaxSize(config.getInteger("maxPoolSize", 10));
        
        // Use the Vertx instance to create the pool
        this.client = PgPool.pool(vertx, connectOptions, poolOptions);
        
        logger.info("Database service initialized - Host: {}, Database: {}",
                connectOptions.getHost(), connectOptions.getDatabase());
    }
    
    /**
     * Store encryption metadata
     */
    public Future<Long> storeEncryptionMetadata(JsonObject metadata) {
        String sql = "INSERT INTO encryption_metadata " +
                "(file_name, original_size, encrypted_size, encryption_algorithm, kem_algorithm, " +
                "aes_key_size, kyber_public_key_size, kyber_private_key_size, kyber_ciphertext_size, " +
                "classical_key_size, pqc_overhead_bytes, pqc_overhead_percentage, encrypted_file_path, status, notes) " +
                "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15) " +
                "RETURNING id";
        
        Tuple params = Tuple.of(
                metadata.getString("fileName"),
                metadata.getLong("originalSize"),
                metadata.getLong("encryptedSize"),
                metadata.getString("encryptionAlgorithm", "AES-256-GCM"),
                metadata.getString("kemAlgorithm", "Kyber1024"),
                metadata.getInteger("aesKeySize", 256),
                metadata.getInteger("kyberPublicKeySize"),
                metadata.getInteger("kyberPrivateKeySize"),
                metadata.getInteger("kyberCiphertextSize"),
                metadata.getInteger("classicalKeySize", 256),
                metadata.getInteger("pqcOverheadBytes"),
                metadata.getDouble("pqcOverheadPercentage"),
                metadata.getString("encryptedFilePath"),
                metadata.getString("status", "encrypted"),
                metadata.getString("notes", "")
        );
        
        return client.preparedQuery(sql)
                .execute(params)
                .map(rows -> {
                    Row row = rows.iterator().next();
                    Long id = row.getLong("id");
                    logger.info("Encryption metadata stored - ID: {}, File: {}", id, metadata.getString("fileName"));
                    return id;
                })
                .onFailure(err -> logger.error("Failed to store encryption metadata", err));
    }
    
    /**
     * Update decryption timestamp
     */
    public Future<Void> updateDecryptionTimestamp(Long id) {
        String sql = "UPDATE encryption_metadata SET decryption_timestamp = $1, status = $2 WHERE id = $3";
        
        return client.preparedQuery(sql)
                .execute(Tuple.of(LocalDateTime.now(), "decrypted", id))
                .compose(rows -> {
                    logger.info("Decryption timestamp updated for ID: {}", id);
                    return Future.<Void>succeededFuture();
                })
                .onFailure(err -> logger.error("Failed to update decryption timestamp", err));
    }
    
    /**
     * Get all encryption records
     */
    public Future<JsonArray> getAllEncryptionRecords() {
        String sql = "SELECT * FROM encryption_metadata ORDER BY encryption_timestamp DESC";
        
        return client.query(sql)
                .execute()
                .map(rows -> {
                    JsonArray records = new JsonArray();
                    for (Row row : rows) {
                        records.add(rowToJson(row));
                    }
                    logger.info("Retrieved {} encryption records", records.size());
                    return records;
                })
                .onFailure(err -> logger.error("Failed to retrieve encryption records", err));
    }
    
    /**
     * Get encryption record by ID
     */
    public Future<JsonObject> getEncryptionRecord(Long id) {
        String sql = "SELECT * FROM encryption_metadata WHERE id = $1";
        
        return client.preparedQuery(sql)
                .execute(Tuple.of(id))
                .map(rows -> {
                    if (rows.size() == 0) {
                        logger.warn("No encryption record found for ID: {}", id);
                        return null;
                    }
                    Row row = rows.iterator().next();
                    return rowToJson(row);
                })
                .onFailure(err -> logger.error("Failed to retrieve encryption record", err));
    }
    
    /**
     * Get encryption summary statistics
     */
    public Future<JsonObject> getEncryptionSummary() {
        String sql = "SELECT * FROM encryption_summary";
        
        return client.query(sql)
                .execute()
                .map(rows -> {
                    JsonArray summaries = new JsonArray();
                    for (Row row : rows) {
                        JsonObject summary = new JsonObject()
                                .put("totalFiles", row.getLong("total_files"))
                                .put("totalOriginalSize", row.getLong("total_original_size"))
                                .put("totalEncryptedSize", row.getLong("total_encrypted_size"))
                                .put("avgPqcOverhead", row.getDouble("avg_pqc_overhead"))
                                .put("kemAlgorithm", row.getString("kem_algorithm"))
                                .put("status", row.getString("status"));
                        summaries.add(summary);
                    }
                    
                    JsonObject result = new JsonObject()
                            .put("summaries", summaries);
                    
                    logger.info("Retrieved encryption summary");
                    return result;
                })
                .onFailure(err -> logger.error("Failed to retrieve encryption summary", err));
    }
    
    /**
     * Get key statistics for dashboard
     */
    public Future<JsonArray> getKeyStatistics() {
        String sql = "SELECT * FROM key_statistics ORDER BY algorithm_type, key_type";
        
        return client.query(sql)
                .execute()
                .map(rows -> {
                    JsonArray stats = new JsonArray();
                    for (Row row : rows) {
                        JsonObject stat = new JsonObject()
                                .put("algorithmType", row.getString("algorithm_type"))
                                .put("keyType", row.getString("key_type"))
                                .put("averageSize", row.getInteger("average_size"))
                                .put("minSize", row.getInteger("min_size"))
                                .put("maxSize", row.getInteger("max_size"))
                                .put("totalOperations", row.getInteger("total_operations"));
                        stats.add(stat);
                    }
                    logger.info("Retrieved {} key statistics", stats.size());
                    return stats;
                })
                .onFailure(err -> logger.error("Failed to retrieve key statistics", err));
    }
    
    /**
     * Get size comparison data
     */
    public Future<JsonArray> getSizeComparison() {
        String sql = "SELECT * FROM size_comparison ORDER BY total_key_size";
        
        return client.query(sql)
                .execute()
                .map(rows -> {
                    JsonArray comparisons = new JsonArray();
                    for (Row row : rows) {
                        JsonObject comparison = new JsonObject()
                                .put("method", row.getString("method"))
                                .put("totalKeySize", row.getInteger("total_key_size"))
                                .put("purpose", row.getString("purpose"));
                        comparisons.add(comparison);
                    }
                    logger.info("Retrieved size comparison data");
                    return comparisons;
                })
                .onFailure(err -> logger.error("Failed to retrieve size comparison", err));
    }
    
    /**
     * Update key statistics
     */
    public Future<Void> updateKeyStatistics(String algorithmType, String keyType, int size) {
        String sql = "INSERT INTO key_statistics (algorithm_type, key_type, average_size, min_size, max_size, total_operations) " +
                "VALUES ($1, $2, $3, $4, $5, 1) " +
                "ON CONFLICT (algorithm_type, key_type) DO UPDATE SET " +
                "average_size = ((key_statistics.average_size * key_statistics.total_operations) + $3) / (key_statistics.total_operations + 1), " +
                "min_size = LEAST(key_statistics.min_size, $4), " +
                "max_size = GREATEST(key_statistics.max_size, $5), " +
                "total_operations = key_statistics.total_operations + 1, " +
                "last_updated = CURRENT_TIMESTAMP";
        
        return client.preparedQuery(sql)
                .execute(Tuple.of(algorithmType, keyType, size, size, size))
                .compose(rows -> {
                    logger.info("Key statistics updated - Type: {}, Key: {}, Size: {}", algorithmType, keyType, size);
                    return Future.<Void>succeededFuture();
                })
                .onFailure(err -> logger.error("Failed to update key statistics", err));
    }
    
    /**
     * Convert database row to JSON
     */
    private JsonObject rowToJson(Row row) {
        JsonObject json = new JsonObject();
        
        json.put("id", row.getLong("id"));
        json.put("fileName", row.getString("file_name"));
        json.put("originalSize", row.getLong("original_size"));
        json.put("encryptedSize", row.getLong("encrypted_size"));
        json.put("encryptionAlgorithm", row.getString("encryption_algorithm"));
        json.put("kemAlgorithm", row.getString("kem_algorithm"));
        json.put("aesKeySize", row.getInteger("aes_key_size"));
        json.put("kyberPublicKeySize", row.getInteger("kyber_public_key_size"));
        json.put("kyberPrivateKeySize", row.getInteger("kyber_private_key_size"));
        json.put("kyberCiphertextSize", row.getInteger("kyber_ciphertext_size"));
        json.put("classicalKeySize", row.getInteger("classical_key_size"));
        json.put("pqcOverheadBytes", row.getInteger("pqc_overhead_bytes"));
        json.put("pqcOverheadPercentage", row.getDouble("pqc_overhead_percentage"));
        json.put("encryptedFilePath", row.getString("encrypted_file_path"));
        json.put("encryptionTimestamp", row.getLocalDateTime("encryption_timestamp").toString());
        
        if (row.getLocalDateTime("decryption_timestamp") != null) {
            json.put("decryptionTimestamp", row.getLocalDateTime("decryption_timestamp").toString());
        }
        
        json.put("status", row.getString("status"));
        json.put("notes", row.getString("notes"));
        
        return json;
    }
    
    /**
     * Close database connection
     */
    public void close() {
        client.close();
        logger.info("Database connection closed");
    }
}

// Made with Bob
