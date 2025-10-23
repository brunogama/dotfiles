#!/bin/bash

commit_hash=$(git reflog --pretty="%H %s" | grep "WIP" | head -n1 | cut -d" " -f1)
if [ -n "$commit_hash" ]; then
    echo "Restoring WIP commit: $commit_hash"
    git cherry-pick "$commit_hash"
else
    echo "No WIP commit found in reflog!"
    exit 1
fi