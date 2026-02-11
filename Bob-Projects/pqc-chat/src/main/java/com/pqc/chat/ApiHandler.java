package com.pqc.chat;

import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * API Handler for PQC Chat endpoints
 */
public class ApiHandler {
    private static final Logger logger = LoggerFactory.getLogger(ApiHandler.class);
    
    private final Map<String, ChatSession> sessions = new ConcurrentHashMap<>();
    
    /**
     * Create a new chat session
     */
    public void createSession(RoutingContext ctx) {
        try {
            JsonObject body = ctx.body().asJsonObject();
            String user1Id = body.getString("user1Id", "Alice");
            String user2Id = body.getString("user2Id", "Bob");
            
            // Create new session
            ChatSession session = new ChatSession(user1Id, user2Id);
            
            // Initialize key exchange
            JsonObject result = session.initializeKeyExchange();
            
            // Store session
            sessions.put(session.getSessionId(), session);
            
            logger.info("Created session: {}", session.getSessionId());
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(result.encodePrettily());
                
        } catch (Exception e) {
            logger.error("Failed to create session", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to create session")
                    .put("message", e.getMessage())
                    .encodePrettily());
        }
    }
    
    /**
     * Send a message in a session
     */
    public void sendMessage(RoutingContext ctx) {
        try {
            String sessionId = ctx.pathParam("sessionId");
            JsonObject body = ctx.body().asJsonObject();
            String fromUserId = body.getString("from");
            String message = body.getString("message");
            
            ChatSession session = sessions.get(sessionId);
            if (session == null) {
                ctx.response()
                    .setStatusCode(404)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Session not found")
                        .encodePrettily());
                return;
            }
            
            // Send message
            JsonObject result = session.sendMessage(fromUserId, message);
            
            logger.info("Message sent in session {}", sessionId);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(result.encodePrettily());
                
        } catch (Exception e) {
            logger.error("Failed to send message", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to send message")
                    .put("message", e.getMessage())
                    .encodePrettily());
        }
    }
    
    /**
     * Get session info including handshake steps
     */
    public void getSessionInfo(RoutingContext ctx) {
        try {
            String sessionId = ctx.pathParam("sessionId");
            
            ChatSession session = sessions.get(sessionId);
            if (session == null) {
                ctx.response()
                    .setStatusCode(404)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Session not found")
                        .encodePrettily());
                return;
            }
            
            JsonObject info = session.getSessionInfo();
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(info.encodePrettily());
                
        } catch (Exception e) {
            logger.error("Failed to get session info", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to get session info")
                    .put("message", e.getMessage())
                    .encodePrettily());
        }
    }
    
    /**
     * Get all messages in a session
     */
    public void getMessages(RoutingContext ctx) {
        try {
            String sessionId = ctx.pathParam("sessionId");
            
            ChatSession session = sessions.get(sessionId);
            if (session == null) {
                ctx.response()
                    .setStatusCode(404)
                    .putHeader("Content-Type", "application/json")
                    .end(new JsonObject()
                        .put("error", "Session not found")
                        .encodePrettily());
                return;
            }
            
            JsonArray messages = new JsonArray();
            session.getMessages().forEach(messages::add);
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("sessionId", sessionId)
                    .put("messages", messages)
                    .encodePrettily());
                
        } catch (Exception e) {
            logger.error("Failed to get messages", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to get messages")
                    .put("message", e.getMessage())
                    .encodePrettily());
        }
    }
    
    /**
     * List all active sessions
     */
    public void listSessions(RoutingContext ctx) {
        try {
            JsonArray sessionList = new JsonArray();
            
            sessions.values().forEach(session -> {
                sessionList.add(new JsonObject()
                    .put("sessionId", session.getSessionId())
                    .put("user1Id", session.getUser1Id())
                    .put("user2Id", session.getUser2Id())
                    .put("keyExchangeComplete", session.isKeyExchangeComplete())
                    .put("messageCount", session.getMessages().size()));
            });
            
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("sessions", sessionList)
                    .put("count", sessions.size())
                    .encodePrettily());
                
        } catch (Exception e) {
            logger.error("Failed to list sessions", e);
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("error", "Failed to list sessions")
                    .put("message", e.getMessage())
                    .encodePrettily());
        }
    }
    
    /**
     * Health check endpoint
     */
    public void healthCheck(RoutingContext ctx) {
        ctx.response()
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("status", "healthy")
                .put("service", "PQC Chat")
                .put("activeSessions", sessions.size())
                .put("timestamp", System.currentTimeMillis())
                .encodePrettily());
    }
}

// Made with Bob
