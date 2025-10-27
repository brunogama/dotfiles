# Fix Home Sync Issues

## Why

The `home-sync` command has critical issues preventing it from working correctly:

**Current Problems:**

1. [NO] **Missing Dependency on Fresh Installation**
   - `store-api-key` script not symlinked after creation
   - Error: "Missing dependencies: store-api-key"
   - `make install-scripts` must be run manually after script updates
   - No automatic detection of new/updated scripts

2. [NO] **Incorrect Git Repository Path**
   - Script expects `$HOME/.config` to be a git repository
   - Actual dotfiles repo is at `~/.config-fixing-dot-files-bugs`
   - Hard-coded `DOTFILES_DIR="$HOME/.config"` in script
   - Error: "Not a git repository" when running commands

3. [NO] **Missing sync.sh Script**
   - Script calls `./sync.sh --restow`, `./sync.sh --push`, `./sync.sh --status`
   - No `sync.sh` exists in the repository
   - These commands fail silently or with errors
   - Functionality depends on non-existent script

4. [NO] **Poor Error Handling for Non-Git Directories**
   - `git diff --quiet` fails with verbose help output
   - Should check if directory is git repo before running git commands
   - Error messages pollute output with git usage help

**Impact:**
-  `home-sync-up` completely non-functional
-  Users get cryptic error messages
-  No clear path to fix the issues
-  Installation doesn't set up dependencies correctly
-  Script assumes environment that doesn't match reality

**Root Causes:**
1. Installation process doesn't re-run `make install-scripts` when scripts change
2. Hard-coded paths don't match actual repository location
3. Missing dependency on `sync.sh` script
4. No validation of prerequisites before running git commands

## What Changes

### 1. Auto-Install Scripts on Startup (Preferred Solution)

**Add Script Installation Check to shell configs:**
```bash
# In config/zsh/personal-config.zsh and work-config.zsh
# Auto-install/update scripts if dotfiles repo is available
if [[ -d "$HOME/.config-fixing-dot-files-bugs" ]]; then
    SCRIPTS_TIMESTAMP="$HOME/.config-fixing-dot-files-bugs/scripts"
    LOCAL_BIN="$HOME/.local/bin"

    # Check if scripts need update (newer scripts than symlinks)
    if [[ -d "$SCRIPTS_TIMESTAMP" ]] && [[ -d "$LOCAL_BIN" ]]; then
        if [[ "$SCRIPTS_TIMESTAMP" -nt "$LOCAL_BIN/.scripts-updated" ]] || \
           [[ ! -f "$LOCAL_BIN/.scripts-updated" ]]; then
            (cd "$HOME/.config-fixing-dot-files-bugs" && make install-scripts >/dev/null 2>&1)
            touch "$LOCAL_BIN/.scripts-updated"
        fi
    fi
fi
```

### 2. Fix Git Repository Path Detection

**Update home-sync script:**
```bash
# Auto-detect dotfiles directory
detect_dotfiles_dir() {
    # Check common locations
    local candidates=(
        "$HOME/.config-fixing-dot-files-bugs"
        "$HOME/.config"
        "$HOME/.dotfiles"
        "$HOME/dotfiles"
    )

    for dir in "${candidates[@]}"; do
        if [[ -d "$dir/.git" ]]; then
            echo "$dir"
            return 0
        fi
    done

    log "ERROR" "Could not find dotfiles git repository"
    log "INFO" "Checked: ${candidates[*]}"
    return 1
}

DOTFILES_DIR="${DOTFILES_DIR:-$(detect_dotfiles_dir)}"
```

### 3. Remove sync.sh Dependencies

**Replace sync.sh calls with direct git commands:**
```bash
# Instead of: ./sync.sh --restow
# Use: git submodule update --init --recursive (if using submodules)

# Instead of: ./sync.sh --push
# Use: git push

# Instead of: ./sync.sh --status
# Use: git status --short
```

### 4. Add Git Repository Validation

**Add check before git operations:**
```bash
# Function to check if in git repo
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Use before git commands
if ! is_git_repo; then
    log "ERROR" "Not a git repository: $DOTFILES_DIR"
    log "INFO" "Initialize with: cd $DOTFILES_DIR && git init"
    return 1
fi
```

### 5. Add Installation Status Check

**Add to Makefile:**
```makefile
check-installation:
	@echo "$(BLUE)Checking installation status...$(NC)"
	@command -v store-api-key >/dev/null && echo "$(GREEN)[OK] Scripts installed$(NC)" || echo "$(RED)[X] Scripts not installed - run: make install-scripts$(NC)"
	@test -d $(HOME)/.zprezto && echo "$(GREEN)[OK] Prezto installed$(NC)" || echo "$(YELLOW)[WARNING] Prezto not installed - run: make setup-prezto$(NC)"
	@test -L $(HOME)/.zshrc && echo "$(GREEN)[OK] ZSH linked$(NC)" || echo "$(RED)[X] ZSH not linked - run: make install-zsh$(NC)"
```

## Impact

**Files Modified:**
- `scripts/core/home-sync` - Fix git repo detection, remove sync.sh deps, add validation
- `config/zsh/personal-config.zsh` - Add auto-install script check
- `config/zsh/work-config.zsh` - Add auto-install script check
- `Makefile` - Add check-installation target

**Files Created:**
- None (removing dependency on non-existent sync.sh)

**Breaking Changes:**
- None (fixes broken functionality)

**Benefits:**
- [YES] Scripts auto-update when shell starts
- [YES] Correct git repository automatically detected
- [YES] Clear error messages for missing prerequisites
- [YES] No dependency on non-existent sync.sh
- [YES] Works immediately after installation
- [YES] Self-healing on shell restart

**Risks:**
- Minimal startup time increase (~10ms for timestamp check)
- Need to test on different shell configurations

**Testing Checklist:**
- [ ] Fresh installation works without manual `make install-scripts`
- [ ] New scripts automatically available after adding to repo
- [ ] home-sync commands work in correct git repo
- [ ] Clear error when not in git repo
- [ ] No performance impact on shell startup
- [ ] Works in both work and personal environments

## Implementation Priority

**Phase 1 (Critical):**
1. Fix git repository path detection
2. Add git repository validation
3. Remove sync.sh dependencies

**Phase 2 (Important):**
4. Add auto-install scripts check
5. Add Makefile check-installation target

**Phase 3 (Nice to have):**
6. Add shell startup performance monitoring
7. Add verbose mode for debugging
