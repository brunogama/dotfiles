---
description: 'General coding conventions and constitutional rules for all files'
applyTo: '**/*'
---

# General Coding Conventions

## Constitutional Rules (MINDSET.md)

All code must follow the constitutional rules defined in `/MINDSET.md`:

### Rule 1: All Directories MUST Be Lowercase
- All directory names use lowercase only
- No exceptions, no mixed case, no uppercase
- See MINDSET.md for rationale

### Rule 2: No Emojis
- No emojis in code, documentation, scripts, commit messages, or help text
- Use ASCII alternatives: [OK], [ERROR], [WARNING], ->
- See MINDSET.md for rationale

### Rule 3: OpenSpec for Major Changes
Use OpenSpec workflow (`/openspec/AGENTS.md`) for:
- New features or capabilities
- Breaking changes (API, schema, behavior)
- Architecture changes
- Performance optimizations that change behavior
- Security pattern updates

Skip OpenSpec for:
- Bug fixes restoring intended behavior
- Typos, formatting, comments
- Non-breaking dependency updates
- Simple configuration changes

## Symlink Management

All symlink operations must reference `/LinkingManifest.json`:

- **Source of Truth**: LinkingManifest.json defines all dotfile symlinks
- **Schema Validation**: Use `/schemas/LinkingManifest.schema.json` for validation
- **Application**: Use `bin/core/link-dotfiles.py` to apply manifest
- **Dry Run First**: Always test with `--dry-run` before `--apply`
- **Platform-Specific**: Use `platform` field for OS-specific links
- **Optional Links**: Use `optional: true` for non-critical symlinks

### LinkingManifest.json Structure
```json
{
  "version": "1.0.0",
  "links": {
    "category-name": {
      "description": "Category description",
      "links": [
        {
          "source": "relative/path/in/dotfiles",
          "target": "~/destination/path",
          "type": "file|directory|directory-contents",
          "platform": "darwin|linux",
          "optional": true|false
        }
      ]
    }
  }
}
```

## Code Quality Standards

### All File Types
- No trailing whitespace
- Files must end with single newline
- Use consistent indentation (language-specific)
- Maximum line length: 79-120 characters (language-specific)
- No commented-out code in production
- Clear, descriptive variable/function names

### Security
- Never commit secrets, API keys, or credentials
- Use `bin/credentials/*` for secure credential management
- Credentials stored in macOS Keychain only
- No secrets in command-line arguments (use stdin/files)

### Testing
- All tests must pass before commit
- Warnings treated as errors
- Unit tests required for bug fixes (minimum 5 tests)
- Integration tests for critical workflows
- Performance tests for optimization claims

### Documentation
- Update relevant documentation before commit
- Code should be self-documenting with clear names
- Complex algorithms require explanation comments
- Breaking changes documented in OpenSpec proposals

## Pre-commit Hooks

The following hooks enforce these rules:
- `check-lowercase-dirs` - Constitutional Rule 1
- `check-no-emojis` - Constitutional Rule 2
- `check-commit-msg` - Conventional Commits format
- `validate-manifest` - LinkingManifest.json schema
- `validate-openspec` - OpenSpec proposal validation
- `shellcheck` - Shell script quality

## Git Workflow

### Commit Format
Use Conventional Commits:
```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

### Branch Naming
- `feature/<description>` - New features
- `fix/<description>` - Bug fixes
- `refactor/<description>` - Code refactoring
- `docs/<description>` - Documentation updates

## Reference Files

- `/MINDSET.md` - Constitutional rules and coding standards
- `/CLAUDE.md` - Project overview and AI assistant guidance
- `/LinkingManifest.json` - Symlink source of truth
- `/openspec/AGENTS.md` - Spec-driven development workflow
- `/openspec/project.md` - Project conventions and patterns
