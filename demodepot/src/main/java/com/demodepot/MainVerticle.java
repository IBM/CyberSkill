package com.demodepot;



import java.nio.file.Path;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.core.AbstractVerticle;
import io.vertx.core.Promise;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.pgclient.PgPool;
import io.vertx.sqlclient.PoolOptions;
import io.vertx.pgclient.PgConnectOptions;
import io.vertx.sqlclient.Row;
import io.vertx.sqlclient.RowSet;
import io.vertx.sqlclient.Tuple;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.ext.web.FileUpload;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.time.LocalDate;
import java.util.UUID;


public class MainVerticle extends AbstractVerticle {

private static final Logger LOGGER = LogManager.getLogger(MainVerticle.class);

private PgPool client;

@Override
public void start(Promise<Void> startPromise) {
	LOGGER.info("This is an MainVerticle 'INFO' TEST MESSAGE");
	LOGGER.debug("This is a MainVerticle 'DEBUG' TEST MESSAGE");
	LOGGER.warn("This is a MainVerticle 'WARN' TEST MESSAGE");
	LOGGER.error("This is an MainVerticle 'ERROR' TEST MESSAGE");
	
	
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
 // Serve static files from resources/webroot
 router.route("/static/*").handler(StaticHandler.create("webroot"));
 // Root route: just show a hello message
 router.get("/").handler(this::handleRoot);
 
 // Demo requests route (placeholder for now)
 
 router.put("/api/demo-requests/:id/status").handler(this::handleUpdateStatus);

//Create draft
router.post("/api/demo-requests/draft").handler(this::handleSaveDraft);

//Update draft
router.put("/api/demo-requests/draft/:id").handler(this::handleUpdateDraft);
router.get("/api/demo-requests/draft/:id").handler(this::handleGetDraft);


router.get("/api/demo-requests").handler(this::handleGetDemoRequests);
router.post("/api/create-demo-requests").handler(BodyHandler.create().setUploadsDirectory("uploads"))
.handler(this::handleCreateDemoRequest);
router.get("/uploads/:filename").handler(rc -> {
	  String filename = rc.pathParam("filename");
	  Path filePath = Path.of("uploads").resolve(filename);

	  rc.response().sendFile(filePath.toString())
	    .onFailure(err -> rc.response().setStatusCode(404).end("File not found"));
	});

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

    String sql = "SELECT * FROM demo_requests WHERE id=$1 AND status='draft'";
    client.preparedQuery(sql).execute(Tuple.of(draftId), ar -> {
        if (ar.succeeded() && ar.result().size() > 0) {
            Row row = ar.result().iterator().next();
            JsonObject draft = row.toJson();
            rc.response().putHeader("content-type", "application/json")
                .end(draft.encode());
        } else {
            rc.response().setStatusCode(404)
                .end(new JsonObject().put("error", "Draft not found").encode());
        }
    });
}

private void handleSaveDraft(RoutingContext rc) {
	String requestId = UUID.randomUUID().toString();
    JsonObject body = rc.getBodyAsJson();
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

    // Insert into DB
    String sql = "INSERT INTO demo_requests " +
        "(pm_owner, demo_type, product_name, delivery_date, title, subtitle, " +
        "value_proposition, feature_focus, flow_sequence, existing_docs_path, demo_url, demo_script_path, status, created_at) " +
        "VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,'draft',NOW()) RETURNING id";

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

    JsonObject body = rc.getBodyAsJson();
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

    // Build SQL update
    String sql = "UPDATE demo_requests SET " +
        "pm_owner=$1, demo_type=$2, product_name=$3, delivery_date=$4, " +
        "title=$5, subtitle=$6, value_proposition=$7, feature_focus=$8, " +
        "flow_sequence=$9, existing_docs_path=$10, demo_url=$11, demo_script_path=$12, " +
        "status='draft', created_at=NOW() WHERE id=$13 RETURNING id";

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
        draftId
    );

    client.preparedQuery(sql).execute(params, ar -> {
        if (ar.succeeded()) {
            if (ar.result().size() == 0) {
                rc.response().setStatusCode(404)
                    .end(new JsonObject().put("error", "Draft not found").encode());
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

	  String existingDocsPath = null;
	  String demoScriptPath = null;

	  for (FileUpload upload : rc.fileUploads()) {
		  try {
			  // Permanent folder inside webroot
			    Path uploadDir = Path.of("webroot", "uploads");
		    Files.createDirectories(uploadDir);

		    // Original filename from the browser
		    String originalName = upload.fileName();
		    LOGGER.info("Saving file with original name: " + originalName);

		    // Destination path (uploads/<originalName>)
		    Path dest = uploadDir.resolve(originalName);

		    // Move file from temp to permanent
		    Files.move(Path.of(upload.uploadedFileName()), dest, StandardCopyOption.REPLACE_EXISTING);

		    // Store original filename in DB
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


	  // Insert into DB
	  String sql = "INSERT INTO demo_requests " +
			  "(pm_owner, demo_type, product_name, delivery_date, title, subtitle, value_proposition, feature_focus, flow_sequence, existing_docs_path, demo_url, demo_script_path, status, created_at) " +
			  "VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,NOW()) RETURNING id";

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
			  existingDocsPath,
			  demoUrl,
			  demoScriptPath,
			  "draft" // default status
			);


	  client.preparedQuery(sql).execute(params, ar -> {
	    if (ar.succeeded()) {
	      int id = ar.result().iterator().next().getInteger("id");
	      rc.response().putHeader("content-type", "application/json")
	        .setStatusCode(201)
	        .end(new JsonObject().put("id", id).put("status", "created").encode());
	    } else {
	      rc.response().setStatusCode(500).end(new JsonObject().put("error", ar.cause().getMessage()).encode());
	    }
	  });
	}


private void handleGetDemoRequests(RoutingContext rc) {
 String sql = "SELECT pm_owner, demo_type, product_name, delivery_date, title, subtitle, value_proposition, feature_focus, flow_sequence, existing_docs_path, demo_url, demo_script_path, created_at , status FROM demo_requests ORDER BY created_at DESC";
 client.query(sql).execute(ar -> {
   if (ar.succeeded()) {
     RowSet<Row> rows = ar.result();
     JsonArray arr = new JsonArray();
     for (Row row : rows) {
       JsonObject obj = new JsonObject()
         .put("pm_owner", row.getString("pm_owner"))
         .put("demo_type", row.getString("demo_type"))
         .put("product_name", row.getString("product_name"))
         .put("delivery_date", row.getLocalDate("delivery_date") != null ? row.getLocalDate("delivery_date").toString() : null)
         .put("title", row.getString("title"))
         .put("subtitle", row.getString("subtitle"))
         .put("value_proposition", row.getString("value_proposition"))
         .put("feature_focus", row.getString("feature_focus"))
         .put("flow_sequence", row.getString("flow_sequence"))
         .put("existing_docs_path", row.getString("existing_docs_path"))
         .put("demo_url", row.getString("demo_url"))
         .put("demo_script_path", row.getString("demo_script_path"))
         .put("created_at", row.getOffsetDateTime("created_at") != null ? row.getOffsetDateTime("created_at").toString() : null)
         .put("status", row.getString("status"));
       arr.add(obj);
     }
     rc.response()
       .putHeader("content-type", "application/json")
       .end(new JsonObject().put("demo_requests", arr).encodePrettily());
   } else {
     rc.response().setStatusCode(500).end(new JsonObject().put("error", ar.cause().getMessage()).encode());
   }
 });
}

private void handleUpdateStatus(RoutingContext rc) {
	  int id = Integer.parseInt(rc.pathParam("id"));
	  JsonObject body = rc.getBodyAsJson();
	  String newStatus = body.getString("status");

	  String sql = "UPDATE demo_requests SET status=$1 WHERE id=$2 RETURNING id";

	  client.preparedQuery(sql).execute(Tuple.of(newStatus, id), ar -> {
	    if (ar.succeeded() && ar.result().size() > 0) {
	      rc.response().putHeader("content-type", "application/json")
	        .end(new JsonObject().put("id", id).put("status", newStatus).encode());
	    } else {
	      rc.response().setStatusCode(404).end(new JsonObject().put("error", "Demo not found").encode());
	    }
	  });
	}

@Override
public void stop() {
 if (client != null) client.close();
}
}
