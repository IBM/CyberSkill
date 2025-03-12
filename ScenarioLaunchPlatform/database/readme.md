# README

## Prerequisites

Before proceeding, ensure you have the following installed:

- PostgreSQL (version 12 or higher recommended)
- Java Runtime Environment (JRE) 11 or higher

## Step 1: Set Up the Database

1. Open a terminal or command prompt.
2. Connect to your PostgreSQL database using the `psql` command or a database GUI tool.
3. Run the provided SQL file :
   ```sh
   psql -U your_username -d your_database -f tables.sql
   ```
   Replace `your_username` with your PostgreSQL username and `your_database` with the target database name.
4. If your system requires patching then run the patches files in order:
   ```sh
   psql -U your_username -d your_database -f tables.sql
    ```


## Step 2: Configure the JSON File

1. Locate the provided configuration file (`config.json`).
2. Open it in a text editor.
3. Update the necessary fields, such as database connection details to suit your environment. Example:
   ```json
   {
    "config.version": "1.00",
    "server": {
        "port": 80,
        "host": "localhost"
    },
    "systemDatabaseController": {
        "host": "127.0.0.1",
        "port": 5432,
        "database": "slp",
        "user": "postgres",
        "password": "postgres",
        "maxConnections": 10
    }
}
   ```

## Step 3: Run the Application

1. Open a terminal or command prompt.
2. Navigate to the directory containing the JAR file.
3. Execute the following command to run and view logs:
   ```sh
   java -jar slp-0.0.1-SNAPSHOT.jar config.json
   ```
4. Execute the following command to run in background:
   ```sh
   nohup java -jar slp-0.0.1-SNAPSHOT.jar config.json &
   ```
   Ensure `slp-0.0.1-SNAPSHOT.jar.jar` and `config.json` are in the same directory, or provide the full path to `config.json`.

## Troubleshooting

- If you encounter connection errors, verify that PostgreSQL is running and that the credentials in `config.json` are correct.
- Ensure that the SQL scripts execute without errors before running the application.
- Check the application's logs for additional debugging information.

## Support

For further assistance, refer to the documentation or contact the development team.

