/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package session.thejasonengine.com;

import io.vertx.core.Vertx;
import io.vertx.core.http.CookieSameSite;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.Session;
import io.vertx.ext.web.handler.SessionHandler;
import io.vertx.ext.web.sstore.LocalSessionStore;
import io.vertx.ext.web.sstore.SessionStore;

public class SetupSession
{
	public SessionStore store;
	public SessionHandler sessionHandler;
	
	public SetupSession(Vertx vertx)
	{
		//Set up the session
		store = LocalSessionStore.create(vertx);
		sessionHandler = SessionHandler.create(store);
		// the session handler controls the cookie used for the session
		// this includes configuring, for example, the same site policy
		// like this, for strict same site policy.
		sessionHandler.setCookieSameSite(CookieSameSite.STRICT);
	}
	/*************************************************************************/
	public String getTokenFromSession(RoutingContext ctx, String sessionObjectKey) 
	{
		  Session session = ctx.session();
		  if (session == null) 
		  {
		    return null;
		  }
		  // get the token from the session
		  String sessionToken = session.get(sessionObjectKey);
		  if (sessionToken != null) 
		  {
		      return sessionToken;
		  }
		  // fail
		  return null;
		}
	/*************************************************************************/
	public Session putTokenInSession(RoutingContext ctx, String sessionObjectKey, String sessionObject) 
	{
		  Session session = ctx.session();
		  if (session == null) 
		  {
		    return null;
		  }
		  // get the token from the session
		  session = session.put(sessionObjectKey,sessionObject);
		  return session;
	}
	/*************************************************************************/
	public void destroySession(RoutingContext ctx)
	{
		ctx.session().destroy();
	}
}