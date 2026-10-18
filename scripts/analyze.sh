#!/usr/bin/env bash

# Task 07: analyze a log file.
# Usage: ./scripts/analyze.sh FILE

set -u

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 FILE"
    exit 1
fi

file="$1"
if [[ ! -f "$file" ]]; then
    echo "Error: file not found: $file"
    exit 1
fi

total_error="$(grep -c 'ERROR' "$file")"
top_code="$(grep 'ERROR' "$file" | sed -E 's/.*code=([0-9]+).*/\1/' | sort | uniq -c | sort -rn | head -1 | awk '{print $2}')"

echo "Total ERROR: $total_error"
echo "Top Code: $top_code"
