# Git Reword Alias - Technical Specification

## Overview
This specification defines the `git-reword` script - an FZF-based interactive tool for rewriting git commit messages on the current branch.

## Script Metadata

### File Location
`bin/git/git-reword`

### Shebang and Initialization
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

### Exit Codes
```bash
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1
readonly EXIT_MISSING_DEPENDENCY=2
readonly EXIT_USER_CANCELLED=130
readonly EXIT_DIRTY_TREE=3
readonly EXIT_INVALID_MESSAGE=4
```

## Color Constants
```bash
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_DIM='\033[2m'
readonly COLOR_BOLD='\033[1m'
```

## Dependencies

### Required Tools
1. **fzf** - Fuzzy finder for interactive selection
2. **git** - Version control system

### Dependency Checking
```bash
check_dependencies() {
    local missing_deps=()

    if ! command -v fzf &>/dev/null; then
        missing_deps+=("fzf")
    fi

    if ! command -v git &>/dev/null; then
        missing_deps+=("git")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "missing required dependencies: ${missing_deps[*]}"
        show_installation_instructions
        return "${EXIT_MISSING_DEPENDENCY}"
    fi

    # Check we're in a git repository
    if ! git rev-parse --git-dir &>/dev/null; then
        log_error "not a git repository"
        return "${EXIT_ERROR}"
    fi

    return 0
}
```

## Core Functions

### Get Branch Commits
```bash
get_branch_commits() {
    local base_branch
    local current_branch

    current_branch="$(git rev-parse --abbrev-ref HEAD)" || return 1

    # Determine base branch
    if git rev-parse --verify main &>/dev/null; then
        base_branch="main"
    elif git rev-parse --verify master &>/dev/null; then
        base_branch="master"
    else
        # If no main/master, show all commits
        git log --oneline --decorate=no --color=never
        return 0
    fi

    # Show commits on current branch that aren't on base
    if [[ "$current_branch" == "$base_branch" ]]; then
        # On base branch, show all commits
        git log --oneline --decorate=no --color=never
    else
        # On feature branch, show commits not in base
        git log --oneline --decorate=no --color=never "${base_branch}..HEAD"
    fi
}
```

### Format for FZF
```bash
format_commit_for_fzf() {
    local line="$1"
    local hash message

    hash="$(echo "$line" | awk '{print $1}')"
    message="$(echo "$line" | cut -d' ' -f2-)"

    # Format: HASH │ MESSAGE
    printf "%s${COLOR_DIM} │ ${COLOR_RESET}%s\n" "$hash" "$message"
}
```

### Generate Preview
```bash
generate_preview() {
    local hash="$1"

    if [[ -z "$hash" ]]; then
        return
    fi

    # Header
    echo -e "${COLOR_CYAN}Commit: ${hash}${COLOR_RESET}"
    echo ""

    # Metadata
    local author date subject

    author="$(git show -s --format='%an <%ae>' "$hash")"
    date="$(git show -s --format='%ar (%ai)' "$hash")"
    subject="$(git show -s --format='%s' "$hash")"

    echo -e "${COLOR_BLUE}Author:${COLOR_RESET} $author"
    echo -e "${COLOR_BLUE}Date:${COLOR_RESET} $date"
    echo ""

    # Full message
    echo -e "${COLOR_BOLD}Message:${COLOR_RESET}"
    git show -s --format='%B' "$hash" | sed 's/^/  /'
    echo ""

    # File statistics
    echo -e "${COLOR_BOLD}Changes:${COLOR_RESET}"
    git show --stat --format='' "$hash" | sed 's/^/  /'
}
```

### Check Commit Status
```bash
check_commit_status() {
    local hash="$1"

    # Check working tree is clean
    if ! git diff-index --quiet HEAD --; then
        log_error "working tree has uncommitted changes"
        log_info "commit or stash changes before reword"
        return "${EXIT_DIRTY_TREE}"
    fi

    # Check if commit has been pushed
    local branches_containing
    branches_containing="$(git branch -r --contains "$hash" 2>/dev/null || true)"

    if [[ -n "$branches_containing" ]]; then
        log_warning "commit $hash has been pushed to:"
        echo "$branches_containing" | sed 's/^/  /'
        echo ""
        log_warning "rewriting pushed commits will require force push"

        read -rp "Continue anyway? (y/N): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "reword cancelled"
            return "${EXIT_USER_CANCELLED}"
        fi
    fi

    return 0
}
```

### Reword HEAD Commit
```bash
reword_head() {
    log_info "rewording HEAD commit (using amend)"

    # Use git commit --amend to reword HEAD
    if git commit --amend --no-verify; then
        log_success "commit message updated"
        return 0
    else
        log_error "failed to amend commit"
        return "${EXIT_ERROR}"
    fi
}
```

### Reword Older Commit
```bash
reword_older_commit() {
    local hash="$1"
    local commit_position

    # Calculate commit position from HEAD
    commit_position="$(git rev-list --count "${hash}..HEAD")"

    log_info "rewording commit $commit_position position(s) back from HEAD"
    log_info "using interactive rebase"

    # Create a temporary script for automatic reword
    local rebase_script
    rebase_script="$(mktemp)"
    trap "rm -f '$rebase_script'" EXIT

    # Generate rebase todo with selected commit marked as "reword"
    git log --reverse --format='%H' "${hash}~1..HEAD" | while IFS= read -r commit; do
        if [[ "$commit" == "$hash" ]]; then
            echo "reword $commit"
        else
            echo "pick $commit"
        fi
    done > "$rebase_script"

    # Execute interactive rebase
    if GIT_SEQUENCE_EDITOR="cat '$rebase_script' >" git rebase -i "${hash}~1"; then
        log_success "commit message updated"
        return 0
    else
        log_error "rebase failed"
        log_info "to abort: git rebase --abort"
        log_info "to continue after fixing conflicts: git rebase --continue"
        return "${EXIT_ERROR}"
    fi
}
```

### Main Selection Logic
```bash
select_commit_and_reword() {
    local commits selection hash

    # Get commits on current branch
    if ! commits="$(get_branch_commits)"; then
        log_error "failed to get branch commits"
        return "${EXIT_ERROR}"
    fi

    if [[ -z "$commits" ]]; then
        log_warning "no commits found on current branch"
        return "${EXIT_ERROR}"
    fi

    # FZF selection with preview
    selection=$(echo "$commits" | fzf \
        --ansi \
        --height=80% \
        --layout=reverse \
        --border \
        --prompt="Select commit to reword > " \
        --header="Use arrows to navigate, Enter to select, Ctrl-C to cancel" \
        --preview="bash -c 'source $(realpath \"$0\") && generate_preview {1}'" \
        --preview-window=right:50% \
        --color="prompt:cyan,header:dim,pointer:green"
    ) || {
        log_info "selection cancelled"
        return "${EXIT_USER_CANCELLED}"
    }

    # Extract hash from selection
    hash="$(echo "$selection" | awk '{print $1}')"

    if [[ -z "$hash" ]]; then
        log_error "failed to extract commit hash"
        return "${EXIT_ERROR}"
    fi

    log_info "selected commit: $hash"

    # Check commit status (dirty tree, pushed commits)
    check_commit_status "$hash" || return $?

    # Determine reword strategy
    local head_hash
    head_hash="$(git rev-parse HEAD)"

    if [[ "$hash" == "$head_hash" ]]; then
        reword_head
    else
        reword_older_commit "$hash"
    fi
}
```

## Logging Functions
```bash
log_error() {
    echo -e "${COLOR_RED}[error]${COLOR_RESET} $*" >&2
}

log_warning() {
    echo -e "${COLOR_YELLOW}[warning]${COLOR_RESET} $*" >&2
}

log_info() {
    echo -e "${COLOR_BLUE}[info]${COLOR_RESET} $*"
}

log_success() {
    echo -e "${COLOR_GREEN}[success]${COLOR_RESET} $*"
}

log_dim() {
    echo -e "${COLOR_DIM}$*${COLOR_RESET}"
}
```

## Error Handling

### Trap Handler
```bash
cleanup() {
    local exit_code=$?

    # Cleanup temporary files
    if [[ -n "${rebase_script:-}" && -f "$rebase_script" ]]; then
        rm -f "$rebase_script"
    fi

    exit "$exit_code"
}

trap cleanup EXIT INT TERM
```

## Main Entry Point
```bash
main() {
    # Check dependencies
    check_dependencies || exit $?

    # Select and reword commit
    select_commit_and_reword
    exit $?
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

## Git Alias Configuration

### Alias Definition
Add to `git/github-flow-aliases.gitconfig`:

```gitconfig
# Interactive commit message reword with FZF
reword = !git-reword
```

## Usage Examples

### Example 1: Reword HEAD
```bash
$ git reword
# FZF opens with commits
# User selects top commit (HEAD)
# Git opens editor with current message
# User edits message, saves, closes
[success] commit message updated
```

### Example 2: Reword Older Commit
```bash
$ git reword
# FZF opens with commits
# User navigates to commit 3 positions back
# Preview shows commit details
# User presses Enter
[info] selected commit: abc1234
[info] rewording commit 3 position(s) back from HEAD
[info] using interactive rebase
# Git opens editor with message
# User edits, saves, closes
# Rebase executes automatically
[success] commit message updated
```

### Example 3: Pushed Commit Warning
```bash
$ git reword
# User selects pushed commit
[warning] commit abc1234 has been pushed to:
  origin/feature-branch
[warning] rewriting pushed commits will require force push
Continue anyway? (y/N): n
[info] reword cancelled
```

## Safety Checks

### 1. Working Tree Clean
```bash
# Before any reword operation
if ! git diff-index --quiet HEAD --; then
    echo "[error] working tree has uncommitted changes"
    exit 3
fi
```

### 2. Pushed Commit Detection
```bash
# Check if commit exists on remote
branches_containing="$(git branch -r --contains "$hash" 2>/dev/null)"
if [[ -n "$branches_containing" ]]; then
    # Show warning and require confirmation
fi
```

### 3. Empty Message Validation
```bash
# Git's built-in validation will catch empty messages
# No additional validation needed
```

## Performance Considerations
- Commit listing should be fast (<100ms for 1000 commits)
- FZF preview should be responsive (<100ms per commit)
- Use git built-in commands for efficiency
- Avoid spawning unnecessary subshells

## Security Considerations
- Validate all commit hashes before use
- Quote all variables in shell commands
- Use `--` separator in git commands
- Don't expose sensitive information in previews
- Respect git hooks (don't use --no-verify by default)

## Testing Requirements

### Unit Tests
1. Commit listing works correctly
2. Hash extraction from FZF output
3. HEAD detection logic
4. Rebase command generation
5. Error handling for edge cases

### Integration Tests
1. Full workflow: select → reword HEAD
2. Full workflow: select → reword older commit
3. Cancellation handling (Ctrl-C)
4. Empty message rejection
5. Uncommitted changes detection
6. Pushed commit warning

### Edge Cases
1. Repository with no commits
2. Repository with only one commit
3. Detached HEAD state
4. Merge commits
5. Rebase conflicts during reword
6. Editor errors or cancellation
