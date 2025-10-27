# General-Purpose Python Library

Tier 1 shared utilities for all Python scripts in the dotfiles repository.

## Architecture

This library provides cross-category utilities used by scripts in:
- bin/core/
- bin/credentials/
- bin/git/
- bin/ide/
- bin/ios/
- bin/macos/

Domain-specific libraries (like bin/git/lib/) build on top of these modules.

## Modules

### common.py
General utility functions for all Python scripts.

**Exports:**
- Path helpers and file operations
- String utilities
- Common patterns

**Usage:**
```python
from lib.common import ensure_directory, read_json_file
```

### colors.py
ANSI color codes and formatting for terminal output.

**Exports:**
- Color constants (RED, GREEN, YELLOW, BLUE, etc.)
- Formatting functions (bold, dim, underline)
- Console styling utilities

**Usage:**
```python
from lib.colors import RED, GREEN, format_error, format_success
print(f"{RED}Error:{RESET} {format_error(message)}")
```

### logging.py
Structured logging framework for consistent log output.

**Exports:**
- Logger configuration
- Log level management
- Structured log formatters

**Usage:**
```python
from lib.logging import get_logger, set_log_level
logger = get_logger(__name__)
logger.info("Operation completed")
```

### validation.py
Common input validation functions.

**Exports:**
- Type validators
- Range validators
- Format validators (email, URL, path)

**Usage:**
```python
from lib.validation import validate_path, validate_non_empty
validate_path("/path/to/file", must_exist=True)
```

### error_handling.py
Consistent error patterns and exit codes.

**Exports:**
- BaseError exception class
- Standard exit codes
- Error formatting utilities

**Usage:**
```python
from lib.error_handling import BaseError, EXIT_SUCCESS, EXIT_ERROR
raise BaseError("Operation failed", exit_code=EXIT_ERROR)
```

## Design Principles

1. **Zero dependencies:** Only use Python standard library
2. **Single responsibility:** Each module has one clear purpose
3. **Type hints:** All functions have complete type annotations
4. **Tested:** Each module has comprehensive unit tests
5. **Under 200 lines:** Keep modules focused and maintainable

## Testing

Tests are located in `tests/lib/`:

```bash
python3 -m pytest tests/lib/
```

## Usage in Scripts

Scripts should manipulate sys.path to import from this library:

```python
#!/usr/bin/env python3
import sys
from pathlib import Path

# Add bin/ to path for lib/ access
sys.path.insert(0, str(Path(__file__).parent.parent))

from lib.colors import GREEN, format_success
from lib.validation import validate_path
```

## Contributing

When adding new modules:
1. Keep under 200 lines
2. Add comprehensive docstrings
3. Include type hints
4. Write unit tests
5. Update this README
