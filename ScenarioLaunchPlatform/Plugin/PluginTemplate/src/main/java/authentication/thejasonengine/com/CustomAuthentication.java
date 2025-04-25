/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/



package authentication.thejasonengine.com;

import io.vertx.core.AsyncResult;
import io.vertx.core.Handler;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.User;
import io.vertx.ext.auth.authentication.AuthenticationProvider;

public class CustomAuthentication implements AuthenticationProvider {

	public void authenticate(JsonObject put, Object object) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void authenticate(JsonObject credentials, Handler<AsyncResult<User>> resultHandler) {
		// TODO Auto-generated method stub
		
	}

	public void setJdbc(Object jdbc) {
		// TODO Auto-generated method stub
		
	}



}