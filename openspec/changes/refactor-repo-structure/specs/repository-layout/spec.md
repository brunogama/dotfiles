# Repository Layout Specification

## ADDED Requirements

### Requirement: Root Directory Structure
The repository SHALL organize content into top-level lowercase category directories (bin, git, packages, zsh, ai_docs) rather than using config/ and scripts/ subdirectories.

**Constitutional Rule**: All directories MUST be lowercase.

#### Scenario: User navigates repository
- **WHEN** a user opens the repository root
- **THEN** they see immediately recognizable category folders (bin, git, packages, zsh, ai_docs)
- **AND** no hidden directories except standard .git, .github

#### Scenario: IDE search and navigation
- **WHEN** user searches for files in their IDE
- **THEN** results include ai_docs/ content without requiring hidden file viewing
- **AND** path names clearly indicate file purpose

### Requirement: LinkingManifest.json
The repository SHALL include a LinkingManifest.json file at the root that declaratively maps source files/directories to their target symlink locations.

#### Scenario: User installs dotfiles
- **WHEN** installation script reads LinkingManifest.json
- **THEN** all specified symlinks are created at their target locations
- **AND** manifest supports conditional rules (e.g., platform-specific)

#### Scenario: User adds new dotfile
- **WHEN** user adds a new configuration file to the repository
- **THEN** they add a single entry to LinkingManifest.json
- **AND** no script modifications are required

### Requirement: bin Directory Organization
The repository SHALL organize executable scripts in bin/ with subdirectories core, credentials, git, ide, ios, and macos.

#### Scenario: User looks for credential script
- **WHEN** user needs a credential management script
- **THEN** they navigate to bin/credentials/
- **AND** find all credential-related executables together

#### Scenario: User looks for iOS tooling
- **WHEN** user needs iOS development scripts
- **THEN** they navigate to bin/ios/
- **AND** find all iOS-specific tools in one place

#### Scenario: User looks for git scripts
- **WHEN** user needs git hooks or git utility scripts
- **THEN** they navigate to bin/git/
- **AND** find all git-related executables (not configuration files)

### Requirement: Configuration Directory Separation
The repository SHALL separate git configuration (git/), package manager configs (packages/), and shell configs (zsh/) into distinct top-level directories. Git scripts SHALL be in bin/git/, not git/.

All git-related configuration files (including .gitignore, .gitattributes, .gitmodules) SHALL be stored in git/ directory, not at repository root.

All package manager configuration files SHALL be stored in their respective packages/ subdirectories, not at repository root. Brewfile SHALL be in packages/homebrew/.

#### Scenario: User modifies git configuration
- **WHEN** user wants to update git settings
- **THEN** they navigate to git/ directory
- **AND** find only git configuration files (.gitconfig, .gitignore, .gitattributes, .gitmodules, ignore, aliases)
- **AND** no executable scripts (scripts are in bin/git/)

#### Scenario: User looks for gitignore patterns
- **WHEN** user wants to update .gitignore
- **THEN** they find it in git/.gitignore (not at repository root)
- **AND** LinkingManifest.json creates symlink from git/.gitignore → .gitignore at root

#### Scenario: User updates Homebrew setup
- **WHEN** user wants to modify Homebrew configuration
- **THEN** they navigate to packages/homebrew/
- **AND** find Brewfile and all Homebrew-related files

#### Scenario: User looks for Brewfile
- **WHEN** user wants to update Brewfile
- **THEN** they find it in packages/homebrew/Brewfile (not at repository root)
- **AND** LinkingManifest.json creates symlink from packages/homebrew/Brewfile → ~/Brewfile

### Requirement: AI Documentation Visibility
The repository SHALL store AI assistant documentation in ai_docs/knowledge_base/ide/ (not hidden) with subdirectories per IDE tool.

#### Scenario: User searches for Claude documentation
- **WHEN** user searches repository for "claude"
- **THEN** search results include ai_docs/knowledge_base/ide/claude-cdde/ files
- **AND** files are not excluded by default .gitignore patterns

#### Scenario: User adds new IDE documentation
- **WHEN** user adds documentation for a new IDE
- **THEN** they create a subdirectory under ai_docs/knowledge_base/ide/
- **AND** structure matches existing IDE documentation patterns

## REMOVED Requirements

### Requirement: Config Directory Structure
**Reason**: Consolidating into semantic top-level directories for better clarity
**Migration**: Move config/git → git/, config/homebrew → packages/homebrew/, config/zsh → zsh/

### Requirement: Scripts Directory Structure
**Reason**: Renaming to "Bin" and reorganizing for clarity
**Migration**: Move scripts/core → bin/core/, scripts/credentials → bin/credentials/, etc.

### Requirement: Hidden AI Documentation Directory
**Reason**: Hidden directories reduce discoverability and complicate IDE workflows
**Migration**: Move .ai_docs/ → ai_docs/knowledge_base/ide/
