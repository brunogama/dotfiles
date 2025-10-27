# Technical Design: Worktree Scripts Refactoring

## Context

The git-worktree and git-virtual-worktree scripts have evolved into complex tools (791 and 911 lines respectively) with significant code duplication. Both scripts implement similar workflows for managing feature branches but using different underlying mechanisms (native git worktrees vs shallow clones).

**Current state:**
- Both scripts are Python implementations using typer + rich
- Significant duplication: Git wrapper class, validation functions, smart-merge integration
- No shared library structure for git utilities
- Each bug fix requires changes in multiple files
- Testing complexity due to code duplication

**Constraints:**
- Must maintain backward compatibility (same CLI interface)
- Cannot break existing workflows or user scripts
- Must preserve all timeout configurations
- Must maintain identical error handling behavior
- Scripts are invoked via UV (uv run --quiet --script) with inline dependencies

## Goals / Non-Goals

### Goals
- Eliminate code duplication between worktree scripts
- Reduce script size to ~300 lines each (within maintainability limits)
- Create reusable library modules for git operations
- Maintain 100% behavioral compatibility
- Improve testability through module isolation
- Establish foundation for future git utilities

### Non-Goals
- Not changing CLI interface or user-facing behavior
- Not converting to installable package (keep UV script format)
- Not refactoring the core worktree/virtual-worktree logic
- Not adding new features (pure refactor)
- Not changing dependencies (keep typer + rich)

## Decisions

### 1.1 Module Organization

Create two-tier library structure:

**Tier 1: General-purpose libraries (bin/lib/)** - Cross-category utilities:
```
bin/lib/
├── __init__.py           # Package initialization
├── README.md             # Library documentation
├── common.py             # ~80 lines: Shared utilities for all Python scripts
├── colors.py             # ~60 lines: ANSI color codes and formatting
├── logging.py            # ~100 lines: Structured logging framework
├── validation.py         # ~80 lines: Common input validation
└── error_handling.py     # ~80 lines: Consistent error patterns
```

**Tier 2: Git-specific libraries (bin/git/lib/)** - Domain-specific utilities:
```
bin/git/lib/
├── __init__.py           # Package initialization
├── README.md             # Library documentation
├── git_common.py         # ~100 lines: ExitCode, GitError, error_exit (uses bin/lib/)
├── git_operations.py     # ~150 lines: Git class, smart-merge integration
├── git_validation.py     # ~100 lines: Repository validation functions
└── git_metadata.py       # ~120 lines: Base metadata class, serialization
```

**Rationale:**
- Two-tier architecture: general (Tier 1) + domain-specific (Tier 2)
- Tier 1 can be used by bin/core/, bin/credentials/, bin/ide/, etc.
- Tier 2 imports from Tier 1 for consistency
- Python modules (not bash) to match script implementation
- Flat structure within each tier for simplicity
- Clear separation of concerns by module
- Each module under 200 lines for maintainability

**Alternatives considered:**
- Single bin/git/lib/ only (rejected: misses opportunity for cross-category reuse)
- Single lib.py file (rejected: would be 870 lines total, defeats purpose)
- Bash libraries (rejected: scripts are Python, conversion unnecessary)
- Nested package structure (rejected: over-engineering for 9 modules)

### 1.2 Import Strategy

Scripts will use standard Python imports from both tiers:

**Git scripts import from Tier 2 (git-specific):**
```python
from lib.git_common import ExitCode, GitError, error_exit, console
from lib.git_validation import check_git_repo, check_not_detached_head
from lib.git_operations import Git, find_git_smart_merge, run_git_smart_merge
from lib.git_metadata import BaseMetadata
```

**Git library modules import from Tier 1 (general-purpose):**
```python
# In bin/git/lib/git_common.py
import sys
from pathlib import Path
# Add parent's parent to path for bin/lib/ access
sys.path.insert(0, str(Path(__file__).parent.parent.parent))
from lib.error_handling import BaseError
from lib.colors import format_error
```

**Rationale:**
- Standard Python import mechanism
- Explicit imports (better than import *)
- Type hints work correctly with imports
- IDE autocompletion supported
- Tier 2 modules can leverage Tier 1 utilities

**Path resolution:**
Since scripts use `#!/usr/bin/env -S uv run --quiet --script`, we need to ensure both lib/ directories are importable:

1. Scripts add bin/git/lib/ to path (for git-specific modules)
2. Git lib modules add bin/ to path (for general-purpose modules)

Decision: Use relative path manipulation at module/script startup:

```python
# In git-worktree and git-virtual-worktree scripts
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent / "lib"))  # For git/lib/
sys.path.insert(0, str(Path(__file__).parent.parent))   # For bin/lib/
```

This keeps scripts self-contained and doesn't require environment modifications.

### 1.3 Metadata Class Hierarchy

Design base class for shared metadata:

```python
# lib/git_metadata.py
from dataclasses import dataclass
import json

@dataclass
class BaseMetadata:
    """Base metadata for git worktree features."""
    base_branch: str
    created_at: str
    created_by: str
    slug: str

    def to_json(self) -> str:
        return json.dumps(asdict(self), indent=2)

    @classmethod
    def from_json(cls, data: str):
        parsed = json.loads(data)
        return cls(**parsed)

# git-worktree script
@dataclass
class WorktreeMetadata(BaseMetadata):
    """Metadata for native git worktrees."""
    pass  # No additional fields needed

# git-virtual-worktree script
@dataclass
class VirtualWorktreeMetadata(BaseMetadata):
    """Metadata for virtual worktrees (shallow clones)."""
    remote_url: str
    depth: int
```

**Rationale:**
- Inheritance allows code reuse while maintaining type distinctions
- Dataclass decorator preserves automatic __init__ and __repr__
- JSON serialization logic centralized
- Each script can extend with specific fields

### 1.4 Architecture Concerns

#### Monorepo Size
**Issue:** Growing to enterprise scale without clear module boundaries

**Symptoms:**
- 60+ scripts across multiple categories
- bin/git/ mixing scripts (bin/git/git-*) with configuration (bin/git/hooks/)
- No shared library for common patterns

**Impact:**
- Code duplication (colors, logging, error handling)
- Maintenance burden (bug fixes in multiple locations)
- Testing complexity (cannot test shared logic in isolation)

**Current approach:** Extract Python libraries for git utilities

**Future consideration:** May need bin/lib/ for bash utilities if shell scripts proliferate:
```
bin/lib/
├── common.sh          # Shared utilities
├── colors.sh          # ANSI color codes
├── logging.sh         # Structured logging
├── validation.sh      # Input validation
└── error-handling.sh  # Consistent error patterns
```

**Recommendation:** Start with bin/git/lib/ for Python modules. Introduce bin/lib/ for bash utilities only when 3+ bash scripts show duplication.

#### Missing Abstraction Layers
**Issue:** Git operations duplicated across multiple scripts

**Examples:**
- Branch validation logic in 4 different scripts
- Worktree path calculation duplicated
- Interactive menu code duplicated (if rich menus used elsewhere)
- Error handling patterns inconsistent

**Current approach:** git_operations.py and git_validation.py address this for Python scripts

**Future consideration:** If more git utilities are added, may need additional modules:
```
bin/git/lib/
├── git-common.py         # Implemented in this change
├── git-operations.py     # Implemented in this change
├── git-validation.py     # Implemented in this change
├── git-metadata.py       # Implemented in this change
├── branch-operations.py  # Future: Branch management if needed
├── interactive-menu.py   # Future: TUI components if reused
└── worktree-common.py    # Future: Additional worktree utilities
```

**Recommendation:** Implement only the 4 modules needed for current refactor. Add additional modules using same OpenSpec process when duplication emerges in new scripts.

### 1.5 Testing Strategy

**Module testing:**
- Each lib module gets unit tests in tests/git/lib/
- Test isolation through mocking subprocess calls
- Validate error handling and edge cases

**Integration testing:**
- Test both scripts end-to-end after refactor
- Verify behavior unchanged (create, merge, cleanup, list, status)
- Test error conditions (dirty tree, detached HEAD, etc.)

**Test structure:**
```
tests/
├── lib/                              # General-purpose library tests
│   ├── test_common.py
│   ├── test_colors.py
│   ├── test_logging.py
│   ├── test_validation.py
│   └── test_error_handling.py
└── git/
    ├── lib/                          # Git-specific library tests
    │   ├── test_git_common.py
    │   ├── test_git_operations.py
    │   ├── test_git_validation.py
    │   └── test_git_metadata.py
    ├── test_git_worktree.py         # Integration tests
    └── test_git_virtual_worktree.py  # Integration tests
```

### 1.6 UV Script Compatibility

**Challenge:** Scripts use `#!/usr/bin/env -S uv run --quiet --script` with inline dependencies

**Consideration:** Shared modules cannot have their own UV dependencies since they're imported, not executed

**Solution:**
- Lib modules use only standard library + dependencies already declared in scripts
- Both scripts already depend on: rich>=13.7.0, typer>=0.12.0
- Lib modules can freely use these dependencies
- No new dependencies introduced by refactor

**Example:**
```python
# lib/git_common.py can use rich since both scripts declare it
from rich.console import Console
console = Console()
```

## Migration Plan

### Phase 1: Extract Modules (Non-breaking)
1. Create bin/git/lib/ directory structure
2. Extract shared code into modules
3. Add comprehensive tests for modules
4. Verify modules work in isolation

**Rollback:** Delete bin/git/lib/ directory

### Phase 2: Refactor git-worktree
1. Add imports for lib modules
2. Remove duplicated code
3. Test all commands thoroughly
4. Verify line count reduction

**Rollback:** Restore from git history (git checkout HEAD -- bin/git/git-worktree)

### Phase 3: Refactor git-virtual-worktree
1. Add imports for lib modules
2. Remove duplicated code
3. Test all commands thoroughly
4. Verify line count reduction

**Rollback:** Restore from git history (git checkout HEAD -- bin/git/git-virtual-worktree)

### Phase 4: Documentation and Finalization
1. Write library documentation
2. Update script docstrings
3. Final validation
4. Deploy

**Rollback:** Full revert via git revert or branch deletion

## Risks / Trade-offs

### Risk: Import Path Issues
**Description:** Python path resolution might fail in some environments

**Likelihood:** Low (using explicit sys.path manipulation)

**Mitigation:**
- Test in multiple environments (macOS, Linux)
- Validate with fresh dotfiles installation
- Add error handling for import failures with clear messages

### Risk: Behavioral Changes
**Description:** Refactor might introduce subtle behavior changes

**Likelihood:** Medium (complex scripts with many edge cases)

**Mitigation:**
- Comprehensive integration testing before/after
- Test all CLI commands systematically
- Verify error messages identical
- Check timeout configurations preserved
- Use git diff to compare outputs in test scenarios

### Risk: UV Script Compatibility
**Description:** Inline UV script format might conflict with imports

**Likelihood:** Low (Python imports work regardless of shebang)

**Mitigation:**
- Test with UV execution early in Phase 1
- Verify both `uv run` and direct execution work
- Document any UV-specific quirks

### Trade-off: Additional Files
**Before:** 2 large files (791 + 911 = 1702 lines)
**After:**
- 2 small scripts (~600 lines)
- 5 general lib modules (~400 lines)
- 4 git-specific lib modules (~470 lines)
- Total: ~1470 lines (13% reduction)

**Analysis:**
- Net reduction: 232 lines (13% decrease)
- More files to maintain (11 vs 2)
- But each file is simpler and more focused
- Shared code tested once, not duplicated
- General libraries reusable across all Python scripts (bin/core/, bin/credentials/, etc.)
- Git libraries reusable for future git utilities
- Establishes sustainable architecture pattern

**Verdict:** Trade-off strongly favors modular architecture despite more files

## Open Questions

1. Should lib modules include their own type stubs (.pyi files)?
   - **Decision:** Not initially, add if type checking becomes priority

2. Should we add a lib/constants.py for timeout values?
   - **Decision:** Keep in git_common.py for now, only split if more constants added

3. Should BaseMetadata validate field types?
   - **Decision:** Use dataclass type hints but don't add runtime validation initially

4. Should we add logging to lib modules?
   - **Decision:** No, keep modules simple. Logging stays in main scripts.

5. Future: Should other git utilities (git-smart-merge, etc.) also be refactored?
   - **Decision:** Out of scope for this change. Evaluate after this refactor proves successful.
