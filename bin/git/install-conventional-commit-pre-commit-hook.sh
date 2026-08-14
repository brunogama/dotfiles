#!/usr/bin/env bash
# shellcheck shell=bash

set -euo pipefail

# shellcheck source=/dev/null
source "$HOME/.local/bin/prints"

repo_path="${1:-$(pwd)}"
repo_root="$(git -C "$repo_path" rev-parse --show-toplevel)"
DOTFILES_ROOT="${DOTFILES_ROOT:-$HOME/.config-fixing-dot-files-bugs}"
hook="$DOTFILES_ROOT/bin/git/git-hooks/pre-commit-conventional-commit-msg"

install_hook() {
	local target_repo="$1"
	local hooks_dir
	hooks_dir="$(git -C "$target_repo" rev-parse --git-path hooks)"
	if [[ "$hooks_dir" != /* ]]; then
		hooks_dir="$target_repo/$hooks_dir"
	fi
	local hook_file="$hooks_dir/pre-commit"

	mkdir -p "$hooks_dir"

	if [[ -f "$hook_file" ]]; then
		pwarning "A pre-commit hook already exists in $target_repo"
		read -r -n 1 -p "Overwrite or merge? [o/m] " response
		printf '\n'

		case "$response" in
		[Oo])
			printf '#!/usr/bin/env bash\n\n# %s\n%s\n' "$0" "$hook" >"$hook_file"
			;;
		[Mm])
			printf '\n# %s\n%s\n' "$0" "$hook" >>"$hook_file"
			;;
		*)
			pwarning "Cancelled without changing $hook_file"
			return 0
			;;
		esac
	else
		printf '#!/usr/bin/env bash\n\n# %s\n%s\n' "$0" "$hook" >"$hook_file"
	fi

	chmod +x "$hook_file"
	psuccess "Installed $0 hook in $target_repo"
}

if [[ ! -x "$hook" ]]; then
	echo "Missing conventional commit hook: $hook" >&2
	exit 1
fi

install_hook "$repo_root"

if [[ -f "$repo_root/.gitmodules" ]]; then
	pwarning "Installing hooks in submodules..."
	while IFS= read -r -d '' entry; do
		submodule="${entry#*$'\n'}"
		submodule_path="$repo_root/$submodule"

		if git -C "$submodule_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
			install_hook "$(git -C "$submodule_path" rev-parse --show-toplevel)"
		else
			pwarning "Skipping $submodule - not initialized"
		fi
	done < <(git -C "$repo_root" config --null --file .gitmodules --get-regexp path || true)
fi

install_gitmessage() {
	local target_repo="$1"
	local template_path="$target_repo/.gitmessage"

	cat >"$template_path" <<'EOL'
# <type>[(scope)][!]: <description>
# |<----   Using a Maximum Of 50 Characters   ---->|

# [optional body]
# |<----   Try To Limit Each Line to a Maximum Of 72 Characters   ---->|

# [optional footer(s)]
# BREAKING CHANGE: <description>
# Fixes: #<issue number>

# feat: A new feature
# fix: A bug fix
# docs: Documentation only changes
# style: Changes that do not affect the meaning of the code
# refactor: A code change that neither fixes a bug nor adds a feature
# perf: A code change that improves performance
# test: Adding missing tests or correcting existing tests
# build: Changes that affect the build system or external dependencies
# ci: Changes to CI configuration files and scripts
# chore: Changes to the build process or auxiliary tools
EOL

	git -C "$target_repo" config --local commit.template "$template_path"
	psuccess "Created .gitmessage template"
}

read -r -n 1 -p "Install conventional commit template? [y/n] " response
printf '\n'
if [[ "$response" =~ ^[Yy]$ ]]; then
	install_gitmessage "$repo_root"
fi

psuccess "Hook installation completed!"
