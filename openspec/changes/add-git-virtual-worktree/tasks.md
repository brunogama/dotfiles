# Implementation Tasks

## 1. Core Script Structure
- [DONE] 1.1 Create bin/git/git-virtual-worktree Python script with uv shebang
- [DONE] 1.2 Add Rich and Typer dependencies (match worktree script)
- [DONE] 1.3 Define VirtualWorktreeMetadata dataclass (base_branch, created_at, remote_url, depth)
- [DONE] 1.4 Define ExitCode enum (reuse same codes as worktree script)
- [DONE] 1.5 Create VirtualWorktreeManager class for clone management
- [DONE] 1.6 Add Git helper class for command execution
- [DONE] 1.7 Add path validation and slug normalization
- [DONE] 1.8 Document script header with dependencies and purpose

## 2. Create Command
- [DONE] 2.1 Implement create command signature (slug, --depth option, --url option)
- [DONE] 2.2 Get current repository remote URL
- [DONE] 2.3 Validate slug and construct clone directory path
- [DONE] 2.4 Check if directory/branch already exists
- [DONE] 2.5 Execute shallow clone: git clone --depth <n> --branch <base> <url> <dir>
- [DONE] 2.6 Create and checkout new feature branch in clone
- [DONE] 2.7 Save metadata to parent repo .git/ directory (JSON format)
- [DONE] 2.8 Display Rich panel with creation summary and next steps
- [DONE] 2.9 Handle submodules (skip by default, warn user)
- [DONE] 2.10 Add error handling for network/auth issues

## 3. Merge Command
- [DONE] 3.1 Implement merge command with --force-rebase, --force-merge, --dry-run flags
- [DONE] 3.2 Load metadata from parent repo
- [DONE] 3.3 Determine base branch from metadata or current branch
- [DONE] 3.4 Validate feature branch exists in virtual worktree
- [DONE] 3.5 Fetch latest changes in parent repo
- [DONE] 3.6 Update base branch from origin in parent repo
- [DONE] 3.7 Fetch feature branch from virtual worktree into parent repo
- [DONE] 3.8 Call git-smart-merge to integrate feature branch
- [DONE] 3.9 Handle exit codes and display results
- [DONE] 3.10 Provide next steps (push, cleanup)

## 4. Cleanup Command
- [DONE] 4.1 Implement cleanup command signature
- [DONE] 4.2 Check if virtual worktree directory exists
- [DONE] 4.3 Warn if uncommitted changes in virtual worktree
- [DONE] 4.4 Remove virtual worktree directory (shutil.rmtree)
- [DONE] 4.5 Delete feature branch from parent repo
- [DONE] 4.6 Remove metadata file
- [DONE] 4.7 Add confirmation prompts for destructive operations
- [DONE] 4.8 Display Rich panel with cleanup summary

## 5. List and Status Commands
- [DONE] 5.1 Implement list command to show all virtual worktrees
- [DONE] 5.2 Read all virtual-worktree-*.json files from .git/
- [DONE] 5.3 Display Rich table with slug, base branch, directory, status
- [DONE] 5.4 Implement status command for specific virtual worktree
- [DONE] 5.5 Show metadata, directory existence, branch info
- [DONE] 5.6 Display git status from virtual worktree if exists
- [DONE] 5.7 Show commits ahead/behind base branch

## 6. Remote URL and Authentication
- [DONE] 6.1 Add get_remote_url() method to detect origin URL
- [DONE] 6.2 Support HTTPS and SSH URLs
- [DONE] 6.3 Preserve authentication method from parent repo
- [DONE] 6.4 Handle git credential helpers
- [DONE] 6.5 Add --url option to override remote URL
- [DONE] 6.6 Validate remote URL before cloning
- [TODO] 6.7 Handle private repos (test with existing credentials)

## 7. git-smart-merge Integration
- [DONE] 7.1 Reuse find_git_smart_merge() helper
- [DONE] 7.2 Reuse run_git_smart_merge() helper
- [DONE] 7.3 Ensure git-smart-merge works in parent repo context
- [DONE] 7.4 Pass same flags (force-rebase, force-merge, dry-run)
- [DONE] 7.5 Handle exit codes consistently
- [DONE] 7.6 Preserve Rich output styling

## 8. Error Handling and Edge Cases
- [DONE] 8.1 Handle missing remote URL
- [DONE] 8.2 Handle authentication failures during clone
- [DONE] 8.3 Handle partial clone failures (cleanup on error)
- [DONE] 8.4 Handle missing virtual worktree directory
- [DONE] 8.5 Handle orphaned metadata files
- [TODO] 8.6 Handle disk space issues
- [DONE] 8.7 Handle network timeouts
- [DONE] 8.8 Add comprehensive error messages with resolution steps

## 9. Performance Optimizations
- [DONE] 9.1 Use --depth 1 by default for minimal clone
- [DONE] 9.2 Use --single-branch for faster clone
- [DONE] 9.3 Skip submodule initialization by default
- [TODO] 9.4 Add --shallow-submodules flag if submodules needed
- [TODO] 9.5 Use --filter=blob:none for even smaller clones (optional)
- [DONE] 9.6 Implement timeout handling for large repos

## 10. Testing
- [TODO] 10.1 Test create command with small repo
- [TODO] 10.2 Test create command with large monorepo (>1GB)
- [TODO] 10.3 Test merge command with clean changes
- [TODO] 10.4 Test merge command with conflicts
- [TODO] 10.5 Test cleanup command
- [TODO] 10.6 Test list command with multiple virtual worktrees
- [TODO] 10.7 Test status command
- [TODO] 10.8 Test with SSH and HTTPS remotes
- [TODO] 10.9 Test authentication handling
- [TODO] 10.10 Test error scenarios (network failure, disk full, etc.)
- [TODO] 10.11 Benchmark performance vs regular worktree

## 11. Documentation
- [DONE] 11.1 Add comprehensive docstrings to all functions/classes
- [DONE] 11.2 Create help text for all commands
- [DONE] 11.3 Document --depth, --url, and merge flags
- [DONE] 11.4 Add usage examples in script header
- [TODO] 11.5 Create docs/git-virtual-worktree.md with full guide
- [TODO] 11.6 Document when to use virtual worktree vs regular worktree
- [TODO] 11.7 Add performance comparison section
- [TODO] 11.8 Document limitations (no shared history, fetch required)
- [TODO] 11.9 Add troubleshooting section
- [TODO] 11.10 Update README to mention git-virtual-worktree

## 12. Integration and Polish
- [DONE] 12.1 Make script executable (chmod +x)
- [DONE] 12.2 Test with uv runtime
- [DONE] 12.3 Ensure consistent Rich styling with worktree script
- [DONE] 12.4 Verify all exit codes are correct
- [TODO] 12.5 Add script to PATH or create alias
- [TODO] 12.6 Test end-to-end workflow
- [TODO] 12.7 Verify git-smart-merge integration works
- [TODO] 12.8 Compare user experience with worktree script
- [TODO] 12.9 Add example workflow to documentation
- [TODO] 12.10 Consider adding to git aliases
