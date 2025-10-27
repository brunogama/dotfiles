# Capability: File Locking

**Change ID**: `migrate-home-sync-to-python`
**Capability**: `file-locking`
**Priority**: Critical

## Overview

Implement race-free, atomic file locking for home-sync to prevent concurrent sync operations from corrupting the repository. This replaces the bash implementation which has TOCTOU (Time-of-Check-Time-of-Use) race conditions.

---

## ADDED Requirements

### Requirement: Atomic Lock Acquisition

**ID**: `lock-001`
**Priority**: Critical

The system MUST acquire locks atomically using fcntl.flock() to prevent race conditions between multiple processes attempting to sync simultaneously.

#### Scenario: Single process acquires lock successfully
**Given** no other process holds the lock
**When** a process calls `acquire_lock()`
**Then** the lock is acquired immediately
**And** the process can proceed with sync operations
**And** the lock file contains the current PID

#### Scenario: Second process fails to acquire lock
**Given** Process A holds the lock
**When** Process B attempts `acquire_lock()`
**Then** Process B fails with `LockError`
**And** the error message indicates another process (PID) holds the lock
**And** Process A's sync operations are not interrupted

#### Scenario: Lock is released automatically on process exit
**Given** a process holds the lock
**When** the process exits (normally or via crash)
**Then** the lock file is removed
**And** subsequent processes can acquire the lock

---

### Requirement: Stale Lock Detection

**ID**: `lock-002`
**Priority**: High

The system MUST detect and remove stale locks from dead processes to prevent permanent deadlock situations.

#### Scenario: Stale lock from crashed process
**Given** a lock file exists with PID 12345
**And** process 12345 no longer exists
**When** a new process attempts `acquire_lock()`
**Then** the stale lock is detected
**And** the stale lock is removed
**And** the new process acquires the lock successfully
**And** a warning is logged about the stale lock

#### Scenario: Lock held by running process is not removed
**Given** a lock file exists with PID 12345
**And** process 12345 is currently running
**When** a new process attempts `acquire_lock()`
**Then** the lock is NOT removed
**And** `LockError` is raised
**And** the error indicates which PID holds the lock

---

### Requirement: Lock Timeout

**ID**: `lock-003`
**Priority**: High

The system MUST support timeout-based lock acquisition to prevent infinite waiting when another process holds the lock for extended periods.

#### Scenario: Lock acquisition with timeout succeeds
**Given** another process holds the lock
**And** the timeout is set to 60 seconds
**When** the other process releases the lock after 30 seconds
**Then** the waiting process acquires the lock
**And** sync proceeds normally

#### Scenario: Lock acquisition times out
**Given** another process holds the lock
**And** the timeout is set to 60 seconds
**When** 60 seconds elapse without lock release
**Then** `LockError` is raised with timeout message
**And** the process exits gracefully
**And** no sync operations are attempted

#### Scenario: Hung process detection via timestamp
**Given** a lock file with PID 12345 and timestamp 1 hour ago
**And** process 12345 is still running
**When** a new process attempts lock acquisition
**Then** the lock is identified as potentially hung
**And** an error message suggests manual intervention
**And** the lock is NOT automatically removed (safety)

---

### Requirement: Context Manager Interface

**ID**: `lock-004`
**Priority**: Medium

The lock MUST be implemented as a Python context manager to ensure automatic cleanup even when exceptions occur.

#### Scenario: Lock released on normal exit
**Given** a process acquires the lock via context manager
**When** the context block executes successfully
**Then** the lock is released automatically
**And** the lock file is removed

#### Scenario: Lock released on exception
**Given** a process acquires the lock via context manager
**When** an exception is raised inside the context
**Then** the lock is released before exception propagates
**And** the lock file is removed
**And** the exception continues to propagate

#### Scenario: Nested lock acquisition fails
**Given** Process A holds the lock via context manager
**When** Process A attempts to acquire the lock again (nested)
**Then** the system detects self-deadlock
**And** raises `LockError` with descriptive message
**And** the original lock remains held

---

### Requirement: Cross-Platform Lock File Location

**ID**: `lock-005`
**Priority**: Low

The lock file MUST be stored in a standard temporary location appropriate for the operating system.

#### Scenario: Lock file on macOS
**Given** the system is macOS
**When** the lock is acquired
**Then** the lock file is created at `/tmp/home-sync.lock`
**And** the file has permissions 0644

#### Scenario: Lock file on Linux
**Given** the system is Linux
**When** the lock is acquired
**Then** the lock file is created at `/tmp/home-sync.lock` or `$TMPDIR/home-sync.lock`
**And** the file respects umask settings

---

## Implementation Notes

### Technical Approach

Use Python's `fcntl.flock()` for kernel-level file locking:

```python
import fcntl
from contextlib import contextmanager
from pathlib import Path
import os
import time

LOCK_FILE = Path("/tmp/home-sync.lock")
LOCK_TIMEOUT = 300  # 5 minutes
LOCK_HUNG_THRESHOLD = 3600  # 1 hour

@contextmanager
def acquire_lock(timeout: int = LOCK_TIMEOUT):
    """
    Acquire exclusive lock with timeout and stale detection.

    Raises:
        LockError: If lock cannot be acquired within timeout
    """
    fd = None
    start_time = time.time()

    try:
        # Open lock file
        fd = open(LOCK_FILE, 'w')

        # Try non-blocking acquire first
        try:
            fcntl.flock(fd.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            # Lock held, check for stale lock
            if is_stale_lock():
                remove_stale_lock()
                fcntl.flock(fd.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
            else:
                # Wait with timeout
                while time.time() - start_time < timeout:
                    time.sleep(1)
                    try:
                        fcntl.flock(fd.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
                        break
                    except BlockingIOError:
                        continue
                else:
                    raise LockError(f"Could not acquire lock within {timeout}s")

        # Write PID and timestamp
        fd.write(f"{os.getpid()}:{int(time.time())}\n")
        fd.flush()

        yield

    finally:
        if fd:
            fcntl.flock(fd.fileno(), fcntl.LOCK_UN)
            fd.close()
            LOCK_FILE.unlink(missing_ok=True)
```

### Testing Strategy

1. **Unit Tests**:
   - Test lock acquisition and release
   - Test stale lock detection with mocked PID checks
   - Test timeout behavior
   - Test exception handling

2. **Integration Tests**:
   - Launch multiple processes attempting to acquire lock
   - Verify only one succeeds
   - Kill process and verify stale lock removal
   - Test lock held across subprocess calls

3. **Race Condition Tests**:
   - Use threading to simulate concurrent acquisition
   - Verify fcntl provides true atomicity
   - Test on both macOS and Linux

---

## Dependencies

- Python fcntl module (standard library, Unix only)
- os module for PID operations
- pathlib for file path handling

---

## Security Considerations

- Lock file location `/tmp/` is world-writable but file itself is process-owned
- PID in lock file prevents impersonation
- No sensitive data stored in lock file
- Stale lock removal requires PID validation to prevent removal of active locks

---

## Performance Considerations

- Lock acquisition: O(1) with fcntl (kernel operation)
- Stale detection: O(1) with os.kill(pid, 0)
- Timeout polling: Sleep 1s between checks (low CPU)
- Lock file I/O: Minimal (single write per acquisition)

---

## Migration from Bash

**Current Issues in Bash**:
```bash
# TOCTOU race condition
if [[ -f "$LOCK_FILE" ]]; then
    # Another process can create lock here
    check_pid
fi
echo $$ > "$LOCK_FILE"  # Race!
```

**Python Solution**:
```python
# Atomic operation at kernel level
fcntl.flock(fd.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
```

No race condition possible - kernel guarantees atomicity.
