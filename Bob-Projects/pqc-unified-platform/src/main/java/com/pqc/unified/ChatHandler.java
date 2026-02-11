package com.pqc.unified;

import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Handler for Secure Messaging functionality
 * Manages chat sessions with PQC key exchange and encrypted messages
 */
public class ChatHandler {
    private static final Logger logger = LoggerFactory.getLogger(ChatHandler.class);
    
    private final Vertx vertx;
    private final JsonObject config;
    private final Map<String, ChatSession> sessions = new ConcurrentHashMap<>();
    
    public ChatHandler(Vertx vertx, JsonObject config) {
        this.vertx = vertx;
        this.config = config;
    }
    
    public void handleCreateSession(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String sessionId = body.getString("sessionId");
        String username = body.getString("username");
        
        if (sessionId == null || username == null) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "sessionId and username are required")
                    .encode());
            return;
        }
        
        logger.info("Creating/joining session: {} for user: {}", sessionId, username);
        
        ChatSession session = sessions.computeIfAbsent(sessionId, id -> new ChatSession(id));
        
        try {
            JsonObject result = session.addUser(username);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("message", "Session created/joined successfully")
                    .put("data", result)
                    .encode());
                    
        } catch (Exception e) {
            logger.error("Failed to create/join session", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to create/join session: " + e.getMessage())
                    .encode());
        }
    }
    
    public void handleJoinSession(RoutingContext ctx) {
        // Same as create session - they're combined
        handleCreateSession(ctx);
    }
    
    public void handleSendMessage(RoutingContext ctx) {
        JsonObject body = ctx.body().asJsonObject();
        String sessionId = body.getString("sessionId");
        String username = body.getString("username");
        String message = body.getString("message");
        
        if (sessionId == null || username == null || message == null) {
            ctx.response()
                .setStatusCode(400)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "sessionId, username, and message are required")
                    .encode());
            return;
        }
        
        ChatSession session = sessions.get(sessionId);
        if (session == null) {
            ctx.response()
                .setStatusCode(404)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Session not found")
                    .encode());
            return;
        }
        
        try {
            JsonObject result = session.sendMessage(username, message);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("success", true)
                    .put("message", "Message sent successfully")
                    .put("data", result)
                    .encode());
                    
        } catch (Exception e) {
            logger.error("Failed to send message", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to send message: " + e.getMessage())
                    .encode());
        }
    }
    
    public void handleGetSession(RoutingContext ctx) {
        String sessionId = ctx.pathParam("id");
        
        ChatSession session = sessions.get(sessionId);
        if (session == null) {
            ctx.response()
                .setStatusCode(404)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Session not found")
                    .encode());
            return;
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(session.toJson().encode());
    }
    
    public void handleListSessions(RoutingContext ctx) {
        JsonArray sessionList = new JsonArray();
        
        for (ChatSession session : sessions.values()) {
            sessionList.add(session.toJson());
        }
        
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("sessions", sessionList)
                .put("total", sessionList.size())
                .encode());
    }
    
    /**
     * Inner class representing a chat session
     */
    private static class ChatSession {
        private final String sessionId;
        private final Map<String, UserInfo> users = new ConcurrentHashMap<>();
        private final List<JsonObject> messages = Collections.synchronizedList(new ArrayList<>());
        private final List<JsonObject> handshakeSteps = Collections.synchronizedList(new ArrayList<>());
        private final long createdAt;
        private boolean keyExchangeComplete = false;
        
        public ChatSession(String sessionId) {
            this.sessionId = sessionId;
            this.createdAt = System.currentTimeMillis();
            addHandshakeStep("Session Created", "Session initialized: " + sessionId);
        }
        
        public JsonObject addUser(String username) throws Exception {
            if (users.size() >= 2 && !users.containsKey(username)) {
                throw new IllegalStateException("Session is full (max 2 users)");
            }
            
            boolean isNewUser = !users.containsKey(username);
            
            UserInfo user = users.computeIfAbsent(username, name -> {
                try {
                    UserInfo newUser = new UserInfo(name);
                    addHandshakeStep("User " + (users.size()) + " Joined",
                                   username + " generated ML-KEM-768 key pair");
                    return newUser;
                } catch (Exception e) {
                    throw new RuntimeException("Failed to create user", e);
                }
            });
            
            // Perform key exchange after both users are in the map
            if (isNewUser && users.size() == 2 && !keyExchangeComplete) {
                performKeyExchange();
            }
            
            return new JsonObject()
                .put("sessionId", sessionId)
                .put("username", username)
                .put("publicKey", user.cryptoService.getPublicKeyBase64())
                .put("userCount", users.size())
                .put("keyExchangeComplete", keyExchangeComplete)
                .put("handshakeSteps", new JsonArray(handshakeSteps));
        }
        
        private void performKeyExchange() throws Exception {
            if (users.size() != 2) {
                return;
            }
            
            List<UserInfo> userList = new ArrayList<>(users.values());
            UserInfo user1 = userList.get(0);
            UserInfo user2 = userList.get(1);
            
            addHandshakeStep("Public Keys Exchanged", 
                           "Users exchanged ML-KEM public keys");
            
            // User 1 encapsulates key using User 2's public key
            byte[] user2PublicKey = user2.cryptoService.getPublicKeyBytes();
            byte[] encapsulatedKey = user1.cryptoService.performKeyEncapsulation(user2PublicKey);
            
            addHandshakeStep("Key Encapsulation", 
                           user1.username + " encapsulated shared secret using " + user2.username + "'s public key");
            
            // User 2 decapsulates to get the same shared secret
            user2.cryptoService.performKeyDecapsulation(encapsulatedKey);
            
            addHandshakeStep("Key Decapsulation", 
                           user2.username + " decapsulated to derive shared secret");
            
            addHandshakeStep("Secure Channel Established", 
                           "Both users have identical AES-256 key for encrypted messaging");
            
            keyExchangeComplete = true;
        }
        
        public JsonObject sendMessage(String username, String message) throws Exception {
            if (!keyExchangeComplete) {
                throw new IllegalStateException("Key exchange not complete");
            }
            
            UserInfo user = users.get(username);
            if (user == null) {
                throw new IllegalStateException("User not in session");
            }
            
            // Encrypt message
            PQCCryptoService.EncryptedData encrypted = user.cryptoService.encryptString(message);
            
            JsonObject messageObj = new JsonObject()
                .put("id", UUID.randomUUID().toString())
                .put("username", username)
                .put("message", message)
                .put("encrypted", encrypted.getCiphertextBase64())
                .put("iv", encrypted.getIvBase64())
                .put("timestamp", System.currentTimeMillis());
            
            messages.add(messageObj);
            
            return messageObj;
        }
        
        private void addHandshakeStep(String step, String description) {
            handshakeSteps.add(new JsonObject()
                .put("step", handshakeSteps.size() + 1)
                .put("name", step)
                .put("description", description)
                .put("timestamp", System.currentTimeMillis()));
        }
        
        public JsonObject toJson() {
            return new JsonObject()
                .put("sessionId", sessionId)
                .put("users", new JsonArray(new ArrayList<>(users.keySet())))
                .put("userCount", users.size())
                .put("messageCount", messages.size())
                .put("keyExchangeComplete", keyExchangeComplete)
                .put("createdAt", createdAt)
                .put("handshakeSteps", new JsonArray(handshakeSteps))
                .put("messages", new JsonArray(messages));
        }
    }
    
    /**
     * Inner class representing a user in a chat session
     */
    private static class UserInfo {
        private final String username;
        private final PQCCryptoService cryptoService;
        
        public UserInfo(String username) throws Exception {
            this.username = username;
            this.cryptoService = new PQCCryptoService();
            this.cryptoService.generateKeyPair();
        }
    }
}

// Made with Bob
