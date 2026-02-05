# Zsh Startup Performance Fix Guide

**Current Performance:** 5.93 seconds  
**Target Performance:** < 0.5 seconds  
**Expected Improvement:** 92% faster (11.86x speedup)

---

## Quick Start

### Option 1: Automated Fix (Recommended)

```bash
# Run the automated fix script
fix-zsh-startup-performance

# Follow the on-screen instructions for manual steps
```

### Option 2: Manual Fix (Step-by-Step)

Follow the detailed instructions below.

---

## Detailed Analysis

### Issue Summary

| Issue | Impact | Priority | Fix Complexity |
|-------|--------|----------|----------------|
| Blocking keychain calls | 1.1s | CRITICAL | Easy |
| Compinit cache not working | 4.0s | CRITICAL | Easy |
| Missing compiled files | 0.3s | MEDIUM | Easy |
| Duplicate .zshrc sourcing | 0.05s | LOW | Easy |

---

## Fix 1: Lazy-Load Nexus Credentials (CRITICAL)

**Problem:** Lines 307-308 in `.zshrc` call keychain on every startup:
```bash
export NEXUS_USER="$(get-api-key NEXUS_USER)"
export NEXUS_PASS="$(get-api-key NEXUS_PASS)"
```

**Impact:** Each call takes ~500ms = 1.1s total wasted time

### Solution

#### Step 1: Create lazy-load file

Create `~/.config/zsh/lib/nexus-lazy-load.zsh`:

```bash
# ============================================================================
# NEXUS CREDENTIALS (Lazy-loaded)
# ============================================================================
# Load credentials only when needed, not on every shell startup.
# Saves ~1.1 seconds by avoiding synchronous keychain calls.

_nexus_credentials_loaded=false

_load_nexus_credentials() {
    if [[ "$_nexus_credentials_loaded" == "false" ]]; then
        export NEXUS_USER="$(get-api-key NEXUS_USER)"
        export NEXUS_PASS="$(get-api-key NEXUS_PASS)"
        _nexus_credentials_loaded=true
    fi
}

# Wrapper functions that auto-load credentials when needed
uv() {
    _load_nexus_credentials
    command uv "$@"
}

pip() {
    _load_nexus_credentials
    # If using lazy-loaded pyenv, initialize it too
    if declare -f pyenv > /dev/null; then
        unfunction pip pyenv 2>/dev/null
        eval "$(command pyenv init -)"
    fi
    command pip "$@"
}

pip3() {
    _load_nexus_credentials
    # If using lazy-loaded pyenv, initialize it too
    if declare -f pyenv > /dev/null; then
        unfunction pip3 pyenv 2>/dev/null
        eval "$(command pyenv init -)"
    fi
    command pip3 "$@"
}
```

#### Step 2: Update .zshrc

In `zsh/.zshrc`, **REMOVE** lines 307-309:
```bash
# DELETE THESE LINES:
export NEXUS_USER="$(get-api-key NEXUS_USER)"
export NEXUS_PASS="$(get-api-key NEXUS_PASS)"
export PATH="/Users/bi002853/.local/bin:$PATH"
```

**REPLACE** with:
```bash
# Lazy-load Nexus credentials (saves ~1.1s on startup)
if [[ -f ~/.config/zsh/lib/nexus-lazy-load.zsh ]]; then
    source ~/.config/zsh/lib/nexus-lazy-load.zsh
fi

# Keep the PATH addition
export PATH="/Users/bi002853/.local/bin:$PATH"
```

**Expected Savings:** ~1.1 seconds ✅

---

## Fix 2: Rebuild Completion Cache (CRITICAL)

**Problem:** `compinit` takes 28.9 seconds because cache is not being used properly.

### Solution

```bash
# Remove old completion cache
rm -f ~/.config/zsh/.zcompdump*

# Optional: Simplify compinit logic in .zshrc
# Replace lines 179-188 with:
autoload -Uz compinit
compinit -C  # Always use cache for speed
```

After this, restart your shell. The cache will be regenerated once, then reused on subsequent startups.

**Expected Savings:** ~4.0 seconds ✅

---

## Fix 3: Compile Zsh Files (MEDIUM PRIORITY)

**Problem:** All zsh files are parsed from source on every startup. Compiling to bytecode makes loading 2-3x faster.

### Solution

```bash
# Compile main config files
zsh -c 'zcompile ~/.config/zsh/.zshrc'
zsh -c 'zcompile ~/.config/zsh/.zshenv'
zsh -c 'zcompile ~/.config/zsh/.zprofile'
zsh -c 'zcompile ~/.config/zsh/.zpreztorc'
zsh -c 'zcompile ~/.config/zsh/.p10k.zsh'
zsh -c 'zcompile ~/.config/zsh/lib/lazy-load.zsh'
zsh -c 'zcompile ~/.config/zsh/personal-config.zsh'
zsh -c 'zcompile ~/.config/zsh/work-config.zsh'

# Compile lazy-load file (if created)
zsh -c 'zcompile ~/.config/zsh/lib/nexus-lazy-load.zsh'

# Compile Prezto modules
for file in ~/.zprezto/modules/*/init.zsh; do
    [[ -f "$file" ]] && zsh -c "zcompile '$file'"
done

# Compile completion dump (after it's regenerated)
zsh -c 'zcompile ~/.config/zsh/.zcompdump'
```

**Note:** Recompile files after editing them:
```bash
# After editing .zshrc
zsh -c 'zcompile ~/.config/zsh/.zshrc'
```

**Expected Savings:** ~0.3 seconds ✅

---

## Fix 4: Remove Duplicate .zshrc Sourcing (LOW PRIORITY)

**Problem:** `.zprofile` sources `.zshrc` explicitly, which may cause double-loading.

### Solution

In `zsh/.zprofile`, **COMMENT OUT** lines 76-82:

```bash
#
# Source .zshrc for login shells
#
# REMOVED: This causes double-loading in some scenarios.
# Interactive shells automatically source .zshrc, so this is redundant.
#
# if [[ -s "${ZDOTDIR:-$HOME}/.zshrc" ]]; then
#   source "${ZDOTDIR:-$HOME}/.zshrc"
# fi
```

**Expected Savings:** ~0.05 seconds ✅

---

## Testing & Verification

### Measure Startup Time

```bash
# Single measurement
time zsh -i -c exit

# Average of 5 runs (more accurate)
for i in {1..5}; do
    time zsh -i -c exit 2>&1 | grep real
done
```

### Profile with zprof

```bash
# Detailed profiling
zsh -i -c 'zmodload zsh/zprof; source ~/.config/zsh/.zshrc; zprof'
```

### Expected Results

| Metric | Before | After |
|--------|--------|-------|
| Startup time | 5.93s | ~0.48s |
| `compinit` time | 28.9s | <0.1s |
| Keychain calls | 2 | 0 |
| Compiled files | 0 | 15+ |

---

## Rollback Instructions

If something goes wrong:

```bash
# Restore from backup (created by automated script)
BACKUP_DIR=$(ls -td ~/.dotfiles/backups/zsh-performance-fix-* | head -1)
cp "$BACKUP_DIR/.zshrc.backup" ~/.dotfiles/zsh/.zshrc
cp "$BACKUP_DIR/.zprofile.backup" ~/.dotfiles/zsh/.zprofile

# Remove compiled files
rm -f ~/.config/zsh/**/*.zwc

# Rebuild completion cache
rm -f ~/.config/zsh/.zcompdump*
```

Or manually revert the changes you made.

---

## Additional Optimizations (Optional)

### 1. Trim History File

Your history has 2,549 entries (relatively small, so less critical):

```bash
# If you have the command
zsh-trim-history

# Or manually
tail -n 1000 ~/.config/zsh/.zsh_history > ~/.config/zsh/.zsh_history.tmp
mv ~/.config/zsh/.zsh_history.tmp ~/.config/zsh/.zsh_history
```

### 2. Optimize P10k Prompt

Your `.p10k.zsh` is 1,712 lines. Consider simplifying:

```bash
# Reconfigure with minimal options
p10k configure

# Choose: fewer segments, no right prompt, instant prompt enabled
```

### 3. Use zsh-benchmark

```bash
# Basic benchmark (10 runs)
zsh-benchmark

# Detailed profiling
zsh-benchmark --detailed
```

---

## Troubleshooting

### Issue: Nexus credentials not loading

**Symptom:** `uv` or `pip` commands fail with authentication errors

**Solution:** Credentials are now lazy-loaded. They'll load automatically on first use. If issues persist:

```bash
# Manually load credentials
_load_nexus_credentials

# Verify they're set
echo $NEXUS_USER
echo $NEXUS_PASS
```

### Issue: Completion not working

**Symptom:** Tab completion broken or slow

**Solution:**

```bash
# Rebuild completion cache
rm -f ~/.config/zsh/.zcompdump*
autoload -U compinit && compinit

# Recompile after regeneration
zsh -c 'zcompile ~/.config/zsh/.zcompdump'
```

### Issue: Shell errors after changes

**Symptom:** Error messages on shell startup

**Solution:**

```bash
# Check syntax errors
zsh -n ~/.config/zsh/.zshrc
zsh -n ~/.config/zsh/lib/nexus-lazy-load.zsh

# View errors in detail
zsh -x -i -c exit 2>&1 | less
```

---

## Implementation Checklist

- [ ] Create backup of `.zshrc` and `.zprofile`
- [ ] Create `~/.config/zsh/lib/nexus-lazy-load.zsh`
- [ ] Update `.zshrc` to remove keychain calls and add lazy-load source
- [ ] Remove completion cache: `rm -f ~/.config/zsh/.zcompdump*`
- [ ] Compile all zsh files
- [ ] Comment out duplicate sourcing in `.zprofile`
- [ ] Test: `time zsh -i -c exit`
- [ ] Verify: Should see < 0.5s
- [ ] Test Nexus credentials work: `uv --version` or similar
- [ ] Verify completion works: Try tab completion
- [ ] Commit changes to git

---

## Questions?

If you encounter issues or have questions, check:

1. **Backup location:** `~/.dotfiles/backups/zsh-performance-fix-YYYYMMDD-HHMMSS/`
2. **Performance report:** `BACKUP_DIR/PERFORMANCE_REPORT.md`
3. **This guide:** `docs/ZSH_PERFORMANCE_FIX_GUIDE.md`

---

**Last Updated:** 2026-02-05  
**Author:** Performance Analysis Script
