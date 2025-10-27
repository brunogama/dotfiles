# Implementation Tasks - Add syncenv Command

## Phase 1: Core Sync Script (MVP) [YES] COMPLETED

### 1.1 Create Python Script Structure with uv [YES]
- [x] Create `scripts/python/` directory
- [x] Create `scripts/python/syncenv` with uv shebang and inline dependencies
- [x] Add script metadata (requires-python, dependencies: rich, click, gitpython)
- [x] Make script executable (`chmod +x`)
- [x] Test uv can run script: `uv run scripts/python/syncenv --help`

### 1.2 Implement Environment Detection [YES]
- [x] Add function to read `DOTFILES_ENV` environment variable
- [x] Add function to detect from `.zshenv` file
- [x] Add command-line argument parsing (work|personal|current)
- [x] Implement priority: CLI arg > DOTFILES_ENV > .zshenv > default
- [x] Validate environment value (only work or personal)
- [x] Add `--help` with clear usage examples

### 1.3 Implement Git Repository Detection [YES]
- [x] Check common dotfiles locations using GitPython
- [x] Validate repository is a valid git repo
- [x] Get current branch name
- [x] Check if branch has upstream tracking
- [x] Return repository object for operations

### 1.4 Implement Smart Pull Strategy [YES]
- [x] Pre-flight checks: uncommitted changes, branch tracking, remote connectivity
- [x] Attempt `git pull --rebase origin <branch>`
- [x] Catch rebase failure and automatically abort
- [x] On rebase failure, attempt `git pull --no-ff origin <branch>`
- [x] Catch merge conflicts
- [x] Return pull result (success, rebase, merge, conflict)

### 1.5 Implement Push After Pull [YES]
- [x] Check if pull was successful
- [x] Attempt `git push origin <branch>`
- [x] Handle push failures (upstream not set, rejected, etc.)
- [x] Return push result

### 1.6 Add Basic Rich Output [YES]
- [x] Import and setup Rich Console
- [x] Add colored status messages ([OK], [X], !, ?)
- [x] Add spinner for pull operation (" Pulling from remote...")
- [x] Add spinner for push operation (" Pushing to remote...")
- [x] Success summary with Panel
- [x] Error messages in red with suggestions

### 1.7 Test MVP End-to-End [YES]
- [x] Test --help command
- [x] Test --status display
- [x] Test --dry-run mode
- [x] Test uncommitted changes detection
- [x] Test environment detection (work vs personal)

## Phase 2: Enhanced Features

### 2.1 Implement Dry-Run Mode
- [ ] Add `--dry-run` flag
- [ ] Show what would be done without executing
- [ ] Display: repo path, current branch, pull strategy, push intention
- [ ] Use different color scheme (yellow/orange for dry-run)

### 2.2 Implement Verbose Mode
- [ ] Add `--verbose / -v` flag
- [ ] Show raw git command output
- [ ] Display detailed step-by-step operations
- [ ] Include timing information for each step

### 2.3 Implement Force Mode
- [ ] Add `--force / -f` flag
- [ ] Auto-commit uncommitted changes with timestamp message
- [ ] Skip pre-flight validation for uncommitted changes
- [ ] Warn user about forced operations

### 2.4 Implement No-Push Mode
- [ ] Add `--no-push` flag
- [ ] Skip push operation after successful pull
- [ ] Useful for pull-only scenarios or conflict resolution

### 2.5 Implement Status Command
- [ ] Add `--status / -s` flag
- [ ] Display: current environment, repo path, branch, tracking status
- [ ] Show uncommitted changes count
- [ ] Show commits ahead/behind remote
- [ ] Show last sync timestamp (from marker file)
- [ ] Use Rich table for formatted output

### 2.6 Comprehensive Error Handling
- [ ] Handle git repository not found
- [ ] Handle network/remote connection errors
- [ ] Handle rebase conflicts with file list
- [ ] Handle merge conflicts with file list
- [ ] Handle push rejected (non-fast-forward)
- [ ] Provide actionable suggestions for each error type

## Phase 3: Polish & Integration

### 3.1 Add Progress Indicators
- [ ] Use Rich Progress for multi-step operations
- [ ] Show: validating → pulling → pushing steps
- [ ] Display elapsed time for long operations
- [ ] Add percentage completion where applicable

### 3.2 Enhanced Statistics
- [ ] Parse git output for files changed, insertions, deletions
- [ ] Display commit count pulled/pushed
- [ ] Show merge type (fast-forward, rebase, merge commit)
- [ ] Display sync duration

### 3.3 Interactive Conflict Resolution
- [ ] Detect merge/rebase conflicts
- [ ] Display conflict files in a table
- [ ] Offer options: abort, resolve manually, force theirs/ours
- [ ] Guide user through resolution steps
- [ ] Rerun sync after conflicts resolved

### 3.4 Shell Integration [YES]
- [x] Add `syncenv` alias to personal-config.zsh
- [x] Add `syncenv` alias to work-config.zsh
- [x] Add convenience aliases: `sync`, `sync-work`, `sync-personal`, `sync-status`, `sync-dry`
- [x] Update environment prompts to mention syncenv
- [x] Document in shell startup messages
- [x] Install script via make install-scripts

### 3.5 Update Documentation
- [ ] Update README with syncenv usage
- [ ] Add syncenv to QUICKSTART.md
- [ ] Document migration from home-sync
- [ ] Add troubleshooting guide for common errors
- [ ] Create man page: `docs/man/man1/syncenv.1`

## Phase 4: Testing & Quality

### 4.1 Unit Tests (Optional)
- [ ] Create `tests/test_syncenv.py`
- [ ] Test environment detection logic
- [ ] Test git repository detection
- [ ] Mock git operations and test error handling
- [ ] Test CLI argument parsing
- [ ] Run tests: `pytest tests/test_syncenv.py`

### 4.2 Integration Tests
- [ ] Create test repository in temp directory
- [ ] Test full sync workflow (pull + push)
- [ ] Test rebase failure → merge fallback
- [ ] Test conflict scenarios
- [ ] Test with both work and personal environments
- [ ] Test all CLI flags (--dry-run, --verbose, --force, etc.)

### 4.3 Performance Testing
- [ ] Benchmark sync time on clean repo (<2s target)
- [ ] Test with large repository (1000+ commits)
- [ ] Optimize slow operations (repo detection, git parsing)
- [ ] Profile with cProfile if needed

### 4.4 Code Quality
- [ ] Run linters: ruff or flake8
- [ ] Format with black
- [ ] Type checking with mypy (if types added)
- [ ] Update pre-commit hooks to check Python files

### 4.5 Makefile Integration
- [ ] Add `make test-syncenv` target
- [ ] Add `make install-syncenv-deps` target (if needed)
- [ ] Update `make check-installation` to verify syncenv
- [ ] Add to main `make install` flow

## Implementation Details

### Script Header (uv inline metadata)
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

Usage:
    syncenv [environment] [options]

Examples:
    syncenv              # Sync current environment
    syncenv personal     # Sync personal environment
    syncenv work --dry-run   # Preview work sync
"""
```

### Core Functions to Implement
```python
def detect_environment(args, env_var) -> str
def find_dotfiles_repo() -> git.Repo
def get_current_branch(repo) -> str
def check_uncommitted_changes(repo) -> list
def pull_with_rebase(repo, branch) -> dict
def pull_with_merge(repo, branch) -> dict
def push_to_remote(repo, branch) -> dict
def display_status(repo, env) -> None
def main() -> None
```

### Rich Output Components
```python
console = Console()

# Spinners
with console.status("[cyan]Pulling from remote..."):
    result = pull_with_rebase()

# Success messages
console.print("[green][OK][/green] Successfully synced!")

# Error messages
console.print("[red][X][/red] Rebase failed, trying merge...")

# Tables (for status)
table = Table(title="Sync Status")
table.add_column("Item", style="cyan")
table.add_column("Value", style="green")
console.print(table)
```

### Git Operations (GitPython)
```python
import git

repo = git.Repo(path)
repo.remotes.origin.pull(rebase=True)  # Pull with rebase
repo.remotes.origin.pull(ff_only=False)  # Pull with merge
repo.remotes.origin.push()  # Push
```

## Verification Checklist

After implementation, verify:
- [ ] `syncenv --help` shows clear usage
- [ ] `syncenv` syncs current environment
- [ ] `syncenv personal` syncs personal environment
- [ ] `syncenv work` syncs work environment
- [ ] Rebase strategy works on clean history
- [ ] Fallback to merge on rebase failure
- [ ] Push succeeds after pull
- [ ] `--dry-run` shows accurate preview
- [ ] `--verbose` shows detailed git output
- [ ] `--force` commits uncommitted changes
- [ ] `--status` displays comprehensive info
- [ ] Error messages are clear and actionable
- [ ] Performance is acceptable (<5s for most operations)
- [ ] Works from any directory (finds dotfiles repo)
- [ ] Shell aliases work correctly
- [ ] Integration with existing tools preserved

## Migration Notes

**For users currently using:**
- `home-sync sync` → `syncenv`
- `personal-backup` → `syncenv personal`
- `home-push` → `syncenv --no-push=false` (default behavior)
- `home-pull` → `syncenv --no-push`

**Backward Compatibility:**
- Keep `home-sync` script for now (deprecate later)
- Add deprecation warnings to old aliases
- Update documentation to recommend `syncenv`

## Dependencies

**Required:**
- Python 3.11+ (for match statements and better type hints)
- `uv` (for running script with inline dependencies)

**Python Packages (auto-installed by uv):**
- `rich` - Terminal formatting and UI
- `click` - CLI framework
- `gitpython` - Git operations

**Optional (for development):**
- `pytest` - Testing framework
- `black` - Code formatter
- `ruff` - Fast linter
- `mypy` - Type checker
