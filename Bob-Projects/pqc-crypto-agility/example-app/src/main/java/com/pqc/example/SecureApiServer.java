package com.pqc.example;

import com.pqc.agility.CryptoAgilityRuntime;
import com.pqc.agility.CryptoProvider;
import com.pqc.agility.policy.PolicyEngine;
import com.pqc.agility.policy.ThreatModel;
import com.pqc.agility.providers.HybridProvider;
import com.pqc.agility.providers.Java24KyberProvider;
import com.pqc.agility.providers.RSAProvider;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpServer;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.BodyHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.nio.charset.StandardCharsets;
import java.security.KeyPair;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

/**
 * Secure REST API Server demonstrating PQC Crypto Agility Runtime integration.
 * 
 * Shows how to integrate the crypto agility runtime into an existing application.
 */
public class SecureApiServer extends AbstractVerticle {
    private static final Logger logger = LoggerFactory.getLogger(SecureApiServer.class);
    private static final int PORT = 8080;
    
    private CryptoAgilityRuntime cryptoRuntime;
    private Map<String, KeyPair> sessionKeys = new HashMap<>();

    public static void main(String[] args) {
        Vertx vertx = Vertx.vertx();
        vertx.deployVerticle(new SecureApiServer())
            .onSuccess(id -> logger.info("✅ Secure API Server deployed successfully"))
            .onFailure(err -> logger.error("❌ Failed to deploy server", err));
    }

    @Override
    public void start(Promise<Void> startPromise) {
        try {
            initializeCryptoRuntime();
            Router router = setupRouter();
            
            HttpServer server = vertx.createHttpServer();
            server.requestHandler(router)
                .listen(PORT)
                .onSuccess(s -> {
                    logger.info("🚀 Secure API Server started on port {}", PORT);
                    logger.info("📚 API Documentation: http://localhost:{}/api/docs", PORT);
                    startPromise.complete();
                })
                .onFailure(startPromise::fail);
                
        } catch (Exception e) {
            logger.error("Failed to start server", e);
            startPromise.fail(e);
        }
    }

    private void initializeCryptoRuntime() {
        logger.info("Initializing PQC Crypto Agility Runtime...");
        
        // Create runtime with policy engine
        cryptoRuntime = new CryptoAgilityRuntime(new PolicyEngine());
        
        // Register classical providers
        cryptoRuntime.registerProvider(new RSAProvider(2048));
        cryptoRuntime.registerProvider(new RSAProvider(4096));
        
        // Register Post-Quantum providers (Java 24 native ML-KEM)
        cryptoRuntime.registerProvider(new Java24KyberProvider("Kyber512"));
        cryptoRuntime.registerProvider(new Java24KyberProvider("Kyber768"));
        cryptoRuntime.registerProvider(new Java24KyberProvider("Kyber1024"));
        
        // Register hybrid providers
        cryptoRuntime.registerProvider(new HybridProvider(
            new RSAProvider(2048),
            new Java24KyberProvider("Kyber768")
        ));
        
        cryptoRuntime.registerProvider(new HybridProvider(
            new RSAProvider(4096),
            new Java24KyberProvider("Kyber1024")
        ));
        
        // Set default provider
        cryptoRuntime.switchProvider("RSA-2048");
        
        logger.info("✅ Registered {} cryptographic providers", cryptoRuntime.getAvailableProviders().size());
    }

    private Router setupRouter() {
        Router router = Router.router(vertx);
        router.route().handler(BodyHandler.create());
        
        // API routes
        router.get("/api/docs").handler(this::handleApiDocs);
        router.get("/api/providers").handler(this::handleListProviders);
        router.get("/api/providers/active").handler(this::handleGetActiveProvider);
        router.post("/api/providers/switch").handler(this::handleSwitchProvider);
        router.post("/api/providers/select-by-policy").handler(this::handleSelectByPolicy);
        router.post("/api/crypto/encrypt").handler(this::handleEncrypt);
        router.post("/api/crypto/decrypt").handler(this::handleDecrypt);
        router.post("/api/crypto/generate-keys").handler(this::handleGenerateKeys);
        router.get("/api/stats").handler(this::handleGetStats);
        router.get("/api/health").handler(this::handleHealthCheck);
        
        return router;
    }

    private void handleApiDocs(RoutingContext ctx) {
        JsonObject docs = new JsonObject()
            .put("title", "PQC Crypto Agility API")
            .put("version", "1.0.0")
            .put("description", "REST API demonstrating runtime cryptographic agility")
            .put("endpoints", new JsonArray()
                .add(endpoint("GET", "/api/providers", "List all available providers"))
                .add(endpoint("GET", "/api/providers/active", "Get active provider"))
                .add(endpoint("POST", "/api/providers/switch", "Switch provider"))
                .add(endpoint("POST", "/api/providers/select-by-policy", "Select by threat model"))
                .add(endpoint("POST", "/api/crypto/encrypt", "Encrypt data"))
                .add(endpoint("POST", "/api/crypto/decrypt", "Decrypt data"))
                .add(endpoint("POST", "/api/crypto/generate-keys", "Generate keys"))
                .add(endpoint("GET", "/api/stats", "Get statistics"))
                .add(endpoint("GET", "/api/health", "Health check")));
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(docs.encodePrettily());
    }

    private JsonObject endpoint(String method, String path, String description) {
        return new JsonObject()
            .put("method", method)
            .put("path", path)
            .put("description", description);
    }

    private void handleListProviders(RoutingContext ctx) {
        JsonArray providers = new JsonArray();
        
        for (CryptoProvider provider : cryptoRuntime.getAvailableProviders()) {
            providers.add(new JsonObject()
                .put("name", provider.getAlgorithmName())
                .put("type", provider.getProviderType().toString())
                .put("quantumSafe", provider.isQuantumSafe())
                .put("securityLevel", provider.getSecurityLevel()));
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("providers", providers)
                .put("count", providers.size())
                .encodePrettily());
    }

    private void handleGetActiveProvider(RoutingContext ctx) {
        CryptoProvider active = cryptoRuntime.getActiveProvider();
        
        if (active == null) {
            ctx.response().setStatusCode(404)
                .end(new JsonObject().put("error", "No active provider").encodePrettily());
            return;
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("name", active.getAlgorithmName())
                .put("type", active.getProviderType().toString())
                .put("quantumSafe", active.isQuantumSafe())
                .put("securityLevel", active.getSecurityLevel())
                .encodePrettily());
    }

    private void handleSwitchProvider(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String providerName = body.getString("providerName");
        
        if (providerName == null || providerName.isEmpty()) {
            ctx.response().setStatusCode(400)
                .end(new JsonObject().put("error", "providerName is required").encodePrettily());
            return;
        }
        
        boolean success = cryptoRuntime.switchProvider(providerName);
        
        if (success) {
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("message", "Switched to provider: " + providerName)
                    .encodePrettily());
        } else {
            ctx.response().setStatusCode(404)
                .end(new JsonObject().put("error", "Provider not found: " + providerName).encodePrettily());
        }
    }

    private void handleSelectByPolicy(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String threatModelName = body.getString("threatModel");
        
        if (threatModelName == null) {
            ctx.response().setStatusCode(400)
                .end(new JsonObject().put("error", "threatModel is required").encodePrettily());
            return;
        }
        
        ThreatModel threatModel = getThreatModel(threatModelName);
        if (threatModel == null) {
            ctx.response().setStatusCode(400)
                .end(new JsonObject().put("error", "Invalid threat model").encodePrettily());
            return;
        }
        
        CryptoProvider selected = cryptoRuntime.selectProvider(threatModel);
        
        if (selected != null) {
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("threatModel", threatModelName)
                    .put("selectedProvider", selected.getAlgorithmName())
                    .put("quantumSafe", selected.isQuantumSafe())
                    .encodePrettily());
        } else {
            ctx.response().setStatusCode(404)
                .end(new JsonObject().put("error", "No suitable provider found").encodePrettily());
        }
    }

    private ThreatModel getThreatModel(String name) {
        return switch (name.toLowerCase()) {
            case "low-security" -> ThreatModel.LOW_SECURITY;
            case "standard" -> ThreatModel.STANDARD;
            case "high-security" -> ThreatModel.HIGH_SECURITY;
            case "quantum-safe" -> ThreatModel.QUANTUM_SAFE;
            case "government" -> ThreatModel.GOVERNMENT;
            default -> null;
        };
    }

    private void handleEncrypt(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String data = body.getString("data");
        String sessionId = body.getString("sessionId", "default");
        
        if (data == null) {
            ctx.response().setStatusCode(400)
                .end(new JsonObject().put("error", "data is required").encodePrettily());
            return;
        }
        
        try {
            CryptoProvider provider = cryptoRuntime.getActiveProvider();
            KeyPair keyPair = sessionKeys.computeIfAbsent(sessionId, k -> {
                try {
                    return provider.generateKeyPair();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            });
            
            byte[] plaintext = data.getBytes(StandardCharsets.UTF_8);
            byte[] ciphertext = provider.encrypt(plaintext, keyPair.getPublic());
            String encoded = Base64.getEncoder().encodeToString(ciphertext);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("ciphertext", encoded)
                    .put("provider", provider.getAlgorithmName())
                    .put("sessionId", sessionId)
                    .encodePrettily());
                    
        } catch (Exception e) {
            ctx.response().setStatusCode(500)
                .end(new JsonObject().put("error", "Encryption failed: " + e.getMessage()).encodePrettily());
        }
    }

    private void handleDecrypt(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String ciphertext = body.getString("ciphertext");
        String sessionId = body.getString("sessionId", "default");
        
        if (ciphertext == null) {
            ctx.response().setStatusCode(400)
                .end(new JsonObject().put("error", "ciphertext is required").encodePrettily());
            return;
        }
        
        try {
            CryptoProvider provider = cryptoRuntime.getActiveProvider();
            KeyPair keyPair = sessionKeys.get(sessionId);
            
            if (keyPair == null) {
                ctx.response().setStatusCode(404)
                    .end(new JsonObject().put("error", "Session not found").encodePrettily());
                return;
            }
            
            byte[] encrypted = Base64.getDecoder().decode(ciphertext);
            byte[] decrypted = provider.decrypt(encrypted, keyPair.getPrivate());
            String plaintext = new String(decrypted, StandardCharsets.UTF_8);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("plaintext", plaintext)
                    .put("provider", provider.getAlgorithmName())
                    .encodePrettily());
                    
        } catch (Exception e) {
            ctx.response().setStatusCode(500)
                .end(new JsonObject().put("error", "Decryption failed: " + e.getMessage()).encodePrettily());
        }
    }

    private void handleGenerateKeys(RoutingContext ctx) {
        try {
            CryptoProvider provider = cryptoRuntime.getActiveProvider();
            KeyPair keyPair = provider.generateKeyPair();
            
            String sessionId = "session-" + System.currentTimeMillis();
            sessionKeys.put(sessionId, keyPair);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("sessionId", sessionId)
                    .put("provider", provider.getAlgorithmName())
                    .put("publicKeySize", keyPair.getPublic().getEncoded().length)
                    .put("privateKeySize", keyPair.getPrivate().getEncoded().length)
                    .encodePrettily());
                    
        } catch (Exception e) {
            ctx.response().setStatusCode(500)
                .end(new JsonObject().put("error", "Key generation failed: " + e.getMessage()).encodePrettily());
        }
    }

    private void handleGetStats(RoutingContext ctx) {
        CryptoProvider active = cryptoRuntime.getActiveProvider();
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("totalProviders", cryptoRuntime.getAvailableProviders().size())
                .put("activeProvider", active != null ? active.getAlgorithmName() : null)
                .put("activeSessions", sessionKeys.size())
                .put("quantumSafeProviders", cryptoRuntime.getAvailableProviders().stream()
                    .filter(CryptoProvider::isQuantumSafe)
                    .count())
                .encodePrettily());
    }

    private void handleHealthCheck(RoutingContext ctx) {
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("status", "healthy")
                .put("service", "PQC Crypto Agility API")
                .put("timestamp", System.currentTimeMillis())
                .encodePrettily());
    }
}

// Made with Bob
