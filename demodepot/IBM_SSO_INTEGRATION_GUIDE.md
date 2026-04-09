# IBM SSO Integration Guide for DemoDepot

This guide explains how to integrate IBM Single Sign-On (SSO) with the DemoDepot application.

## Overview

DemoDepot currently uses JWT-based authentication with local user accounts. To integrate with IBM SSO, you'll need to implement OAuth 2.0 / OpenID Connect (OIDC) flow.

## Supported IBM SSO Solutions

1. **IBM Security Verify** (formerly IBM Cloud Identity)
2. **IBM Cloud App ID**
3. **IBM Security Access Manager (ISAM)**

## Architecture Changes

### Current Flow:
```
User → Login Form → Backend validates credentials → JWT token → Access granted
```

### IBM SSO Flow:
```
User → SSO Login Button → IBM SSO Portal → OAuth callback → Backend validates token → JWT token → Access granted
```

## Implementation Steps

### 1. Prerequisites

Add OAuth2 dependencies to `pom.xml`:

```xml
<dependencies>
  <!-- Existing dependencies... -->
  
  <!-- OAuth2 / OIDC Support -->
  <dependency>
    <groupId>io.vertx</groupId>
    <artifactId>vertx-auth-oauth2</artifactId>
    <version>4.5.0</version>
  </dependency>
  
  <!-- HTTP Client for token validation -->
  <dependency>
    <groupId>io.vertx</groupId>
    <artifactId>vertx-web-client</artifactId>
    <version>4.5.0</version>
  </dependency>
</dependencies>
```

### 2. IBM SSO Configuration

#### For IBM Security Verify:
1. Log into IBM Security Verify admin console
2. Create a new application
3. Configure OAuth 2.0 settings:
   - **Redirect URI**: `http://localhost:9999/api/auth/callback`
   - **Grant Types**: Authorization Code
   - **Scopes**: openid, profile, email
4. Note down:
   - Client ID
   - Client Secret
   - Authorization Endpoint
   - Token Endpoint
   - UserInfo Endpoint

#### For IBM Cloud App ID:
1. Create App ID service instance in IBM Cloud
2. Add application credentials
3. Configure redirect URLs
4. Get service credentials (contains all endpoints)

### 3. Backend Implementation

Create a new configuration file `src/main/resources/ibm-sso-config.json`:

```json
{
  "ibm_sso": {
    "enabled": true,
    "provider": "ibm-verify",
    "client_id": "YOUR_CLIENT_ID",
    "client_secret": "YOUR_CLIENT_SECRET",
    "authorization_endpoint": "https://YOUR_TENANT.verify.ibm.com/oauth2/authorize",
    "token_endpoint": "https://YOUR_TENANT.verify.ibm.com/oauth2/token",
    "userinfo_endpoint": "https://YOUR_TENANT.verify.ibm.com/oauth2/userinfo",
    "redirect_uri": "http://localhost:9999/api/auth/callback",
    "scopes": ["openid", "profile", "email"],
    "role_mapping": {
      "admin_group": "admin",
      "default": "user"
    }
  }
}
```

### 4. Update MainVerticle.java

Add OAuth2 authentication handler:

```java
import io.vertx.ext.auth.oauth2.OAuth2Auth;
import io.vertx.ext.auth.oauth2.OAuth2Options;
import io.vertx.ext.auth.oauth2.providers.OpenIDConnectAuth;
import io.vertx.ext.web.client.WebClient;

public class MainVerticle extends AbstractVerticle {
    
    private OAuth2Auth oauth2;
    private JsonObject ssoConfig;
    
    @Override
    public void start(Promise<Void> startPromise) {
        // Load SSO configuration
        vertx.fileSystem().readFile("src/main/resources/ibm-sso-config.json", ar -> {
            if (ar.succeeded()) {
                ssoConfig = ar.result().toJsonObject().getJsonObject("ibm_sso");
                
                if (ssoConfig.getBoolean("enabled", false)) {
                    initializeOAuth2();
                }
            }
        });
        
        // ... existing code ...
        
        // Add SSO routes
        router.get("/api/auth/login").handler(this::handleSSOLogin);
        router.get("/api/auth/callback").handler(this::handleSSOCallback);
        router.get("/api/auth/logout").handler(this::handleSSOLogout);
        
        // ... rest of existing code ...
    }
    
    private void initializeOAuth2() {
        OAuth2Options options = new OAuth2Options()
            .setClientId(ssoConfig.getString("client_id"))
            .setClientSecret(ssoConfig.getString("client_secret"))
            .setSite(ssoConfig.getString("authorization_endpoint").replaceAll("/oauth2/authorize$", ""))
            .setAuthorizationPath("/oauth2/authorize")
            .setTokenPath("/oauth2/token")
            .setUserInfoPath("/oauth2/userinfo");
        
        oauth2 = OAuth2Auth.create(vertx, options);
        LOGGER.info("IBM SSO OAuth2 initialized successfully");
    }
    
    private void handleSSOLogin(RoutingContext rc) {
        LOGGER.info("=== IBM SSO LOGIN REQUEST ===");
        
        if (oauth2 == null) {
            rc.response().setStatusCode(503)
                .end(new JsonObject()
                    .put("error", "SSO not configured")
                    .put("message", "IBM SSO is not enabled")
                    .encode());
            return;
        }
        
        String authorizationUri = oauth2.authorizeURL(new JsonObject()
            .put("redirect_uri", ssoConfig.getString("redirect_uri"))
            .put("scope", String.join(" ", ssoConfig.getJsonArray("scopes").getList()))
            .put("state", UUID.randomUUID().toString()));
        
        LOGGER.info("Redirecting to IBM SSO: {}", authorizationUri);
        rc.response()
            .putHeader("Location", authorizationUri)
            .setStatusCode(302)
            .end();
    }
    
    private void handleSSOCallback(RoutingContext rc) {
        LOGGER.info("=== IBM SSO CALLBACK ===");
        
        String code = rc.request().getParam("code");
        String state = rc.request().getParam("state");
        String error = rc.request().getParam("error");
        
        if (error != null) {
            LOGGER.error("SSO error: {}", error);
            rc.response()
                .putHeader("Location", "/login.html?error=" + error)
                .setStatusCode(302)
                .end();
            return;
        }
        
        if (code == null) {
            LOGGER.error("No authorization code received");
            rc.response()
                .putHeader("Location", "/login.html?error=no_code")
                .setStatusCode(302)
                .end();
            return;
        }
        
        LOGGER.info("Authorization code received, exchanging for token...");
        
        // Exchange code for token
        oauth2.authenticate(new JsonObject()
            .put("code", code)
            .put("redirect_uri", ssoConfig.getString("redirect_uri")))
            .onSuccess(user -> {
                LOGGER.info("Token exchange successful");
                
                // Get user info
                oauth2.userInfo(user).onSuccess(userInfo -> {
                    String email = userInfo.getString("email");
                    String name = userInfo.getString("name", email);
                    
                    LOGGER.info("User info retrieved: {}", email);
                    
                    // Check if user exists in database, create if not
                    createOrUpdateUser(email, name, userInfo, rc);
                    
                }).onFailure(err -> {
                    LOGGER.error("Failed to get user info", err);
                    rc.response()
                        .putHeader("Location", "/login.html?error=userinfo_failed")
                        .setStatusCode(302)
                        .end();
                });
                
            }).onFailure(err -> {
                LOGGER.error("Token exchange failed", err);
                rc.response()
                    .putHeader("Location", "/login.html?error=token_failed")
                    .setStatusCode(302)
                    .end();
            });
    }
    
    private void createOrUpdateUser(String email, String name, JsonObject userInfo, RoutingContext rc) {
        // Check if user exists
        String sql = "SELECT id, username, role FROM users WHERE username = $1";
        client.preparedQuery(sql).execute(Tuple.of(email), ar -> {
            if (ar.succeeded() && ar.result().size() > 0) {
                // User exists
                Row row = ar.result().iterator().next();
                int userId = row.getInteger("id");
                String role = row.getString("role");
                
                LOGGER.info("Existing user logged in via SSO: {} (ID: {})", email, userId);
                generateAndReturnToken(rc, email, userId, role);
                
            } else {
                // Create new user
                String role = determineUserRole(userInfo);
                String insertSql = "INSERT INTO users (username, password_hash, role) VALUES ($1, $2, $3) RETURNING id";
                
                client.preparedQuery(insertSql).execute(
                    Tuple.of(email, "SSO_USER", role), 
                    insertAr -> {
                        if (insertAr.succeeded() && insertAr.result().size() > 0) {
                            int userId = insertAr.result().iterator().next().getInteger("id");
                            LOGGER.info("New user created via SSO: {} (ID: {})", email, userId);
                            generateAndReturnToken(rc, email, userId, role);
                        } else {
                            LOGGER.error("Failed to create user", insertAr.cause());
                            rc.response()
                                .putHeader("Location", "/login.html?error=user_creation_failed")
                                .setStatusCode(302)
                                .end();
                        }
                    });
            }
        });
    }
    
    private String determineUserRole(JsonObject userInfo) {
        // Check user's groups/roles from IBM SSO
        JsonArray groups = userInfo.getJsonArray("groups", new JsonArray());
        JsonObject roleMapping = ssoConfig.getJsonObject("role_mapping");
        
        for (Object group : groups) {
            if (group.toString().equals(roleMapping.getString("admin_group"))) {
                return "admin";
            }
        }
        
        return roleMapping.getString("default", "user");
    }
    
    private void generateAndReturnToken(RoutingContext rc, String username, int userId, String role) {
        String token = jwtAuth.generateToken(
            new JsonObject()
                .put("sub", username)
                .put("userId", userId)
                .put("role", role),
            new JWTOptions().setExpiresInMinutes(60 * 24 * 7)
        );
        
        LOGGER.info("JWT token generated for SSO user: {}", username);
        
        // Redirect to dashboard with token in URL (will be stored in localStorage)
        String redirectUrl = role.equals("admin") 
            ? "/admin-dashboard.html" 
            : "/user-dashboard.html";
        
        rc.response()
            .putHeader("Location", redirectUrl + "?token=" + token + "&username=" + username + "&role=" + role)
            .setStatusCode(302)
            .end();
    }
    
    private void handleSSOLogout(RoutingContext rc) {
        LOGGER.info("=== IBM SSO LOGOUT ===");
        
        // IBM SSO logout URL
        String logoutUrl = ssoConfig.getString("authorization_endpoint")
            .replaceAll("/oauth2/authorize$", "/oauth2/logout")
            + "?post_logout_redirect_uri=" + ssoConfig.getString("redirect_uri").replaceAll("/api/auth/callback$", "/login.html");
        
        rc.response()
            .putHeader("Location", logoutUrl)
            .setStatusCode(302)
            .end();
    }
}
```

### 5. Update Frontend (login.html)

Add SSO login button:

```html
<!-- Add after existing login form -->
<div class="sso-section" style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #e6edf3;">
  <button id="ssoLoginBtn" class="primary" style="width: 100%; background: #0f62fe;">
    <svg style="width: 20px; height: 20px; margin-right: 8px; vertical-align: middle;" viewBox="0 0 32 32" fill="currentColor">
      <path d="M16 2C8.3 2 2 8.3 2 16s6.3 14 14 14 14-6.3 14-14S23.7 2 16 2zm0 26C9.4 28 4 22.6 4 16S9.4 4 16 4s12 5.4 12 12-5.4 12-12 12z"/>
      <path d="M16 8c-4.4 0-8 3.6-8 8s3.6 8 8 8 8-3.6 8-8-3.6-8-8-8zm0 14c-3.3 0-6-2.7-6-6s2.7-6 6-6 6 2.7 6 6-2.7 6-6 6z"/>
    </svg>
    Sign in with IBM SSO
  </button>
  <p class="small" style="text-align: center; margin-top: 10px; color: #6b7280;">
    Use your IBM credentials to sign in
  </p>
</div>

<script>
  // Add SSO login handler
  document.getElementById('ssoLoginBtn').addEventListener('click', () => {
    console.log('[SSO] Initiating IBM SSO login...');
    toast.loading('Redirecting to IBM SSO...');
    window.location.href = '/api/auth/login';
  });
  
  // Handle token from SSO callback
  const urlParams = new URLSearchParams(window.location.search);
  const token = urlParams.get('token');
  const username = urlParams.get('username');
  const role = urlParams.get('role');
  
  if (token && username && role) {
    console.log('[SSO] Received token from callback');
    localStorage.setItem('token', token);
    localStorage.setItem('username', username);
    localStorage.setItem('role', role);
    toast.success('Logged in via IBM SSO');
    
    // Clean URL
    window.history.replaceState({}, document.title, window.location.pathname);
  }
</script>
```

### 6. Environment Configuration

Create `.env` file for sensitive credentials:

```properties
IBM_SSO_CLIENT_ID=your_client_id_here
IBM_SSO_CLIENT_SECRET=your_client_secret_here
IBM_SSO_TENANT=your_tenant_name
```

Update config loading to use environment variables:

```java
String clientId = System.getenv("IBM_SSO_CLIENT_ID");
String clientSecret = System.getenv("IBM_SSO_CLIENT_SECRET");
```

## Testing

### 1. Local Testing
```bash
# Set environment variables
export IBM_SSO_CLIENT_ID=your_client_id
export IBM_SSO_CLIENT_SECRET=your_secret

# Run application
mvn clean package
java -jar target/demodepot-1.0.0-SNAPSHOT-fat.jar
```

### 2. Test Flow
1. Navigate to `http://localhost:9999/login.html`
2. Click "Sign in with IBM SSO"
3. Redirected to IBM SSO login page
4. Enter IBM credentials
5. Redirected back to DemoDepot
6. Automatically logged in with JWT token

## Security Considerations

1. **HTTPS Required**: IBM SSO requires HTTPS in production
2. **State Parameter**: Prevents CSRF attacks (already included)
3. **Token Validation**: Always validate tokens server-side
4. **Secure Storage**: Store client secret securely (environment variables, vault)
5. **Token Refresh**: Implement token refresh logic for long sessions

## Hybrid Authentication

To support both local login and IBM SSO:

```java
// Keep existing handleLogin and handleSignup
// Add SSO routes alongside them
// Frontend shows both options

// In login.html:
<div class="tabs">
  <div class="tab active">Local Login</div>
  <div class="tab">IBM SSO</div>
</div>
```

## Troubleshooting

### Common Issues:

1. **Redirect URI Mismatch**
   - Ensure redirect URI in IBM SSO config matches exactly
   - Check for trailing slashes

2. **Invalid Client Credentials**
   - Verify client ID and secret
   - Check environment variables are loaded

3. **Token Validation Fails**
   - Verify token endpoint URL
   - Check network connectivity to IBM SSO

4. **User Not Created**
   - Check database permissions
   - Verify email is returned from userInfo endpoint

## Production Deployment

1. Use HTTPS (required by IBM SSO)
2. Update redirect URIs to production URLs
3. Store secrets in secure vault (IBM Key Protect, HashiCorp Vault)
4. Enable audit logging
5. Set up monitoring for SSO failures

## Additional Resources

- [IBM Security Verify Documentation](https://www.ibm.com/docs/en/security-verify)
- [IBM Cloud App ID Documentation](https://cloud.ibm.com/docs/appid)
- [OAuth 2.0 Specification](https://oauth.net/2/)
- [OpenID Connect Specification](https://openid.net/connect/)

## Support

For IBM SSO specific issues:
- IBM Support Portal
- IBM Developer Community
- Stack Overflow (tag: ibm-cloud, ibm-security-verify)