package com.demodepot;

import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.UUID;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.mindrot.jbcrypt.BCrypt;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.JWTOptions;
import io.vertx.ext.auth.PubSecKeyOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.auth.jwt.JWTAuthOptions;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.FileUpload;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.ext.web.handler.JWTAuthHandler;
import io.vertx.pgclient.PgPool;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.sqlclient.PoolOptions;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;


public class MainVerticle extends AbstractVerticle {

private static final Logger LOGGER = LogManager.getLogger(MainVerticle.class);
private static final String JWT_SECRET = "your-secret-key-change-in-production-min-256-bits-long";

private PgPool client;
private JWTAuth jwtAuth;
private MondayService mondayService;

@Override
public void start(Promise<Void> startPromise) {
	LOGGER.info("This is an MainVerticle 'INFO' TEST MESSAGE");
	LOGGER.debug("This is a MainVerticle 'DEBUG' TEST MESSAGE");
	LOGGER.warn("This is a MainVerticle 'WARN' TEST MESSAGE");
	LOGGER.error("This is an MainVerticle 'ERROR' TEST MESSAGE");
	
	// Initialize JWT Auth
	jwtAuth = JWTAuth.create(vertx, new JWTAuthOptions()
	    .addPubSecKey(new PubSecKeyOptions()
	        .setAlgorithm("HS256")
	        .setBuffer(JWT_SECRET)));
	
	// Initialize Monday.com service
	mondayService = new MondayService(vertx);
	
	PgConnectOptions connectOptions = new PgConnectOptions()
   .setHost(config().getString("db.host", "localhost"))
   .setPort(config().getInteger("db.port", 5432))
   .setDatabase(config().getString("db.database", "demodepot"))
   .setUser(config().getString("db.user", "postgres"))
   .setPassword(config().getString("db.password", "postgres"));

 PoolOptions poolOptions = new PoolOptions()
   .setMaxSize(config().getInteger("db.poolSize", 5));

 client = PgPool.pool(vertx, connectOptions, poolOptions);

 Router router = Router.router(vertx);
 
 // Body handler for API requests - must be before authentication
 router.route("/api/*").handler(BodyHandler.create().setUploadsDirectory("uploads"));
 
 // Root route
 router.get("/").handler(this::handleRoot);
 
 // Authentication routes (public)
 router.post("/api/signup").handler(this::handleSignup);
 router.post("/api/login").handler(this::handleLogin);
 
 // Public read-only dashboard API
 router.get("/api/demo-requests/public").handler(this::handleGetPublicDemoRequests);
 
 // Protected routes - require JWT authentication
 JWTAuthHandler jwtHandler = JWTAuthHandler.create(jwtAuth);
 
 // User routes (authenticated users)
 router.get("/api/demo-requests").handler(jwtHandler).handler(this::handleGetUserDemoRequests);
 router.get("/api/demo-requests/:id").handler(jwtHandler).handler(this::handleGetSingleDemoRequest);
 router.post("/api/create-demo-requests").handler(jwtHandler).handler(this::handleCreateDemoRequest);
 router.post("/api/demo-requests/draft").handler(jwtHandler).handler(this::handleSaveDraft);
 router.put("/api/demo-requests/draft/:id").handler(jwtHandler).handler(this::handleUpdateDraft);
 router.get("/api/demo-requests/draft/:id").handler(jwtHandler).handler(this::handleGetDraft);
 router.put("/api/demo-requests/:id").handler(jwtHandler).handler(this::handleUpdateDemoRequest);
 router.delete("/api/demo-requests/:id").handler(jwtHandler).handler(this::handleDeleteDemoRequest);
 
 // Admin-only routes
 router.put("/api/demo-requests/:id/status").handler(jwtHandler).handler(this::handleUpdateStatus);
 router.get("/api/admin/demo-requests").handler(jwtHandler).handler(this::handleGetAllDemoRequests);
 
 // File uploads
 router.get("/uploads/:filename").handler(rc -> {
   String filename = rc.pathParam("filename");
   Path filePath = Path.of("uploads").resolve(filename);
   rc.response().sendFile(filePath.toString())
     .onFailure(err -> rc.response().setStatusCode(404).end("File not found"));
 });
 
 // Serve static files (HTML, CSS, JS) - MUST be last
 router.route().handler(StaticHandler.create("webroot"));

 int port = config().getInteger("http.port", 9999);
 vertx.createHttpServer()
   .requestHandler(router)
   .listen(port)
   .onSuccess(s -> {
     LOGGER.info("HTTP server started on port " + port);
     startPromise.complete();
   })
   .onFailure(startPromise::fail);
}

private void handleRoot(RoutingContext rc) {
    rc.response()
      .putHeader("content-type", "text/plain")
      .end("Hello from Vert.x HTTP server!");
  }

private void handleGetDraft(RoutingContext rc) {
    JsonObject user = getUserFromToken(rc);
    int userId = user.getInteger("userId");
    
    String idParam = rc.pathParam("id");
    if (idParam == null) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Draft ID required").encode());
        return;
    }

    int draftId;
    try {
        draftId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Invalid draft ID").encode());
        return;
    }

    String sql = "SELECT * FROM demo_requests WHERE id=$1 AND user_id=$2 AND status='draft'";
    client.preparedQuery(sql).execute(Tuple.of(draftId, userId), ar -> {
        if (ar.succeeded() && ar.result().size() > 0) {
            Row row = ar.result().iterator().next();
            JsonObject draft = rowToJson(row, true);
            rc.response().putHeader("content-type", "application/json")
                .end(draft.encode());
        } else {
            rc.response().setStatusCode(404)
                .end(new JsonObject().put("error", "Draft not found or not authorized").encode());
        }
    });
}

private void handleSaveDraft(RoutingContext rc) {
	String requestId = UUID.randomUUID().toString();
	JsonObject user = getUserFromToken(rc);
	int userId = user.getInteger("userId");
    JsonObject body = rc.body().asJsonObject();
    LOGGER.debug("[{}] Raw body: {} " ,requestId, rc.getBodyAsString());
    LOGGER.info("Parsed JSON: " + body);
    if (body == null) {
        LOGGER.warn("[{}] No JSON body provided", requestId);
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Expected JSON body").encode());
        return;
    }
    String pmOwner;
    
    String demoType;
    String productName;
    String deliveryDate;
    String title;
    String subtitle;
    String valueProp;
    String featureFocus;
    String flowSequence;
    String demoUrl;
    String existingDocsPath = null;
    String demoScriptPath = null;

    if (body != null) {
        LOGGER.info("handleSaveDraft: Received JSON body");

        pmOwner = body.getString("pm_owner");
        LOGGER.info("[{}] Draft owner: {}", requestId, pmOwner);
        demoType = body.getString("demo_type");
        LOGGER.info("[{}] Draft owner: {}", requestId, pmOwner);
        productName = body.getString("product_name");
        LOGGER.info("[{}] Draft owner: {}", requestId, pmOwner);
        deliveryDate = body.getString("delivery_date");
        LOGGER.info("[{}] Draft owner: {}", requestId, pmOwner);
        title = body.getString("title");
        LOGGER.info("[{}] Draft owner: {}", requestId, pmOwner);
        subtitle = body.getString("subtitle", ""); // default empty
        valueProp = body.getString("value_proposition");
        featureFocus = body.getString("feature_focus");
        flowSequence = body.getString("flow_sequence");
        demoUrl = body.getString("demo_url", ""); // default empty
        existingDocsPath = body.getString("existing_docs_path", null);
        demoScriptPath = body.getString("demo_script_path", null);
        if (pmOwner == null || pmOwner.isBlank() ||
        	    demoType == null || demoType.isBlank() ||
        	    productName == null || productName.isBlank() ||
        	    deliveryDate == null || deliveryDate.isBlank() ||
        	    title == null || title.isBlank() ||
        	    valueProp == null || valueProp.isBlank() ||
        	    featureFocus == null || featureFocus.isBlank() ||
        	    flowSequence == null || flowSequence.isBlank()) {
        	    rc.response().setStatusCode(400)
        	        .end(new JsonObject().put("error", "Missing required fields").encode());
        	    return;
        	}


    } else {
        LOGGER.info("handleSaveDraft: Received multipart form-data");

        pmOwner = rc.request().getFormAttribute("pm_owner");
        demoType = rc.request().getFormAttribute("demo_type");
        productName = rc.request().getFormAttribute("product_name");
        deliveryDate = rc.request().getFormAttribute("delivery_date");
        title = rc.request().getFormAttribute("title");
        subtitle = rc.request().getFormAttribute("subtitle");
        valueProp = rc.request().getFormAttribute("value_proposition");
        featureFocus = rc.request().getFormAttribute("feature_focus");
        flowSequence = rc.request().getFormAttribute("flow_sequence");
        demoUrl = rc.request().getFormAttribute("demo_url");
        if (pmOwner == null || pmOwner.isBlank() ||
        	    demoType == null || demoType.isBlank() ||
        	    productName == null || productName.isBlank() ||
        	    deliveryDate == null || deliveryDate.isBlank() ||
        	    title == null || title.isBlank() ||
        	    valueProp == null || valueProp.isBlank() ||
        	    featureFocus == null || featureFocus.isBlank() ||
        	    flowSequence == null || flowSequence.isBlank()) {
        	    rc.response().setStatusCode(400)
        	        .end(new JsonObject().put("error", "Missing required fields").encode());
        	    return;
        	}

        for (FileUpload upload : rc.fileUploads()) {
            String originalName = upload.fileName();
            LOGGER.info("handleSaveDraft: Got upload field=" + upload.name() + " originalName=" + originalName);

            Path uploadDir = Path.of("webroot", "uploads");
            try {
                Files.createDirectories(uploadDir);
                Path dest = uploadDir.resolve(originalName);
                Files.move(Path.of(upload.uploadedFileName()), dest, StandardCopyOption.REPLACE_EXISTING);

                if ("existing_docs".equals(upload.name())) {
                    existingDocsPath = originalName;
                } else if ("demo_script".equals(upload.name())) {
                    demoScriptPath = originalName;
                }
            } catch (Exception e) {
                rc.response().setStatusCode(500)
                    .end(new JsonObject().put("error", "File move failed: " + e.getMessage()).encode());
                return;
            }
        }
    }



    // Parse date safely
    LocalDate parsedDate = null;
    try {
        parsedDate = LocalDate.parse(deliveryDate);
    } catch (Exception e) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Invalid delivery_date format, expected YYYY-MM-DD").encode());
        return;
    }

    // Insert into DB with user_id
    String sql = "INSERT INTO demo_requests " +
        "(user_id, pm_owner, demo_type, product_name, delivery_date, title, subtitle, " +
        "value_proposition, feature_focus, flow_sequence, existing_docs_path, demo_url, demo_script_path, status, created_at) " +
        "VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,'draft',NOW()) RETURNING id";

    Tuple params = Tuple.of(
        userId,
        pmOwner,
        demoType,
        productName,
        parsedDate,
        title,
        subtitle,
        valueProp,
        featureFocus,
        flowSequence,
        existingDocsPath,
        demoUrl,
        demoScriptPath
    );

    client.preparedQuery(sql).execute(params, ar -> {
        if (ar.succeeded()) {
            int id = ar.result().iterator().next().getInteger("id");
            rc.response().putHeader("content-type", "application/json")
                .setStatusCode(201)
                .end(new JsonObject().put("id", id).put("status", "draft saved").encode());
        } else {
            rc.response().setStatusCode(500)
                .end(new JsonObject().put("error", ar.cause().getMessage()).encode());
        }
    });
}


private void handleUpdateDraft(RoutingContext rc) {
    JsonObject user = getUserFromToken(rc);
    int userId = user.getInteger("userId");
    
    String idParam = rc.pathParam("id");
    if (idParam == null) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Draft ID is required in path").encode());
        return;
    }

    int draftId;
    try {
        draftId = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Invalid draft ID").encode());
        return;
    }

    JsonObject body = rc.body().asJsonObject();
    LOGGER.info("Raw body string: " + rc.getBodyAsString());
    LOGGER.info("Parsed JSON: " + body);

    if (body == null) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Expected JSON body").encode());
        return;
    }

    // Extract fields
    String pmOwner = body.getString("pm_owner");
    String demoType = body.getString("demo_type");
    String productName = body.getString("product_name");
    String deliveryDate = body.getString("delivery_date");
    String title = body.getString("title");
    String subtitle = body.getString("subtitle", "");
    String valueProp = body.getString("value_proposition");
    String featureFocus = body.getString("feature_focus");
    String flowSequence = body.getString("flow_sequence");
    String demoUrl = body.getString("demo_url", "");
    String existingDocsPath = body.getString("existing_docs_path", null);
    String demoScriptPath = body.getString("demo_script_path", null);

    // Validate required fields
    if (pmOwner == null || pmOwner.isBlank() ||
        demoType == null || demoType.isBlank() ||
        productName == null || productName.isBlank() ||
        deliveryDate == null || deliveryDate.isBlank() ||
        title == null || title.isBlank() ||
        valueProp == null || valueProp.isBlank() ||
        featureFocus == null || featureFocus.isBlank() ||
        flowSequence == null || flowSequence.isBlank()) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Missing required fields").encode());
        return;
    }

    // Parse date safely
    LocalDate parsedDate = null;
    try {
        parsedDate = LocalDate.parse(deliveryDate);
    } catch (Exception e) {
        rc.response().setStatusCode(400)
            .end(new JsonObject().put("error", "Invalid delivery_date format, expected YYYY-MM-DD").encode());
        return;
    }

    // Build SQL update - verify user ownership
    String sql = "UPDATE demo_requests SET " +
        "pm_owner=$1, demo_type=$2, product_name=$3, delivery_date=$4, " +
        "title=$5, subtitle=$6, value_proposition=$7, feature_focus=$8, " +
        "flow_sequence=$9, existing_docs_path=$10, demo_url=$11, demo_script_path=$12, " +
        "status='draft', updated_at=NOW() WHERE id=$13 AND user_id=$14 RETURNING id";

    Tuple params = Tuple.of(
        pmOwner,
        demoType,
        productName,
        parsedDate,
        title,
        subtitle,
        valueProp,
        featureFocus,
        flowSequence,
        existingDocsPath,
        demoUrl,
        demoScriptPath,
        draftId,
        userId
    );

    client.preparedQuery(sql).execute(params, ar -> {
        if (ar.succeeded()) {
            if (ar.result().size() == 0) {
                rc.response().setStatusCode(404)
                    .end(new JsonObject().put("error", "Draft not found or not authorized").encode());
            } else {
                int id = ar.result().iterator().next().getInteger("id");
                rc.response().putHeader("content-type", "application/json")
                    .setStatusCode(200)
                    .end(new JsonObject().put("id", id).put("status", "draft updated").encode());
            }
        } else {
            rc.response().setStatusCode(500)
                .end(new JsonObject().put("error", ar.cause().getMessage()).encode());
        }
    });
}




private void handleCreateDemoRequest(RoutingContext rc) {
	String requestId = UUID.randomUUID().toString();
	JsonObject user = getUserFromToken(rc);
	int userId = user.getInteger("userId");
	String userEmail = user.getString("email");
    
	  // Form fields
	  String pmOwner = rc.request().getFormAttribute("pm_owner");
	  LOGGER.info("[{}] Demo owner: {}", requestId, pmOwner);
	  String demoType = rc.request().getFormAttribute("demo_type");
	  LOGGER.info("[{}] Demo type: {}", requestId, demoType);
	  String productName = rc.request().getFormAttribute("product_name");
	  LOGGER.info("[{}] Demo productName: {}", requestId, productName);
	  String deliveryDate = rc.request().getFormAttribute("delivery_date");
	  LOGGER.info("[{}] Demo deliveryDate: {}", requestId, deliveryDate);
	  String title = rc.request().getFormAttribute("title");
	  LOGGER.info("[{}] Demo title: {}", requestId, title);
	  String subtitle = rc.request().getFormAttribute("subtitle");
	  LOGGER.info("[{}] Demo subtitle: {}", requestId, subtitle);
	  String valueProp = rc.request().getFormAttribute("value_proposition");
	  LOGGER.info("[{}] Demo valueProp: {}", requestId, valueProp);
	  String featureFocus = rc.request().getFormAttribute("feature_focus");
	  LOGGER.info("[{}] Demo featureFocus: {}", requestId, featureFocus);
	  String flowSequence = rc.request().getFormAttribute("flow_sequence");
	  LOGGER.info("[{}] Demo flowSequence: {}", requestId, flowSequence);
	  String demoUrl = rc.request().getFormAttribute("demo_url");
	  LOGGER.info("[{}] Demo demoUrl: {}", requestId, demoUrl);
	  String requesterEmail = rc.request().getFormAttribute("requester_email");
	  LOGGER.info("[{}] Requester email: {}", requestId, requesterEmail);
	  String statusParam = rc.request().getFormAttribute("status");
	  final String status = (statusParam == null || statusParam.isEmpty()) ? "submitted" : statusParam;
	  LOGGER.info("[{}] Demo status: {}", requestId, status);

	  // Use array to make variables effectively final for lambda
	  final String[] filePaths = new String[2]; // [0] = existingDocs, [1] = demoScript

	  for (FileUpload upload : rc.fileUploads()) {
	   try {
	    // Skip empty file uploads
	    if (upload.size() == 0) {
	        LOGGER.info("Skipping empty file upload: " + upload.name());
	        continue;
	    }
	    
	    // Permanent folder inside webroot
	    Path uploadDir = Path.of("src", "main", "resources", "webroot", "uploads");
	    
	    // Create directory if it doesn't exist, or if it exists as a file, handle it
	    if (!Files.exists(uploadDir)) {
	        Files.createDirectories(uploadDir);
	    } else if (!Files.isDirectory(uploadDir)) {
	        LOGGER.error("Upload path exists but is not a directory: " + uploadDir);
	        throw new IOException("Upload path is not a directory: " + uploadDir);
	    }

	     // Original filename from the browser
	     String originalName = upload.fileName();
	     LOGGER.info("Saving file with original name: " + originalName);

	     // Destination path (uploads/<originalName>)
	     Path dest = uploadDir.resolve(originalName);

	     // Move file from temp to permanent
	     Files.move(Path.of(upload.uploadedFileName()), dest, StandardCopyOption.REPLACE_EXISTING);

	     // Store original filename in array
	     if ("existing_docs".equals(upload.name())) {
	       filePaths[0] = originalName;
	     } else if ("demo_script".equals(upload.name())) {
	       filePaths[1] = originalName;
	     }

	   } catch (Exception e) {
	     LOGGER.error("File upload error for field " + upload.name() + ": " + e.getMessage(), e);
	     // Don't fail the entire request for file upload errors - just log and continue
	     // Files are optional, so we can still create the demo request
	   }
	 }
	 
	 String existingDocsPath = filePaths[0];
	 String demoScriptPath = filePaths[1];


	  // Insert into DB with user_id and requester_email
	  String sql = "INSERT INTO demo_requests " +
			  "(user_id, pm_owner, demo_type, product_name, delivery_date, title, subtitle, value_proposition, feature_focus, flow_sequence, existing_docs_path, demo_url, demo_script_path, requester_email, status, created_at) " +
			  "VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,NOW()) RETURNING id";

		Tuple params = Tuple.of(
		  userId,
		  pmOwner,
		  demoType,
		  productName,
		  deliveryDate != null ? java.time.LocalDate.parse(deliveryDate) : null,
		  title,
		  subtitle,
		  valueProp,
		  featureFocus,
		  flowSequence,
		  existingDocsPath,
		  demoUrl,
		  demoScriptPath,
		  requesterEmail != null ? requesterEmail : userEmail, // Use form email or fallback to user's email
		  status // Use status from form (draft or submitted)
		);


	  client.preparedQuery(sql).execute(params, ar -> {
	    if (ar.succeeded()) {
	      int id = ar.result().iterator().next().getInteger("id");
	      
	      // Create Monday.com task if status is submitted (not draft)
	      if ("submitted".equals(status)) {
	          JsonObject demoData = new JsonObject()
	              .put("demo_name", title)
	              .put("demo_date", deliveryDate)
	              .put("demo_type", demoType)
	              .put("status", "pending");
	          
	          mondayService.createTask(demoData)
	              .onSuccess(result -> {
	                  LOGGER.info("[{}] Monday.com task created successfully", requestId);
	                  
	                  // Upload demo_script file if it exists
	                  if (filePaths[1] != null && !filePaths[1].isEmpty()) {
	                      String itemId = result.getJsonObject("data")
	                          .getJsonObject("create_item")
	                          .getString("id");
	                      
	                      if (itemId != null) {
	                          String fullPath = "src/main/resources/webroot/uploads/" + filePaths[1];
	                          mondayService.uploadFile(itemId, fullPath, mondayService.getFilesColumnId())
	                              .onSuccess(uploadResult -> {
	                                  LOGGER.info("[{}] File uploaded to Monday.com: {}", requestId, filePaths[1]);
	                              })
	                              .onFailure(uploadErr -> {
	                                  LOGGER.warn("[{}] Failed to upload file to Monday.com: {}", requestId, uploadErr.getMessage());
	                              });
	                      }
	                  }
	              })
	              .onFailure(err -> {
	                  LOGGER.error("[{}] Failed to create Monday.com task: {}", requestId, err.getMessage());
	                  // Don't fail the request if Monday.com integration fails
	              });
	      }
	      
	      rc.response().putHeader("content-type", "application/json")
	        .setStatusCode(201)
	        .end(new JsonObject().put("id", id).put("status", "created").encode());
	    } else {
	      rc.response().setStatusCode(500).end(new JsonObject().put("error", ar.cause().getMessage()).encode());
	    }
	  });
	}



private void handleUpdateStatus(RoutingContext rc) {
	  // Only admins can update status
	  if (!isAdmin(rc)) {
	      rc.response().setStatusCode(403)
	          .end(new JsonObject().put("error", "Admin access required").encode());
	      return;
	  }
	  
	  int id = Integer.parseInt(rc.pathParam("id"));
	  JsonObject body = rc.body().asJsonObject();
	  String newStatus = body.getString("status");

	  String sql = "UPDATE demo_requests SET status=$1, updated_at=NOW() WHERE id=$2 RETURNING id";

	  client.preparedQuery(sql).execute(Tuple.of(newStatus, id), ar -> {
	    if (ar.succeeded() && ar.result().size() > 0) {
	      rc.response().putHeader("content-type", "application/json")
	        .end(new JsonObject().put("id", id).put("status", newStatus).encode());
	    } else {
	      rc.response().setStatusCode(404).end(new JsonObject().put("error", "Demo not found").encode());
	    }
	  });
	}

// Authentication handlers
private void handleSignup(RoutingContext rc) {
    LOGGER.info("=== SIGNUP REQUEST ===");
    JsonObject body = rc.body().asJsonObject();
    if (body == null) {
        LOGGER.warn("Signup failed: No JSON body provided");
        rc.response().setStatusCode(400)
            .end(new JsonObject()
                .put("error", "Expected JSON body")
                .put("message", "Please provide all required fields")
                .encode());
        return;
    }

    String username = body.getString("username");
    String password = body.getString("password");
    String email = body.getString("email");
    String fullName = body.getString("full_name");
    
    LOGGER.info("Signup attempt - username: {}, email: {}, name: {}", username, email, fullName);
    LOGGER.debug("Password length: {}", password != null ? password.length() : 0);

    if (username == null || username.isBlank() ||
        password == null || password.length() < 8 ||
        email == null || email.isBlank()) {
        LOGGER.warn("Signup validation failed");
        rc.response().setStatusCode(400)
            .end(new JsonObject()
                .put("error", "Invalid input")
                .put("message", "Username, email, and password (min 8 chars) are required")
                .encode());
        return;
    }

    // Hash password with BCrypt
    LOGGER.debug("Hashing password with BCrypt...");
    String passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());
    LOGGER.debug("Password hashed successfully, hash length: {}", passwordHash.length());

    String sql = "INSERT INTO users (username, password_hash, email, full_name, role) " +
                 "VALUES ($1, $2, $3, $4, 'user') RETURNING id, username, email, full_name, role";
    client.preparedQuery(sql).execute(Tuple.of(username, passwordHash, email, fullName), ar -> {
        if (ar.succeeded() && ar.result().size() > 0) {
            Row row = ar.result().iterator().next();
            int userId = row.getInteger("id");
            String role = row.getString("role");
            String userEmail = row.getString("email");
            String userName = row.getString("full_name");
            
            LOGGER.info("User created successfully: {} (ID: {}, Email: {}, Role: {})", username, userId, userEmail, role);

            // Generate JWT token with email and full_name
            String token = jwtAuth.generateToken(
                new JsonObject()
                    .put("sub", username)
                    .put("userId", userId)
                    .put("role", role)
                    .put("email", userEmail)
                    .put("fullName", userName),
                new JWTOptions().setExpiresInMinutes(60 * 24 * 7) // 7 days
            );
            
            LOGGER.info("JWT token generated for user: {}", username);

            rc.response().putHeader("content-type", "application/json")
                .end(new JsonObject()
                    .put("token", token)
                    .put("username", username)
                    .put("email", userEmail)
                    .put("fullName", userName)
                    .put("role", role)
                    .put("message", "Account created successfully")
                    .encode());
        } else {
            LOGGER.warn("Signup failed: Username or email already exists");
            rc.response().setStatusCode(409)
                .end(new JsonObject()
                    .put("error", "User already exists")
                    .put("message", "This username or email is already registered. Please login instead.")
                    .encode());
        }
    });
}

private void handleLogin(RoutingContext rc) {
    LOGGER.info("=== LOGIN REQUEST ===");
    JsonObject body = rc.body().asJsonObject();
    if (body == null) {
        LOGGER.warn("Login failed: No JSON body provided");
        rc.response().setStatusCode(400)
            .end(new JsonObject()
                .put("error", "Expected JSON body")
                .put("message", "Please provide username and password")
                .encode());
        return;
    }

    String username = body.getString("username");
    String password = body.getString("password");
    
    LOGGER.info("Login attempt for username: {}", username);

    if (username == null || password == null) {
        LOGGER.warn("Login validation failed: Missing credentials");
        rc.response().setStatusCode(400)
            .end(new JsonObject()
                .put("error", "Username and password required")
                .put("message", "Both username and password are required")
                .encode());
        return;
    }

    String sql = "SELECT id, username, password_hash, email, full_name, role FROM users WHERE username = $1";
    client.preparedQuery(sql).execute(Tuple.of(username), ar -> {
        if (ar.succeeded() && ar.result().size() > 0) {
            Row row = ar.result().iterator().next();
            String storedHash = row.getString("password_hash");
            
            LOGGER.debug("User found in database: {}", username);
            LOGGER.debug("Password length: {}", password != null ? password.length() : 0);
            LOGGER.debug("Stored hash length: {}", storedHash != null ? storedHash.length() : 0);
            
            try {
                boolean passwordMatches = BCrypt.checkpw(password, storedHash);
                LOGGER.info("Password verification result for {}: {}", username, passwordMatches);
                
                if (storedHash != null && passwordMatches) {
                    int userId = row.getInteger("id");
                    String role = row.getString("role");
                    String email = row.getString("email");
                    String fullName = row.getString("full_name");
                    
                    LOGGER.info("✓ Login successful - User: {}, Email: {}, Role: {}, ID: {}", username, email, role, userId);

                    // Generate JWT token with email and full_name
                    String token = jwtAuth.generateToken(
                        new JsonObject()
                            .put("sub", username)
                            .put("userId", userId)
                            .put("role", role)
                            .put("email", email)
                            .put("fullName", fullName),
                        new JWTOptions().setExpiresInMinutes(60 * 24 * 7) // 7 days
                    );
                    
                    LOGGER.info("JWT token generated for user: {}", username);

                    rc.response().putHeader("content-type", "application/json")
                        .end(new JsonObject()
                            .put("token", token)
                            .put("username", username)
                            .put("email", email)
                            .put("fullName", fullName)
                            .put("role", role)
                            .put("message", "Login successful")
                            .encode());
                } else {
                    LOGGER.warn("✗ Login failed for user: {} - Invalid password", username);
                    rc.response().setStatusCode(401)
                        .end(new JsonObject()
                            .put("error", "Invalid credentials")
                            .put("message", "Username or password is incorrect")
                            .encode());
                }
            } catch (Exception e) {
                LOGGER.error("✗ Error checking password for user: {}", username, e);
                rc.response().setStatusCode(401)
                    .end(new JsonObject()
                        .put("error", "Invalid credentials")
                        .put("message", "Authentication failed")
                        .encode());
            }
        } else {
            LOGGER.warn("✗ Login failed - User not found: {}", username);
            rc.response().setStatusCode(401)
                .end(new JsonObject()
                    .put("error", "Invalid credentials")
                    .put("message", "Username or password is incorrect")
                    .encode());
        }
    });
}

// Helper to extract user info from JWT
private JsonObject getUserFromToken(RoutingContext rc) {
    return rc.user().principal();
}

private boolean isAdmin(RoutingContext rc) {
    JsonObject user = getUserFromToken(rc);
    return "admin".equals(user.getString("role"));
}

// Public read-only dashboard
private void handleGetPublicDemoRequests(RoutingContext rc) {
    String sql = "SELECT dr.id, dr.pm_owner, dr.demo_type, dr.product_name, dr.delivery_date, " +
                 "dr.title, dr.subtitle, dr.value_proposition, dr.feature_focus, dr.flow_sequence, " +
                 "dr.demo_url, dr.status, dr.created_at, dr.existing_docs_path, dr.demo_script_path " +
                 "FROM demo_requests dr ORDER BY dr.created_at DESC";
    
    client.query(sql).execute(ar -> {
        if (ar.succeeded()) {
            RowSet<Row> rows = ar.result();
            JsonArray arr = new JsonArray();
            for (Row row : rows) {
                arr.add(rowToJson(row, true)); // true = include file paths
            }
            rc.response()
                .putHeader("content-type", "application/json")
                .end(new JsonObject().put("demo_requests", arr).encodePrettily());
        } else {
            rc.response().setStatusCode(500)
                .end(new JsonObject().put("error", ar.cause().getMessage()).encode());
        }
    });
}

// User's own demo requests
private void handleGetUserDemoRequests(RoutingContext rc) {
    JsonObject user = getUserFromToken(rc);
    int userId = user.getInteger("userId");
    
    String sql = "SELECT * FROM demo_requests WHERE user_id = $1 ORDER BY created_at DESC";
    client.preparedQuery(sql).execute(Tuple.of(userId), ar -> {
        if (ar.succeeded()) {
            RowSet<Row> rows = ar.result();
            JsonArray arr = new JsonArray();
            for (Row row : rows) {
                arr.add(rowToJson(row, true)); // true = include file paths
            }
            rc.response()
                .putHeader("content-type", "application/json")
                .end(new JsonObject().put("demo_requests", arr).encodePrettily());
        } else {
            rc.response().setStatusCode(500)
                .end(new JsonObject().put("error", ar.cause().getMessage()).encode());
        }
    });
}

// Get single demo request (user can only get their own)
private void handleGetSingleDemoRequest(RoutingContext rc) {
    JsonObject user = getUserFromToken(rc);
    int userId = user.getInteger("userId");
    int requestId = Integer.parseInt(rc.pathParam("id"));
    
    LOGGER.info("[Get Single] User {} requesting demo request {}", userId, requestId);
    
    String sql = "SELECT * FROM demo_requests WHERE id = $1 AND user_id = $2";
    client.preparedQuery(sql).execute(Tuple.of(requestId, userId), ar -> {
        if (ar.succeeded() && ar.result().size() > 0) {
            Row row = ar.result().iterator().next();
            JsonObject demoRequest = rowToJson(row, true); // true = include file paths
            LOGGER.info("[Get Single] Found demo request: {}", requestId);
            rc.response()
                .putHeader("content-type", "application/json")
                .end(new JsonObject().put("demo_request", demoRequest).encodePrettily());
        } else {
            LOGGER.warn("[Get Single] Demo request {} not found or not authorized for user {}", requestId, userId);
            rc.response().setStatusCode(404)
                .end(new JsonObject().put("error", "Demo request not found or not authorized").encode());
        }
    });
}

// Admin: get all demo requests
private void handleGetAllDemoRequests(RoutingContext rc) {
    if (!isAdmin(rc)) {
        rc.response().setStatusCode(403)
            .end(new JsonObject().put("error", "Admin access required").encode());
        return;
    }
    
    String sql = "SELECT dr.*, u.username FROM demo_requests dr " +
                 "LEFT JOIN users u ON dr.user_id = u.id ORDER BY dr.created_at DESC";
    client.query(sql).execute(ar -> {
        if (ar.succeeded()) {
            RowSet<Row> rows = ar.result();
            JsonArray arr = new JsonArray();
            for (Row row : rows) {
                JsonObject obj = rowToJson(row, true);
                obj.put("username", row.getString("username"));
                arr.add(obj);
            }
            rc.response()
                .putHeader("content-type", "application/json")
                .end(new JsonObject().put("demo_requests", arr).encodePrettily());
        } else {
            rc.response().setStatusCode(500)
                .end(new JsonObject().put("error", ar.cause().getMessage()).encode());
        }
    });
}

// Helper method to convert row to JSON
private JsonObject rowToJson(Row row, boolean includeFiles) {
    JsonObject obj = new JsonObject()
        .put("id", row.getInteger("id"))
        .put("pm_owner", row.getString("pm_owner"))
        .put("demo_type", row.getString("demo_type"))
        .put("product_name", row.getString("product_name"))
        .put("delivery_date", row.getLocalDate("delivery_date") != null ?
            row.getLocalDate("delivery_date").toString() : null)
        .put("title", row.getString("title"))
        .put("subtitle", row.getString("subtitle"))
        .put("value_proposition", row.getString("value_proposition"))
        .put("feature_focus", row.getString("feature_focus"))
        .put("flow_sequence", row.getString("flow_sequence"))
        .put("demo_url", row.getString("demo_url"))
        .put("status", row.getString("status"))
        .put("created_at", row.getOffsetDateTime("created_at") != null ?
            row.getOffsetDateTime("created_at").toString() : null);
    
    if (includeFiles) {
        obj.put("existing_docs_path", row.getString("existing_docs_path"))
           .put("demo_script_path", row.getString("demo_script_path"));
    }
    
    return obj;
}

// Update demo request (user can only update their own) - supports FormData with file uploads
private void handleUpdateDemoRequest(RoutingContext rc) {
    String requestId = rc.pathParam("id");
    JsonObject user = getUserFromToken(rc);
    int userId = user.getInteger("userId");
    String userEmail = user.getString("email");
    
    LOGGER.info("[Update] Updating demo request ID: {} by user: {}", requestId, userId);
    
    // Verify ownership first
    String checkSql = "SELECT user_id FROM demo_requests WHERE id = $1";
    client.preparedQuery(checkSql).execute(Tuple.of(Integer.parseInt(requestId)), checkAr -> {
        if (checkAr.succeeded() && checkAr.result().size() > 0) {
            int ownerId = checkAr.result().iterator().next().getInteger("user_id");
            if (ownerId != userId) {
                LOGGER.warn("[Update] User {} not authorized to update request {}", userId, requestId);
                rc.response().setStatusCode(403)
                    .end(new JsonObject().put("error", "Not authorized").encode());
                return;
            }
            
            // Extract form fields
            String pmOwner = rc.request().getFormAttribute("pm_owner");
            String demoType = rc.request().getFormAttribute("demo_type");
            String productName = rc.request().getFormAttribute("product_name");
            String deliveryDate = rc.request().getFormAttribute("delivery_date");
            String title = rc.request().getFormAttribute("title");
            String subtitle = rc.request().getFormAttribute("subtitle");
            String valueProp = rc.request().getFormAttribute("value_proposition");
            String featureFocus = rc.request().getFormAttribute("feature_focus");
            String flowSequence = rc.request().getFormAttribute("flow_sequence");
            String demoUrl = rc.request().getFormAttribute("demo_url");
            String requesterEmail = rc.request().getFormAttribute("requester_email");
            String status = rc.request().getFormAttribute("status");
            if (status == null || status.isEmpty()) {
                status = "submitted"; // Default if not specified
            }
            
            // Handle file uploads (optional)
            String existingDocsPath = null;
            String demoScriptPath = null;
            
            for (FileUpload upload : rc.fileUploads()) {
                try {
                    if (upload.size() == 0) {
                        LOGGER.info("[Update] Skipping empty file upload: " + upload.name());
                        continue;
                    }
                    
                    Path uploadDir = Path.of("src", "main", "resources", "webroot", "uploads");
                    if (!Files.exists(uploadDir)) {
                        Files.createDirectories(uploadDir);
                    } else if (!Files.isDirectory(uploadDir)) {
                        LOGGER.error("[Update] Upload path exists but is not a directory: " + uploadDir);
                        throw new IOException("Upload path is not a directory: " + uploadDir);
                    }
                    
                    String originalName = upload.fileName();
                    Path dest = uploadDir.resolve(originalName);
                    Files.move(Path.of(upload.uploadedFileName()), dest, StandardCopyOption.REPLACE_EXISTING);
                    
                    if ("existing_docs".equals(upload.name())) {
                        existingDocsPath = originalName;
                    } else if ("demo_script".equals(upload.name())) {
                        demoScriptPath = originalName;
                    }
                } catch (Exception e) {
                    LOGGER.error("[Update] File upload error for field " + upload.name() + ": " + e.getMessage(), e);
                }
            }
            
            // Build UPDATE SQL - only update file paths if new files were uploaded
            StringBuilder updateSql = new StringBuilder("UPDATE demo_requests SET " +
                "pm_owner=$1, demo_type=$2, product_name=$3, delivery_date=$4, " +
                "title=$5, subtitle=$6, value_proposition=$7, feature_focus=$8, " +
                "flow_sequence=$9, demo_url=$10, requester_email=$11, status=$12, updated_at=NOW()");
            
            int paramIndex = 13;
            if (existingDocsPath != null) {
                updateSql.append(", existing_docs_path=$").append(paramIndex++);
            }
            if (demoScriptPath != null) {
                updateSql.append(", demo_script_path=$").append(paramIndex++);
            }
            updateSql.append(" WHERE id=$").append(paramIndex).append(" RETURNING id");
            
            // Build parameters tuple
            Tuple params = Tuple.of(
                pmOwner,
                demoType,
                productName,
                deliveryDate != null ? java.time.LocalDate.parse(deliveryDate) : null,
                title,
                subtitle,
                valueProp,
                featureFocus,
                flowSequence,
                demoUrl,
                requesterEmail != null ? requesterEmail : userEmail,
                status
            );
            
            if (existingDocsPath != null) {
                params.addString(existingDocsPath);
            }
            if (demoScriptPath != null) {
                params.addString(demoScriptPath);
            }
            params.addInteger(Integer.parseInt(requestId));
            
            LOGGER.info("[Update] Executing update SQL for request: {}", requestId);
            client.preparedQuery(updateSql.toString()).execute(params, ar -> {
                if (ar.succeeded()) {
                    LOGGER.info("[Update] Successfully updated request: {}", requestId);
                    rc.response().putHeader("content-type", "application/json")
                        .end(new JsonObject().put("id", Integer.parseInt(requestId)).put("status", "updated").encode());
                } else {
                    LOGGER.error("[Update] Failed to update request: " + ar.cause().getMessage(), ar.cause());
                    rc.response().setStatusCode(500)
                        .end(new JsonObject().put("error", ar.cause().getMessage()).encode());
                }
            });
        } else {
            LOGGER.warn("[Update] Demo request not found: {}", requestId);
            rc.response().setStatusCode(404)
                .end(new JsonObject().put("error", "Demo request not found").encode());
        }
    });
}

// Delete demo request (user can only delete their own)
private void handleDeleteDemoRequest(RoutingContext rc) {
    JsonObject user = getUserFromToken(rc);
    int userId = user.getInteger("userId");
    int requestId = Integer.parseInt(rc.pathParam("id"));
    
    String sql = "DELETE FROM demo_requests WHERE id = $1 AND user_id = $2 RETURNING id";
    client.preparedQuery(sql).execute(Tuple.of(requestId, userId), ar -> {
        if (ar.succeeded() && ar.result().size() > 0) {
            rc.response().putHeader("content-type", "application/json")
                .end(new JsonObject().put("status", "deleted").encode());
        } else {
            rc.response().setStatusCode(404)
                .end(new JsonObject().put("error", "Demo request not found or not authorized").encode());
        }
    });
}

@Override
public void stop() {
 if (client != null) client.close();
}
}
