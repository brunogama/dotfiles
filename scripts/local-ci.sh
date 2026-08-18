#!/usr/bin/env bash
# Execute locally reproducible macOS CI stages and report GitHub-only stages.
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: scripts/local-ci.sh [options]

Options:
  --include-destructive    Run the Nix installation stage in a disposable macOS VM.
  --keep-workspace         Preserve the temporary workspace and results report.
  -h, --help               Show this help.
EOF
}

include_destructive=0
keep_workspace=0
failed=0

while (($#)); do
	case "$1" in
	--include-destructive) include_destructive=1 ;;
	--keep-workspace) keep_workspace=1 ;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		printf 'Unknown option: %s\n' "$1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if root="$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)"; then
	root_is_git_repository=1
else
	root="$(jj -R "$script_dir/.." root)"
	root_is_git_repository=0
fi
run_root="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-local-ci.XXXXXX")"
workspace="$run_root/workspace"
results="$run_root/results.tsv"
report="$run_root/results.md"

cleanup() {
	if ((keep_workspace)); then
		printf 'Retained local CI workspace: %s\n' "$run_root"
	else
		rm -rf "$run_root"
	fi
}
trap cleanup EXIT

warn() {
	printf 'WARNING: %s\n' "$*" >&2
}

record() {
	printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" >>"$results"
}

record_skip() {
	record "$1" "$2" "$3" skip "$4"
}

run_stage() {
	local workflow="$1"
	local cell="$2"
	local stage="$3"
	shift 3

	local status
	set +e
	(
		set -euo pipefail
		"$@"
	)
	status=$?
	set -e

	if ((status == 0)); then
		record "$workflow" "$cell" "$stage" pass ''
		return 0
	fi

	record "$workflow" "$cell" "$stage" fail "exit $status"
	failed=1
	return "$status"
}

stage_slug() {
	printf '%s\n' "${1//[^[:alnum:]._-]/_}"
}

materialize_macos_workspace() {
	local destination="$1"
	local home="$2"

	mkdir -p "$destination" "$home/.config" "$home/.cache" \
		"$home/.local/state" "$home/tmp"
	rsync -a --delete --exclude '.git' --exclude '.jj' --exclude '.local-ci' \
		"$root/" "$destination/"
	git -C "$destination" init --quiet
	git -C "$destination" add --all --force
	git -C "$destination" -c user.name='Local CI' -c user.email='local-ci@example.invalid' \
		-c core.hooksPath=/dev/null -c commit.gpgsign=false \
		commit --quiet -m 'Local CI snapshot'
}

run_macos_stage() {
	local workflow="$1"
	local cell="$2"
	local stage="$3"
	local runner="$4"
	local slug
	local stage_workspace
	local home
	shift 4

	slug="$(stage_slug "$stage")"
	stage_workspace="$run_root/workspaces/$slug"
	home="$run_root/homes/$slug"
	materialize_macos_workspace "$stage_workspace" "$home"
	workspace="$stage_workspace" HOME="$home" XDG_CONFIG_HOME="$home/.config" \
		XDG_CACHE_HOME="$home/.cache" XDG_STATE_HOME="$home/.local/state" \
		TMPDIR="$home/tmp" GIT_CONFIG_NOSYSTEM=1 \
		run_stage "$workflow" "$cell" "$stage" "$runner" "$@"
}

render_report() {
	{
		printf '| Workflow | Cell | Stage | Status | Notes |\n'
		printf '|---|---|---|---|---|\n'
		awk -F '\t' \
			'{ printf "| %s | %s | %s | %s | %s |\\n", $1, $2, $3, $4, $5 }' \
			"$results"
	} >"$report"
	cat "$report"
	printf '\nResults report: %s\n' "$report"
}

require_command() {
	command -v "$1" >/dev/null 2>&1 || {
		printf 'Required command not found: %s\n' "$1" >&2
		exit 2
	}
}

prepare_workspace() {
	require_command git
	require_command python3
	require_command rsync

	if ((root_is_git_repository)); then
		git clone --quiet --no-local "$root" "$workspace"
	else
		mkdir -p "$workspace"
	fi
	rsync -a --delete --exclude '.git' --exclude '.jj' --exclude '.local-ci' "$root/" "$workspace/"
	if (( ! root_is_git_repository )); then
		git -C "$workspace" init --quiet
		git -C "$workspace" add --all
		git -C "$workspace" -c user.name='local-ci' -c user.email='local-ci@example.invalid' \
			commit --quiet -m 'local CI snapshot'
	fi
	: >"$results"
}

macos_available() {
	[[ "$(uname -s)" == Darwin ]] &&
		command -v python3.11 >/dev/null 2>&1 &&
		command -v shellcheck >/dev/null 2>&1 &&
		command -v jq >/dev/null 2>&1 &&
		command -v bats >/dev/null 2>&1
}

macos_validate() (
	cd "$workspace"
	local_ci_python="$HOME/.local-ci-venv/bin/python"
	python3.11 -m venv "$HOME/.local-ci-venv"
	"$local_ci_python" -m pip install --upgrade pip uv pre-commit
	SKIP=trailing-whitespace,end-of-file-fixer \
		"$local_ci_python" -m pre_commit run --all-files
	bin/git/hooks/check-lowercase-dirs
	git ls-files | while IFS= read -r file; do
		if [[ -f "$file" && "$file" =~ \.(md|sh|zsh|bash|txt)$ ]]; then
			bin/git/hooks/check-no-emojis "$file"
		fi
	done
	find bin/ -type f \
		\( -name '*.sh' -o -name '*.bash' -o -name '*.zsh' \) -print0 |
		while IFS= read -r -d '' file; do
			shellcheck --severity=error "$file"
		done
	bash -n install
)

macos_validate_nix() (
	cd "$workspace"
	command -v nix >/dev/null
	./bin/core/nix-validate
	dock_defaults="$(nix eval --json .#darwinConfigurations.default.config.system.defaults.dock)"
	jq -e '."autohide-delay" == 0 and ."autohide-time-modifier" == 0' \
		<<<"$dock_defaults"
)

macos_install_nix() (
	cd "$workspace"
	./install --nix --yes --username "$USER" --machine-name 'Dotfiles CI'
	grep -Fq "username = \"$USER\";" nix/host.nix
	grep -Fq 'configurationName = "dotfiles-ci";' nix/host.nix
	grep -Fq 'computerName = "Dotfiles CI";' nix/host.nix
	grep -Fq 'hostName = "dotfiles-ci";' nix/host.nix
	grep -Fq 'localHostName = "dotfiles-ci";' nix/host.nix

	profile_path="/etc/profiles/per-user/$USER/bin"
	export PATH="$HOME/.nix-profile/bin:$profile_path:$PATH"
	for path in \
		"$HOME/.zshenv" \
		"$HOME/.config/zsh/.zshrc" \
		"$HOME/.config/starship.toml" \
		"$HOME/.pi/agent/AGENTS.md" \
		"$HOME/.codex/AGENTS.md" \
		"$HOME/.claude/CLAUDE.md"; do
		test -L "$path"
	done
	test -f "$HOME/.config/zsh/.zshrc.zwc"
	ZDOTDIR="$HOME/.config/zsh" zsh -lic \
		'command -v starship >/dev/null && command -v git >/dev/null'

	for command in git home-manager jq rg shellcheck starship zsh; do
		command -v "$command" >/dev/null
	done
	test -x "$HOME/.local/share/dotfiles/npm/current/node_modules/.bin/pi"
	home-manager generations
)

macos_test() (
	cd "$workspace"
	local_ci_python="$HOME/.local-ci-venv/bin/python"
	local_ci_uv="$HOME/.local-ci-venv/bin/uv"
	python3.11 -m venv "$HOME/.local-ci-venv"
	"$local_ci_python" -m pip install --upgrade pip uv
	./install --dry-run
	"$local_ci_uv" run bin/core/link-dotfiles.py --dry-run
	printf '%s\n' 'Skipping script help-message probe outside the GitHub runner.'
)

macos_integration() (
	cd "$workspace"
	bats --tap tests/integration/core/test_install.bats
	bats --tap tests/integration/core/test_work_mode.bats
)

record_github_only_stages() {
	local note='requires a GitHub Actions Linux runner'

	record_skip CI 'ubuntu-latest / Python 3.11' test-linux "$note"
	record_skip CI 'ubuntu-latest / Python 3.11' test-python "$note"
	record_skip CI 'ubuntu-latest / Python 3.11' mutation-testing "$note"
	record_skip CI ubuntu-latest test-integration-linux "$note"
	record_skip CI ubuntu-latest documentation "$note"
	record_skip 'Agent repository QA' 'ubuntu-latest / setup-uv@v6' \
		deterministic-qa "$note"
	record_skip 'Agent repository QA' 'ubuntu-latest / setup-uv@v6' \
		agent-evidence "$note"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
prepare_workspace

mac_validation_passed=0
if macos_available; then
	if run_macos_stage CI 'macos-latest / Python 3.11' validate macos_validate; then
		mac_validation_passed=1
	fi
else
	warn 'macOS jobs require native macOS, Homebrew, and python3.11.'
	record_skip CI 'macos-latest / Python 3.11' validate \
		'requires native macOS, Homebrew, and python3.11'
fi

if ((mac_validation_passed)); then
	if command -v nix >/dev/null 2>&1; then
		if run_macos_stage CI macos-latest validate-nix macos_validate_nix; then
			if ((include_destructive)); then
				run_macos_stage CI macos-latest install-nix-macos macos_install_nix || true
			else
				record_skip CI macos-latest install-nix-macos \
					'requires --include-destructive in a disposable macOS VM'
			fi
		else
			record_skip CI macos-latest install-nix-macos 'validate-nix failed'
		fi
	else
		record_skip CI macos-latest validate-nix 'Nix is not installed'
		record_skip CI macos-latest install-nix-macos 'requires validate-nix'
	fi
	run_macos_stage CI 'macos-latest / Python 3.11' test-macos macos_test || true
	run_macos_stage CI macos-latest test-integration-macos macos_integration || true
else
	record_skip CI macos-latest validate-nix 'validate failed or was unavailable'
	record_skip CI macos-latest install-nix-macos 'validate-nix was not run'
	record_skip CI 'macos-latest / Python 3.11' test-macos 'validate was not passed'
	record_skip CI macos-latest test-integration-macos 'validate was not passed'
fi

record_github_only_stages

record_skip 'Close pull requests' ubuntu-latest close \
	'requires GitHub Actions'

render_report
((failed == 0))
fi
