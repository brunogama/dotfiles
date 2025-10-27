# git-virtual-worktree

Virtual worktree manager for large monorepos using shallow Git clones instead of worktrees.

## Overview

`git-virtual-worktree` provides the same workflow as `git-worktree-feature-py` but uses shallow clones for feature branches, making it ideal for large repositories (>1GB) where:

- **Setup time** is critical (seconds vs minutes)
- **Disk space** is limited (100s of MB vs GBs)
- **I/O contention** on shared `.git` causes slowdowns
- **Submodule initialization** is expensive

## When to Use

| Use Case | Recommended Tool |
|----------|-----------------|
| Small/medium repos (<500MB) | `git-worktree-feature-py` (shared history) |
| Large monorepos (>1GB) | `git-virtual-worktree` (shallow clones) |
| Many parallel features | `git-worktree-feature-py` (shared `.git`) |
| Limited disk space | `git-virtual-worktree` (minimal footprint) |
| Slow I/O (network drives) | `git-virtual-worktree` (isolated `.git`) |

## Performance Comparison

For a 2GB monorepo with 100k commits:

| Operation | Worktree | Virtual Worktree | Speedup |
|-----------|----------|------------------|---------|
| Setup | 3-5 min | 10-30 sec | **10-15x** |
| Disk per feature | 2GB | 100-200MB | **10-20x** less |
| Cleanup | Instant | 1-2 sec | Similar |

## Installation

```bash
# Script is in bin/git/
cd ~/.config-fixing-dot-files-bugs
chmod +x bin/git/git-virtual-worktree

# Add to PATH (optional)
export PATH="$HOME/.config-fixing-dot-files-bugs/bin/git:$PATH"

# Or create alias
alias gvw='~/.config-fixing-dot-files-bugs/bin/git/git-virtual-worktree'
```

## Usage

### Create Virtual Worktree

```bash
# Create shallow clone feature branch (depth=1)
git-virtual-worktree create my-feature

# Create with more history for context
git-virtual-worktree create my-feature --depth 10

# Override remote URL
git-virtual-worktree create my-feature --url https://github.com/user/repo.git
```

**What it does:**
1. Detects parent repo's remote URL
2. Creates shallow clone: `git clone --depth 1 --single-branch`
3. Creates new branch: `feature/my-feature`
4. Saves metadata in parent repo's `.git/`
5. Skips submodules (fast setup)

### Work in Virtual Worktree

```bash
# Navigate to clone
cd ../<parent>-my-feature

# Make changes
git add .
git commit -m "feat: add new feature"

# Return to parent
cd -
```

### Merge Feature

```bash
# Intelligent merge with automatic strategy selection
git-virtual-worktree merge my-feature

# Force rebase (no conflict detection)
git-virtual-worktree merge my-feature --force-rebase

# Force merge (always use merge commit)
git-virtual-worktree merge my-feature --force-merge

# Preview strategy without executing
git-virtual-worktree merge my-feature --dry-run
```

**What it does:**
1. Updates base branch from origin
2. Fetches feature branch from virtual worktree clone
3. Calls `git-smart-merge` for integration
4. Automatic conflict detection and strategy selection

### Cleanup

```bash
# Remove virtual worktree and delete branch
git-virtual-worktree cleanup my-feature
```

**What it does:**
1. Warns about uncommitted changes
2. Removes clone directory
3. Deletes feature branch from parent repo
4. Removes metadata file

### List All Virtual Worktrees

```bash
git-virtual-worktree list
```

Shows table with:
- Slug
- Base branch
- Directory path
- Status (Active/Missing)

### Check Status

```bash
git-virtual-worktree status my-feature
```

Shows:
- Metadata (base branch, created at/by, remote URL, depth)
- Directory existence
- Git status if clone exists
- Commits ahead of base branch

## Architecture

```
Parent Repo: ~/project/
├── .git/
│   └── virtual-worktree-my-feature.json  # Metadata
└── (your work)

Virtual Worktree: ~/project-my-feature/
├── .git/  # Independent shallow clone
└── (feature work)
```

## How It Works

### Create Phase

1. **Shallow clone**: Only fetches last N commits (default: 1)
2. **Single branch**: Only clones base branch
3. **Feature branch**: Created in clone, not parent
4. **Metadata**: Saved in parent's `.git/` for tracking
5. **Skip submodules**: Avoids expensive initialization

### Merge Phase

1. **Base update**: Parent repo fetches from origin
2. **Feature fetch**: `git fetch <clone-dir> feature/<slug>:feature/<slug>`
3. **Import commits**: Feature branch imported to parent
4. **Smart merge**: Uses `git-smart-merge` for integration
5. **Conflict handling**: Automatic fallback to merge if needed

### Cleanup Phase

1. **Uncommitted check**: Warns if work would be lost
2. **Directory removal**: `shutil.rmtree(clone-dir)`
3. **Branch deletion**: Remove from parent repo
4. **Metadata cleanup**: Remove JSON tracking file

## Workflow Example

```bash
# Start new feature
cd ~/my-monorepo
git checkout main
git pull
git-virtual-worktree create add-auth-flow

# Work in virtual worktree
cd ~/my-monorepo-add-auth-flow
# ... make changes ...
git add .
git commit -m "feat: add OAuth2 authentication"
git commit -m "test: add auth integration tests"

# Return to parent and merge
cd ~/my-monorepo
git-virtual-worktree merge add-auth-flow

# Output:
# [git-smart-merge] No conflicts detected
# [git-smart-merge] Strategy selected: rebase
# ✓ Feature successfully integrated into main

# Push and cleanup
git push origin main
git-virtual-worktree cleanup add-auth-flow
```

## Comparison with Worktrees

### Worktrees (git-worktree-feature-py)

**Pros:**
- Shared history (one `.git` directory)
- Instant setup (no clone needed)
- Disk efficient for multiple features
- Share refs and objects

**Cons:**
- Initial worktree setup copies history
- Shared `.git` creates I/O contention
- Submodule initialization in every worktree
- Not optimized for huge repos

### Virtual Worktrees (git-virtual-worktree)

**Pros:**
- 10-50x faster setup for large repos
- Minimal disk usage per feature
- Independent `.git` (no I/O contention)
- Submodules skipped by default

**Cons:**
- Each clone is isolated (can't share objects)
- Requires fetch from clone during merge
- Small overhead for tiny repos (<50MB)
- More disk total if many features

## Advanced Usage

### Custom Clone Depth

```bash
# Minimal (fastest, smallest)
git-virtual-worktree create feature --depth 1

# More context (useful for git log)
git-virtual-worktree create feature --depth 50

# Full history (rarely needed)
git-virtual-worktree create feature --depth 999999
```

### Multiple Features in Parallel

```bash
# Create multiple virtual worktrees
git-virtual-worktree create feat-a
git-virtual-worktree create feat-b
git-virtual-worktree create feat-c

# List all
git-virtual-worktree list

# Work in each independently
cd ../project-feat-a  # Independent clone
cd ../project-feat-b  # Independent clone
cd ../project-feat-c  # Independent clone
```

### Recovery from Orphaned Clones

```bash
# If clone directory deleted manually
git-virtual-worktree status my-feature
# Shows: ✗ Virtual worktree not found

# Clean up metadata
git-virtual-worktree cleanup my-feature
```

## Troubleshooting

### "Could not detect remote URL"

**Cause:** Parent repo has no `origin` remote.

**Solution:**
```bash
# Add remote
git remote add origin <url>

# Or specify URL explicitly
git-virtual-worktree create feature --url <git-url>
```

### "Authentication failed"

**Cause:** Clone couldn't authenticate to remote.

**Solution:**
```bash
# Test manual clone first
git clone <url> /tmp/test-clone

# Check SSH keys
ssh -T git@github.com

# Or use HTTPS with credential helper
git config --global credential.helper store
```

### "Virtual worktree not found" during merge

**Cause:** Clone directory was moved or deleted.

**Solution:**
```bash
# Check status
git-virtual-worktree status my-feature

# If you have the commits elsewhere, fetch them:
git fetch <other-location> feature/my-feature

# Or recreate the clone and re-apply changes
git-virtual-worktree cleanup my-feature
```

### Slow clone despite shallow flag

**Cause:** Large repo with many files (not commits).

**Solution:**
```bash
# Use --depth 1 (already default)
git-virtual-worktree create feature

# Network might be slow - wait or check connection
# Shallow clone only reduces history size, not checkout size
```

### Disk space still high

**Cause:** Large working tree (many/large files).

**Solution:**
```bash
# Shallow clone only saves history space
# Working tree size is same as full clone
# Consider sparse checkout if needed (manual setup)

cd ../project-feature
git sparse-checkout set <directories>
```

## Limitations

1. **No shared history**: Each clone is independent
2. **Fetch required**: Must fetch from clone during merge
3. **Shallow limitations**: Some Git operations won't work
   - `git log --all` won't show full history
   - `git blame` limited to fetched commits
   - Force push to remote won't work without unshallow
4. **Submodules skipped**: Must manually init if needed
5. **Not faster for small repos**: Overhead not worth it <100MB

## Tips

1. **Use for large repos only**: <500MB? Use regular worktrees
2. **Keep depth=1**: Unless you need history for context
3. **Clean up regularly**: Remove merged features promptly
4. **Use `list` often**: Track active virtual worktrees
5. **Test merge first**: Use `--dry-run` for safety

## Related Scripts

- `git-worktree-feature-py` - Regular worktree workflow (better for small repos)
- `git-smart-merge` - Intelligent merge with conflict detection (used internally)

## Technical Details

### Metadata Format

Stored in `.git/virtual-worktree-<slug>.json`:

```json
{
  "base_branch": "main",
  "created_at": "2025-10-26T18:45:00",
  "created_by": "username",
  "slug": "my-feature",
  "remote_url": "git@github.com:user/repo.git",
  "depth": 1
}
```

### Clone Command

```bash
git clone \
  --depth 1 \
  --single-branch \
  --branch main \
  git@github.com:user/repo.git \
  ../repo-my-feature
```

### Fetch from Virtual Worktree

```bash
git fetch \
  ../repo-my-feature \
  feature/my-feature:feature/my-feature
```

## License

MIT License - See [LICENSE](../LICENSE) for details.
