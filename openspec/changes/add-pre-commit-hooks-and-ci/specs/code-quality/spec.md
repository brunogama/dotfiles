# Code Quality Enforcement Specification

## ADDED Requirements

### Requirement: Pre-commit Hook Framework
The system SHALL provide automated pre-commit hooks to enforce code quality standards.

#### Scenario: Hook Installation
- **GIVEN** repository cloned
- **WHEN** user runs `bin/core/setup-git-hooks`
- **THEN** pre-commit framework installed
- **AND** hooks registered in `.git/hooks/`
- **AND** success message displayed

#### Scenario: Hooks Run Automatically
- **GIVEN** pre-commit hooks installed
- **WHEN** user runs `git commit`
- **THEN** all configured hooks execute
- **AND** commit proceeds only if all checks pass
- **AND** error messages shown for failures

#### Scenario: Hooks Can Be Bypassed
- **GIVEN** pre-commit hooks installed
- **WHEN** user runs `git commit --no-verify`
- **THEN** hooks are skipped
- **AND** commit proceeds without checks
- **AND** developer assumes responsibility

### Requirement: Emoji Detection (MINDSET Rule 2)
The system SHALL reject commits containing emojis in documentation or code.

#### Scenario: Detect Emoji in Markdown
- **GIVEN** file `README.md` contains "Features:  Fast"
- **WHEN** user attempts `git commit`
- **THEN** commit blocked
- **AND** error shows: "ERROR: Emojis found in README.md"
- **AND** message references MINDSET.MD Rule 2

#### Scenario: Allow Emoji-Free Content
- **GIVEN** file `README.md` contains "Features: Fast"
- **WHEN** user attempts `git commit`
- **THEN** emoji check passes
- **AND** no error message

#### Scenario: Check Multiple File Types
- **GIVEN** emoji in .md, .sh, .zsh, or .txt file
- **WHEN** user attempts commit
- **THEN** all text files scanned
- **AND** any emoji triggers rejection

#### Scenario: Exclude Generated Files
- **GIVEN** emoji in `.ai_docs/legacy/report.md`
- **AND** `.ai_docs/` excluded in config
- **WHEN** user attempts commit
- **THEN** excluded file not checked
- **AND** commit proceeds

### Requirement: Lowercase Directory Validation (MINDSET Rule 1)
The system SHALL reject commits creating or modifying uppercase directories.

#### Scenario: Detect Uppercase Directory
- **GIVEN** directory `Bin/` exists
- **WHEN** user attempts commit
- **THEN** commit blocked
- **AND** error shows: "ERROR: Uppercase directory found: Bin/"
- **AND** message references MINDSET.MD Rule 1

#### Scenario: Allow Lowercase Directories
- **GIVEN** all directories lowercase (`bin/`, `git/`, `zsh/`)
- **WHEN** user attempts commit
- **THEN** directory check passes
- **AND** no error message

#### Scenario: Provide Fix Instructions
- **GIVEN** uppercase directory detected
- **WHEN** error displayed
- **THEN** message includes: "Rename directories to lowercase: mv Directory directory"
- **AND** references MINDSET.MD

### Requirement: Shellcheck Validation
The system SHALL reject commits with shellcheck errors in shell scripts.

#### Scenario: Detect Shellcheck Error
- **GIVEN** script contains `echo $undefined_var`
- **WHEN** user attempts commit
- **THEN** commit blocked
- **AND** shellcheck errors displayed
- **AND** severity level "error" enforced

#### Scenario: Allow Clean Shell Scripts
- **GIVEN** script contains `echo "$defined_var"`
- **WHEN** user attempts commit
- **THEN** shellcheck passes
- **AND** no errors

#### Scenario: Check All Shell Scripts
- **GIVEN** multiple .sh, .bash, .zsh files modified
- **WHEN** user attempts commit
- **THEN** all shell scripts checked
- **AND** any failure blocks commit

### Requirement: Conventional Commit Messages
The system SHALL enforce conventional commit message format.

#### Scenario: Valid Conventional Commit
- **GIVEN** commit message "feat: add pre-commit hooks"
- **WHEN** commit attempted
- **THEN** message validation passes
- **AND** commit proceeds

#### Scenario: Invalid Commit Message
- **GIVEN** commit message "added stuff"
- **WHEN** commit attempted
- **THEN** commit blocked
- **AND** error shows conventional format
- **AND** examples provided

#### Scenario: Valid Types Accepted
- **GIVEN** commit message with type: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert
- **WHEN** commit attempted
- **THEN** validation passes for all valid types

#### Scenario: Merge Commits Exempted
- **GIVEN** commit message "Merge branch 'feature' into main"
- **WHEN** commit attempted
- **THEN** validation skipped
- **AND** merge commit allowed

### Requirement: LinkingManifest Validation
The system SHALL validate LinkingManifest.json syntax and structure.

#### Scenario: Valid Manifest
- **GIVEN** LinkingManifest.json with valid JSON
- **AND** required fields present (links, version)
- **WHEN** manifest modified and committed
- **THEN** validation passes

#### Scenario: Invalid JSON Syntax
- **GIVEN** LinkingManifest.json with trailing comma
- **WHEN** commit attempted
- **THEN** commit blocked
- **AND** error: "Invalid JSON in LinkingManifest.json"

#### Scenario: Missing Required Field
- **GIVEN** LinkingManifest.json missing "version" field
- **WHEN** commit attempted
- **THEN** commit blocked
- **AND** error: "Missing required field 'version'"

### Requirement: OpenSpec Validation
The system SHALL validate OpenSpec proposals for correctness.

#### Scenario: Valid Proposal
- **GIVEN** OpenSpec proposal with valid structure
- **WHEN** proposal files committed
- **THEN** openspec validate runs
- **AND** validation passes

#### Scenario: Invalid Proposal
- **GIVEN** OpenSpec proposal missing spec.md
- **WHEN** proposal committed
- **THEN** commit blocked
- **AND** openspec validation errors shown

#### Scenario: OpenSpec Not Installed
- **GIVEN** openspec command not available
- **WHEN** proposal committed
- **THEN** warning shown: "openspec not installed, skipping"
- **AND** commit proceeds (graceful degradation)

### Requirement: GitHub Actions CI
The system SHALL run automated checks on pull requests.

#### Scenario: CI Runs on Pull Request
- **GIVEN** pull request created
- **WHEN** CI workflow triggered
- **THEN** all checks execute:
  - Shellcheck
  - Emoji detection
  - Lowercase directories
  - LinkingManifest validation
  - Trailing whitespace

#### Scenario: CI Passes on Clean Code
- **GIVEN** PR with no violations
- **WHEN** CI runs
- **THEN** all jobs pass
- **AND** green checkmark on PR
- **AND** merge allowed

#### Scenario: CI Fails on Violations
- **GIVEN** PR with emoji in README.md
- **WHEN** CI runs
- **THEN** lint job fails
- **AND** error details shown
- **AND** merge blocked

#### Scenario: CI Matrix Testing
- **GIVEN** CI configured with matrix (ubuntu, macos)
- **WHEN** CI runs
- **THEN** tests run on both platforms
- **AND** installation tested on each
- **AND** all must pass

### Requirement: Trailing Whitespace Check
The system SHALL detect and reject trailing whitespace.

#### Scenario: Detect Trailing Whitespace
- **GIVEN** file with "line with spaces   \n"
- **WHEN** commit attempted
- **THEN** commit blocked (pre-commit)
- **OR** CI fails with location shown

#### Scenario: Allow Clean Files
- **GIVEN** file with "line without trailing spaces\n"
- **WHEN** commit attempted
- **THEN** check passes

### Requirement: File Format Checks
The system SHALL validate YAML and JSON file syntax.

#### Scenario: Valid YAML
- **GIVEN** .pre-commit-config.yaml with valid syntax
- **WHEN** committed
- **THEN** YAML check passes

#### Scenario: Invalid YAML
- **GIVEN** workflow.yml with indentation error
- **WHEN** committed
- **THEN** commit blocked
- **AND** YAML syntax error shown

#### Scenario: Valid JSON
- **GIVEN** package.json with valid JSON
- **WHEN** committed
- **THEN** JSON check passes

#### Scenario: Invalid JSON
- **GIVEN** config.json with trailing comma
- **WHEN** committed
- **THEN** commit blocked
- **AND** JSON error location shown

### Requirement: Performance
Checks SHALL complete quickly to not impede development flow.

#### Scenario: Pre-commit Completes Under 5 Seconds
- **GIVEN** typical commit with 5 modified files
- **WHEN** hooks run
- **THEN** all checks complete in < 5 seconds
- **AND** developer not significantly delayed

#### Scenario: CI Completes Under 5 Minutes
- **GIVEN** pull request with 20 file changes
- **WHEN** CI runs
- **THEN** full suite completes in < 5 minutes
- **AND** fast feedback provided

### Requirement: Clear Error Messages
Failed checks SHALL provide actionable error messages.

#### Scenario: Error with Fix Instructions
- **GIVEN** shellcheck error in script
- **WHEN** check fails
- **THEN** error message includes:
  - What failed (shellcheck)
  - Which file (bin/core/script)
  - What's wrong (undefined variable)
  - How to fix (quote variables)

#### Scenario: Reference to Documentation
- **GIVEN** MINDSET rule violation
- **WHEN** check fails
- **THEN** error references MINDSET.MD
- **AND** shows specific rule number

### Requirement: Hook Management
Developers SHALL be able to manage hook execution.

#### Scenario: Skip Specific Hook
- **GIVEN** emoji check causing false positive
- **WHEN** user runs `SKIP=no-emojis git commit`
- **THEN** only emoji check skipped
- **AND** other hooks still run

#### Scenario: Skip All Hooks
- **GIVEN** emergency hotfix needed
- **WHEN** user runs `git commit --no-verify`
- **THEN** all hooks skipped
- **AND** commit proceeds

#### Scenario: Run Hooks Manually
- **GIVEN** hooks installed
- **WHEN** user runs `pre-commit run --all-files`
- **THEN** all hooks run on entire repo
- **AND** results displayed

### Requirement: Installation Integration
Hook setup SHALL integrate with existing install script.

#### Scenario: Hooks Installed During Setup
- **GIVEN** fresh dotfiles installation
- **WHEN** `./install` runs
- **THEN** git hooks automatically installed
- **AND** user notified

#### Scenario: Manual Hook Installation
- **GIVEN** hooks not yet installed
- **WHEN** user runs `bin/core/setup-git-hooks`
- **THEN** pre-commit framework installed
- **AND** hooks configured
- **AND** ready for use

## Testing Requirements

### Requirement: Hook Testing
All hooks SHALL be tested before deployment.

#### Scenario: Test Emoji Detection
- **GIVEN** test file with emoji
- **WHEN** test suite runs
- **THEN** emoji detected correctly
- **AND** appropriate error shown

#### Scenario: Test False Positives
- **GIVEN** legitimate content that looks like emoji
- **WHEN** hooks run
- **THEN** no false positive
- **AND** commit allowed

### Requirement: CI Testing
CI configuration SHALL be tested.

#### Scenario: Test CI on PR
- **GIVEN** test PR with known violations
- **WHEN** CI runs
- **THEN** violations detected
- **AND** appropriate failures

#### Scenario: Verify All Jobs Run
- **GIVEN** CI workflow configured
- **WHEN** triggered
- **THEN** lint, test, and openspec jobs all execute
- **AND** results reported

## Documentation Requirements

### Requirement: User Documentation
Users SHALL understand how to use pre-commit hooks.

#### Scenario: Setup Instructions
- **GIVEN** CONTRIBUTING.md read
- **WHEN** user follows instructions
- **THEN** hooks installed successfully
- **AND** usage clear

#### Scenario: Troubleshooting Guide
- **GIVEN** hook fails
- **WHEN** user checks documentation
- **THEN** common issues documented
- **AND** solutions provided

### Requirement: Developer Documentation
Developers SHALL understand how to maintain hooks.

#### Scenario: Add New Hook
- **GIVEN** new check needed
- **WHEN** developer reads docs
- **THEN** process to add hook clear
- **AND** examples provided

#### Scenario: Update Hook
- **GIVEN** hook needs modification
- **WHEN** developer updates
- **THEN** testing process documented
- **AND** rollout procedure clear

## Success Metrics

### Requirement: Adoption
Hooks SHALL be widely adopted by contributors.

#### Scenario: Installation Rate
- **GIVEN** 10 active contributors
- **WHEN** hooks promoted
- **THEN** 80%+ have hooks installed
- **AND** using regularly

### Requirement: Effectiveness
Hooks SHALL catch violations before code review.

#### Scenario: Violation Detection Rate
- **GIVEN** violations attempted
- **WHEN** commits made
- **THEN** 95%+ caught by hooks
- **AND** not reaching code review

### Requirement: Performance Impact
Hooks SHALL not significantly slow development.

#### Scenario: Developer Satisfaction
- **GIVEN** hooks in use for 1 month
- **WHEN** developers surveyed
- **THEN** majority find acceptable
- **AND** few complaints about speed

## Edge Cases

### Requirement: Large File Handling
Hooks SHALL handle large files gracefully.

#### Scenario: Large File Skipped
- **GIVEN** 10MB binary file
- **WHEN** committed
- **THEN** checks skip appropriately
- **AND** no timeout

### Requirement: Binary File Handling
Binary files SHALL be excluded from text checks.

#### Scenario: Binary File Exempt
- **GIVEN** .png file committed
- **WHEN** emoji check runs
- **THEN** binary file skipped
- **AND** no false positive
