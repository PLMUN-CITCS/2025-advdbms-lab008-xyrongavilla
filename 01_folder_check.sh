#!/bin/bash

directory="bookstore_database"

if [ -d "$directory" ]; then
echo "Folder exists"
else
echo "Folder does not exist"
fi