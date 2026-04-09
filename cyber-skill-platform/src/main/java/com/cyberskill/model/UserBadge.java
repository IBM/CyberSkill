package com.cyberskill.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * UserBadge model representing a badge earned by a user
 */
public class UserBadge {
    private UUID id;
    private UUID userId;
    private UUID badgeId;
    private LocalDateTime earnedAt;
    private String earnedFor; // Description of what earned this badge (e.g., "Completed Penetration Testing Module")

    // Constructors
    public UserBadge() {
        this.id = UUID.randomUUID();
        this.earnedAt = LocalDateTime.now();
    }

    public UserBadge(UUID userId, UUID badgeId) {
        this();
        this.userId = userId;
        this.badgeId = badgeId;
    }

    public UserBadge(UUID userId, UUID badgeId, String earnedFor) {
        this(userId, badgeId);
        this.earnedFor = earnedFor;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getBadgeId() {
        return badgeId;
    }

    public void setBadgeId(UUID badgeId) {
        this.badgeId = badgeId;
    }

    public LocalDateTime getEarnedAt() {
        return earnedAt;
    }

    public void setEarnedAt(LocalDateTime earnedAt) {
        this.earnedAt = earnedAt;
    }

    public String getEarnedFor() {
        return earnedFor;
    }

    public void setEarnedFor(String earnedFor) {
        this.earnedFor = earnedFor;
    }

    @Override
    public String toString() {
        return "UserBadge{" +
                "id=" + id +
                ", userId=" + userId +
                ", badgeId=" + badgeId +
                ", earnedAt=" + earnedAt +
                ", earnedFor='" + earnedFor + '\'' +
                '}';
    }
}

// Made with Bob
