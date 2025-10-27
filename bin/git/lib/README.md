# Git-Specific Python Library

Tier 2 domain-specific utilities for git Python scripts.

## Architecture

This library provides git-specific utilities building on top of bin/lib/ (Tier 1).
Used exclusively by Python scripts in bin/git/ for git operations.

## Modules

### git_common.py
Common git script utilities and constants.

**Exports:**
- ExitCode enum (git-specific exit codes)
- GitError exception class
- error_exit() function
- Console initialization (Rich)
- Timeout constants (GIT_TIMEOUT, CLONE_TIMEOUT)

**Dependencies:**
- bin/lib/error_handling (inherits BaseError)
- bin/lib/colors (for console formatting)

**Usage:**
```python
from lib.git_common import ExitCode, GitError, error_exit, console
if error_condition:
    error_exit("Operation failed", ExitCode.NOT_GIT_REPO)
```

### git_operations.py
Git command wrapper and smart-merge integration.

**Exports:**
- Git class (wrapper for subprocess git commands)
- find_git_smart_merge() function
- run_git_smart_merge() function

**Usage:**
```python
from lib.git_operations import Git, run_git_smart_merge

# Run git command
result = Git.run("status", "--short")

# Use smart-merge integration
run_git_smart_merge("feature-branch", "main")
```

### git_validation.py
Repository validation functions.

**Exports:**
- check_git_repo() - Verify current directory is git repo
- check_not_detached_head() - Ensure not in detached HEAD state
- check_clean_working_tree() - Verify no uncommitted changes

**Dependencies:**
- bin/lib/validation (for common validation patterns)

**Usage:**
```python
from lib.git_validation import check_git_repo, check_clean_working_tree

check_git_repo()  # Exits if not a git repo
check_clean_working_tree()  # Exits if dirty
```

### git_metadata.py
Metadata serialization for git features.

**Exports:**
- BaseMetadata class (JSON serialization)
- to_json() method
- from_json() classmethod

**Usage:**
```python
from lib.git_metadata import BaseMetadata
from dataclasses import dataclass

@dataclass
class WorktreeMetadata(BaseMetadata):
    base_branch: str
    created_at: str
    created_by: str
    slug: str

metadata = WorktreeMetadata(...)
json_str = metadata.to_json()
restored = WorktreeMetadata.from_json(json_str)
```

## Design Principles

1. **Build on Tier 1:** Leverage bin/lib/ for general utilities
2. **Git-specific:** Focus only on git domain logic
3. **Type hints:** Complete type annotations
4. **Tested:** Comprehensive unit and integration tests
5. **Under 200 lines:** Keep modules focused

## Testing

Tests are located in `tests/git/lib/`:

```bash
python3 -m pytest tests/git/lib/
```

## Usage in Git Scripts

Git scripts in bin/git/ should add both libraries to path:

```python
#!/usr/bin/env -S uv run --quiet --script
import sys
from pathlib import Path

# Add git/lib/ for git-specific modules
sys.path.insert(0, str(Path(__file__).parent / "lib"))
# Add bin/ for general-purpose modules
sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.git_common import ExitCode, error_exit
from lib.git_validation import check_git_repo
from lib.colors import GREEN  # From Tier 1
```

## Contributing

When adding new modules:
1. Keep under 200 lines
2. Leverage bin/lib/ modules when possible
3. Add comprehensive docstrings
4. Include type hints
5. Write unit tests
6. Update this README
