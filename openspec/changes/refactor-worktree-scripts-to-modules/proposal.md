# Refactor Worktree Scripts to Shared Modules

## Why

Both git-worktree (791 lines) and git-virtual-worktree (911 lines) have grown beyond maintainability limits and contain significant code duplication. Shell script standards specify 400-line maximum for maintainability, but both scripts are Python implementations exceeding double that limit.

Analysis reveals substantial duplication:
- Identical: ExitCode enum, GitError exception, Git command wrapper class
- Identical: Validation functions (check_git_repo, check_not_detached_head, check_clean_working_tree)
- Identical: Smart-merge integration (find_git_smart_merge, run_git_smart_merge)
- Similar: Metadata classes with only minor variations
- Similar: Error handling and exit patterns

This violates DRY principle, increases maintenance burden, and makes bug fixes require changes in multiple locations.

## Strategic Context: Monorepo Architecture

This refactoring addresses a symptom of broader architectural issues as the repository grows to enterprise scale:

**Current monorepo challenges:**
- 60+ scripts across multiple categories without clear module boundaries
- bin/git/ mixing executable scripts (bin/git/git-*) with configuration (bin/git/hooks/)
- No shared library infrastructure for common patterns
- Code duplication across bash scripts (colors, logging, error handling)
- Inconsistent error handling and validation patterns

**Immediate action (this change):**
Establish two-tier shared library architecture:

1. General-purpose Python libraries (cross-category utilities):
```
bin/lib/
├── __init__.py
├── common.py          # Shared Python utilities
├── colors.py          # ANSI color codes for Python scripts
├── logging.py         # Structured logging
├── validation.py      # Input validation
└── error_handling.py  # Consistent error patterns
```

2. Git-specific Python libraries (domain-specific):
```
bin/git/lib/
├── __init__.py
├── git_common.py      # Git script utilities (uses bin/lib/common.py)
├── git_operations.py  # Git command wrapper
├── git_validation.py  # Repository validation
└── git_metadata.py    # Metadata serialization
```

**Recommendation for future changes:**
Introduce bash shared libraries when duplication emerges across 3+ shell scripts:
```
bin/lib/
├── common.sh          # Bash shared utilities
├── colors.sh          # ANSI color codes for bash
├── logging.sh         # Structured logging for bash
├── validation.sh      # Input validation for bash
└── error-handling.sh  # Consistent error patterns for bash
```

This establishes a sustainable two-tier pattern:
- **Tier 1 (bin/lib/):** Cross-category shared code (used by bin/core/, bin/credentials/, bin/git/, etc.)
- **Tier 2 (bin/category/lib/):** Category-specific libraries (git, ios, macos, etc.)

## What Changes

**Create general-purpose Python libraries (bin/lib/):**
- common.py: Shared utilities for all Python scripts
- colors.py: ANSI color codes and formatting
- logging.py: Structured logging framework
- validation.py: Common input validation
- error_handling.py: Consistent error patterns and exit codes

**Create git-specific Python libraries (bin/git/lib/):**
- git_common.py: ExitCode, GitError, error_exit, console setup (uses bin/lib/)
- git_validation.py: Repository validation functions
- git_operations.py: Git command wrapper and smart-merge integration
- git_metadata.py: Base metadata class and serialization

**Refactor both scripts:**
- git-worktree: Reduce from 791 to ~300 lines
- git-virtual-worktree: Reduce from 911 to ~300 lines
- Import shared modules instead of duplicating code
- Maintain identical CLI interface (no breaking changes)

**Update documentation:**
- Add bin/lib/README.md explaining general library organization
- Add bin/git/lib/README.md explaining git-specific libraries
- Update script docstrings to reference shared modules
- Add module-level documentation for each library file

## Impact

**Affected code:**
- bin/git/git-worktree (complete refactor)
- bin/git/git-virtual-worktree (complete refactor)
- bin/lib/ (new directory with 5 general-purpose Python modules)
- bin/git/lib/ (new directory with 4 git-specific Python modules)

**Affected specs:**
- None (no existing OpenSpec specifications)

**User impact:**
- No changes to CLI interface or behavior
- Transparent refactor with identical functionality
- **Git aliases preserved:** `git wt` and `git vw` continue to work identically
- Script names and locations unchanged (git-worktree, git-virtual-worktree in bin/git/)
- Interactive wrappers (git-wt-interactive, git-vw-interactive) unaffected
- Future bug fixes propagate to both tools automatically

**Testing requirements:**
- Verify both scripts maintain identical behavior
- Test all commands: create, merge, cleanup, list, status
- **Test git aliases: `git wt` and `git vw` must work identically**
- Verify interactive wrappers (git-wt-interactive, git-vw-interactive) still function
- Ensure error handling unchanged
- Validate timeout configurations preserved
