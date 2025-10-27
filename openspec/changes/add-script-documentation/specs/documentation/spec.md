# Script Documentation Specification

## ADDED Requirements

### Requirement: Central Documentation Structure
The system SHALL provide centralized documentation for all utility scripts.

#### Scenario: Documentation Directory Exists
- **GIVEN** repository cloned
- **WHEN** user navigates to `docs/scripts/`
- **THEN** directory contains documentation files
- **AND** README.md provides overview

#### Scenario: Category Documentation Available
- **GIVEN** scripts organized by category
- **WHEN** user opens `docs/scripts/core.md`
- **THEN** all core scripts documented
- **AND** consistent format used

### Requirement: Consistent Help Messages
All scripts SHALL provide --help flag with standardized format.

#### Scenario: Script Shows Help
- **GIVEN** any script in `bin/`
- **WHEN** user runs `script --help`
- **THEN** help message displayed
- **AND** includes: usage, options, examples, requirements

#### Scenario: Help Format Consistent
- **GIVEN** multiple scripts
- **WHEN** help messages compared
- **THEN** same structure and sections
- **AND** similar formatting

### Requirement: Interactive Help Command
The system SHALL provide interactive help for script discovery.

#### Scenario: Launch Interactive Menu
- **GIVEN** user runs `dotfiles-help`
- **WHEN** command executes
- **THEN** category menu displayed
- **AND** user can browse scripts

#### Scenario: Search by Keyword
- **GIVEN** interactive menu open
- **WHEN** user selects "Search by keyword"
- **AND** enters "sync"
- **THEN** all sync-related scripts shown

#### Scenario: Direct Script Help
- **GIVEN** user runs `dotfiles-help zsh-benchmark`
- **WHEN** command executes
- **THEN** specific script help displayed

### Requirement: Quick Reference Card
The system SHALL provide one-page quick reference.

#### Scenario: Quick Reference Accessible
- **GIVEN** user opens `docs/scripts/quick-reference.md`
- **WHEN** file viewed
- **THEN** all scripts listed in tables
- **AND** organized by category and task

#### Scenario: Task-Based Index
- **GIVEN** quick reference open
- **WHEN** user looks for "I want to sync dotfiles"
- **THEN** relevant scripts shown with examples

#### Scenario: Frequency Grouping
- **GIVEN** quick reference open
- **WHEN** user views "By Frequency" section
- **THEN** scripts grouped: Daily, Weekly, One-time

### Requirement: Auto-generated Documentation
The system SHALL auto-generate docs from script help text.

#### Scenario: Generate Documentation
- **GIVEN** user runs `generate-script-docs`
- **WHEN** command executes
- **THEN** docs/scripts/*.md files created
- **AND** content extracted from --help

#### Scenario: Documentation Up-to-Date
- **GIVEN** script help updated
- **WHEN** `generate-script-docs` runs
- **THEN** documentation reflects changes
- **AND** no manual editing needed

### Requirement: Complete Coverage
All scripts SHALL be documented.

#### Scenario: All Scripts Have Help
- **GIVEN** 50+ scripts in bin/
- **WHEN** checked for --help
- **THEN** 100% have help message

#### Scenario: All Scripts in Docs
- **GIVEN** scripts in bin/
- **WHEN** compared with docs/scripts/*.md
- **THEN** every script documented
- **AND** no missing entries

### Requirement: Documentation Content Quality
Documentation SHALL be accurate, complete, and useful.

#### Scenario: Purpose Clear
- **GIVEN** script documentation entry
- **WHEN** user reads purpose
- **THEN** understands what script does in one sentence

#### Scenario: Examples Work
- **GIVEN** documentation shows examples
- **WHEN** user copies and runs example
- **THEN** command works as documented

#### Scenario: Requirements Listed
- **GIVEN** script has dependencies
- **WHEN** user reads requirements section
- **THEN** all dependencies listed (jq, homebrew, etc.)

#### Scenario: Platform Indicated
- **GIVEN** script platform-specific
- **WHEN** user checks documentation
- **THEN** platform clearly marked (darwin/linux/all)

### Requirement: Cross-References
Documentation SHALL link related scripts.

#### Scenario: Related Scripts Listed
- **GIVEN** `zsh-benchmark` documentation
- **WHEN** user reads "Related Scripts"
- **THEN** sees `zsh-compile`, `zsh-trim-history`
- **AND** links to their documentation

#### Scenario: Workflow Connections
- **GIVEN** credential management docs
- **WHEN** user reads workflow
- **THEN** sees progression: store-api-key → get-api-key → credmatch

### Requirement: Searchability
Users SHALL be able to find scripts by keyword or task.

#### Scenario: Search in Documentation
- **GIVEN** user searches for "performance"
- **WHEN** greps docs/scripts/*.md
- **THEN** finds zsh-benchmark, zsh-compile, zsh-trim-history

#### Scenario: Task-Based Discovery
- **GIVEN** user wants to "sync dotfiles"
- **WHEN** checks "I want to..." section
- **THEN** finds syncenv and home-sync

### Requirement: README Integration
Main README SHALL link to script documentation.

#### Scenario: README Links to Docs
- **GIVEN** user opens README.md
- **WHEN** reads Scripts section
- **THEN** sees links to docs/scripts/

#### Scenario: README Shows Popular Scripts
- **GIVEN** README.md Scripts section
- **WHEN** user scans content
- **THEN** sees most-used scripts highlighted

### Requirement: Documentation Maintenance
Documentation SHALL be easy to update and maintain.

#### Scenario: Script Added
- **GIVEN** new script created
- **WHEN** developer runs `generate-script-docs`
- **THEN** new script automatically documented

#### Scenario: Script Modified
- **GIVEN** script --help updated
- **WHEN** `generate-script-docs` runs
- **THEN** documentation reflects changes
- **AND** manual sync not needed

### Requirement: Man Pages
The system SHALL optionally provide man pages for scripts.

#### Scenario: Man Page Available
- **GIVEN** man pages generated
- **WHEN** user runs `man zsh-benchmark`
- **THEN** man page displayed
- **AND** formatted properly

#### Scenario: Man Pages Installed
- **GIVEN** user runs `generate-man-pages`
- **WHEN** command completes
- **THEN** man pages in /usr/local/share/man/

## Testing Requirements

### Requirement: Documentation Completeness Test
Tests SHALL verify all scripts documented.

#### Scenario: Check All Scripts Covered
- **GIVEN** test suite runs
- **WHEN** comparing bin/ to docs/
- **THEN** all executable scripts documented
- **AND** test passes

#### Scenario: Check All Help Available
- **GIVEN** test suite runs
- **WHEN** checking --help on all scripts
- **THEN** all scripts respond
- **AND** no missing help

### Requirement: Link Validation
Tests SHALL verify cross-references work.

#### Scenario: Validate Internal Links
- **GIVEN** documentation contains links
- **WHEN** link checker runs
- **THEN** all links resolve
- **AND** no 404s

#### Scenario: Validate Script References
- **GIVEN** docs reference script names
- **WHEN** validated
- **THEN** all scripts exist
- **AND** names spelled correctly

### Requirement: Example Validation
Tests SHALL verify examples work.

#### Scenario: Test Documentation Examples
- **GIVEN** docs contain command examples
- **WHEN** examples extracted and run
- **THEN** all examples execute successfully
- **AND** no errors

## Documentation Requirements

### Requirement: Documentation Standards
Documentation SHALL follow consistent format.

#### Scenario: Section Headers Present
- **GIVEN** script documentation
- **WHEN** checked for sections
- **THEN** includes: Name, Purpose, Usage, Examples, Related, Requirements, Platform

#### Scenario: Format Consistent
- **GIVEN** multiple script docs
- **WHEN** compared
- **THEN** same markdown style
- **AND** same heading levels

### Requirement: Quality Standards
Documentation SHALL be clear and accurate.

#### Scenario: One-Line Purpose
- **GIVEN** script documentation
- **WHEN** purpose read
- **THEN** single sentence under 100 chars
- **AND** describes main function

#### Scenario: Working Examples
- **GIVEN** examples in documentation
- **WHEN** user copies example
- **THEN** command runs successfully
- **AND** produces described result

### Requirement: Update Documentation
Developer documentation SHALL explain maintenance.

#### Scenario: Adding New Script
- **GIVEN** developer adds script
- **WHEN** reads contribution guide
- **THEN** knows to add --help
- **AND** knows to run generate-script-docs

#### Scenario: Updating Script
- **GIVEN** developer modifies script
- **WHEN** changes --help text
- **THEN** knows docs auto-update
- **AND** regenerates docs

## Success Metrics

### Requirement: Completion Metrics
Documentation SHALL be comprehensive.

#### Scenario: 100% Coverage
- **GIVEN** all scripts in bin/
- **WHEN** documentation checked
- **THEN** 100% documented
- **AND** no gaps

#### Scenario: Help Availability
- **GIVEN** 50+ scripts
- **WHEN** --help tested
- **THEN** 100% respond
- **AND** consistent format

### Requirement: Usage Metrics
Documentation SHALL be used.

#### Scenario: Reduced Support Questions
- **GIVEN** documentation deployed
- **WHEN** measured over 1 month
- **THEN** "how do I" questions reduced 50%+

#### Scenario: Script Discovery
- **GIVEN** users surveyed
- **WHEN** asked about script discovery
- **THEN** majority find via docs
- **AND** not by browsing code

### Requirement: Quality Metrics
Documentation SHALL be high quality.

#### Scenario: User Satisfaction
- **GIVEN** users surveyed
- **WHEN** asked about docs
- **THEN** 80%+ find helpful
- **AND** examples work

#### Scenario: Zero Broken Links
- **GIVEN** link checker runs
- **WHEN** all docs validated
- **THEN** zero broken links
- **AND** all references valid

## Edge Cases

### Requirement: Binary Scripts
Non-shell scripts SHALL be documented.

#### Scenario: Python Script Documented
- **GIVEN** Python script with uv header
- **WHEN** documentation generated
- **THEN** script included
- **AND** Python requirements noted

### Requirement: Deprecated Scripts
Deprecated scripts SHALL be marked.

#### Scenario: Deprecated Script
- **GIVEN** script being phased out
- **WHEN** documentation viewed
- **THEN** marked as deprecated
- **AND** alternative suggested

### Requirement: Platform-Specific Scripts
Platform requirements SHALL be clear.

#### Scenario: macOS-Only Script
- **GIVEN** script in bin/macos/
- **WHEN** documentation viewed
- **THEN** Platform: darwin shown
- **AND** macOS requirement clear
