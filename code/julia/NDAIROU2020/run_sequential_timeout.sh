#!/usr/bin/env bash
set -u

JULIA_CMD="${JULIA_CMD:-julia}"
PROJECT_ARG="${PROJECT_ARG:-}"
LIST_FILE="${LIST_FILE:-script_list_sequential.txt}"
TIME_LIMIT="${TIME_LIMIT:-3600}"

mkdir -p result run_logs
summary_file="run_logs/timeout_summary.csv"
echo "script,status,wall_seconds,time_limit_seconds" > "$summary_file"

while IFS= read -r script; do
    [ -z "$script" ] && continue
    echo "==> Running $script with TIME_LIMIT=${TIME_LIMIT}s"
    start=$(date +%s)
    cmd=("$JULIA_CMD")
    if [ -n "$PROJECT_ARG" ]; then
        cmd+=("$PROJECT_ARG")
    fi
    cmd+=("$script")
    timeout "$TIME_LIMIT" "${cmd[@]}" > "run_logs/${script%.jl}.console.log" 2>&1
    status=$?
    end=$(date +%s)
    wall=$((end - start))
    echo "$script,$status,$wall,$TIME_LIMIT" >> "$summary_file"
    if [ "$status" -eq 124 ]; then
        echo "Timed out after ${TIME_LIMIT}s: $script"
        echo "Continuing to next script."
        continue
    fi
    if [ "$status" -ne 0 ]; then
        echo "Failed: $script"
        echo "Check run_logs/${script%.jl}.console.log"
        exit "$status"
    fi
    echo "$script,status=$status,wall_seconds=$wall"
done < "$LIST_FILE"

echo "Done. Results are in ./result"
echo "Summary: $summary_file"