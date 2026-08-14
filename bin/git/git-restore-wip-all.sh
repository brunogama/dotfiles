#!/bin/bash

git restore-wip
git submodule foreach --recursive "
    echo \"Restoring WIP in submodule: \$sm_path\" && \
    git restore-wip"
