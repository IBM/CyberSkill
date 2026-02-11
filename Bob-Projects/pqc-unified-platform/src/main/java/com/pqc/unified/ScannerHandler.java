package com.pqc.unified;

import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.net.ssl.*;
import java.net.Socket;
import java.security.cert.X509Certificate;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Handler for Domain Scanner functionality
 * Scans domains for TLS/PQC certificate information
 */
public class ScannerHandler {
    private static final Logger logger = LoggerFactory.getLogger(ScannerHandler.class);
    
    private final Vertx vertx;
    private final PgPool dbPool;
    private final JsonObject config;
    private final Map<String, JsonObject> scanCache = new ConcurrentHashMap<>();
    
    public ScannerHandler(Vertx vertx, PgPool dbPool, JsonObject config) {
        this.vertx = vertx;
        this.dbPool = dbPool;
        this.config = config;
    }
    
    public void handleScan(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String domain = body.getString("domain");
        
        if (domain == null || domain.trim().isEmpty()) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Domain is required")
                    .encode());
            return;
        }
        
        logger.info("Scanning domain: {}", domain);
        
        // Perform scan asynchronously
        vertx.executeBlocking(promise -> {
            try {
                JsonObject result = performScan(domain);
                promise.complete(result);
            } catch (Exception e) {
                logger.error("Scan failed for domain: {}", domain, e);
                promise.fail(e);
            }
        }, res -> {
            if (res.succeeded()) {
                JsonObject result = (JsonObject) res.result();
                
                // Cache result
                scanCache.put(domain, result);
                
                // Save to database if available
                if (dbPool != null) {
                    saveScanResult(result);
                }
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(result.encode());
            } else {
                ctx.response()
                    .setStatusCode(500)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Scan failed: " + res.cause().getMessage())
                        .encode());
            }
        });
    }
    
    private JsonObject performScan(String domain) throws Exception {
        String host = domain.replaceAll("https?://", "").split("/")[0];
        int port = 443;
        
        JsonObject result = new JsonObject()
            .put("domain", domain)
            .put("host", host)
            .put("port", port)
            .put("timestamp", System.currentTimeMillis());
        
        try {
            // Create SSL context
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, new TrustManager[]{new TrustAllManager()}, null);
            
            SSLSocketFactory factory = sslContext.getSocketFactory();
            
            try (SSLSocket socket = (SSLSocket) factory.createSocket(host, port)) {
                socket.startHandshake();
                
                SSLSession session = socket.getSession();
                
                // Get certificate chain
                X509Certificate[] certs = (X509Certificate[]) session.getPeerCertificates();
                
                if (certs != null && certs.length > 0) {
                    X509Certificate cert = certs[0];
                    
                    result.put("certificate", new JsonObject()
                        .put("subject", cert.getSubjectX500Principal().getName())
                        .put("issuer", cert.getIssuerX500Principal().getName())
                        .put("validFrom", cert.getNotBefore().getTime())
                        .put("validTo", cert.getNotAfter().getTime())
                        .put("signatureAlgorithm", cert.getSigAlgName())
                        .put("version", cert.getVersion())
                        .put("serialNumber", cert.getSerialNumber().toString()));
                    
                    // Check for PQC algorithms
                    String sigAlg = cert.getSigAlgName().toLowerCase();
                    boolean isPQC = sigAlg.contains("dilithium") || 
                                   sigAlg.contains("falcon") || 
                                   sigAlg.contains("sphincs");
                    
                    result.put("isPQC", isPQC);
                    result.put("pqcAlgorithm", isPQC ? sigAlg : "none");
                }
                
                // Get cipher suite
                result.put("cipherSuite", session.getCipherSuite());
                result.put("protocol", session.getProtocol());
                
                // Calculate risk score
                int riskScore = calculateRiskScore(result);
                result.put("riskScore", riskScore);
                result.put("riskLevel", getRiskLevel(riskScore));
                
                result.put("status", "success");
                
            }
        } catch (Exception e) {
            result.put("status", "error");
            result.put("error", e.getMessage());
            throw e;
        }
        
        return result;
    }
    
    private int calculateRiskScore(JsonObject scanResult) {
        int score = 0;
        
        // Check if PQC is used
        if (!scanResult.getBoolean("isPQC", false)) {
            score += 50; // High risk if not using PQC
        }
        
        // Check protocol version
        String protocol = scanResult.getString("protocol", "");
        if (protocol.contains("TLSv1.0") || protocol.contains("TLSv1.1")) {
            score += 30;
        } else if (protocol.contains("TLSv1.2")) {
            score += 10;
        }
        
        // Check certificate validity
        JsonObject cert = scanResult.getJsonObject("certificate");
        if (cert != null) {
            long validTo = cert.getLong("validTo", 0L);
            long now = System.currentTimeMillis();
            long daysUntilExpiry = (validTo - now) / (1000 * 60 * 60 * 24);
            
            if (daysUntilExpiry < 30) {
                score += 20;
            } else if (daysUntilExpiry < 90) {
                score += 10;
            }
        }
        
        return Math.min(score, 100);
    }
    
    private String getRiskLevel(int score) {
        if (score >= 70) return "HIGH";
        if (score >= 40) return "MEDIUM";
        return "LOW";
    }
    
    private void saveScanResult(JsonObject result) {
        String sql = "INSERT INTO scan_results (domain, host, port, is_pqc, pqc_algorithm, " +
                    "cipher_suite, protocol, risk_score, risk_level, scan_data, created_at) " +
                    "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, NOW())";
        
        dbPool.preparedQuery(sql)
            .execute(Tuple.of(
                result.getString("domain"),
                result.getString("host"),
                result.getInteger("port"),
                result.getBoolean("isPQC", false),
                result.getString("pqcAlgorithm", "none"),
                result.getString("cipherSuite", ""),
                result.getString("protocol", ""),
                result.getInteger("riskScore", 0),
                result.getString("riskLevel", "UNKNOWN"),
                result.encode()
            ))
            .onSuccess(rows -> logger.debug("Scan result saved to database"))
            .onFailure(err -> logger.warn("Failed to save scan result", err));
    }
    
    public void handleGetResults(RoutingContext ctx) {
        if (dbPool == null) {
            // Return cached results if no database
            JsonArray results = new JsonArray();
            scanCache.values().forEach(results::add);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("results", results)
                    .put("total", results.size())
                    .encode());
            return;
        }
        
        String sql = "SELECT * FROM scan_results ORDER BY created_at DESC LIMIT 100";
        
        dbPool.query(sql)
            .execute()
            .onSuccess(rows -> {
                JsonArray results = new JsonArray();
                for (Row row : rows) {
                    results.add(rowToJson(row));
                }
                
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("results", results)
                        .put("total", results.size())
                        .encode());
            })
            .onFailure(err -> {
                logger.error("Failed to fetch results", err);
                ctx.response()
                    .setStatusCode(500)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Failed to fetch results")
                        .encode());
            });
    }
    
    public void handleGetResult(RoutingContext ctx) {
        String id = ctx.pathParam("id");
        
        // Check cache first
        JsonObject cached = scanCache.get(id);
        if (cached != null) {
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(cached.encode());
            return;
        }
        
        if (dbPool == null) {
            ctx.response()
                .setStatusCode(404)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Result not found")
                    .encode());
            return;
        }
        
        String sql = "SELECT * FROM scan_results WHERE id = $1";
        
        dbPool.preparedQuery(sql)
            .execute(Tuple.of(Integer.parseInt(id)))
            .onSuccess(rows -> {
                if (rows.size() > 0) {
                    ctx.response()
                        .putHeader("Content-Type", "application/json")
                        .end(rowToJson(rows.iterator().next()).encode());
                } else {
                    ctx.response()
                        .setStatusCode(404)
                        .putHeader("Content-Type", "application/json")
                        .end(new JsonObject()
                            .put("error", "Result not found")
                            .encode());
                }
            })
            .onFailure(err -> {
                logger.error("Failed to fetch result", err);
                ctx.response()
                    .setStatusCode(500)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Failed to fetch result")
                        .encode());
            });
    }
    
    public void handleGetStats(RoutingContext ctx) {
        JsonObject stats = new JsonObject()
            .put("totalScans", scanCache.size())
            .put("pqcEnabled", 0)
            .put("highRisk", 0)
            .put("mediumRisk", 0)
            .put("lowRisk", 0);
        
        for (JsonObject result : scanCache.values()) {
            if (result.getBoolean("isPQC", false)) {
                stats.put("pqcEnabled", stats.getInteger("pqcEnabled") + 1);
            }
            
            String riskLevel = result.getString("riskLevel", "UNKNOWN");
            switch (riskLevel) {
                case "HIGH":
                    stats.put("highRisk", stats.getInteger("highRisk") + 1);
                    break;
                case "MEDIUM":
                    stats.put("mediumRisk", stats.getInteger("mediumRisk") + 1);
                    break;
                case "LOW":
                    stats.put("lowRisk", stats.getInteger("lowRisk") + 1);
                    break;
            }
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(stats.encode());
    }
    
    private JsonObject rowToJson(Row row) {
        return new JsonObject()
            .put("id", row.getInteger("id"))
            .put("domain", row.getString("domain"))
            .put("host", row.getString("host"))
            .put("port", row.getInteger("port"))
            .put("isPQC", row.getBoolean("is_pqc"))
            .put("pqcAlgorithm", row.getString("pqc_algorithm"))
            .put("cipherSuite", row.getString("cipher_suite"))
            .put("protocol", row.getString("protocol"))
            .put("riskScore", row.getInteger("risk_score"))
            .put("riskLevel", row.getString("risk_level"))
            .put("timestamp", row.getLocalDateTime("created_at").toString());
    }
    
    // Trust all certificates (for testing only)
    private static class TrustAllManager implements X509TrustManager {
        public void checkClientTrusted(X509Certificate[] chain, String authType) {}
        public void checkServerTrusted(X509Certificate[] chain, String authType) {}
        public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
    }
}

// Made with Bob
