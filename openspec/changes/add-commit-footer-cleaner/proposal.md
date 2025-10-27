# Add Script to Remove Commit Message Footers from History

## Why

Git commit messages contain various footers that can clutter history and make logs harder to read:

**Current Problems:**
- [NO] "Co-authored-by" footers from pair programming/AI assistance
- [NO] "Signed-off-by" footers from DCO compliance
- [NO] "Reviewed-by" footers from code review tools
- [NO] "Tested-by" footers from CI/CD systems
- [NO] Other automated footers that aren't user-relevant
- [NO] No easy way to clean up history retroactively
- [NO] Footers make `git log` output verbose and hard to scan

**Impact:**
- Cluttered git history
- Harder to find actual commit information
- Unnecessary metadata in logs
- Messy git log output for presentations/documentation
- Historical commits contain outdated footer information

**Use Cases:**
1. Cleaning up before presenting git history
2. Removing AI co-author footers when not wanted
3. Preparing clean history for open source release
4. Simplifying internal repository before sharing
5. Removing deprecated footer formats

## What Changes

**Create Git History Cleanup Script:**
- New script: `scripts/git/clean-commit-footers.sh`
- Removes common footer patterns from commit messages
- Safe operation with backup branch creation
- Interactive mode for confirmation
- Dry-run mode to preview changes
- Configurable footer patterns

**Supported Footer Patterns:**
```
Co-authored-by: Name <email>
Co-Authored-By: Name <email>
Signed-off-by: Name <email>
Signed-Off-By: Name <email>
Reviewed-by: Name <email>
Reviewed-By: Name <email>
Tested-by: Name <email>
Tested-By: Name <email>
Acked-by: Name <email>
Acked-By: Name <email>
Cc: Name <email>
```

**Features:**
- Preserve commit body (only remove footers)
- Handle multiple consecutive footers
- Preserve blank lines before footers
- Case-insensitive matching
- Support for custom footer patterns via arguments
- Backup original history automatically
- Rollback capability

**Safety Measures:**
- Create backup branch before rewriting
- Interactive confirmation (unless --force)
- Dry-run mode (--dry-run)
- Validate git repository state
- Check for uncommitted changes
- Warn about force-push requirements

## Impact

**Files Created:**
- `scripts/git/clean-commit-footers.sh` - Main cleanup script (200-300 lines)
- `docs/guides/GIT_HISTORY_CLEANUP.md` - Usage guide and best practices

**Files Modified:**
- `README.md` - Add link to git history cleanup in Resources
- `ONBOARDING.md` - Add note about commit footer cleanup in git workflow
- `CHANGELOG.md` - Document new script

**Breaking Changes:**
- None (optional script, doesn't affect workflow)
- **WARNING:** Rewrites git history (requires force push)

**Benefits:**
- [YES] Clean, readable git history
- [YES] Easy to scan `git log` output
- [YES] Remove outdated/unnecessary footers
- [YES] Prepare history for sharing
- [YES] Safe operation with backup and rollback
- [YES] Flexible footer pattern matching

**Risks:**
- **High Risk:** Rewrites git history (mitigated by backup branch)
- **Medium Risk:** Requires force push to remote (clearly documented)
- **Low Risk:** Collaborators need to rebase (standard for history rewrite)

**Mitigation:**
- Script creates backup branch automatically
- Clear warnings before destructive operations
- Dry-run mode to preview changes
- Comprehensive documentation
- Rollback instructions included
