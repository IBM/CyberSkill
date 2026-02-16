# Latest README

This folder contains the latest version of the application

## 📥 Latest Release Contains

✔️ **JAR file** - slp-0.0.1-SNAPSHOT.jar
✔️ **Database folder** - Complete SQL scripts and patches
✔️ **Content packs folder** - All scenario content packs
✔️ **Scripts folder** - Utility and deployment scripts
✔️ **Config file** - config.json
✔️ **Connection Validator** - connectionValidator.sh
✔️ **Restart Scripts** - restartSLP.sh (Linux/Unix) and restartSLP.bat (Windows)
✔️ **Readme file** - This documentation

## 📦 Distribution Package

The distribution is packaged as `slp-0.0.1-SNAPSHOT-distribution.tar.gz` and includes:
- Application JAR with all dependencies
- Database initialization and migration scripts
- Content packs for various database scenarios
- Configuration templates
- Utility scripts for management and deployment

## 🔨 Building the Distribution

To build the distribution package from source:

```sh
mvn clean package
```

This will:
1. Compile the Java source code
2. Package the application as a JAR file
3. Create a tar.gz archive in the `latest/` folder with all required files

## Prerequisites

Before proceeding, ensure you have the following installed and have extracted the contents of the tar file:

- PostgreSQL (version 12 or higher recommended)
- Java Runtime Environment (JRE) 11 or higher

## 🦾 Extract tar contents

```sh
tar -xzf slp-0.0.1-SNAPSHOT-distribution.tar.gz
```

## 📋 Installation Steps

1. **Extract the distribution package:**
   ```sh
   tar -xzf slp-0.0.1-SNAPSHOT-distribution.tar.gz
   cd slp-0.0.1-SNAPSHOT-distribution
   ```

2. **Configure the application:**
   - Edit `config.json` with your database connection details
   - Update any environment-specific settings

3. **Initialize the database:**
   - Run the SQL scripts in the `database/ScenarioLaunchPlatform_CORE/` folder
   - Apply any necessary patches from `database/ScenarioLaunchPlatform_CORE/patches/`

4. **Set script permissions:**
   ```sh
   chmod +x connectionValidator.sh restartSLP.sh
   chmod +x scripts/*.sh
   ```

5. **Start the application:**
   
   **Linux/Unix:**
   ```sh
   java -jar slp-0.0.1-SNAPSHOT.jar
   ```
   
   Or use the restart script:
   ```sh
   ./restartSLP.sh
   ```
   
   **Windows:**
   ```cmd
   java -jar slp-0.0.1-SNAPSHOT.jar
   ```
   
   Or use the restart script:
   ```cmd
   restartSLP.bat
   ```

## 🔄 Latest Changes

### Version 0.0.1-SNAPSHOT
- Automated distribution packaging with Maven Assembly Plugin
- Includes all required folders: database, contentpacks, scripts
- Configuration files and utility scripts bundled
- Cross-platform restart scripts (Linux/Unix and Windows)
- Simplified deployment process with single tar.gz archive

## Troubleshooting

- If you encounter connection errors, verify that PostgreSQL is running and that the credentials in `config.json` are correct.
- Ensure that the SQL scripts execute without errors before running the application.
- Check the application's logs for additional debugging information.

## Support

For further assistance, refer to the documentation or contact the development team.

