# Add Interactive FZF/Tmux Wrapper for git-worktree

## Status
Proposed

## Context
The `git-worktree` script provides powerful worktree management with feature branches, but requires remembering command syntax and flags. An interactive wrapper using FZF and tmux would significantly improve the user experience, matching the workflow we created for `git-virtual-worktree`.

## Problem
Current workflow pain points:
1. Must remember command syntax for all operations (create, merge, cleanup, list, status)
2. No visual selection of existing worktrees for merge/cleanup/status operations
3. Manual tmux session management for switching between worktrees
4. Repetitive typing of slug names and flags

## Proposed Solution
Create `bin/git/git-wt-interactive` - an interactive Bash script that:

### Core Features
1. **FZF Menu System**
   - Main menu with actions: Create, Merge, Cleanup, List, Status, Quit
   - Worktree selection using FZF with preview pane
   - Strategy selection for merge (Auto, Force Rebase, Force Merge, Dry Run)

2. **Tmux Integration**
   - Automatically create tmux sessions when creating worktrees
   - Detect if inside tmux (create window) vs outside (create session)
   - Name tmux sessions as `wt-<slug>` for easy identification
   - Kill tmux sessions during cleanup (with confirmation)
   - Quick switch to worktree's tmux session from status view

3. **Interactive Workflows**
   - **Create**: Prompt for slug, auto-switch to new tmux session in worktree
   - **Merge**: Select worktree via FZF, choose strategy, execute merge
   - **Cleanup**: Select worktree, confirm if uncommitted changes, kill tmux session
   - **List**: Display git worktree list with option to view status
   - **Status**: Select worktree, show details, offer tmux switch

4. **MINDSET.MD Compliance**
   - No emojis (use text markers: `[active]`, `[missing]`, `error:`, `success:`)
   - Proper error handling (`set -euo pipefail`, trap handlers)
   - Color constants (`COLOR_*` variables)
   - All directories lowercase
   - Functions ≤40 lines
   - Comprehensive dependency checking

## Implementation Plan

### Phase 1: Core Script Structure
- Create bash script with proper shebang and error handling
- Dependency validation (fzf, tmux, git-worktree)
- Helper functions (logging, tmux management)
- Main menu loop

### Phase 2: FZF Integration
- Worktree listing and formatting for FZF
- Preview pane showing worktree details
- Selection handling and validation

### Phase 3: Tmux Integration
- Session/window creation based on context
- Session naming and sanitization
- Session existence checking
- Cleanup and killing sessions

### Phase 4: Action Handlers
- Create action with tmux auto-setup
- Merge action with strategy selection
- Cleanup action with tmux cleanup
- List action with navigation
- Status action with tmux switch option

### Phase 5: Polish
- Color-coded output
- Progress indicators
- Helpful error messages
- Keyboard shortcuts documentation

## Benefits
1. **Reduced cognitive load**: No need to remember command syntax
2. **Faster workflow**: Visual selection is quicker than typing slugs
3. **Better context switching**: Tmux integration streamlines multi-feature work
4. **Consistent UX**: Matches git-vw-interactive interface
5. **Error prevention**: Interactive confirmations prevent mistakes

## Dependencies
- `fzf` (fuzzy finder)
- `tmux` (terminal multiplexer)
- `git-worktree` (core worktree manager)
- `jq` (JSON parsing for metadata)

## Risks and Mitigations
1. **Risk**: User doesn't have fzf/tmux installed
   - **Mitigation**: Comprehensive dependency checking with installation instructions

2. **Risk**: Conflicts with existing tmux sessions
   - **Mitigation**: Use unique naming pattern `wt-<slug>`, check for existence

3. **Risk**: Complex to maintain two similar scripts
   - **Mitigation**: Share common patterns, extract reusable functions

## Alternatives Considered
1. **Single unified interactive script**: Would be complex, better to have separate tools
2. **Git alias only**: Not interactive enough, still requires memorization
3. **Full GUI application**: Overkill, breaks terminal workflow

## Success Criteria
- [TODO] Script passes all syntax checks
- [TODO] All 6 menu actions work correctly
- [TODO] Tmux sessions created/managed properly
- [TODO] FZF preview shows accurate worktree status
- [TODO] Zero MINDSET.MD violations (no emojis, proper error handling)
- [TODO] End-to-end workflow: create → work → merge → cleanup

## Timeline
- Phase 1-2: Core structure and FZF (2-3 hours)
- Phase 3-4: Tmux integration and actions (3-4 hours)
- Phase 5: Polish and testing (1-2 hours)
- **Total**: 6-9 hours of development time

## Related Changes
- Complements: `add-fzf-tmux-virtual-worktree` (same pattern, different backend)
- Uses: `add-git-smart-merge` (for merge operations)
- Integrates with: `bin/git/git-worktree` (core functionality)
