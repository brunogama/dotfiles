# Add syncenv Command - Python-Based Environment Sync

## Why

The current environment management system lacks a unified, delightful sync experience:

**Current Problems:**

1. [NO] **Fragmented Sync Commands**
   - `home-sync sync` for manual sync
   - `personal-backup` / `personal-restore` aliases
   - `work-mode` for switching but no integrated sync
   - No smart git strategy (rebase vs merge)
   - Users need to remember multiple commands

2. [NO] **No Environment-Aware Syncing**
   - Same sync command for both work and personal
   - No per-environment git strategies
   - Can't easily sync current environment context
   - Manual branch management required

3. [NO] **Poor Developer Experience**
   - Bash scripts are hard to maintain and extend
   - No rich CLI with colors/spinners/progress
   - Error handling is basic
   - No dry-run or verbose modes for debugging

4. [NO] **No Smart Git Operations**
   - No automatic rebase with fallback to merge
   - No conflict detection and guidance
   - No status checking before operations
   - Push failures not gracefully handled

**What Users Want:**
```bash
syncenv personal    # Sync personal environment (smart git strategy)
syncenv work        # Sync work environment
syncenv            # Sync current environment
```

**Root Causes:**
- Legacy bash scripts optimized for simplicity over UX
- No environment context awareness in sync logic
- Missing modern CLI patterns (rich output, interactive prompts)
- Git operations too simplistic (no rebase strategy)

## What Changes

### 1. New `syncenv` Command (Python + uv)

**Core Features:**
- Single command for environment-aware syncing
- Environment detection from `DOTFILES_ENV` or argument
- Smart git strategy: `pull --rebase` → fallback to `pull --no-ff` → push
- Beautiful CLI with rich output (colors, spinners, progress)
- Comprehensive error handling with actionable suggestions

**Command API:**
```bash
syncenv [environment] [options]

Arguments:
  environment           Environment to sync (work|personal|current)
                       Default: detect from DOTFILES_ENV

Options:
  --dry-run            Show what would be done without doing it
  --verbose, -v        Show detailed output
  --force, -f          Force sync even with uncommitted changes
  --no-push           Skip push after successful pull
  --status, -s         Show sync status without syncing
  --help, -h           Show help message

Examples:
  syncenv              # Sync current environment
  syncenv personal     # Sync personal environment
  syncenv work --dry-run   # Preview work sync
  syncenv --status     # Check sync status
```

### 2. Smart Git Strategy

**Pull Strategy (with automatic fallback):**
```python
1. Try: git pull --rebase origin main
   [YES] Success → Clean history

2. If rebase fails:
   - Abort rebase automatically
   - Try: git pull --no-ff origin main
   [YES] Success → Merge commit created

3. If merge fails:
   - Show conflict files
   - Provide resolution guide
   - Exit with actionable error

4. After successful pull:
   - Auto-commit if --force flag
   - Push to origin
   - Show summary of changes
```

**Pre-sync Validation:**
- Check git repo exists and is valid
- Detect uncommitted changes
- Verify remote connectivity
- Check branch tracking status

### 3. Beautiful CLI Output

**Using Rich library for:**
-  Color-coded messages (success, warning, error, info)
-  Spinners for long operations ("Pulling from remote...")
-  Progress bars for multi-step operations
-  Tables for status summaries
-  Clear error messages with suggestions

**Example Output:**
```
 Syncing personal environment...

[OK] Repository detected: ~/.config-fixing-dot-files-bugs
[OK] Current branch: main
[OK] Remote: origin (github.com/user/dotfiles.git)

 Pulling changes (rebase)...
[OK] Successfully rebased 3 commits

 Pushing to remote...
[OK] Successfully pushed to origin/main

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Sync complete!

Changes:
  • 3 files updated
  • 12 insertions(+), 5 deletions(-)
  • Fast-forward merge

 Tip: Use --verbose for detailed git output
```

### 4. Python Implementation with uv

**Script Structure:**
```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "rich>=13.7.0",
#     "click>=8.1.0",
#     "gitpython>=3.1.0",
# ]
# ///

"""
syncenv - Environment-aware dotfiles sync with marvelous DX
"""

import click
from rich.console import Console
from rich.spinner import Spinner
import git

# Core sync logic
# Environment detection
# Git operations with fallback
# Beautiful error messages
```

**Key Dependencies:**
- `rich` - Beautiful terminal output
- `click` - CLI framework with auto-help
- `gitpython` - Robust git operations

### 5. Environment Detection

**Priority:**
1. Command argument (`syncenv work`)
2. `DOTFILES_ENV` environment variable
3. Detect from current shell config file
4. Default to `personal`

**Validation:**
- Ensure environment config exists
- Verify git repository path
- Check branch configuration

### 6. Integration with Existing Tools

**Replaces:**
- [NO] `home-sync sync` (kept for compatibility)
- [NO] `personal-backup` / `personal-restore` (deprecated)
- [NO] Manual `git pull && git push` workflows

**Works with:**
- [YES] `work-mode` (switches environment)
- [YES] `make check-installation` (validates setup)
- [YES] Auto-install scripts system
- [YES] Credential management

**Shell Aliases:**
```bash
alias sync="syncenv"               # Quick sync current env
alias sync-work="syncenv work"     # Sync work
alias sync-personal="syncenv personal"  # Sync personal
```

## Impact

**Files Created:**
- `scripts/python/syncenv` - Main Python script with uv
- `tests/test_syncenv.py` - Unit tests (optional)

**Files Modified:**
- `config/zsh/personal-config.zsh` - Add syncenv alias
- `config/zsh/work-config.zsh` - Add syncenv alias
- `Makefile` - Add test-syncenv target (optional)
- `requirements-dev.txt` - Add testing dependencies (optional)

**Files Deprecated (kept for compatibility):**
- `scripts/core/home-sync` - Still works but recommend syncenv

**Breaking Changes:**
- None (all existing commands still work)

**Benefits:**
- [YES] Single, intuitive command for all syncing
- [YES] Environment-aware by default
- [YES] Smart git operations with automatic fallback
- [YES] Beautiful, informative output
- [YES] Better error messages and guidance
- [YES] Dry-run and verbose modes for debugging
- [YES] Modern Python stack (easy to maintain/extend)
- [YES] Automatic dependency management with uv

**Risks:**
- Python dependency (uv + packages) - mitigated by uv's speed and inline deps
- Learning curve for bash users - mitigated by excellent help text
- Potential git edge cases - mitigated by comprehensive error handling

**Testing Checklist:**
- [ ] Sync with clean working directory
- [ ] Sync with uncommitted changes (with/without --force)
- [ ] Rebase success scenario
- [ ] Rebase failure → merge fallback
- [ ] Merge conflict handling
- [ ] Push failure scenarios
- [ ] Environment detection (work vs personal)
- [ ] Dry-run mode accuracy
- [ ] Status command output
- [ ] Integration with existing aliases
- [ ] Performance (should complete in <5s for clean repo)

## Implementation Priority

**Phase 1 (MVP):**
1. Core syncenv script with environment detection
2. Smart pull strategy (rebase → merge fallback)
3. Push after successful pull
4. Basic rich output (colors and spinners)

**Phase 2 (Enhanced):**
5. Dry-run and verbose modes
6. Status command
7. Comprehensive error handling
8. Shell integration (aliases)

**Phase 3 (Polish):**
9. Progress bars for long operations
10. Detailed statistics and summaries
11. Interactive conflict resolution guide
12. Performance optimizations

**Phase 4 (Testing & Docs):**
13. Unit tests with pytest
14. Integration tests
15. Documentation and examples
16. Migration guide from home-sync
