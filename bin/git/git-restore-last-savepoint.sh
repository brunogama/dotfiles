#!/usr/bin/env bash

# Restore from reflog last commit that has "chore!: SAVE POINT" in the message
commit_hash=$(git reflog --pretty="%H %s" | grep "chore!: SAVE POINT" | head -n1 | cut -d" " -f1)
if [ -n "$commit_hash" ]; then
    echo "Restoring SAVE POINT commit: $commit_hash"
    git cherry-pick "$commit_hash"
    # Remove the last SAVE POINT commit
    git reset --hard HEAD~1
else
    echo "No SAVE POINT commit found in reflog!"
    exit 1
fi
