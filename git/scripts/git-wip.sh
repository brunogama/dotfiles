#!/bin/bash

echo "--- WIP for main repo ---"
git add -A && git commit -m "WIP" --no-verify && git reset HEAD~ || true

echo "--- WIP for submodules ---"
git submodule foreach --recursive "
    if [ \$(git status --porcelain | wc -l) -gt 0 ]; then
        echo \"WIP in submodule: \$sm_path\" && \
        git add -A && git commit -m \"WIP\" --no-verify || true && \
        git reset HEAD~ || true
    else
        echo \"No changes to WIP in submodule: \$sm_path\"
    fi"