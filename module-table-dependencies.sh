#!/bin/bash

# Set the project directory path
PROJECT_DIR=~/Projects/core-api

# Change to the project directory
cd "$PROJECT_DIR" || exit 1

# Iterate through all directories
for module in */; do
    # Extract table count for each directory
    table_count=$(grep -Eohr "@Table\(name[[:space:]]*=[[:space:]]*\"[a-z0-9_]+\"\)" "$module" |
                  grep -Eoh "\"[a-z0-9_]+\"" |
                  grep -Eoh "[a-z0-9_]+" |
                  sort |
                  uniq |
                  wc -l)

    # Only output directories that have tables (count > 0)
    if [ "$table_count" -gt 0 ]; then
        printf "%-20s\t%d\n" "${module%/}" "$table_count"
    fi
done
