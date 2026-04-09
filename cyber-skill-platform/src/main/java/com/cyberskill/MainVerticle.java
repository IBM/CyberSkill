package com.cyberskill;

import com.cyberskill.config.AppConfig;
import com.cyberskill.handler.*;
import com.cyberskill.repository.*;
import com.cyberskill.security.AuthMiddleware;
import com.cyberskill.security.JwtUtil;
import com.cyberskill.service.*;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.http.HttpServer;
import io.vertx.core.http.HttpServerOptions;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.CorsHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.ext.web.handler.TimeoutHandler;
import io.vertx.ext.web.templ.freemarker.FreeMarkerTemplateEngine;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import org.flywaydb.core.Flyway;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Arrays;
import java.util.HashSet;

/**
 * Main Verticle - Entry point for the CyberSkill Platform
 */
public class MainVerticle extends AbstractVerticle {
    private static final Logger logger = LoggerFactory.getLogger(MainVerticle.class);
    private AppConfig config;
    private PgPool pgPool;
    private FreeMarkerTemplateEngine templateEngine;
    private JwtUtil jwtUtil;
    
    // Repositories
    private UserRepository userRepository;
    private LearningPathRepository learningPathRepository;
    private ModuleRepository moduleRepository;
    private SectionRepository sectionRepository;
    private LessonRepository lessonRepository;
    private QuizRepository quizRepository;
    private ProgressRepository progressRepository;
    private BadgeRepository badgeRepository;
    private CertificateRepository certificateRepository;
    
    // Services
    private AuthService authService;
    private LearningService learningService;
    private ModuleService moduleService;
    private SectionService sectionService;
    private LessonService lessonService;
    private QuizService quizService;
    private ProgressService progressService;
    private BadgeService badgeService;
    private CertificateService certificateService;
    
    // Handlers
    private AuthHandler authHandler;
    private LearningHandler learningHandler;
    private ModuleHandler moduleHandler;
    private SectionHandler sectionHandler;
    private LessonHandler lessonHandler;
    private QuizHandler quizHandler;
    private ProgressHandler progressHandler;
    private BadgeHandler badgeHandler;
    private CertificateHandler certificateHandler;
    
    // Middleware
    private AuthMiddleware authMiddleware;

    @Override
    public void start(Promise<Void> startPromise) {
        logger.info("Starting CyberSkill Platform...");

        try {
            // Initialize configuration
            config = AppConfig.getInstance();
            
            // Initialize JWT utility
            jwtUtil = new JwtUtil();

            // Run database migrations
            runDatabaseMigrations();

            // Initialize database pool
            initializeDatabasePool();
            
            // Initialize repositories
            initializeRepositories();
            
            // Initialize services
            initializeServices();
            
            // Initialize handlers
            initializeHandlers();
            
            // Initialize middleware
            authMiddleware = new AuthMiddleware(jwtUtil);

            // Initialize template engine
            templateEngine = FreeMarkerTemplateEngine.create(vertx);

            // Create HTTP server
            HttpServer server = vertx.createHttpServer(
                new HttpServerOptions()
                    .setCompressionSupported(true)
                    .setIdleTimeout(120)
            );

            // Setup router
            Router router = setupRouter();

            // Start server
            int port = config.getServerPort();
            String host = config.getServerHost();

            server.requestHandler(router)
                .listen(port, host)
                .onSuccess(httpServer -> {
                    logger.info("✓ CyberSkill Platform started successfully");
                    logger.info("✓ Server listening on http://{}:{}", host, port);
                    logger.info("✓ API available at http://{}:{}/api", host, port);
                    logger.info("✓ Admin dashboard at http://{}:{}/admin", host, port);
                    startPromise.complete();
                })
                .onFailure(error -> {
                    logger.error("✗ Failed to start server", error);
                    startPromise.fail(error);
                });

        } catch (Exception e) {
            logger.error("✗ Error during startup", e);
            startPromise.fail(e);
        }
    }
    
    /**
     * Map icon name to emoji
     */
    private String mapIconToEmoji(String iconName) {
        if (iconName == null) return "📚";
        
        switch (iconName.toLowerCase()) {
            case "shield-check":
            case "shield":
                return "🔐";
            case "clipboard":
            case "clipboard-check":
                return "📋";
            case "lock":
            case "lock-closed":
                return "🔒";
            case "atom":
            case "quantum":
                return "⚛️";
            case "crosshair":
            case "target":
                return "🎯";
            case "layers":
            case "architecture":
                return "🏗️";
            case "brain":
            case "ai":
                return "🤖";
            default:
                return "📚";
        }
    }
    
    /**
     * Initialize repositories
     */
    private void initializeRepositories() {
        logger.info("Initializing repositories...");
        userRepository = new UserRepository(pgPool);
        learningPathRepository = new LearningPathRepository(pgPool);
        moduleRepository = new ModuleRepository(pgPool);
        sectionRepository = new SectionRepository(pgPool);
        lessonRepository = new LessonRepository(pgPool);
        quizRepository = new QuizRepository(pgPool);
        progressRepository = new ProgressRepository(pgPool);
        badgeRepository = new BadgeRepository(pgPool);
        certificateRepository = new CertificateRepository(pgPool);
        logger.info("✓ Repositories initialized");
    }
    
    /**
     * Initialize services
     */
    private void initializeServices() {
        logger.info("Initializing services...");
        authService = new AuthService(userRepository);
        learningService = new LearningService(learningPathRepository);
        moduleService = new ModuleService(moduleRepository);
        sectionService = new SectionService(sectionRepository);
        lessonService = new LessonService(lessonRepository);
        quizService = new QuizService(quizRepository);
        progressService = new ProgressService(progressRepository);
        badgeService = new BadgeService(badgeRepository, progressRepository);
        certificateService = new CertificateService(certificateRepository, progressRepository);
        logger.info("✓ Services initialized");
    }
    
    /**
     * Initialize handlers
     */
    private void initializeHandlers() {
        logger.info("Initializing handlers...");
        authHandler = new AuthHandler(authService);
        learningHandler = new LearningHandler(learningService);
        moduleHandler = new ModuleHandler(moduleService);
        sectionHandler = new SectionHandler(sectionService);
        lessonHandler = new LessonHandler(lessonService);
        quizHandler = new QuizHandler(quizService);
        progressHandler = new ProgressHandler(progressService);
        badgeHandler = new BadgeHandler(badgeService);
        certificateHandler = new CertificateHandler(certificateService);
        logger.info("✓ Handlers initialized");
    }

    /**
     * Run Flyway database migrations
     */
    private void runDatabaseMigrations() {
        logger.info("Running database migrations...");
        try {
            Flyway flyway = Flyway.configure()
                .dataSource(
                    config.getDatabaseUrl(),
                    config.getDatabaseUsername(),
                    config.getDatabasePassword()
                )
                .locations("classpath:db/migration")
                .baselineOnMigrate(true)
                .baselineVersion("0")
                .validateOnMigrate(true)
                .load();

            // Run migrations - all content is now stored as JSONB in migrations
            int migrationsApplied = flyway.migrate().migrationsExecuted;
            logger.info("✓ Applied {} database migration(s)", migrationsApplied);
        } catch (Exception e) {
            logger.error("✗ Database migration failed", e);
            throw new RuntimeException("Database migration failed", e);
        }
    }

    /**
     * Initialize PostgreSQL connection pool
     */
    private void initializeDatabasePool() {
        logger.info("Initializing database connection pool...");

        PgConnectOptions connectOptions = new PgConnectOptions()
            .setHost(config.getDatabaseHost())
            .setPort(config.getDatabasePort())
            .setDatabase(config.getDatabaseName())
            .setUser(config.getDatabaseUsername())
            .setPassword(config.getDatabasePassword())
            .setReconnectAttempts(5)
            .setReconnectInterval(2000);

        PoolOptions poolOptions = new PoolOptions()
            .setMaxSize(config.getDatabasePoolMaxSize());

        pgPool = PgPool.pool(vertx, connectOptions, poolOptions);
        logger.info("✓ Database connection pool initialized");
    }

    /**
     * Setup application router with all routes and handlers
     */
    private Router setupRouter() {
        Router router = Router.router(vertx);

        // Global handlers
        setupGlobalHandlers(router);

        // Static resources
        setupStaticResources(router);

        // Web routes (Freemarker templates)
        setupWebRoutes(router);

        // API routes
        setupApiRoutes(router);

        // Error handlers
        setupErrorHandlers(router);

        return router;
    }

    /**
     * Setup global handlers (CORS, Body, Timeout, etc.)
     */
    private void setupGlobalHandlers(Router router) {
        // CORS handler
        CorsHandler corsHandler = CorsHandler.create()
            .addOrigins(Arrays.asList(config.getCorsAllowedOrigins()))
            .allowedMethods(new HashSet<>(Arrays.asList(
                io.vertx.core.http.HttpMethod.GET,
                io.vertx.core.http.HttpMethod.POST,
                io.vertx.core.http.HttpMethod.PUT,
                io.vertx.core.http.HttpMethod.DELETE,
                io.vertx.core.http.HttpMethod.OPTIONS
            )))
            .allowedHeaders(new HashSet<>(Arrays.asList(config.getCorsAllowedHeaders())))
            .maxAgeSeconds(config.getCorsMaxAge());

        router.route().handler(corsHandler);

        // Body handler for parsing request bodies
        router.route().handler(BodyHandler.create()
            .setBodyLimit(config.getUploadMaxSize()));

        // Timeout handler
        router.route().handler(TimeoutHandler.create(30000));

        // Request logging
        router.route().handler(ctx -> {
            logger.debug("{} {}", ctx.request().method(), ctx.request().uri());
            ctx.next();
        });
    }

    /**
     * Setup static resource handlers
     */
    private void setupStaticResources(Router router) {
        // Serve static files from /static
        router.route("/static/*").handler(StaticHandler.create("static")
            .setCachingEnabled(true)
            .setMaxAgeSeconds(86400));

        // Serve CSS
        router.route("/css/*").handler(StaticHandler.create("static/css"));

        // Serve JavaScript
        router.route("/js/*").handler(StaticHandler.create("static/js"));

        // Serve images
        router.route("/images/*").handler(StaticHandler.create("static/images"));
    }

    /**
     * Setup web routes (Freemarker templates)
     */
    private void setupWebRoutes(Router router) {
        // Home page
        router.get("/").handler(ctx -> {
            logger.info("📄 GET / - Rendering home page");
            
            // Fetch all learning paths from database
            learningPathRepository.findAllPaths()
                .onSuccess(paths -> {
                    // Convert learning paths to JSON array for template
                    io.vertx.core.json.JsonArray pathsArray = new io.vertx.core.json.JsonArray();
                    paths.forEach(path -> {
                        io.vertx.core.json.JsonObject pathJson = new io.vertx.core.json.JsonObject()
                            .put("id", path.getId().toString())
                            .put("name", path.getName())
                            .put("slug", path.getSlug())
                            .put("description", path.getDescription())
                            .put("icon", mapIconToEmoji(path.getIcon()))
                            .put("estimatedHours", path.getEstimatedHours());
                        pathsArray.add(pathJson);
                    });
                    
                    // Add learning paths to template context
                    ctx.data().put("learningPaths", pathsArray.getList());
                    
                    templateEngine.render(ctx.data(), "templates/index.ftl")
                        .onSuccess(buffer -> {
                            logger.info("✅ Home page rendered successfully with {} learning paths", paths.size());
                            ctx.response()
                                .putHeader("Content-Type", "text/html")
                                .end(buffer);
                        })
                        .onFailure(err -> {
                            logger.error("❌ Home page rendering failed", err);
                            logger.error("Error details: {}", err.getMessage());
                            ctx.fail(500);
                        });
                })
                .onFailure(err -> {
                    logger.error("❌ Failed to fetch learning paths", err);
                    ctx.fail(500);
                });
        });

        // Login page
        router.get("/login").handler(ctx -> {
            logger.info("📄 GET /login - Rendering login page");
            templateEngine.render(ctx.data(), "templates/login.ftl")
                .onSuccess(buffer -> {
                    logger.info("✅ Login page rendered successfully");
                    ctx.response()
                        .putHeader("Content-Type", "text/html")
                        .end(buffer);
                })
                .onFailure(err -> {
                    logger.error("❌ Login page rendering failed", err);
                    logger.error("Error details: {}", err.getMessage());
                    ctx.fail(500);
                });
        });

        // Register page
        router.get("/register").handler(ctx -> {
            logger.info("📄 GET /register - Rendering registration page");
            templateEngine.render(ctx.data(), "templates/register.ftl")
                .onSuccess(buffer -> {
                    logger.info("✅ Register page rendered successfully");
                    ctx.response()
                        .putHeader("Content-Type", "text/html")
                        .end(buffer);
                })
                .onFailure(err -> {
                    logger.error("❌ Register page rendering failed", err);
                    logger.error("Error details: {}", err.getMessage());
                    logger.error("Template path: templates/register.ftl");
                    ctx.fail(500);
                });
        });

        // Dashboard (requires authentication)
        router.get("/dashboard").handler(ctx -> {
            logger.info("📄 GET /dashboard - Rendering dashboard");
            // TODO: Add authentication check
            templateEngine.render(ctx.data(), "templates/dashboard.ftl")
                .onSuccess(buffer -> {
                    logger.info("✅ Dashboard rendered successfully");
                    ctx.response()
                        .putHeader("Content-Type", "text/html")
                        .end(buffer);
                })
                .onFailure(err -> {
                    logger.error("❌ Dashboard rendering failed", err);
                    logger.error("Error details: {}", err.getMessage());
                    ctx.fail(500);
                });
        });

        // Admin dashboard (requires admin role)
        router.get("/admin").handler(ctx -> {
            // TODO: Add admin authentication check
            templateEngine.render(ctx.data(), "templates/admin/dashboard.ftl")
                .onSuccess(buffer -> ctx.response()
                    .putHeader("Content-Type", "text/html")
                    .end(buffer))
                .onFailure(err -> ctx.fail(500));
        });

        // Learning path detail page
        router.get("/learning/path/:pathId").handler(ctx -> {
            String pathId = ctx.pathParam("pathId");
            logger.info("📚 GET /learning/path/{} - Rendering learning path", pathId);
            
            // Add pathId to template context
            ctx.data().put("pathId", pathId);
            
            templateEngine.render(ctx.data(), "templates/learning-path.ftl")
                .onSuccess(buffer -> {
                    logger.info("✅ Learning path page rendered successfully");
                    ctx.response()
                        .putHeader("Content-Type", "text/html")
                        .end(buffer);
                })
                .onFailure(err -> {
                    logger.error("❌ Learning path page rendering failed", err);
                    ctx.fail(500);
                });
        });
        
        // Lesson detail page
        router.get("/lesson/:lessonId").handler(ctx -> {
            String lessonId = ctx.pathParam("lessonId");
            logger.info("📖 GET /lesson/{} - Rendering lesson", lessonId);
            
            // Add lessonId to template context
            ctx.data().put("lessonId", lessonId);
            
            templateEngine.render(ctx.data(), "templates/lesson.ftl")
                .onSuccess(buffer -> {
                    logger.info("✅ Lesson page rendered successfully");
                    ctx.response()
                        .putHeader("Content-Type", "text/html")
                        .end(buffer);
                })
                .onFailure(err -> {
                    logger.error("❌ Lesson page rendering failed", err);
                    ctx.fail(500);
                });
        });
        
        // Quiz taking page
        router.get("/quiz/:quizId").handler(ctx -> {
            String quizId = ctx.pathParam("quizId");
            logger.info("📝 GET /quiz/{} - Rendering quiz page", quizId);
            
            // Add quizId to template context
            ctx.data().put("quizId", quizId);
            
            templateEngine.render(ctx.data(), "templates/quiz.ftl")
                .onSuccess(buffer -> {
                    logger.info("✅ Quiz page rendered successfully");
                    ctx.response()
                        .putHeader("Content-Type", "text/html")
                        .end(buffer);
                })
                .onFailure(err -> {
                    logger.error("❌ Quiz page rendering failed", err);
                    ctx.fail(500);
                });
        });
    }

    /**
     * Setup API routes
     */
    private void setupApiRoutes(Router router) {
        // Health check
        router.get("/api/health").handler(ctx -> {
            ctx.response()
                .putHeader("Content-Type", "application/json")
                .end("{\"status\":\"UP\",\"service\":\"CyberSkill Platform\"}");
        });

        // ===== Authentication Routes (Public) =====
        router.post("/api/auth/register").handler(authHandler.register());
        router.post("/api/auth/login").handler(authHandler.login());
        router.post("/api/auth/refresh").handler(authHandler.refresh());
        router.post("/api/auth/logout").handler(authHandler.logout());
        
        // ===== Protected Authentication Routes =====
        router.post("/api/auth/change-password")
            .handler(authMiddleware.requireAuth())
            .handler(authHandler.changePassword());

        // ===== Learning Path Routes (Public - read only) =====
        router.get("/api/paths").handler(learningHandler.getAllPaths());
        router.get("/api/paths/:id").handler(learningHandler.getPathById());
        router.get("/api/paths/slug/:slug").handler(learningHandler.getPathBySlug());
        
        // ===== Module Routes (Public - read only) =====
        router.get("/api/paths/:pathId/modules").handler(moduleHandler.getModulesByPathId());
        router.get("/api/modules/:id").handler(moduleHandler.getModuleById());
        
        // ===== Section Routes (Public - read only) =====
        router.get("/api/modules/:moduleId/sections").handler(sectionHandler.getSectionsByModuleId());
        router.get("/api/sections/:id").handler(sectionHandler.getSectionById());
        
        // ===== Lesson Routes (Public - read only) =====
        router.get("/api/sections/:sectionId/lessons").handler(lessonHandler.getLessonsBySectionId());
        router.get("/api/lessons/:id").handler(lessonHandler.getLessonById());
        
        // ===== Quiz Routes (Public - read only) =====
        router.get("/api/sections/:sectionId/quizzes").handler(quizHandler::getQuizzesBySection);
        router.get("/api/quizzes/:id").handler(quizHandler::getQuizById);
        router.get("/api/quizzes/:id/full").handler(quizHandler::getQuizForTaking);
        
        // ===== Quiz Taking Routes (Protected) =====
        router.post("/api/quizzes/:id/start")
            .handler(authMiddleware.requireAuth())
            .handler(quizHandler::startQuizAttempt);
            
        router.post("/api/attempts/:attemptId/answers")
            .handler(authMiddleware.requireAuth())
            .handler(quizHandler::submitAnswer);
            
        router.post("/api/attempts/:attemptId/complete")
            .handler(authMiddleware.requireAuth())
            .handler(quizHandler::completeQuizAttempt);
            
        router.get("/api/attempts/:attemptId")
            .handler(authMiddleware.requireAuth())
            .handler(quizHandler::getAttemptDetails);
            
        router.get("/api/quizzes/:id/history")
            .handler(authMiddleware.requireAuth())
            .handler(quizHandler::getUserQuizHistory);
        
        // ===== Progress Tracking Routes (Protected) =====
        router.post("/api/progress/lessons/:lessonId/start")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::startLesson);
            
        router.post("/api/progress/lessons/:lessonId/complete")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::completeLesson);
            
        router.post("/api/progress/lessons/:lessonId/time")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::updateTimeSpent);
            
        router.get("/api/progress/lessons/:lessonId")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getLessonProgress);
            
        router.get("/api/progress")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getUserProgress);
            
        router.get("/api/progress/completed")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getCompletedLessons);
            
        router.get("/api/progress/sections/:sectionId")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getSectionProgress);
            
        router.get("/api/progress/modules/:moduleId")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getModuleProgress);
            
        router.get("/api/progress/paths/:pathId")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getPathProgress);
            
        router.get("/api/progress/statistics")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::getUserStatistics);
            
        router.delete("/api/progress/lessons/:lessonId")
            .handler(authMiddleware.requireAuth())
            .handler(progressHandler::resetLessonProgress);

        // ===== User Routes (Protected) =====
        router.get("/api/user/profile")
            .handler(authMiddleware.requireAuth())
            .handler(ctx -> {
                Integer userId = ctx.get("userId");
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end("{\"userId\":" + userId + ",\"message\":\"Profile endpoint\"}");
            });
        
        router.get("/api/user/progress")
            .handler(authMiddleware.requireAuth())
            .handler(ctx -> {
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end("{\"message\":\"Progress endpoint - to be implemented\"}");
            });
        
        // ===== Badge Routes (Protected) =====
        router.get("/api/user/badges")
            .handler(authMiddleware.requireAuth())
            .handler(badgeHandler::getUserBadges);
            
        router.get("/api/user/badges/count")
            .handler(authMiddleware.requireAuth())
            .handler(badgeHandler::getUserBadgeCount);
            
        router.get("/api/badges")
            .handler(badgeHandler::getAllBadges);
            
        router.get("/api/badges/:id")
            .handler(badgeHandler::getBadgeById);
        
        // ===== Certificate Routes (Protected) =====
        router.get("/api/user/certificates")
            .handler(authMiddleware.requireAuth())
            .handler(certificateHandler::getUserCertificates);
            
        router.get("/api/user/certificates/count")
            .handler(authMiddleware.requireAuth())
            .handler(certificateHandler::getUserCertificateCount);
            
        router.post("/api/certificates/generate")
            .handler(authMiddleware.requireAuth())
            .handler(certificateHandler::generateCertificate);
            
        router.get("/api/certificates/verify/:certificateNumber")
            .handler(certificateHandler::verifyCertificate);
            
        router.get("/api/certificates/:id")
            .handler(certificateHandler::getCertificateById);

        // ===== Admin Routes (Protected - Admin only) =====
        
        // Admin - Learning Path Management
        router.post("/api/admin/paths")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(learningHandler.createPath());
        
        router.put("/api/admin/paths/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(learningHandler.updatePath());
        
        router.delete("/api/admin/paths/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(learningHandler.deletePath());
        
        // Admin - Module Management
        router.get("/api/admin/modules")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(moduleHandler.getAllModules());
            
        router.post("/api/admin/modules")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(moduleHandler.createModule());
            
        router.put("/api/admin/modules/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(moduleHandler.updateModule());
            
        router.delete("/api/admin/modules/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(moduleHandler.deleteModule());
        
        // Admin - Section Management
        router.get("/api/admin/sections")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(sectionHandler.getAllSections());
            
        router.post("/api/admin/sections")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(sectionHandler.createSection());
            
        router.put("/api/admin/sections/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(sectionHandler.updateSection());
            
        router.delete("/api/admin/sections/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(sectionHandler.deleteSection());
        
        // Admin - Lesson Management
        router.get("/api/admin/lessons")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(lessonHandler.getAllLessons());
            
        router.post("/api/admin/lessons")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(lessonHandler.createLesson());
            
        router.put("/api/admin/lessons/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(lessonHandler.updateLesson());
            
        router.delete("/api/admin/lessons/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(lessonHandler.deleteLesson());
        
        // Admin - Quiz Management
        router.post("/api/admin/quizzes")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::createQuiz);
            
        router.put("/api/admin/quizzes/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::updateQuiz);
            
        router.delete("/api/admin/quizzes/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::deleteQuiz);
        
        // Admin - Question Management
        router.post("/api/admin/questions")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::createQuestion);
            
        router.put("/api/admin/questions/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::updateQuestion);
            
        router.delete("/api/admin/questions/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::deleteQuestion);
        
        // Admin - Answer Management
        router.post("/api/admin/answers")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::createAnswer);
            
        router.put("/api/admin/answers/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::updateAnswer);
            
        router.delete("/api/admin/answers/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(quizHandler::deleteAnswer);
        
        // Admin - User Management
        router.get("/api/admin/users")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(ctx -> {
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end("{\"message\":\"Admin users endpoint - to be implemented\"}");
            });
        
        // Admin - Badge Management
        router.post("/api/admin/badges")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(badgeHandler::createBadge);
            
        router.put("/api/admin/badges/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(badgeHandler::updateBadge);
            
        router.delete("/api/admin/badges/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(badgeHandler::deleteBadge);
            
        router.post("/api/admin/badges/:badgeId/award/:userId")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(badgeHandler::awardBadgeToUser);
            
        router.delete("/api/admin/badges/:badgeId/revoke/:userId")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(badgeHandler::revokeBadgeFromUser);
            
        router.get("/api/admin/badges/statistics")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(badgeHandler::getBadgeStatistics);
        
        // Admin - Certificate Management
        router.get("/api/admin/certificates/path/:pathId")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(certificateHandler::getPathCertificates);
            
        router.post("/api/admin/certificates/revoke/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(certificateHandler::revokeCertificate);
            
        router.post("/api/admin/certificates/regenerate/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(certificateHandler::regenerateCertificatePdf);
            
        router.delete("/api/admin/certificates/:id")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(certificateHandler::deleteCertificate);
            
        router.get("/api/admin/certificates/statistics")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(certificateHandler::getCertificateStatistics);
        
        // Admin - Analytics
        router.get("/api/admin/analytics/overview")
            .handler(authMiddleware.requireAuth())
            .handler(authMiddleware.requireAdmin())
            .handler(ctx -> {
                ctx.response()
                    .putHeader("Content-Type", "application/json")
                    .end("{\"message\":\"Analytics endpoint - to be implemented\"}");
            });
    }

    /**
     * Setup error handlers
     */
    private void setupErrorHandlers(Router router) {
        // 404 handler
        router.route().handler(ctx -> {
            ctx.response()
                .setStatusCode(404)
                .putHeader("Content-Type", "application/json")
                .end("{\"error\":\"Not Found\",\"path\":\"" + ctx.request().path() + "\"}");
        });

        // Global error handler
        router.errorHandler(500, ctx -> {
            logger.error("Internal server error", ctx.failure());
            ctx.response()
                .setStatusCode(500)
                .putHeader("Content-Type", "application/json")
                .end("{\"error\":\"Internal Server Error\"}");
        });
    }

    @Override
    public void stop(Promise<Void> stopPromise) {
        logger.info("Stopping CyberSkill Platform...");
        if (pgPool != null) {
            pgPool.close();
        }
        stopPromise.complete();
        logger.info("✓ CyberSkill Platform stopped");
    }

    public PgPool getPgPool() {
        return pgPool;
    }

    public FreeMarkerTemplateEngine getTemplateEngine() {
        return templateEngine;
    }

    public JwtUtil getJwtUtil() {
        return jwtUtil;
    }
}

// Made with Bob
