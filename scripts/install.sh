#!/usr/bin/env bash

set -e

if [[ -z "$1" ]]; then
    echo "Usage: $0 <sql_files_list>"
    exit 1
fi

if [[ ! -f "$1" ]]; then
    echo "Error: File not found: $1"
    exit 1
fi

read -sp "Password: " my_pass
export PGPASSWORD="$my_pass"

psql -U snap2card -d snap2card -h localhost -tc "
    DROP SCHEMA IF EXISTS public CASCADE;
    CREATE SCHEMA public;
"

while IFS= read -r file; do
    
    # Skip empty lines and comments
    [[ -z "$file" || "$file" =~ ^[[:space:]]*# ]] && continue

    if [[ ! -f "$file" ]]; then
        echo "Error: SQL file not found: $file"
        exit 1
    fi

    echo "========================================"
    echo "Running: $file"
    echo "========================================"

    psql -U snap2card -d snap2card -h localhost \
        -v ON_ERROR_STOP=1 \
        -f "$file"

    echo "Completed: $file"
    echo
done < "$1"

echo "All SQL files executed successfully."
unset PGPASSWORD
unset my_pass