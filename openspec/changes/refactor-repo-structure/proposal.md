# Repository Structure Simplification

## Why
The current dotfiles repository has a complex structure with separate `config/` and `scripts/` directories, hidden `.ai_docs/` folder, and inconsistent organization patterns. This makes it harder to understand, navigate, and maintain the codebase.

## What Changes
- **BREAKING**: Consolidate `config/` and `scripts/` into a unified structure
- **Constitutional Rule**: All directories MUST be lowercase (enforced in MINDSET.MD)
- Introduce `LinkingManifest.json` for declarative symlink management (replacing manual linking logic)
- Reorganize scripts into logical `bin/` subdirectories (core, credentials, ide, ios, macos, git)
- Move configuration files to top-level category directories (git, packages, zsh)
- Move all git-related files (.gitignore, .gitattributes, .gitmodules) to git/ directory
- Move Brewfile from repository root to packages/homebrew/ (symlinked back for convenience)
- Rename and relocate `.ai_docs/` to `ai_docs/knowledge_base/ide/` for better discoverability
- Remove hidden directory pattern for better visibility and searchability

## Impact
- Affected areas: Entire repository structure
- Migration required: All symlinks need recreation using new manifest
- Breaking change: All existing symlink paths will change
- Documentation: Setup instructions need complete rewrite
- Scripts: All script paths and references need updating

## Benefits
- Single source of truth for file linking via manifest
- Clearer separation of concerns (binaries vs configs vs docs)
- Easier onboarding - obvious where things live
- Better IDE/search integration with non-hidden directories
- Simpler mental model for contributors

## Structure
```
./
├── LinkingManifest.json    # Declarative symlink mappings
├── bin/                    # Executable scripts
│   ├── core/              # Core utilities
│   ├── credentials/       # Credential management
│   ├── git/              # Git scripts and hooks
│   ├── ide/              # IDE tooling
│   ├── ios/              # iOS development tools
│   └── macos/            # macOS-specific scripts
├── git/                    # Git configuration (no scripts)
│   ├── .gitconfig
│   ├── .gitignore         # Symlinked to root
│   ├── .gitmodules        # Symlinked to root
│   ├── ignore
│   └── aliases
├── packages/              # Package managers
│   ├── homebrew/
│   │   └── Brewfile       # Symlinked to ~/Brewfile
│   └── macos/
├── zsh/                    # Shell configuration
│   ├── .zshrc
│   ├── .zshprofile
│   └── .zhistory
└── ai_docs/               # AI assistant documentation
    └── knowledge_base/
        └── ide/           # IDE-specific docs
            ├── cursor/
            ├── claude-cdde/
            ├── droid/
            ├── kiro/
            └── visualstudiocode/
```
