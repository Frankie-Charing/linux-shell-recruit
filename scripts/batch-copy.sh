#!/usr/bin/env bash

# Task 08: copy multiple files into a destination directory.
# Usage: ./scripts/batch-copy.sh DEST FILE...

destination="$1"
shift

mkdir -p "$destination"

for file in "$@"
do
    cp "$file" "$destination/"
done
