/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package cron.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.ext.web.RoutingContext;

public class Govenor 
{
	private static final Logger LOGGER = LogManager.getLogger(Govenor.class);
	
	public static void ScheduledTask(RoutingContext routingContext)
	{
		routingContext.vertx().setPeriodic(1000, h -> 
		{
			LOGGER.info("Govenor periodic running on: " + Thread.currentThread().getName());
		});
	}

}
