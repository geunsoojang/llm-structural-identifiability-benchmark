#!/usr/bin/env bash
set -u

JULIA_CMD="${JULIA_CMD:-julia}"
PROJECT_ARG="${PROJECT_ARG:-}"
MAX_JOBS="${MAX_JOBS:-2}"

mkdir -p result run_logs

run_one() {
    script="$1"
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
    return "$status"
}

active=0
failed=0

while IFS= read -r script; do
    [ -z "$script" ] && continue

    run_one "$script" &
    active=$((active + 1))

    if [ "$active" -ge "$MAX_JOBS" ]; then
        wait -n
        status=$?
        active=$((active - 1))
        if [ "$status" -ne 0 ]; then
            failed=1
        fi
    fi
done < script_list.txt

while [ "$active" -gt 0 ]; do
    wait -n
    status=$?
    active=$((active - 1))
    if [ "$status" -ne 0 ]; then
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    echo "At least one run failed. Check ./run_logs"
    exit 1
fi

echo "Done. Results are in ./result"
