package com.cyberskill.security;

import com.cyberskill.model.UserRole;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Middleware for JWT authentication and authorization
 */
public class AuthMiddleware {
    private static final Logger logger = LoggerFactory.getLogger(AuthMiddleware.class);
    private final JwtUtil jwtUtil;

    public AuthMiddleware(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    /**
     * Require authentication - validates JWT token
     */
    public Handler<RoutingContext> requireAuth() {
        return ctx -> {
            String authHeader = ctx.request().getHeader("Authorization");
            
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                sendUnauthorized(ctx, "Missing or invalid authorization header");
                return;
            }
            
            String token = JwtUtil.extractTokenFromHeader(authHeader);
            if (token == null) {
                sendUnauthorized(ctx, "Invalid token format");
                return;
            }
            
            try {
                Integer userId = jwtUtil.validateAndGetUserId(token);
                if (userId == null) {
                    sendUnauthorized(ctx, "Invalid or expired token");
                    return;
                }
                
                // Store user info in context for downstream handlers
                ctx.put("userId", userId);
                ctx.put("username", jwtUtil.getUsernameFromToken(token));
                ctx.put("role", jwtUtil.getRoleFromToken(token));
                
                ctx.next();
                
            } catch (Exception e) {
                logger.error("Token validation failed", e);
                sendUnauthorized(ctx, "Invalid token");
            }
        };
    }

    /**
     * Require admin role
     */
    public Handler<RoutingContext> requireAdmin() {
        return ctx -> {
            UserRole role = ctx.get("role");
            
            if (role == null || role != UserRole.ADMIN) {
                sendForbidden(ctx, "Admin access required");
                return;
            }
            
            ctx.next();
        };
    }

    /**
     * Require user role (any authenticated user)
     */
    public Handler<RoutingContext> requireUser() {
        return ctx -> {
            UserRole role = ctx.get("role");
            
            if (role == null) {
                sendForbidden(ctx, "User access required");
                return;
            }
            
            ctx.next();
        };
    }

    /**
     * Optional authentication - validates token if present but doesn't require it
     */
    public Handler<RoutingContext> optionalAuth() {
        return ctx -> {
            String authHeader = ctx.request().getHeader("Authorization");
            
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = JwtUtil.extractTokenFromHeader(authHeader);
                
                if (token != null) {
                    try {
                        Integer userId = jwtUtil.validateAndGetUserId(token);
                        if (userId != null) {
                            ctx.put("userId", userId);
                            ctx.put("username", jwtUtil.getUsernameFromToken(token));
                            ctx.put("role", jwtUtil.getRoleFromToken(token));
                        }
                    } catch (Exception e) {
                        logger.debug("Optional auth token validation failed", e);
                    }
                }
            }
            
            ctx.next();
        };
    }

    /**
     * Send 401 Unauthorized response
     */
    private void sendUnauthorized(RoutingContext ctx, String message) {
        ctx.response()
            .setStatusCode(401)
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("error", "Unauthorized")
                .put("message", message)
                .encode());
    }

    /**
     * Send 403 Forbidden response
     */
    private void sendForbidden(RoutingContext ctx, String message) {
        ctx.response()
            .setStatusCode(403)
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("error", "Forbidden")
                .put("message", message)
                .encode());
    }
}

// Made with Bob
