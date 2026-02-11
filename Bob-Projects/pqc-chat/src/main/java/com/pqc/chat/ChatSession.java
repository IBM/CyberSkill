package com.pqc.chat;

import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Represents a chat session between two users
 */
public class ChatSession {
    private static final Logger logger = LoggerFactory.getLogger(ChatSession.class);
    
    private final String sessionId;
    private final String user1Id;
    private final String user2Id;
    private final PQCCryptoService user1Crypto;
    private final PQCCryptoService user2Crypto;
    private final List<JsonObject> messages;
    private boolean keyExchangeComplete;
    
    public ChatSession(String user1Id, String user2Id) {
        this.sessionId = UUID.randomUUID().toString();
        this.user1Id = user1Id;
        this.user2Id = user2Id;
        this.user1Crypto = new PQCCryptoService();
        this.user2Crypto = new PQCCryptoService();
        this.messages = new ArrayList<>();
        this.keyExchangeComplete = false;
        
        logger.info("Created chat session {} between {} and {}", sessionId, user1Id, user2Id);
    }
    
    /**
     * Initialize key exchange for both users
     */
    public JsonObject initializeKeyExchange() throws Exception {
        // Generate key pairs for both users
        user1Crypto.initializeKeyPair();
        user2Crypto.initializeKeyPair();
        
        // Get public keys
        String user1PublicKey = user1Crypto.getPublicKeyBase64();
        String user2PublicKey = user2Crypto.getPublicKeyBase64();
        
        // User 1 encapsulates a key using User 2's public key
        String encapsulatedKey = user1Crypto.performKeyEncapsulation(user2PublicKey);
        
        // User 2 decapsulates the key using their private key
        user2Crypto.performKeyDecapsulation(encapsulatedKey);
        
        keyExchangeComplete = true;
        
        logger.info("ML-KEM key exchange completed for session {}", sessionId);
        
        return new JsonObject()
            .put("sessionId", sessionId)
            .put("user1PublicKey", user1PublicKey)
            .put("user2PublicKey", user2PublicKey)
            .put("user1Steps", new JsonArray(user1Crypto.getHandshakeSteps()))
            .put("user2Steps", new JsonArray(user2Crypto.getHandshakeSteps()))
            .put("keyExchangeComplete", true);
    }
    
    /**
     * Send a message from one user to another
     */
    public JsonObject sendMessage(String fromUserId, String plaintext) throws Exception {
        if (!keyExchangeComplete) {
            throw new IllegalStateException("Key exchange not complete");
        }
        
        PQCCryptoService senderCrypto = fromUserId.equals(user1Id) ? user1Crypto : user2Crypto;
        PQCCryptoService receiverCrypto = fromUserId.equals(user1Id) ? user2Crypto : user1Crypto;
        String toUserId = fromUserId.equals(user1Id) ? user2Id : user1Id;
        
        // Encrypt message
        String encrypted = senderCrypto.encryptMessage(plaintext);
        
        // Decrypt message (to verify)
        String decrypted = receiverCrypto.decryptMessage(encrypted);
        
        // Store message
        JsonObject message = new JsonObject()
            .put("timestamp", System.currentTimeMillis())
            .put("from", fromUserId)
            .put("to", toUserId)
            .put("plaintext", plaintext)
            .put("encrypted", encrypted)
            .put("decrypted", decrypted)
            .put("encryptedSize", encrypted.length());
        
        messages.add(message);
        
        logger.info("Message sent in session {} from {} to {}", sessionId, fromUserId, toUserId);
        
        return message;
    }
    
    /**
     * Get all messages in the session
     */
    public List<JsonObject> getMessages() {
        return new ArrayList<>(messages);
    }
    
    /**
     * Get handshake steps for a specific user
     */
    public List<String> getHandshakeSteps(String userId) {
        if (userId.equals(user1Id)) {
            return user1Crypto.getHandshakeSteps();
        } else if (userId.equals(user2Id)) {
            return user2Crypto.getHandshakeSteps();
        }
        return new ArrayList<>();
    }
    
    /**
     * Get session info
     */
    public JsonObject getSessionInfo() {
        return new JsonObject()
            .put("sessionId", sessionId)
            .put("user1Id", user1Id)
            .put("user2Id", user2Id)
            .put("keyExchangeComplete", keyExchangeComplete)
            .put("messageCount", messages.size())
            .put("user1HandshakeSteps", new JsonArray(user1Crypto.getHandshakeSteps()))
            .put("user2HandshakeSteps", new JsonArray(user2Crypto.getHandshakeSteps()));
    }
    
    // Getters
    public String getSessionId() {
        return sessionId;
    }
    
    public String getUser1Id() {
        return user1Id;
    }
    
    public String getUser2Id() {
        return user2Id;
    }
    
    public boolean isKeyExchangeComplete() {
        return keyExchangeComplete;
    }
}

// Made with Bob
