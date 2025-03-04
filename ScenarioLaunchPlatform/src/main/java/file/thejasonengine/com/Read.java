/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package file.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Vertx;
import io.vertx.core.file.FileSystem;
import io.vertx.core.buffer.Buffer;


public class Read {
	private static final Logger LOGGER = LogManager.getLogger(Read.class);
	public static void readFile(Vertx vertx, String filePath)
	{
		 FileSystem fs = vertx.fileSystem();
		 filePath = "user/"+filePath;
		 LOGGER.debug("filePath: " + filePath);

	     // Asynchronously read the file content
	     fs.readFile(filePath, res -> 
	     {
	    	 if (res.succeeded()) 
	    	 {
	                Buffer fileContent = res.result();
	                LOGGER.debug("----------------------------------------- > File content: " + fileContent.toString());
	    	 } 
	    	 else 
	    	 {
	                LOGGER.error("----------------------------------------- > Failed to read file: " + res.cause().getMessage());
	         }
	     });
	}
}
