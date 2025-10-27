# Implementation Tasks

## 1. Refactor merge Command
- [DONE] 1.1 Add helper method to find git-smart-merge script path
- [DONE] 1.2 Replace manual rebase logic (lines 520-535) with git-smart-merge subprocess call
- [DONE] 1.3 Add `--force-rebase` flag to merge command signature
- [DONE] 1.4 Add `--force-merge` flag to merge command signature
- [DONE] 1.5 Add `--dry-run` flag to merge command signature
- [DONE] 1.6 Pass appropriate flags to git-smart-merge based on user options
- [DONE] 1.7 Update error handling to parse git-smart-merge exit codes (0, 1, 2)
- [DONE] 1.8 Preserve Rich console styling for output integration

## 2. Base Branch Update Logic
- [DONE] 2.1 Keep existing fetch logic (lines 506-509)
- [DONE] 2.2 Keep existing base branch rebase onto origin (lines 511-522)
- [DONE] 2.3 Ensure clean state before calling git-smart-merge
- [DONE] 2.4 Document that git-smart-merge handles feature→base integration

## 3. Error Handling and User Experience
- [DONE] 3.1 Map git-smart-merge exit codes to WorktreeManager exit codes
- [DONE] 3.2 Enhance error messages to indicate git-smart-merge was used
- [DONE] 3.3 Update "Next steps" output based on merge vs rebase outcome
- [DONE] 3.4 Test error scenarios (conflicts, missing branch, uncommitted changes)
- [DONE] 3.5 Ensure Rich formatting is preserved in combined output

## 4. Testing
- [DONE] 4.1 Test merge command with clean rebase (no conflicts)
- [DONE] 4.2 Test merge command with conflicting changes (auto fallback to merge)
- [DONE] 4.3 Test --force-rebase flag functionality
- [DONE] 4.4 Test --force-merge flag functionality
- [DONE] 4.5 Test --dry-run flag functionality
- [DONE] 4.6 Test error handling when git-smart-merge not found
- [DONE] 4.7 Verify base branch update still works correctly
- [DONE] 4.8 Test with metadata present and missing

## 5. Documentation
- [DONE] 5.1 Update git-worktree-feature-py docstring for merge command
- [DONE] 5.2 Document new --force-rebase, --force-merge, --dry-run flags
- [DONE] 5.3 Update merge command help text with flag examples
- [DONE] 5.4 Document dependency on git-smart-merge in script header
- [DONE] 5.5 Add troubleshooting section for git-smart-merge integration
- [DONE] 5.6 Update README if git-worktree-feature-py is documented there

## 6. Integration and Validation
- [DONE] 6.1 Verify git-smart-merge is in PATH or findable relative to script
- [DONE] 6.2 Add fallback behavior if git-smart-merge not available
- [DONE] 6.3 Test end-to-end workflow: create → work → merge → cleanup
- [DONE] 6.4 Verify error messages are actionable and clear
- [DONE] 6.5 Check that all existing merge command functionality is preserved
