package com.pqc.scanner;

import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Risk Calculator for PQC Domain Scanner
 * Calculates risk scores and levels based on multiple security factors
 */
public class RiskCalculator {
    
    private static final Logger logger = LoggerFactory.getLogger(RiskCalculator.class);
    
    // Risk level thresholds
    private static final int CRITICAL_THRESHOLD = 80;
    private static final int HIGH_THRESHOLD = 60;
    private static final int MEDIUM_THRESHOLD = 40;
    
    // Weight factors (total = 100%)
    private static final double VULNERABILITY_WEIGHT = 0.40;  // 40%
    private static final double CERT_VALIDITY_WEIGHT = 0.20;  // 20%
    private static final double ALGORITHM_WEIGHT = 0.20;      // 20%
    private static final double TLS_VERSION_WEIGHT = 0.10;    // 10%
    private static final double CHAIN_WEIGHT = 0.10;          // 10%
    
    /**
     * Calculate comprehensive risk score for a scan result
     * @param scanResult The scan result data
     * @return JsonObject with risk_score and risk_level
     */
    public static JsonObject calculateRisk(JsonObject scanResult) {
        try {
            int vulnerabilityScore = calculateVulnerabilityScore(scanResult);
            int certValidityScore = calculateCertValidityScore(scanResult);
            int algorithmScore = calculateAlgorithmScore(scanResult);
            int tlsVersionScore = calculateTlsVersionScore(scanResult);
            int chainScore = calculateChainScore(scanResult);
            
            // Calculate weighted total (0-100)
            double totalScore = 
                (vulnerabilityScore * VULNERABILITY_WEIGHT) +
                (certValidityScore * CERT_VALIDITY_WEIGHT) +
                (algorithmScore * ALGORITHM_WEIGHT) +
                (tlsVersionScore * TLS_VERSION_WEIGHT) +
                (chainScore * CHAIN_WEIGHT);
            
            int riskScore = (int) Math.round(totalScore);
            String riskLevel = determineRiskLevel(riskScore);
            
            logger.debug("Risk calculation for {}: score={}, level={} (vuln={}, cert={}, algo={}, tls={}, chain={})",
                scanResult.getString("domain"),
                riskScore, riskLevel,
                vulnerabilityScore, certValidityScore, algorithmScore, tlsVersionScore, chainScore);
            
            return new JsonObject()
                .put("risk_score", riskScore)
                .put("risk_level", riskLevel)
                .put("vulnerability_score", vulnerabilityScore)
                .put("cert_validity_score", certValidityScore)
                .put("algorithm_score", algorithmScore)
                .put("tls_version_score", tlsVersionScore)
                .put("chain_score", chainScore);
                
        } catch (Exception e) {
            logger.error("Error calculating risk: {}", e.getMessage());
            return new JsonObject()
                .put("risk_score", 50)
                .put("risk_level", "MEDIUM");
        }
    }
    
    /**
     * Calculate vulnerability score based on days until quantum threat
     * Higher score = higher risk
     */
    private static int calculateVulnerabilityScore(JsonObject scanResult) {
        Integer daysUntilVulnerable = scanResult.getInteger("days_until_vulnerable");
        
        if (daysUntilVulnerable == null) {
            return 50; // Unknown = medium risk
        }
        
        if (daysUntilVulnerable < 0) {
            return 0; // Already quantum-safe
        }
        
        if (daysUntilVulnerable < 365) {
            return 100; // Critical: < 1 year
        } else if (daysUntilVulnerable < 730) {
            return 80;  // High: 1-2 years
        } else if (daysUntilVulnerable < 1095) {
            return 60;  // Medium: 2-3 years
        } else if (daysUntilVulnerable < 1460) {
            return 40;  // Low-Medium: 3-4 years
        } else {
            return 20;  // Low: > 4 years
        }
    }
    
    /**
     * Calculate certificate validity score
     * Higher score = higher risk
     */
    private static int calculateCertValidityScore(JsonObject scanResult) {
        Boolean certValid = scanResult.getBoolean("certificate_valid");
        
        if (certValid == null || !certValid) {
            return 100; // Invalid cert = critical risk
        }
        
        // Check if certificate is expiring soon
        String certExpiry = scanResult.getString("certificate_expiry");
        if (certExpiry != null) {
            // If we have expiry date, could calculate days until expiry
            // For now, valid cert = low risk
            return 10;
        }
        
        return 20; // Valid but no expiry info
    }
    
    /**
     * Calculate algorithm strength score
     * Higher score = higher risk (weaker algorithms)
     */
    private static int calculateAlgorithmScore(JsonObject scanResult) {
        String keyExchange = scanResult.getString("key_exchange_algorithm", "").toUpperCase();
        String signature = scanResult.getString("signature_algorithm", "").toUpperCase();
        Boolean isQuantumSafe = scanResult.getBoolean("is_quantum_safe", false);
        
        if (isQuantumSafe) {
            return 0; // Quantum-safe = no risk
        }
        
        int score = 0;
        
        // Check key exchange algorithm
        if (keyExchange.contains("RSA")) {
            Integer keySize = scanResult.getInteger("public_key_size");
            if (keySize != null && keySize < 2048) {
                score += 50; // Weak RSA
            } else {
                score += 30; // Standard RSA (quantum-vulnerable)
            }
        } else if (keyExchange.contains("ECDH") || keyExchange.contains("ECDSA")) {
            score += 25; // ECC (quantum-vulnerable but stronger than RSA)
        } else if (keyExchange.contains("DH")) {
            score += 35; // DH (quantum-vulnerable)
        } else {
            score += 40; // Unknown = assume vulnerable
        }
        
        // Check signature algorithm
        if (signature.contains("SHA1")) {
            score += 30; // SHA1 is deprecated
        } else if (signature.contains("MD5")) {
            score += 50; // MD5 is broken
        } else if (signature.contains("SHA256") || signature.contains("SHA384") || signature.contains("SHA512")) {
            score += 10; // Modern hash but still quantum-vulnerable
        }
        
        return Math.min(score, 100);
    }
    
    /**
     * Calculate TLS version score
     * Higher score = higher risk (older versions)
     */
    private static int calculateTlsVersionScore(JsonObject scanResult) {
        Boolean supportsTls13 = scanResult.getBoolean("supports_tls_13", false);
        
        if (supportsTls13) {
            return 10; // TLS 1.3 = low risk
        } else {
            return 60; // TLS 1.2 or older = medium-high risk
        }
    }
    
    /**
     * Calculate certificate chain score
     * Higher score = higher risk
     */
    private static int calculateChainScore(JsonObject scanResult) {
        Boolean chainHasIssues = scanResult.getBoolean("chain_has_issues", false);
        
        if (chainHasIssues) {
            return 80; // Chain issues = high risk
        }
        
        return 10; // No known chain issues
    }
    
    /**
     * Determine risk level from score
     */
    private static String determineRiskLevel(int score) {
        if (score >= CRITICAL_THRESHOLD) {
            return "CRITICAL";
        } else if (score >= HIGH_THRESHOLD) {
            return "HIGH";
        } else if (score >= MEDIUM_THRESHOLD) {
            return "MEDIUM";
        } else {
            return "LOW";
        }
    }
    
    /**
     * Get risk level color for UI
     */
    public static String getRiskColor(String riskLevel) {
        switch (riskLevel) {
            case "CRITICAL":
                return "#dc3545"; // Red
            case "HIGH":
                return "#fd7e14"; // Orange
            case "MEDIUM":
                return "#ffc107"; // Yellow
            case "LOW":
                return "#28a745"; // Green
            default:
                return "#6c757d"; // Gray
        }
    }
}

// Made with Bob
