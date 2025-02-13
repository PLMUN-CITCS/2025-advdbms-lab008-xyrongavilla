#!/bin/bash

declare -a files
directory="bookstore_database"
SQL_FILES=("create_bookstore_schema.sql" "insert_bookstore_data.sql" "query_bookstore_data.sql") # Array of filenames

for file in "${files[@]}"; do  # Important: Quote "${files[@]}"
filepath="$directory/$file" # Construct the full path
if [ -f "$filepath" ]; then
    echo "$filepath exists"
else
    echo "$filepath does not exist"
fi
done