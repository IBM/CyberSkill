package utils.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Vertx;
import io.vertx.core.file.FileSystem;
import io.vertx.core.AsyncResult;
import io.vertx.core.Handler;

public class FolderDelete 
{
  
	private static final Logger LOGGER = LogManager.getLogger(FolderDelete.class);
	public static void deleteDirectory(Vertx vertx, String dirPath, Handler<AsyncResult<Void>> handler) 
	{
	    FileSystem fs = vertx.fileSystem();

	    fs.exists(dirPath, existsRes ->
	    {
	      if (existsRes.failed()) 
	      {
	        handler.handle(existsRes.mapEmpty());
	        return;
	      }

	      if (!existsRes.result()) {
	        handler.handle(io.vertx.core.Future.failedFuture("Directory does not exist: " + dirPath));
	        return;
	      }
	      fs.deleteRecursive(dirPath, true, handler);
	    });
	}
}
	  
	 
