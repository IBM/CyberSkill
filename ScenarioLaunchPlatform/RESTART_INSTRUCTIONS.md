# Restart Instructions - Error Tracking Now Active!

## What Changed

I've added error tracking to **4 additional catch blocks** in `SetupPostHandlers.java`:

1. **Line 4586**: Connection errors during SELECT queries
2. **Line 4593**: SELECT execution errors  
3. **Line 4653**: Connection errors during UPDATE/INSERT/DELETE queries
4. **Line 4660**: UPDATE/INSERT/DELETE execution errors

**All errors are now being recorded in metrics!** 🎉

## How to Restart

### Step 1: Stop Current Application
Find the running Java process and stop it:

**Windows:**
```cmd
# Find the process
tasklist | findstr java

# Kill it (replace PID with actual process ID)
taskkill /F /PID <PID>
```

**Or just press Ctrl+C in the terminal where it's running**

### Step 2: Start New Version
```bash
cd ScenarioLaunchPlatform
java -jar target/slp-0.0.1-SNAPSHOT-fat.jar
```

### Step 3: Open Dashboard
```
http://localhost:8888/health-dashboard.html
```

### Step 4: Run Stories
Execute some stories (especially ones that might fail) to generate errors.

## What You'll See Now

### ⚠️ Errors Card Will Show:

**When datasource not found:**
```
Error Type: NullPointerException
Message: Datasource not found: invalid_datasource
```

**When connection fails:**
```
Error Type: ConnectionError
Message: Unable to get database connection
```

**When SELECT query fails:**
```
Error Type: SelectExecutionError
Message: Error running SELECT query
```

**When UPDATE/INSERT/DELETE fails:**
```
Error Type: UpdateExecutionError
Message: Error running UPDATE/INSERT/DELETE query
```

**When datasource initialization fails:**
```
Error Type: DataSourceInitError
Message: Failed to initialize data sources
```

**When query execution fails:**
```
Error Type: QueryExecutionError
Message: Query failed
```

## Testing Error Tracking

### Test 1: Invalid Datasource
Run a story with a datasource that doesn't exist:
```json
{
  "jwt": "your_token",
  "datasource": "invalid_datasource_name",
  "queryId": 7
}
```

**Expected Result:**
- ✅ Application doesn't crash
- ✅ Error appears in dashboard
- ✅ HTTP 400 response with available datasources

### Test 2: Bad SQL Query
Run a story with invalid SQL:
```json
{
  "jwt": "your_token",
  "datasource": "valid_datasource",
  "queryId": 999
}
```

**Expected Result:**
- ✅ Error recorded in metrics
- ✅ Error appears in dashboard
- ✅ Story marked as failed

### Test 3: Connection Issues
If database is down or unreachable:

**Expected Result:**
- ✅ ConnectionError recorded
- ✅ Error appears in dashboard
- ✅ Graceful failure

## Dashboard Metrics

After running stories with errors, you should see:

```
📖 Story Execution
Total: 10
Success: 7  Failed: 3
Success Rate: 70.0%
Avg Execution Time: 1250ms
Active: 0
```

```
⚠️ Errors
Total: 5
Error Types: 3
Recent Errors:
- NullPointerException: Datasource not found: invalid_ds (2 min ago)
- ConnectionError: Unable to get database connection (5 min ago)
- SelectExecutionError: Error running SELECT query (8 min ago)
```

## Verification Checklist

After restart, verify:

- [ ] Application starts without errors
- [ ] Dashboard loads at http://localhost:8888/health-dashboard.html
- [ ] HTTP metrics show requests
- [ ] Run a successful story - metrics increment
- [ ] Run a failing story - error appears in dashboard
- [ ] Error card shows error count and details
- [ ] Story metrics show success/failure breakdown

## Troubleshooting

### Dashboard Shows Zero Errors
**Cause:** You're still running the old version

**Solution:** 
1. Stop the application completely
2. Verify no Java processes are running
3. Start the new JAR file

### Errors Not Appearing
**Cause:** No errors have occurred yet

**Solution:**
1. Run a story with an invalid datasource
2. Check the logs for error messages
3. Refresh the dashboard

### Application Won't Start
**Cause:** Port 8888 is still in use

**Solution:**
```bash
# Windows
netstat -ano | findstr :8888
taskkill /F /PID <PID>

# Then restart
java -jar target/slp-0.0.1-SNAPSHOT-fat.jar
```

## Summary

**Before Restart:**
- ❌ Errors logged but not tracked in metrics
- ❌ Dashboard error card shows zero
- ❌ No visibility into failure patterns

**After Restart:**
- ✅ All errors tracked in metrics
- ✅ Dashboard shows error count and types
- ✅ Recent errors displayed with timestamps
- ✅ Full observability into failures

**The new JAR is ready - just restart the application!** 🚀