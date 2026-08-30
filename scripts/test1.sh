
read -sp "Password: " my_pass
export PGPASSWORD="$my_pass"

find ./test/test1 -type f -name "*.sql" -print0 |
while IFS= read -r -d '' file; do
    if [[ ! -f "$file" ]]; then
        echo "Error: SQL file not found: $file"
        exit 1
    fi

    echo "========================================"
    echo "Running: $file"
    echo "========================================"

    psql -U snap2card -d snap2card -h localhost \
        -v ON_ERROR_STOP=1 \
        -f "$file" || exit 1

    echo "Completed: $file"
    echo
done

echo "All SQL files executed successfully."
unset PGPASSWORD
unset my_pass