# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- CHANGELOG.md to track user-facing changes
- Pre-commit hooks for code quality and CHANGELOG enforcement
- CHANGELOG validation script to ensure documentation of changes
- OpenSpec proposal for home-sync fixes (fix-home-sync-issues)
  - Git repository auto-detection for flexible dotfiles location
  - Script auto-installation on shell startup
  - Git repository validation before operations
- Auto-install scripts on shell startup (no more manual `make install-scripts`)
  - Timestamp-based detection of script changes
  - Automatic reinstall when scripts are added or modified
  - Works in both personal and work environments
- `make check-installation` command to validate dotfiles setup
  - Checks all critical components (scripts, ZSH, Git, Prezto)
  - Color-coded status with actionable fix commands
  - Overall installation health summary
- OpenSpec proposal for syncenv command (add-syncenv-command)
  - Python-based environment sync with marvelous DX
  - Smart git strategy: rebase with auto-fallback to merge
  - Environment-aware syncing (work vs personal)
  - Beautiful CLI with rich output, spinners, and progress
  - Comprehensive error handling with actionable guidance

### Fixed
- Makefile color escaping - ANSI colors now render correctly in terminal output
- home-sync missing dependency error (store-api-key) - automatically resolved on shell startup
- home-sync git repository detection - now auto-detects correct location
- home-sync sync.sh dependencies - replaced with direct git commands

## [1.0.0] - 2025-01-23

### Added
- OpenSpec integration for spec-driven development
  - Slash commands for Claude Code (`/proposal`, `/apply`, `/archive`)
  - GitHub prompts for proposal workflow
- Comprehensive onboarding documentation (ONBOARDING.md, 3,341 lines)
  - Complete tech stack documentation
  - Architecture decisions and design patterns
  - 50+ script catalog with descriptions
  - Common tasks and troubleshooting guides
- Quick start guide (QUICKSTART.md, 253 lines)
  - One-line installation command
  - Quick commands cheat sheet
- README improvements roadmap (README_IMPROVEMENTS.md, 725 lines)
  - Critical issues identification
  - Section-by-section improvement suggestions
  - Priority matrix for changes
- Agent documentation (AGENTS.md, CLAUDE.md)
  - Project overview for AI assistants
  - Code quality rules (shellcheck, PEP 8)
  - OpenSpec workflow integration
- Environment management system
  - `work-mode` command to switch between work/personal environments
  - Visual prompt indicators (WORK in orange, HOME:PERSONAL in blue)
  - Environment-specific configuration loading
- Background synchronization service
  - `home-sync` for manual sync operations
  - `home-sync-service` daemon for automated sync
- Secure credential management
  - `credfile` for encrypted file storage
  - `credmatch` for credential search/decrypt

### Changed
- Migrated from Stow to Makefile-based installation system
- Removed all Stow references from documentation
- Replaced docs/guides/README.md with navigation page
- Updated installation instructions to use `make install` commands
- Simplified "Why This Structure?" section in README

### Removed
- Obsolete MIGRATION_GUIDE.md (191 lines)
- Obsolete REORGANIZATION_SUMMARY.md (204 lines)
- Obsolete docs/guides/README.old.md (469 lines, Stow-based)
- All references to `stow-install.sh` (script removed in earlier update)
- All references to `brew install stow` (no longer needed)
- All references to `stow-packages/` directory structure

### Fixed
- Git repository initialization when .git file points to non-existent worktree
- Documentation accuracy (removed 900+ lines of outdated Stow instructions)

## [0.1.0] - 2024-10-23

### Added
- Initial dotfiles structure with config/, scripts/, docs/ organization
- ZSH configuration with Prezto and Powerlevel10k
- Git configuration with conventional commits workflow
- 50+ utility scripts organized by category
- Homebrew package management with Brewfile
- macOS preferences management scripts
- Comprehensive man pages for core commands

[unreleased]: https://github.com/brunogama/dotfiles/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/brunogama/dotfiles/compare/v0.1.0...v1.0.0
[0.1.0]: https://github.com/brunogama/dotfiles/releases/tag/v0.1.0
