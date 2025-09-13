#!/usr/bin/env bash
# Git Worktree FZF Integration - Interactive worktree management with fuzzy finding
# Requires: fzf (https://github.com/junegunn/fzf)

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command -v fzf > /dev/null 2>&1; then
        missing_deps+=("fzf")
    fi
    
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌${NC} Not in a git repository"
        exit 1
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo -e "${RED}❌${NC} Missing dependencies: ${missing_deps[*]}"
        echo -e "${BLUE}ℹ${NC} Install fzf: https://github.com/junegunn/fzf#installation"
        exit 1
    fi
}

# Get worktree manager script path
get_manager_script() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local manager_script="$script_dir/git-worktree-manager.sh"
    
    if [[ ! -f "$manager_script" ]]; then
        echo -e "${RED}❌${NC} git-worktree-manager.sh not found"
        exit 1
    fi
    
    echo "$manager_script"
}

# Interactive worktree switcher
fzf_switch_worktree() {
    local current_path
    current_path="$(pwd)"
    
    local selection
    selection=$(git worktree list --porcelain | awk '
        /^worktree / { path = substr($0, 10) }
        /^branch / { 
            branch = substr($0, 18)
            if (path == "'"$current_path"'") {
                printf "→ %-20s %s\n", branch, path
            } else {
                printf "  %-20s %s\n", branch, path
            }
        }
        /^detached/ {
            if (path == "'"$current_path"'") {
                printf "→ %-20s %s (detached)\n", "HEAD", path
            } else {
                printf "  %-20s %s (detached)\n", "HEAD", path
            }
        }
    ' | fzf \
        --ansi \
        --header="Select worktree to switch to" \
        --preview="cd {2} && git log --oneline --graph --decorate -10 2>/dev/null || echo 'No git history'" \
        --preview-window="right:50%" \
        --bind="ctrl-r:reload(git worktree list --porcelain | awk -v current=\"$current_path\" '
            /^worktree / { path = substr(\$0, 10) }
            /^branch / { 
                branch = substr(\$0, 18)
                if (path == current) {
                    printf \"→ %-20s %s\\n\", branch, path
                } else {
                    printf \"  %-20s %s\\n\", branch, path
                }
            }
            /^detached/ {
                if (path == current) {
                    printf \"→ %-20s %s (detached)\\n\", \"HEAD\", path
                } else {
                    printf \"  %-20s %s (detached)\\n\", \"HEAD\", path
                }
            }
        ')" \
        --header-lines=0)
    
    if [[ -n "$selection" ]]; then
        local worktree_path
        worktree_path="$(echo "$selection" | awk '{print $2}')"
        
        if [[ -d "$worktree_path" ]]; then
            cd "$worktree_path"
            echo -e "${GREEN}✅${NC} Switched to: $worktree_path"
            
            # Update terminal title
            if [[ -n "$TERM" && "$TERM" != "dumb" ]]; then
                local branch_name
                branch_name="$(git branch --show-current 2>/dev/null || echo "detached")"
                printf '\033]0;%s - %s\007' "$(basename "$worktree_path")" "$branch_name"
            fi
            
            # Show status
            echo
            git status --short
        else
            echo -e "${RED}❌${NC} Worktree path not found: $worktree_path"
            exit 1
        fi
    fi
}

# Interactive branch selector for creating worktrees
fzf_create_worktree() {
    local manager_script
    manager_script="$(get_manager_script)"
    
    # Get all branches (local and remote)
    local selection
    selection=$(git branch -a --format="%(refname:short)" | \
        grep -v "^HEAD" | \
        sed 's|^origin/||' | \
        sort -u | \
        fzf \
            --ansi \
            --header="Select branch for new worktree (or type new branch name)" \
            --print-query \
            --preview="git log --oneline --graph --decorate {} -10 2>/dev/null || echo 'New branch'" \
            --preview-window="right:50%" \
            --bind="ctrl-r:reload(git branch -a --format='%(refname:short)' | grep -v '^HEAD' | sed 's|^origin/||' | sort -u)")
    
    # fzf returns query on first line, selection on second line
    local query
    local branch
    query="$(echo "$selection" | head -n 1)"
    branch="$(echo "$selection" | tail -n 1)"
    
    # If user typed something and didn't select, use the query
    if [[ -n "$query" && "$query" != "$branch" ]]; then
        branch="$query"
    fi
    
    if [[ -n "$branch" ]]; then
        echo -e "${BLUE}ℹ${NC} Creating worktree for branch: $branch"
        "$manager_script" create "$branch"
        
        # Ask if user wants to switch to the new worktree
        read -p "Switch to new worktree? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$|^$ ]]; then
            local worktree_path
            worktree_path=$("$manager_script" cd "$branch")
            eval "$worktree_path"
        fi
    fi
}

# Interactive worktree remover
fzf_remove_worktree() {
    local current_path
    current_path="$(pwd)"
    
    local selection
    selection=$(git worktree list --porcelain | awk '
        /^worktree / { path = substr($0, 10) }
        /^branch / { 
            branch = substr($0, 18)
            if (path != "'"$current_path"'") {
                # Check for changes
                cmd = "cd " path " && git status --porcelain 2>/dev/null | wc -l"
                cmd | getline changes
                close(cmd)
                
                if (changes > 0) {
                    printf "⚠ %-20s %s (%d changes)\n", branch, path, changes
                } else {
                    printf "  %-20s %s\n", branch, path
                }
            }
        }
    ' | fzf \
        --ansi \
        --header="Select worktree to remove (current worktree excluded)" \
        --preview="cd {2} && git status --short 2>/dev/null || echo 'Cannot access worktree'" \
        --preview-window="right:50%" \
        --multi)
    
    if [[ -n "$selection" ]]; then
        echo "$selection" | while IFS= read -r line; do
            local branch
            local path
            branch="$(echo "$line" | awk '{print $2}')"
            path="$(echo "$line" | awk '{print $3}')"
            
            echo -e "${YELLOW}⚠${NC} Removing worktree: $branch ($path)"
            
            # Use the manager script for safe removal
            local manager_script
            manager_script="$(get_manager_script)"
            "$manager_script" remove "$branch"
        done
    fi
}

# Interactive branch cleanup
fzf_clean_branches() {
    local manager_script
    manager_script="$(get_manager_script)"
    
    echo -e "${BLUE}ℹ${NC} Finding merged branches..."
    "$manager_script" clean
}

# Interactive worktree status viewer
fzf_worktree_status() {
    git worktree list --porcelain | awk '
        /^worktree / { path = substr($0, 10) }
        /^branch / { 
            branch = substr($0, 18)
            
            # Get status info
            cmd = "cd " path " && git status --porcelain 2>/dev/null | wc -l"
            cmd | getline changes
            close(cmd)
            
            cmd = "cd " path " && git log --oneline -1 2>/dev/null"
            cmd | getline last_commit
            close(cmd)
            
            # Get ahead/behind info
            cmd = "cd " path " && git rev-list --count --left-right @{upstream}...HEAD 2>/dev/null || echo \"0\t0\""
            cmd | getline ahead_behind
            close(cmd)
            split(ahead_behind, ab, "\t")
            behind = ab[1]
            ahead = ab[2]
            
            status_info = ""
            if (changes > 0) status_info = status_info changes " changes, "
            if (ahead > 0) status_info = status_info ahead " ahead, "
            if (behind > 0) status_info = status_info behind " behind, "
            if (status_info == "") status_info = "clean"
            else status_info = substr(status_info, 1, length(status_info)-2)
            
            printf "%-20s %-50s %s\n", branch, path, status_info
        }
    ' | fzf \
        --ansi \
        --header="Worktree Status (press Enter to switch, Esc to exit)" \
        --preview="cd {2} && echo 'Branch: {1}' && echo 'Path: {2}' && echo && git status 2>/dev/null && echo && git log --oneline --graph --decorate -5 2>/dev/null || echo 'No git history'" \
        --preview-window="right:60%" \
        --bind="enter:execute(cd {2})+abort"
}

# Main menu
show_menu() {
    local options=(
        "🔄 Switch Worktree"
        "➕ Create Worktree"
        "🗑️  Remove Worktree"
        "🧹 Clean Merged"
        "📊 Status Viewer"
        "📋 List All"
        "❌ Exit"
    )
    
    local selection
    selection=$(printf '%s\n' "${options[@]}" | fzf \
        --ansi \
        --header="Git Worktree Manager" \
        --preview="echo 'Git Worktree Interactive Manager' && echo && git worktree list 2>/dev/null || echo 'No worktrees found'" \
        --preview-window="right:50%")
    
    case "$selection" in
        *"Switch Worktree"*)
            fzf_switch_worktree
            ;;
        *"Create Worktree"*)
            fzf_create_worktree
            ;;
        *"Remove Worktree"*)
            fzf_remove_worktree
            ;;
        *"Clean Merged"*)
            fzf_clean_branches
            ;;
        *"Status Viewer"*)
            fzf_worktree_status
            ;;
        *"List All"*)
            local manager_script
            manager_script="$(get_manager_script)"
            "$manager_script" list
            ;;
        *"Exit"*)
            echo -e "${BLUE}ℹ${NC} Goodbye!"
            ;;
        *)
            echo -e "${RED}❌${NC} Invalid selection"
            ;;
    esac
}

# Command line interface
main() {
    check_dependencies
    
    local command="${1:-menu}"
    
    case "$command" in
        switch|s)
            fzf_switch_worktree
            ;;
        create|c)
            fzf_create_worktree
            ;;
        remove|rm)
            fzf_remove_worktree
            ;;
        clean)
            fzf_clean_branches
            ;;
        status)
            fzf_worktree_status
            ;;
        menu|m)
            show_menu
            ;;
        help|--help|-h)
            cat << 'EOF'
Git Worktree FZF Integration

Usage: worktree-fzf.sh [command]

Commands:
  switch, s     Interactive worktree switcher
  create, c     Interactive worktree creator
  remove, rm    Interactive worktree remover
  clean         Clean merged branches
  status        Interactive status viewer
  menu, m       Show interactive menu (default)
  help          Show this help

Key bindings in fzf:
  Ctrl+R        Refresh the list
  Enter         Select item
  Esc           Cancel/exit
  Tab           Multi-select (where applicable)

Examples:
  worktree-fzf.sh switch
  worktree-fzf.sh create
  worktree-fzf.sh
EOF
            ;;
        *)
            echo -e "${RED}❌${NC} Unknown command: $command"
            echo "Use 'worktree-fzf.sh help' for usage information"
            exit 1
            ;;
    esac
}

main "$@"
