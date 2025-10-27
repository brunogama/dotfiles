# Git Worktree Utilities Capability

## ADDED Requirements

### Requirement: Modular Architecture
The git worktree utilities SHALL use a shared library architecture to eliminate code duplication and improve maintainability.

#### Scenario: Shared library modules exist
- **WHEN** examining the bin/git/lib/ directory
- **THEN** the following Python modules SHALL exist:
  - git_common.py containing ExitCode enum, GitError exception, error_exit function, and timeout constants
  - git_operations.py containing Git command wrapper class and smart-merge integration
  - git_validation.py containing repository validation functions
  - git_metadata.py containing base metadata class with JSON serialization

#### Scenario: Scripts use shared modules
- **WHEN** git-worktree or git-virtual-worktree scripts are examined
- **THEN** they SHALL import shared functionality from lib modules instead of duplicating code
- **AND** each script SHALL be under 400 lines for maintainability

#### Scenario: Behavioral compatibility preserved
- **WHEN** refactoring scripts to use shared modules
- **THEN** all CLI commands (create, merge, cleanup, list, status) SHALL maintain identical behavior
- **AND** all error handling SHALL remain unchanged
- **AND** all timeout configurations SHALL be preserved

### Requirement: Code Organization
The git worktree utilities SHALL organize shared code into focused, single-responsibility modules.

#### Scenario: Module size limits
- **WHEN** a shared library module is created
- **THEN** it SHALL be under 200 lines to maintain readability
- **AND** it SHALL have a clear single purpose

#### Scenario: Module documentation
- **WHEN** shared library modules are created
- **THEN** each module SHALL include a docstring explaining its purpose
- **AND** bin/git/lib/README.md SHALL document the library organization
- **AND** all public functions SHALL have type hints

### Requirement: Testing Infrastructure
The git worktree utilities SHALL provide comprehensive testing for shared modules.

#### Scenario: Module unit tests
- **WHEN** a shared library module is created
- **THEN** it SHALL have corresponding unit tests in tests/git/lib/
- **AND** tests SHALL validate error handling and edge cases
- **AND** tests SHALL use mocking for subprocess calls

#### Scenario: Integration testing
- **WHEN** scripts are refactored to use shared modules
- **THEN** integration tests SHALL verify all CLI commands work identically
- **AND** tests SHALL cover error conditions (dirty tree, detached HEAD, invalid paths)

### Requirement: Import Compatibility
The git worktree utilities SHALL support standard Python imports despite using UV script format.

#### Scenario: Path resolution
- **WHEN** scripts import from lib modules
- **THEN** they SHALL manipulate sys.path to ensure lib/ is importable
- **AND** imports SHALL work with both `uv run` and direct execution

#### Scenario: Dependency compatibility
- **WHEN** lib modules use dependencies
- **THEN** they SHALL only use dependencies already declared in calling scripts (rich, typer)
- **AND** they SHALL not introduce new dependencies
