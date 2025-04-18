/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package story.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.json.JsonArray;
import io.vertx.core.json.JsonObject;
import io.vertx.core.net.ProxyOptions;
import io.vertx.core.net.ProxyType;
import io.vertx.core.Future;
import io.vertx.core.Promise;
import io.vertx.ext.web.client.WebClient;
import io.vertx.ext.web.client.WebClientOptions;
import messaging.thejasonengine.com.Websocket;

public class RunStoryVerticle extends AbstractVerticle 
{
	private static final Logger LOGGER = LogManager.getLogger(RunStoryVerticle.class);
	private static WebClient webClient;
	private static String serverIP;
	private static Integer serverPort;
	private static String jwt;
	@SuppressWarnings("deprecation")
	@Override
    public void start() 
	{
		
		
		
		
		LOGGER.debug("Starting the RunStoryVerticle");
		
		JsonObject config = config();
        
		LOGGER.debug("Recieved config:");
		LOGGER.debug(config.encodePrettily());
		
        int id = config.getInteger("id");
        String runtime = config.getString("runtime");
        
        serverIP = config.getString("serverIP");
        serverPort = config.getInteger("serverPort");
        jwt = config.getString("jwt");
        
        
        WebClientOptions options = new WebClientOptions()
	            .setProxyOptions(new ProxyOptions()
	                .setType(ProxyType.HTTP) 
	                .setHost(serverIP)    
	                .setPort(serverPort));
		
		
		webClient = WebClient.create(vertx, options);
        
		
        LOGGER.debug("Story execution serverIP: " + serverIP);
        LOGGER.debug("Story execution serverPort: " + serverPort);
        LOGGER.debug("Story execution jwt: " + jwt);
        
        LOGGER.debug("Story id: " + id);
        LOGGER.debug("Story runtime: " + runtime);
        
        JsonObject joStory = config.getJsonObject("story");
        
        LOGGER.debug("Story name: " + joStory.getString("name"));
        
        JsonArray jaStory = joStory.getJsonArray("story");
        
        
        executeStory(jaStory).onComplete(res -> 
        {
            if (res.succeeded()) 
            {
              LOGGER.info("All chapters finished");
            } 
            else 
            {
              LOGGER.error("Failed to finish the story: " + res.cause());
            }
          });
    }
	private Future<Void> executeStory(JsonArray jaStory) 
	{
	    Future<Void> chain = Future.succeededFuture();
	    
	    
	    for (int i = 0; i < jaStory.size(); i++) 
	    {
	        JsonObject joChapter = jaStory.getJsonObject(i);
	        chain = chain.compose(v -> executeChapter(joChapter)); //carry out chapter task
	    }
	    return chain;
	}
	private Future<Void> executeChapter(JsonObject joChapter) 
	{
	    Promise<Void> promise = Promise.promise();
	    Integer pause_in_seconds = joChapter.getInteger("pause_in_seconds");
	    Integer query_id =  joChapter.getInteger("query_id");
	    String datasource =  joChapter.getString("datasource");
	    
	    
	    LOGGER.debug("Chapter pause: " + pause_in_seconds);
	    LOGGER.debug("Chapter query_id: " + query_id);
	    LOGGER.debug("Chapter datasource: " + datasource);
	            
        /*BOF Chapter activities*/
        
	   
	    
	    
	    JsonObject payload = new JsonObject().put("datasource", datasource);
	    payload.put("queryId", query_id);
	    payload.put("jwt", jwt);    
	    payload.put("datasource", datasource);
	   
	    LOGGER.debug("Sending story flow progress to connected ws clients");
    	Websocket ws = new Websocket();
    	ws.sendMessageToClient("username", joChapter.encodePrettily());  
        
    	LOGGER.debug("Running chapter payload: " + payload.encodePrettily());
	    
    	LOGGER.debug("Chapter serverPort: " + serverPort);
    	LOGGER.debug("Chapter serverIP: " + serverIP);
    	
    	if(serverIP.contains("0:0:0:0:0:0:0:1"))
    	{
    		LOGGER.debug("have detected an IP6 address 0:0:0:0:0:0:0:1 converting it to IP4 127.0.0.1");
    		serverIP = "127.0.0.1";
    	}
    	
    	
	    webClient.post(serverPort, serverIP, "/api/runDatabaseQueryByDatasourceMapAndQueryId")
	    	.putHeader("Content-Type", "application/json")
	    	.putHeader("Accept", "application/json")
          .sendJsonObject(payload)
          .onSuccess(res -> 
          {
        	LOGGER.debug("Response from chapter webclient: " + res.bodyAsString());
          }
          )
          .onFailure(err -> {
            LOGGER.error("Chapter webclient request failed: " + err.getMessage());
          }).
          onComplete(comp -> {
        	  LOGGER.debug("Chapter webclient request complete: " + comp.succeeded());
          });
	    LOGGER.debug("Chapter called successfully");
	    
        /*EOF Chapter activities*/
        vertx.setTimer(pause_in_seconds, id -> 
	    {
	    	promise.complete();
	    });
	    return promise.future();
	}
	 
	
}
