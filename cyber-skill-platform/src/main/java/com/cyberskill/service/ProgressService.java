package com.cyberskill.service;

import com.cyberskill.model.UserProgress;
import com.cyberskill.repository.ProgressRepository;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;
import java.util.*;

/**
 * Service layer for Progress Tracking business logic
 */
public class ProgressService {
    private static final Logger logger = LoggerFactory.getLogger(ProgressService.class);
    private final ProgressRepository progressRepository;

    public ProgressService(ProgressRepository progressRepository) {
        this.progressRepository = progressRepository;
    }

    /**
     * Mark a lesson as started (create progress record if doesn't exist)
     */
    public Future<UserProgress> startLesson(UUID userId, UUID lessonId) {
        Promise<UserProgress> promise = Promise.promise();

        progressRepository.findByUserAndLesson(userId, lessonId)
                .compose(existingProgress -> {
                    if (existingProgress.isPresent()) {
                        // Update last accessed time
                        UserProgress progress = existingProgress.get();
                        progress.setLastAccessedAt(LocalDateTime.now());
                        return progressRepository.upsertProgress(progress);
                    } else {
                        // Create new progress record
                        UserProgress progress = new UserProgress(userId, lessonId);
                        return progressRepository.upsertProgress(progress);
                    }
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Mark a lesson as completed
     */
    public Future<UserProgress> completeLesson(UUID userId, UUID lessonId) {
        Promise<UserProgress> promise = Promise.promise();

        progressRepository.findByUserAndLesson(userId, lessonId)
                .compose(existingProgress -> {
                    UserProgress progress;
                    if (existingProgress.isPresent()) {
                        progress = existingProgress.get();
                    } else {
                        progress = new UserProgress(userId, lessonId);
                    }

                    progress.setCompleted(true);
                    progress.setCompletedAt(LocalDateTime.now());
                    progress.setLastAccessedAt(LocalDateTime.now());

                    return progressRepository.upsertProgress(progress);
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Update time spent on a lesson
     */
    public Future<UserProgress> updateTimeSpent(UUID userId, UUID lessonId, Integer additionalSeconds) {
        Promise<UserProgress> promise = Promise.promise();

        progressRepository.findByUserAndLesson(userId, lessonId)
                .compose(existingProgress -> {
                    UserProgress progress;
                    if (existingProgress.isPresent()) {
                        progress = existingProgress.get();
                        progress.setTimeSpentSeconds(progress.getTimeSpentSeconds() + additionalSeconds);
                    } else {
                        progress = new UserProgress(userId, lessonId);
                        progress.setTimeSpentSeconds(additionalSeconds);
                    }

                    progress.setLastAccessedAt(LocalDateTime.now());
                    return progressRepository.upsertProgress(progress);
                })
                .onSuccess(promise::complete)
                .onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get user's progress for a specific lesson
     */
    public Future<Optional<UserProgress>> getLessonProgress(UUID userId, UUID lessonId) {
        return progressRepository.findByUserAndLesson(userId, lessonId);
    }

    /**
     * Get all progress for a user
     */
    public Future<List<UserProgress>> getUserProgress(UUID userId) {
        return progressRepository.findByUserId(userId);
    }

    /**
     * Get completed lessons for a user
     */
    public Future<List<UserProgress>> getCompletedLessons(UUID userId) {
        return progressRepository.findCompletedByUserId(userId);
    }

    /**
     * Get section progress summary
     */
    public Future<JsonObject> getSectionProgress(UUID userId, UUID sectionId) {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInSection(userId, sectionId),
                progressRepository.countLessonsInSection(sectionId),
                progressRepository.findByUserAndSection(userId, sectionId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            List<UserProgress> progressList = compositeFuture.resultAt(2);

            int percentage = total > 0 ? (completed * 100) / total : 0;
            boolean isCompleted = total > 0 && completed == total;

            JsonObject result = new JsonObject()
                    .put("sectionId", sectionId.toString())
                    .put("completed", completed)
                    .put("total", total)
                    .put("percentage", percentage)
                    .put("isCompleted", isCompleted)
                    .put("lessons", progressList.size());

            promise.complete(result);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get module progress summary
     */
    public Future<JsonObject> getModuleProgress(UUID userId, UUID moduleId) {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInModule(userId, moduleId),
                progressRepository.countLessonsInModule(moduleId),
                progressRepository.findByUserAndModule(userId, moduleId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            List<UserProgress> progressList = compositeFuture.resultAt(2);

            int percentage = total > 0 ? (completed * 100) / total : 0;
            boolean isCompleted = total > 0 && completed == total;

            // Calculate total time spent
            int totalTimeSpent = progressList.stream()
                    .mapToInt(UserProgress::getTimeSpentSeconds)
                    .sum();

            JsonObject result = new JsonObject()
                    .put("moduleId", moduleId.toString())
                    .put("completed", completed)
                    .put("total", total)
                    .put("percentage", percentage)
                    .put("isCompleted", isCompleted)
                    .put("totalTimeSpentSeconds", totalTimeSpent);

            promise.complete(result);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get learning path progress summary
     */
    public Future<JsonObject> getPathProgress(UUID userId, UUID pathId) {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInPath(userId, pathId),
                progressRepository.countLessonsInPath(pathId),
                progressRepository.findByUserAndPath(userId, pathId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            List<UserProgress> progressList = compositeFuture.resultAt(2);

            int percentage = total > 0 ? (completed * 100) / total : 0;
            boolean isCompleted = total > 0 && completed == total;

            // Calculate total time spent
            int totalTimeSpent = progressList.stream()
                    .mapToInt(UserProgress::getTimeSpentSeconds)
                    .sum();

            // Get last accessed date
            Optional<LocalDateTime> lastAccessed = progressList.stream()
                    .map(UserProgress::getLastAccessedAt)
                    .max(LocalDateTime::compareTo);

            JsonObject result = new JsonObject()
                    .put("pathId", pathId.toString())
                    .put("completed", completed)
                    .put("total", total)
                    .put("percentage", percentage)
                    .put("isCompleted", isCompleted)
                    .put("totalTimeSpentSeconds", totalTimeSpent);

            if (lastAccessed.isPresent()) {
                result.put("lastAccessedAt", lastAccessed.get().toString());
            }

            promise.complete(result);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Get overall user statistics
     */
    public Future<JsonObject> getUserStatistics(UUID userId) {
        Promise<JsonObject> promise = Promise.promise();

        Future.all(
                progressRepository.findByUserId(userId),
                progressRepository.findCompletedByUserId(userId)
        ).onSuccess(compositeFuture -> {
            List<UserProgress> allProgress = compositeFuture.resultAt(0);
            List<UserProgress> completedProgress = compositeFuture.resultAt(1);

            // Calculate statistics
            int totalLessonsStarted = allProgress.size();
            int totalLessonsCompleted = completedProgress.size();
            
            int totalTimeSpent = allProgress.stream()
                    .mapToInt(UserProgress::getTimeSpentSeconds)
                    .sum();

            // Get last activity
            Optional<LocalDateTime> lastActivity = allProgress.stream()
                    .map(UserProgress::getLastAccessedAt)
                    .max(LocalDateTime::compareTo);

            // Calculate streak (consecutive days with activity)
            int currentStreak = calculateStreak(allProgress);

            JsonObject result = new JsonObject()
                    .put("totalLessonsStarted", totalLessonsStarted)
                    .put("totalLessonsCompleted", totalLessonsCompleted)
                    .put("totalTimeSpentSeconds", totalTimeSpent)
                    .put("totalTimeSpentHours", totalTimeSpent / 3600.0)
                    .put("currentStreak", currentStreak);

            if (lastActivity.isPresent()) {
                result.put("lastActivity", lastActivity.get().toString());
            }

            promise.complete(result);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Calculate user's learning streak (consecutive days with activity)
     */
    private int calculateStreak(List<UserProgress> progressList) {
        if (progressList.isEmpty()) {
            return 0;
        }

        // Get unique dates of activity
        Set<LocalDateTime> activityDates = new TreeSet<>(Collections.reverseOrder());
        for (UserProgress progress : progressList) {
            activityDates.add(progress.getLastAccessedAt().toLocalDate().atStartOfDay());
        }

        // Calculate streak
        int streak = 0;
        LocalDateTime today = LocalDateTime.now().toLocalDate().atStartOfDay();
        LocalDateTime checkDate = today;

        for (LocalDateTime activityDate : activityDates) {
            LocalDateTime activityDay = activityDate.toLocalDate().atStartOfDay();
            
            if (activityDay.equals(checkDate) || activityDay.equals(checkDate.minusDays(1))) {
                streak++;
                checkDate = activityDay.minusDays(1);
            } else {
                break;
            }
        }

        return streak;
    }

    /**
     * Reset user progress for a lesson
     */
    public Future<Void> resetLessonProgress(UUID userId, UUID lessonId) {
        return progressRepository.deleteProgress(userId, lessonId);
    }

    /**
     * Check if a section is completed
     */
    public Future<Boolean> isSectionCompleted(UUID userId, UUID sectionId) {
        Promise<Boolean> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInSection(userId, sectionId),
                progressRepository.countLessonsInSection(sectionId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            promise.complete(total > 0 && completed == total);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Check if a module is completed
     */
    public Future<Boolean> isModuleCompleted(UUID userId, UUID moduleId) {
        Promise<Boolean> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInModule(userId, moduleId),
                progressRepository.countLessonsInModule(moduleId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            promise.complete(total > 0 && completed == total);
        }).onFailure(promise::fail);

        return promise.future();
    }

    /**
     * Check if a learning path is completed
     */
    public Future<Boolean> isPathCompleted(UUID userId, UUID pathId) {
        Promise<Boolean> promise = Promise.promise();

        Future.all(
                progressRepository.countCompletedInPath(userId, pathId),
                progressRepository.countLessonsInPath(pathId)
        ).onSuccess(compositeFuture -> {
            int completed = compositeFuture.resultAt(0);
            int total = compositeFuture.resultAt(1);
            promise.complete(total > 0 && completed == total);
        }).onFailure(promise::fail);

        return promise.future();
    }
}

// Made with Bob
