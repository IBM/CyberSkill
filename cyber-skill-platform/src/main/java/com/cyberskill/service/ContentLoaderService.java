package com.cyberskill.service;

import io.vertx.core.Future;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonObject;
import io.vertx.core.logging.Logger;
import io.vertx.core.logging.LoggerFactory;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.Tuple;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.stream.Stream;

/**
 * Service for loading lesson content from JSON files
 */
public class ContentLoaderService {
    private static final Logger logger = LoggerFactory.getLogger(ContentLoaderService.class);
    private final Vertx vertx;
    private final PgPool pool;
    private static final String CONTENT_DIR = "lesson-content";

    public ContentLoaderService(Vertx vertx, PgPool pool) {
        this.vertx = vertx;
        this.pool = pool;
    }

    /**
     * Load all JSON content files and update lessons in database
     */
    public Future<Void> loadAllContent() {
        return vertx.executeBlocking(promise -> {
            try {
                // Get content directory from classpath
                ClassLoader classLoader = getClass().getClassLoader();
                java.net.URL resource = classLoader.getResource(CONTENT_DIR);
                
                if (resource == null) {
                    logger.warn("Content directory not found: " + CONTENT_DIR);
                    promise.complete();
                    return;
                }

                Path contentPath = Paths.get(resource.toURI());
                
                // Process all JSON files
                try (Stream<Path> paths = Files.walk(contentPath)) {
                    paths.filter(Files::isRegularFile)
                         .filter(p -> p.toString().endsWith(".json"))
                         .forEach(this::loadContentFile);
                }
                
                promise.complete();
            } catch (Exception e) {
                logger.error("Error loading content files", e);
                promise.fail(e);
            }
        });
    }

    /**
     * Load a single JSON content file
     */
    private void loadContentFile(Path filePath) {
        try {
            String jsonContent = Files.readString(filePath);
            JsonObject contentObj = new JsonObject(jsonContent);
            
            updateLessonContent(contentObj).onComplete(ar -> {
                if (ar.succeeded()) {
                    logger.info("Successfully loaded content from: " + filePath.getFileName());
                } else {
                    logger.error("Failed to load content from: " + filePath.getFileName(), ar.cause());
                }
            });
            
        } catch (IOException e) {
            logger.error("Error reading content file: " + filePath, e);
        }
    }

    /**
     * Update lesson content in database
     */
    private Future<Void> updateLessonContent(JsonObject contentObj) {
        String sql = "UPDATE lessons SET content = $1, video_url = $2, estimated_minutes = $3 " +
                    "WHERE section_id = $4 AND name = $5";
        
        return pool.preparedQuery(sql)
            .execute(Tuple.of(
                contentObj.getString("content"),
                contentObj.getString("videoUrl", null),
                contentObj.getInteger("estimatedMinutes"),
                contentObj.getInteger("sectionId"),
                contentObj.getString("name")
            ))
            .map(rows -> {
                if (rows.rowCount() == 0) {
                    logger.warn("No lesson found for: " + contentObj.getString("name"));
                }
                return null;
            });
    }

    /**
     * Load content for a specific lesson by ID
     */
    public Future<JsonObject> loadLessonContent(int lessonId) {
        return vertx.executeBlocking(promise -> {
            try {
                ClassLoader classLoader = getClass().getClassLoader();
                java.net.URL resource = classLoader.getResource(CONTENT_DIR);
                
                if (resource == null) {
                    promise.fail("Content directory not found");
                    return;
                }

                Path contentPath = Paths.get(resource.toURI());
                
                // Find JSON file matching lesson ID
                try (Stream<Path> paths = Files.walk(contentPath)) {
                    paths.filter(Files::isRegularFile)
                         .filter(p -> p.toString().endsWith(".json"))
                         .forEach(path -> {
                             try {
                                 String jsonContent = Files.readString(path);
                                 JsonObject contentObj = new JsonObject(jsonContent);
                                 if (contentObj.getInteger("lessonId") == lessonId) {
                                     promise.complete(contentObj);
                                 }
                             } catch (IOException e) {
                                 logger.error("Error reading file: " + path, e);
                             }
                         });
                }
                
                promise.complete(new JsonObject());
            } catch (Exception e) {
                promise.fail(e);
            }
        });
    }
}

// Made with Bob
