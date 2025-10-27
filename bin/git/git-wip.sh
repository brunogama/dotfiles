#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Cleanup handler
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "Error: Script failed with exit code $exit_code" >&2
    fi
}

trap cleanup EXIT INT TERM

# WIP for main repository
echo "--- WIP for main repo ---"
if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "WIP" --no-verify
    git reset HEAD~
else
    echo "No changes to WIP in main repo"
fi

# WIP for submodules
echo "--- WIP for submodules ---"
git submodule foreach --recursive "
    set -euo pipefail
    if [ -n \"\$(git status --porcelain)\" ]; then
        echo \"WIP in submodule: \$sm_path\"
        git add -A
        git commit -m \"WIP\" --no-verify
        git reset HEAD~
    else
        echo \"No changes to WIP in submodule: \$sm_path\"
    fi
"
