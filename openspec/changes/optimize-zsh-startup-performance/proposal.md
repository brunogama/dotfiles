# Optimize Zsh Startup Performance

## Why

**PERFORMANCE ISSUE**: Zsh shell startup is slow, negatively impacting developer experience.

### Current Problems Identified

**1. Redundant Initializations:**
- `compinit` called **3 times** in single shell startup
- `zoxide init zsh` evaluated **2 times**
- Multiple PATH modifications scattered throughout files

**2. Heavy Blocking Operations:**
```zsh
# Every shell start executes:
eval "$(mise activate zsh)"           # ~100-200ms
eval "$(rbenv init -)"                # ~50-100ms
eval "$(zoxide init zsh)" # 2x        # ~30-50ms each
source <(fzf --zsh)                   # ~40-80ms
[[ -s sdkman-init.sh ]] && source     # ~50-150ms
[ -s nvm.sh ] && source               # ~200-400ms (if enabled)
```
**Total blocking time: 500-1000ms+**

**3. File System Operations on Every Start:**
```zsh
# In personal-config.zsh and work-config.zsh:
find "$DOTFILES_REPO/scripts" -type f ...     # ~50-100ms
stat operations on multiple files             # ~20-50ms
Conditional make install-scripts              # ~100-500ms if triggered
```

**4. Non-Interactive Shell Pollution:**
- `echo` statements run even for non-interactive shells (scripts)
- Slows down command execution in pipes/scripts

**5. Large History File:**
- 100,000 history entries loaded on every start
- No history file truncation/cleanup

**6. Suboptimal Completion Loading:**
- Docker completions added to fpath before compinit
- No zwc (compiled) files for faster loading

### Measured Impact

**Current startup time (estimated):**
- Cold start: **1.5-2.5 seconds**
- Warm start: **0.8-1.5 seconds**

**Target startup time:**
- Cold start: **<500ms**
- Warm start: **<200ms**

**Goal: 70-80% startup time reduction**

## What Changes

### 1. Lazy Loading Framework

Create `zsh/lib/lazy-load.zsh`:
```zsh
# Lazy load expensive tools - only initialize on first use

# Lazy load mise
if command -v mise &>/dev/null; then
    mise() {
        unfunction mise
        eval "$(command mise activate zsh)"
        mise "$@"
    }
fi

# Lazy load rbenv
if command -v rbenv &>/dev/null; then
    rbenv() {
        unfunction rbenv
        eval "$(command rbenv init -)"
        rbenv "$@"
    }
fi

# Lazy load nvm
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    nvm() {
        unset -f nvm
        source "$NVM_DIR/nvm.sh"
        nvm "$@"
    }

    node() {
        unset -f node nvm
        source "$NVM_DIR/nvm.sh"
        node "$@"
    }

    npm() {
        unset -f npm nvm node
        source "$NVM_DIR/nvm.sh"
        npm "$@"
    }
fi

# Lazy load SDKMAN
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    sdk() {
        unset -f sdk
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        sdk "$@"
    }
fi
```

### 2. Startup Time Profiling Script

Create `bin/core/zsh-benchmark`:
```zsh
#!/usr/bin/env zsh
# Benchmark zsh startup time with detailed breakdown

# Usage: zsh-benchmark [--detailed]

DETAILED=false
[[ "$1" == "--detailed" ]] && DETAILED=true

# Measure total startup time
total_start=$(date +%s%N)

if [[ "$DETAILED" == true ]]; then
    # Enable zsh profiling
    zmodload zsh/zprof
    source ~/.zshrc
    zprof
else
    # Quick benchmark (10 runs)
    echo "Running 10 shell startup benchmarks..."

    times=()
    for i in {1..10}; do
        start=$(date +%s%N)
        zsh -i -c exit
        end=$(date +%s%N)
        elapsed=$(( (end - start) / 1000000 ))
        times+=($elapsed)
        printf "."
    done
    echo ""

    # Calculate statistics
    total=0
    min=${times[1]}
    max=${times[1]}

    for time in "${times[@]}"; do
        total=$((total + time))
        [[ $time -lt $min ]] && min=$time
        [[ $time -gt $max ]] && max=$time
    done

    avg=$((total / 10))

    echo ""
    echo "Startup Time Statistics:"
    echo "  Average: ${avg}ms"
    echo "  Min:     ${min}ms"
    echo "  Max:     ${max}ms"
    echo ""

    # Performance rating
    if [[ $avg -lt 200 ]]; then
        echo "[YES] Excellent! (< 200ms)"
    elif [[ $avg -lt 500 ]]; then
        echo "[OK]  Good (200-500ms)"
    elif [[ $avg -lt 1000 ]]; then
        echo "[WARNING]  Acceptable (500-1000ms)"
    else
        echo "[NO] Slow (> 1000ms) - optimization needed!"
    fi
fi
```

### 3. Optimized .zshrc Structure

```zsh
# ~/.config/zsh/.zshrc (optimized)

# ============================================================================
# 1. INSTANT PROMPT (Keep at top, no changes before this)
# ============================================================================
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# 2. PREZTO INITIALIZATION (unchanged but measured)
# ============================================================================
if [[ -s "$HOME/.zprezto/init.zsh" ]]; then
  source "$HOME/.zprezto/init.zsh"
fi

# ============================================================================
# 3. ENVIRONMENT CONFIGURATION (optimized)
# ============================================================================
# Only load for interactive shells
if [[ -o interactive ]]; then
    if [[ "$DOTFILES_ENV" == "work" ]]; then
        [[ -f ~/.config/zsh/work-config.zsh ]] && source ~/.config/zsh/work-config.zsh
    else
        [[ -f ~/.config/zsh/personal-config.zsh ]] && source ~/.config/zsh/personal-config.zsh
    fi
fi

# ============================================================================
# 4. CORE SETTINGS (fast operations only)
# ============================================================================
export EDITOR="code"
export VISUAL="code"
export GIT_PAGER='delta'

# ============================================================================
# 5. ALIASES (instant, no performance impact)
# ============================================================================
# ... all aliases here ...

# ============================================================================
# 6. LAZY LOADING (defer expensive initializations)
# ============================================================================
source ~/.config/zsh/lib/lazy-load.zsh

# ============================================================================
# 7. ESSENTIAL FAST TOOLS (< 50ms each)
# ============================================================================
# Only initialize truly essential tools that are fast
eval "$(zoxide init zsh)"  # Fast, keep immediate

# ============================================================================
# 8. COMPLETION (consolidated, called only once)
# ============================================================================
# Add completion directories to fpath
fpath=(
    ~/.docker/completions(N)
    ~/.zsh_functions(N)
    $fpath
)

# Compile and load completions (only once!)
autoload -Uz compinit
# Cache completions for 24 hours
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C  # Skip check for speed
fi

# ============================================================================
# 9. PROMPT FINALIZATION
# ============================================================================
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# ============================================================================
# 10. FZF (last, can be deferred)
# ============================================================================
# Load fzf in background for non-interactive or defer
if [[ -o interactive ]]; then
    source <(fzf --zsh) &!  # Background load
fi
```

### 4. Optimized Personal/Work Configs

**Remove blocking file system operations:**
```zsh
# OLD (slow):
NEWEST_SCRIPT=$(find "$DOTFILES_REPO/scripts" ...)
SCRIPTS_MTIME=$(stat -f "%m" "$NEWEST_SCRIPT")
# ... expensive timestamp checking ...

# NEW (fast):
# Move auto-install to background job or separate command
# Only check once per day, not every shell
```

**Add interactive check for echo statements:**
```zsh
# OLD:
echo " Personal environment loaded..."

# NEW:
[[ -o interactive ]] && echo " Personal environment loaded..."
```

### 5. Compilation and Caching

Create `bin/core/zsh-compile`:
```zsh
#!/usr/bin/env zsh
# Compile zsh files for faster loading

echo "Compiling zsh configuration files..."

# Compile main config files
for file in ~/.config/zsh/{.zshrc,.zprofile,.zpreztorc,personal-config.zsh,work-config.zsh,lib/*.zsh}; do
    [[ -f "$file" ]] && zcompile "$file" && echo "[OK] Compiled: $file"
done

# Compile completion dump
[[ -f ~/.config/zsh/.zcompdump ]] && zcompile ~/.config/zsh/.zcompdump

# Compile functions
for func in ~/.zsh_functions/*; do
    [[ -f "$func" ]] && zcompile "$func"
done

echo "[YES] Compilation complete!"
echo "Restart your shell for changes to take effect."
```

### 6. History Optimization

```zsh
# In .zpreztorc - reduce history size
zstyle ':prezto:module:history' histsize 10000    # Was: 100000
zstyle ':prezto:module:history' savehist 10000    # Was: 100000
```

Create `bin/core/zsh-trim-history`:
```zsh
#!/usr/bin/env zsh
# Trim old history to keep only recent entries

HISTFILE="${ZDOTDIR:-$HOME}/.config/zsh/.zsh_history"
KEEP_ENTRIES=10000

if [[ -f "$HISTFILE" ]]; then
    CURRENT_SIZE=$(wc -l < "$HISTFILE" | tr -d ' ')

    if [[ $CURRENT_SIZE -gt $KEEP_ENTRIES ]]; then
        echo "Current history: $CURRENT_SIZE entries"
        echo "Trimming to: $KEEP_ENTRIES entries"

        # Backup
        cp "$HISTFILE" "${HISTFILE}.backup"

        # Keep last N entries
        tail -n "$KEEP_ENTRIES" "$HISTFILE" > "${HISTFILE}.tmp"
        mv "${HISTFILE}.tmp" "$HISTFILE"

        echo "[YES] History trimmed!"
    else
        echo "[OK] History size OK ($CURRENT_SIZE entries)"
    fi
fi
```

### 7. Background Auto-Install

Move auto-install logic to separate command:
```zsh
# bin/core/update-dotfiles-scripts
#!/usr/bin/env zsh
# Update scripts from dotfiles repo (run manually or via cron)

DOTFILES_REPO="$HOME/.config-fixing-dot-files-bugs"

if [[ -d "$DOTFILES_REPO" ]]; then
    echo "Updating scripts from $DOTFILES_REPO..."
    cd "$DOTFILES_REPO" || exit 1
    make install-scripts
    echo "[YES] Scripts updated!"
fi
```

Remove from personal/work configs, replace with:
```zsh
# Check once per day (cached)
if [[ ! -f ~/.cache/zsh-scripts-checked-$(date +%Y%m%d) ]]; then
    update-dotfiles-scripts &!  # Background update
    touch ~/.cache/zsh-scripts-checked-$(date +%Y%m%d)
fi
```

## Impact

### Files Created
- `zsh/lib/lazy-load.zsh` - Lazy loading framework
- `bin/core/zsh-benchmark` - Startup time profiler
- `bin/core/zsh-compile` - Compile zsh files
- `bin/core/zsh-trim-history` - History cleanup utility
- `bin/core/update-dotfiles-scripts` - Deferred script updater

### Files Modified
- `zsh/.zshrc` - Complete restructure for performance
- `zsh/personal-config.zsh` - Remove blocking operations
- `zsh/work-config.zsh` - Remove blocking operations
- `zsh/.zpreztorc` - Optimize history size

### Breaking Changes
**None** - All changes are backward compatible:
- Tools still work via lazy loading (transparent)
- History still available (just smaller cap)
- All existing aliases/functions preserved

### New Capabilities
- **Lazy loading**: Heavy tools load on first use
- **Benchmarking**: Measure and track startup time
- **Compilation**: Pre-compiled zsh files (.zwc)
- **History management**: Automated trimming
- **Background updates**: Non-blocking script updates

## Expected Performance Improvements

### Before (Current):
```
Cold start:  1.5-2.5s
Warm start:  0.8-1.5s
```

### After (Optimized):
```
Cold start:  400-600ms  (70% faster)
Warm start:  150-250ms  (80% faster)
```

### Breakdown of Savings:
- **Lazy loading**: -500-800ms (mise, rbenv, nvm, sdkman)
- **Single compinit**: -50-100ms (eliminate 2 redundant calls)
- **Compiled files**: -100-200ms (zwc pre-compiled bytecode)
- **Smaller history**: -50-100ms (10k vs 100k entries)
- **Removed blocking IO**: -100-200ms (no find/stat on startup)
- **Background loading**: -40-80ms (fzf deferred)

**Total savings: ~1-1.5 seconds**

## Migration Path

### Phase 1: Measure (Non-Breaking)
1. Add `zsh-benchmark` script
2. Measure current startup time
3. Enable `zprof` for detailed analysis

### Phase 2: Low-Risk Optimizations
1. Consolidate compinit calls
2. Add interactive checks to echo statements
3. Compile zsh files with `zsh-compile`
4. Reduce history size

### Phase 3: Lazy Loading
1. Create `lazy-load.zsh` framework
2. Move mise, rbenv, nvm, sdkman to lazy load
3. Test each tool still works correctly

### Phase 4: Restructure
1. Reorganize .zshrc into sections
2. Move auto-install to background job
3. Defer non-essential tools

### Phase 5: Validation
1. Benchmark again
2. Verify all tools still functional
3. Update documentation

## Testing Strategy

### Automated Tests
```zsh
# Test lazy loading works
test-lazy-load() {
    zsh -c 'mise --version' || echo "FAIL: mise"
    zsh -c 'rbenv --version' || echo "FAIL: rbenv"
    zsh -c 'node --version' || echo "FAIL: node"
    zsh -c 'sdk version' || echo "FAIL: sdk"
}

# Test startup time
test-startup-time() {
    time=$(zsh-benchmark | grep Average | awk '{print $2}' | tr -d 'ms')
    [[ $time -lt 500 ]] || echo "FAIL: Startup too slow ($time ms)"
}

# Test interactive features
test-interactive() {
    # Completions work
    zsh -i -c 'git <TAB>' &>/dev/null || echo "FAIL: completion"

    # Aliases work
    zsh -i -c 'type ll' | grep -q 'alias' || echo "FAIL: aliases"
}
```

### Manual Tests
1. Open new terminal → should be fast
2. Run `mise --version` → should work (lazy loads)
3. Run `rbenv --version` → should work
4. Run `node --version` → should work
5. Test tab completion → should work
6. Test history search (Ctrl+R) → should work
7. Test fzf bindings → should work

## Success Criteria

- [YES] Startup time < 500ms (cold), < 250ms (warm)
- [YES] All tools still functional via lazy loading
- [YES] No breaking changes to user experience
- [YES] Benchmark script shows measurable improvement
- [YES] Compiled .zwc files generated
- [YES] No errors in shell startup
- [YES] Completions work correctly
- [YES] History search works correctly

## Future Optimizations (Beyond Scope)

- Consider switching from Prezto to lighter framework (zinit, antidote)
- Investigate P10k instant prompt optimizations
- Profile and optimize Prezto module loading
- Consider async plugin loading (zsh-async)
- Cache environment variable exports
- Lazy load Docker completions

## References

- [Zsh Startup Performance](https://blog.jonlu.ca/posts/speeding-up-zsh)
- [Lazy Loading Zsh](https://frederic-hemberger.de/notes/shell/speed-up-initial-zsh-startup-with-lazy-loading/)
- [Zsh Profiling](https://stevenvanbael.com/profiling-zsh-startup)
