/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/


package authentication.thejasonengine.com;

import io.vertx.core.AsyncResult;
import io.vertx.core.Context;
import io.vertx.core.Handler;
import io.vertx.core.http.Cookie;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.AuthProvider;
import io.vertx.ext.auth.PubSecKeyOptions;
import io.vertx.ext.auth.User;
import io.vertx.ext.auth.jwt.*;
import io.vertx.ext.auth.jwt.JWTAuthOptions;
import io.vertx.ext.web.RoutingContext;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class AuthUtils implements AuthProvider{
	Logger LOGGER = LogManager.getLogger(AuthUtils.class);

	
	public AuthUtils()
	{
		
	}
	
	/*Create a JWT token*/
	public JWTAuth createJWTToken(Context context)
	{
		JWTAuth jwt = JWTAuth.create(context.owner(), new JWTAuthOptions()
	      		  .addPubSecKey(new PubSecKeyOptions()
	      		  .setAlgorithm("HS256")
	      		  .setBuffer("keyboard cat")));
		LOGGER.debug("Created the JWT Token");
		return jwt;
	}
	
	public Cookie createCookie(RoutingContext ctx, long age, String name, String token, String path)
	{
		Cookie cookie = Cookie.cookie(name,token);
        path = "/"; //give any suitable path
        cookie.setPath(path);
        cookie.setMaxAge(age);
        ctx.addCookie(cookie);
        LOGGER.debug("Created the Cookie");
        return cookie;
	}

	@Override
	public void authenticate(JsonObject credentials, Handler<AsyncResult<User>> resultHandler) 
	{
		// TODO Auto-generated method stub
		LOGGER.debug("Called the authentication");
		
	}
}