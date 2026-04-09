package com.cyberskill.config;

import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Application configuration loader and holder
 */
public class AppConfig {
    private static final Logger logger = LoggerFactory.getLogger(AppConfig.class);
    private static AppConfig instance;
    private final Properties properties;

    private AppConfig() {
        properties = new Properties();
        loadProperties();
    }

    public static synchronized AppConfig getInstance() {
        if (instance == null) {
            instance = new AppConfig();
        }
        return instance;
    }

    private void loadProperties() {
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("application.properties")) {
            if (input == null) {
                logger.error("Unable to find application.properties");
                return;
            }
            properties.load(input);
            logger.info("Application properties loaded successfully");
        } catch (IOException e) {
            logger.error("Error loading application properties", e);
        }
    }

    public String get(String key) {
        return properties.getProperty(key);
    }

    public String get(String key, String defaultValue) {
        return properties.getProperty(key, defaultValue);
    }

    public int getInt(String key, int defaultValue) {
        String value = properties.getProperty(key);
        if (value != null) {
            try {
                return Integer.parseInt(value);
            } catch (NumberFormatException e) {
                logger.warn("Invalid integer value for key {}: {}", key, value);
            }
        }
        return defaultValue;
    }

    public boolean getBoolean(String key, boolean defaultValue) {
        String value = properties.getProperty(key);
        if (value != null) {
            return Boolean.parseBoolean(value);
        }
        return defaultValue;
    }

    // Server Configuration
    public int getServerPort() {
        return getInt("server.port", 8080);
    }

    public String getServerHost() {
        return get("server.host", "0.0.0.0");
    }

    // Database Configuration
    public String getDatabaseHost() {
        return get("database.host", "localhost");
    }

    public int getDatabasePort() {
        return getInt("database.port", 5432);
    }

    public String getDatabaseName() {
        return get("database.name", "cyberskill");
    }

    public String getDatabaseUsername() {
        return get("database.username", "cyberskill_user");
    }

    public String getDatabasePassword() {
        return get("database.password", "changeme");
    }

    public int getDatabasePoolMaxSize() {
        return getInt("database.pool.max.size", 20);
    }

    public String getDatabaseUrl() {
        return String.format("jdbc:postgresql://%s:%d/%s",
                getDatabaseHost(), getDatabasePort(), getDatabaseName());
    }

    // JWT Configuration
    public String getJwtSecret() {
        return get("jwt.secret", "CHANGE_THIS_SECRET_IN_PRODUCTION");
    }

    public int getJwtAccessExpiry() {
        return getInt("jwt.expiry.access", 3600);
    }

    public int getJwtRefreshExpiry() {
        return getInt("jwt.expiry.refresh", 604800);
    }

    public String getJwtIssuer() {
        return get("jwt.issuer", "cyberskill-platform");
    }

    // Security Configuration
    public int getBcryptRounds() {
        return getInt("security.bcrypt.rounds", 12);
    }

    public boolean isMfaEnabled() {
        return getBoolean("security.mfa.enabled", true);
    }

    public int getSessionTimeout() {
        return getInt("security.session.timeout", 1800);
    }

    // CORS Configuration
    public String[] getCorsAllowedOrigins() {
        String origins = get("cors.allowed.origins", "http://localhost:8080");
        return origins.split(",");
    }

    public String[] getCorsAllowedMethods() {
        String methods = get("cors.allowed.methods", "GET,POST,PUT,DELETE,OPTIONS");
        return methods.split(",");
    }

    public String[] getCorsAllowedHeaders() {
        String headers = get("cors.allowed.headers", "Content-Type,Authorization");
        return headers.split(",");
    }

    public int getCorsMaxAge() {
        return getInt("cors.max.age", 3600);
    }

    // File Upload Configuration
    public long getUploadMaxSize() {
        return Long.parseLong(get("upload.max.size", "10485760"));
    }

    public String[] getUploadAllowedTypes() {
        String types = get("upload.allowed.types", "image/jpeg,image/png");
        return types.split(",");
    }

    // Logging Configuration
    public String getLoggingLevel() {
        return get("logging.level", "INFO");
    }

    // Certificate Configuration
    public String getCertificateStoragePath() {
        return get("certificate.storage.path", "certificates");
    }

    public String getCertificateTemplatePath() {
        return get("certificate.template.path", "templates/certificate-template.pdf");
    }

    // Rate Limiting
    public boolean isRateLimitEnabled() {
        return getBoolean("rate.limit.enabled", true);
    }

    public int getRateLimitRequestsPerMinute() {
        return getInt("rate.limit.requests.per.minute", 60);
    }

    public int getRateLimitRequestsPerHour() {
        return getInt("rate.limit.requests.per.hour", 1000);
    }

    // Cache Configuration
    public boolean isCacheEnabled() {
        return getBoolean("cache.enabled", true);
    }

    public int getCacheTtlSeconds() {
        return getInt("cache.ttl.seconds", 300);
    }

    // Analytics Configuration
    public boolean isAnalyticsEnabled() {
        return getBoolean("analytics.enabled", true);
    }

    /**
     * Convert configuration to JsonObject for Vert.x
     */
    public JsonObject toJsonObject() {
        JsonObject config = new JsonObject();
        properties.forEach((key, value) -> config.put(key.toString(), value));
        return config;
    }

    /**
     * Get database connection options as JsonObject
     */
    public JsonObject getDatabaseConfig() {
        return new JsonObject()
                .put("host", getDatabaseHost())
                .put("port", getDatabasePort())
                .put("database", getDatabaseName())
                .put("user", getDatabaseUsername())
                .put("password", getDatabasePassword())
                .put("maxSize", getDatabasePoolMaxSize());
    }
}

// Made with Bob
