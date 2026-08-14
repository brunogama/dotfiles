#!/bin/bash
set -euo pipefail

if [ -z "${1:-}" ]; then
    echo "Error: Please specify a submodule path" >&2
    exit 1
fi
git submodule deinit -- "$1" && git rm -- "$1"
