#!/usr/bin/env bash
# Execute the locally reproducible GitHub Actions job graph for this repository.
set -euo pipefail

usage() {
	cat <<'EOF'
Usage: scripts/local-ci.sh [options]

Options:
  --skip-remote-only       Skip Codecov and GitHub API stages (default).
  --include-remote-only    Enable Codecov and close-prs with supplied credentials.
  --include-destructive    Run the Nix installation stage in a disposable macOS VM.
  --keep-workspace         Preserve the temporary workspace and results report.
  -h, --help               Show this help.

Environment:
  ACT_IMAGE                Ubuntu act image (default: ghcr.io/catthehacker/ubuntu:full-latest).
  CODECOV_TOKEN            Optional token used only with --include-remote-only.
  GITHUB_TOKEN             Required for the close-prs stage.
  LOCAL_CI_CLOSE_EVENT     Required pull_request_target event JSON for close-prs.
EOF
}

skip_remote_only=1
include_destructive=0
keep_workspace=0
failed=0

while (($#)); do
	case "$1" in
	--skip-remote-only) skip_remote_only=1 ;;
	--include-remote-only) skip_remote_only=0 ;;
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
artifacts="$run_root/artifacts"
results="$run_root/results.tsv"
report="$run_root/results.md"
local_workflows="$workspace/.local-ci"
act_image="${ACT_IMAGE:-ghcr.io/catthehacker/ubuntu:full-latest}"

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

render_report() {
	{
		printf '| Workflow | Cell | Stage | Status | Notes |\n'
		printf '|---|---|---|---|---|\n'
		awk -F '\t' \
			'{ printf "| %s | %s | %s | %s | %s |\\n", $1, $2, $3, $4, $5 }' \
			"$results"
	} >"$report"
	cat "$report"
	printf '\nResults report: %s\nArtifacts: %s\n' "$report" "$artifacts"
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
	mkdir -p "$artifacts" "$local_workflows"
	: >"$results"

	python3 - \
		"$workspace/.github/workflows/ci.yml" \
		"$local_workflows/ci.local.yml" \
		"$skip_remote_only" <<'PY'
from pathlib import Path
import re
import sys

source = Path(sys.argv[1]).read_text()
destination = Path(sys.argv[2])
skip_remote_only = sys.argv[3].lower()

permissions = "permissions:\n  contents: read\n"
if permissions not in source:
    raise SystemExit("Cannot locate the CI permissions block.")
source = source.replace(
    permissions,
    f"{permissions}\nenv:\n  LOCAL_CI_SKIP_REMOTE_ONLY: {skip_remote_only}\n",
    1,
)

codecov = "      - name: Upload coverage to Codecov\n"
if codecov not in source:
    raise SystemExit("Cannot locate the Codecov stage.")
source = source.replace(
    codecov,
    f"{codecov}        if: env.LOCAL_CI_SKIP_REMOTE_ONLY != 'true'\n",
    1,
)

# This shell script enforces the needs graph. Removing needs permits act to
# execute a selected Ubuntu job without emulating its macOS dependency in Linux.
source = re.sub(r"(?m)^    needs: [^\n]+\n", "", source)
destination.write_text(source)
PY
}

macos_available() {
	[[ "$(uname -s)" == Darwin ]] &&
		command -v brew >/dev/null 2>&1 &&
		command -v python3.11 >/dev/null 2>&1
}

macos_validate() (
	cd "$workspace"
	brew install shellcheck jq
	python3.11 -m pip install --upgrade pip uv pre-commit
	SKIP=trailing-whitespace,end-of-file-fixer pre-commit run --all-files
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
	python3.11 -m pip install --upgrade pip uv
	./install --dry-run
	bin/core/link-dotfiles.py --dry-run
	for script in bin/core/* bin/credentials/* bin/git/*; do
		if [[ -x "$script" && -f "$script" ]]; then
			"$script" --help >/dev/null || true
		fi
	done
)

macos_integration() (
	cd "$workspace"
	brew install bats-core
	mkdir -p tests/helpers
	for library in bats-support bats-assert bats-file; do
		git clone "https://github.com/bats-core/${library}.git" \
			"tests/helpers/${library}" || true
	done
	bats --tap tests/integration/core/test_install.bats
	bats --tap tests/integration/core/test_work_mode.bats
)

act_ci_job() {
	local job="$1"
	local -a secrets=()
	if [[ -n "${CODECOV_TOKEN:-}" ]]; then
		secrets+=(--secret "CODECOV_TOKEN=$CODECOV_TOKEN")
	fi
	act workflow_dispatch \
		--directory "$workspace" \
		--workflows "$local_workflows/ci.local.yml" \
		--job "$job" \
		--platform "ubuntu-latest=$act_image" \
		--container-architecture linux/amd64 \
		--artifact-server-path "$artifacts" \
		--env "LOCAL_CI_SKIP_REMOTE_ONLY=$skip_remote_only" \
		"${secrets[@]}"
}

act_qa_job() {
	act pull_request \
		--directory "$workspace" \
		--workflows "$workspace/.github/workflows/qa.yml" \
		--job deterministic-qa \
		--platform "ubuntu-latest=$act_image" \
		--container-architecture linux/amd64 \
		--artifact-server-path "$artifacts"
}

act_close_prs_job() {
	act pull_request_target \
		--directory "$workspace" \
		--workflows "$workspace/.github/workflows/close-prs.yml" \
		--job close \
		--eventpath "$LOCAL_CI_CLOSE_EVENT" \
		--platform "ubuntu-latest=$act_image" \
		--container-architecture linux/amd64 \
		--secret "GITHUB_TOKEN=$GITHUB_TOKEN"
}

prepare_workspace

mac_validation_passed=0
if macos_available; then
	if run_stage CI 'macos-latest / Python 3.11' validate macos_validate; then
		mac_validation_passed=1
	fi
else
	warn 'macOS jobs require native macOS, Homebrew, and python3.11.'
	record_skip CI 'macos-latest / Python 3.11' validate \
		'requires native macOS, Homebrew, and python3.11'
fi

if ((mac_validation_passed)); then
	if command -v nix >/dev/null 2>&1; then
		if run_stage CI macos-latest validate-nix macos_validate_nix; then
			if ((include_destructive)); then
				run_stage CI macos-latest install-nix-macos macos_install_nix || true
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
	run_stage CI 'macos-latest / Python 3.11' test-macos macos_test || true
	run_stage CI macos-latest test-integration-macos macos_integration || true
else
	record_skip CI macos-latest validate-nix 'validate failed or was unavailable'
	record_skip CI macos-latest install-nix-macos 'validate-nix was not run'
	record_skip CI 'macos-latest / Python 3.11' test-macos 'validate was not passed'
	record_skip CI macos-latest test-integration-macos 'validate was not passed'
fi

require_command act
require_command docker
docker info >/dev/null

run_stage CI 'ubuntu-latest / Python 3.11' test-linux act_ci_job test-linux || true
if run_stage CI 'ubuntu-latest / Python 3.11' test-python act_ci_job test-python; then
	run_stage CI 'ubuntu-latest / Python 3.11' mutation-testing \
		act_ci_job mutation-testing || true
else
	record_skip CI 'ubuntu-latest / Python 3.11' mutation-testing 'test-python failed'
fi
run_stage CI ubuntu-latest test-integration-linux act_ci_job test-integration-linux || true
run_stage CI ubuntu-latest documentation act_ci_job documentation || true
run_stage 'Agent repository QA' 'ubuntu-latest / setup-uv@v6' \
	deterministic-qa act_qa_job || true

if ((skip_remote_only)); then
	record_skip 'Close pull requests' ubuntu-latest close \
		'remote GitHub API operation; use --include-remote-only'
elif [[ -z "${GITHUB_TOKEN:-}" || -z "${LOCAL_CI_CLOSE_EVENT:-}" ]]; then
	record_skip 'Close pull requests' ubuntu-latest close \
		'requires GITHUB_TOKEN and LOCAL_CI_CLOSE_EVENT'
else
	run_stage 'Close pull requests' ubuntu-latest close act_close_prs_job || true
fi

render_report
((failed == 0))
