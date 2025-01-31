#!/bin/bash

# Set the project directory path
PROJECT_DIR=~/Projects/core-api

# Check if module name is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <module_name>"
    exit 1
fi

MODULE_FILTER="$1"

# Change to the project directory
cd "$PROJECT_DIR" || exit 1

# Function to get list of modules with TSV files
get_modules() {
    for dir in */; do
        module=${dir%/}
        if [ -f "module-db-tables/${module}.tsv" ]; then
            echo "$module"
        fi
    done
}

# Function to count common tables between two modules
count_common_tables() {
    local module1=$1
    local module2=$2
    comm -12 "module-db-tables/${module1}.tsv" "module-db-tables/${module2}.tsv" | wc -l
}

# Main loop to compare modules
for module1 in $(get_modules); do
    for module2 in $(get_modules); do
        # Skip comparing module with itself
        [ "$module1" = "$module2" ] && continue

        # Count common tables
        common_count=$(count_common_tables "$module1" "$module2")
        
        # Only process if there are common tables
        if [ "$common_count" -gt 0 ]; then
            printf "%-5d\t%-20s\t%-20s\n" "$common_count" "$module1" "$module2"
        fi
    done
done | sort -rn | grep -E "^[0-9]+\s+${MODULE_FILTER} "
