package com.cyberskill.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.cyberskill.config.AppConfig;
import com.cyberskill.model.User;
import com.cyberskill.model.UserRole;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

/**
 * JWT utility for token generation and validation
 */
public class JwtUtil {
    private static final Logger logger = LoggerFactory.getLogger(JwtUtil.class);
    private final Algorithm algorithm;
    private final JWTVerifier verifier;
    private final AppConfig config;

    public JwtUtil() {
        this.config = AppConfig.getInstance();
        this.algorithm = Algorithm.HMAC256(config.getJwtSecret());
        this.verifier = JWT.require(algorithm)
                .withIssuer(config.getJwtIssuer())
                .build();
    }

    /**
     * Generate access token for user
     */
    public String generateAccessToken(User user) {
        Instant now = Instant.now();
        Instant expiry = now.plus(config.getJwtAccessExpiry(), ChronoUnit.SECONDS);

        return JWT.create()
                .withIssuer(config.getJwtIssuer())
                .withSubject(user.getId().toString())
                .withClaim("username", user.getUsername())
                .withClaim("email", user.getEmail())
                .withClaim("role", user.getRole().getValue())
                .withIssuedAt(Date.from(now))
                .withExpiresAt(Date.from(expiry))
                .sign(algorithm);
    }

    /**
     * Generate refresh token for user
     */
    public String generateRefreshToken(User user) {
        Instant now = Instant.now();
        Instant expiry = now.plus(config.getJwtRefreshExpiry(), ChronoUnit.SECONDS);

        return JWT.create()
                .withIssuer(config.getJwtIssuer())
                .withSubject(user.getId().toString())
                .withClaim("type", "refresh")
                .withIssuedAt(Date.from(now))
                .withExpiresAt(Date.from(expiry))
                .sign(algorithm);
    }

    /**
     * Verify and decode JWT token
     */
    public DecodedJWT verifyToken(String token) throws JWTVerificationException {
        try {
            return verifier.verify(token);
        } catch (JWTVerificationException e) {
            logger.warn("Token verification failed: {}", e.getMessage());
            throw e;
        }
    }

    /**
     * Extract user ID from token
     */
    public Integer getUserIdFromToken(String token) {
        try {
            DecodedJWT jwt = verifyToken(token);
            return Integer.parseInt(jwt.getSubject());
        } catch (Exception e) {
            logger.error("Error extracting user ID from token", e);
            return null;
        }
    }

    /**
     * Extract username from token
     */
    public String getUsernameFromToken(String token) {
        try {
            DecodedJWT jwt = verifyToken(token);
            return jwt.getClaim("username").asString();
        } catch (Exception e) {
            logger.error("Error extracting username from token", e);
            return null;
        }
    }

    /**
     * Extract user role from token
     */
    public UserRole getRoleFromToken(String token) {
        try {
            DecodedJWT jwt = verifyToken(token);
            String roleStr = jwt.getClaim("role").asString();
            return UserRole.fromString(roleStr);
        } catch (Exception e) {
            logger.error("Error extracting role from token", e);
            return null;
        }
    }

    /**
     * Check if token is expired
     */
    public boolean isTokenExpired(String token) {
        try {
            DecodedJWT jwt = JWT.decode(token);
            return jwt.getExpiresAt().before(new Date());
        } catch (Exception e) {
            logger.error("Error checking token expiration", e);
            return true;
        }
    }

    /**
     * Check if token is a refresh token
     */
    public boolean isRefreshToken(String token) {
        try {
            DecodedJWT jwt = JWT.decode(token);
            String type = jwt.getClaim("type").asString();
            return "refresh".equals(type);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Extract token from Authorization header
     */
    public static String extractTokenFromHeader(String authHeader) {
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        return null;
    }

    /**
     * Validate token and return user ID if valid
     */
    public Integer validateAndGetUserId(String token) {
        try {
            if (token == null || isTokenExpired(token)) {
                return null;
            }
            return getUserIdFromToken(token);
        } catch (Exception e) {
            logger.error("Token validation failed", e);
            return null;
        }
    }
}

// Made with Bob
