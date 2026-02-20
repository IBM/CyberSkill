# GDP Lab Latest Release

This folder contains the latest GDP Lab version of the Scenario Launch Platform with Outliers focus.

## 📥 Latest Release Contains

✔️ **JAR file** - slp-0.0.1-SNAPSHOT.jar
✔️ **Database folder** - Complete SQL scripts and patches
✔️ **Content packs folder** - Standard database scenario content packs
✔️ **GDP Lab Outliers folder** - All outlier scenario content packs for GDP Lab
✔️ **Scripts folder** - Utility and deployment scripts
✔️ **Config file** - config.json
✔️ **Connection Validator** - connectionValidator.sh
✔️ **Restart Script** - restartSLP.sh (Linux/Unix)
✔️ **Outlier Stories Runner** - run_outlier_stories.sh
✔️ **Readme file** - This documentation

## 📦 Distribution Package

The distribution is packaged as `slp-gdp-lab-0.0.1-SNAPSHOT-gdp-lab-distribution.tar.gz` and includes:
- Application JAR with all dependencies
- Database initialization and migration scripts
- Standard content packs for various databases (MySQL, Oracle, PostgreSQL, SQL Server, DB2)
- GDP Lab outlier content packs (all outlier scenarios)
- Configuration templates
- Utility scripts for management and deployment
- Automated outlier stories execution script

## 🔨 Building the GDP Lab Distribution

To build the GDP Lab distribution package from source:

```sh
mvn clean package
```

This will:
1. Compile the Java source code
2. Package the application as a JAR file
3. Create a tar.gz archive in the `gdp_lab_latest/` folder with all required files

## 🦾 Extract tar contents

```sh
tar -xzf slp-gdp-lab-0.0.1-SNAPSHOT-gdp-lab-distribution.tar.gz
```

## 📋 Installation Steps

1. **Extract the distribution package:**
   ```sh
   tar -xzf slp-gdp-lab-0.0.1-SNAPSHOT-gdp-lab-distribution.tar.gz
   cd slp-gdp-lab-0.0.1-SNAPSHOT-gdp-lab-distribution
   ```

2. **Configure the application:**
   - Edit `config.json` with your database connection details
   - Update any environment-specific settings

3. **Initialize the database:**
   - Run the SQL scripts in the `database/ScenarioLaunchPlatform_CORE/` folder
   - Apply any necessary patches from `database/ScenarioLaunchPlatform_CORE/patches/`

4. **Set script permissions:**
   ```sh
   chmod +x connectionValidator.sh restartSLP.sh run_outlier_stories.sh
   chmod +x scripts/*.sh
   ```

5. **Start the application:**
   ```sh
   java -jar slp-0.0.1-SNAPSHOT.jar
   ```
   
   Or use the restart script:
   ```sh
   ./restartSLP.sh
   ```

## 🎯 Running Outlier Stories

The GDP Lab distribution includes a script to automatically run all outlier stories:

```sh
./run_outlier_stories.sh
```

This script will:
- Connect to the SLP API
- Fetch all available stories
- Execute all outlier stories (excluding Quick Demo scenarios)
- Log execution details to `outlier_stories_run.log`

**Note:** Make sure to update the JWT token in `run_outlier_stories.sh` before running.

## 📚 Content Packs

### Standard Content Packs (`contentpacks/` folder)
Standard database scenario content packs for:
- **MySQL 8.0** - MySQL database scenarios
- **Oracle** - Oracle database scenarios
- **Oracle AWS** - Oracle on AWS scenarios
- **PostgreSQL** - PostgreSQL database scenarios
- **SQL Server** - SQL Server database scenarios
- **DB2** - IBM DB2 database scenarios

### GDP Lab Outliers Content Packs (`gdp_lab_outliers/` folder)

Specialized outlier detection scenarios:

- **outlier_account_take_over** - Account takeover detection scenarios
- **outlier_data_leak_command** - Data leak command detection
- **outlier_data_tampering** - Data tampering detection
- **outlier_denial_of_service** - DoS attack detection
- **outlier_insert_anomaly** - Insert operation anomaly detection
- **outlier_massive_grant_case** - Massive privilege grant detection
- **outlier_revoke_anomaly** - Revoke operation anomaly detection
- **outlier_schema_tampering** - Schema modification detection
- **outlier_update_anomaly** - Update operation anomaly detection

## Prerequisites

Before proceeding, ensure you have the following installed:

- PostgreSQL (version 12 or higher recommended)
- Java Runtime Environment (JRE) 21 or higher
- curl (for running outlier stories script)
- jq (for JSON parsing in outlier stories script)

## Troubleshooting

- If you encounter connection errors, verify that PostgreSQL is running and that the credentials in `config.json` are correct.
- Ensure that the SQL scripts execute without errors before running the application.
- Check the application's logs for additional debugging information.
- For outlier stories script issues, check `outlier_stories_run.log` for detailed execution logs.

## 🔄 Latest Changes

### Version 0.0.1-SNAPSHOT (GDP Lab Edition)
- GDP Lab specific distribution with outlier focus
- Includes standard content packs for all major databases
- Includes all outlier detection content packs in gdp_lab_outliers folder
- Automated outlier stories execution script (run_outlier_stories.sh)
- Database initialization and migration scripts
- Configuration files and utility scripts bundled
- Simplified deployment process with single tar.gz archive

## Support

For further assistance, refer to the documentation or contact the development team.