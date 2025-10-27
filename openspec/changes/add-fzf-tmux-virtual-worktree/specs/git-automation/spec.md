# Git Automation Specification

## ADDED Requirements

### Requirement: Interactive Virtual Worktree Manager

The system SHALL provide an interactive fzf-based interface for managing virtual worktrees through a single command.

#### Scenario: Launch interactive menu
- **WHEN** user runs `git vw` with no arguments
- **THEN** fzf displays menu with options: Create, Merge, Cleanup, List, Status, Quit
- **AND** menu has custom colors and prompt
- **AND** user can navigate with arrow keys
- **AND** pressing Enter selects action
- **AND** pressing Esc or Ctrl-C cancels

#### Scenario: Create action selected
- **WHEN** user selects "Create" from main menu
- **THEN** prompted for slug name with validation
- **AND** optionally prompted for depth and URL
- **AND** calls git-virtual-worktree create with parameters
- **AND** on success, tmux session/window is created
- **AND** user is switched to new tmux session/window

#### Scenario: Select existing worktree with fzf
- **WHEN** user selects Merge, Cleanup, or Status action
- **THEN** fzf displays list of existing virtual worktrees
- **AND** shows: slug, base branch, directory, status (Active/Missing)
- **AND** preview pane shows detailed worktree information
- **AND** user selects worktree with Enter
- **AND** selected slug is used for the action

#### Scenario: No worktrees exist
- **WHEN** user selects Merge, Cleanup, or Status with no existing worktrees
- **THEN** message displayed: "No virtual worktrees found"
- **AND** returns to main menu
- **AND** suggests creating a new worktree

### Requirement: Automatic Tmux Session Creation

The system SHALL automatically create and switch to tmux sessions when virtual worktrees are created.

#### Scenario: Create worktree outside tmux
- **WHEN** user creates virtual worktree while not in tmux session
- **THEN** new tmux session is created with name: `vw-<slug>`
- **AND** working directory set to virtual worktree path
- **AND** user is attached to new tmux session
- **AND** success message displayed before attach

#### Scenario: Create worktree inside tmux
- **WHEN** user creates virtual worktree while inside existing tmux session
- **THEN** new window is created in current session
- **AND** window named: `vw-<slug>`
- **AND** working directory set to virtual worktree path
- **AND** user is switched to new window
- **AND** original session preserved

#### Scenario: Tmux session naming
- **WHEN** tmux session/window is created for virtual worktree
- **THEN** name is: `vw-<slug>`
- **AND** invalid characters sanitized (only alphanumeric, dash, underscore)
- **AND** name is unique (suffix added if collision)
- **AND** name matches worktree slug for easy identification

#### Scenario: Resume existing tmux session
- **WHEN** user tries to create worktree with slug that has existing tmux session
- **THEN** prompt asks: "Tmux session exists. Reuse? (y/n)"
- **AND** if yes: switches to existing session
- **AND** if no: creates with unique suffix

### Requirement: Tmux Session Cleanup

The system SHALL clean up associated tmux sessions when virtual worktrees are removed.

#### Scenario: Cleanup with active tmux session
- **WHEN** user runs cleanup for worktree with active tmux session
- **THEN** warning displayed: "Tmux session 'vw-<slug>' is active"
- **AND** prompted: "Kill tmux session? (y/n)"
- **AND** if yes: tmux session/window is killed first
- **AND** if no: cleanup continues but session remains
- **AND** cleanup proceeds with virtual worktree removal

#### Scenario: Cleanup without tmux session
- **WHEN** cleanup runs for worktree without tmux session
- **THEN** only virtual worktree and branch are cleaned
- **AND** no tmux prompts shown
- **AND** normal cleanup flow

#### Scenario: Auto-detect tmux session for cleanup
- **WHEN** cleanup action starts
- **THEN** checks if tmux session with name `vw-<slug>` exists
- **AND** checks current session windows for matching name
- **AND** detects both session-level and window-level matches

### Requirement: FZF Preview Pane Integration

The system SHALL display detailed worktree information in fzf preview pane during selection.

#### Scenario: Preview active worktree
- **WHEN** user navigates worktree list in fzf
- **THEN** preview pane shows:
  - Base branch
  - Created at timestamp
  - Created by user
  - Remote URL
  - Clone depth
  - Feature branch name
  - Virtual worktree path
  - Directory status (Active/Missing)
  - Git status (if active)
  - Commits ahead of base
- **AND** preview updates as selection changes
- **AND** color coded: green for active, yellow for missing

#### Scenario: Preview missing worktree
- **WHEN** fzf shows missing worktree (directory deleted)
- **THEN** preview displays metadata from JSON
- **AND** shows: "[Missing] Directory not found"
- **AND** suggests running cleanup
- **AND** highlights in yellow

#### Scenario: Preview with git status
- **WHEN** worktree directory exists and is active
- **THEN** preview runs git status --short
- **AND** displays uncommitted changes
- **AND** shows files to commit
- **AND** warns if working tree is dirty

### Requirement: Merge Action with Strategy Selection

The system SHALL allow selecting merge strategy interactively through fzf.

#### Scenario: Select merge strategy
- **WHEN** user selects Merge action and chooses worktree
- **THEN** fzf displays merge strategy options:
  - Auto (detect conflicts, smart strategy)
  - Force Rebase (no conflict check)
  - Force Merge (always merge commit)
  - Dry Run (preview without executing)
- **AND** default is Auto
- **AND** user selects strategy with Enter
- **AND** git-smart-merge called with appropriate flags

#### Scenario: Post-merge cleanup prompt
- **WHEN** merge completes successfully
- **THEN** prompt displayed: "Merge successful! Cleanup worktree? (y/n)"
- **AND** if yes: runs cleanup action automatically
- **AND** if no: returns to main menu
- **AND** displays next steps (push to remote)

#### Scenario: Merge with conflicts
- **WHEN** merge fails due to conflicts
- **THEN** error message displayed with conflict details
- **AND** suggests resolution steps
- **AND** does NOT prompt for cleanup
- **AND** user can manually fix and retry

### Requirement: Dependency Management and Validation

The system SHALL validate all required dependencies are installed before operations.

#### Scenario: Check dependencies on startup
- **WHEN** git-vw-interactive script starts
- **THEN** checks for fzf installation
- **AND** checks for tmux installation
- **AND** checks for git-virtual-worktree script
- **AND** if any missing, displays error with installation instructions
- **AND** exits with code 1

#### Scenario: Missing fzf
- **WHEN** fzf is not installed
- **THEN** error: "fzf is required but not installed"
- **AND** suggests: "brew install fzf" or "apt-get install fzf"
- **AND** provides link to fzf repo
- **AND** exits before showing menu

#### Scenario: Missing tmux
- **WHEN** tmux is not installed
- **THEN** error: "tmux is required but not installed"
- **AND** suggests: "brew install tmux" or "apt-get install tmux"
- **AND** offers to run without tmux integration (degraded mode)

#### Scenario: Missing git-virtual-worktree
- **WHEN** git-virtual-worktree script not found in PATH or bin/
- **THEN** error: "git-virtual-worktree not found"
- **AND** shows expected locations
- **AND** suggests checking installation
- **AND** exits with code 1

### Requirement: Input Validation and Error Handling

The system SHALL validate all user inputs and provide helpful error messages.

#### Scenario: Invalid slug format
- **WHEN** user enters slug with spaces or special characters
- **THEN** error: "Invalid slug format"
- **AND** explains: "Only letters, numbers, hyphens, underscores allowed"
- **AND** re-prompts for slug
- **AND** shows example: "my-feature-123"

#### Scenario: Duplicate slug
- **WHEN** user enters slug that already exists
- **THEN** error: "Virtual worktree 'slug' already exists"
- **AND** shows existing worktree details
- **AND** suggests different slug or cleanup existing
- **AND** re-prompts for slug

#### Scenario: Invalid depth
- **WHEN** user enters non-numeric or negative depth
- **THEN** error: "Depth must be positive integer"
- **AND** defaults to 1 if invalid
- **AND** continues with default

#### Scenario: User cancels fzf selection
- **WHEN** user presses Esc or Ctrl-C in fzf
- **THEN** returns to main menu (not exit script)
- **AND** no error message (normal cancellation)
- **AND** menu redisplays

### Requirement: List and Status Actions

The system SHALL provide formatted list and detailed status views.

#### Scenario: List all worktrees
- **WHEN** user selects List action
- **THEN** calls git-virtual-worktree list
- **AND** displays formatted table output
- **AND** adds pagination if many worktrees
- **AND** prompt: "Press Enter to continue"
- **AND** returns to main menu

#### Scenario: Status with tmux info
- **WHEN** user selects Status action and chooses worktree
- **THEN** displays git-virtual-worktree status output
- **AND** adds tmux session info if exists:
  - "[Tmux] Session: vw-<slug>"
  - "[Tmux] Active windows: 3"
- **AND** prompt: "Open in tmux? (y/n)"
- **AND** if yes: switches to tmux session
- **AND** if no: returns to menu

### Requirement: Keyboard Shortcuts and Navigation

The system SHALL provide intuitive keyboard navigation throughout the interface.

#### Scenario: Main menu shortcuts
- **WHEN** user is in main menu
- **THEN** arrow keys or j/k navigate options
- **AND** Enter selects current option
- **AND** Esc or Ctrl-C quits script
- **AND** q also quits (if Quit option)

#### Scenario: FZF list shortcuts
- **WHEN** user is selecting from worktree list
- **THEN** arrow keys or Ctrl-N/P navigate
- **AND** Enter selects worktree
- **AND** Esc cancels and returns to menu
- **AND** Ctrl-D scrolls preview down
- **AND** Ctrl-U scrolls preview up
- **AND** Tab toggles preview pane

#### Scenario: Prompt shortcuts
- **WHEN** user is at text input prompt
- **THEN** Enter submits input
- **AND** Ctrl-C cancels and returns to menu
- **AND** Backspace edits input
- **AND** shows default in brackets: [default]

## MODIFIED Requirements

### Requirement: Virtual Worktree Command Line Interface

The git-virtual-worktree tool SHALL support both direct CLI usage and interactive mode through unified interface.

#### Scenario: Direct CLI usage preserved
- **WHEN** user calls git-virtual-worktree create directly
- **THEN** command works as before (no fzf/tmux)
- **AND** no interactive prompts
- **AND** output to stdout
- **AND** same exit codes

#### Scenario: Interactive mode via git vw
- **WHEN** user calls `git vw` (new alias)
- **THEN** launches git-vw-interactive script
- **AND** shows fzf menu
- **AND** integrates tmux
- **AND** provides guided workflow

#### Scenario: Backwards compatibility
- **WHEN** user uses existing aliases (git vw-create, etc.)
- **THEN** commands work unchanged
- **AND** no interactive mode
- **AND** direct command execution
- **AND** new `git vw` is additional, not replacement

## REMOVED Requirements

None

## RENAMED Requirements

None
