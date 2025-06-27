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
3. Update the necessary fields, such as database connection details and application settings. Example:
   ```json
   {
       "db_host": "localhost",
       "db_port": 5432,
       "db_name": "your_database",
       "db_user": "your_username",
       "db_password": "your_password"
   }
   ```

## Step 3: Run the Application

1. Open a terminal or command prompt.
2. Navigate to the directory containing the JAR file.
3. Execute the following command:
   ```sh
   java -jar application.jar config.json
   ```
   Ensure `application.jar` and `config.json` are in the same directory, or provide the full path to `config.json`.

## Troubleshooting

- If you encounter connection errors, verify that PostgreSQL is running and that the credentials in `config.json` are correct.
- Ensure that the SQL scripts execute without errors before running the application.
- Check the application's logs for additional debugging information.

## Support

For further assistance, refer to the documentation or contact the development team.

