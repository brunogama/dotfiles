#!/usr/bin/env bash
# Git Worktree Tmux Integration - Enhanced tmux workflow for worktrees
# Automatically creates tmux sessions for worktrees with intelligent naming

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
TMUX_SESSION_PREFIX="${TMUX_SESSION_PREFIX:-wt}"
TMUX_WINDOW_LAYOUT="${TMUX_WINDOW_LAYOUT:-main-vertical}"

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v tmux > /dev/null 2>&1; then
        missing_deps+=("tmux")
    fi
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

# Get session name for branch
get_session_name() {
    local branch="$1"
    local repo_name
    repo_name="$(basename "$(git rev-parse --show-toplevel)")"
    
    # Clean branch name for tmux session
    local clean_branch="${branch//[^a-zA-Z0-9_-]/_}"
    
    echo "${TMUX_SESSION_PREFIX}_${repo_name}_${clean_branch}"
}

# Get worktree path for branch
get_worktree_path() {
    local branch="$1"
    git worktree list --porcelain | awk -v branch="$branch" '
        /^worktree / { path = substr($0, 10) }
        /^branch / { 
            if (substr($0, 18) == branch) {
                print path
                exit
            }
        }
    '
}

# Create tmux session for worktree
create_worktree_session() {
    local branch="$1"
    local session_name
    session_name="$(get_session_name "$branch")"
    
    local worktree_path
    worktree_path="$(get_worktree_path "$branch")"
    
    if [[ -z "$worktree_path" ]]; then
        log_error "Worktree for branch '$branch' not found"
        return 1
    fi
    
    if [[ ! -d "$worktree_path" ]]; then
        log_error "Worktree path does not exist: $worktree_path"
        return 1
    fi
    
    # Check if session already exists
    if tmux has-session -t "$session_name" 2>/dev/null; then
        log_warning "Session '$session_name' already exists"
        return 0
    fi
    
    log_info "Creating tmux session '$session_name' for worktree '$branch'"
    
    # Create new session
    tmux new-session -d -s "$session_name" -c "$worktree_path"
    
    # Set up windows based on project type
    setup_project_windows "$session_name" "$worktree_path"
    
    log_success "Created session '$session_name'"
    return 0
}

# Set up project-specific windows
setup_project_windows() {
    local session_name="$1"
    local worktree_path="$2"
    
    # Window 1: Editor/Main work (already created)
    tmux rename-window -t "$session_name:0" "editor"
    
    # Window 2: Terminal/Commands
    tmux new-window -t "$session_name" -n "terminal" -c "$worktree_path"
    
    # Window 3: Git operations
    tmux new-window -t "$session_name" -n "git" -c "$worktree_path"
    tmux send-keys -t "$session_name:git" "git status" C-m
    
    # Project-specific setup
    if [[ -f "$worktree_path/package.json" ]]; then
        # Node.js project
        tmux new-window -t "$session_name" -n "dev" -c "$worktree_path"
        tmux send-keys -t "$session_name:dev" "npm install" C-m
        
        tmux new-window -t "$session_name" -n "test" -c "$worktree_path"
        tmux send-keys -t "$session_name:test" "# npm test" C-m
        
    elif [[ -f "$worktree_path/Cargo.toml" ]]; then
        # Rust project
        tmux new-window -t "$session_name" -n "build" -c "$worktree_path"
        tmux send-keys -t "$session_name:build" "cargo check" C-m
        
        tmux new-window -t "$session_name" -n "test" -c "$worktree_path"
        tmux send-keys -t "$session_name:test" "# cargo test" C-m
        
    elif [[ -f "$worktree_path/requirements.txt" ]] || [[ -f "$worktree_path/pyproject.toml" ]]; then
        # Python project
        tmux new-window -t "$session_name" -n "venv" -c "$worktree_path"
        if [[ -f "$worktree_path/requirements.txt" ]]; then
            tmux send-keys -t "$session_name:venv" "# pip install -r requirements.txt" C-m
        fi
        
        tmux new-window -t "$session_name" -n "test" -c "$worktree_path"
        tmux send-keys -t "$session_name:test" "# pytest" C-m
    fi
    
    # Go back to editor window
    tmux select-window -t "$session_name:editor"
    
    # Set layout
    tmux select-layout -t "$session_name" "$TMUX_WINDOW_LAYOUT"
}

# Attach to worktree session
attach_worktree_session() {
    local branch="$1"
    local session_name
    session_name="$(get_session_name "$branch")"
    
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        log_info "Session '$session_name' doesn't exist, creating..."
        if ! create_worktree_session "$branch"; then
            return 1
        fi
    fi
    
    log_info "Attaching to session '$session_name'"
    
    if [[ -n "${TMUX:-}" ]]; then
        # Already in tmux, switch to session
        tmux switch-client -t "$session_name"
    else
        # Not in tmux, attach to session
        tmux attach-session -t "$session_name"
    fi
}

# List all worktree sessions
list_worktree_sessions() {
    log_info "Worktree tmux sessions:"
    
    local sessions
    sessions="$(tmux list-sessions 2>/dev/null | grep "^${TMUX_SESSION_PREFIX}_" || true)"
    
    if [[ -z "$sessions" ]]; then
        echo "  No worktree sessions found"
        return
    fi
    
    echo "$sessions" | while IFS=: read -r session_name rest; do
        # Extract branch name from session name
        local branch
        branch="$(echo "$session_name" | sed "s/^${TMUX_SESSION_PREFIX}_[^_]*_//" | sed 's/_/\//g')"
        
        # Check if worktree still exists
        local worktree_path
        worktree_path="$(get_worktree_path "$branch")"
        
        if [[ -n "$worktree_path" && -d "$worktree_path" ]]; then
            echo -e "  ${GREEN}●${NC} $session_name → $branch ($worktree_path)"
        else
            echo -e "  ${RED}●${NC} $session_name → $branch (worktree missing)"
        fi
    done
}

# Kill worktree session
kill_worktree_session() {
    local branch="$1"
    local session_name
    session_name="$(get_session_name "$branch")"
    
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        log_warning "Session '$session_name' doesn't exist"
        return 1
    fi
    
    log_info "Killing session '$session_name'"
    tmux kill-session -t "$session_name"
    log_success "Session killed"
}

# Clean up stale sessions
clean_stale_sessions() {
    log_info "Cleaning up stale worktree sessions..."
    
    local sessions
    sessions="$(tmux list-sessions 2>/dev/null | grep "^${TMUX_SESSION_PREFIX}_" | cut -d: -f1 || true)"
    
    if [[ -z "$sessions" ]]; then
        log_info "No worktree sessions found"
        return
    fi
    
    local cleaned_count=0
    
    echo "$sessions" | while IFS= read -r session_name; do
        # Extract branch name from session name
        local branch
        branch="$(echo "$session_name" | sed "s/^${TMUX_SESSION_PREFIX}_[^_]*_//" | sed 's/_/\//g')"
        
        # Check if worktree still exists
        local worktree_path
        worktree_path="$(get_worktree_path "$branch")"
        
        if [[ -z "$worktree_path" || ! -d "$worktree_path" ]]; then
            log_warning "Removing stale session: $session_name (worktree missing)"
            tmux kill-session -t "$session_name" 2>/dev/null || true
            cleaned_count=$((cleaned_count + 1))
        fi
    done
    
    if [[ $cleaned_count -eq 0 ]]; then
        log_success "No stale sessions found"
    else
        log_success "Cleaned up $cleaned_count stale sessions"
    fi
}

# Interactive session selector (requires fzf)
interactive_session_selector() {
    if ! command -v fzf > /dev/null 2>&1; then
        log_error "fzf is required for interactive session selector"
        return 1
    fi
    
    # Get all worktrees
    local worktrees
    worktrees="$(git worktree list --porcelain | awk '
        /^worktree / { path = substr($0, 10) }
        /^branch / { 
            branch = substr($0, 18)
            printf "%s\t%s\n", branch, path
        }
    ')"
    
    if [[ -z "$worktrees" ]]; then
        log_warning "No worktrees found"
        return 1
    fi
    
    local selection
    selection="$(echo "$worktrees" | fzf \
        --delimiter='\t' \
        --with-nth=1 \
        --preview="echo 'Branch: {1}' && echo 'Path: {2}' && echo && cd {2} && git status --short 2>/dev/null || true" \
        --preview-window="right:50%" \
        --header="Select worktree for tmux session")"
    
    if [[ -n "$selection" ]]; then
        local branch
        branch="$(echo "$selection" | cut -f1)"
        attach_worktree_session "$branch"
    fi
}

# Show help
show_help() {
    cat << 'EOF'
Git Worktree Tmux Integration

Usage: worktree-tmux.sh <command> [args]

Commands:
  create <branch>      Create tmux session for worktree
  attach <branch>      Attach to worktree session (create if needed)
  list                 List all worktree sessions
  kill <branch>        Kill worktree session
  clean               Clean up stale sessions
  interactive         Interactive session selector (requires fzf)

Environment Variables:
  TMUX_SESSION_PREFIX  Session name prefix (default: wt)
  TMUX_WINDOW_LAYOUT   Default window layout (default: main-vertical)

Examples:
  worktree-tmux.sh create feature/auth
  worktree-tmux.sh attach feature/auth
  worktree-tmux.sh list
  worktree-tmux.sh clean
  worktree-tmux.sh interactive

Integration:
  Add to your shell configuration:
  alias wtt='./scripts/worktree-tmux.sh'
  alias wtta='./scripts/worktree-tmux.sh attach'
  alias wtti='./scripts/worktree-tmux.sh interactive'
EOF
}

# Main command dispatcher
main() {
    check_dependencies
    
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        create|c)
            local branch="${1:-}"
            if [[ -z "$branch" ]]; then
                log_error "Branch name required"
                exit 1
            fi
            create_worktree_session "$branch"
            ;;
        attach|a)
            local branch="${1:-}"
            if [[ -z "$branch" ]]; then
                log_error "Branch name required"
                exit 1
            fi
            attach_worktree_session "$branch"
            ;;
        list|ls)
            list_worktree_sessions
            ;;
        kill|k)
            local branch="${1:-}"
            if [[ -z "$branch" ]]; then
                log_error "Branch name required"
                exit 1
            fi
            kill_worktree_session "$branch"
            ;;
        clean)
            clean_stale_sessions
            ;;
        interactive|i)
            interactive_session_selector
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "Unknown command: $command"
            echo
            show_help
            exit 1
            ;;
    esac
}

main "$@"
