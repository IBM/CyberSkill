package com.cyberskill.repository;

import com.cyberskill.model.User;
import com.cyberskill.model.UserRole;
import io.vertx.core.Future;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * Repository for User database operations
 */
public class UserRepository {
    private static final Logger logger = LoggerFactory.getLogger(UserRepository.class);
    private final PgPool pool;

    public UserRepository(PgPool pool) {
        this.pool = pool;
    }

    /**
     * Find user by ID
     */
    public Future<Optional<User>> findById(Integer id) {
        String query = "SELECT * FROM users WHERE id = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(id))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<User>empty();
                }
                return Optional.of(mapRowToUser(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding user by id: {}", id, err));
    }

    /**
     * Find user by email
     */
    public Future<Optional<User>> findByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(email))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<User>empty();
                }
                return Optional.of(mapRowToUser(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding user by email: {}", email, err));
    }

    /**
     * Find user by username
     */
    public Future<Optional<User>> findByUsername(String username) {
        String query = "SELECT * FROM users WHERE username = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(username))
            .map(rows -> {
                if (rows.size() == 0) {
                    return Optional.<User>empty();
                }
                return Optional.of(mapRowToUser(rows.iterator().next()));
            })
            .onFailure(err -> logger.error("Error finding user by username: {}", username, err));
    }

    /**
     * Create new user
     */
    public Future<User> create(User user) {
        String query = "INSERT INTO users (username, email, password_hash, role, mfa_enabled, is_active, email_verified) " +
                      "VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(
                user.getUsername(),
                user.getEmail(),
                user.getPasswordHash(),
                user.getRole().getValue(),
                user.isMfaEnabled(),
                user.isActive(),
                user.isEmailVerified()
            ))
            .map(rows -> mapRowToUser(rows.iterator().next()))
            .onSuccess(u -> logger.info("Created user: {}", u.getUsername()))
            .onFailure(err -> logger.error("Error creating user: {}", user.getUsername(), err));
    }

    /**
     * Update user
     */
    public Future<User> update(User user) {
        String query = "UPDATE users SET username = $1, email = $2, role = $3, " +
                      "mfa_enabled = $4, is_active = $5, email_verified = $6, updated_at = CURRENT_TIMESTAMP " +
                      "WHERE id = $7 RETURNING *";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(
                user.getUsername(),
                user.getEmail(),
                user.getRole().getValue(),
                user.isMfaEnabled(),
                user.isActive(),
                user.isEmailVerified(),
                user.getId()
            ))
            .map(rows -> mapRowToUser(rows.iterator().next()))
            .onSuccess(u -> logger.info("Updated user: {}", u.getUsername()))
            .onFailure(err -> logger.error("Error updating user: {}", user.getId(), err));
    }

    /**
     * Update user password
     */
    public Future<Void> updatePassword(Integer userId, String passwordHash) {
        String query = "UPDATE users SET password_hash = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(passwordHash, userId))
            .map(rs -> (Void) null)
            .onSuccess(v -> logger.info("Updated password for user: {}", userId))
            .onFailure(err -> logger.error("Error updating password for user: {}", userId, err));
    }

    /**
     * Update last login timestamp
     */
    public Future<Void> updateLastLogin(Integer userId) {
        String query = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(userId))
            .map(rs -> (Void) null)
            .onFailure(err -> logger.error("Error updating last login for user: {}", userId, err));
    }

    /**
     * Delete user
     */
    public Future<Void> delete(Integer userId) {
        String query = "DELETE FROM users WHERE id = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(userId))
            .map(rs -> (Void) null)
            .onSuccess(v -> logger.info("Deleted user: {}", userId))
            .onFailure(err -> logger.error("Error deleting user: {}", userId, err));
    }

    /**
     * Find all users
     */
    public Future<List<User>> findAll() {
        String query = "SELECT * FROM users ORDER BY created_at DESC";
        
        return pool.query(query)
            .execute()
            .map(rows -> {
                List<User> users = new ArrayList<>();
                for (Row row : rows) {
                    users.add(mapRowToUser(row));
                }
                return users;
            })
            .onFailure(err -> logger.error("Error finding all users", err));
    }

    /**
     * Find users by role
     */
    public Future<List<User>> findByRole(UserRole role) {
        String query = "SELECT * FROM users WHERE role = $1 ORDER BY created_at DESC";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(role.getValue()))
            .map(rows -> {
                List<User> users = new ArrayList<>();
                for (Row row : rows) {
                    users.add(mapRowToUser(row));
                }
                return users;
            })
            .onFailure(err -> logger.error("Error finding users by role: {}", role, err));
    }

    /**
     * Check if email exists
     */
    public Future<Boolean> emailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(email))
            .map(rows -> rows.iterator().next().getLong(0) > 0)
            .onFailure(err -> logger.error("Error checking email exists: {}", email, err));
    }

    /**
     * Check if username exists
     */
    public Future<Boolean> usernameExists(String username) {
        String query = "SELECT COUNT(*) FROM users WHERE username = $1";
        
        return pool.preparedQuery(query)
            .execute(Tuple.of(username))
            .map(rows -> rows.iterator().next().getLong(0) > 0)
            .onFailure(err -> logger.error("Error checking username exists: {}", username, err));
    }

    /**
     * Count all users
     */
    public Future<Integer> countAllUsers() {
        String query = "SELECT COUNT(*) as count FROM users";
        
        return pool.query(query)
            .execute()
            .map(rows -> {
                if (rows.iterator().hasNext()) {
                    return rows.iterator().next().getInteger("count");
                }
                return 0;
            })
            .onFailure(err -> logger.error("Error counting all users", err));
    }

    /**
     * Map database row to User object
     */
    private User mapRowToUser(Row row) {
        User user = new User();
        user.setId(row.getInteger("id"));
        user.setUsername(row.getString("username"));
        user.setEmail(row.getString("email"));
        user.setPasswordHash(row.getString("password_hash"));
        user.setRole(UserRole.fromString(row.getString("role")));
        user.setMfaEnabled(row.getBoolean("mfa_enabled"));
        user.setMfaSecret(row.getString("mfa_secret"));
        user.setActive(row.getBoolean("is_active"));
        user.setEmailVerified(row.getBoolean("email_verified"));
        user.setCreatedAt(row.getLocalDateTime("created_at"));
        user.setUpdatedAt(row.getLocalDateTime("updated_at"));
        user.setLastLogin(row.getLocalDateTime("last_login"));
        return user;
    }
}

// Made with Bob
