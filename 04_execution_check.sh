#!/bin/bash

# Database credentials (environment variables are recommended)
DB_HOST="${DB_HOST:-127.0.0.1}"  # Default to 127.0.0.1 if not set
DB_PORT="${DB_PORT:-4000}"      # Default to 4000 if not set
DB_USER="${DB_USER:-root}"      # Default to root if not set

# Directory containing the SQL scripts
SQL_DIR="bookstore_database"

# Array of SQL script filenames (or use a wildcard)
declare -a SQL_FILES
#SQL_FILES=("$SQL_DIR"/*.sql)  # Dynamically get all .sql files
SQL_FILES=("create_bookstore_schema.sql" "insert_bookstore_data.sql" "query_bookstore_data.sql") # Array of filenames

# Loop through the SQL files
for sql_file in "${SQL_FILES[@]}"; do
  sql_filepath="$SQL_DIR/$sql_file"

  # Check if the SQL file exists
  if [ ! -f "$sql_filepath" ]; then
    echo "Error: SQL file '$sql_filepath' not found."
    continue  # Skip to the next file
  fi

  echo "Executing SQL script: $sql_filepath"

  # Execute the SQL script using mysql and capture the output
  output=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" < "$sql_filepath" 2>&1) # Capture stderr

  exit_code=$?

  if [ "$exit_code" -eq 0 ]; then
    echo "SQL script '$sql_filepath' executed successfully."
    echo "Output:"
    echo "$output"  # Print the output of the SQL script
  else
    echo "Error: Failed to execute SQL script '$sql_filepath'."
    echo "Error Output:"
    echo "$output" # Print the error output
    # Optionally exit the script on error:
    exit 1
  fi
done

echo "Finished executing SQL scripts."

exit 0