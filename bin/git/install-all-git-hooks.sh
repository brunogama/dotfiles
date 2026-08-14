#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

# shellcheck source=/dev/null
source "$HOME/.local/bin/prints"

# Parse options
repo_path="$(pwd)"
while getopts "r:" opt; do
	case "$opt" in
	r)
		repo_path="$OPTARG"
		;;
	*)
		echo "Usage: $0 [-r repository_path]" >&2
		exit 1
		;;
	esac
done

repo_root="$(git -C "$repo_path" rev-parse --show-toplevel)"
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

installation_script="$DOTFILES_ROOT/bin/git/install-conventional-commit-pre-commit-hook.sh"

if [[ ! -x "$installation_script" ]]; then
	echo "Missing hook installer: $installation_script" >&2
	exit 1
fi

pwarning "Installing git hooks in $repo_root"
"$installation_script" "$repo_root"
