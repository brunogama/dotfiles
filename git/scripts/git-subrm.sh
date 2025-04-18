#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Please specify a submodule path" && exit 1
fi
git submodule deinit $1 && git rm $1