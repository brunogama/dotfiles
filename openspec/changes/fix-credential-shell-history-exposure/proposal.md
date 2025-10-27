# Fix Credential Exposure in Shell History

## Why

**SECURITY VULNERABILITY**: Current credential storage scripts expose sensitive data in shell history and process lists.

### Current Dangerous Pattern
```bash
store-api-key "CREDMATCH_MASTER_PASSWORD" "my-secret-password"
credmatch store "password" "API_KEY" "sensitive-value"
```

**Exposed in:**
- [X] Shell history (`~/.zsh_history`, `~/.bash_history`)
- [X] Process list (`ps aux` shows command arguments)
- [X] Shell debugging output (`set -x`)
- [X] Terminal scrollback buffer
- [X] Screen sharing/recording

### Attack Vectors
1. User runs `history` → sees plaintext passwords
2. Another user runs `ps aux` → sees credentials in process args
3. Malware reads shell history files
4. Shared terminal sessions expose secrets
5. CI/CD logs capture command lines

## What Changes

### 1. Interactive Mode (Default)
Prompt for secrets securely without echoing:
```bash
store-api-key "OPENAI_API_KEY"
# Prompts: Enter value: [hidden input]

credmatch store
# Prompts for: master password, key, value
```

### 2. Stdin Mode
Read from pipe or redirection:
```bash
echo "secret-value" | store-api-key "API_KEY" --stdin
cat secret.txt | store-api-key "API_KEY" --stdin

echo "master-password" | credmatch store --master-stdin "KEY" "value"
```

### 3. File Mode
Read from file (secure permissions):
```bash
store-api-key "API_KEY" --from-file ~/.secrets/api-key.txt
credmatch store --master-file ~/.secrets/master.txt "KEY" "value"
```

### 4. Environment Variable Mode
```bash
CREDMATCH_MASTER_PASSWORD="..." credmatch store "KEY" "value"
# Still better than command line, environment is less logged
```

### 5. Deprecation Warnings
Legacy positional arguments show warning:
```bash
store-api-key "KEY" "value"
# [WARNING]  WARNING: Passing secrets as command arguments exposes them in shell history!
# [WARNING]  Use --stdin, --from-file, or interactive mode instead.
# [WARNING]  This usage will be removed in v2.0
```

## Impact

### Files Modified
- `bin/credentials/store-api-key` - Add interactive/stdin/file modes
- `bin/credentials/credmatch` - Add interactive/stdin/file modes
- `bin/credentials/get-api-key` - No changes needed (read-only)
- `bin/credentials/credfile` - Update to use secure modes internally

### Breaking Changes
**None** - All changes are backward compatible with deprecation warnings.

### New Capabilities
- Secure credential input without shell history exposure
- Support for automated scripts (stdin mode)
- File-based secret injection
- Environment variable support

### Documentation Updates
- `ONBOARDING.md` - Update credential management section
- `README_IMPROVEMENTS.md` - Fix security examples
- Add `SECURITY.md` - Document secure practices

## Migration Path

### Phase 1: Add New Modes (Backward Compatible)
- Add --stdin, --from-file, --interactive flags
- Keep positional args working with warnings
- Default to interactive mode when no args

### Phase 2: Documentation & Education
- Update all docs to use secure methods
- Add warnings to old usage patterns
- Create migration guide

### Phase 3: Deprecation (v2.0)
- Remove positional argument support
- Make interactive mode mandatory default
- Require explicit flag for non-interactive use

## Examples

### Before (INSECURE)
```bash
# [NO] EXPOSED IN HISTORY
store-api-key "OPENAI_API_KEY" "sk-xxxxxxxxxxxxx"
credmatch store "master-pass" "github_token" "ghp_xxxxx"

# Visible in:
$ history | grep store-api-key
store-api-key "OPENAI_API_KEY" "sk-xxxxxxxxxxxxx"
```

### After (SECURE)
```bash
# [YES] INTERACTIVE (SECURE)
store-api-key "OPENAI_API_KEY"
Enter value for OPENAI_API_KEY: [hidden input]
[OK] Stored securely in Keychain

# [YES] STDIN (SECURE)
cat ~/.secrets/openai.key | store-api-key "OPENAI_API_KEY" --stdin

# [YES] FILE (SECURE)
store-api-key "OPENAI_API_KEY" --from-file ~/.secrets/openai.key

# [YES] ENVIRONMENT VARIABLE (ACCEPTABLE)
MASTER_PASS="..." credmatch store "github_token" "ghp_xxxxx"

# History shows:
$ history | grep store-api-key
store-api-key "OPENAI_API_KEY"  # No secret visible!
```

## Security Benefits

### Before
| Attack Vector | Status |
|---------------|--------|
| Shell history | [NO] Fully exposed |
| Process list | [NO] Fully exposed |
| Terminal recording | [NO] Fully exposed |
| Log files | [NO] Fully exposed |
| Shoulder surfing | [NO] Visible on screen |

### After
| Attack Vector | Status |
|---------------|--------|
| Shell history | [YES] Protected (no args) |
| Process list | [YES] Protected (no args) |
| Terminal recording | [YES] Protected (hidden input) |
| Log files | [YES] Protected (no args logged) |
| Shoulder surfing | [YES] Protected (masked input) |

## Additional Hardening

### 1. Clear History Command
```bash
# Add helper to clear sensitive history
clear-secret-history
# Removes any history lines containing: store-api-key, credmatch store, etc.
```

### 2. Pre-commit Hook Warning
Detect and warn about secrets in git commits:
```bash
# In git pre-commit hook
if git diff --cached | grep -E "(store-api-key|credmatch store).*\".*\".*\""; then
    echo "[WARNING]  WARNING: Potential secret in commit!"
fi
```

### 3. Documentation Banner
Add to all credential docs:
```markdown
[WARNING]  **SECURITY WARNING**
Never pass secrets as command-line arguments!
Always use interactive mode, stdin, or file input.
```

## Testing Plan

### Security Tests
1. Verify secrets NOT in shell history after interactive input
2. Verify secrets NOT in `ps aux` output during execution
3. Verify file mode checks permissions (600 or stricter)
4. Verify stdin mode doesn't echo to terminal
5. Verify deprecation warnings appear for old usage

### Compatibility Tests
1. Old positional args still work (with warning)
2. New flags work correctly
3. Interactive mode on TTY, fails gracefully without TTY
4. Stdin mode works in pipes
5. File mode handles missing files gracefully

### Integration Tests
1. `credfile` uses secure modes internally
2. Installation scripts use secure patterns
3. All docs examples are secure
4. No secrets in example commands

## Related Issues

- Shell history persistence
- macOS Keychain as primary secret store
- CI/CD secret injection patterns
- Multi-user system security

## Success Criteria

- [YES] No secrets visible in shell history after normal usage
- [YES] No secrets in process list during execution
- [YES] Interactive mode works seamlessly
- [YES] Backward compatibility maintained
- [YES] Clear migration path documented
- [YES] All docs updated to secure patterns
- [YES] Deprecation warnings guide users

## Timeline

- **Phase 1 (Week 1)**: Implement new modes in store-api-key
- **Phase 2 (Week 1)**: Implement new modes in credmatch
- **Phase 3 (Week 1)**: Update credfile to use secure modes
- **Phase 4 (Week 2)**: Update all documentation
- **Phase 5 (Week 2)**: Add tests and validation
- **Phase 6 (Week 2)**: Add deprecation warnings
- **v2.0 (Future)**: Remove insecure modes completely
