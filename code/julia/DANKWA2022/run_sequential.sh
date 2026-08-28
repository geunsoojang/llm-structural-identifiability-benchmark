#!/usr/bin/env bash
set -u

JULIA_CMD="${JULIA_CMD:-julia}"
PROJECT_ARG="${PROJECT_ARG:-}"
LIST_FILE="${LIST_FILE:-script_list_sequential.txt}"

mkdir -p result run_logs

while IFS= read -r script; do
    [ -z "$script" ] && continue
    echo "==> Running $script"
    start=$(date +%s)
    if [ -n "$PROJECT_ARG" ]; then
        $JULIA_CMD "$PROJECT_ARG" "$script" > "run_logs/${script%.jl}.console.log" 2>&1
    else
        $JULIA_CMD "$script" > "run_logs/${script%.jl}.console.log" 2>&1
    fi
    status=$?
    end=$(date +%s)
    echo "$script,status=$status,wall_seconds=$((end - start))"
    if [ "$status" -ne 0 ]; then
        echo "Failed: $script"
        echo "Check run_logs/${script%.jl}.console.log"
        exit "$status"
    fi
done < "$LIST_FILE"

echo "Done. Results are in ./result"
