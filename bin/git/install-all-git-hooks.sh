#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

# shellcheck source=/dev/null
source "$HOME/.local/bin/prints"

repo_path="${1:-$(pwd)}"
repo_root="$(git -C "$repo_path" rev-parse --show-toplevel)"
DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.config-fixing-dot-files-bugs}"

installation_script="$DOTFILES_ROOT/bin/git/install-conventional-commit-pre-commit-hook.sh"

if [[ ! -x "$installation_script" ]]; then
	echo "Missing hook installer: $installation_script" >&2
	exit 1
fi

pwarning "Installing git hooks in $repo_root"
"$installation_script" "$repo_root"
