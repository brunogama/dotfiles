#!/usr/bin/env bash
# Git Worktree Manager - Enhanced DX for Git Worktrees
# Usage: ./scripts/git-worktree-manager.sh <command> [args]

set -euo pipefail

# Configuration
WORKTREE_BASE_DIR="${WORKTREE_BASE_DIR:-$(git rev-parse --show-toplevel)/../worktrees}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
WORKTREE_HISTORY_FILE="${HOME}/.worktree-history"
WORKTREE_HISTORY_SIZE="${WORKTREE_HISTORY_SIZE:-20}"
WORKTREE_STATE_ENABLED="${WORKTREE_STATE_ENABLED:-true}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_header() { echo -e "${PURPLE}🌳${NC} $1"; }

show_help() {
    cat << EOF
${PURPLE}Git Worktree Manager${NC} - Enhanced DX for Git Worktrees

${CYAN}Usage:${NC}
  $(basename "$0") <command> [args]

${CYAN}Commands:${NC}
  ${GREEN}create${NC} <branch> [base]     Create new worktree for branch
  ${GREEN}switch${NC} <branch>            Switch to existing worktree
  ${GREEN}list${NC}                       List all worktrees with enhanced status
  ${GREEN}recent${NC}                     Show recently used worktrees
  ${GREEN}remove${NC} <branch>            Remove worktree (with safety checks)
  ${GREEN}clean${NC}                      Clean up stale/merged worktrees
  ${GREEN}status${NC}                     Show detailed worktree status
  ${GREEN}sync${NC} [branch]              Sync worktree with remote
  ${GREEN}init${NC}                       Initialize worktree structure
  ${GREEN}cd${NC} <branch>                Print cd command for worktree

${CYAN}Examples:${NC}
  $(basename "$0") create feature/auth-system
  $(basename "$0") switch feature/auth-system  
  $(basename "$0") list
  $(basename "$0") recent
  $(basename "$0") clean
  $(basename "$0") cd feature/auth-system | source /dev/stdin

${CYAN}Environment Variables:${NC}
  WORKTREE_BASE_DIR      Base directory for worktrees (default: ../worktrees)
  DEFAULT_BRANCH         Default branch name (default: main)
  WORKTREE_HISTORY_SIZE  Number of recent worktrees to remember (default: 20)
  WORKTREE_STATE_ENABLED Enable workspace state persistence (default: true)
EOF
}

# Ensure we're in a git repository
ensure_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi
}

# Get worktree path for branch
get_worktree_path() {
    local branch="$1"
    echo "$WORKTREE_BASE_DIR/$(basename "$(git rev-parse --show-toplevel)")/$branch"
}

# Check if worktree exists
worktree_exists() {
    local branch="$1"
    git worktree list | grep -q "$(get_worktree_path "$branch")"
}

# Add worktree to history
add_to_history() {
    local branch="$1"
    local path="$2"
    local timestamp
    timestamp="$(date +%s)"
    local repo_root
    repo_root="$(git rev-parse --show-toplevel)"
    
    # Create history entry: timestamp|repo|branch|path
    local entry="${timestamp}|${repo_root}|${branch}|${path}"
    
    # Create history file if it doesn't exist
    touch "$WORKTREE_HISTORY_FILE"
    
    # Remove existing entry for this branch in this repo (to update timestamp)
    grep -v "|${repo_root}|${branch}|" "$WORKTREE_HISTORY_FILE" > "${WORKTREE_HISTORY_FILE}.tmp" || true
    
    # Add new entry at the beginning
    echo "$entry" > "${WORKTREE_HISTORY_FILE}.new"
    cat "${WORKTREE_HISTORY_FILE}.tmp" >> "${WORKTREE_HISTORY_FILE}.new" 2>/dev/null || true
    
    # Keep only the most recent entries
    head -n "$WORKTREE_HISTORY_SIZE" "${WORKTREE_HISTORY_FILE}.new" > "$WORKTREE_HISTORY_FILE"
    
    # Clean up temp files
    rm -f "${WORKTREE_HISTORY_FILE}.tmp" "${WORKTREE_HISTORY_FILE}.new"
}

# Get recent worktrees for current repo
get_recent_worktrees() {
    if [[ ! -f "$WORKTREE_HISTORY_FILE" ]]; then
        return
    fi
    
    local repo_root
    repo_root="$(git rev-parse --show-toplevel)"
    
    # Filter history for current repo and check if worktrees still exist
    while IFS='|' read -r timestamp repo branch path; do
        if [[ "$repo" == "$repo_root" && -d "$path" ]]; then
            # Calculate age
            local current_time
            current_time="$(date +%s)"
            local age_seconds=$((current_time - timestamp))
            local age_display
            
            if [[ $age_seconds -lt 3600 ]]; then
                local minutes=$((age_seconds / 60))
                age_display="${minutes}m ago"
            elif [[ $age_seconds -lt 86400 ]]; then
                local hours=$((age_seconds / 3600))
                age_display="${hours}h ago"
            else
                local days=$((age_seconds / 86400))
                age_display="${days}d ago"
            fi
            
            printf "%-20s %-30s %s\n" "${CYAN}$branch${NC}" "$path" "$age_display"
        fi
    done < "$WORKTREE_HISTORY_FILE"
}

# Save workspace state
save_workspace_state() {
    local worktree_path="$1"
    local branch="$2"
    
    if [[ "$WORKTREE_STATE_ENABLED" != "true" ]]; then
        return
    fi
    
    local state_file="$worktree_path/.worktree-state.json"
    local current_dir
    current_dir="$(pwd)"
    
    # Create state object
    cat > "$state_file" << EOF
{
  "branch": "$branch",
  "last_working_dir": "$current_dir",
  "timestamp": $(date +%s),
  "shell": "${SHELL:-/bin/bash}",
  "git_status": "$(cd "$worktree_path" && git status --porcelain 2>/dev/null || echo '')"
}
EOF
}

# Restore workspace state
restore_workspace_state() {
    local worktree_path="$1"
    
    if [[ "$WORKTREE_STATE_ENABLED" != "true" ]]; then
        return
    fi
    
    local state_file="$worktree_path/.worktree-state.json"
    
    if [[ -f "$state_file" ]]; then
        log_info "Restoring workspace state..."
        
        # Extract working directory from state file
        local last_dir
        last_dir=$(grep '"last_working_dir"' "$state_file" | sed 's/.*": *"\([^"]*\)".*/\1/')
        
        if [[ -n "$last_dir" && -d "$last_dir" ]]; then
            cd "$last_dir"
            log_success "Restored working directory: $last_dir"
        fi
    fi
}

# Create new worktree
cmd_create() {
    local branch="${1:-}"
    local base_branch="${2:-$DEFAULT_BRANCH}"
    
    if [[ -z "$branch" ]]; then
        log_error "Branch name required"
        echo "Usage: $(basename "$0") create <branch> [base]"
        exit 1
    fi
    
    local worktree_path
    worktree_path="$(get_worktree_path "$branch")"
    
    if worktree_exists "$branch"; then
        log_warning "Worktree for '$branch' already exists at: $worktree_path"
        exit 1
    fi
    
    log_info "Creating worktree for branch '$branch' based on '$base_branch'"
    
    # Create directory structure
    mkdir -p "$(dirname "$worktree_path")"
    
    # Check if branch exists locally or remotely
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        log_info "Using existing local branch '$branch'"
        git worktree add "$worktree_path" "$branch"
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        log_info "Checking out existing remote branch '$branch'"
        git worktree add "$worktree_path" -b "$branch" "origin/$branch"
    else
        log_info "Creating new branch '$branch' from '$base_branch'"
        git worktree add "$worktree_path" -b "$branch" "$base_branch"
    fi
    
    # Add to history
    add_to_history "$branch" "$worktree_path"
    
    log_success "Worktree created at: $worktree_path"
    log_info "To switch: cd '$worktree_path'"
    log_info "Or use: $(basename "$0") switch $branch"
}

# Switch to worktree
cmd_switch() {
    local branch="${1:-}"
    
    if [[ -z "$branch" ]]; then
        log_error "Branch name required"
        echo "Usage: $(basename "$0") switch <branch>"
        exit 1
    fi
    
    if ! worktree_exists "$branch"; then
        log_error "Worktree for '$branch' does not exist"
        log_info "Available worktrees:"
        cmd_list
        exit 1
    fi
    
    local worktree_path
    worktree_path="$(get_worktree_path "$branch")"
    
    # Save current workspace state if we're in a worktree
    local current_worktree_path
    if current_worktree_path="$(git rev-parse --show-toplevel 2>/dev/null)"; then
        local current_branch
        current_branch="$(git branch --show-current 2>/dev/null || echo '')"
        if [[ -n "$current_branch" ]]; then
            save_workspace_state "$current_worktree_path" "$current_branch"
        fi
    fi
    
    # Add to history
    add_to_history "$branch" "$worktree_path"
    
    log_info "Switching to worktree: $worktree_path"
    cd "$worktree_path"
    
    # Restore workspace state
    restore_workspace_state "$worktree_path"
    
    # If running in a shell, try to change directory
    if [[ -n "${BASH_VERSION:-}" ]]; then
        exec bash -c "cd '$worktree_path' && exec bash"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        exec zsh -c "cd '$worktree_path' && exec zsh"
    fi
}

# Enhanced worktree info extraction
get_worktree_info() {
    local path="$1"
    local branch="$2"
    local info=""
    
    if [[ -d "$path/.git" ]]; then
        local changes ahead behind last_commit last_author age
        
        # Get changes count
        changes=$(cd "$path" && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
        
        # Get ahead/behind info
        local tracking_info
        tracking_info=$(cd "$path" && git rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null || echo "0	0")
        behind=$(echo "$tracking_info" | cut -f1)
        ahead=$(echo "$tracking_info" | cut -f2)
        
        # Get last commit info
        last_commit=$(cd "$path" && git log -1 --format="%h %s" 2>/dev/null || echo "no commits")
        last_author=$(cd "$path" && git log -1 --format="%an" 2>/dev/null || echo "unknown")
        
        # Get worktree age
        local last_commit_date
        last_commit_date=$(cd "$path" && git log -1 --format="%ct" 2>/dev/null || echo "0")
        if [[ "$last_commit_date" -gt 0 ]]; then
            local current_time
            current_time=$(date +%s)
            local age_seconds=$((current_time - last_commit_date))
            local age_days=$((age_seconds / 86400))
            if [[ $age_days -eq 0 ]]; then
                age="today"
            elif [[ $age_days -eq 1 ]]; then
                age="1 day ago"
            else
                age="${age_days} days ago"
            fi
        else
            age="unknown"
        fi
        
        # Build status info
        local status_parts=()
        if [[ "$changes" -gt 0 ]]; then
            status_parts+=("${YELLOW}$changes changes${NC}")
        fi
        if [[ "$ahead" -gt 0 ]]; then
            status_parts+=("${GREEN}↑$ahead${NC}")
        fi
        if [[ "$behind" -gt 0 ]]; then
            status_parts+=("${RED}↓$behind${NC}")
        fi
        if [[ ${#status_parts[@]} -eq 0 ]]; then
            status_parts+=("${GREEN}clean${NC}")
        fi
        
        local status_str
        printf -v status_str "%s" "$(IFS=', '; echo "${status_parts[*]}")"
        
        info="${status_str} | ${BLUE}$last_commit${NC} | ${PURPLE}$last_author${NC} | $age"
    else
        info="${RED}invalid${NC}"
    fi
    
    echo "$info"
}

# List all worktrees with enhanced information
cmd_list() {
    log_header "Git Worktrees"
    
    if ! git worktree list > /dev/null 2>&1; then
        log_warning "No worktrees found"
        return
    fi
    
    local current_path
    current_path="$(pwd)"
    
    printf "%-2s %-20s %-30s %s\n" "" "Branch" "Path" "Status | Last Commit | Author | Age"
    printf "%-2s %-20s %-30s %s\n" "" "------" "----" "----------------------------------------"
    
    git worktree list --porcelain | while IFS= read -r line; do
        if [[ "$line" =~ ^worktree ]]; then
            local path="${line#worktree }"
            local branch=""
            
            # Read next lines for branch
            read -r branch_line
            if [[ "$branch_line" =~ ^branch ]]; then
                branch="${branch_line#branch refs/heads/}"
            else
                branch="(detached)"
            fi
            
            # Check if this is current worktree
            local indicator=""
            if [[ "$path" == "$current_path" ]]; then
                indicator="${GREEN}→${NC}"
            else
                indicator=" "
            fi
            
            # Get enhanced worktree info
            local worktree_info
            worktree_info="$(get_worktree_info "$path" "$branch")"
            
            # Truncate path for display
            local display_path="$path"
            if [[ ${#path} -gt 28 ]]; then
                display_path="...${path: -25}"
            fi
            
            printf "%s %-20s %-30s %s\n" "$indicator" "${CYAN}$branch${NC}" "$display_path" "$worktree_info"
        fi
    done
}

# Show recent worktrees
cmd_recent() {
    log_header "Recent Worktrees"
    
    local recent_output
    recent_output="$(get_recent_worktrees)"
    
    if [[ -z "$recent_output" ]]; then
        log_info "No recent worktrees found"
        log_info "Worktree history is stored in: $WORKTREE_HISTORY_FILE"
        return
    fi
    
    printf "%-20s %-30s %s\n" "Branch" "Path" "Last Used"
    printf "%-20s %-30s %s\n" "------" "----" "---------"
    echo "$recent_output"
}

# Remove worktree
cmd_remove() {
    local branch="${1:-}"
    
    if [[ -z "$branch" ]]; then
        log_error "Branch name required"
        echo "Usage: $(basename "$0") remove <branch>"
        exit 1
    fi
    
    if ! worktree_exists "$branch"; then
        log_error "Worktree for '$branch' does not exist"
        exit 1
    fi
    
    local worktree_path
    worktree_path="$(get_worktree_path "$branch")"
    
    # Safety check - ensure no uncommitted changes
    if [[ -d "$worktree_path" ]]; then
        cd "$worktree_path"
        if ! git diff --quiet || ! git diff --cached --quiet; then
            log_error "Worktree has uncommitted changes"
            log_info "Commit or stash changes before removing"
            exit 1
        fi
    fi
    
    log_warning "Removing worktree for '$branch' at: $worktree_path"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git worktree remove "$worktree_path"
        log_success "Worktree removed"
        
        # Ask if user wants to delete the branch too
        if git show-ref --verify --quiet "refs/heads/$branch"; then
            read -p "Delete branch '$branch' too? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                git branch -d "$branch" 2>/dev/null || git branch -D "$branch"
                log_success "Branch '$branch' deleted"
            fi
        fi
    else
        log_info "Cancelled"
    fi
}

# Clean up stale worktrees
cmd_clean() {
    log_header "Cleaning up stale worktrees"
    
    # Remove stale worktree references
    git worktree prune
    
    # Find merged branches in worktrees
    local merged_branches=()
    while IFS= read -r line; do
        if [[ "$line" =~ ^worktree ]]; then
            local path="${line#worktree }"
            read -r branch_line
            if [[ "$branch_line" =~ ^branch ]]; then
                local branch="${branch_line#branch refs/heads/}"
                
                # Skip main/master branches
                if [[ "$branch" != "main" && "$branch" != "master" && "$branch" != "$DEFAULT_BRANCH" ]]; then
                    # Check if branch is merged
                    if git merge-base --is-ancestor "refs/heads/$branch" "refs/heads/$DEFAULT_BRANCH" 2>/dev/null; then
                        if [[ "$(git rev-parse "refs/heads/$branch")" == "$(git merge-base "refs/heads/$branch" "refs/heads/$DEFAULT_BRANCH")" ]]; then
                            merged_branches+=("$branch:$path")
                        fi
                    fi
                fi
            fi
        fi
    done < <(git worktree list --porcelain)
    
    if [[ ${#merged_branches[@]} -eq 0 ]]; then
        log_success "No merged branches found in worktrees"
        return
    fi
    
    log_info "Found merged branches:"
    for item in "${merged_branches[@]}"; do
        local branch="${item%%:*}"
        local path="${item##*:}"
        echo "  - $branch ($path)"
    done
    
    read -p "Remove these merged worktrees? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for item in "${merged_branches[@]}"; do
            local branch="${item%%:*}"
            local path="${item##*:}"
            
            git worktree remove "$path" 2>/dev/null || true
            git branch -d "$branch" 2>/dev/null || true
            log_success "Cleaned up: $branch"
        done
    fi
}

# Show detailed status
cmd_status() {
    log_header "Worktree Status"
    
    local repo_name
    repo_name="$(basename "$(git rev-parse --show-toplevel)")"
    
    echo "Repository: $repo_name"
    echo "Base directory: $WORKTREE_BASE_DIR"
    echo "Default branch: $DEFAULT_BRANCH"
    echo
    
    cmd_list
}

# Sync worktree with remote
cmd_sync() {
    local branch="${1:-$(git branch --show-current)}"
    
    if [[ -z "$branch" ]]; then
        log_error "Could not determine current branch"
        exit 1
    fi
    
    log_info "Syncing worktree for branch '$branch'"
    
    # Fetch latest changes
    git fetch origin
    
    # Check if remote branch exists
    if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        log_info "Pulling latest changes from origin/$branch"
        git pull origin "$branch"
    else
        log_warning "Remote branch 'origin/$branch' does not exist"
    fi
    
    log_success "Sync completed"
}

# Initialize worktree structure
cmd_init() {
    log_header "Initializing worktree structure"
    
    mkdir -p "$WORKTREE_BASE_DIR"
    log_success "Created base directory: $WORKTREE_BASE_DIR"
    
    # Create a .gitignore for worktree directory
    local gitignore_path="$WORKTREE_BASE_DIR/.gitignore"
    if [[ ! -f "$gitignore_path" ]]; then
        cat > "$gitignore_path" << 'EOF'
# Worktree directories
*/

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db
EOF
        log_success "Created .gitignore: $gitignore_path"
    fi
    
    log_info "Worktree structure initialized"
    log_info "Base directory: $WORKTREE_BASE_DIR"
}

# Print cd command
cmd_cd() {
    local branch="${1:-}"
    
    if [[ -z "$branch" ]]; then
        log_error "Branch name required"
        exit 1
    fi
    
    if ! worktree_exists "$branch"; then
        log_error "Worktree for '$branch' does not exist"
        exit 1
    fi
    
    local worktree_path
    worktree_path="$(get_worktree_path "$branch")"
    echo "cd '$worktree_path'"
}

# Main command dispatcher
main() {
    ensure_git_repo
    
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        create)
            cmd_create "$@"
            ;;
        switch)
            cmd_switch "$@"
            ;;
        list|ls)
            cmd_list "$@"
            ;;
        recent|r)
            cmd_recent "$@"
            ;;
        remove|rm)
            cmd_remove "$@"
            ;;
        clean)
            cmd_clean "$@"
            ;;
        status)
            cmd_status "$@"
            ;;
        sync)
            cmd_sync "$@"
            ;;
        init)
            cmd_init "$@"
            ;;
        cd)
            cmd_cd "$@"
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
