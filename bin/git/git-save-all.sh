#!/usr/bin/env bash

# chore!: SAVE POINT
git add . && git save-point
git submodule foreach --recursive "
    echo \"Saving WIP in submodule: \$sm_path\" && \
    git add . && git save-point || true"
