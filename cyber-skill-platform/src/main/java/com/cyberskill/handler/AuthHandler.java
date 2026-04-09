package com.cyberskill.handler;

import com.cyberskill.service.AuthService;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.RoutingContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Handler for authentication endpoints
 */
public class AuthHandler {
    private static final Logger logger = LoggerFactory.getLogger(AuthHandler.class);
    private final AuthService authService;

    public AuthHandler(AuthService authService) {
        this.authService = authService;
    }

    /**
     * Handle user registration
     * POST /api/auth/register
     */
    public Handler<RoutingContext> register() {
        return ctx -> {
            logger.info("🔐 POST /api/auth/register - Registration request received");
            try {
                JsonObject body = ctx.body().asJsonObject();
                logger.debug("Request body: {}", body.encodePrettily());
                
                String username = body.getString("username");
                String email = body.getString("email");
                String password = body.getString("password");
                
                logger.info("Registration attempt for username: {}, email: {}", username, email);
                
                // Validate input
                if (username == null || username.trim().isEmpty()) {
                    logger.warn("❌ Registration failed: Username is required");
                    sendError(ctx, 400, "Username is required");
                    return;
                }
                if (email == null || email.trim().isEmpty()) {
                    logger.warn("❌ Registration failed: Email is required");
                    sendError(ctx, 400, "Email is required");
                    return;
                }
                if (password == null || password.trim().isEmpty()) {
                    logger.warn("❌ Registration failed: Password is required");
                    sendError(ctx, 400, "Password is required");
                    return;
                }
                
                logger.info("Calling authService.register() for user: {}", username);
                authService.register(username.trim(), email.trim(), password)
                    .onSuccess(result -> {
                        logger.info("✅ Registration successful for user: {}", username);
                        ctx.response()
                            .setStatusCode(201)
                            .putHeader("Content-Type", "application/json")
                            .end(result.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Registration failed", err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing registration", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Handle user login
     * POST /api/auth/login
     */
    public Handler<RoutingContext> login() {
        return ctx -> {
            try {
                JsonObject body = ctx.body().asJsonObject();
                
                String email = body.getString("email");
                String password = body.getString("password");
                
                // Validate input
                if (email == null || email.trim().isEmpty()) {
                    sendError(ctx, 400, "Email is required");
                    return;
                }
                if (password == null || password.trim().isEmpty()) {
                    sendError(ctx, 400, "Password is required");
                    return;
                }
                
                authService.login(email.trim(), password)
                    .onSuccess(result -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(result.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Login failed for: {}", email, err);
                        sendError(ctx, 401, "Invalid email or password");
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing login", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Handle token refresh
     * POST /api/auth/refresh
     */
    public Handler<RoutingContext> refresh() {
        return ctx -> {
            try {
                JsonObject body = ctx.body().asJsonObject();
                String refreshToken = body.getString("refreshToken");
                
                if (refreshToken == null || refreshToken.trim().isEmpty()) {
                    sendError(ctx, 400, "Refresh token is required");
                    return;
                }
                
                authService.refreshToken(refreshToken)
                    .onSuccess(result -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(result.encode());
                    })
                    .onFailure(err -> {
                        logger.error("Token refresh failed", err);
                        sendError(ctx, 401, "Invalid refresh token");
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing token refresh", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Handle password change
     * POST /api/auth/change-password
     */
    public Handler<RoutingContext> changePassword() {
        return ctx -> {
            try {
                // Get user ID from context (set by auth middleware)
                Integer userId = ctx.get("userId");
                if (userId == null) {
                    sendError(ctx, 401, "Unauthorized");
                    return;
                }
                
                JsonObject body = ctx.body().asJsonObject();
                String currentPassword = body.getString("currentPassword");
                String newPassword = body.getString("newPassword");
                
                if (currentPassword == null || newPassword == null) {
                    sendError(ctx, 400, "Current and new passwords are required");
                    return;
                }
                
                authService.changePassword(userId, currentPassword, newPassword)
                    .onSuccess(v -> {
                        ctx.response()
                            .setStatusCode(200)
                            .putHeader("Content-Type", "application/json")
                            .end(new JsonObject()
                                .put("message", "Password changed successfully")
                                .encode());
                    })
                    .onFailure(err -> {
                        logger.error("Password change failed for user: {}", userId, err);
                        sendError(ctx, 400, err.getMessage());
                    });
                    
            } catch (Exception e) {
                logger.error("Error processing password change", e);
                sendError(ctx, 400, "Invalid request body");
            }
        };
    }

    /**
     * Handle logout
     * POST /api/auth/logout
     */
    public Handler<RoutingContext> logout() {
        return ctx -> {
            // In a stateless JWT system, logout is handled client-side
            // Here we just acknowledge the request
            ctx.response()
                .setStatusCode(200)
                .putHeader("Content-Type", "application/json")
                .end(new JsonObject()
                    .put("message", "Logged out successfully")
                    .encode());
        };
    }

    /**
     * Send error response
     */
    private void sendError(RoutingContext ctx, int statusCode, String message) {
        ctx.response()
            .setStatusCode(statusCode)
            .putHeader("Content-Type", "application/json")
            .end(new JsonObject()
                .put("error", message)
                .encode());
    }
}

// Made with Bob
