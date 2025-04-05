/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package file.thejasonengine.com;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.io.BufferedReader;
import java.io.InputStreamReader;

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
	public static String getDatabaseSchemaInfo(String currentSchemaVersion)
	{
		String content = ""; 
		try
		 {
			 Path jarPath = Paths.get(Read.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getParent();
			 LOGGER.debug("Location of SLP: " + jarPath);
			 Path filePath = jarPath.resolve(currentSchemaVersion + "_toLatest.sql"); // Replace with the actual filename
	         LOGGER.debug("Location of schema to execute: " + filePath);
	         if (Files.exists(filePath)) 
	         {
	        	 List<String> lines = Files.readAllLines(filePath);
	             content = String.join(System.lineSeparator(), lines);
	             LOGGER.debug(content);
	         } 
	         else 
	         {
	        	 LOGGER.debug("File not found!");
	         }
	        
		 } 
		 catch (Exception e) 
		 {
			 LOGGER.error("Unable to getDatabaseSchemaInfo : "+ e.getMessage());
		 }
		 return content;
	}
}
