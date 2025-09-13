#!/usr/bin/env bash
# Git Worktree Aliases - Enhanced Git aliases for worktree workflow
# Source this file or add to your shell configuration

# Core worktree aliases
alias gwt='git worktree'
alias gwtl='git worktree list'
alias gwta='git worktree add'
alias gwtr='git worktree remove'
alias gwtp='git worktree prune'

# Enhanced worktree aliases using the manager script
alias wt='./scripts/git-worktree-manager.sh'
alias wtc='./scripts/git-worktree-manager.sh create'
alias wts='./scripts/git-worktree-manager.sh switch'
alias wtl='./scripts/git-worktree-manager.sh list'
alias wtrm='./scripts/git-worktree-manager.sh remove'
alias wtclean='./scripts/git-worktree-manager.sh clean'
alias wtstatus='./scripts/git-worktree-manager.sh status'
alias wtsync='./scripts/git-worktree-manager.sh sync'

# Quick navigation aliases
alias wtcd='cd $(./scripts/git-worktree-manager.sh cd'
alias wtgo='eval $(./scripts/git-worktree-manager.sh cd'

# Branch management aliases
alias gbnew='git checkout -b'
alias gbdel='git branch -d'
alias gbforce='git branch -D'
alias gblist='git branch -a'
alias gbclean='git branch --merged | grep -v "\*\|main\|master" | xargs -n 1 git branch -d'

# Enhanced git aliases for worktree workflow
alias gs='git status --short'
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gr='git rebase'
alias gri='git rebase -i'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias glp='git log --oneline --graph --decorate --patch'

# Stash aliases
alias gss='git stash save'
alias gsp='git stash pop'
alias gsl='git stash list'
alias gsd='git stash drop'
alias gsc='git stash clear'

# Remote aliases
alias grem='git remote -v'
alias grema='git remote add'
alias gremd='git remote remove'

# Functions for enhanced workflow
wtswitch() {
    local branch="$1"
    if [[ -z "$branch" ]]; then
        echo "Usage: wtswitch <branch>"
        return 1
    fi
    
    # Try to switch to existing worktree first
    if ./scripts/git-worktree-manager.sh list | grep -q "$branch"; then
        eval "$(./scripts/git-worktree-manager.sh cd "$branch")"
    else
        # Create new worktree if it doesn't exist
        ./scripts/git-worktree-manager.sh create "$branch"
        eval "$(./scripts/git-worktree-manager.sh cd "$branch")"
    fi
}

# Function to create feature branch worktree
wtfeature() {
    local feature_name="$1"
    if [[ -z "$feature_name" ]]; then
        echo "Usage: wtfeature <feature-name>"
        return 1
    fi
    
    local branch_name="feature/$feature_name"
    ./scripts/git-worktree-manager.sh create "$branch_name"
    eval "$(./scripts/git-worktree-manager.sh cd "$branch_name")"
}

# Function to create hotfix branch worktree
wthotfix() {
    local hotfix_name="$1"
    if [[ -z "$hotfix_name" ]]; then
        echo "Usage: wthotfix <hotfix-name>"
        return 1
    fi
    
    local branch_name="hotfix/$hotfix_name"
    ./scripts/git-worktree-manager.sh create "$branch_name"
    eval "$(./scripts/git-worktree-manager.sh cd "$branch_name")"
}

# Function to create release branch worktree
wtrelease() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "Usage: wtrelease <version>"
        return 1
    fi
    
    local branch_name="release/$version"
    ./scripts/git-worktree-manager.sh create "$branch_name"
    eval "$(./scripts/git-worktree-manager.sh cd "$branch_name")"
}

# Function to quickly commit and push in worktree
wtpush() {
    local message="$1"
    if [[ -z "$message" ]]; then
        echo "Usage: wtpush <commit-message>"
        return 1
    fi
    
    git add --all
    git commit -m "$message"
    git push -u origin "$(git branch --show-current)"
}

# Function to sync all worktrees
wtsyncall() {
    echo "🔄 Syncing all worktrees..."
    
    git worktree list --porcelain | while IFS= read -r line; do
        if [[ "$line" =~ ^worktree ]]; then
            local path="${line#worktree }"
            echo "📁 Syncing: $path"
            
            (cd "$path" && git fetch origin && git status --porcelain || echo "⚠️  Could not sync $path")
        fi
    done
}

# Function to show worktree summary
wtsummary() {
    echo "🌳 Worktree Summary"
    echo "=================="
    
    local total_worktrees=0
    local dirty_worktrees=0
    local temp_file
    temp_file="$(mktemp)"
    
    git worktree list --porcelain | while IFS= read -r line; do
        if [[ "$line" =~ ^worktree ]]; then
            local path="${line#worktree }"
            read -r branch_line
            local branch="${branch_line#branch refs/heads/}"
            
            # Check for changes
            local changes=0
            if [[ -d "$path/.git" ]]; then
                changes=$(cd "$path" && git status --porcelain 2>/dev/null | wc -l)
                if [[ "$changes" -gt 0 ]]; then
                    echo "dirty" >> "$temp_file"
                fi
            fi
            echo "total" >> "$temp_file"
            
            printf "%-20s %s (%d changes)\n" "$branch" "$path" "$changes"
        fi
    done
    
    total_worktrees=$(grep -c "total" "$temp_file" 2>/dev/null || echo "0")
    dirty_worktrees=$(grep -c "dirty" "$temp_file" 2>/dev/null || echo "0")
    rm -f "$temp_file"
    
    echo "=================="
    echo "Total worktrees: $total_worktrees"
    echo "With changes: $dirty_worktrees"
}

# Help function
wthelp() {
    cat << 'EOF'
🌳 Git Worktree Aliases & Functions

Core Aliases:
  wt          - Git worktree manager
  wtc         - Create worktree
  wts         - Switch to worktree
  wtl         - List worktrees
  wtrm        - Remove worktree
  wtclean     - Clean merged worktrees
  wtstatus    - Show worktree status
  wtsync      - Sync current worktree

Enhanced Functions:
  wtswitch <branch>     - Switch or create worktree
  wtfeature <name>      - Create feature branch worktree
  wthotfix <name>       - Create hotfix branch worktree
  wtrelease <version>   - Create release branch worktree
  wtpush <message>      - Add, commit, and push
  wtsyncall             - Sync all worktrees
  wtsummary             - Show worktree summary

Git Aliases:
  gs/gst      - Git status
  ga/gaa      - Git add
  gc/gcm      - Git commit
  gp/gpl      - Git push/pull
  gl/gla      - Git log
  gd/gdc      - Git diff
  gblist      - List branches
  gbclean     - Clean merged branches
EOF
}

echo "🌳 Git Worktree aliases loaded! Type 'wthelp' for usage."
