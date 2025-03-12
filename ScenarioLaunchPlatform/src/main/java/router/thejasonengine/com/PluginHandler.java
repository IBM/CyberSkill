package router.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Vertx;
import io.vertx.core.http.HttpClient;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import memory.thejasonengine.com.Ram;

public class PluginHandler {
	
	private static final Logger LOGGER = LogManager.getLogger(PluginHandler.class);
	
	
	
	public void createNewPluginRoute(Vertx vertx, JsonObject plugin)
	{
		Ram ram = new Ram();
		
		Router router = ram.getRouter();
		
		Integer Port = 81;
		String host = "127.0.0.1";
		String pluginName = "insights";
		
		LOGGER.debug("Request to create new plugin route with details: " + plugin.encodePrettily());
		
		router.get("/api/plugin/insights").handler(ctx -> {
			HttpClient client = vertx.createHttpClient();
		    client.request(ctx.request().method(), 81, "127.0.0.1", ctx.request().uri())
		          .compose(req -> req.send())
		          .onSuccess(response -> {
		        	  LOGGER.debug("Successfully sent request");
		              response.body().onSuccess(body -> 
		              {
		            	  LOGGER.debug("request: " + body);
		            	  
		                  ctx.response().setStatusCode(response.statusCode()).end(body);
		              });
		          })
		          .onFailure(err ->{
		         LOGGER.error("Unable to great pluging route: " + err);	  
		          ctx.fail(500);});
		});
		
	}
	
	

}


