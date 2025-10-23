# Documentation Cleanup Specification Delta

## REMOVED Requirements

### Requirement: Stow Package Management Documentation
**Reason:** Project migrated from Stow to Makefile-based installation in commit f54bc7a (October 2024). Stow is no longer used.

**Migration:** Users should use Makefile targets instead:
- `make install` - Install all dotfiles
- `make install-zsh` - Install ZSH configuration only
- `make install-git` - Install Git configuration only
- `make install-scripts` - Install scripts to ~/.local/bin

**Affected Documentation:**
- README.md sections on Stow package management
- docs/guides/README.md Stow references
- docs/guides/README.old.md (entire file)

## MODIFIED Requirements

### Requirement: Installation Instructions Must Reference Existing Tools
Documentation SHALL only reference tools and scripts that currently exist in the codebase.

**Before:**
```bash
# Install prerequisites
brew install stow

# Install all packages
./stow-install.sh

# Install specific packages
./install.sh --packages zsh git
```

**After:**
```bash
# Install prerequisites (no Stow needed)
xcode-select --install
brew install git

# Install all dotfiles
make install

# Install specific components
make install-zsh
make install-git
```

#### Scenario: User follows installation instructions
- **WHEN** user reads installation section in README.md
- **THEN** all referenced scripts SHALL exist in the repository
- **AND** all commands SHALL execute successfully
- **AND** no Stow installation SHALL be required

#### Scenario: User tries documented commands
- **WHEN** user copies command from documentation
- **THEN** the command SHALL work without modification
- **AND** no "command not found" or "file not found" errors

### Requirement: Directory Structure Documentation Must Be Accurate
Documentation SHALL reflect the actual directory structure of the repository.

**Before:**
```
~/.config/
├── stow-packages/
│   ├── zsh/
│   │   └── .config/zsh/
│   ├── git/
│   │   └── .config/git/
│   └── bin/
│       └── .local/bin/
```

**After:**
```
~/.config/dotfiles/
├── config/
│   ├── zsh/
│   ├── git/
│   └── homebrew/
├── scripts/
│   ├── core/
│   ├── git/
│   └── credentials/
└── docs/
```

#### Scenario: User navigates codebase following documentation
- **WHEN** user reads directory structure in documentation
- **THEN** all paths SHALL match actual repository structure
- **AND** no "stow-packages" directory references
- **AND** symlink destinations SHALL be accurate

#### Scenario: User adds new configuration
- **WHEN** user reads "Adding New Configurations" section
- **THEN** instructions SHALL describe current system (config/ and scripts/)
- **AND** no Stow commands SHALL be referenced

### Requirement: Installation Prerequisites Must Be Minimal and Accurate
Documentation SHALL list only required prerequisites, not obsolete tools.

#### Scenario: User checks prerequisites
- **WHEN** user reads prerequisites section
- **THEN** Stow SHALL NOT be listed
- **AND** only actually required tools SHALL be listed
- **AND** all listed tools SHALL be used in installation process

#### Scenario: User installs prerequisites
- **WHEN** user installs all documented prerequisites
- **THEN** installation SHALL succeed
- **AND** no missing dependencies errors

## ADDED Requirements

### Requirement: Historical References Must Be Clearly Marked
Documentation SHALL clearly mark any historical system references as obsolete when mentioned.

#### Scenario: Historical reference in documentation
- **WHEN** documentation mentions old Stow system for historical context
- **THEN** it SHALL be clearly marked as historical/obsolete
- **AND** it SHALL NOT be in installation instructions
- **AND** it SHALL include migration note to current system

Example acceptable reference:
```markdown
## Migration from Old Setup (October 2024)

The project previously used Stow for package management but has migrated to a
Makefile-based system. If you have an old installation, run:

\`\`\`bash
make unlink  # Remove old symlinks
make install # Reinstall with new system
\`\`\`
```

## VALIDATION

### Pre-Implementation Checks
```bash
# Count current Stow references in markdown files
rg -i "stow" --type md | wc -l

# Should show 50+ references
```

### Post-Implementation Checks
```bash
# Verify minimal Stow references remain
rg -i "stow" --type md

# Should show <5 references (only historical/git comments)

# Verify specific removals
rg "stow-install.sh"        # Should return nothing
rg "brew install stow"      # Should return nothing
rg "stow-packages/"         # Should return nothing

# Verify file deletion
ls docs/guides/README.old.md  # Should fail (file not found)
```

### Acceptance Criteria
- [ ] Zero references to `stow-install.sh` in documentation
- [ ] Zero references to `brew install stow` in installation instructions
- [ ] Zero references to `stow-packages/` paths in current documentation
- [ ] `docs/guides/README.old.md` file deleted
- [ ] All installation commands use Makefile targets
- [ ] Directory structure diagrams reflect current layout
- [ ] All documented commands tested and work
