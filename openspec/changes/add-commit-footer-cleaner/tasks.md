# Implementation Tasks

## 1. Create Main Cleanup Script
- [ ] 1.1 Create `scripts/git/clean-commit-footers.sh`
- [ ] 1.2 Add shebang and safety flags (`set -euo pipefail`)
- [ ] 1.3 Add script header with description and usage
- [ ] 1.4 Define footer pattern array (Co-authored-by, Signed-off-by, etc.)
- [ ] 1.5 Add case-insensitive pattern matching
- [ ] 1.6 Make script executable: `chmod +x scripts/git/clean-commit-footers.sh`

## 2. Implement Safety Checks
- [ ] 2.1 Check if in git repository: `git rev-parse --git-dir`
- [ ] 2.2 Check for uncommitted changes: `git diff-index --quiet HEAD`
- [ ] 2.3 Check for untracked files that matter
- [ ] 2.4 Verify current branch name
- [ ] 2.5 Warn if on main/master branch
- [ ] 2.6 Check for existing backup branch

## 3. Implement Backup Functionality
- [ ] 3.1 Create backup branch with timestamp
- [ ] 3.2 Format: `backup-before-footer-cleanup-YYYY-MM-DD-HHMMSS`
- [ ] 3.3 Tag backup point for easy reference
- [ ] 3.4 Print backup branch name for user
- [ ] 3.5 Store backup ref in temporary file

## 4. Implement Footer Removal Logic
- [ ] 4.1 Use `git filter-branch` or `git filter-repo` for rewriting
- [ ] 4.2 Create commit-msg filter script
- [ ] 4.3 Parse commit message into header, body, footers
- [ ] 4.4 Identify footer section (consecutive footer lines at end)
- [ ] 4.5 Remove matching footer patterns
- [ ] 4.6 Preserve non-footer content
- [ ] 4.7 Preserve blank lines between body and footers (if body remains)
- [ ] 4.8 Handle edge cases:
  - Commit with only subject
  - Commit with subject and footers (no body)
  - Multiple consecutive footers
  - Footers mid-message (keep those)

## 5. Add Command-Line Arguments
- [ ] 5.1 Add `--dry-run` flag to preview changes
- [ ] 5.2 Add `--force` flag to skip confirmation
- [ ] 5.3 Add `--pattern <regex>` for custom footer patterns
- [ ] 5.4 Add `--since <commit>` to limit rewrite range
- [ ] 5.5 Add `--help` flag with usage information
- [ ] 5.6 Add `--backup-only` to create backup without cleaning
- [ ] 5.7 Add `--rollback` to restore from backup

## 6. Implement Dry-Run Mode
- [ ] 6.1 Show commits that would be modified
- [ ] 6.2 Show before/after diff for each commit message
- [ ] 6.3 Count total commits affected
- [ ] 6.4 Show footer patterns that would be removed
- [ ] 6.5 Exit without making changes

## 7. Implement Interactive Confirmation
- [ ] 7.1 Show summary of changes to be made
- [ ] 7.2 Show warning about history rewrite
- [ ] 7.3 Show backup branch information
- [ ] 7.4 Prompt user for confirmation (Y/n)
- [ ] 7.5 Explain force-push requirements
- [ ] 7.6 Skip confirmation if --force flag set

## 8. Add Rollback Functionality
- [ ] 8.1 Implement `--rollback` option
- [ ] 8.2 Find most recent backup branch
- [ ] 8.3 Confirm rollback with user
- [ ] 8.4 Reset to backup branch: `git reset --hard <backup>`
- [ ] 8.5 Show rollback success message
- [ ] 8.6 Keep backup branch for safety

## 9. Add Error Handling
- [ ] 9.1 Handle git command failures gracefully
- [ ] 9.2 Clean up temporary files on error
- [ ] 9.3 Preserve backup branch on error
- [ ] 9.4 Provide helpful error messages
- [ ] 9.5 Exit with appropriate error codes
- [ ] 9.6 Handle Ctrl+C gracefully

## 10. Create Documentation Guide
- [ ] 10.1 Create `docs/guides/GIT_HISTORY_CLEANUP.md`
- [ ] 10.2 Document common use cases
- [ ] 10.3 Add step-by-step cleanup guide
- [ ] 10.4 Document all command-line options
- [ ] 10.5 Add examples for each option
- [ ] 10.6 Document force-push workflow
- [ ] 10.7 Add team coordination instructions
- [ ] 10.8 Document rollback procedure

## 11. Update README.md
- [ ] 11.1 Add "Git History Cleanup" section in Git Tools
- [ ] 11.2 Add link to GIT_HISTORY_CLEANUP.md guide
- [ ] 11.3 Add warning about history rewriting
- [ ] 11.4 Add common usage examples

## 12. Update ONBOARDING.md
- [ ] 12.1 Add commit footer cleanup to Git Workflow section
- [ ] 12.2 Explain when to use footer cleanup
- [ ] 12.3 Add warning about force-push implications
- [ ] 12.4 Link to detailed guide

## 13. Test Script Thoroughly
- [ ] 13.1 Test in clean test repository
- [ ] 13.2 Test dry-run mode
- [ ] 13.3 Test actual cleanup on test commits
- [ ] 13.4 Test backup creation
- [ ] 13.5 Test rollback functionality
- [ ] 13.6 Test with various footer combinations
- [ ] 13.7 Test edge cases:
  - Empty commit messages
  - Single-line commits
  - Commits with only footers
  - Mixed footer formats
- [ ] 13.8 Verify shellcheck passes: `shellcheck scripts/git/clean-commit-footers.sh`

## 14. Update CHANGELOG.md
- [ ] 14.1 Add entry under [Unreleased] → ### Added
- [ ] 14.2 Describe new script capability
- [ ] 14.3 Mention safety features (backup, dry-run)
- [ ] 14.4 Note that it's optional and destructive

## 15. Validation & Testing
- [ ] 15.1 Run script on test repository
- [ ] 15.2 Verify footers are removed correctly
- [ ] 15.3 Verify commit bodies are preserved
- [ ] 15.4 Verify backup branch created
- [ ] 15.5 Verify rollback works
- [ ] 15.6 Verify dry-run shows accurate preview
- [ ] 15.7 Test force-push workflow

## 16. Final Review
- [ ] 16.1 Proofread all documentation
- [ ] 16.2 Ensure script follows project conventions
- [ ] 16.3 Verify all safety warnings present
- [ ] 16.4 Check all examples work
- [ ] 16.5 Ensure rollback instructions clear
