# Add Interactive Git Reword Alias with FZF

## Status
Proposed

## Context
Git commit message rewriting currently requires manual use of `git rebase -i` or `git commit --amend`, which involves:
- Remembering commit hashes or counting HEAD~N positions
- Opening interactive rebase editor
- Changing "pick" to "reword"
- Saving and closing editor
- Waiting for next editor to open for actual message rewrite

This workflow has unnecessary friction for a common operation.

## Problem
Current pain points when rewriting commit messages:
1. No visual interface for selecting which commit to reword
2. Multi-step process with multiple editor opens
3. Easy to make mistakes with interactive rebase commands
4. Difficult to see commit context before deciding to reword
5. No preview of commit details (changes, author, date)

## Proposed Solution
Create `git reword` alias - an FZF-based interactive commit message rewriter.

### Core Features
1. **FZF Commit Selection**
   - Display all commits on current branch in one-line format
   - Navigate with arrow keys (up/down)
   - Preview pane showing commit details (diff stats, message, metadata)
   - Select commit with Enter

2. **Smart Reword Logic**
   - Last commit (HEAD): Use `git commit --amend`
   - Older commits: Use `git rebase -i` with automatic "reword" action
   - Safety checks for uncommitted changes
   - Detect pushed commits and warn user

3. **Interactive Message Editor**
   - After selection, open editor with current commit message
   - User rewrites message
   - Automatic validation (no empty messages)
   - Preserve commit metadata (author, date)

4. **MINDSET.MD Compliance**
   - No emojis (use text markers: `warning:`, `error:`, `success:`)
   - Proper error handling (set -euo pipefail)
   - Color constants for output
   - Functions ≤40 lines
   - Comprehensive safety checks

### User Workflow
```bash
git reword

# FZF opens showing:
e0b09c1 feat(git): add interactive FZF/tmux wrapper
cd88f74 feat(git): add virtual worktree and smart merge
925c263 docs: add Factory CLI documentation crawl
...

# User navigates with arrows, sees preview:
# ┌─────────────────────────────────────────┐
# │ Commit: e0b09c1                         │
# │ Author: Bruno <bruno@example.com>       │
# │ Date:   Sun Oct 26 21:14:01 2025        │
# │                                         │
# │ Changes:                                │
# │  6 files changed, 1530 insertions(+)   │
# │  - Bin/git/git-wt-interactive          │
# │  - Git/.gitconfig                      │
# │  ...                                   │
# └─────────────────────────────────────────┘

# User hits Enter, editor opens with current message:
feat(git): add interactive FZF/tmux wrapper

Implements git-wt-interactive...
# User edits message, saves, closes
# Git automatically rewrites commit history
```

## Implementation Plan

### Phase 1: Core Alias (Simple Approach)
Create bash script that:
- Gets commits for current branch (`git log --oneline`)
- Pipes to FZF for selection
- Extracts commit hash
- Determines reword strategy (amend vs rebase)
- Executes git command

### Phase 2: Enhanced Preview
Add FZF preview pane showing:
- Full commit message
- Commit metadata (author, date, hash)
- File change statistics
- Diff summary

### Phase 3: Safety Features
- Check for uncommitted changes
- Warn if commit is pushed to remote
- Confirm before rewriting pushed commits
- Validate new commit message not empty

### Phase 4: Advanced Options
- Flag to include/exclude merge commits
- Option to reword multiple commits in sequence
- Interactive message templates
- Integration with conventional commits format

## Benefits
1. **Faster workflow**: One command instead of multi-step process
2. **Visual selection**: See all commits at once with context
3. **Reduced errors**: Less manual typing of commit hashes
4. **Better UX**: Consistent with other FZF-based git aliases (wt, vw)
5. **Safer**: Built-in checks prevent common mistakes

## Implementation Details

### Git Alias Definition
```gitconfig
[alias]
    # Interactive commit message reword with FZF
    reword = !git-reword
```

### Script Location
`bin/git/git-reword` - Bash script (estimated 200-300 lines)

### Key Functions
- `get_branch_commits()` - Get commits on current branch
- `format_for_fzf()` - Format commits for FZF display
- `generate_preview()` - Create FZF preview content
- `check_commit_status()` - Verify commit is safe to reword
- `reword_commit()` - Execute reword (amend or rebase)
- `validate_message()` - Ensure new message is valid

### Dependencies
- `fzf` - Fuzzy finder for interactive selection
- `git` - Obviously
- Standard Unix tools: `awk`, `sed`, `grep`

## Risks and Mitigations

1. **Risk**: User rewrites pushed commits
   - **Mitigation**: Detect pushed commits, show warning, require confirmation

2. **Risk**: Rebase conflicts during reword
   - **Mitigation**: Clear error messages, suggest recovery steps

3. **Risk**: Empty commit message
   - **Mitigation**: Validate message before executing reword

4. **Risk**: Uncommitted changes interfere
   - **Mitigation**: Check working tree clean before reword

## Alternatives Considered

1. **Simple alias without FZF**: Less interactive, requires knowing commit hash
2. **GUI tool integration**: Breaks terminal workflow
3. **Editor plugin**: Not all users use same editor
4. **Existing tools (tig, lazygit)**: Requires learning separate tool

## Success Criteria
- [TODO] Script passes shellcheck validation
- [TODO] Works with HEAD commit (amend)
- [TODO] Works with older commits (rebase)
- [TODO] FZF preview shows accurate commit details
- [TODO] Safety checks prevent dangerous operations
- [TODO] MINDSET.MD compliant (no emojis, proper error handling)
- [TODO] Zero bugs when rewriting unpushed commits
- [TODO] Clear warnings for pushed commits

## Timeline
- Phase 1: Core functionality (2-3 hours)
- Phase 2: Preview pane (1-2 hours)
- Phase 3: Safety features (2-3 hours)
- Phase 4: Advanced options (optional, 2-3 hours)
- **Total**: 5-8 hours for essential features

## Related Changes
- Complements: `git wt`, `git vw` (same FZF interaction pattern)
- Uses: Standard git rebase/amend commands
- Integrates with: `git/github-flow-aliases.gitconfig`

## Example Usage Scenarios

### Scenario 1: Fix Typo in Last Commit
```bash
git reword
# Select HEAD commit
# Edit message, fix typo
# Save and close
# Done in 10 seconds vs 30+ seconds with manual rebase
```

### Scenario 2: Improve Commit Message 3 Commits Ago
```bash
git reword
# Navigate to commit 3 positions back
# See preview of changes
# Rewrite message with better description
# Git handles rebase automatically
```

### Scenario 3: Cancelled Reword
```bash
git reword
# Select commit
# Editor opens
# User decides not to change
# Close editor without saving
# No changes made (safe abort)
```
