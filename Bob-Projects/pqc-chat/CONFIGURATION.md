# Configuration Guide - PQC Secured Messaging

## Configuration Loading Priority

The application loads configuration in the following order (highest priority first):

1. **config.json file** (in classpath/resources)
2. **Vert.x configuration** (passed via command line)
3. **Default values** (hardcoded fallback)

## Configuration File

### Location
`src/main/resources/config.json`

### Format
```json
{
  "http.port": 9999,
  "logging.level": "INFO"
}
```

### Available Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `http.port` | Integer | 8080 | HTTP server port |
| `logging.level` | String | INFO | Logging level (DEBUG, INFO, WARN, ERROR) |

## Usage Examples

### 1. Using config.json (Recommended)

Edit `src/main/resources/config.json`:
```json
{
  "http.port": 9999,
  "logging.level": "DEBUG"
}
```

Then rebuild and run:
```bash
mvn clean package -DskipTests
java -jar target/pqc-chat-1.0.0-fat.jar
```

Server will start on port 9999.

### 2. Using Default Port

If no config.json is found or port is not specified, the application falls back to port 8080:

```bash
# Remove or rename config.json
java -jar target/pqc-chat-1.0.0-fat.jar
```

Server will start on port 8080 (default).

### 3. Override via Command Line

You can also pass configuration via Vert.x options:

```bash
java -jar target/pqc-chat-1.0.0-fat.jar -conf '{"http.port":7777}'
```

Server will start on port 7777.

## Configuration Loading Behavior

### Startup Logs

When the application starts, you'll see configuration loading messages:

```
Configuration file loaded: config.json
Configuration loaded - Port: 9999
PQC Chat Server started successfully on port 9999
Access the application at: http://localhost:9999
```

### If config.json is Missing

```
Configuration file not found: config.json, using defaults
Configuration loaded - Port: 8080
PQC Chat Server started successfully on port 8080
Access the application at: http://localhost:8080
```

### If config.json is Invalid

```
Error loading configuration file: config.json
Configuration loaded - Port: 8080
PQC Chat Server started successfully on port 8080
Access the application at: http://localhost:8080
```

## Port Selection Logic

```
Port = config.json["http.port"] 
       || Vert.x config["http.port"] 
       || DEFAULT_PORT (8080)
```

## Common Scenarios

### Scenario 1: Development
Use a high port number to avoid conflicts:
```json
{
  "http.port": 9999,
  "logging.level": "DEBUG"
}
```

### Scenario 2: Production
Use standard HTTP port with INFO logging:
```json
{
  "http.port": 80,
  "logging.level": "INFO"
}
```

### Scenario 3: Testing
Use a random high port:
```json
{
  "http.port": 8888,
  "logging.level": "DEBUG"
}
```

## Troubleshooting

### Port Already in Use

**Error:**
```
java.net.BindException: Address already in use: bind
```

**Solution:**
1. Change the port in config.json
2. Or find and stop the process using the port:
   ```bash
   # Windows
   netstat -ano | findstr :9999
   taskkill /PID <pid> /F
   
   # Linux/Mac
   lsof -i :9999
   kill -9 <pid>
   ```

### Configuration Not Loading

**Check:**
1. Ensure config.json is in `src/main/resources/`
2. Rebuild the application: `mvn clean package`
3. Check the JAR contains config.json:
   ```bash
   jar -tf target/pqc-chat-1.0.0-fat.jar | grep config.json
   ```

### Invalid JSON Format

**Error:**
```
Error loading configuration file: config.json
```

**Solution:**
Validate your JSON at https://jsonlint.com/ or use:
```bash
# Linux/Mac
cat src/main/resources/config.json | python -m json.tool

# Windows PowerShell
Get-Content src/main/resources/config.json | ConvertFrom-Json
```

## Best Practices

1. **Version Control**: Commit a template config.json with default values
2. **Environment-Specific**: Use different configs for dev/test/prod
3. **Documentation**: Document all configuration options
4. **Validation**: Add validation for critical configuration values
5. **Logging**: Always log the loaded configuration on startup

## Advanced Configuration

### External Configuration File

To load configuration from an external file:

```bash
java -jar target/pqc-chat-1.0.0-fat.jar -conf /path/to/external-config.json
```

### Environment Variables

You can also use environment variables (requires code modification):

```java
int port = System.getenv("PQC_CHAT_PORT") != null 
    ? Integer.parseInt(System.getenv("PQC_CHAT_PORT"))
    : config.getInteger("http.port", DEFAULT_PORT);
```

## Summary

The PQC Chat application provides flexible configuration with sensible defaults:
- ✅ Reads from config.json if available
- ✅ Falls back to default port 8080 if not configured
- ✅ Supports command-line overrides
- ✅ Logs configuration loading status
- ✅ Handles errors gracefully

This ensures the application can run in any environment without requiring configuration changes.