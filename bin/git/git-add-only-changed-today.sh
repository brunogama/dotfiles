#!/usr/bin/env bash
set -euo pipefail

git diff --name-only --diff-filter=ACMRT --since="yesterday" | while IFS= read -r file; do
    git add -- "$file"
done
