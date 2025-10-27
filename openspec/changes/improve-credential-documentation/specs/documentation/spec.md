# Credential Documentation Specification

## ADDED Requirements

### Requirement: Comprehensive Credential Guide
The system SHALL provide comprehensive documentation for all credential management tools.

#### Scenario: Guide Exists and Complete
- **GIVEN** user needs to understand credential tools
- **WHEN** opens `docs/guides/CREDENTIAL_MANAGEMENT.md`
- **THEN** sees complete guide covering all tools
- **AND** includes architecture overview
- **AND** includes decision tree for tool selection

#### Scenario: Architecture Clearly Explained
- **GIVEN** guide open
- **WHEN** reading architecture section
- **THEN** understands difference between store-api-key, credmatch, credfile
- **AND** sees diagram of storage locations
- **AND** understands encryption mechanisms

### Requirement: Enhanced Script Help
All credential scripts SHALL provide comprehensive help with examples.

#### Scenario: store-api-key Help Shows Examples
- **GIVEN** user runs `store-api-key --help`
- **WHEN** reading output
- **THEN** sees usage syntax
- **AND** sees security warnings
- **AND** sees all three input modes (interactive, stdin, file)
- **AND** sees complete examples for each mode

#### Scenario: credmatch Help Shows Workflows
- **GIVEN** user runs `credmatch --help`
- **WHEN** reading output
- **THEN** sees architecture explanation
- **AND** sees master password options
- **AND** sees store/fetch/list examples
- **AND** sees multi-machine sync examples

#### Scenario: credfile Help Shows Use Cases
- **GIVEN** user runs `credfile --help`
- **WHEN** reading output
- **THEN** sees file storage explanation
- **AND** sees put/get/list examples
- **AND** sees SSH key and certificate examples
- **AND** sees backup/restore procedures

### Requirement: Decision Guide
Documentation SHALL help users choose the correct tool.

#### Scenario: Decision Tree Available
- **GIVEN** user has credential to store
- **WHEN** consulting documentation
- **THEN** sees decision tree
- **AND** tree asks about use case
- **AND** tree recommends appropriate tool

#### Scenario: Use Case Table Provided
- **GIVEN** user reading guide
- **WHEN** viewing tool comparison
- **THEN** sees table with use cases
- **AND** columns: use case, tool, example
- **AND** clear recommendation for each scenario

### Requirement: Complete Workflow Examples
Documentation SHALL show end-to-end workflows.

#### Scenario: Simple API Key Workflow
- **GIVEN** guide section on simple keys
- **WHEN** following example
- **THEN** shows store-api-key command
- **AND** shows retrieval with get-api-key
- **AND** shows usage in script
- **AND** example works when tested

#### Scenario: Multi-Environment AWS Workflow
- **GIVEN** guide section on credmatch
- **WHEN** reading AWS example
- **THEN** shows structured naming (aws.dev.key, aws.prod.key)
- **AND** shows environment switching script
- **AND** shows retrieval in automation
- **AND** example works when tested

#### Scenario: SSH Key Management Workflow
- **GIVEN** guide section on credfile
- **WHEN** reading SSH example
- **THEN** shows storing private key
- **AND** shows retrieving to temp location
- **AND** shows cleanup after use
- **AND** shows permission handling
- **AND** example works when tested

### Requirement: Security Guidance
Documentation SHALL provide security best practices.

#### Scenario: Master Password Guidelines
- **GIVEN** guide security section
- **WHEN** reading password requirements
- **THEN** sees minimum length recommendation
- **AND** sees complexity requirements
- **AND** sees good and bad examples
- **AND** sees rotation frequency

#### Scenario: Secure Input Methods Explained
- **GIVEN** guide security section
- **WHEN** reading input methods
- **THEN** sees interactive mode marked as secure
- **AND** sees positional arguments marked as insecure
- **AND** sees explanation of shell history exposure
- **AND** sees clear-secret-history tool referenced

### Requirement: Multi-Machine Setup
Documentation SHALL explain cross-machine synchronization.

#### Scenario: credmatch Sync Explained
- **GIVEN** guide multi-machine section
- **WHEN** reading credmatch sync
- **THEN** sees encrypted file location
- **AND** sees sync methods (Dropbox, rsync, Git)
- **AND** sees master password setup on new machine
- **AND** example works when tested

#### Scenario: credfile Sync Explained
- **GIVEN** guide multi-machine section
- **WHEN** reading credfile sync
- **THEN** sees ~/.credfile/ directory sync
- **AND** sees backup command examples
- **AND** sees restore procedures
- **AND** example works when tested

### Requirement: Troubleshooting Procedures
Documentation SHALL provide solutions for common problems.

#### Scenario: Master Password Issues
- **GIVEN** troubleshooting section
- **WHEN** searching for password problems
- **THEN** finds "master password incorrect" error
- **AND** sees verification steps
- **AND** sees reset procedure
- **AND** solution works

#### Scenario: Keychain Access Issues
- **GIVEN** troubleshooting section
- **WHEN** searching for keychain problems
- **THEN** finds "keychain locked" error
- **AND** sees unlock command
- **AND** sees Touch ID configuration
- **AND** solution works

#### Scenario: Permission Errors
- **GIVEN** troubleshooting section
- **WHEN** searching for permission problems
- **THEN** finds "permission denied" error
- **AND** sees chmod commands
- **AND** sees correct permission values (600, 700)
- **AND** solution works

### Requirement: Integration with dotfiles-help
Interactive help SHALL include credential examples.

#### Scenario: Credential Section in Menu
- **GIVEN** user runs `dotfiles-help`
- **WHEN** selecting credential category
- **THEN** sees three tool explanations
- **AND** sees quick examples for each
- **AND** sees link to full guide

#### Scenario: Direct Credential Help
- **GIVEN** user runs `dotfiles-help store-api-key`
- **WHEN** viewing output
- **THEN** shows store-api-key help
- **AND** includes examples
- **AND** includes security warnings

### Requirement: Quick Reference Updates
Quick reference SHALL include credential decision guide.

#### Scenario: Credential Table in Quick Reference
- **GIVEN** docs/scripts/quick-reference.md open
- **WHEN** viewing credential section
- **THEN** sees decision table
- **AND** columns: use case, tool, example
- **AND** all three tools represented

#### Scenario: Quick Workflows Shown
- **GIVEN** quick reference credential section
- **WHEN** viewing workflows
- **THEN** sees one-liner for each tool
- **AND** examples are copy-paste ready
- **AND** examples work when tested

### Requirement: Link Integration
Documentation SHALL be discoverable from multiple entry points.

#### Scenario: Link from README
- **GIVEN** README.md open
- **WHEN** viewing credential section
- **THEN** sees link to CREDENTIAL_MANAGEMENT.md
- **AND** link works (not broken)

#### Scenario: Link from ONBOARDING
- **GIVEN** ONBOARDING.md open
- **WHEN** viewing credential section
- **THEN** sees link to CREDENTIAL_MANAGEMENT.md
- **AND** explains credential architecture
- **AND** link works (not broken)

#### Scenario: Link from Script Help
- **GIVEN** any credential script --help
- **WHEN** viewing "SEE ALSO" section
- **THEN** references docs/guides/CREDENTIAL_MANAGEMENT.md
- **AND** references related tools

### Requirement: Examples Are Tested
All documentation examples SHALL work when executed.

#### Scenario: Example Testing
- **GIVEN** example command in documentation
- **WHEN** copied and executed
- **THEN** command runs successfully
- **AND** produces described output
- **AND** no errors occur

#### Scenario: Example Security
- **GIVEN** example in documentation
- **WHEN** reviewing command
- **THEN** uses secure input method
- **AND** does not expose secrets
- **AND** follows best practices

## Testing Requirements

### Requirement: Documentation Completeness
Tests SHALL verify all tools documented.

#### Scenario: All Scripts Covered
- **GIVEN** credential scripts in bin/credentials/
- **WHEN** checking documentation
- **THEN** each script has enhanced --help
- **AND** each script in guide
- **AND** no missing coverage

### Requirement: Link Validation
Tests SHALL verify all links work.

#### Scenario: Internal Links
- **GIVEN** documentation with internal links
- **WHEN** link checker runs
- **THEN** all links resolve
- **AND** no 404 errors

#### Scenario: Cross-References
- **GIVEN** script help with references
- **WHEN** checking references
- **THEN** all referenced docs exist
- **AND** all referenced tools exist

### Requirement: Example Validation
Tests SHALL verify examples work.

#### Scenario: Command Examples
- **GIVEN** example commands in docs
- **WHEN** extracted and tested
- **THEN** all commands execute successfully
- **AND** produce expected output

## Documentation Standards

### Requirement: Consistent Format
Documentation SHALL follow consistent structure.

#### Scenario: Help Text Structure
- **GIVEN** any credential script help
- **WHEN** viewing sections
- **THEN** includes: USAGE, EXAMPLES, SECURITY, RELATED, SEE ALSO
- **AND** sections in consistent order

#### Scenario: Guide Structure
- **GIVEN** CREDENTIAL_MANAGEMENT.md
- **WHEN** viewing structure
- **THEN** includes: Overview, Quick Start, Tools, Workflows, Security, Troubleshooting
- **AND** consistent heading levels

### Requirement: Security Emphasis
Security information SHALL be prominent.

#### Scenario: Security Warnings Visible
- **GIVEN** script help text
- **WHEN** user reads help
- **THEN** security warnings appear early
- **AND** marked as [WARNING] or [NO]
- **AND** secure alternatives shown

#### Scenario: Best Practices Highlighted
- **GIVEN** guide security section
- **WHEN** reading practices
- **THEN** uses [YES] for good examples
- **AND** uses [NO] for bad examples
- **AND** explains why

## Success Metrics

### Requirement: User Satisfaction
Documentation SHALL improve user experience.

#### Scenario: Time to First Success
- **GIVEN** new user with credential to store
- **WHEN** following documentation
- **THEN** successfully stores credential in < 5 minutes
- **AND** understands which tool to use

#### Scenario: Error Reduction
- **GIVEN** users before documentation
- **WHEN** measuring credential storage errors
- **THEN** 50%+ reduction after documentation
- **AND** fewer support questions

### Requirement: Documentation Metrics
Documentation SHALL be comprehensive.

#### Scenario: Coverage Completeness
- **GIVEN** all credential tools
- **WHEN** checking documentation
- **THEN** 100% have enhanced help
- **AND** 100% in comprehensive guide
- **AND** all use cases covered

#### Scenario: Example Count
- **GIVEN** comprehensive guide
- **WHEN** counting examples
- **THEN** at least 20 complete examples
- **AND** covering all three tools
- **AND** all examples tested

## Edge Cases

### Requirement: Platform Differences
Documentation SHALL note platform-specific behavior.

#### Scenario: macOS vs Linux
- **GIVEN** tool documentation
- **WHEN** platform-specific behavior exists
- **THEN** clearly marked as "macOS only" or "linux only"
- **AND** alternative shown for other platform

### Requirement: Legacy Support
Documentation SHALL handle deprecated features.

#### Scenario: Deprecated Positional Args
- **GIVEN** store-api-key documentation
- **WHEN** mentioning positional arguments
- **THEN** marked as deprecated
- **AND** warns about security issue
- **AND** shows secure alternative
