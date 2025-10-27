# Interactive FZF/Tmux Wrapper for git-worktree - Technical Specification

## Overview
This specification defines the interactive wrapper `git-wt-interactive` for the `git-worktree` script, providing FZF-based menu navigation and tmux session management.

## Script Metadata

### File Location
`bin/git/git-wt-interactive`

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
2. **tmux** - Terminal multiplexer for session management
3. **git-worktree** - Core worktree management script
4. **jq** - JSON parser for metadata reading

### Dependency Checking
```bash
check_dependencies() {
    local missing_deps=()

    if ! command -v fzf &>/dev/null; then
        missing_deps+=("fzf")
    fi

    if ! command -v tmux &>/dev/null; then
        missing_deps+=("tmux")
    fi

    if ! command -v jq &>/dev/null; then
        missing_deps+=("jq")
    fi

    if ! find_git_worktree &>/dev/null; then
        missing_deps+=("git-worktree")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "missing required dependencies: ${missing_deps[*]}"
        show_installation_instructions
        return "${EXIT_MISSING_DEPENDENCY}"
    fi

    return 0
}
```

## Main Menu

### Menu Options
1. **Create** - Create new worktree with tmux session
2. **Merge** - Merge feature branch back to base
3. **Cleanup** - Remove worktree and feature branch
4. **List** - List all worktrees
5. **Status** - Show detailed status of worktree
6. **Quit** - Exit interactive mode

### FZF Configuration
```bash
show_main_menu() {
    selection=$(cat <<EOF | fzf \
        --height=40% \
        --layout=reverse \
        --border \
        --prompt="git worktree > " \
        --header="select action (ctrl-c to cancel)" \
        --color="prompt:cyan,header:dim,pointer:green"
Create   - create new worktree with feature branch
Merge    - merge feature branch back to base
Cleanup  - remove worktree and feature branch
List     - list all worktrees
Status   - show detailed status of worktree
Quit     - exit interactive mode
EOF
    ) || return "${EXIT_USER_CANCELLED}"

    action=$(echo "${selection}" | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    echo "${action}"
}
```

## Worktree Management

### Get Worktree List
```bash
get_worktree_list() {
    local git_dir
    git_dir="$(git rev-parse --git-dir 2>/dev/null)" || return 1

    local worktrees=()

    while IFS= read -r metadata_file; do
        if [[ -f "$metadata_file" ]]; then
            slug="$(basename "$metadata_file" | sed 's/^worktree-feature-//;s/.json$//')"
            base_branch="$(jq -r '.base_branch // "unknown"' "$metadata_file" 2>/dev/null)"

            # Check if worktree directory exists
            local parent_dir="${PWD##*/}"
            local worktree_dir="../${parent_dir}-${slug}"

            if [[ -d "$worktree_dir" ]]; then
                status="${COLOR_GREEN}[active]${COLOR_RESET}"
            else
                status="${COLOR_YELLOW}[missing]${COLOR_RESET}"
            fi

            worktrees+=("${slug}|${base_branch}|${status}|${metadata_file}")
        fi
    done < <(find "$git_dir" -maxdepth 1 -name "worktree-feature-*.json" 2>/dev/null)

    if [[ ${#worktrees[@]} -eq 0 ]]; then
        return 1
    fi

    printf '%s\n' "${worktrees[@]}"
}
```

### FZF Preview
```bash
generate_preview() {
    local line="$1"
    IFS='|' read -r slug _ _ metadata_file <<< "$line"

    if [[ ! -f "$metadata_file" ]]; then
        return
    fi

    echo -e "${COLOR_CYAN}worktree: ${slug}${COLOR_RESET}"
    echo ""

    base_branch="$(jq -r '.base_branch // "unknown"' "$metadata_file")"
    created_at="$(jq -r '.created_at // "unknown"' "$metadata_file")"
    created_by="$(jq -r '.created_by // "unknown"' "$metadata_file")"

    echo -e "${COLOR_BLUE}base branch:${COLOR_RESET} $base_branch"
    echo -e "${COLOR_BLUE}created:${COLOR_RESET} $created_at"
    echo -e "${COLOR_BLUE}by:${COLOR_RESET} $created_by"
    echo ""

    # Check directory status
    local parent_dir="${PWD##*/}"
    local worktree_dir="../${parent_dir}-${slug}"

    if [[ -d "$worktree_dir" ]]; then
        echo -e "${COLOR_GREEN}[active]${COLOR_RESET} directory exists: $worktree_dir"

        if [[ -d "${worktree_dir}/.git" ]]; then
            echo -e "${COLOR_BLUE}git status:${COLOR_RESET}"
            git -C "$worktree_dir" status --short 2>/dev/null || echo "  (unable to get status)"
        fi
    else
        echo -e "${COLOR_YELLOW}[missing]${COLOR_RESET} directory not found: $worktree_dir"
        echo -e "${COLOR_YELLOW}run cleanup to remove orphaned metadata${COLOR_RESET}"
    fi

    # Check tmux session
    local tmux_name="$(sanitize_tmux_name "$slug")"
    if tmux_session_exists "$tmux_name"; then
        echo ""
        echo -e "${COLOR_GREEN}[active]${COLOR_RESET} tmux session: $tmux_name"
    fi
}
```

## Tmux Integration

### Session Naming
```bash
sanitize_tmux_name() {
    local name="$1"
    echo "wt-${name}" | tr -c '[:alnum:]-_' '-'
}
```

### Session Management
```bash
is_in_tmux() {
    [[ -n "${TMUX:-}" ]]
}

tmux_session_exists() {
    local session_name="$1"
    tmux has-session -t "$session_name" 2>/dev/null
}

create_tmux_session() {
    local slug="$1"
    local worktree_dir="$2"
    local tmux_name="$(sanitize_tmux_name "$slug")"

    if is_in_tmux; then
        tmux new-window -t "$(tmux display-message -p '#S')" -n "$tmux_name" -c "$worktree_dir"
        log_success "Tmux window '$tmux_name' created"
        log_info "Switch with: Ctrl-b + w"
    else
        tmux new-session -d -s "$tmux_name" -c "$worktree_dir"
        log_success "Tmux session '$tmux_name' ready"
        log_info "Starting session..."
        sleep 1
        tmux attach-session -t "$tmux_name"
    fi
}

kill_tmux_session() {
    local slug="$1"
    local tmux_name="$(sanitize_tmux_name "$slug")"

    if tmux_session_exists "$tmux_name"; then
        if is_in_tmux; then
            if tmux list-windows -F "#{window_name}" | grep -q "^${tmux_name}$"; then
                tmux kill-window -t "$tmux_name" 2>/dev/null || true
                log_success "Tmux window killed"
            fi
        else
            tmux kill-session -t "$tmux_name" 2>/dev/null || true
            log_success "Tmux session killed"
        fi
    fi
}
```

## Action Handlers

### Create Action
```bash
action_create() {
    log_info "Create new worktree"

    # Prompt for slug
    while true; do
        read -rp "Enter slug (letters, numbers, hyphens, underscores): " slug

        if [[ -z "$slug" ]]; then
            log_error "Slug cannot be empty"
            continue
        fi

        if [[ ! "$slug" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            log_error "Invalid slug format"
            continue
        fi

        if git branch --list "feature/$slug" | grep -q .; then
            log_error "Branch feature/$slug already exists"
            continue
        fi

        break
    done

    # Execute create
    log_info "Creating worktree..."
    if "$WT_SCRIPT" create "$slug"; then
        log_success "Worktree created!"

        # Create tmux session
        local parent_dir="${PWD##*/}"
        local worktree_dir="../${parent_dir}-${slug}"
        create_tmux_session "$slug" "$worktree_dir"
    else
        log_error "Failed to create worktree"
    fi

    read -rp "Press Enter to continue..."
}
```

### Merge Action
```bash
action_merge() {
    if ! worktrees="$(get_worktree_list)"; then
        log_warning "No worktrees found"
        read -rp "Press Enter to continue..."
        return
    fi

    # Select worktree
    selected=$(while IFS= read -r line; do
        format_worktree_for_fzf "$line"
    done <<< "$worktrees" | fzf \
        --height=80% \
        --reverse \
        --border \
        --ansi \
        --delimiter="|" \
        --with-nth=1 \
        --prompt="Select worktree to merge > " \
        --preview="bash -c 'source $(realpath "$0") && generate_preview \"\$(echo {} | cut -d\"|\" -f2-)\"'" \
        --preview-window=right:50% \
    | cut -d"|" -f2-)

    if [[ -z "$selected" ]]; then
        return
    fi

    slug="$(echo "$selected" | cut -d'|' -f1)"

    # Select merge strategy
    strategy=$(cat <<EOF | fzf --height=40% --reverse --border --prompt="Merge strategy > " --header="Select strategy for '$slug':"
Auto (smart conflict detection)
Force Rebase
Force Merge
Dry Run
EOF
    )

    local flags=()
    case "$strategy" in
        *"Force Rebase"*) flags+=(--force-rebase) ;;
        *"Force Merge"*) flags+=(--force-merge) ;;
        *"Dry Run"*) flags+=(--dry-run) ;;
    esac

    # Execute merge
    log_info "Merging worktree: $slug"
    if "$WT_SCRIPT" merge "$slug" "${flags[@]:-}"; then
        log_success "Merge completed!"

        # Ask about cleanup
        read -rp "Cleanup worktree now? (y/n): " cleanup
        if [[ "$cleanup" =~ ^[Yy]$ ]]; then
            perform_cleanup "$slug"
        fi
    else
        log_error "Merge failed"
    fi

    read -rp "Press Enter to continue..."
}
```

### Cleanup Action
```bash
action_cleanup() {
    if ! worktrees="$(get_worktree_list)"; then
        log_warning "No worktrees found"
        read -rp "Press Enter to continue..."
        return
    fi

    # Select worktree
    selected=$(while IFS= read -r line; do
        format_worktree_for_fzf "$line"
    done <<< "$worktrees" | fzf \
        --height=80% \
        --reverse \
        --border \
        --ansi \
        --delimiter="|" \
        --with-nth=1 \
        --prompt="Select worktree to cleanup > " \
        --preview="bash -c 'source $(realpath "$0") && generate_preview \"\$(echo {} | cut -d\"|\" -f2-)\"'" \
        --preview-window=right:50% \
    | cut -d"|" -f2-)

    if [[ -z "$selected" ]]; then
        return
    fi

    slug="$(echo "$selected" | cut -d'|' -f1)"
    perform_cleanup "$slug"

    read -rp "Press Enter to continue..."
}

perform_cleanup() {
    local slug="$1"

    # Check for tmux session
    local tmux_name="$(sanitize_tmux_name "$slug")"
    if tmux_session_exists "$tmux_name"; then
        log_warning "Tmux session '$tmux_name' is active"
        read -rp "Kill tmux session? (y/n): " kill_tmux
        if [[ "$kill_tmux" =~ ^[Yy]$ ]]; then
            kill_tmux_session "$slug"
        fi
    fi

    # Execute cleanup
    log_info "Cleaning up worktree: $slug"
    if "$WT_SCRIPT" cleanup "$slug"; then
        log_success "Cleanup completed!"
    else
        log_error "Cleanup failed"
    fi
}
```

### List Action
```bash
action_list() {
    "$WT_SCRIPT" list || log_warning "No worktrees found"
    read -rp "Press Enter to continue..."
}
```

### Status Action
```bash
action_status() {
    if ! worktrees="$(get_worktree_list)"; then
        log_warning "No worktrees found"
        read -rp "Press Enter to continue..."
        return
    fi

    # Select worktree
    selected=$(while IFS= read -r line; do
        format_worktree_for_fzf "$line"
    done <<< "$worktrees" | fzf \
        --height=80% \
        --reverse \
        --border \
        --ansi \
        --delimiter="|" \
        --with-nth=1 \
        --prompt="Select worktree for status > " \
        --preview="bash -c 'source $(realpath "$0") && generate_preview \"\$(echo {} | cut -d\"|\" -f2-)\"'" \
        --preview-window=right:50% \
    | cut -d"|" -f2-)

    if [[ -z "$selected" ]]; then
        return
    fi

    slug="$(echo "$selected" | cut -d'|' -f1)"

    # Show status
    "$WT_SCRIPT" status "$slug"

    # Offer to open in tmux
    local tmux_name="$(sanitize_tmux_name "$slug")"
    if tmux_session_exists "$tmux_name"; then
        read -rp "Switch to tmux session? (y/n): " switch_tmux
        if [[ "$switch_tmux" =~ ^[Yy]$ ]]; then
            if is_in_tmux; then
                tmux switch-client -t "$tmux_name"
            else
                tmux attach-session -t "$tmux_name"
            fi
        fi
    fi

    read -rp "Press Enter to continue..."
}
```

## Error Handling

### Trap Handler
```bash
cleanup() {
    local exit_code=$?
    # Cleanup logic here
}

trap cleanup EXIT INT TERM
```

### Logging Functions
```bash
log_error() {
    echo -e "${COLOR_RED}error:${COLOR_RESET} $*" >&2
}

log_warning() {
    echo -e "${COLOR_YELLOW}warning:${COLOR_RESET} $*" >&2
}

log_info() {
    echo -e "${COLOR_BLUE}info:${COLOR_RESET} $*"
}

log_success() {
    echo -e "${COLOR_GREEN}success:${COLOR_RESET} $*"
}

log_dim() {
    echo -e "${COLOR_DIM}$*${COLOR_RESET}"
}
```

## Testing Requirements

### Unit Tests
1. Dependency checking works correctly
2. Slug validation accepts valid formats
3. Slug validation rejects invalid formats
4. Tmux session naming sanitization
5. Worktree listing and parsing

### Integration Tests
1. Full workflow: create → work → merge → cleanup
2. Tmux session creation (inside and outside tmux)
3. Tmux session cleanup
4. FZF selection and cancellation
5. Merge strategy selection

### Edge Cases
1. No worktrees exist (empty state)
2. Worktree directory missing but metadata exists
3. Tmux session exists but worktree gone
4. User cancels FZF selection (Ctrl-C)
5. Multiple worktrees with similar names

## Performance Considerations
- Metadata reading should be fast (use `jq` efficiently)
- FZF preview should be responsive (<100ms)
- Tmux operations should be non-blocking where possible

## Security Considerations
- Validate all user input (slug format, paths)
- Prevent path traversal attacks
- Quote all variables in shell commands
- Use `--` separator for git commands with user input
