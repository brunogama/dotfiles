# Proposal: Git Virtual Worktree for Large Monorepos

## Why

Git worktrees share the same `.git` directory and full repository history, which becomes problematic for large monorepos:
- **Disk space**: Worktrees still reference the entire history (GBs in monorepos)
- **Performance**: Initial worktree setup clones all objects
- **I/O overhead**: Shared `.git` directory creates contention in large repos
- **Submodule complexity**: Recursive submodule initialization is expensive

For massive repositories (>1GB), a shallow clone approach is more efficient:
- Only fetches the last commit (minimal disk usage)
- Independent `.git` directory (no I/O contention)
- Faster setup (seconds vs minutes)
- Isolated environment (easier cleanup)

## What Changes

- Create new script `bin/git/git-virtual-worktree` with commands: create, merge, cleanup, list, status
- Uses shallow clones (`git clone --depth 1`) instead of worktrees
- Creates independent clones at `../<parent>-<slug>` (same path convention)
- Tracks metadata in parent repo's `.git/virtual-worktree-<slug>.json`
- Integrates with `git-smart-merge` for merging (same as worktree script)
- Supports same workflow: create feature → work → merge → cleanup
- Provides `--depth` option for controlling clone depth (default: 1)
- Handles remote URL detection and authentication

## Impact

- Affected specs: `specs/git-automation/spec.md` (new capability)
- Affected code:
  - New file: `bin/git/git-virtual-worktree` (~600 lines, Python with uv)
  - Reuses: `bin/git/git-smart-merge` (for merging)
  - Metadata: `.git/virtual-worktree-<slug>.json` (tracking)
- User experience: Nearly identical to git-worktree-feature-py but optimized for large repos
- Performance improvement: 10-50x faster for repos >1GB
- Breaking changes: None (new tool, doesn't affect existing workflows)
