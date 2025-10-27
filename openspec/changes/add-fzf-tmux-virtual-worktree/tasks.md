# Implementation Tasks

## 1. Core Script Structure
- [DONE] 1.1 Create bin/git/git-vw-interactive Bash script
- [DONE] 1.2 Add shebang and script header with dependencies
- [DONE] 1.3 Add dependency checks (fzf, tmux, git-virtual-worktree)
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
- [TODO] 3.1 Prompt for slug name (with validation)
- [TODO] 3.2 Ask for optional --depth and --url
- [TODO] 3.3 Call git-virtual-worktree create with parameters
- [TODO] 3.4 Detect if running inside tmux session
- [TODO] 3.5 If inside tmux: create new window in current session
- [TODO] 3.6 If outside tmux: create new tmux session
- [TODO] 3.7 Set tmux session/window name to slug
- [TODO] 3.8 Navigate to virtual worktree directory in tmux
- [TODO] 3.9 Display success message with tmux session info
- [TODO] 3.10 Auto-switch to new tmux session/window

## 4. Worktree Selection with FZF
- [TODO] 4.1 Create function to list existing virtual worktrees
- [TODO] 4.2 Parse git-virtual-worktree list output
- [TODO] 4.3 Format for fzf display (slug, base branch, status)
- [TODO] 4.4 Add fzf preview pane showing worktree status
- [TODO] 4.5 Highlight active vs missing worktrees
- [TODO] 4.6 Extract selected slug from fzf output
- [TODO] 4.7 Handle no worktrees found (show message)
- [TODO] 4.8 Handle user cancellation

## 5. Merge Action
- [TODO] 5.1 Use fzf to select worktree to merge
- [TODO] 5.2 Ask for merge strategy flags (fzf menu or default auto)
- [TODO] 5.3 Options: Auto (default), Force Rebase, Force Merge, Dry Run
- [TODO] 5.4 Call git-virtual-worktree merge with selected options
- [TODO] 5.5 Show real-time output from merge command
- [TODO] 5.6 Handle merge conflicts (display error, exit gracefully)
- [TODO] 5.7 On success, ask if user wants to cleanup

## 6. Cleanup Action
- [TODO] 6.1 Use fzf to select worktree to cleanup
- [TODO] 6.2 Show confirmation prompt with worktree details
- [TODO] 6.3 Warn if tmux session exists for worktree
- [TODO] 6.4 Call git-virtual-worktree cleanup
- [TODO] 6.5 Kill associated tmux session/window if exists
- [TODO] 6.6 Display cleanup summary

## 7. List Action
- [TODO] 7.1 Call git-virtual-worktree list
- [TODO] 7.2 Display output with pagination if needed
- [TODO] 7.3 Add option to select worktree for status
- [TODO] 7.4 Return to main menu after viewing

## 8. Status Action
- [TODO] 8.1 Use fzf to select worktree for status
- [TODO] 8.2 Call git-virtual-worktree status
- [TODO] 8.3 Display detailed status
- [TODO] 8.4 Add option to open tmux session for worktree
- [TODO] 8.5 Return to main menu

## 9. Tmux Session Management
- [TODO] 9.1 Function to check if inside tmux
- [TODO] 9.2 Function to check if tmux session exists
- [TODO] 9.3 Function to create tmux session with name
- [TODO] 9.4 Function to create tmux window in current session
- [TODO] 9.5 Function to switch to tmux session
- [TODO] 9.6 Function to kill tmux session
- [TODO] 9.7 Function to send commands to tmux window
- [TODO] 9.8 Generate tmux session names from slug (sanitize)

## 10. FZF Preview Pane
- [TODO] 10.1 Create preview script for worktree details
- [TODO] 10.2 Show: base branch, created date, status, path
- [TODO] 10.3 Show git status if worktree exists
- [TODO] 10.4 Show commits ahead of base
- [TODO] 10.5 Add color coding for status indicators
- [TODO] 10.6 Handle preview for missing worktrees

## 11. Input Validation
- [TODO] 11.1 Validate slug format (letters, numbers, hyphens)
- [TODO] 11.2 Check for existing slugs
- [TODO] 11.3 Validate depth is positive integer
- [TODO] 11.4 Validate URL format if provided
- [TODO] 11.5 Check git repository context
- [TODO] 11.6 Add helpful error messages

## 12. Error Handling
- [TODO] 12.1 Handle missing dependencies (fzf, tmux, git-virtual-worktree)
- [TODO] 12.2 Handle git-virtual-worktree command failures
- [TODO] 12.3 Handle tmux command failures
- [TODO] 12.4 Handle fzf cancellations gracefully
- [TODO] 12.5 Provide recovery suggestions
- [TODO] 12.6 Clean up on script interrupt (Ctrl-C)

## 13. Git Alias Configuration
- [TODO] 13.1 Add alias to Git/.gitconfig: vw = !git-vw-interactive
- [TODO] 13.2 Update documentation to use `git vw`
- [TODO] 13.3 Keep existing vw-* aliases for direct access
- [TODO] 13.4 Test alias from various directories

## 14. Testing
- [TODO] 14.1 Test main menu navigation
- [TODO] 14.2 Test create action with tmux session
- [TODO] 14.3 Test create inside existing tmux session
- [TODO] 14.4 Test merge action with fzf selection
- [TODO] 14.5 Test cleanup with tmux session cleanup
- [TODO] 14.6 Test with no existing worktrees
- [TODO] 14.7 Test with multiple worktrees
- [TODO] 14.8 Test tmux session naming edge cases
- [TODO] 14.9 Test outside tmux context
- [TODO] 14.10 Test all fzf keyboard shortcuts

## 15. Documentation
- [TODO] 15.1 Document `git vw` command in main README
- [TODO] 15.2 Add keyboard shortcuts reference
- [TODO] 15.3 Document tmux session naming convention
- [TODO] 15.4 Add usage examples with screenshots/demos
- [TODO] 15.5 Document dependencies and installation
- [TODO] 15.6 Add troubleshooting section
- [TODO] 15.7 Update git-virtual-worktree.md with interactive mode
- [TODO] 15.8 Create video demo or GIF walkthrough

## 16. Polish and User Experience
- [TODO] 16.1 Add colored output for success/error/info
- [TODO] 16.2 Add progress indicators for slow operations
- [TODO] 16.3 Add helpful hints in menus
- [TODO] 16.4 Make fzf prompts descriptive
- [TODO] 16.5 Add "Press Enter to continue" pauses where needed
- [TODO] 16.6 Ensure consistent formatting across all outputs
- [TODO] 16.7 Add ASCII art or branding (optional)
- [TODO] 16.8 Test on different terminal sizes
