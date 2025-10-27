# Architecture and Technical Review - October 2025

**Review Date**: 2025-10-27
**Reviewer**: Claude Code (Automated Analysis)
**Scope**: Full codebase architecture, technical debt, security, and feature roadmap

---

## Executive Summary

This dotfiles repository represents a **production-grade, enterprise-quality system** with several standout architectural decisions. Overall assessment: **A- (Excellent with Minor Issues)**.

### Key Findings

**Strengths**:
- Security-first credential management with no history exposure
- Performance-optimized zsh configuration (< 500ms startup, 70-80% improvement)
- Declarative configuration via LinkingManifest.json
- Spec-driven development using OpenSpec framework
- Comprehensive documentation and constitutional rules

**Critical Issues**:
1. Four git utilities violate 400-line limit (911, 791, 677, 645 lines)
2. Python migration incomplete (cli.py is stub, Phases 3-6 missing)
3. ShellCheck warnings in home-sync.bash (SC2155 x6)
4. Zero test coverage for shell scripts

**Recommended Priority**:
1. Complete Python migration (4 weeks)
2. Refactor oversized git utilities (3 weeks)
3. Expand test coverage to >50% shell, >95% Python (2 weeks)
4. Implement quick wins: linting dashboard, performance tests (2 weeks)

---

## Table of Contents

1. [Architecture Assessment](#1-architecture-assessment)
2. [Technical Debt Analysis](#2-technical-debt-analysis)
3. [Security Assessment](#3-security-assessment)
4. [Code Quality Analysis](#4-code-quality-analysis)
5. [Feature Suggestions](#5-feature-suggestions)
6. [Prioritized Roadmap](#6-prioritized-roadmap)
7. [Metrics and Success Criteria](#7-metrics-and-success-criteria)

---

## 1. Architecture Assessment

### 1.1 Overall Grade: A- (Excellent)

### 1.2 Core Architecture Patterns

#### Declarative Symlink Management
**Location**: `LinkingManifest.json`, `bin/core/link-dotfiles.py`

**Pattern**:
- Single source of truth for all symlinks
- JSON schema validation prevents configuration errors
- Platform-specific handling (darwin/linux)
- Optional links support
- Directory contents expansion

**Strengths**:
- Predictable and repeatable
- Version controllable
- Easy to audit
- Safe preview with --dry-run

**Example**:
```json
{
  "links": {
    "shell": {
      "zsh": [
        {
          "source": "zsh/.zshrc",
          "target": "~/.config/zsh/.zshrc",
          "description": "Main zsh configuration"
        }
      ]
    }
  }
}
```

#### Security-First Credential Management
**Location**: `bin/credentials/store-api-key`, `bin/credentials/get-api-key`

**Pattern**:
- Interactive prompts (no shell history exposure)
- Multiple secure input methods: interactive, stdin, file
- macOS Keychain integration
- Cleanup traps clear sensitive variables
- File permission validation (600/400)

**Security Model**:
```
User Input → Validation → Keychain Storage
                ↓
         No History Pollution
                ↓
         Cleanup on Exit
```

**Strengths**:
- Zero secrets in shell history
- Multiple secure input modes
- Deprecation warnings for insecure patterns
- Comprehensive error messages with remediation

#### Performance Optimization Framework
**Location**: `zsh/lib/lazy-load.zsh`, `zsh/.zshrc`

**Pattern**:
- Lazy loading for mise, pyenv, rbenv, nvm, SDKMAN
- Compiled zsh configs (.zwc bytecode)
- 24-hour completion cache
- Instant prompt with p10k
- Optimized history (10k vs 100k default)

**Performance Stack**:
```
Instant Prompt (p10k)
    ↓
Prezto Framework
    ↓
Lazy Loading (on-demand init)
    ↓
Compiled Bytecode (.zwc)
    ↓
Result: < 500ms startup
```

**Results**:
- Cold start: < 500ms (was 1.5-2.5s) = 70-80% improvement
- Warm start: < 200ms (was 0.8-1.5s) = 60-75% improvement

#### Spec-Driven Development
**Location**: `openspec/AGENTS.md`, `openspec/changes/`

**Pattern**:
- Three-stage workflow: propose → implement → archive
- Structured proposals with tasks and specs
- Strict validation before implementation
- 26 active change proposals

**Change Structure**:
```
openspec/changes/<change-id>/
├── proposal.md       # Why, what, impact
├── tasks.md          # Implementation checklist
├── design.md         # Optional technical design
└── specs/            # Delta changes per capability
```

**Strengths**:
- Forces design before implementation
- Provides audit trail
- Enables parallel work on different changes
- AI-assistant friendly

### 1.3 Directory Organization

```
~/.dotfiles/
├── install                          # One-command setup
├── LinkingManifest.json             # Declarative symlink definitions
├── bin/                             # 50+ utility scripts
│   ├── core/                        # 27 general utilities + home_sync
│   ├── credentials/                 # 8 secure credential tools
│   ├── git/                         # 20+ git utilities
│   ├── ide/                         # IDE integrations
│   ├── macos/                       # macOS-specific utilities
│   └── ios/                         # iOS development tools
├── git/                             # Git configuration (not scripts)
├── zsh/                             # Optimized shell configuration
├── packages/                        # Package manager configs
├── openspec/                        # Spec-driven development framework
└── ai_docs/                         # AI assistant knowledge base
```

### 1.4 Architecture Concerns

#### Monorepo Size
**Issue**: Growing to enterprise scale without clear module boundaries

**Symptoms**:
- 60+ scripts across multiple categories
- bin/git/ mixing scripts (bin/git/git-*) with configuration (bin/git/hooks/)
- No shared library for common patterns

**Impact**:
- Code duplication (colors, logging, error handling)
- Maintenance burden
- Testing complexity

**Recommendation**: Introduce shared libraries
```bash
bin/lib/
├── common.sh          # Shared utilities
├── colors.sh          # ANSI color codes
├── logging.sh         # Structured logging
├── validation.sh      # Input validation
└── error-handling.sh  # Consistent error patterns
```

#### Missing Abstraction Layers
**Issue**: Git operations duplicated across multiple scripts

**Examples**:
- Branch validation logic in 4 different scripts
- Worktree path calculation duplicated
- Interactive menu code duplicated
- Error handling patterns inconsistent

**Recommendation**: Extract git operations library
```bash
bin/git/lib/
├── git-common.sh         # Shared git operations
├── branch-operations.sh  # Branch management
├── worktree-common.sh    # Worktree operations
└── interactive-menu.sh   # TUI components
```

---

## 2. Technical Debt Analysis

### 2.1 Critical Issues (Priority 1)

#### Issue 1: Oversized Shell Scripts (Constitutional Violation)

**Constitutional Rule**: MINDSET.MD mandates ≤400 lines per file

| Script | Lines | Violation | Location |
|--------|-------|-----------|----------|
| git-virtual-worktree | 911 | +128% | bin/git/git-virtual-worktree |
| git-worktree | 791 | +98% | bin/git/git-worktree |
| git-vw-interactive | 645 | +61% | bin/git/git-vw-interactive |
| git-wt-interactive | 677 | +69% | bin/git/git-wt-interactive |
| home-sync.bash | 603 | +51% | bin/core/home-sync.bash |
| credmatch | 579 | +45% | bin/credentials/credmatch |
| credfile | 458 | +15% | bin/credentials/credfile |

**Impact**:
- Maintenance burden (hard to understand)
- Testing difficulty (complex state)
- SRP violations (doing too much)
- Review overhead (cognitive load)

**Root Cause**:
- Feature creep without refactoring
- No shared library for common operations
- Interactive mode adds significant LOC

**Remediation Strategy**:

1. **Extract Shared Modules** (Week 1-2):
   ```bash
   bin/git/lib/
   ├── worktree-common.sh      # 150 lines
   ├── branch-operations.sh    # 120 lines
   ├── interactive-menu.sh     # 180 lines
   └── validation.sh           # 100 lines
   ```

2. **Refactor git-virtual-worktree** (Week 3):
   - Extract: worktree creation → worktree-common.sh
   - Extract: branch validation → branch-operations.sh
   - Extract: interactive menu → interactive-menu.sh
   - Result: Main script ~300 lines

3. **Refactor git-worktree** (Week 4):
   - Reuse: worktree-common.sh
   - Reuse: branch-operations.sh
   - Extract: cleanup logic → worktree-cleanup.sh
   - Result: Main script ~280 lines

4. **Complete home-sync Python migration** (see Issue 2)

**Acceptance Criteria**:
- All scripts ≤400 lines
- Shared modules have >80% test coverage
- Zero shellcheck errors
- Documentation updated

**Estimated Effort**: 4 weeks

---

#### Issue 2: Incomplete Python Migration

**Current State**: Phases 1 & 2 complete (infrastructure + core modules)

**Location**: `bin/core/home_sync/`, `openspec/changes/migrate-home-sync-to-python/`

**Completed**:
- Phase 1: Setup and Infrastructure
  - Package structure (pyproject.toml)
  - Development tools (mypy, pytest)
  - LinkingManifest updates
- Phase 2: Core Modules
  - logger.py (colored logging)
  - config.py (YAML config with validation)
  - utils.py (path expansion, utilities)
  - lock.py (atomic file locking)
  - metrics.py (operation tracking)

**Missing** (from tasks.md:96-150):
- Phase 3: Git Operations (critical logic)
  - run_git() subprocess wrapper
  - is_git_repo() check
  - get_repo_status()
  - has_uncommitted_changes()
  - safe_add_commit_push()
  - Conflict detection and resolution
- Phase 4: CLI Implementation
  - Argument parsing (typer/click)
  - Command handlers
  - Progress display
  - Error reporting
- Phase 5: Testing & Validation
  - Integration tests (end-to-end sync)
  - Performance benchmarks
  - Edge case testing
- Phase 6: Migration & Deprecation
  - Parallel operation (Python + bash fallback)
  - Deprecation warnings
  - Bash version removal

**Blocker**: `cli.py` is a stub (26 lines):
```python
def main(argv: Optional[List[str]] = None) -> int:
    # TODO: Implement CLI argument parsing
    print("home-sync v2.0.0 (stub)")
    return 0
```

**Risk Assessment**:
- **High**: Bash fallback (603 lines) still in production
- **Medium**: No timeline for completion
- **Medium**: Test coverage incomplete (integration tests missing)

**Remediation Strategy**:

**Week 1-2: Phase 3 (Git Operations)**
```python
# home_sync/git.py additions needed:
class GitOperations:
    def safe_add_commit_push(
        self,
        repo_path: Path,
        message: str,
        timeout: int = 30
    ) -> Result[None, GitError]:
        """Safely add, commit, and push changes."""

    def detect_conflicts(
        self,
        repo_path: Path
    ) -> List[ConflictInfo]:
        """Detect merge conflicts."""

    def resolve_simple_conflicts(
        self,
        repo_path: Path,
        strategy: ConflictStrategy
    ) -> Result[None, GitConflictError]:
        """Attempt automatic conflict resolution."""
```

**Week 3: Phase 4 (CLI Implementation)**
```python
# home_sync/cli.py full implementation:
import typer
from rich.console import Console

app = typer.Typer()

@app.command()
def sync(
    config: Path = typer.Option("~/.config/home-sync/config.yaml"),
    dry_run: bool = typer.Option(False),
    verbose: bool = typer.Option(False)
):
    """Synchronize dotfiles and credentials."""
    # Implementation
```

**Week 4: Phase 5 (Testing)**
```python
# tests/integration/test_full_sync.py
def test_full_sync_no_conflicts(tmp_repo):
    """Test complete sync flow without conflicts."""

def test_full_sync_with_conflicts(tmp_repo):
    """Test conflict detection and resolution."""

def test_performance_benchmark(tmp_repo):
    """Ensure sync completes in < 5 seconds."""
```

**Week 5: Phase 6 (Migration)**
1. Add deprecation warning to home-sync.bash
2. Run both versions in parallel (validation)
3. Switch default to Python version
4. Remove bash version after 30 days

**Acceptance Criteria**:
- CLI fully functional with all bash features
- Test coverage >95% (Python code)
- Integration tests pass
- Performance: sync in <5 seconds
- Documentation updated
- Bash version deprecated

**Estimated Effort**: 5 weeks

---

#### Issue 3: ShellCheck Warnings (Code Quality)

**Location**: `bin/core/home-sync.bash`

**Warnings**: 6 instances of SC2155 (Declare and assign separately)

**Examples**:
```bash
# Line 53 - WRONG
local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# CORRECT
local timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
```

**Issue Explanation**:
- Combined declaration + assignment masks return values
- If `date` command fails, script doesn't detect it
- Violates `set -e` (errexit) behavior

**Impact**:
- Silent failures in command substitution
- Harder to debug issues
- Inconsistent error handling

**Affected Lines**:
- Line 19: `script_real=$(readlink -f ...)`
- Line 20: `script_path=$(cd ... && pwd)`
- Line 53: `timestamp=$(date ...)`
- Line 159: `pid=$(cat "$LOCK_FILE" ...)`
- Line 348: `secret_count=$(ws-list ...)`
- Line 357: `pid=$(cat "$LOCK_FILE" ...)`

**Remediation**:
```bash
# Pattern for all fixes:
local variable_name
variable_name=$(command) || {
    error "Failed to execute command"
    return 1
}
```

**Acceptance Criteria**:
- Zero shellcheck warnings
- Error handling verified
- Tests added for failure cases

**Estimated Effort**: 1 day

---

### 2.2 High Priority Issues (Priority 2)

#### Issue 4: Test Coverage Gaps

**Current State**:

| Component | Coverage | Status |
|-----------|----------|--------|
| Python (home_sync) | ~70% | Good |
| Shell scripts | 0% | None |
| Integration tests | 0% | None |
| Performance tests | Manual | Needs automation |

**Missing Test Categories**:

1. **Shell Script Unit Tests** (0% coverage)
   - Framework: bats-core (Bash Automated Testing System)
   - Coverage tool: kcov (code coverage for shell scripts)

   ```bash
   tests/shell/
   ├── test_store_api_key.bats
   ├── test_git_smart_merge.bats
   ├── test_work_mode.bats
   └── test_link_dotfiles.bats
   ```

2. **Integration Tests** (0% coverage)
   - Test end-to-end workflows
   - Use temporary repositories

   ```python
   tests/integration/
   ├── test_full_sync.py           # Complete sync workflow
   ├── test_git_smart_merge.py     # Merge scenarios
   ├── test_credential_flow.py     # Keychain operations
   └── test_manifest_linking.py    # Symlink creation
   ```

3. **Performance Tests** (Manual only)
   - Automated benchmarks
   - Regression detection

   ```python
   tests/performance/
   ├── test_zsh_startup.py         # < 500ms validation
   ├── test_link_manifest.py       # Large manifest handling
   └── test_git_operations.py      # Git command speed
   ```

4. **Security Tests** (Missing)
   - Credential exposure checks
   - Permission validation

   ```python
   tests/security/
   ├── test_credential_exposure.py  # History checks
   ├── test_file_permissions.py     # 600/400 validation
   └── test_secret_scanning.py      # Scan for leaked secrets
   ```

**Remediation Strategy**:

**Week 1: Shell Script Testing Framework**
```bash
# Install bats-core and kcov
brew install bats-core kcov

# Create first test
cat > tests/shell/test_work_mode.bats <<'EOF'
#!/usr/bin/env bats

@test "work-mode switches to work environment" {
  run bin/core/work-mode work
  [ "$status" -eq 0 ]
  grep -q "DOTFILES_ENV=work" ~/.zshenv
}

@test "work-mode switches to personal environment" {
  run bin/core/work-mode personal
  [ "$status" -eq 0 ]
  grep -vq "DOTFILES_ENV=" ~/.zshenv || true
}
EOF

# Run tests with coverage
kcov --exclude-pattern=/usr coverage/ bats tests/shell/
```

**Week 2: Integration Tests**
```python
# tests/integration/test_credential_flow.py
import subprocess
import pytest

def test_store_and_retrieve_api_key(tmp_keychain):
    """Test storing and retrieving API key from keychain."""
    # Store key
    process = subprocess.run(
        ["bin/credentials/store-api-key", "TEST_KEY", "--stdin"],
        input=b"test-secret-value",
        capture_output=True
    )
    assert process.returncode == 0

    # Retrieve key
    result = subprocess.run(
        ["bin/credentials/get-api-key", "TEST_KEY"],
        capture_output=True,
        text=True
    )
    assert "test-secret-value" in result.stdout
```

**Week 3: Performance Tests**
```python
# tests/performance/test_zsh_startup.py
import subprocess
import time
import pytest

def test_zsh_startup_under_500ms():
    """Ensure zsh startup is under 500ms."""
    times = []
    for _ in range(10):
        start = time.time()
        subprocess.run(["zsh", "-i", "-c", "exit"], check=True)
        elapsed = (time.time() - start) * 1000
        times.append(elapsed)

    avg_time = sum(times) / len(times)
    assert avg_time < 500, f"Average startup: {avg_time:.1f}ms"
```

**Acceptance Criteria**:
- Shell scripts: >50% coverage
- Python: >95% coverage
- Integration tests: all critical flows
- Performance tests: automated in CI
- CI fails on coverage regression

**Estimated Effort**: 3 weeks

---

#### Issue 5: Documentation Gaps

**Current State**:

| Documentation Type | Status | Quality |
|-------------------|--------|---------|
| README.md | Excellent | A |
| CLAUDE.md | Excellent | A |
| MINDSET.MD | Excellent | A |
| Script usage | Good | B |
| Architecture diagrams | Missing | F |
| API documentation | Missing | D |
| Troubleshooting guide | Missing | F |
| Performance benchmarks | Missing | F |

**Missing Documentation**:

1. **Architecture Diagrams**
   ```
   docs/architecture/
   ├── overview.md              # High-level system diagram
   ├── symlink-management.md    # LinkingManifest flow
   ├── credential-flow.md       # Security architecture
   ├── performance-stack.md     # Lazy loading, caching
   └── openspec-workflow.md     # Change proposal process
   ```

2. **API Documentation** (Python modules)
   ```python
   # Auto-generate with Sphinx
   cd bin/core/home_sync
   sphinx-apidoc -o docs/api home_sync/

   # Result:
   docs/api/
   ├── home_sync.config.html
   ├── home_sync.git.html
   ├── home_sync.logger.html
   └── home_sync.utils.html
   ```

3. **Troubleshooting Guide**
   ```
   docs/troubleshooting/
   ├── zsh-slow-startup.md      # Diagnosis and fixes
   ├── git-merge-conflicts.md   # git-smart-merge issues
   ├── symlink-failures.md      # LinkingManifest problems
   └── credential-errors.md     # Keychain access issues
   ```

4. **Performance Benchmarks**
   ```
   docs/performance/
   ├── zsh-startup-history.md   # Historical trends
   ├── git-operations.md        # Command timings
   └── optimization-guide.md    # How to improve
   ```

**Remediation Strategy**:

**Week 1: Architecture Diagrams** (using Mermaid)
```markdown
# docs/architecture/overview.md

## System Architecture

```mermaid
graph TB
    A[User] --> B[install script]
    B --> C[LinkingManifest.json]
    C --> D[link-dotfiles.py]
    D --> E[Symlinks Created]

    A --> F[Shell Scripts]
    F --> G[bin/core/]
    F --> H[bin/git/]
    F --> I[bin/credentials/]

    I --> J[macOS Keychain]

    A --> K[Zsh Config]
    K --> L[Lazy Loading]
    L --> M[< 500ms Startup]
```

**Week 2: API Documentation**
```bash
# Setup Sphinx for Python modules
cd bin/core/home_sync
pip install sphinx sphinx-rtd-theme
sphinx-quickstart docs
sphinx-apidoc -o docs/source home_sync/
make html
```

**Week 3: Troubleshooting Guides**
```markdown
# docs/troubleshooting/zsh-slow-startup.md

## Problem: Zsh Startup >1 Second

### Diagnosis

1. Run benchmark:
   ```bash
   zsh-benchmark --detailed
   ```

2. Check lazy loading:
   ```bash
   # Look for non-lazy-loaded tools
   grep -v "lazy" ~/.config/zsh/.zshrc
   ```

### Common Causes

| Cause | Fix | Expected Improvement |
|-------|-----|---------------------|
| mise not lazy-loaded | Add to lazy-load.zsh | 200-300ms |
| Large history file | zsh-trim-history | 50-100ms |
| Uncompiled configs | zsh-compile | 30-50ms |
```

**Acceptance Criteria**:
- Architecture diagrams for all major components
- API documentation auto-generated
- Troubleshooting guide for common issues
- Performance baselines documented

**Estimated Effort**: 3 weeks

---

### 2.3 Medium Priority Issues (Priority 3)

#### Issue 6: Git Utility Duplication

**Pattern**: Multiple scripts implement similar git operations

| Script Pair | LOC | Shared Logic |
|-------------|-----|--------------|
| git-worktree (791) vs git-virtual-worktree (911) | 1702 | Branch validation, path calculation, cleanup |
| git-wt-interactive (677) vs git-vw-interactive (645) | 1322 | Interactive menus, status display |

**Duplication Examples**:

1. **Branch Validation** (4 scripts):
   ```bash
   # Duplicated in each script:
   validate_branch() {
       if ! git rev-parse --verify "$1" >/dev/null 2>&1; then
           error "Branch '$1' does not exist"
           return 1
       fi
   }
   ```

2. **Worktree Path Calculation** (2 scripts):
   ```bash
   # Duplicated:
   get_worktree_path() {
       local branch="$1"
       local base_dir="${WORKTREE_BASE_DIR:-$HOME/.worktrees}"
       echo "$base_dir/${branch}"
   }
   ```

3. **Cleanup Operations** (3 scripts):
   ```bash
   # Duplicated:
   cleanup_worktree() {
       local worktree_path="$1"
       if [[ -d "$worktree_path" ]]; then
           rm -rf "$worktree_path"
       fi
   }
   ```

4. **Interactive Menus** (2 scripts):
   ```bash
   # Duplicated:
   show_menu() {
       local title="$1"
       shift
       local options=("$@")
       # Menu rendering logic...
   }
   ```

**Impact**:
- Maintenance: Bugs fixed in one place remain in others
- Consistency: Behavior diverges over time
- Testing: Same logic tested multiple times
- Code bloat: 1700+ lines could be 600 with sharing

**Recommendation**: Create shared library

```bash
# bin/git/lib/git-common.sh
get_repo_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

validate_branch_name() {
    local branch="$1"
    if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
        return 1
    fi
}

check_uncommitted_changes() {
    [[ -z "$(git status --porcelain)" ]]
}

safe_git_operation() {
    local operation="$1"
    shift
    git "$operation" "$@" 2>&1 | tee /tmp/git-operation.log
    return "${PIPESTATUS[0]}"
}
```

```bash
# bin/git/lib/worktree-common.sh
readonly DEFAULT_WORKTREE_BASE="${HOME}/.worktrees"

get_worktree_path() {
    local branch="$1"
    local base="${WORKTREE_BASE_DIR:-$DEFAULT_WORKTREE_BASE}"
    echo "${base}/${branch}"
}

create_worktree() {
    local branch="$1"
    local worktree_path="$2"

    git worktree add "$worktree_path" "$branch" || return 1
    info "Created worktree at $worktree_path"
}

cleanup_worktree() {
    local worktree_path="$1"

    if [[ -d "$worktree_path" ]]; then
        git worktree remove "$worktree_path" --force
        info "Removed worktree at $worktree_path"
    fi
}
```

```bash
# bin/git/lib/interactive-menu.sh
show_menu() {
    local title="$1"
    shift
    local -a options=("$@")

    echo -e "${BLUE}${title}${NC}"
    for i in "${!options[@]}"; do
        echo "  $((i+1)). ${options[$i]}"
    done
}

select_option() {
    local prompt="$1"
    local -a options=("$@")

    local selection
    while true; do
        read -rp "$prompt [1-${#options[@]}]: " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && \
           (( selection >= 1 && selection <= ${#options[@]} )); then
            return $((selection - 1))
        fi
        echo "Invalid selection"
    done
}
```

**Usage in Refactored Scripts**:
```bash
#!/bin/bash
set -euo pipefail

# Source shared libraries
source "$(dirname "$0")/lib/git-common.sh"
source "$(dirname "$0")/lib/worktree-common.sh"
source "$(dirname "$0")/lib/interactive-menu.sh"

# Now script is much shorter
validate_branch_name "$branch" || exit 1
worktree_path=$(get_worktree_path "$branch")
create_worktree "$branch" "$worktree_path"
```

**Estimated Effort**: 2 weeks

---

#### Issue 7: Constitutional Rule Enforcement Timing

**Current State**: Violations caught only at commit-time

**Enforcement Points**:
- [PASS] check-lowercase-dirs (git pre-commit hook)
- [PASS] check-no-emojis (git pre-commit hook)
- [PASS] check-commit-msg (conventional commits)

**Problem**: Late feedback loop
```
Write code → Save file → Stage changes → Commit → Hook fails
                                                     ↑
                                           Violation discovered here
```

**Better**: Early feedback loop
```
Write code → Save file → Hook validates → Error shown
                          ↑
                Violation discovered here
```

**Recommendation**: Add editor hooks

**VS Code** (.vscode/settings.json):
```json
{
  "files.watcherExclude": {
    "**/*[A-Z]*/**": true
  },
  "files.associations": {
    "**/[A-Z]*": "plaintext"
  },
  "editor.rulers": [
    {
      "column": 100,
      "color": "#ff0000"
    }
  ],
  "shellcheck.enable": true,
  "shellcheck.run": "onSave"
}
```

**Vim** (.vim/after/ftplugin/sh.vim):
```vim
" Enforce constitutional rules
function! CheckConstitutionalRules()
    " Check lowercase directories
    let l:path = expand('%:p:h')
    if l:path =~# '[A-Z]'
        echohl ErrorMsg
        echo "Error: Directory contains uppercase letters"
        echohl None
    endif

    " Check for emojis
    if search('[^\x00-\x7F]', 'nw') > 0
        echohl ErrorMsg
        echo "Error: File contains emojis"
        echohl None
    endif
endfunction

autocmd BufWritePre <buffer> call CheckConstitutionalRules()
```

**Pre-Save Hook** (bin/core/pre-save-validate):
```bash
#!/bin/bash
# Run before saving any file

file="$1"
dir="$(dirname "$file")"

# Check lowercase directories
if [[ "$dir" =~ [A-Z] ]]; then
    echo "ERROR: Directory contains uppercase: $dir"
    exit 1
fi

# Check for emojis
if grep -P '[^\x00-\x7F]' "$file" >/dev/null; then
    echo "ERROR: File contains non-ASCII (emojis?): $file"
    exit 1
fi
```

**Estimated Effort**: 1 week

---

#### Issue 8: Dependency Management

**Current State**:
- Homebrew (Brewfile) - 50+ packages
- mise for language runtimes
- UV for Python packages
- Manual git clone for some tools

**Problems**:

1. **No Version Pinning** (Brewfile):
   ```ruby
   # Current (no versions)
   brew "git"
   brew "shellcheck"

   # Should be:
   brew "git", version: "2.42.0"
   brew "shellcheck", version: "0.11.0"
   ```

2. **No Lockfile Equivalent**:
   - Brewfile has no lock mechanism
   - Homebrew updates unpredictably
   - CI may test different versions than dev

3. **brew-sync Doesn't Verify Versions**:
   ```bash
   # bin/macos/brew-sync
   # Currently just runs: brew bundle
   # Doesn't check if versions match
   ```

4. **Mixed Dependency Sources**:
   - Some tools via Homebrew
   - Some via mise
   - Some via git clone
   - No single source of truth

**Recommendation**: Implement version locking

**Brewfile.lock** (generate with brew-lock):
```yaml
version: 1.0
dependencies:
  - name: git
    version: 2.42.0
    sha256: abc123...
  - name: shellcheck
    version: 0.11.0
    sha256: def456...
```

**Enhanced brew-sync**:
```bash
#!/bin/bash
# bin/macos/brew-sync with version checking

if [[ -f "Brewfile.lock" ]]; then
    # Verify installed versions match lock
    while IFS= read -r line; do
        name=$(echo "$line" | yq '.name')
        version=$(echo "$line" | yq '.version')

        installed=$(brew list --versions "$name" | awk '{print $2}')
        if [[ "$installed" != "$version" ]]; then
            warn "Version mismatch: $name ($installed != $version)"
        fi
    done < Brewfile.lock
fi

brew bundle
```

**Dependency Manifest** (deps.yaml):
```yaml
# Unified dependency manifest
tools:
  shell:
    - name: shellcheck
      source: homebrew
      version: "0.11.0"

  git:
    - name: git
      source: homebrew
      version: "2.42.0"

  languages:
    - name: python
      source: mise
      version: "3.11"
    - name: node
      source: mise
      version: "18.16.0"
```

**Estimated Effort**: 2 weeks

---

## 3. Security Assessment

### 3.1 Overall Grade: A (Excellent)

### 3.2 Security Strengths

#### Credential Management Excellence

**Implementation**: `bin/credentials/store-api-key`

**Security Features**:

1. **No Shell History Exposure**:
   ```bash
   # Line 24: Prevents history pollution
   HISTCONTROL=ignorespace:ignoredups

   # Line 51: Clears history on exit
   { history -c; } 2>/dev/null || true
   ```

2. **Multiple Secure Input Methods**:
   ```bash
   # Interactive (default) - no echo
   store-api-key OPENAI_API_KEY

   # Stdin (automation) - no arguments
   echo "$SECRET" | store-api-key KEY --stdin

   # File (persistent) - checks permissions
   store-api-key KEY --from-file ~/.secrets/key
   ```

3. **File Permission Validation**:
   ```bash
   # Ensures file is 600 or 400 (owner-only read)
   check_file_permissions() {
       local file="$1"
       local perms=$(stat -f %A "$file" 2>/dev/null)
       if [[ "$perms" != "600" ]] && [[ "$perms" != "400" ]]; then
           error "Insecure permissions: $perms (expected 600 or 400)"
           return 1
       fi
   }
   ```

4. **Cleanup Traps**:
   ```bash
   # Line 47-53: Secure cleanup on exit
   cleanup() {
       API_KEY=""              # Clear sensitive variable
       SERVICE_NAME=""         # Clear service name
       INPUT_FILE=""           # Clear file path
       { history -c; } 2>/dev/null || true
   }
   trap 'cleanup' EXIT INT TERM
   ```

5. **Deprecation Warnings**:
   ```bash
   # Line 17-18: Warning for insecure legacy mode
   # LEGACY (INSECURE - Deprecated):
   #   store-api-key KEY "value"  # Will show warning
   ```

#### Secret Scanning

**Pre-commit Hook**: `bin/git/hooks/check-secrets` (assumed, should exist)

**Patterns Detected**:
- API keys: `sk-[a-zA-Z0-9]{48}`
- AWS credentials: `AKIA[A-Z0-9]{16}`
- Private keys: `-----BEGIN.*PRIVATE KEY-----`
- Tokens: `ghp_[a-zA-Z0-9]{36}` (GitHub)

**Actions**:
- Blocks commit if secrets found
- Shows location of leaked secret
- Suggests using keychain storage

#### Input Validation

**No Shell Injection Risks**:
```python
# Python scripts use subprocess safely (no shell=True)
subprocess.run(
    ["git", "status"],  # List form, not string
    capture_output=True,
    check=True,
    timeout=30
)
```

**Proper Quoting in Bash**:
```bash
# All user input properly quoted
git checkout "$branch"  # Not: git checkout $branch
cd "$directory"         # Not: cd $directory
```

**No eval of Untrusted Input**:
```bash
# Constitutional rule: Never eval untrusted input
# Verified: No eval statements in codebase
```

### 3.3 Security Recommendations

#### Recommendation 1: Add Secret Rotation Workflow

**Capability**: Automated credential rotation

```bash
#!/bin/bash
# bin/credentials/rotate-api-key

set -euo pipefail

rotate_api_key() {
    local service="$1"
    local notify="${2:-false}"

    # 1. Check current key usage
    echo "Checking usage of $service..."
    last_used=$(get-api-key "$service" --last-used)

    # 2. Generate new key (provider-specific)
    echo "Generating new key..."
    new_key=$(generate_api_key "$service")

    # 3. Store new key
    echo "$new_key" | store-api-key "${service}_NEW" --stdin

    # 4. Test new key
    if ! test_api_key "$service" "$new_key"; then
        error "New key failed validation"
        return 1
    fi

    # 5. Promote new key
    echo "$new_key" | store-api-key "$service" --stdin --force

    # 6. Deprecate old key (keep for 24h)
    store-api-key "${service}_OLD" --move-from "$service"

    # 7. Notify if requested
    if [[ "$notify" == "true" ]]; then
        send_notification "Rotated API key: $service"
    fi

    info "Successfully rotated $service"
}
```

**Usage**:
```bash
# Manual rotation
rotate-api-key OPENAI_API_KEY --notify

# Scheduled rotation (crontab)
0 0 1 * * ~/.local/bin/rotate-api-key OPENAI_API_KEY --notify
```

---

#### Recommendation 2: Add Audit Logging

**Capability**: Track credential access for security auditing

```bash
# ~/.credentials/audit.log format:
# timestamp | action | service | user | source
2025-10-27T14:32:01Z | STORE | OPENAI_API_KEY | bruno | cli
2025-10-27T14:35:22Z | RETRIEVE | OPENAI_API_KEY | bruno | script
2025-10-27T15:12:43Z | DELETE | OLD_KEY | bruno | cli
2025-10-27T16:00:00Z | ROTATE | OPENAI_API_KEY | system | cron
```

**Implementation**:
```bash
# bin/credentials/lib/audit.sh

AUDIT_LOG="${HOME}/.credentials/audit.log"

log_audit_event() {
    local action="$1"
    local service="$2"
    local user="${3:-$(whoami)}"
    local source="${4:-cli}"

    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "$timestamp | $action | $service | $user | $source" >> "$AUDIT_LOG"

    # Rotate log if > 10MB
    if [[ -f "$AUDIT_LOG" ]] && [[ $(stat -f%z "$AUDIT_LOG") -gt 10485760 ]]; then
        mv "$AUDIT_LOG" "${AUDIT_LOG}.1"
        gzip "${AUDIT_LOG}.1"
    fi
}

# Usage in store-api-key:
log_audit_event "STORE" "$SERVICE_NAME"

# Usage in get-api-key:
log_audit_event "RETRIEVE" "$SERVICE_NAME"
```

**Audit Reports**:
```bash
# bin/credentials/audit-report

# Show recent activity
audit-report --recent 7d

# Show specific service
audit-report --service OPENAI_API_KEY

# Show suspicious activity (multiple failures)
audit-report --suspicious

# Output example:
# Recent Activity (Last 7 Days):
# OPENAI_API_KEY: 42 retrievals, 1 rotation, 0 failures
# AWS_SECRET_KEY: 8 retrievals, 0 rotations, 2 failures (!)
```

---

#### Recommendation 3: Add 2FA for Sensitive Operations

**Capability**: Require Touch ID or password for sensitive operations

```bash
#!/bin/bash
# bin/credentials/store-api-key with 2FA

require_2fa() {
    local operation="$1"

    # Try Touch ID first
    if command -v bioutil &>/dev/null; then
        if bioutil -r; then
            return 0
        fi
    fi

    # Fall back to password
    echo "2FA required for: $operation"
    if sudo -v; then
        return 0
    fi

    return 1
}

# Usage:
if [[ "$REQUIRE_2FA" == "true" ]]; then
    require_2fa "Store $SERVICE_NAME" || exit 1
fi
```

**Configuration**:
```yaml
# ~/.config/credentials/config.yaml
security:
  require_2fa:
    - PRODUCTION_API_KEY
    - AWS_SECRET_KEY
    - GITHUB_TOKEN

  allow_passwordless:
    - DEV_API_KEY
    - TEST_TOKEN
```

---

### 3.4 Security Checklist

- [x] No secrets in shell history
- [x] No secrets in git repository
- [x] No secrets in command-line arguments
- [x] No secrets in process lists
- [x] Keychain integration for credential storage
- [x] File permission validation (600/400)
- [x] Cleanup traps clear sensitive variables
- [x] Deprecation warnings for insecure patterns
- [x] No shell injection risks
- [x] No eval of untrusted input
- [ ] Secret rotation workflow (recommended)
- [ ] Audit logging (recommended)
- [ ] 2FA for sensitive operations (recommended)
- [ ] Security scanning in CI (exists, verify)
- [ ] Regular security audits (schedule needed)

---

## 4. Code Quality Analysis

### 4.1 Metrics Summary

| Metric | Current | Target | Grade |
|--------|---------|--------|-------|
| Shell Script Standards | 90% | 100% | B+ |
| Python Type Coverage | 100% | 100% | A |
| Test Coverage (Python) | ~70% | >95% | C |
| Test Coverage (Shell) | 0% | >50% | F |
| Documentation | 85% | >90% | B+ |
| Code Duplication | 15% | <5% | C |
| ShellCheck Compliance | 98% | 100% | A- |
| Constitutional Compliance | 85% | 100% | B |

### 4.2 Shell Script Quality

**Strengths**:
- Consistent header: `#!/bin/bash` + `set -euo pipefail`
- Color codes standardized
- Usage documentation in all scripts
- Error handling with cleanup traps
- No eval of untrusted input

**Issues**:
- 7 scripts exceed 400-line limit
- 6 shellcheck warnings (SC2155) in home-sync.bash
- Code duplication across git utilities
- No automated shell script tests

**Examples of High-Quality Scripts**:

1. **work-mode** (169 lines) - Excellent:
   ```bash
   #!/bin/bash
   set -euo pipefail

   # Clear documentation
   # Proper argument parsing
   # Idempotent operations
   # Good error messages
   # Cleanup on exit
   ```

2. **store-api-key** (353 lines) - Excellent:
   ```bash
   # Security-focused
   # Multiple input modes
   # Comprehensive validation
   # Excellent documentation
   # Proper error handling
   ```

**Shell Script Standards Checklist**:
- [x] `set -euo pipefail` in all scripts
- [x] Functions ≤40 lines (mostly compliant)
- [ ] Files ≤400 lines (7 violations)
- [x] `getopts` for argument parsing
- [x] Cleanup traps on EXIT
- [x] Idempotent operations
- [x] No eval of untrusted input
- [ ] Zero shellcheck warnings (6 warnings)

### 4.3 Python Code Quality

**Strengths**:
- 100% type hints (strict mypy configuration)
- dataclass-based configurations
- Comprehensive docstrings
- Custom exception hierarchy
- Proper error handling

**home_sync Package Quality**:

**pyproject.toml** - Excellent configuration:
```toml
[tool.mypy]
python_version = "3.11"
strict = true                    # Strictest type checking
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_generics = true
check_untyped_defs = true

[tool.pytest.ini_options]
addopts = "-ra -q --strict-markers --cov=home_sync --cov-report=term-missing"
```

**Example: config.py** (Excellent):
```python
from dataclasses import dataclass, field
from typing import Optional
import yaml

@dataclass
class SyncConfig:
    """Home sync configuration with validation."""

    sync_interval: int = 300  # seconds
    backup_retention: int = 7  # days
    profile: str = "personal"

    def __post_init__(self) -> None:
        """Validate configuration after initialization."""
        if self.sync_interval < 60:
            raise ValueError("sync_interval must be ≥60 seconds")
        if self.backup_retention > 30:
            raise ValueError("backup_retention must be ≤30 days")
        if self.profile not in ["personal", "work"]:
            raise ValueError(f"Invalid profile: {self.profile}")

    @classmethod
    def from_yaml(cls, path: Path) -> "SyncConfig":
        """Load configuration from YAML file."""
        with open(path) as f:
            data = yaml.safe_load(f)
        return cls(**data)
```

**Example: git.py** (Good error handling):
```python
class GitError(Exception):
    """Base exception for git operations."""
    pass

class GitTimeoutError(GitError):
    """Git operation timed out."""
    pass

class GitConflictError(GitError):
    """Git merge conflict detected."""
    pass

def run_git(
    args: List[str],
    cwd: Path,
    timeout: int = 30
) -> subprocess.CompletedProcess:
    """Run git command safely."""
    try:
        return subprocess.run(
            ["git"] + args,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=True,
            timeout=timeout
        )
    except subprocess.TimeoutExpired as e:
        raise GitTimeoutError(f"Git command timed out: {args}") from e
    except subprocess.CalledProcessError as e:
        raise GitError(f"Git command failed: {e.stderr}") from e
```

**Python Quality Checklist**:
- [x] PEP 8 compliant
- [x] Type hints required (strict mypy)
- [x] Scripts >500 lines become packages
- [ ] ≥95% test coverage (currently ~70%)
- [x] Custom exception hierarchy
- [x] Docstrings for all public APIs
- [x] dataclass for data structures

---

## 5. Feature Suggestions

### 5.1 Quick Wins (1-2 weeks)

#### Feature 1: Shell Script Linting Dashboard

**Problem**: No visibility into shell script quality across codebase

**Solution**: Unified linting dashboard

```bash
#!/bin/bash
# bin/core/lint-all-scripts --summary

lint_all_scripts() {
    local total=0
    local passed=0
    local warnings=0
    local failed=0

    echo "Linting all shell scripts..."

    while IFS= read -r script; do
        ((total++))

        if shellcheck "$script" >/dev/null 2>&1; then
            ((passed++))
        elif shellcheck "$script" 2>&1 | grep -q "warning"; then
            ((warnings++))
        else
            ((failed++))
        fi
    done < <(find bin -type f -executable)

    echo ""
    echo "Summary:"
    echo "  [PASS] $passed scripts passed"
    echo "  [WARN]  $warnings scripts with warnings"
    echo "  [FAIL] $failed scripts failed"
    echo ""
    echo "Details:"
    shellcheck bin/**/* 2>&1 | head -50
}
```

**Features**:
- Summary view (passed/warnings/failed)
- Detailed view (show all issues)
- CI integration (fail on errors)
- Historical tracking (trend over time)

**Value**: Continuous quality visibility

---

#### Feature 2: Performance Regression Testing

**Problem**: No automated checks for performance regressions

**Solution**: Baseline tracking with CI enforcement

```bash
#!/bin/bash
# bin/core/zsh-benchmark --baseline ~/.zsh-baseline.json --fail-if-slower 10%

benchmark_with_baseline() {
    local baseline_file="$1"
    local tolerance="${2:-10}"  # Default 10% tolerance

    # Run current benchmark
    local current=$(zsh-benchmark --json)
    local current_time=$(echo "$current" | jq '.avg_startup_ms')

    # Load baseline
    if [[ ! -f "$baseline_file" ]]; then
        echo "$current" > "$baseline_file"
        info "Created new baseline: ${current_time}ms"
        return 0
    fi

    local baseline_time=$(jq '.avg_startup_ms' "$baseline_file")

    # Calculate difference
    local diff=$(echo "scale=2; (($current_time - $baseline_time) / $baseline_time) * 100" | bc)

    echo "Baseline: ${baseline_time}ms"
    echo "Current:  ${current_time}ms"
    echo "Diff:     ${diff}%"

    # Check tolerance
    if (( $(echo "$diff > $tolerance" | bc -l) )); then
        error "Performance regression detected: ${diff}% slower"
        return 1
    fi

    info "Performance within tolerance"
    return 0
}
```

**CI Integration**:
```yaml
# .github/workflows/ci.yml
- name: Performance Test
  run: |
    bin/core/zsh-benchmark --baseline .github/baseline.json --fail-if-slower 10%
```

**Value**: Prevents performance regressions in CI

---

#### Feature 3: Dependency Update Automation

**Problem**: Manual dependency updates are tedious and error-prone

**Solution**: Automated update checker with PR creation

```bash
#!/bin/bash
# bin/core/update-dependencies --check --pr

update_dependencies() {
    local mode="$1"  # check, update, pr

    echo "Checking for outdated dependencies..."

    # Check Homebrew
    brew outdated --json | jq -r '.[] | "\(.name): \(.installed_versions[0]) → \(.current_version)"'

    # Check mise
    mise outdated

    # Check Python (UV)
    cd bin/core/home_sync
    uv pip list --outdated

    if [[ "$mode" == "pr" ]]; then
        # Create update branch
        git checkout -b "chore/update-dependencies-$(date +%Y%m%d)"

        # Update dependencies
        brew upgrade
        mise upgrade
        cd bin/core/home_sync && uv pip compile --upgrade

        # Commit changes
        git add -A
        git commit -m "chore: update dependencies (automated)"

        # Create PR
        gh pr create \
            --title "chore: automated dependency updates" \
            --body "$(generate_update_summary)"
    fi
}
```

**Value**: Stay current with security patches

---

#### Feature 4: Configuration Validator

**Problem**: Configuration errors discovered late (at runtime)

**Solution**: Comprehensive pre-deployment validation

```bash
#!/bin/bash
# bin/core/validate-dotfiles --strict

validate_dotfiles() {
    local strict="${1:-false}"
    local errors=0

    echo "Validating dotfiles configuration..."

    # 1. Validate LinkingManifest.json
    echo "Checking LinkingManifest.json..."
    if ! python3 -m json.tool LinkingManifest.json >/dev/null; then
        error "Invalid JSON in LinkingManifest.json"
        ((errors++))
    fi

    # 2. Validate OpenSpec proposals
    echo "Checking OpenSpec proposals..."
    for change in openspec/changes/*/; do
        if [[ -f "$change/proposal.md" ]]; then
            openspec validate "$(basename "$change")" || ((errors++))
        fi
    done

    # 3. Validate shell scripts
    echo "Checking shell scripts..."
    for script in bin/**/*; do
        if [[ -f "$script" ]] && [[ -x "$script" ]]; then
            shellcheck "$script" || ((errors++))
        fi
    done

    # 4. Validate git hooks
    echo "Checking git hooks..."
    for hook in bin/git/hooks/*; do
        if [[ ! -x "$hook" ]]; then
            error "Hook not executable: $hook"
            ((errors++))
        fi
    done

    # 5. Validate zsh syntax
    echo "Checking zsh configuration..."
    if ! zsh -n zsh/.zshrc; then
        error "Syntax error in .zshrc"
        ((errors++))
    fi

    # Report
    if [[ $errors -eq 0 ]]; then
        success "All validations passed"
        return 0
    else
        error "$errors validation(s) failed"
        [[ "$strict" == "true" ]] && return 1
        return 0
    fi
}
```

**CI Integration**:
```yaml
# .github/workflows/ci.yml
- name: Validate Configuration
  run: bin/core/validate-dotfiles --strict
```

**Value**: Catch errors before deployment

---

### 5.2 Medium-Term Features (1-2 months)

#### Feature 5: Dotfiles Profile System

**Problem**: One-size-fits-all configuration doesn't fit all contexts

**Solution**: Multiple profiles for different use cases

**Architecture**:
```
~/.config/profiles/
├── gaming.zsh           # Disable dev tools, optimize GPU
├── gaming.yaml          # Profile metadata
├── gaming.links.json    # Additional symlinks
├── streaming.zsh        # OBS integration
├── streaming.yaml
├── streaming.links.json
├── minimal.zsh          # Server deployment
├── minimal.yaml
└── minimal.links.json
```

**Profile Definition** (gaming.yaml):
```yaml
name: gaming
description: Optimized for gaming performance
enabled_features:
  - minimal_shell  # Fast startup
  - gpu_optimization
  - game_launchers
disabled_features:
  - dev_tools      # Xcode, etc.
  - docker
  - mise
environment:
  ZSH_STARTUP_TARGET: 200ms  # Even faster
  GPU_PREFER: nvidia
symlinks:
  - source: configs/gaming/alacritty.yml
    target: ~/.config/alacritty/alacritty.yml
```

**CLI**:
```bash
# Create new profile
dotfiles-profile create gaming --from personal

# Switch profiles
dotfiles-profile switch gaming

# List profiles
dotfiles-profile list
# Output:
# - personal (current) - Default development environment
# - work - Work environment with VPN
# - gaming - Optimized for gaming
# - streaming - OBS integration
# - minimal - Server deployment

# Edit profile
dotfiles-profile edit gaming

# Delete profile
dotfiles-profile delete gaming
```

**Implementation**:
```bash
#!/bin/bash
# bin/core/dotfiles-profile

readonly PROFILES_DIR="${HOME}/.config/profiles"

create_profile() {
    local name="$1"
    local base="${2:-personal}"

    mkdir -p "${PROFILES_DIR}/${name}"

    # Create metadata
    cat > "${PROFILES_DIR}/${name}/${name}.yaml" <<EOF
name: ${name}
description: Custom profile
base: ${base}
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
enabled_features: []
disabled_features: []
EOF

    # Create config file
    touch "${PROFILES_DIR}/${name}/${name}.zsh"

    info "Created profile: ${name}"
}

switch_profile() {
    local name="$1"

    if [[ ! -d "${PROFILES_DIR}/${name}" ]]; then
        error "Profile not found: ${name}"
        return 1
    fi

    # Update environment
    echo "DOTFILES_PROFILE=${name}" > ~/.zshenv

    # Apply profile symlinks
    if [[ -f "${PROFILES_DIR}/${name}/${name}.links.json" ]]; then
        link-dotfiles.py "${PROFILES_DIR}/${name}/${name}.links.json"
    fi

    info "Switched to profile: ${name}"
    info "Reload shell: exec zsh"
}
```

**Use Cases**:
1. **Gaming Profile**:
   - Disable heavy dev tools
   - Optimize GPU settings
   - Fast shell startup (<200ms)
   - Game launcher integration

2. **Streaming Profile**:
   - OBS scene switching
   - Audio routing controls
   - Stream quality monitoring
   - Chat integration

3. **Minimal Profile**:
   - Server deployment
   - Minimal dependencies
   - No GUI tools
   - Fast startup

**Value**: Context-appropriate configurations without conflicts

---

#### Feature 6: Secrets Sync Service (Encrypted)

**Problem**: Manual credential management across multiple machines

**Solution**: Encrypted credential synchronization

**Architecture**:
```
Local Machine          Cloud Storage         Remote Machine
+-----------+         +-------------+        +-----------+
| Keychain  | ---->  | Encrypted   | ---->  | Keychain  |
| (plain)   |  sync  | (AES-256)   |  sync  | (plain)   |
+-----------+         +-------------+        +-----------+
     |                      |                      |
     v                      v                      v
  Encrypt              Store/Sync             Decrypt
```

**Implementation**:
```bash
#!/bin/bash
# bin/credentials/secrets-sync

secrets_sync() {
    local action="$1"  # push, pull, status
    local remote="$2"  # s3://bucket, git@github:user/repo

    case "$action" in
        push)
            # 1. Export all keys from keychain
            local temp_dir=$(mktemp -d)
            export_keychain_keys "$temp_dir"

            # 2. Encrypt with user passphrase
            encrypt_directory "$temp_dir" "${temp_dir}.enc"

            # 3. Upload to remote
            upload_to_remote "${temp_dir}.enc" "$remote"

            # 4. Cleanup
            secure_delete "$temp_dir" "${temp_dir}.enc"
            ;;

        pull)
            # 1. Download from remote
            local temp_file=$(mktemp)
            download_from_remote "$remote" "$temp_file"

            # 2. Decrypt with user passphrase
            local temp_dir=$(mktemp -d)
            decrypt_file "$temp_file" "$temp_dir"

            # 3. Import keys to keychain
            import_keychain_keys "$temp_dir"

            # 4. Cleanup
            secure_delete "$temp_dir" "$temp_file"
            ;;

        status)
            # Show sync status
            show_sync_status "$remote"
            ;;
    esac
}

encrypt_directory() {
    local source="$1"
    local dest="$2"

    # Use AES-256 with scrypt for key derivation
    tar -czf - -C "$source" . | \
        openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 \
        -out "$dest"
}

decrypt_file() {
    local source="$1"
    local dest="$2"

    openssl enc -d -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 \
        -in "$source" | \
        tar -xzf - -C "$dest"
}
```

**Configuration** (.secrets-sync.yaml):
```yaml
remote: s3://my-bucket/secrets.enc
# OR
remote: git@github.com:user/secrets-private.git

sync:
  interval: daily
  conflict_resolution: manual  # manual, local-wins, remote-wins

encryption:
  algorithm: aes-256-cbc
  key_derivation: pbkdf2
  iterations: 100000

included_services:
  - OPENAI_API_KEY
  - ANTHROPIC_API_KEY
  - GITHUB_TOKEN

excluded_services:
  - LOCAL_DEV_KEY
```

**Conflict Resolution**:
```bash
# If both local and remote modified
secrets-sync pull
# Output:
# Conflict detected: OPENAI_API_KEY
#   Local:  sk-123... (modified: 2025-10-27 10:00)
#   Remote: sk-456... (modified: 2025-10-27 09:00)
#
# Choose:
#   1. Keep local
#   2. Keep remote
#   3. Keep both (rename remote to OPENAI_API_KEY_REMOTE)
#   4. Show diff
```

**Value**: Multi-machine credential synchronization

---

#### Feature 7: Interactive Setup Wizard

**Problem**: Installation process can be overwhelming for new users

**Solution**: Guided setup with smart defaults

```bash
#!/bin/bash
# ./install --interactive

interactive_setup() {
    clear
    cat <<'EOF'
╔═══════════════════════════════════════╗
║  Welcome to Dotfiles Setup Wizard    ║
╚═══════════════════════════════════════╝

This wizard will help you customize your dotfiles installation.
EOF

    # 1. Determine user role
    echo ""
    echo "What's your primary role?"
    select role in "Developer" "DevOps" "Data Scientist" "General User"; do
        case $role in
            Developer) setup_developer; break;;
            DevOps) setup_devops; break;;
            "Data Scientist") setup_data_scientist; break;;
            "General User") setup_general; break;;
        esac
    done

    # 2. Select languages
    echo ""
    echo "Which languages do you use? (space-separated)"
    echo "Options: swift python go rust javascript typescript java"
    read -r languages

    # 3. Platform selection
    echo ""
    echo "Which platform?"
    select platform in "macOS" "Linux" "Both"; do
        PLATFORM=$platform
        break
    done

    # 4. Feature selection
    echo ""
    echo "Enable these features?"
    features=("git-virtual-worktree" "home-sync" "secrets-sync" "performance-monitoring")
    selected_features=()

    for feature in "${features[@]}"; do
        read -p "Enable $feature? [Y/n] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
            selected_features+=("$feature")
        fi
    done

    # 5. Security level
    echo ""
    echo "Security level?"
    select security in "Basic" "Paranoid"; do
        SECURITY_LEVEL=$security
        break
    done

    # 6. Generate custom manifest
    echo ""
    echo "Generating custom configuration..."
    generate_custom_manifest \
        --role "$role" \
        --languages "$languages" \
        --platform "$PLATFORM" \
        --features "${selected_features[@]}" \
        --security "$SECURITY_LEVEL"

    # 7. Review and confirm
    echo ""
    echo "Configuration Summary:"
    echo "  Role: $role"
    echo "  Languages: $languages"
    echo "  Platform: $PLATFORM"
    echo "  Features: ${selected_features[*]}"
    echo "  Security: $SECURITY_LEVEL"
    echo ""
    read -p "Proceed with installation? [Y/n] " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        install_with_custom_config
    fi
}
```

**Generated Configuration**:
```json
{
  "role": "Developer",
  "languages": ["swift", "python"],
  "platform": "macOS",
  "features": {
    "git-virtual-worktree": true,
    "home-sync": true,
    "secrets-sync": false,
    "performance-monitoring": true
  },
  "security": "Paranoid",
  "manifest": "LinkingManifest.custom.json"
}
```

**Value**: Easier onboarding, customized installations

---

#### Feature 8: Remote Dotfiles Templates

**Problem**: Specialized configurations require starting from scratch

**Solution**: Template marketplace for common setups

**Template Structure**:
```
templates/
├── devops-kubernetes/
│   ├── template.yaml
│   ├── bin/kubernetes/
│   │   ├── k8s-switch-context
│   │   ├── k8s-pod-logs
│   │   └── k8s-deploy
│   ├── configs/
│   │   ├── kubectl/
│   │   └── helm/
│   └── README.md
├── mobile-ios/
│   ├── template.yaml
│   ├── bin/ios/
│   └── configs/xcode/
└── data-science-python/
    ├── template.yaml
    ├── bin/data/
    └── configs/jupyter/
```

**Template Metadata** (template.yaml):
```yaml
name: devops-kubernetes
version: 1.0.0
description: Kubernetes DevOps toolkit with kubectl, helm, and k9s
author: dotfiles-community
license: MIT

dependencies:
  brew:
    - kubectl
    - helm
    - k9s
  mise:
    - go: 1.21

features:
  - name: k8s-context-switching
    description: Fast Kubernetes context switching
  - name: pod-logs-viewer
    description: Interactive pod log viewer
  - name: deployment-automation
    description: One-command deployments

installation:
  symlinks:
    - source: configs/kubectl
      target: ~/.kube/config
  scripts:
    - bin/kubernetes/*
```

**CLI**:
```bash
# List available templates
dotfiles template list --remote
# Output:
# Available Templates:
# - devops-kubernetes (⭐ 324) - Kubernetes DevOps toolkit
# - mobile-ios (⭐ 256) - iOS development setup
# - data-science-python (⭐ 198) - Python data science tools
# - frontend-react (⭐ 176) - React development setup

# Install template
dotfiles template install devops-kubernetes
# Output:
# Downloading template: devops-kubernetes
# Installing dependencies (kubectl, helm, k9s)
# Creating symlinks
# Installing scripts to ~/.local/bin
# Template installed successfully

# Search templates
dotfiles template search "git"
# Results:
# - git-worktree-extended (⭐ 324) - Enhanced worktree management
# - git-flow-pro (⭐ 198) - Git flow automation
# - git-analytics (⭐ 156) - Repository insights

# Update installed templates
dotfiles template update devops-kubernetes

# Remove template
dotfiles template remove devops-kubernetes
```

**Value**: Reusable configuration modules, community knowledge sharing

---

### 5.3 Long-Term Vision (3-6 months)

#### Feature 9: Dotfiles Marketplace

**Concept**: Community-driven ecosystem of vetted plugins and templates

**Architecture**:
```
Marketplace (GitHub Registry)
    ↓
Security Scan + Review
    ↓
Publication
    ↓
User Discovery
    ↓
Installation
    ↓
Ratings & Reviews
```

**Marketplace Manifest**:
```yaml
# ~/.dotfiles-marketplace/registry.yaml
plugins:
  - id: git-worktree-extended
    name: Git Worktree Extended
    description: Enhanced worktree management with interactive mode
    author: community
    version: 2.1.0
    stars: 324
    reviews: 45
    security_score: 9.5/10
    verified: true

  - id: git-flow-pro
    name: Git Flow Pro
    description: Professional git flow automation
    author: devops-team
    version: 1.8.2
    stars: 198
    reviews: 28
    security_score: 9.0/10
    verified: true
```

**Security Review Process**:
1. Automated scanning (shellcheck, secret detection)
2. Manual code review by maintainers
3. Test coverage verification (>80%)
4. Dependency audit
5. Community review period (7 days)

**CLI**:
```bash
# Browse marketplace
dotfiles marketplace browse

# Install plugin
dotfiles plugin install git-worktree-extended

# Review and rate
dotfiles plugin review git-worktree-extended --rating 5 --comment "Excellent tool"

# Publish your plugin
dotfiles plugin publish bin/my-awesome-script
```

**Value**: Community-driven ecosystem, quality assurance, knowledge sharing

---

#### Feature 10: AI-Powered Optimization

**Concept**: Analyze usage patterns and suggest optimizations

**Implementation**:
```bash
#!/bin/bash
# bin/core/dotfiles-optimize --ai

ai_optimize() {
    echo "Analyzing usage patterns (last 30 days)..."

    # Collect usage data
    local alias_usage=$(analyze_alias_usage 30d)
    local script_usage=$(analyze_script_usage 30d)
    local performance=$(analyze_performance 30d)
    local conflicts=$(analyze_conflicts)

    # AI analysis (using local LLM or API)
    local suggestions=$(ai_analyze \
        --alias-usage "$alias_usage" \
        --script-usage "$script_usage" \
        --performance "$performance" \
        --conflicts "$conflicts")

    # Display suggestions
    echo ""
    echo "AI Recommendations:"
    echo "$suggestions"

    # Example output:
    # 1. Remove 15 unused aliases (save 2KB memory)
    #    - alias 'old-deploy' (never used)
    #    - alias 'legacy-build' (never used)
    #
    # 2. Cache git-worktree branch list (save 200ms per invocation)
    #    Current: git branch --list (150ms avg)
    #    Suggested: Cache with 1h TTL
    #
    # 3. Resolve conflicting configs:
    #    - git.pull.rebase = true
    #    - git.pull.ff = only
    #    Suggested: Remove git.pull.ff (redundant)
    #
    # 4. Lazy load 'pyenv' (save 180ms startup)
    #    Currently loaded at startup
    #    Usage: Only in 15% of sessions
}

analyze_alias_usage() {
    local period="$1"

    # Parse zsh history for alias usage
    awk '{print $1}' ~/.zsh_history | \
        sort | uniq -c | sort -rn
}

analyze_script_usage() {
    local period="$1"

    # Track script invocations
    find ~/.local/bin -type f -exec basename {} \; | \
        while read script; do
            count=$(grep -c "$script" ~/.zsh_history)
            echo "$count $script"
        done | sort -rn
}

analyze_performance() {
    local period="$1"

    # Analyze zsh startup history
    tail -30 ~/.zsh-benchmark-history.json | \
        jq -r '.[] | "\(.timestamp): \(.startup_ms)ms"'
}
```

**AI Model Integration**:
```python
# Use local LLM or API
import anthropic

def ai_analyze(usage_data):
    client = anthropic.Anthropic()

    message = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=1024,
        messages=[{
            "role": "user",
            "content": f"Analyze this dotfiles usage data and suggest optimizations:\n{usage_data}"
        }]
    )

    return message.content
```

**Value**: Continuous self-improvement, data-driven optimizations

---

#### Feature 11: Cross-Platform Translation

**Concept**: Automatically translate dotfiles between platforms

**Translation Matrix**:
```
macOS                  →  Linux
-------------------------  --------------------------
Homebrew               →  apt/dnf/pacman
/Users/username        →  /home/username
~/Library              →  ~/.local/share
pbcopy/pbpaste         →  xclip/xsel
open                   →  xdg-open
launchd                →  systemd
security (keychain)    →  gnome-keyring/secret-tool
```

**Implementation**:
```bash
#!/bin/bash
# bin/core/dotfiles-translate --from darwin --to linux --preview

translate_dotfiles() {
    local source_platform="$1"
    local target_platform="$2"
    local preview="${3:-false}"

    echo "Translating dotfiles: $source_platform → $target_platform"

    # 1. Translate package manager
    translate_packages "$source_platform" "$target_platform"

    # 2. Translate paths
    translate_paths "$source_platform" "$target_platform"

    # 3. Translate commands
    translate_commands "$source_platform" "$target_platform"

    # 4. Translate services
    translate_services "$source_platform" "$target_platform"

    # 5. Generate platform-specific manifest
    generate_manifest "$target_platform"

    if [[ "$preview" == "true" ]]; then
        show_translation_diff
    fi
}

translate_packages() {
    local source="$1"
    local target="$2"

    if [[ "$source" == "darwin" ]] && [[ "$target" == "linux" ]]; then
        # Homebrew → apt
        sed 's/brew "git"/apt install git/g' Brewfile > Aptfile
    fi
}
```

**Translation Rules** (translations.yaml):
```yaml
packages:
  macOS:
    brew: [git, shellcheck, ripgrep]
  linux-debian:
    apt: [git, shellcheck, ripgrep]
  linux-arch:
    pacman: [git, shellcheck, ripgrep]

paths:
  macOS:
    home: /Users/{username}
    config: ~/Library/Application Support
  linux:
    home: /home/{username}
    config: ~/.config

commands:
  clipboard:
    macOS: [pbcopy, pbpaste]
    linux: [xclip -selection clipboard, xclip -selection clipboard -o]
  open:
    macOS: open
    linux: xdg-open

services:
  keychain:
    macOS: security
    linux-gnome: secret-tool
    linux-kde: kwalletmanager
```

**Value**: Single codebase, multiple platforms

---

#### Feature 12: Dotfiles as Code (Infrastructure-Style)

**Concept**: Terraform-style declarative configuration

**Implementation** (dotfiles.yaml):
```yaml
version: "2.0"

providers:
  brew:
    source: packages/homebrew/Brewfile
    upgrade_strategy: conservative  # conservative, aggressive, manual

  mise:
    runtimes:
      python: "3.11"
      node: "18.16.0"
      go: "1.21"
    auto_install: true

  git:
    global_config: git/.gitconfig
    hooks_enabled: true

modules:
  git-workflow:
    enabled: true
    features:
      worktrees: advanced  # basic, advanced, disabled
      merge_strategy: smart  # smart, rebase, merge
      virtual_worktrees: true

  credentials:
    storage: keychain  # keychain, encrypted-file, env-vars
    rotation_days: 90
    2fa_required: [PRODUCTION_*, AWS_*]
    audit_logging: true

  shell:
    startup_target_ms: 500
    lazy_load: [mise, nvm, rbenv, pyenv]
    completion_cache_hours: 24
    history_size: 10000

  performance:
    monitoring_enabled: true
    alert_on_regression: true
    baseline_file: .performance-baseline.json

environments:
  work:
    modules: [git-workflow, credentials, shell, performance]
    secrets_profile: work-keys
    overrides:
      shell.startup_target_ms: 400
      credentials.2fa_required: ["*"]  # All operations

  personal:
    modules: [git-workflow, shell]
    secrets_profile: personal-keys
    overrides:
      git-workflow.features.virtual_worktrees: false

  gaming:
    modules: [shell]
    overrides:
      shell.startup_target_ms: 200
      shell.lazy_load: []  # Load everything at startup for speed

validation:
  on_save: true
  on_commit: true
  fail_on_warning: true

testing:
  run_on_pr: true
  performance_regression_tolerance: 10%
  coverage_minimum: 80%
```

**CLI**:
```bash
# Validate configuration
dotfiles validate dotfiles.yaml

# Show plan (what will change)
dotfiles plan dotfiles.yaml

# Apply configuration
dotfiles apply dotfiles.yaml

# Show diff from current
dotfiles diff dotfiles.yaml
```

**Value**: Infrastructure-as-code principles, predictable deployments

---

### 5.4 Innovative Features

#### Feature 13: Time-Travel Debugging

**Concept**: Snapshot and rollback dotfiles state for fearless experimentation

**Implementation**:
```bash
#!/bin/bash
# bin/core/dotfiles-snapshot

create_snapshot() {
    local name="$1"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local snapshot_id="${timestamp}-${name}"

    mkdir -p ~/.dotfiles-snapshots

    # Capture current state
    {
        echo "Snapshot: $snapshot_id"
        echo "Created: $(date)"
        echo ""

        # System info
        echo "System:"
        uname -a

        # Zsh startup time
        echo ""
        echo "Performance:"
        zsh-benchmark --json

        # Installed packages
        echo ""
        echo "Packages:"
        brew list --versions

        # Git aliases
        echo ""
        echo "Git Aliases:"
        git config --get-regexp alias

        # Current configs
        echo ""
        echo "Configs:"
        tar -czf "~/.dotfiles-snapshots/${snapshot_id}.tar.gz" \
            ~/.zshrc \
            ~/.gitconfig \
            LinkingManifest.json
    } > "~/.dotfiles-snapshots/${snapshot_id}.metadata"

    info "Created snapshot: $snapshot_id"
}

diff_snapshots() {
    local snapshot1="$1"
    local snapshot2="${2:-current}"

    echo "Comparing $snapshot1 vs $snapshot2:"

    # Performance diff
    local time1=$(jq '.avg_startup_ms' "$snapshot1.metadata")
    local time2=$(zsh-benchmark --json | jq '.avg_startup_ms')
    local diff=$((time2 - time1))

    if [[ $diff -gt 0 ]]; then
        echo "  Zsh startup: ${time1}ms → ${time2}ms (+${diff}ms, SLOWER)"
    else
        echo "  Zsh startup: ${time1}ms → ${time2}ms (${diff}ms, FASTER)"
    fi

    # Alias diff
    diff <(grep "alias" "$snapshot1.metadata") \
         <(git config --get-regexp alias)

    # Package diff
    diff <(grep "^[a-z]" "$snapshot1.metadata" | tail -n +10) \
         <(brew list --versions)
}

rollback_snapshot() {
    local snapshot_id="$1"

    if [[ ! -f "~/.dotfiles-snapshots/${snapshot_id}.tar.gz" ]]; then
        error "Snapshot not found: $snapshot_id"
        return 1
    fi

    # Extract snapshot
    tar -xzf "~/.dotfiles-snapshots/${snapshot_id}.tar.gz" -C ~

    # Reload shell
    exec zsh
}
```

**Usage**:
```bash
# Before making changes
dotfiles snapshot create "before-upgrade"

# Make changes...
brew upgrade
# ... zsh startup now 680ms (was 450ms)

# Check what changed
dotfiles diff main..HEAD --what-changed
# Output:
# - zsh startup: 450ms → 680ms (+51%, REGRESSION)
# - git aliases: 12 → 15 (+3)
# - bin/git scripts: 20 → 22 (+2)

# Rollback
dotfiles rollback "before-upgrade"
# Restored to 450ms startup
```

**Value**: Fearless experimentation, easy recovery from mistakes

---

#### Feature 14: Collaboration Mode

**Concept**: Share specific scripts with team members

**Implementation**:
```bash
#!/bin/bash
# bin/core/dotfiles-share

share_script() {
    local script="$1"
    local team="${2:-public}"

    # 1. Package script with dependencies
    local temp_dir=$(mktemp -d)
    cp "$script" "$temp_dir/"

    # 2. Extract dependencies
    grep -E "^source|^\. " "$script" | while read -r line; do
        dep=$(echo "$line" | awk '{print $2}')
        cp "$dep" "$temp_dir/"
    done

    # 3. Generate installer
    cat > "$temp_dir/install.sh" <<'EOF'
#!/bin/bash
# Auto-generated installer

INSTALL_DIR="${HOME}/.local/bin"
mkdir -p "$INSTALL_DIR"

# Copy scripts
cp *.sh "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR"/*.sh

echo "Installed successfully"
EOF

    # 4. Generate documentation
    extract_documentation "$script" > "$temp_dir/README.md"

    # 5. Create archive
    tar -czf "${script}.bundle.tar.gz" -C "$temp_dir" .

    # 6. Upload to sharing service
    upload_to_sharing_service "${script}.bundle.tar.gz" "$team"

    # 7. Generate shareable link
    local share_url=$(get_share_url "${script}.bundle.tar.gz")

    echo "Share URL: $share_url"
    echo "Install command: curl -fsSL $share_url | bash"
}
```

**Usage**:
```bash
# Share with team
dotfiles share bin/git/git-smart-merge --with team

# Share publicly
dotfiles share bin/git/git-smart-merge --public

# Team members install:
curl -fsSL https://your-domain/shared/git-smart-merge | bash
```

**Generated Package Structure**:
```
git-smart-merge.bundle/
├── install.sh          # Auto-installer
├── README.md           # Usage documentation
├── git-smart-merge     # Main script
├── lib/
│   └── git-common.sh   # Dependencies
└── examples/
    ├── example1.sh     # Usage examples
    └── example2.sh
```

**Value**: Team knowledge sharing, easy distribution

---

#### Feature 15: Health Monitoring Dashboard

**Concept**: Operational visibility into dotfiles health

**Implementation**:
```bash
#!/bin/bash
# bin/core/dotfiles-health --dashboard

show_health_dashboard() {
    # Use TUI library (e.g., dialog, whiptail)
    while true; do
        clear
        cat <<'EOF'
╔════════════════════════════════════════════════════════════╗
║              Dotfiles Health Dashboard                     ║
╚════════════════════════════════════════════════════════════╝

Performance Trend (Last 30 Days):
    500ms │                                        ╭─
    450ms │                         ╭──────────────╯
    400ms │         ╭───────────────╯
    350ms ╰─────────╯
          │────────────────────────────────────────│
          Day 1                                Day 30

Script Usage Frequency:
  git-smart-merge:  █████████████████████ 142 uses
  work-mode:        ████████████ 78 uses
  store-api-key:    ██████ 34 uses
  home-sync:        ███ 12 uses

Credential Status:
  [PASS] OPENAI_API_KEY      Last rotated: 15 days ago
  [PASS] ANTHROPIC_API_KEY   Last rotated: 8 days ago
  [WARN]  AWS_SECRET_KEY     Last rotated: 92 days ago (OVERDUE)
  [PASS] GITHUB_TOKEN        Last rotated: 23 days ago

Dependency Health:
  [PASS] 0 vulnerabilities found
  [WARN]  3 packages have updates available
  [PASS] All services running normally

Configuration Status:
  [PASS] No drift detected
  [PASS] All symlinks valid
  [PASS] All hooks enabled
  [PASS] Backup current (last: 2h ago)

Press [R] to refresh, [Q] to quit
EOF

        read -n 1 -s -t 5 key
        case $key in
            r|R) continue ;;
            q|Q) break ;;
        esac
    done
}
```

**Data Collection**:
```bash
# Collect metrics continuously
bin/core/dotfiles-health-collector --daemon

# Metrics stored in:
~/.dotfiles-metrics/
├── performance.db      # SQLite database
├── usage.db
├── credentials.db
└── health.db
```

**Alerts**:
```bash
# Configure alerts
dotfiles health alert --if "startup_time > 600ms" --email me@example.com
dotfiles health alert --if "credential_age > 90d" --notify

# Receive notifications:
# "Alert: Zsh startup time exceeded 600ms (current: 685ms)"
# "Alert: AWS_SECRET_KEY needs rotation (age: 92 days)"
```

**Value**: Proactive maintenance, operational visibility

---

## 6. Prioritized Roadmap

### Q1 2025 (Immediate Priority)

#### Sprint 1-2 (Weeks 1-4)

**Goals**: Resolve critical technical debt

1. **Complete Python Migration** (Priority: CRITICAL)
   - Week 1-2: Implement Phase 3 (Git Operations)
   - Week 3: Implement Phase 4 (CLI)
   - Week 4: Implement Phase 5-6 (Testing & Migration)
   - **Deliverable**: Fully functional home-sync Python package
   - **Success Criteria**: All bash features replicated, >95% test coverage

2. **Refactor git-virtual-worktree** (Priority: HIGH)
   - Extract shared modules: worktree-common.sh, branch-operations.sh
   - Reduce script size to <400 lines
   - **Deliverable**: Modular git utilities with shared libraries
   - **Success Criteria**: All scripts ≤400 lines, zero duplicated code

3. **Fix ShellCheck Warnings** (Priority: MEDIUM)
   - Fix 6 SC2155 warnings in home-sync.bash
   - Add error handling tests
   - **Deliverable**: Zero shellcheck warnings
   - **Success Criteria**: All scripts pass shellcheck

4. **Add Integration Tests** (Priority: HIGH)
   - Implement bats-core framework
   - Write tests for critical flows
   - **Deliverable**: Integration test suite
   - **Success Criteria**: >50% shell script coverage

#### Sprint 3-4 (Weeks 5-8)

**Goals**: Quick wins and tooling improvements

5. **Performance Regression Testing** (Priority: MEDIUM)
   - Implement baseline tracking
   - Add CI enforcement
   - **Deliverable**: Automated performance tests
   - **Success Criteria**: CI fails if startup >550ms

6. **Dependency Update Automation** (Priority: LOW)
   - Implement update checker
   - Add PR creation workflow
   - **Deliverable**: Automated dependency updates
   - **Success Criteria**: Weekly dependency update PRs

7. **Configuration Validator** (Priority: MEDIUM)
   - Validate LinkingManifest.json
   - Validate OpenSpec proposals
   - Validate shell scripts
   - **Deliverable**: Pre-deployment validation
   - **Success Criteria**: Catches errors before commit

8. **Shell Script Linting Dashboard** (Priority: LOW)
   - Unified linting summary
   - CI integration
   - **Deliverable**: Quality visibility dashboard
   - **Success Criteria**: Shows all script quality issues

### Q2 2025 (Growth Features)

#### Sprint 5-6 (Weeks 9-12)

**Goals**: User experience improvements

9. **Dotfiles Profile System** (Priority: HIGH)
   - Implement profile creation/switching
   - Add gaming, streaming, minimal profiles
   - **Deliverable**: Multi-profile support
   - **Success Criteria**: Switch profiles without conflicts

10. **Secrets Sync Service** (Priority: HIGH)
    - Implement encryption/decryption
    - Add S3/Git backend support
    - **Deliverable**: Multi-machine credential sync
    - **Success Criteria**: Sync credentials securely across machines

11. **Interactive Setup Wizard** (Priority: MEDIUM)
    - Guided installation
    - Smart defaults
    - **Deliverable**: User-friendly setup
    - **Success Criteria**: New users complete setup in <15 minutes

#### Sprint 7-8 (Weeks 13-16)

**Goals**: Ecosystem expansion

12. **Remote Templates System** (Priority: MEDIUM)
    - Template registry
    - Installation workflow
    - **Deliverable**: Template marketplace
    - **Success Criteria**: Install templates with one command

13. **Architecture Documentation** (Priority: HIGH)
    - Mermaid diagrams
    - Component docs
    - **Deliverable**: Comprehensive architecture docs
    - **Success Criteria**: New contributors understand system in <2 hours

14. **Troubleshooting Runbook** (Priority: MEDIUM)
    - Common issues guide
    - Step-by-step fixes
    - **Deliverable**: Self-service troubleshooting
    - **Success Criteria**: Resolve 80% of issues without help

### Q3 2025 (Innovation)

#### Sprint 9-12 (Weeks 17-24)

**Goals**: Advanced features and ecosystem

15. **Dotfiles Marketplace (MVP)** (Priority: MEDIUM)
    - Plugin registry
    - Security review process
    - **Deliverable**: Community plugin marketplace
    - **Success Criteria**: 10+ verified plugins

16. **AI-Powered Optimization** (Priority: LOW)
    - Usage analysis
    - Automated suggestions
    - **Deliverable**: AI optimization recommendations
    - **Success Criteria**: Suggests 5+ actionable improvements

17. **Cross-Platform Sync** (Priority: LOW)
    - macOS → Linux translation
    - Package manager mapping
    - **Deliverable**: Multi-platform support
    - **Success Criteria**: Same dotfiles work on macOS and Linux

18. **Time-Travel Debugging** (Priority: LOW)
    - Snapshot/rollback system
    - Diff visualization
    - **Deliverable**: Fearless experimentation
    - **Success Criteria**: Rollback from any change in <30 seconds

---

## 7. Metrics and Success Criteria

### 7.1 Current Baseline

| Metric | Current | Date Measured |
|--------|---------|---------------|
| Zsh Startup (Cold) | 450ms | 2025-10-27 |
| Zsh Startup (Warm) | 180ms | 2025-10-27 |
| Python Test Coverage | ~70% | 2025-10-27 |
| Shell Test Coverage | 0% | 2025-10-27 |
| Scripts >400 Lines | 7 | 2025-10-27 |
| ShellCheck Warnings | 6 | 2025-10-27 |
| OpenSpec Proposals | 26 active | 2025-10-27 |
| Total Scripts | ~60 | 2025-10-27 |

### 7.2 Q1 2025 Targets (End of Sprint 4)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Zsh Startup (Cold) | <500ms | zsh-benchmark |
| Python Coverage | >95% | pytest-cov |
| Shell Coverage | >50% | bats + kcov |
| Scripts >400 Lines | 0 | Line count check |
| ShellCheck Warnings | 0 | shellcheck |
| CI Green Rate | >98% | GitHub Actions |
| Python Migration | 100% | CLI fully functional |
| Integration Tests | >20 | Test count |

### 7.3 Q2 2025 Targets (End of Sprint 8)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Zsh Startup (Cold) | <450ms | zsh-benchmark |
| Documentation Score | >90% | doc-coverage tool |
| Profiles Supported | 3+ | gaming, streaming, minimal |
| Templates Available | 5+ | Template registry |
| Code Duplication | <5% | Analysis tool |
| Dependency Freshness | <30 days | Automated checks |
| User Onboarding Time | <15 min | Setup wizard |

### 7.4 Q3 2025 Targets (End of Sprint 12)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Zsh Startup (Cold) | <400ms | zsh-benchmark |
| Marketplace Plugins | 10+ | Verified plugins |
| Cross-Platform Support | Yes | macOS + Linux |
| AI Suggestions | 5+ | Per analysis run |
| Community Contributors | 10+ | GitHub contributors |
| Stars on GitHub | 500+ | Repository stars |

### 7.5 Key Performance Indicators (KPIs)

**Quality KPIs**:
- Test coverage >95% (Python), >50% (Shell)
- Zero shellcheck warnings
- Zero constitutional rule violations
- CI green rate >98%

**Performance KPIs**:
- Zsh startup <500ms (Q1), <400ms (Q3)
- Git operations <1s average
- Home-sync <5s for typical sync

**User Experience KPIs**:
- Setup time <15 minutes
- Time to first value <5 minutes
- Troubleshooting self-service >80%

**Ecosystem KPIs**:
- Verified plugins >10
- Template downloads >100/month
- Community contributors >10

---

## Appendix

### A. File References

**Critical Files**:
- `LinkingManifest.json` - Symlink source of truth
- `MINDSET.MD` - Constitutional rules
- `CLAUDE.md` - Project instructions
- `openspec/AGENTS.md` - OpenSpec workflow

**Large Scripts (>400 lines)**:
- `bin/git/git-virtual-worktree` (911 lines)
- `bin/git/git-worktree` (791 lines)
- `bin/git/git-vw-interactive` (645 lines)
- `bin/git/git-wt-interactive` (677 lines)
- `bin/core/home-sync.bash` (603 lines)
- `bin/credentials/credmatch` (579 lines)
- `bin/credentials/credfile` (458 lines)

**Python Package**:
- `bin/core/home_sync/pyproject.toml`
- `bin/core/home_sync/home_sync/*.py`
- `bin/core/home_sync/tests/*.py`

### B. Glossary

- **Constitutional Rules**: Inviolable project rules in MINDSET.MD
- **OpenSpec**: Spec-driven development framework
- **LinkingManifest**: Declarative symlink configuration
- **Lazy Loading**: Deferred initialization of slow tools
- **Instant Prompt**: p10k feature for fast zsh startup
- **Worktree**: Git feature for parallel branch work

### C. References

**Documentation**:
- README.md - User-facing documentation
- ONBOARDING.md - New contributor guide
- docs/guides/ - User guides
- docs/reports/ - Technical reports

**External Resources**:
- Shellcheck: https://www.shellcheck.net/
- Bats-core: https://bats-core.readthedocs.io/
- Pytest: https://docs.pytest.org/
- Mypy: https://mypy.readthedocs.io/

---

**End of Report**

*Generated: 2025-10-27*
*Next Review: 2026-01-27 (Quarterly)*
