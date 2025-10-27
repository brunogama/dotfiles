# Root Installation Script

## Why
The repository has automated symlink creation (via link-dotfiles) but no unified entry point for the complete installation process. Users must manually:
1. Install Homebrew
2. Install dependencies (jq, etc.)
3. Run link-dotfiles
4. Set up shell configurations
5. Install packages from Brewfile

This creates a poor first-time user experience and increases setup friction.

## What Changes
- Create `install` script at repository root as the main entry point
- Orchestrate the complete dotfiles installation process
- Make it idempotent (safe to run multiple times)
- Provide clear progress reporting
- Support both interactive and non-interactive modes
- Handle platform-specific setup (macOS vs Linux)
- Validate prerequisites and offer to install missing dependencies

## Impact
- New file: `install` at repository root
- Dependencies: Uses existing `bin/core/link-dotfiles` script (from other proposal)
- Breaking: None - this is purely additive
- Benefits:
  - One-command installation: `./install`
  - Consistent setup across machines
  - Reduces onboarding time
  - Self-documenting installation process
  - Safe to re-run for updates

## Design Decisions

### Location: Repository Root
- **At root** (not in bin/) - This is the entry point, should be immediately visible
- Follows Unix convention (like ./configure, ./install.sh)
- Makes README instructions simpler: `git clone ... && cd ... && ./install`

### Idempotency Strategy
- Check before acting: detect what's already installed/configured
- Skip completed steps with "already installed" message
- Only perform missing setup
- Exit code 0 even if everything is already done

### Mode Selection
- **Default: Interactive** - Prompts for confirmations, explains what it will do
- **Non-interactive: `--yes` flag** - For CI/automated setups, no prompts
- **Dry-run: `--dry-run` flag** - Preview what would be done

### Dependency Installation
- **Homebrew (macOS only)**: Offer to install if missing
- **jq**: Required for link-dotfiles, install via platform package manager
- **Others**: Check and report, let user decide

## Installation Phases

The script SHALL execute these phases in order:

### Phase 1: Pre-flight Checks
1. Detect platform (darwin/linux)
2. Check if running in dotfiles repository
3. Verify git is available

### Phase 2: Package Manager Setup
1. Check for Homebrew (macOS only)
2. Offer to install Homebrew if missing
3. Verify brew is working

### Phase 3: Dependency Installation
1. Check for required dependencies (jq)
2. Install missing dependencies via Homebrew (macOS) or apt/yum (Linux)
3. Verify installations

### Phase 4: Homebrew Bundle
1. Check if Brewfile exists
2. Run `brew bundle install --file=packages/homebrew/Brewfile` (macOS only)
3. Report package installation results

### Phase 5: Symlink Creation
1. Call `bin/core/link-dotfiles --apply`
2. Pass through --yes flag if provided
3. Report linking results

### Phase 6: Shell Configuration
1. Detect current shell (bash/zsh/fish)
2. Check if shell RC files are linked
3. Remind user to restart shell or source config

### Phase 7: Summary
1. Report what was installed/configured
2. Show any manual steps needed
3. Provide next steps

## Structure
```bash
./install [OPTIONS]

Options:
  --dry-run          Preview what would be done (no changes)
  --yes              Non-interactive mode, assume yes to all prompts
  --skip-brew        Skip Homebrew installation/bundle
  --skip-packages    Skip package installation
  --skip-links       Skip symlink creation
  --verbose          Show detailed output
  --help             Show help message

Exit Codes:
  0: Success (or already installed)
  1: General error
  2: Prerequisites not met
  3: User cancelled
```

## Example Usage
```bash
# Interactive installation (default)
./install

# Non-interactive for automation
./install --yes

# Preview without changes
./install --dry-run

# Skip package installation, just link files
./install --skip-packages

# Verbose output for troubleshooting
./install --verbose
```

## Sample Output
```
=================================================
 Dotfiles Installation
=================================================

Platform: macOS (darwin)
Repository: /Users/bruno/.config-fixing-dot-files-bugs

Phase 1: Pre-flight Checks
  [OK] Git is installed
  [OK] Running in dotfiles repository
  [OK] Platform detected: darwin

Phase 2: Package Manager Setup
  [OK] Homebrew is already installed
  [OK] Homebrew is up to date

Phase 3: Dependencies
  [OK] jq is already installed (v1.7.1)

Phase 4: Homebrew Bundle
  → Running brew bundle...
  Installing dependencies from packages/homebrew/Brewfile
  [OK] Installed 5 packages, 3 already present

Phase 5: Symlink Creation
  → Creating symlinks from LinkingManifest.json...
  [OK] Created 23 symlinks
  [OK] Skipped 4 (already linked)

Phase 6: Shell Configuration
  ℹ Current shell: zsh
  [OK] Shell RC file is linked: ~/.zshrc

=================================================
 Installation Complete!
=================================================

Next Steps:
  1. Restart your terminal or run: exec zsh
  2. Check environment: work-mode status
  3. Verify git config: git config --list

For help: ./install --help
```
