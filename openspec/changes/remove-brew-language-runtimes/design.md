# Design: Remove Language Runtimes from Homebrew

## Context

The dotfiles currently install language runtimes through Homebrew, which conflicts with the existing lazy-load.zsh setup that expects version managers (rbenv, nvm, mise). This creates a hybrid system where:

1. Homebrew installs a single version of each language
2. Version managers are configured but not actively used
3. Brew-installed binaries in PATH take precedence over version manager shims

The lazy-load.zsh already has framework support for rbenv and nvm, but these tools are either not installed or not functioning properly due to Homebrew taking precedence.

**Stakeholders:**
- Developers using these dotfiles
- CI/CD systems that depend on consistent environments
- Projects requiring specific language versions

**Constraints:**
- Must maintain backward compatibility with existing shell configurations
- Installation script must work on fresh macOS installs
- Must not break existing projects mid-development

## Goals / Non-Goals

**Goals:**
- Remove Python, Node from Brewfile
- Add official installation method support in install script
- Support multiple versions per language via version managers
- Leverage existing lazy-load.zsh infrastructure
- Provide clear migration path for existing users

**Non-Goals:**
- Changing the lazy-load.zsh framework (already works)
- Supporting Windows or non-Unix systems
- Managing system Python/Ruby (leave system versions untouched)
- Automatically migrating existing brew-installed languages

## Decisions

### Decision 1: Version Manager Selection

**Python: pyenv**
- Rationale: Industry standard, similar to rbenv pattern
- Alternatives considered:
  - mise: Could manage all languages, but adds complexity
  - Official installers: No version switching capability
  - Homebrew multiple versions: Difficult to maintain
- Implementation: Install pyenv via Homebrew, manage Python versions via pyenv

**Node: nvm**
- Rationale: Already supported in lazy-load.zsh, industry standard
- Alternatives considered:
  - fnm: Faster but less mature ecosystem
  - volta: Good but less common
  - mise: Same as above
- Implementation: Install nvm via official method, no Homebrew dependency

**Ruby: rbenv**
- Rationale: Already in Brewfile and lazy-load.zsh
- Alternatives considered:
  - rvm: More features but heavier
  - mise: Same as above
  - chruby: Simpler but less features
- Implementation: Keep rbenv in Brewfile (it's a tool, not the runtime), use ruby-build plugin

### Decision 2: Installation Approach

Install script phases:
1. **Phase 1 (Homebrew)**: Install version managers only (rbenv, pyenv)
2. **Phase 2 (Post-Homebrew)**: Install nvm via official curl script
3. **Phase 3 (Language Runtimes)**: Install default versions via version managers
   - pyenv: latest stable Python 3.x
   - nvm: latest LTS Node
   - rbenv: latest stable Ruby 3.x
4. **Phase 4 (Global defaults)**: Set global versions for each language

Alternatives considered:
- Skip runtime installation: Too manual for users
- Install all via mise: Breaking change, different patterns
- Keep Homebrew for everything: Defeats the purpose

### Decision 3: Brewfile Changes

Remove these lines:
```ruby
brew "python"       # Line 12
brew "python@3.9"   # Line 13
brew "node"         # Line 54
```

Add these lines:
```ruby
brew "pyenv"        # Python version manager
# rbenv already present (line 11)
# nvm installed via official script (not Homebrew)
```

### Decision 4: Lazy-load.zsh Updates

**Required changes: NONE**

The current lazy-load.zsh already supports:
- rbenv (lines 19-40)
- nvm (lines 43-69)
- mise (lines 8-16)

Add pyenv lazy-loading:
```zsh
# Lazy Load: pyenv
if command -v pyenv &>/dev/null; then
    pyenv() {
        unfunction pyenv
        eval "$(command pyenv init - zsh)"
        pyenv "$@"
    }

    python() {
        unfunction python pyenv 2>/dev/null
        eval "$(command pyenv init - zsh)"
        python "$@"
    }

    pip() {
        unfunction pip pyenv 2>/dev/null
        eval "$(command pyenv init - zsh)"
        pip "$@"
    }
fi
```

## Risks / Trade-offs

### Risk 1: Breaking Changes for Existing Users
- **Impact**: Users must manually uninstall brew languages and reinstall via version managers
- **Mitigation**:
  - Provide clear migration guide
  - Install script detects brew-installed languages and warns
  - Add `--migrate-languages` flag to automate uninstall/reinstall
  - Document in CHANGELOG

### Risk 2: Installation Time Increase
- **Impact**: Installing version managers + languages takes longer than `brew install node`
- **Mitigation**:
  - Install only one version per language initially
  - Add `--skip-language-runtimes` flag for fast installs
  - Use parallel installation where possible
- **Trade-off**: Acceptable for better long-term flexibility

### Risk 3: PATH Configuration Complexity
- **Impact**: Version manager shims must be in PATH before system/Homebrew binaries
- **Mitigation**:
  - Lazy-load.zsh already handles initialization correctly
  - Install script validates PATH order
  - Documentation includes troubleshooting section
- **Trade-off**: One-time configuration vs ongoing version conflicts

### Risk 4: CI/CD Compatibility
- **Impact**: CI systems may expect brew-installed languages
- **Mitigation**:
  - Add environment variable `USE_BREW_LANGUAGES=1` to skip version managers
  - Document CI-specific installation instructions
  - Provide Docker images with pre-configured setups
- **Trade-off**: CI flexibility vs developer experience

## Migration Plan

### Phase 1: Update Brewfile and Install Script
1. Remove Python, Node from Brewfile
2. Add pyenv to Brewfile
3. Update install script with new logic
4. Update lazy-load.zsh with pyenv support

### Phase 2: Documentation
1. Update README with new installation approach
2. Create MIGRATION.md guide
3. Update troubleshooting docs
4. Add examples for common scenarios

### Phase 3: Testing
1. Test on fresh macOS install
2. Test migration path from current setup
3. Validate lazy-loading works correctly
4. Test with sample projects using different versions

### Phase 4: Rollout
1. Announce change in CHANGELOG
2. Provide migration script
3. Update CI/CD configurations
4. Monitor for issues

### Rollback Plan
If critical issues arise:
1. Revert Brewfile changes
2. Add back `brew "python"` and `brew "node"`
3. Keep version managers for opt-in usage
4. Document hybrid approach

## Open Questions

1. **Q**: Should we use mise instead of multiple version managers?
   - **A**: No, stay with established tools (rbenv, nvm, pyenv) for now. Mise can be evaluated later.

2. **Q**: Should python@3.9 be available via pyenv for legacy projects?
   - **A**: Yes, document how to install specific versions: `pyenv install 3.9.x`

3. **Q**: How do we handle projects with .nvmrc, .ruby-version, .python-version files?
   - **A**: Version managers automatically detect and use these files. Document best practices.

4. **Q**: Should the install script install language versions non-interactively?
   - **A**: Yes, install latest stable by default. Add `--skip-language-runtimes` for opt-out.
