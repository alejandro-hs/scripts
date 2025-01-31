#!/bin/bash

# Script to extract table names from Java @Table annotations and save to TSV files

# Set the project directory path
PROJECT_DIR=~/Projects/core-api

# Change to the project directory
cd "$PROJECT_DIR" || {
    echo "Error: Could not change to directory $PROJECT_DIR"
    exit 1
}

# Create output directory if it doesn't exist
mkdir -p module-db-tables

# Function to extract table names from a module
extract_table_names() {
    local module=$1
    
    # Find all @Table annotations and extract table names
    grep -Eohr "@Table\(name[[:space:]]*=[[:space:]]*\"[a-z0-9_]+\"\)" "$module" |
        grep -Eoh "\"[a-z0-9_]+\"" |
        grep -Eoh "[a-z0-9_]+" |
        sort |
        uniq > "module-db-tables/${module%/}.tsv"
    
    # Report number of tables found
    local count=$(wc -l < "module-db-tables/${module%/}.tsv")
    echo "Found $count tables in $module"
}

# Process each module directory
for module in */; do
    extract_table_names "$module"
done
