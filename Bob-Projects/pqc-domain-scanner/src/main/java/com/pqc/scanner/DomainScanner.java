package com.pqc.scanner;

import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.Tuple;
import org.bouncycastle.asn1.x509.SubjectPublicKeyInfo;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
import org.bouncycastle.openssl.PEMParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.net.ssl.*;
import java.io.StringReader;
import java.net.InetSocketAddress;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

public class DomainScanner {
    
    private static final Logger logger = LoggerFactory.getLogger(DomainScanner.class);
    
    // Key exchange algorithm patterns for extraction (order matters: more specific first)
    private static final Map<String, String> KEY_EXCHANGE_PATTERNS = new LinkedHashMap<>();
    static {
        KEY_EXCHANGE_PATTERNS.put("ECDH", "ECDH");
        KEY_EXCHANGE_PATTERNS.put("EC", "ECDH");
        KEY_EXCHANGE_PATTERNS.put("RSA", "RSA");
        KEY_EXCHANGE_PATTERNS.put("DH", "DH");
        KEY_EXCHANGE_PATTERNS.put("X25519", "X25519");
        KEY_EXCHANGE_PATTERNS.put("X448", "X448");
    }
    
    private final Vertx vertx;
    private final PgPool pgPool;
    private final JsonObject config;
    private final Set<String> quantumSafeAlgorithms;
    private final Set<String> vulnerableAlgorithms;
    private final int quantumThreatYear;
    
    public DomainScanner(Vertx vertx, PgPool pgPool, JsonObject config) {
        this.vertx = vertx;
        this.pgPool = pgPool;
        this.config = config;
        
        // Load quantum-safe algorithms from config
        this.quantumSafeAlgorithms = new HashSet<>();
        JsonArray qsAlgos = config.getJsonArray("quantumSafeAlgorithms", new JsonArray());
        qsAlgos.forEach(algo -> quantumSafeAlgorithms.add(algo.toString().toUpperCase()));
        
        // Load vulnerable algorithms from config
        this.vulnerableAlgorithms = new HashSet<>();
        JsonArray vulnAlgos = config.getJsonArray("vulnerableAlgorithms", new JsonArray());
        vulnAlgos.forEach(algo -> vulnerableAlgorithms.add(algo.toString().toUpperCase()));
        
        this.quantumThreatYear = config.getInteger("quantumThreatYear", 2030);
    }
    
    public Future<JsonObject> scanDomain(String domain) {
        Promise<JsonObject> promise = Promise.promise();
        long startTime = System.currentTimeMillis();
        
        vertx.executeBlocking(blockingPromise -> {
            try {
                JsonObject result = performScan(domain);
                result.put("response_time_ms", System.currentTimeMillis() - startTime);
                blockingPromise.complete(result);
            } catch (Exception e) {
                logger.error("Error scanning domain {}: {}", domain, e.getMessage());
                JsonObject errorResult = new JsonObject()
                    .put("domain", domain)
                    .put("error", true)
                    .put("error_message", e.getMessage())
                    .put("response_time_ms", System.currentTimeMillis() - startTime);
                blockingPromise.complete(errorResult);
            }
        }, false, ar -> {
            if (ar.succeeded()) {
                JsonObject scanResult = (JsonObject) ar.result();
                saveScanResult(domain, scanResult)
                    .onSuccess(v -> promise.complete(scanResult))
                    .onFailure(promise::fail);
            } else {
                promise.fail(ar.cause());
            }
        });
        
        return promise.future();
    }
    
    private JsonObject performScan(String domain) throws Exception {
        JsonObject result = new JsonObject();
        result.put("domain", domain);
        result.put("scan_date", Instant.now().toString());
        
        // Create SSL context that accepts all certificates for analysis
        SSLContext sslContext = SSLContext.getInstance("TLS");
        TrustManager[] trustAllCerts = new TrustManager[]{
            new X509TrustManager() {
                public X509Certificate[] getAcceptedIssuers() { return null; }
                public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                public void checkServerTrusted(X509Certificate[] certs, String authType) {}
            }
        };
        sslContext.init(null, trustAllCerts, new java.security.SecureRandom());
        
        SSLSocketFactory factory = sslContext.getSocketFactory();
        
        // Connect to domain on port 443
        try (SSLSocket socket = (SSLSocket) factory.createSocket()) {
            socket.connect(new InetSocketAddress(domain, 443), config.getInteger("timeout", 10000));
            socket.startHandshake();
            
            // Get SSL session info
            SSLSession session = socket.getSession();
            result.put("protocol", session.getProtocol());
            result.put("cipher_suite", session.getCipherSuite());
            result.put("supports_tls_13", session.getProtocol().equals("TLSv1.3"));
            
            // Analyze certificates and certificate chain
            Certificate[] certs = session.getPeerCertificates();
            if (certs.length > 0 && certs[0] instanceof X509Certificate) {
                X509Certificate cert = (X509Certificate) certs[0];
                JsonObject certInfo = analyzeCertificate(cert);
                result.mergeIn(certInfo);
                
                // Calculate vulnerability window
                int daysUntilVulnerable = calculateVulnerabilityWindow(cert, certInfo);
                result.put("days_until_vulnerable", daysUntilVulnerable);
                
                // Analyze certificate chain
                JsonObject chainAnalysis = analyzeCertificateChain(certs);
                result.put("certificate_chain", chainAnalysis.getJsonArray("chain"));
                result.put("chain_has_issues", chainAnalysis.getBoolean("has_issues", false));
            }
            
            result.put("certificate_valid", true);
            result.put("error", false);
            
            // Calculate risk score
            JsonObject riskInfo = RiskCalculator.calculateRisk(result);
            result.put("risk_score", riskInfo.getInteger("risk_score"));
            result.put("risk_level", riskInfo.getString("risk_level"));
            
        } catch (Exception e) {
            result.put("certificate_valid", false);
            result.put("error", true);
            result.put("error_message", e.getMessage());
            result.put("chain_has_issues", false);
            
            // Calculate risk even for failed scans
            JsonObject riskInfo = RiskCalculator.calculateRisk(result);
            result.put("risk_score", riskInfo.getInteger("risk_score"));
            result.put("risk_level", riskInfo.getString("risk_level"));
        }
        
        return result;
    }
    
    private JsonObject analyzeCertificate(X509Certificate cert) {
        JsonObject certInfo = new JsonObject();
        
        // Basic certificate info
        certInfo.put("subject", cert.getSubjectX500Principal().getName());
        certInfo.put("issuer", cert.getIssuerX500Principal().getName());
        certInfo.put("serial_number", cert.getSerialNumber().toString(16));
        certInfo.put("not_before", cert.getNotBefore().toInstant().toString());
        certInfo.put("not_after", cert.getNotAfter().toInstant().toString());
        certInfo.put("certificate_expiry", cert.getNotAfter().toInstant().toString());
        
        // Public key analysis
        String publicKeyAlgo = cert.getPublicKey().getAlgorithm();
        certInfo.put("public_key_algorithm", publicKeyAlgo);
        
        // Determine key size
        int keySize = getKeySize(cert);
        certInfo.put("public_key_size", keySize);
        
        // Signature algorithm
        String sigAlgo = cert.getSigAlgName();
        certInfo.put("signature_algorithm", sigAlgo);
        
        // Check if quantum-safe
        boolean isQuantumSafe = isQuantumSafeAlgorithm(publicKeyAlgo, sigAlgo);
        certInfo.put("is_pqc_ready", isQuantumSafe);
        certInfo.put("is_quantum_safe", isQuantumSafe);
        
        // Determine PQC algorithm type if applicable
        String pqcType = detectPQCAlgorithmType(publicKeyAlgo, sigAlgo);
        certInfo.put("pqc_algorithm_type", pqcType);
        
        // Key exchange algorithm (derived from cipher suite)
        String keyExchange = extractKeyExchangeAlgorithm(publicKeyAlgo);
        certInfo.put("key_exchange_algorithm", keyExchange);
        
        // Get SAN entries
        try {
            Collection<List<?>> sans = cert.getSubjectAlternativeNames();
            if (sans != null) {
                JsonArray sanArray = new JsonArray();
                sans.forEach(san -> sanArray.add(san.get(1).toString()));
                certInfo.put("san_entries", sanArray.encode());
            }
        } catch (Exception e) {
            logger.debug("No SAN entries found");
        }
        
        return certInfo;
    }
    
    private int getKeySize(X509Certificate cert) {
        String algo = cert.getPublicKey().getAlgorithm();
        if (algo.contains("RSA")) {
            return ((java.security.interfaces.RSAPublicKey) cert.getPublicKey()).getModulus().bitLength();
        } else if (algo.contains("EC")) {
            return ((java.security.interfaces.ECPublicKey) cert.getPublicKey()).getParams().getCurve().getField().getFieldSize();
        }
        return 0;
    }
    
    private boolean isQuantumSafeAlgorithm(String publicKeyAlgo, String sigAlgo) {
        String combined = (publicKeyAlgo + " " + sigAlgo).toUpperCase();
        return quantumSafeAlgorithms.stream().anyMatch(combined::contains);
    }
    
    private String detectPQCAlgorithmType(String publicKeyAlgo, String sigAlgo) {
        String combined = (publicKeyAlgo + " " + sigAlgo).toUpperCase();
        
        for (String pqcAlgo : quantumSafeAlgorithms) {
            if (combined.contains(pqcAlgo)) {
                return pqcAlgo;
            }
        }
        
        // Check if it's a vulnerable classical algorithm
        for (String vulnAlgo : vulnerableAlgorithms) {
            if (combined.contains(vulnAlgo)) {
                return "Classical-" + vulnAlgo;
            }
        }
        
        return "Unknown";
    }
    
    /**
     * Extracts the key exchange algorithm from a public key algorithm string.
     * Performs case-insensitive pattern matching to identify the key exchange mechanism.
     *
     * @param publicKeyAlgo The public key algorithm string (e.g., "RSA", "EC", "ECDH")
     * @return The normalized key exchange algorithm name, or "UNKNOWN" if not recognized
     * @throws IllegalArgumentException if publicKeyAlgo is null
     */
    private String extractKeyExchangeAlgorithm(String publicKeyAlgo) {
        if (publicKeyAlgo == null) {
            logger.warn("Null public key algorithm provided");
            throw new IllegalArgumentException("Public key algorithm cannot be null");
        }
        
        if (publicKeyAlgo.trim().isEmpty()) {
            logger.warn("Empty public key algorithm provided");
            return "UNKNOWN";
        }
        
        String normalizedAlgo = publicKeyAlgo.trim().toUpperCase();
        
        // Check against known patterns (order matters for specificity)
        for (Map.Entry<String, String> entry : KEY_EXCHANGE_PATTERNS.entrySet()) {
            if (normalizedAlgo.contains(entry.getKey())) {
                logger.debug("Matched key exchange algorithm: {} -> {}", publicKeyAlgo, entry.getValue());
                return entry.getValue();
            }
        }
        
        // Return normalized original if no match found (for future/unknown algorithms)
        logger.debug("Unknown key exchange algorithm: {}", publicKeyAlgo);
        return normalizedAlgo;
    }
    /**
     * Analyze the full certificate chain
     * @param certs Array of certificates in the chain
     * @return JsonObject with chain analysis results
     */
    private JsonObject analyzeCertificateChain(Certificate[] certs) {
        JsonObject result = new JsonObject();
        JsonArray chainArray = new JsonArray();
        boolean hasIssues = false;
        
        logger.debug("Analyzing certificate chain with {} certificates", certs.length);
        
        for (int i = 0; i < certs.length; i++) {
            if (certs[i] instanceof X509Certificate) {
                X509Certificate cert = (X509Certificate) certs[i];
                JsonObject chainCert = new JsonObject();
                
                chainCert.put("chain_position", i);
                chainCert.put("subject", cert.getSubjectX500Principal().getName());
                chainCert.put("issuer", cert.getIssuerX500Principal().getName());
                chainCert.put("serial_number", cert.getSerialNumber().toString(16));
                chainCert.put("not_before", cert.getNotBefore().toInstant().toString());
                chainCert.put("not_after", cert.getNotAfter().toInstant().toString());
                
                // Analyze public key
                String publicKeyAlgo = cert.getPublicKey().getAlgorithm();
                chainCert.put("public_key_algorithm", publicKeyAlgo);
                chainCert.put("public_key_size", getKeySize(cert));
                
                // Analyze signature
                String sigAlgo = cert.getSigAlgName();
                chainCert.put("signature_algorithm", sigAlgo);
                
                // Check if root certificate
                boolean isRoot = cert.getSubjectX500Principal().equals(cert.getIssuerX500Principal());
                chainCert.put("is_root", isRoot);
                
                // Check if quantum-safe
                boolean isQuantumSafe = isQuantumSafeAlgorithm(publicKeyAlgo, sigAlgo);
                chainCert.put("is_quantum_safe", isQuantumSafe);
                
                if (isQuantumSafe) {
                    chainCert.put("pqc_algorithm_type", detectPQCAlgorithmType(publicKeyAlgo, sigAlgo));
                }
                
                // Validate certificate
                boolean isValid = true;
                String validationError = null;
                
                try {
                    cert.checkValidity();
                } catch (Exception e) {
                    isValid = false;
                    validationError = "Certificate expired or not yet valid: " + e.getMessage();
                    hasIssues = true;
                }
                
                // Check for weak algorithms
                if (!isQuantumSafe) {
                    if (sigAlgo.contains("SHA1") || sigAlgo.contains("MD5")) {
                        hasIssues = true;
                        validationError = (validationError != null ? validationError + "; " : "") + 
                            "Weak signature algorithm: " + sigAlgo;
                    }
                    
                    int keySize = getKeySize(cert);
                    if (publicKeyAlgo.contains("RSA") && keySize < 2048) {
                        hasIssues = true;
                        validationError = (validationError != null ? validationError + "; " : "") + 
                            "Weak RSA key size: " + keySize;
                    }
                }
                
                chainCert.put("is_valid", isValid);
                if (validationError != null) {
                    chainCert.put("validation_error", validationError);
                }
                
                chainArray.add(chainCert);
                
                logger.debug("Chain cert {}: subject={}, isRoot={}, isQuantumSafe={}, isValid={}", 
                    i, cert.getSubjectX500Principal().getName(), isRoot, isQuantumSafe, isValid);
            }
        }
        
        result.put("chain", chainArray);
        result.put("chain_length", chainArray.size());
        result.put("has_issues", hasIssues);
        
        return result;
    }
    
    
    private int calculateVulnerabilityWindow(X509Certificate cert, JsonObject certInfo) {
        // If already quantum-safe, return -1 (not vulnerable)
        if (certInfo.getBoolean("is_quantum_safe", false)) {
            return -1;
        }
        
        // Calculate days until quantum threat becomes real
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime threatDate = LocalDateTime.of(quantumThreatYear, 1, 1, 0, 0);
        long daysUntilThreat = ChronoUnit.DAYS.between(now, threatDate);
        
        // Calculate days until certificate expires
        LocalDateTime expiryDate = LocalDateTime.ofInstant(
            cert.getNotAfter().toInstant(), 
            ZoneId.systemDefault()
        );
        long daysUntilExpiry = ChronoUnit.DAYS.between(now, expiryDate);
        
        // Return the minimum (whichever comes first)
        return (int) Math.min(daysUntilThreat, daysUntilExpiry);
    }
    
    private Future<Void> saveScanResult(String domain, JsonObject scanResult) {
        Promise<Void> promise = Promise.promise();
        
        // First, ensure domain exists in database
        String insertDomainSql = "INSERT INTO domains (domain_name) VALUES ($1) " +
            "ON CONFLICT (domain_name) DO UPDATE SET last_scanned = CURRENT_TIMESTAMP, " +
            "scan_count = domains.scan_count + 1 RETURNING id";
        
        pgPool.preparedQuery(insertDomainSql)
            .execute(Tuple.of(domain))
            .compose(rows -> {
                int domainId = rows.iterator().next().getInteger("id");
                
                // Convert certificate_expiry from ISO 8601 string to LocalDateTime
                LocalDateTime certExpiry = null;
                String certExpiryStr = scanResult.getString("certificate_expiry");
                if (certExpiryStr != null) {
                    try {
                        certExpiry = LocalDateTime.ofInstant(
                            Instant.parse(certExpiryStr),
                            ZoneId.systemDefault()
                        );
                    } catch (Exception e) {
                        logger.warn("Failed to parse certificate expiry date: {}", certExpiryStr);
                    }
                }
                
                // Insert scan result with risk scoring
                String insertScanSql = "INSERT INTO scan_results " +
                    "(domain_id, is_pqc_ready, supports_tls_13, certificate_valid, " +
                    "certificate_expiry, days_until_vulnerable, cipher_suites, " +
                    "key_exchange_algorithm, signature_algorithm, error_message, response_time_ms, " +
                    "risk_score, risk_level, chain_has_issues) " +
                    "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING id";
                
                return pgPool.preparedQuery(insertScanSql)
                    .execute(Tuple.of(
                        domainId,
                        scanResult.getBoolean("is_pqc_ready", false),
                        scanResult.getBoolean("supports_tls_13", false),
                        scanResult.getBoolean("certificate_valid", false),
                        certExpiry,
                        scanResult.getInteger("days_until_vulnerable"),
                        scanResult.getString("cipher_suite"),
                        scanResult.getString("key_exchange_algorithm"),
                        scanResult.getString("signature_algorithm"),
                        scanResult.getString("error_message"),
                        scanResult.getInteger("response_time_ms"),
                        scanResult.getInteger("risk_score"),
                        scanResult.getString("risk_level"),
                        scanResult.getBoolean("chain_has_issues", false)
                    ))
                    .map(scanRows -> {
                        int scanId = scanRows.iterator().next().getInteger("id");
                        return new JsonObject()
                            .put("domainId", domainId)
                            .put("scanId", scanId);
                    });
            })
            .compose(ids -> {
                // Insert certificate details if available
                if (scanResult.containsKey("subject")) {
                    // Convert not_before and not_after from ISO 8601 strings to LocalDateTime
                    LocalDateTime notBefore = null;
                    LocalDateTime notAfter = null;
                    
                    String notBeforeStr = scanResult.getString("not_before");
                    if (notBeforeStr != null) {
                        try {
                            notBefore = LocalDateTime.ofInstant(
                                Instant.parse(notBeforeStr),
                                ZoneId.systemDefault()
                            );
                        } catch (Exception e) {
                            logger.warn("Failed to parse not_before date: {}", notBeforeStr);
                        }
                    }
                    
                    String notAfterStr = scanResult.getString("not_after");
                    if (notAfterStr != null) {
                        try {
                            notAfter = LocalDateTime.ofInstant(
                                Instant.parse(notAfterStr),
                                ZoneId.systemDefault()
                            );
                        } catch (Exception e) {
                            logger.warn("Failed to parse not_after date: {}", notAfterStr);
                        }
                    }
                    
                    String insertCertSql = "INSERT INTO certificate_details " +
                        "(scan_result_id, subject, issuer, serial_number, not_before, not_after, " +
                        "public_key_algorithm, public_key_size, signature_algorithm, " +
                        "is_quantum_safe, pqc_algorithm_type, san_entries) " +
                        "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)";
                    
                    return pgPool.preparedQuery(insertCertSql)
                        .execute(Tuple.of(
                            ids.getInteger("scanId"),
                            scanResult.getString("subject"),
                            scanResult.getString("issuer"),
                            scanResult.getString("serial_number"),
                            notBefore,
                            notAfter,
                            scanResult.getString("public_key_algorithm"),
                            scanResult.getInteger("public_key_size"),
                            scanResult.getString("signature_algorithm"),
                            scanResult.getBoolean("is_quantum_safe", false),
                            scanResult.getString("pqc_algorithm_type"),
                            scanResult.getString("san_entries")
                        ))
                        .compose(v -> {
                            // Save certificate chain if available
                            return saveCertificateChain(ids.getInteger("scanId"), scanResult);
                        });
                }
                return saveCertificateChain(ids.getInteger("scanId"), scanResult);
            })
            .onSuccess(v -> promise.complete())
            .onFailure(err -> {
                logger.error("Error saving scan result: {}", err.getMessage());
                promise.fail(err);
            });
            return promise.future();
        }
    /**
     * Save certificate chain data to database
     */
    private Future<Void> saveCertificateChain(int scanResultId, JsonObject scanResult) {
    JsonArray chain = scanResult.getJsonArray("certificate_chain");

    if (chain == null || chain.isEmpty()) {
        return Future.succeededFuture();
    }

    Promise<Void> promise = Promise.promise();
    List<Future<?>> futures = new ArrayList<>();

    for (int i = 0; i < chain.size(); i++) {
        JsonObject chainCert = chain.getJsonObject(i);

        LocalDateTime notBefore = null;
        LocalDateTime notAfter = null;

        String notBeforeStr = chainCert.getString("not_before");
        if (notBeforeStr != null) {
            try {
                notBefore = LocalDateTime.ofInstant(
                    Instant.parse(notBeforeStr),
                    ZoneId.systemDefault()
                );
            } catch (Exception e) {
                logger.warn("Failed to parse chain cert not_before: {}", notBeforeStr);
            }
        }

        String notAfterStr = chainCert.getString("not_after");
        if (notAfterStr != null) {
            try {
                notAfter = LocalDateTime.ofInstant(
                    Instant.parse(notAfterStr),
                    ZoneId.systemDefault()
                );
            } catch (Exception e) {
                logger.warn("Failed to parse chain cert not_after: {}", notAfterStr);
            }
        }

        String insertChainSql = "INSERT INTO certificate_chain " +
            "(scan_result_id, chain_position, subject, issuer, serial_number, " +
            "not_before, not_after, public_key_algorithm, public_key_size, " +
            "signature_algorithm, is_root, is_quantum_safe, pqc_algorithm_type, " +
            "is_valid, validation_error) " +
            "VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)";

        Future<Void> chainFuture = pgPool.preparedQuery(insertChainSql)
            .execute(Tuple.of(
                scanResultId,
                chainCert.getInteger("chain_position"),
                chainCert.getString("subject"),
                chainCert.getString("issuer"),
                chainCert.getString("serial_number"),
                notBefore,
                notAfter,
                chainCert.getString("public_key_algorithm"),
                chainCert.getInteger("public_key_size"),
                chainCert.getString("signature_algorithm"),
                chainCert.getBoolean("is_root", false),
                chainCert.getBoolean("is_quantum_safe", false),
                chainCert.getString("pqc_algorithm_type"),
                chainCert.getBoolean("is_valid", true),
                chainCert.getString("validation_error")
            ))
            .mapEmpty();

        futures.add(chainFuture);
    }

    Future.all(futures)
        .onSuccess(v -> {
            logger.debug("Saved {} certificate chain entries", chain.size());
            promise.complete();
        })
        .onFailure(err -> {
            logger.error("Error saving certificate chain: {}", err.getMessage());
            promise.fail(err);
        });

    return promise.future();
}
}

// Made with Bob
