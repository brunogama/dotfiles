# Implementation Tasks

## 1. Core Script Structure
- [DONE] 1.1 Create bin/git/git-wt-interactive Bash script
- [DONE] 1.2 Add shebang and script header with dependencies
- [DONE] 1.3 Add dependency checks (fzf, tmux, git-worktree, jq)
- [DONE] 1.4 Define color variables for output
- [DONE] 1.5 Add helper functions for logging
- [DONE] 1.6 Add error handling and exit codes
- [DONE] 1.7 Make script executable

## 2. Main Menu Implementation
- [DONE] 2.1 Create main fzf menu with action options
- [DONE] 2.2 Add options: Create, Merge, Cleanup, List, Status, Quit
- [DONE] 2.3 Use fzf with custom prompt and colors
- [DONE] 2.4 Add keyboard shortcuts (Ctrl-C to cancel)
- [DONE] 2.5 Handle empty selection (user cancelled)
- [DONE] 2.6 Loop menu until quit or successful action

## 3. Create Action with Tmux Integration
- [DONE] 3.1 Prompt for slug name (with validation)
- [DONE] 3.2 Call git-worktree create with slug
- [DONE] 3.3 Detect if running inside tmux session
- [DONE] 3.4 If inside tmux: create new window in current session
- [DONE] 3.5 If outside tmux: create new tmux session
- [DONE] 3.6 Set tmux session/window name to wt-<slug>
- [DONE] 3.7 Navigate to worktree directory in tmux
- [DONE] 3.8 Display success message with tmux session info
- [DONE] 3.9 Auto-switch to new tmux session/window

## 4. Worktree Selection with FZF
- [DONE] 4.1 Create function to list existing worktrees
- [DONE] 4.2 Parse git-worktree metadata files (worktree-feature-*.json)
- [DONE] 4.3 Format for fzf display (slug, base branch, status)
- [DONE] 4.4 Add fzf preview pane showing worktree status
- [DONE] 4.5 Highlight active vs missing worktrees
- [DONE] 4.6 Extract selected slug from fzf output
- [DONE] 4.7 Handle no worktrees found (show message)
- [DONE] 4.8 Handle user cancellation

## 5. Merge Action
- [DONE] 5.1 Use fzf to select worktree to merge
- [DONE] 5.2 Ask for merge strategy flags (fzf menu or default auto)
- [DONE] 5.3 Options: Auto (default), Force Rebase, Force Merge, Dry Run
- [DONE] 5.4 Call git-worktree merge with selected options
- [DONE] 5.5 Show real-time output from merge command
- [DONE] 5.6 Handle merge conflicts (display error, exit gracefully)
- [DONE] 5.7 On success, ask if user wants to cleanup

## 6. Cleanup Action
- [DONE] 6.1 Use fzf to select worktree to cleanup
- [DONE] 6.2 Show confirmation prompt with worktree details
- [DONE] 6.3 Warn if tmux session exists for worktree
- [DONE] 6.4 Call git-worktree cleanup
- [DONE] 6.5 Kill associated tmux session/window if exists
- [DONE] 6.6 Display cleanup summary

## 7. List Action
- [DONE] 7.1 Call git-worktree list
- [DONE] 7.2 Display output with pagination if needed
- [DONE] 7.3 Add option to select worktree for status
- [DONE] 7.4 Return to main menu after viewing

## 8. Status Action
- [DONE] 8.1 Use fzf to select worktree for status
- [DONE] 8.2 Call git-worktree status
- [DONE] 8.3 Display detailed status
- [DONE] 8.4 Add option to open tmux session for worktree
- [DONE] 8.5 Return to main menu

## 9. Tmux Session Management
- [DONE] 9.1 Function to check if inside tmux
- [DONE] 9.2 Function to check if tmux session exists
- [DONE] 9.3 Function to create tmux session with name
- [DONE] 9.4 Function to create tmux window in current session
- [DONE] 9.5 Function to switch to tmux session
- [DONE] 9.6 Function to kill tmux session
- [DONE] 9.7 Function to send commands to tmux window
- [DONE] 9.8 Generate tmux session names from slug (sanitize with wt- prefix)

## 10. FZF Preview Pane
- [DONE] 10.1 Create preview script for worktree details
- [DONE] 10.2 Show: base branch, created date, status, path
- [DONE] 10.3 Show git status if worktree exists
- [DONE] 10.4 Show commits ahead of base
- [DONE] 10.5 Add color coding for status indicators
- [DONE] 10.6 Handle preview for missing worktrees

## 11. Input Validation
- [DONE] 11.1 Validate slug format (letters, numbers, hyphens)
- [DONE] 11.2 Check for existing slugs
- [DONE] 11.3 Check git repository context
- [DONE] 11.4 Add helpful error messages

## 12. Error Handling
- [DONE] 12.1 Handle missing dependencies (fzf, tmux, git-worktree, jq)
- [DONE] 12.2 Handle git-worktree command failures
- [DONE] 12.3 Handle tmux command failures
- [DONE] 12.4 Handle fzf cancellations gracefully
- [DONE] 12.5 Provide recovery suggestions
- [DONE] 12.6 Clean up on script interrupt (Ctrl-C)

## 13. Git Alias Configuration
- [TODO] 13.1 Add alias to Git/.gitconfig: wt = !git-wt-interactive
- [TODO] 13.2 Update documentation to use `git wt`
- [TODO] 13.3 Keep existing wt-* aliases for direct access
- [TODO] 13.4 Test alias from various directories

## 14. Testing
- [DONE] 14.1 Test main menu navigation
- [DONE] 14.2 Test create action with tmux session
- [DONE] 14.3 Test create inside existing tmux session
- [DONE] 14.4 Test merge action with fzf selection
- [DONE] 14.5 Test cleanup with tmux session cleanup
- [DONE] 14.6 Test with no existing worktrees
- [DONE] 14.7 Test with multiple worktrees
- [DONE] 14.8 Test tmux session naming edge cases
- [DONE] 14.9 Test outside tmux context
- [DONE] 14.10 Test all fzf keyboard shortcuts

## 15. Documentation
- [TODO] 15.1 Document `git wt` command in main README
- [TODO] 15.2 Add keyboard shortcuts reference
- [TODO] 15.3 Document tmux session naming convention
- [TODO] 15.4 Add usage examples
- [TODO] 15.5 Document dependencies and installation
- [TODO] 15.6 Add troubleshooting section
- [TODO] 15.7 Update docs/git-worktree.md with interactive mode

## 16. Polish and User Experience
- [DONE] 16.1 Add colored output for success/error/info
- [DONE] 16.2 Add progress indicators for slow operations
- [DONE] 16.3 Add helpful hints in menus
- [DONE] 16.4 Make fzf prompts descriptive
- [DONE] 16.5 Add "Press Enter to continue" pauses where needed
- [DONE] 16.6 Ensure consistent formatting across all outputs
- [DONE] 16.7 Test on different terminal sizes
