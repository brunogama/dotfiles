# Proposal: Interactive FZF Virtual Worktree Manager with Tmux Integration

## Why

Current virtual worktree workflow requires:
- Remembering command syntax (`git vw-create`, `git vw-merge`, etc.)
- Typing slugs manually (error-prone)
- Manually navigating to worktree directory after creation
- Switching between terminals for different worktrees

An interactive fzf-based manager with tmux integration provides:
- **Discoverable interface**: Menu-driven workflow, no memorization
- **Smart selection**: fzf-powered slug selection from existing worktrees
- **Automatic navigation**: Tmux session spawned in new worktree
- **Single command**: `git vw` for all operations
- **Visual feedback**: Preview of worktree status in fzf

## What Changes

- Create new shell script `bin/git/git-vw-interactive` (fzf + tmux integration)
- Add Git alias `vw = !git-vw-interactive` for easy access
- Integrate with existing `git-virtual-worktree` commands
- Provide fzf menu for action selection: Create, Merge, Cleanup, List, Status
- Auto-spawn tmux session after creating virtual worktree
- Use fzf for existing worktree selection (merge, cleanup, status)
- Add preview pane showing worktree details
- Handle tmux session naming and switching
- Support both inside and outside tmux contexts

## Impact

- Affected specs: `specs/git-automation/spec.md` (modified)
- Affected code:
  - New file: `bin/git/git-vw-interactive` (~300 lines, Bash script)
  - Modified: `Git/.gitconfig` (add `vw` alias)
  - Integrates: `bin/git/git-virtual-worktree` (existing)
- User experience: Unified, interactive interface for virtual worktree management
- Dependencies: Requires `fzf` and `tmux` installed
- Breaking changes: None (additive, new alias)
- Performance: Instant menu display, same performance for underlying commands
