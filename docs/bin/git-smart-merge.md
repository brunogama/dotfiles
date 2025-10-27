# git-smart-merge

Intelligently merge a Git branch using rebase or merge based on automatic conflict detection.

## Overview

`git-smart-merge` automatically determines the optimal Git merge strategy by:
1. Checking for conflicts before attempting rebase
2. Using `git rebase` for clean, linear history when safe
3. Falling back to `git merge --no-ff` when conflicts are detected
4. Providing clear logging of all decisions and actions

## Installation

The script is located at `bin/git-smart-merge` and is already executable.

Optionally, add to your PATH:
```bash
# Add to ~/.zshrc or ~/.bashrc
export PATH="$HOME/.config-fixing-dot-files-bugs/bin:$PATH"

# Or create an alias
alias gsm='~/.config-fixing-dot-files-bugs/bin/git-smart-merge'
```

## Usage

```bash
git-smart-merge <source-branch> [options]
```

### Options

- `--dry-run` - Show which strategy would be used without executing
- `--force-merge` - Force merge strategy, skip rebase attempt
- `--force-rebase` - Force rebase strategy, skip conflict detection

### Examples

**Basic usage:**
```bash
# Smart merge feature branch into current branch
git-smart-merge feature-branch
```

**Preview mode:**
```bash
# See what would happen without making changes
git-smart-merge feature-branch --dry-run
```

**Force specific strategy:**
```bash
# Always use merge, never rebase
git-smart-merge feature-branch --force-merge

# Always use rebase, fail if conflicts
git-smart-merge feature-branch --force-rebase
```

## How It Works

### 1. Pre-flight Checks

The script validates:
- Repository is a valid Git repository
- Working directory has no uncommitted changes
- Source branch exists (locally or remotely)
- Current branch is identified

### 2. Conflict Detection

Uses `git merge-tree` to simulate the merge and detect conflicts without touching the working tree.

### 3. Strategy Selection

**Rebase chosen when:**
- No merge conflicts detected
- Creates clean, linear history
- Logs: "Rebase strategy chosen: no conflicts detected"

**Merge chosen when:**
- Conflicts detected in analysis
- Safer approach that preserves both histories
- Logs: "Merge strategy chosen: conflicts detected, rebase not safe"

### 4. Execution

Executes the chosen strategy with full error handling and logging.

## Output Examples

### Successful Rebase

```
[git-smart-merge] Checking repository state...
[git-smart-merge] Current branch: main
[git-smart-merge] Source branch: feature-branch
[git-smart-merge] Fetching latest remote changes...
[git-smart-merge] Detecting conflicts...
[git-smart-merge] No conflicts detected
[git-smart-merge] Strategy selected: rebase
[git-smart-merge] Executing rebase...
[git-smart-merge] Running: git rebase feature-branch
[git-smart-merge] Rebase strategy chosen: no conflicts detected
[git-smart-merge] Operation completed successfully
```

### Conflicts Detected (Merge Used)

```
[git-smart-merge] Checking repository state...
[git-smart-merge] Current branch: main
[git-smart-merge] Source branch: feature-branch
[git-smart-merge] Fetching latest remote changes...
[git-smart-merge] Detecting conflicts...
[git-smart-merge] Conflicts detected during analysis
[git-smart-merge] Rebase not safe, falling back to merge strategy
[git-smart-merge] Strategy selected: merge
[git-smart-merge] Executing merge...
[git-smart-merge] Running: git merge --no-ff feature-branch
[git-smart-merge] Merge strategy chosen: conflicts detected, rebase not safe
[git-smart-merge] Operation completed successfully
```

### Error: Uncommitted Changes

```
[git-smart-merge] Checking repository state...
[git-smart-merge] ERROR: Uncommitted changes detected. Commit or stash changes before merging.
[git-smart-merge] Run 'git status' to see uncommitted changes.
```

## Exit Codes

| Code | Meaning | Examples |
|------|---------|----------|
| 0 | Success | Rebase or merge completed successfully |
| 1 | Error | Uncommitted changes, conflicts, git failure, branch not found |
| 2 | Usage error | Missing branch argument, conflicting flags |

## Troubleshooting

### "Branch 'X' not found"

**Cause:** Source branch doesn't exist locally or remotely.

**Solution:**
```bash
# List all branches
git branch -a

# Fetch remote branches
git fetch

# Verify branch name spelling
git branch -a | grep feature
```

### "Uncommitted changes detected"

**Cause:** Working directory has uncommitted changes.

**Solution:**
```bash
# See what's uncommitted
git status

# Option 1: Commit changes
git add .
git commit -m "WIP: save changes"

# Option 2: Stash changes
git stash push -m "temporary stash"
# After merge: git stash pop
```

### Rebase failed mid-operation

**Cause:** Unexpected conflicts during rebase execution.

**Solution:**
```bash
# Option 1: Abort and retry with merge
git rebase --abort
git-smart-merge feature-branch --force-merge

# Option 2: Resolve conflicts manually
# ... edit conflicted files ...
git add <resolved-files>
git rebase --continue
```

### Merge conflicts during execution

**Cause:** Conflicts appeared during merge (even though detected).

**Solution:**
```bash
# Option 1: Resolve and continue
# ... edit conflicted files ...
git add <resolved-files>
git merge --continue

# Option 2: Abort merge
git merge --abort
```

## Best Practices

1. **Always work with clean state:**
   ```bash
   git status  # Verify clean
   git-smart-merge feature-branch
   ```

2. **Preview before executing:**
   ```bash
   git-smart-merge feature-branch --dry-run
   ```

3. **Keep branches up to date:**
   ```bash
   git fetch
   git pull origin main
   git-smart-merge feature-branch
   ```

4. **Use force flags sparingly:**
   - `--force-merge`: Only when you explicitly want merge commits
   - `--force-rebase`: Only when you're confident there are no conflicts

5. **Verify result:**
   ```bash
   git log --oneline --graph -10
   ```

## Integration with Workflows

### GitHub Pull Request Workflow

```bash
# After PR is approved
git checkout main
git pull origin main
git-smart-merge feature-branch
git push origin main
```

### Feature Branch Development

```bash
# Update feature branch with main
git checkout feature-branch
git-smart-merge main  # Brings main changes into feature
```

### CI/CD Pipeline

```bash
#!/bin/bash
set -e

git fetch origin
git checkout "${TARGET_BRANCH}"
git pull origin "${TARGET_BRANCH}"

if git-smart-merge "${SOURCE_BRANCH}" --dry-run; then
    git-smart-merge "${SOURCE_BRANCH}"
    git push origin "${TARGET_BRANCH}"
else
    echo "Merge would fail, manual intervention required"
    exit 1
fi
```

## Technical Details

### Conflict Detection Method

The script uses `git merge-tree` which performs a three-way merge simulation:
```bash
merge_base=$(git merge-base current_branch source_branch)
git merge-tree $merge_base current_branch source_branch
```

This approach:
- Doesn't modify working tree or index
- Fast and reliable
- Same algorithm used by `git merge`

### Safety Features

1. **Working directory check**: Prevents data loss from uncommitted changes
2. **Branch validation**: Ensures source branch exists before proceeding
3. **Remote sync**: Fetches latest changes before analysis
4. **Comprehensive logging**: Every decision is logged for transparency
5. **Standard exit codes**: Enables scripting and automation

### Limitations

1. **Complex merge scenarios**: Very complex merges might not be detected accurately
2. **Binary conflicts**: Binary file conflicts may not be detected in all cases
3. **Remote branches**: Script works with local refs; ensure branches are fetched
4. **Submodules**: Submodule conflicts may require manual handling

## Testing

Run the test suite:
```bash
python3 tests/test_git_smart_merge.py -v
```

Test coverage includes:
- Missing arguments
- Non-existent branches
- Uncommitted changes detection
- Clean rebase scenarios
- Conflicting changes scenarios
- Dry-run mode
- Force modes
- Error handling
- Logging output

## Related Scripts

- `conventional-commit` - Guided conventional commits
- `git-cleanup-merged` - Clean up merged branches
- See `docs/scripts/` for more Git utilities

## Contributing

When modifying this script:
1. Update tests in `tests/test_git_smart_merge.py`
2. Run test suite: `python3 tests/test_git_smart_merge.py -v`
3. Update this documentation
4. Follow OpenSpec change process (see `openspec/changes/add-git-smart-merge/`)

## License

MIT License - See [LICENSE](../LICENSE) for details.
