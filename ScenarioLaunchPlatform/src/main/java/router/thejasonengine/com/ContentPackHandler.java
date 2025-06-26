package router.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import io.vertx.core.Handler;
import io.vertx.core.Vertx;
import io.vertx.ext.web.RoutingContext;

public class ContentPackHandler 
{
	private static final Logger LOGGER = LogManager.getLogger(ContentPackHandler.class);

	public Handler<RoutingContext> installContentPack;
	public Handler<RoutingContext> uninstallContentPack;
	
	/******************************************************************************************/
	public ContentPackHandler(Vertx vertx)
    {
		installContentPack = ContentPackHandler.this::handleInstallContentPack;
		uninstallContentPack = ContentPackHandler.this::handleUninstallContentPack;
	}
	
	public void handleInstallContentPack(RoutingContext routingContext)
	{
		LOGGER.debug("inside: handleInstallContentPack ");
	}
	
	public void handleUninstallContentPack(RoutingContext routingContext)
	{
		LOGGER.debug("inside: handleUninstallContentPack ");
		
	}
	
}
