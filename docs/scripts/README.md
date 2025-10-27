# Scripts Documentation

Complete documentation for all dotfiles scripts.

## Quick Start

```bash
# Interactive help menu
dotfiles-help

# Help for specific script
dotfiles-help zsh-benchmark

# Search for scripts
dotfiles-help --search sync

# Quick reference guide
cat docs/scripts/quick-reference.md
```

## Categories

- **[Core Utilities](core.md)** - General-purpose tools (27 scripts)
- **[Credential Management](credentials.md)** - Secure secret storage (8 scripts)
- **[Git Utilities](git.md)** - Git workflow enhancements (23 scripts)
- **[macOS Tools](macos.md)** - macOS-specific utilities (3 scripts)
- **[Quick Reference](quick-reference.md)** - One-page cheat sheet

## Most Used Scripts

| Script | Purpose | Category |
|--------|---------|----------|
| `work-mode` | Switch work/personal environments | Core |
| `syncenv` | Sync dotfiles with smart git strategy | Core |
| `store-api-key` | Store credentials securely | Credentials |
| `get-api-key` | Retrieve credentials | Credentials |
| `zsh-benchmark` | Measure shell startup performance | Core |
| `conventional-commit` | Guided conventional commits | Git |
| `link-dotfiles` | Apply symlinks from manifest | Core |

## By Task

**Syncing dotfiles:**
- `syncenv` - Smart git-based sync (recommended)
- `home-sync` - Full environment sync

**Managing credentials:**
- `store-api-key` - Store secrets (interactive, secure)
- `get-api-key` - Retrieve secrets
- `credmatch` - Search/manage all credentials
- `clear-secret-history` - Remove exposed secrets

**Performance:**
- `zsh-benchmark` - Measure startup time
- `zsh-compile` - Compile to bytecode
- `zsh-trim-history` - Reduce history size

**Git workflow:**
- `conventional-commit` - Guided commits
- `git-wip` - Quick WIP saves
- `git-save-all` - Create savepoints

**Environment:**
- `work-mode` - Switch work/personal
- `reload-shell` - Apply config changes

## Documentation Standards

All scripts follow consistent documentation format:

```bash
script-name --help

# Output format:
# script-name - One-line description
# 
# USAGE:
#     script-name [OPTIONS] [ARGUMENTS]
# 
# OPTIONS:
#     --flag          Description
#     --help, -h      Show this help
# 
# EXAMPLES:
#     script-name --flag value
# 
# REQUIREMENTS:
#     - dependency1
#     - dependency2
# 
# PLATFORM: darwin | linux | all
# 
# SEE ALSO:
#     related-script1, related-script2
```

## Adding New Scripts

When creating a new script:

1. **Add to appropriate category** (bin/core/, bin/credentials/, etc.)
2. **Include --help flag** following the standard format
3. **Make executable** with `chmod +x`
4. **Test help message** with `script-name --help`
5. **Run shellcheck** for validation
6. **Document** by running `dotfiles-help` to verify it appears

The interactive help system will automatically discover new scripts.

## Platform Support

**macOS (darwin):**
- All scripts fully supported
- Uses Homebrew for packages
- Uses macOS Keychain for secrets

**Linux:**
- Core scripts fully supported
- Git utilities fully supported
- macOS-specific scripts skipped
- Uses native package manager
- Uses gnome-keyring or kwallet for secrets

Scripts indicate platform compatibility in their help text.

## Performance Notes

Shell startup performance targets:
- **Cold start:** < 500ms
- **Warm start:** < 200ms

Use `zsh-benchmark` to measure and `zsh-compile` to optimize.

## Security Guidelines

**Storing secrets:**
```bash
# SECURE (interactive, no history)
store-api-key OPENAI_API_KEY

# SECURE (stdin)
echo "secret" | store-api-key KEY --stdin

# INSECURE (exposed in history) - DON'T DO THIS
store-api-key KEY "secret"
```

Always use interactive or stdin modes for secrets.

## Contributing

See [CONTRIBUTING.md](../../CONTRIBUTING.md) for guidelines on:
- Code style
- Testing requirements
- Documentation standards
- OpenSpec proposal process

## Getting Help

- **Interactive:** `dotfiles-help`
- **Specific script:** `script-name --help`
- **Quick reference:** `docs/scripts/quick-reference.md`
- **Onboarding:** [ONBOARDING.md](../../ONBOARDING.md)
- **Full docs:** Browse `docs/scripts/*.md`
