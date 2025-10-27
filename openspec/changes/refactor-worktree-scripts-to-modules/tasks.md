# Implementation Tasks

## Phase 1: Extract Shared Modules (Week 1-2)

### 1.0 Create General Library Infrastructure
- [ ] Create bin/lib/ directory (Tier 1: cross-category)
- [ ] Create bin/lib/__init__.py for package initialization
- [ ] Create bin/lib/README.md explaining general library organization
- [ ] Create bin/git/lib/ directory (Tier 2: git-specific)
- [ ] Create bin/git/lib/__init__.py for package initialization
- [ ] Create bin/git/lib/README.md explaining git-specific libraries

### 1.1 Extract General-Purpose Python Modules (bin/lib/)
- [ ] Extract bin/lib/common.py (~80 lines)
  - [ ] Common utility functions for all Python scripts
  - [ ] Path helpers, file operations
  - [ ] Add module docstring and type hints
  - [ ] Add unit tests
- [ ] Extract bin/lib/colors.py (~60 lines)
  - [ ] ANSI color codes and formatting functions
  - [ ] Console styling utilities
  - [ ] Add module docstring and type hints
  - [ ] Add unit tests for color output
- [ ] Extract bin/lib/logging.py (~100 lines)
  - [ ] Structured logging framework
  - [ ] Log level configuration
  - [ ] Add module docstring and type hints
  - [ ] Add unit tests
- [ ] Extract bin/lib/validation.py (~80 lines)
  - [ ] Common input validation functions
  - [ ] Type checking, range validation
  - [ ] Add module docstring and type hints
  - [ ] Add unit tests for validators
- [ ] Extract bin/lib/error_handling.py (~80 lines)
  - [ ] Consistent error patterns
  - [ ] Base exception classes
  - [ ] Add module docstring and type hints
  - [ ] Add unit tests

### 1.2 Extract git_common.py (~100 lines)
- [ ] Extract ExitCode enum (identical in both scripts)
- [ ] Extract GitError exception class (inherits from bin/lib/error_handling.py)
- [ ] Extract error_exit() function (uses bin/lib/error_handling.py)
- [ ] Extract console initialization (Rich Console setup, uses bin/lib/colors.py)
- [ ] Extract timeout constants (GIT_TIMEOUT, CLONE_TIMEOUT)
- [ ] Add module docstring and type hints
- [ ] Add unit tests for error_exit behavior
- [ ] Ensure proper imports from bin/lib/ modules

### 1.3 Extract git_operations.py (~150 lines)
- [ ] Extract Git class with run() method
- [ ] Extract find_git_smart_merge() function
- [ ] Extract run_git_smart_merge() function
- [ ] Ensure timeout parameter handling preserved
- [ ] Add comprehensive error handling
- [ ] Add module docstring and type hints
- [ ] Add unit tests for Git.run() wrapper
- [ ] Add integration tests for smart-merge detection

### 1.4 Extract git_validation.py (~100 lines)
- [ ] Extract check_git_repo() function
- [ ] Extract check_not_detached_head() function
- [ ] Extract check_clean_working_tree() function
- [ ] Ensure proper error messages with ExitCode
- [ ] Add module docstring and type hints
- [ ] Add unit tests for each validation function
- [ ] Add tests for error conditions

### 1.5 Extract git_metadata.py (~120 lines)
- [ ] Design base Metadata class with common fields
- [ ] Extract to_json() serialization method
- [ ] Extract from_json() deserialization method
- [ ] Support inheritance for WorktreeMetadata and VirtualWorktreeMetadata
- [ ] Add validation in __init__ or as @classmethod
- [ ] Add module docstring and type hints
- [ ] Add unit tests for serialization/deserialization
- [ ] Add tests for invalid metadata handling

## Phase 2: Refactor git-worktree (Week 3)

### 2.1 Update Imports
- [ ] Add imports for git_common module
- [ ] Add imports for git_validation module
- [ ] Add imports for git_operations module
- [ ] Add imports for git_metadata module
- [ ] Remove duplicated code that's now imported

### 2.2 Refactor Metadata
- [ ] Inherit WorktreeMetadata from base Metadata class
- [ ] Remove duplicated serialization methods
- [ ] Add worktree-specific fields if any
- [ ] Update all metadata usage to use shared base

### 2.3 Refactor Manager Class
- [ ] Update WorktreeManager to use Git class from git_operations
- [ ] Replace inline validation with git_validation functions
- [ ] Use error_exit from git_common for error handling
- [ ] Ensure all timeout configurations use shared constants

### 2.4 Refactor CLI Commands
- [ ] Update create() to use shared modules
- [ ] Update merge() to use shared modules
- [ ] Update cleanup() to use shared modules
- [ ] Update list_worktrees() to use shared modules
- [ ] Update status() to use shared modules

### 2.5 Testing and Validation
- [ ] Run all git-worktree commands in test environment
- [ ] Verify create command works identically
- [ ] Verify merge command works identically
- [ ] Verify cleanup command works identically
- [ ] Verify list command works identically
- [ ] Verify status command works identically
- [ ] **Test git alias: Verify `git wt` continues to work**
- [ ] **Test interactive wrapper: Verify git-wt-interactive still functions**
- [ ] Verify error handling unchanged
- [ ] Compare line count (target: ~300 lines)

## Phase 3: Refactor git-virtual-worktree (Week 4)

### 3.1 Update Imports
- [ ] Add imports for git_common module
- [ ] Add imports for git_validation module
- [ ] Add imports for git_operations module
- [ ] Add imports for git_metadata module
- [ ] Remove duplicated code that's now imported

### 3.2 Refactor Metadata
- [ ] Inherit VirtualWorktreeMetadata from base Metadata class
- [ ] Remove duplicated serialization methods
- [ ] Add virtual-worktree-specific fields (remote_url, depth)
- [ ] Update all metadata usage to use shared base

### 3.3 Refactor Manager Class
- [ ] Update VirtualWorktreeManager to use Git class from git_operations
- [ ] Replace inline validation with git_validation functions
- [ ] Use error_exit from git_common for error handling
- [ ] Ensure all timeout configurations use shared constants

### 3.4 Refactor CLI Commands
- [ ] Update create() to use shared modules
- [ ] Update merge() to use shared modules
- [ ] Update cleanup() to use shared modules
- [ ] Update list_virtual_worktrees() to use shared modules
- [ ] Update status() to use shared modules

### 3.5 Testing and Validation
- [ ] Run all git-virtual-worktree commands in test environment
- [ ] Verify create command works identically
- [ ] Verify merge command works identically
- [ ] Verify cleanup command works identically
- [ ] Verify list command works identically
- [ ] Verify status command works identically
- [ ] **Test git alias: Verify `git vw` continues to work**
- [ ] **Test interactive wrapper: Verify git-vw-interactive still functions**
- [ ] Verify error handling unchanged
- [ ] Verify shallow clone behavior preserved
- [ ] Compare line count (target: ~300 lines)

## Phase 4: Documentation and Quality (Week 4)

### 4.1 Library Documentation
- [ ] Write comprehensive bin/git/lib/README.md
- [ ] Add usage examples for each module
- [ ] Document public API for each module
- [ ] Add type hints to all function signatures

### 4.2 Script Documentation
- [ ] Update git-worktree docstring to reference lib modules
- [ ] Update git-virtual-worktree docstring to reference lib modules
- [ ] Add inline comments for complex logic
- [ ] Update CLAUDE.md if needed

### 4.3 Testing Coverage
- [ ] Ensure all shared modules have unit tests
- [ ] Run shellcheck on any remaining shell scripts
- [ ] Verify no regressions in behavior
- [ ] Test edge cases (dirty working tree, detached HEAD, etc.)

### 4.4 Final Validation
- [ ] Verify both scripts under 400 lines each
- [ ] Run both scripts in production-like environment
- [ ] Check that all tests pass
- [ ] Verify no shellcheck/lint errors
- [ ] Confirm DRY principle achieved

## Phase 5: Integration and Deployment

### 5.1 Integration Testing
- [ ] Test both scripts together in same repository
- [ ] Verify no conflicts in shared module usage
- [ ] Test concurrent execution if applicable
- [ ] Validate error messages are consistent
- [ ] **Final verification: Test both `git wt` and `git vw` aliases end-to-end**
- [ ] **Verify git-wt-interactive and git-vw-interactive work with refactored scripts**

### 5.2 Pre-commit Validation
- [ ] Ensure pre-commit hooks still pass
- [ ] Verify conventional commit format
- [ ] Check lowercase directory enforcement
- [ ] Validate no emoji in code

### 5.3 Deployment
- [ ] Create feature branch for refactor
- [ ] Commit with conventional format: "refactor(git): extract shared modules from worktree scripts"
- [ ] Test installation on clean system
- [ ] Create pull request for review
- [ ] Merge after approval

## Success Metrics

- [ ] git-worktree reduced to ~300 lines (from 791)
- [ ] git-virtual-worktree reduced to ~300 lines (from 911)
- [ ] Zero code duplication between scripts
- [ ] All shared code in bin/git/lib/ modules
- [ ] 100% behavior preservation (no regressions)
- [ ] Comprehensive test coverage for modules
- [ ] All pre-commit hooks passing
