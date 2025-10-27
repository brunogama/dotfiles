# Proposal: Refactor git-worktree-feature-py to Use git-smart-merge

## Why

The `git-worktree-feature-py` tool currently implements its own rebase logic in the `merge` command (lines 488-535), which duplicates functionality now available in `git-smart-merge`. This duplication:
- Increases maintenance burden (two places to update merge logic)
- Lacks intelligent conflict detection (always attempts rebase, manual fallback)
- Misses safety features (conflict pre-detection, dry-run mode)
- Creates inconsistent user experience across Git utilities

By delegating to `git-smart-merge`, we gain automatic conflict detection, fallback to merge when needed, and consistent behavior across all Git tools.

## What Changes

- Refactor `git-worktree-feature-py merge` command to use `git-smart-merge` script
- Replace manual rebase logic with subprocess call to `git-smart-merge`
- Preserve existing base branch update logic (fetch + rebase onto origin)
- Add optional `--force-rebase` and `--force-merge` flags to `merge` command
- Update error handling to parse `git-smart-merge` exit codes
- Maintain Rich console output style and user experience
- Update documentation to reflect new behavior

## Impact

- Affected specs: `specs/git-automation/spec.md` (modified)
- Affected code:
  - Modified: `bin/git/git-worktree-feature-py` (merge command, ~40 lines changed)
  - No breaking changes to command interface (new flags are optional)
- User experience improvements:
  - Automatic fallback to merge when conflicts detected
  - Better error messages from git-smart-merge
  - Consistent behavior with standalone git-smart-merge usage
- Dependencies: Requires `bin/git-smart-merge` (already implemented)
- Testing: Update existing tests to verify git-smart-merge integration
