# Manifest-Driven Symlink Automation

## Why
The repository now has a declarative LinkingManifest.json but no automation to actually create the symlinks. Users must manually create symlinks based on the manifest, which defeats the purpose of having a declarative configuration. This is error-prone and makes installation/updates tedious.

## What Changes
- Create `bin/core/link-dotfiles` script to parse LinkingManifest.json and create symlinks automatically
- Support all manifest features:
  - Different link types (file, directory, directory-contents)
  - Platform-specific links (darwin, linux, all)
  - Optional links (skip if source doesn't exist)
  - Executable permissions
  - Tilde expansion for home directory
- Provide safe operations:
  - Dry-run mode to preview changes
  - Backup existing files before overwriting
  - Interactive confirmation for destructive operations
  - Idempotent (safe to run multiple times)
- Clear reporting of actions taken

## Impact
- Affected specs: New capability - dotfiles-installation
- Affected code: New script `bin/core/link-dotfiles`
- Dependencies: `jq` for JSON parsing (already available via Homebrew)
- Benefits:
  - Automated installation process
  - Consistent symlink management
  - Easy to update when manifest changes
  - Platform-aware linking
  - Reduces manual errors

## Non-Goals
- This script does NOT handle:
  - Installing Homebrew packages (use `brew bundle` separately)
  - Installing system dependencies
  - Setting up shell configurations beyond linking
  - Git repository initialization

## Design Decisions

### Language Choice
- **Shell script (bash)** - Keeps dependencies minimal, aligns with other scripts
- Alternative considered: Python with `uv` - Rejected for simplicity; JSON parsing with `jq` is sufficient

### JSON Parsing
- **Use `jq`** - Already in Brewfile, powerful JSON query language
- Alternative considered: Python json module - Rejected to avoid Python dependency

### Safety Features
- Backup files to `~/.dotfiles-backup-<timestamp>/` before overwriting
- Dry-run mode as default behavior (require `--apply` flag)
- Interactive prompts for destructive operations (can be bypassed with `--yes`)

## Structure
```
bin/core/link-dotfiles    # Main linking script
├── Usage: link-dotfiles [OPTIONS]
├── Options:
│   --dry-run          Preview changes without applying (default)
│   --apply            Actually create symlinks
│   --force            Overwrite existing files/symlinks
│   --yes              Skip confirmation prompts
│   --verbose          Show detailed output
└── Exit codes:
    0: Success
    1: General error
    2: Manifest not found or invalid
    3: User cancelled operation
```

## Example Usage
```bash
# Preview what would be linked
./bin/core/link-dotfiles

# Actually create links (with confirmation)
./bin/core/link-dotfiles --apply

# Force overwrite and skip prompts
./bin/core/link-dotfiles --apply --force --yes

# Verbose output for debugging
./bin/core/link-dotfiles --apply --verbose
```
