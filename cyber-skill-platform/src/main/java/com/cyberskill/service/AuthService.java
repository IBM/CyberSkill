package com.cyberskill.service;

import com.cyberskill.model.User;
import com.cyberskill.model.UserRole;
import com.cyberskill.repository.UserRepository;
import com.cyberskill.security.JwtUtil;
import com.cyberskill.security.PasswordUtil;
import io.vertx.core.Future;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

/**
 * Service for authentication and user management
 */
public class AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);
    private final UserRepository userRepository;
    private final PasswordUtil passwordUtil;
    private final JwtUtil jwtUtil;

    public AuthService(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.passwordUtil = new PasswordUtil();
        this.jwtUtil = new JwtUtil();
    }

    /**
     * Register a new user
     */
    public Future<JsonObject> register(String username, String email, String password) {
        logger.info("Attempting to register user: {}", email);

        // Validate password strength
        if (!passwordUtil.isPasswordStrong(password)) {
            String message = passwordUtil.getPasswordStrengthMessage(password);
            return Future.failedFuture(new IllegalArgumentException(message));
        }

        // Check if email already exists
        return userRepository.emailExists(email)
            .compose(exists -> {
                if (exists) {
                    return Future.failedFuture(new IllegalArgumentException("Email already registered"));
                }
                return userRepository.usernameExists(username);
            })
            .compose(exists -> {
                if (exists) {
                    return Future.failedFuture(new IllegalArgumentException("Username already taken"));
                }
                
                // Create new user
                User user = new User();
                user.setUsername(username);
                user.setEmail(email);
                user.setPasswordHash(passwordUtil.hashPassword(password));
                user.setRole(UserRole.USER);
                user.setActive(true);
                user.setEmailVerified(false);
                
                return userRepository.create(user);
            })
            .map(user -> {
                logger.info("User registered successfully: {}", user.getEmail());
                return createAuthResponse(user);
            })
            .onFailure(err -> logger.error("Registration failed for: {}", email, err));
    }

    /**
     * Login user
     */
    public Future<JsonObject> login(String email, String password) {
        logger.info("Login attempt for: {}", email);

        return userRepository.findByEmail(email)
            .compose(optUser -> {
                if (optUser.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("Invalid email or password"));
                }
                
                User user = optUser.get();
                
                // Check if user is active
                if (!user.isActive()) {
                    return Future.failedFuture(new IllegalArgumentException("Account is disabled"));
                }
                
                // Verify password
                if (!passwordUtil.verifyPassword(password, user.getPasswordHash())) {
                    return Future.failedFuture(new IllegalArgumentException("Invalid email or password"));
                }
                
                // Update last login
                return userRepository.updateLastLogin(user.getId())
                    .map(user);
            })
            .map(user -> {
                logger.info("User logged in successfully: {}", user.getEmail());
                return createAuthResponse(user);
            })
            .onFailure(err -> logger.error("Login failed for: {}", email, err));
    }

    /**
     * Change user password
     */
    public Future<Void> changePassword(Integer userId, String currentPassword, String newPassword) {
        logger.info("Password change attempt for user: {}", userId);

        // Validate new password strength
        if (!passwordUtil.isPasswordStrong(newPassword)) {
            String message = passwordUtil.getPasswordStrengthMessage(newPassword);
            return Future.failedFuture(new IllegalArgumentException(message));
        }

        return userRepository.findById(userId)
            .compose(optUser -> {
                if (optUser.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("User not found"));
                }
                
                User user = optUser.get();
                
                // Verify current password
                if (!passwordUtil.verifyPassword(currentPassword, user.getPasswordHash())) {
                    return Future.failedFuture(new IllegalArgumentException("Current password is incorrect"));
                }
                
                // Hash and update new password
                String newPasswordHash = passwordUtil.hashPassword(newPassword);
                return userRepository.updatePassword(userId, newPasswordHash);
            })
            .onSuccess(v -> logger.info("Password changed successfully for user: {}", userId))
            .onFailure(err -> logger.error("Password change failed for user: {}", userId, err));
    }

    /**
     * Verify JWT token and get user
     */
    public Future<User> verifyToken(String token) {
        try {
            Integer userId = jwtUtil.validateAndGetUserId(token);
            if (userId == null) {
                return Future.failedFuture(new IllegalArgumentException("Invalid token"));
            }
            
            return userRepository.findById(userId)
                .compose(optUser -> {
                    if (optUser.isEmpty()) {
                        return Future.failedFuture(new IllegalArgumentException("User not found"));
                    }
                    return Future.succeededFuture(optUser.get());
                });
        } catch (Exception e) {
            return Future.failedFuture(new IllegalArgumentException("Invalid token"));
        }
    }

    /**
     * Refresh access token
     */
    public Future<JsonObject> refreshToken(String refreshToken) {
        try {
            if (!jwtUtil.isRefreshToken(refreshToken)) {
                return Future.failedFuture(new IllegalArgumentException("Invalid refresh token"));
            }
            
            Integer userId = jwtUtil.getUserIdFromToken(refreshToken);
            if (userId == null) {
                return Future.failedFuture(new IllegalArgumentException("Invalid refresh token"));
            }
            
            return userRepository.findById(userId)
                .compose(optUser -> {
                    if (optUser.isEmpty()) {
                        return Future.failedFuture(new IllegalArgumentException("User not found"));
                    }
                    
                    User user = optUser.get();
                    if (!user.isActive()) {
                        return Future.failedFuture(new IllegalArgumentException("Account is disabled"));
                    }
                    
                    return Future.succeededFuture(createAuthResponse(user));
                });
        } catch (Exception e) {
            return Future.failedFuture(new IllegalArgumentException("Invalid refresh token"));
        }
    }

    /**
     * Create authentication response with tokens
     */
    private JsonObject createAuthResponse(User user) {
        String accessToken = jwtUtil.generateAccessToken(user);
        String refreshToken = jwtUtil.generateRefreshToken(user);
        
        return new JsonObject()
            .put("accessToken", accessToken)
            .put("refreshToken", refreshToken)
            .put("user", new JsonObject()
                .put("id", user.getId())
                .put("username", user.getUsername())
                .put("email", user.getEmail())
                .put("role", user.getRole().getValue())
                .put("mfaEnabled", user.isMfaEnabled())
            );
    }

    /**
     * Get user by ID
     */
    public Future<Optional<User>> getUserById(Integer userId) {
        return userRepository.findById(userId);
    }

    /**
     * Update user profile
     */
    public Future<User> updateProfile(Integer userId, String username, String email) {
        return userRepository.findById(userId)
            .compose(optUser -> {
                if (optUser.isEmpty()) {
                    return Future.failedFuture(new IllegalArgumentException("User not found"));
                }
                
                User user = optUser.get();
                user.setUsername(username);
                user.setEmail(email);
                
                return userRepository.update(user);
            })
            .onSuccess(u -> logger.info("Profile updated for user: {}", userId))
            .onFailure(err -> logger.error("Profile update failed for user: {}", userId, err));
    }
}

// Made with Bob
