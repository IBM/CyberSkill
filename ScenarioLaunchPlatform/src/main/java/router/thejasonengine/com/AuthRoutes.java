/*  Notification [Common Notification]
*
*	Author(s): Jason Flood/John Clarke
*  	Licence: Apache 2
*  
*   
*/

package router.thejasonengine.com;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import authentication.thejasonengine.com.AuthUtils;
import io.vertx.core.Vertx;
import io.vertx.core.http.Cookie;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.auth.JWTOptions;
import io.vertx.ext.auth.jwt.JWTAuth;
import io.vertx.ext.jwt.JWT;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.core.http.HttpHeaders;

/**
 * Handles all authentication-related routes
 */
public class AuthRoutes {
    
    private static final Logger LOGGER = LogManager.getLogger(AuthRoutes.class);
    private final Vertx vertx;
    private final JWTAuth jwt;
    private final AuthUtils authUtils;
    private final SetupPostHandlers setupPostHandlers;
    
    public AuthRoutes(Vertx vertx, JWTAuth jwt, AuthUtils authUtils, SetupPostHandlers setupPostHandlers) {
        this.vertx = vertx;
        this.jwt = jwt;
        this.authUtils = authUtils;
        this.setupPostHandlers = setupPostHandlers;
    }
    
    /**
     * Register all authentication routes
     */
    public void registerRoutes(Router router) {
        LOGGER.info("Registering authentication routes");
        
        // Token generation and validation
        router.get("/api/newToken").handler(this::handleNewToken);
        router.get("/api/protected").handler(this::handleProtected);
        router.get("/api/passwordGenerator/:password").handler(this::handlePasswordGenerator);
        
        // Login and session management
        router.post("/api/validateCredentials").handler(BodyHandler.create()).handler(setupPostHandlers.validateCredentials);
        router.post("/api/validateUserStatus").handler(BodyHandler.create()).handler(setupPostHandlers.validateUserStatus);
        router.post("/api/createCookie").handler(BodyHandler.create()).handler(setupPostHandlers.createCookie);
        router.post("/api/createSession").handler(BodyHandler.create()).handler(setupPostHandlers.createSession);
        router.post("/web/login").handler(BodyHandler.create()).handler(setupPostHandlers.webLogin);
        
        LOGGER.info("Authentication routes registered successfully");
    }
    
    /**
     * Generate a new JWT token
     */
    private void handleNewToken(io.vertx.ext.web.RoutingContext ctx) {
        String name = "JWT";
        ctx.response().putHeader("Content-Type", "application/json");
        
        JsonObject tokenObject = new JsonObject();
        tokenObject.put("endpoint", "sensor1");
        tokenObject.put("someKey", "someValue");
        
        String token = jwt.generateToken(tokenObject, new JWTOptions().setExpiresInSeconds(60000));
        LOGGER.info("JWT TOKEN generated");
        
        LOGGER.debug("Creating cookie");
        authUtils.createCookie(ctx, 60000, name, token, "/");
        LOGGER.debug("Cookie created");
        
        ctx.response().setChunked(true);
        ctx.response().putHeader(HttpHeaders.ACCESS_CONTROL_ALLOW_ORIGIN, "*");
        ctx.response().putHeader(HttpHeaders.ACCESS_CONTROL_ALLOW_METHODS, "GET");
        
        JsonObject response = new JsonObject();
        response.put("token", token);
        LOGGER.info("Successfully generated token and added cookie");
        ctx.response().end(response.toString());
    }
    
    /**
     * Protected endpoint that requires valid JWT
     */
    private void handleProtected(io.vertx.ext.web.RoutingContext ctx) {
        ctx.response().putHeader("Content-Type", "application/json");
        Cookie cookie = ctx.getCookie("JWT");
        
        if (cookie != null) {
            LOGGER.info("Found a cookie with the correct name");
            if (verifyCookie(cookie)) {
                ctx.response().end("OK");
            } else {
                ctx.response().setStatusCode(401).end("Invalid token");
            }
        } else {
            LOGGER.error("Did not find a cookie name JWT when calling the (api/protected) webpage: " + ctx.normalizedPath());
            ctx.response().setStatusCode(401).sendFile("webroot/index.htm");
        }
    }
    
    /**
     * Generate password hash
     */
    private void handlePasswordGenerator(io.vertx.ext.web.RoutingContext ctx) {
        String password = ctx.request().getParam("password");
        
        ctx.response().putHeader("Content-Type", "application/json");
        
        String result = SetupPostHandlers.hashAndSaltPass(password);
        
        JsonObject response = new JsonObject();
        response.put("password", result);
        LOGGER.info("Successfully generated password token");
        ctx.response().end(response.toString());
    }
    
    /**
     * Verify cookie validity
     * TODO: Implement proper JWT signature validation
     */
    private boolean verifyCookie(Cookie cookie) {
        String token = cookie.getValue();
        LOGGER.info("Token value: " + token);
        
        JWT jwtToken = new JWT();
        LOGGER.info("Token parsed: " + jwtToken.parse(token).toString());
        JsonObject JSON_JWT = jwtToken.parse(token);
        
        Integer cookieExpiry = (Integer) JSON_JWT.getJsonObject("payload").getValue("exp");
        
        long cookExp = Long.valueOf(cookieExpiry.longValue());
        cookExp = cookExp * 1000; // convert from an int to a long
        
        LOGGER.info("Cookie Expires: " + cookExp);
        long currentTimestamp = System.currentTimeMillis();
        LOGGER.info("Current Time:" + currentTimestamp);
        
        if (currentTimestamp < cookExp) {
            LOGGER.info("Cookie is still alive");
            return true;
        } else {
            LOGGER.info("Cookie is too old and will not be accepted");
            return false;
        }
    }
}


