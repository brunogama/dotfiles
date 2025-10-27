# Git History Cleanup Specification Delta

## ADDED Requirements

### Requirement: Script SHALL Safely Remove Commit Message Footers
The project SHALL provide a script to remove common footer patterns from git commit history with safety measures.

**Script Location:** `scripts/git/clean-commit-footers.sh`

#### Scenario: User wants to clean commit footers
- **WHEN** user runs `clean-commit-footers.sh`
- **THEN** script SHALL create backup branch before any changes
- **AND** script SHALL show preview of changes in dry-run mode
- **AND** script SHALL prompt for confirmation before rewriting
- **AND** script SHALL remove only footer patterns (preserve body)
- **AND** script SHALL handle all footer pattern variations

#### Scenario: User runs in dry-run mode
- **WHEN** user runs `clean-commit-footers.sh --dry-run`
- **THEN** script SHALL show commits that would be modified
- **AND** script SHALL show before/after diff for each commit
- **AND** script SHALL NOT modify any commits
- **AND** script SHALL exit with code 0

### Requirement: Script SHALL Support Common Footer Patterns
The script SHALL recognize and remove standard git trailer patterns.

**Required Patterns (case-insensitive):**
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

#### Scenario: Remove Co-authored-by footers
- **WHEN** commit message contains "Co-authored-by: name <email>"
- **THEN** script SHALL remove the entire footer line
- **AND** script SHALL preserve commit subject and body
- **AND** script SHALL remove trailing blank lines after footer removal

#### Scenario: Remove multiple consecutive footers
- **WHEN** commit has multiple footer lines
- **THEN** script SHALL remove all matching footer patterns
- **AND** script SHALL preserve non-footer content
- **AND** script SHALL handle footers with various capitalizations

#### Scenario: Preserve footers in commit body
- **WHEN** footer pattern appears in commit body (not at end)
- **THEN** script SHALL NOT remove it (only remove trailing footers)
- **AND** script SHALL only process footer block at end of message

### Requirement: Script SHALL Create Automatic Backups
Before any history modification, script SHALL create a backup branch.

**Backup Branch Format:** `backup-before-footer-cleanup-YYYY-MM-DD-HHMMSS`

#### Scenario: User runs cleanup script
- **WHEN** script starts execution
- **THEN** it SHALL check if backup branch already exists
- **AND** it SHALL create new backup branch from current HEAD
- **AND** it SHALL print backup branch name to user
- **AND** it SHALL tag backup point for easy reference

#### Scenario: Backup branch already exists
- **WHEN** backup branch with same timestamp exists
- **THEN** script SHALL append sequence number (-2, -3, etc.)
- **OR** script SHALL use more precise timestamp (include seconds)

### Requirement: Script SHALL Support Rollback
The script SHALL allow users to restore original history from backup.

#### Scenario: User wants to undo cleanup
- **WHEN** user runs `clean-commit-footers.sh --rollback`
- **THEN** script SHALL find most recent backup branch
- **AND** script SHALL confirm rollback with user
- **AND** script SHALL reset current branch to backup
- **AND** script SHALL preserve backup branch for future reference
- **AND** script SHALL display success message with new HEAD

#### Scenario: No backup branch exists
- **WHEN** user runs --rollback but no backup branch exists
- **THEN** script SHALL exit with error
- **AND** script SHALL print helpful message about when backups are created

### Requirement: Script SHALL Validate Repository State
Before modifying history, script SHALL verify safe conditions.

#### Scenario: Repository has uncommitted changes
- **WHEN** user runs script with dirty working directory
- **THEN** script SHALL exit with error
- **AND** script SHALL print message to commit or stash changes
- **AND** script SHALL NOT create backup or modify history

#### Scenario: Not in a git repository
- **WHEN** script runs outside git repository
- **THEN** script SHALL exit with error code 1
- **AND** script SHALL print clear error message

#### Scenario: Current branch is main/master
- **WHEN** user runs on main or master branch
- **THEN** script SHALL show extra warning
- **AND** script SHALL require explicit confirmation
- **AND** script SHALL remind about force-push implications

### Requirement: Script SHALL Provide Clear Warnings
The script SHALL warn users about destructive operations.

#### Scenario: Before rewriting history
- **WHEN** script is about to rewrite history
- **THEN** it SHALL display warning about history modification
- **AND** it SHALL explain that force-push will be needed
- **AND** it SHALL show backup branch information
- **AND** it SHALL prompt for user confirmation
- **AND** it SHALL allow abort (Ctrl+C or 'n' response)

**Warning Message SHALL Include:**
```
[WARNING]  WARNING: This will rewrite git history!

This operation will:
- Modify commit hashes (SHAs will change)
- Require force-push to update remote: git push --force-with-lease
- Require collaborators to rebase their work

Backup branch created: backup-before-footer-cleanup-2025-10-23-123456

Continue? [y/N]:
```

### Requirement: Documentation SHALL Explain Force-Push Workflow
Documentation SHALL guide users through safe history rewrite workflow.

#### Scenario: User reads git history cleanup guide
- **WHEN** user opens `docs/guides/GIT_HISTORY_CLEANUP.md`
- **THEN** they SHALL see complete workflow explanation
- **AND** they SHALL see team coordination instructions
- **AND** they SHALL see force-push examples with --force-with-lease
- **AND** they SHALL see rollback instructions

**Required Documentation Topics:**
1. When to clean commit footers
2. How backup and rollback works
3. Force-push workflow and --force-with-lease
4. Team coordination (announcing history rewrite)
5. What to do if things go wrong
6. Common use cases and examples

### Requirement: Script SHALL Handle Edge Cases
The script SHALL correctly process various commit message formats.

#### Scenario: Commit with only subject line
- **WHEN** commit message is single line with no footers
- **THEN** script SHALL NOT modify commit
- **AND** script SHALL skip to next commit

#### Scenario: Commit with subject and footer (no body)
- **WHEN** commit has subject line, blank line, then footer
- **THEN** script SHALL remove footer
- **AND** script SHALL remove trailing blank line
- **AND** result SHALL be single-line commit

#### Scenario: Footer in middle of message
- **WHEN** footer pattern appears in commit body (not at end)
- **THEN** script SHALL NOT remove it
- **AND** script SHALL only process trailing footer block

#### Scenario: Multiple blank lines before footers
- **WHEN** commit has multiple blank lines before footers
- **THEN** script SHALL preserve one blank line after body
- **AND** script SHALL remove excess blank lines and footers

## MODIFIED Requirements

### Requirement: Git Scripts SHALL Be Safe and Reversible
Previously git scripts were tools without specific safety requirements. Now git history modification scripts SHALL include automatic backups and rollback capabilities.

**Before:**
- Git scripts could modify history without safeguards
- Manual backup was user's responsibility

**After:**
- Scripts SHALL create automatic backups
- Scripts SHALL provide rollback functionality
- Scripts SHALL validate repository state before changes
- Scripts SHALL warn about destructive operations

#### Scenario: User runs history-modifying script
- **WHEN** any script modifies git history
- **THEN** it SHALL create backup automatically
- **AND** it SHALL warn about consequences
- **AND** it SHALL require confirmation
- **AND** it SHALL provide rollback option

## VALIDATION

### Pre-Implementation Checks
```bash
# Verify script doesn't exist
ls scripts/git/clean-commit-footers.sh  # Should fail

# Verify guide doesn't exist
ls docs/guides/GIT_HISTORY_CLEANUP.md   # Should fail
```

### Post-Implementation Checks

```bash
# Verify script exists and is executable
test -x scripts/git/clean-commit-footers.sh && echo "Executable"

# Verify shellcheck passes
shellcheck scripts/git/clean-commit-footers.sh

# Test dry-run mode
./scripts/git/clean-commit-footers.sh --dry-run

# Test help output
./scripts/git/clean-commit-footers.sh --help

# Verify guide exists
test -f docs/guides/GIT_HISTORY_CLEANUP.md && echo "Guide exists"
```

### Functional Tests

```bash
# Create test repository
git init test-repo
cd test-repo

# Create test commit with footers
git commit --allow-empty -m "feat: test commit

This is the body.

Co-authored-by: Bot <bot@example.com>
Signed-off-by: User <user@example.com>"

# Test dry-run
../scripts/git/clean-commit-footers.sh --dry-run
# Should show preview of changes

# Test actual cleanup
../scripts/git/clean-commit-footers.sh --force
# Should remove footers, create backup

# Verify backup created
git branch | grep backup-before-footer-cleanup

# Verify footers removed
git log --format=%B -1 | grep -i "co-authored-by" && echo "FAIL" || echo "PASS"

# Test rollback
../scripts/git/clean-commit-footers.sh --rollback
# Should restore original commit

# Verify footer restored
git log --format=%B -1 | grep -i "co-authored-by" && echo "PASS" || echo "FAIL"
```

### Acceptance Criteria
- [ ] Script exists and is executable
- [ ] Passes shellcheck with no errors
- [ ] Removes all standard footer patterns
- [ ] Preserves commit subject and body
- [ ] Creates backup branch automatically
- [ ] Dry-run mode works correctly
- [ ] Rollback restores original history
- [ ] Validates repository state before running
- [ ] Shows clear warnings before destructive operations
- [ ] Documentation guide is comprehensive
- [ ] All edge cases handled correctly
- [ ] CHANGELOG.md updated with new feature
