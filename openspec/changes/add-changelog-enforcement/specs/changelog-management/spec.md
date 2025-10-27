# CHANGELOG Management Specification Delta

## ADDED Requirements

### Requirement: Project SHALL Maintain a User-Facing CHANGELOG

The project SHALL maintain a CHANGELOG.md file following [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.

#### Scenario: User checks what changed

- **WHEN** user opens CHANGELOG.md
- **THEN** they SHALL see all notable changes organized by version
- **AND** changes SHALL be categorized (Added, Changed, Fixed, etc.)
- **AND** most recent changes SHALL be at the top
- **AND** each entry SHALL be user-focused (not technical implementation)

#### Scenario: Developer prepares release

- **WHEN** developer prepares a release
- **THEN** they SHALL move [Unreleased] entries to a new version section
- **AND** version SHALL follow semantic versioning (MAJOR.MINOR.PATCH)
- **AND** release date SHALL be in YYYY-MM-DD format

### Requirement: Pre-Commit Hooks SHALL Enforce CHANGELOG Updates

The project SHALL use pre-commit hooks to verify CHANGELOG updates for user-facing changes.

**Configuration File:** `.pre-commit-config.yaml`

#### Scenario: Developer commits user-facing change

- **WHEN** developer commits with type `feat:`, `fix:`, `perf:`, or `refactor:`
- **THEN** pre-commit hook SHALL check for CHANGELOG.md changes
- **AND** hook SHALL verify [Unreleased] section has new entries
- **AND** commit SHALL fail if CHANGELOG is unchanged
- **AND** error message SHALL provide clear instructions

#### Scenario: Developer commits non-user-facing change

- **WHEN** developer commits with type `chore:`, `docs:`, `test:`, or `ci:`
- **THEN** pre-commit hook SHALL skip CHANGELOG validation
- **AND** commit SHALL succeed without CHANGELOG update

#### Scenario: Developer needs to bypass hook

- **WHEN** developer uses `git commit --no-verify`
- **THEN** commit SHALL succeed without running hooks
- **AND** bypass SHALL be documented in contributing guidelines

### Requirement: CHANGELOG Validation Script SHALL Be Maintainable

The validation script SHALL be clear, testable, and pass shellcheck.

**Location:** `scripts/validate-changelog.sh`

**Requirements:**

- SHALL use `set -euo pipefail` for safety
- SHALL pass shellcheck with no errors
- SHALL provide helpful error messages
- SHALL be executable (`chmod +x`)
- SHALL check git diff for CHANGELOG.md changes
- SHALL parse commit message to determine type

#### Scenario: Script detects missing CHANGELOG update

- **WHEN** script runs on feat/fix commit without CHANGELOG changes
- **THEN** it SHALL exit with code 1
- **AND** it SHALL print error message:

  ```
  ERROR: CHANGELOG.md not updated for user-facing change

  This commit (feat: ...) requires a CHANGELOG entry.
  Please add your change to the [Unreleased] section in CHANGELOG.md

  Example:
  ### Added
  - New feature description
  ```

#### Scenario: Script detects valid CHANGELOG update

- **WHEN** script runs on feat/fix commit with CHANGELOG changes
- **THEN** it SHALL verify [Unreleased] section exists
- **AND** it SHALL exit with code 0

### Requirement: Pre-Commit Configuration SHALL Include Quality Checks

The `.pre-commit-config.yaml` SHALL include hooks for code quality.

**Required Hooks:**

- `shellcheck` - Shell script linting
- `trailing-whitespace` - Remove trailing whitespace
- `end-of-file-fixer` - Ensure files end with newline
- `check-yaml` - Validate YAML syntax
- `check-json` - Validate JSON syntax
- `black` - Python code formatting (if Python files exist)
- `isort` - Python import sorting (if Python files exist)

#### Scenario: Developer commits with code quality issues

- **WHEN** developer commits shell script with shellcheck errors
- **THEN** pre-commit SHALL fail
- **AND** error message SHALL show specific issues
- **AND** developer SHALL fix issues before committing

#### Scenario: Pre-commit auto-fixes issues

- **WHEN** developer commits file with trailing whitespace
- **THEN** pre-commit SHALL remove whitespace automatically
- **AND** files SHALL be staged with fixes
- **AND** developer SHALL need to re-commit

### Requirement: Documentation SHALL Explain CHANGELOG Workflow

README.md and CONTRIBUTING.md SHALL document how to use CHANGELOG.

#### Scenario: New contributor reads CONTRIBUTING.md

- **WHEN** new contributor reads contributing guidelines
- **THEN** they SHALL find clear CHANGELOG update instructions
- **AND** they SHALL see examples of good entries
- **AND** they SHALL understand which commits need CHANGELOG updates
- **AND** they SHALL know how to set up pre-commit

**Example Documentation:**

```markdown
## Updating the CHANGELOG

Add entries to the [Unreleased] section of CHANGELOG.md:

- **feat:** → Added
- **fix:** → Fixed
- **perf:** → Changed (performance improvement)
- **refactor:** → Changed (if user-visible)
- **BREAKING CHANGE:** → Changed (with note)

Example:
\`\`\`markdown
### Added
- Environment switching with `work-mode` command

### Fixed
- Broken symlinks in git configuration
\`\`\`
```

### Requirement: CHANGELOG Entries SHALL Be User-Focused

Entries SHALL describe impact on users, not implementation details.

**Good Examples:**

```markdown
### Added
- Environment switching between work and personal configurations
- Interactive shell reload option after environment changes

### Fixed
- Git repository initialization error when .git file is corrupted
```

**Bad Examples:**

```markdown
### Added
- Refactored work-mode script to use ~/.zshenv instead of marker file

### Fixed
- Changed git init logic to backup .git file first
```

#### Scenario: Reviewer checks CHANGELOG entry

- **WHEN** reviewer reads CHANGELOG entry
- **THEN** they SHALL understand user impact without reading code
- **AND** entry SHALL use user-facing terminology
- **AND** entry SHALL not mention internal implementation

## MODIFIED Requirements

### Requirement: User-Facing Commits SHALL Update CHANGELOG

Previously commits only needed conventional commit format. Now user-facing commits SHALL also update CHANGELOG.md.

**Before:**

- Commits required conventional commit format (feat:, fix:, etc.)
- No CHANGELOG update requirement

**After:**

- Commits still require conventional commit format
- User-facing commits (feat, fix, perf, refactor) SHALL update CHANGELOG.md
- Non-user-facing commits (chore, docs, test, ci) do not require CHANGELOG update

#### Scenario: Developer commits new feature

- **WHEN** developer commits with `feat:` prefix
- **THEN** commit SHALL include CHANGELOG.md changes
- **AND** [Unreleased] section SHALL have new entry
- **AND** pre-commit hook SHALL enforce this requirement
- **AND** commit SHALL fail if CHANGELOG is not updated

## VALIDATION

### Pre-Implementation Checks

```bash
# Verify no CHANGELOG exists
ls CHANGELOG.md  # Should fail

# Verify no pre-commit config
ls .pre-commit-config.yaml  # Should fail

# Verify validation script doesn't exist
ls scripts/validate-changelog.sh  # Should fail
```

### Post-Implementation Checks

```bash
# Verify CHANGELOG exists and is valid
cat CHANGELOG.md | grep "\[Unreleased\]"  # Should find section

# Verify pre-commit config exists
pre-commit validate-config  # Should pass

# Verify validation script exists and is executable
test -x scripts/validate-changelog.sh && echo "Executable"

# Test validation script
./scripts/validate-changelog.sh  # Should run without errors

# Test pre-commit installation
pre-commit install  # Should succeed

# Test hook triggers
git commit -m "feat: test" --allow-empty  # Should fail (no CHANGELOG)

# Test hook bypass
git commit -m "feat: test" --allow-empty --no-verify  # Should succeed
```

### Acceptance Criteria

- [ ] CHANGELOG.md exists and follows Keep a Changelog format
- [ ] [Unreleased] section exists and contains recent changes
- [ ] `.pre-commit-config.yaml` exists with all required hooks
- [ ] `scripts/validate-changelog.sh` exists, executable, passes shellcheck
- [ ] Pre-commit hook fails on feat/fix without CHANGELOG update
- [ ] Pre-commit hook passes on chore/docs without CHANGELOG update
- [ ] Pre-commit can be bypassed with --no-verify
- [ ] README.md documents pre-commit setup
- [ ] CONTRIBUTING.md documents CHANGELOG workflow
- [ ] All existing files pass pre-commit hooks
- [ ] `pre-commit run --all-files` succeeds
