package router.thejasonengine.com;

import java.nio.file.Path;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import cluster.thejasonengine.com.ClusteredVerticle;
import database.thejasonengine.com.DatabaseController;
import io.vertx.core.Context;
import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.core.file.FileSystem;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.FileUpload;
import io.vertx.ext.web.RoutingContext;
import io.vertx.sqlclient.Pool;
import io.vertx.sqlclient.SqlConnection;
import io.vertx.sqlclient.Tuple;

public class FileUploadHandler 
{
	
	private static final Logger LOGGER = LogManager.getLogger(FileUploadHandler.class);
	
	public Handler<RoutingContext> uploadFileToServer;


	/******************************************************************************************/
	public FileUploadHandler(Vertx vertx)
    {
		uploadFileToServer = FileUploadHandler.this::handleUploadFileToServer;
	}
	private void handleUploadFileToServer(RoutingContext routingContext)
	{
		LOGGER.info("Inside FileUploadHandler.handleUploadFileToServer");  
		
		List<FileUpload> files = routingContext.fileUploads();

		  // 1️  Must be exactly ONE part
		  if (files.size() != 1) {
			routingContext.response()
		       .setStatusCode(400)
		       .putHeader("content-type", "application/json")
		       .end("{\"error\":\"exactly one file expected\"}");
		    return;
		  }

		  FileUpload f = files.iterator().next();           // the single upload
		  String original = f.fileName();

		  // 2️  Must end with .zip (case‑insensitive)
		  if (!original.toLowerCase().endsWith(".zip")) 
		  {
		   // clean temp asynchronously
		   routingContext.vertx().fileSystem().delete(f.uploadedFileName(), del -> {
		       // ignore result
		   });
		   routingContext.response()
		       .setStatusCode(415)
		       .putHeader("content-type", "application/json")
		       .end("{\"error\":\"only .zip files allowed\"}");
		    return;
		  }

		String uploadsFolder = "uploads";
		Path uploadsDir = Path.of(uploadsFolder);
		// 3️  Move to final uploads/ dir (non-blocking)
		String target = uploadsDir.resolve(original).toString();
		FileSystem fs = routingContext.vertx().fileSystem();
		fs.move(f.uploadedFileName(), target, moveRes -> {
		    if (moveRes.succeeded()) {
		        // 4️  Success JSON
		        routingContext.response()
		           .putHeader("content-type", "application/json")
		           .end(new JsonObject()
		                  .put("stored", target)
		                  .put("size",   f.size())
		                  .encode());
		    } else {
		        // Attempt to clean temp and return error
		        fs.delete(f.uploadedFileName(), del -> {
		            // ignore
		        });
		        routingContext.response()
		           .setStatusCode(500)
		           .putHeader("content-type", "application/json")
		           .end(new JsonObject()
		                  .put("error", "failed to store file")
		                  .put("detail", moveRes.cause() != null ? moveRes.cause().getMessage() : "unknown")
		                  .encode());
		    }
		});
	}	
}

