# Improve Credential Management Documentation

## Why

**USABILITY ISSUE**: Credential management scripts (credmatch, credfile, store-api-key) lack comprehensive documentation with practical examples, making them difficult to discover and use effectively.

### Current Problems

**1. Incomplete Documentation:**
- credmatch: Has help text but no workflow examples
- credfile: Basic usage shown but missing advanced patterns
- store-api-key: Security improvements not documented
- No end-to-end credential lifecycle examples

**2. Missing Context:**
```bash
# Users don't understand the relationship between tools
$ store-api-key GITHUB_TOKEN  # Stores in Keychain
$ credmatch list              # Separate encrypted storage?
$ credfile put file           # Another storage mechanism?

# Which tool for which use case?
```

**3. No Security Guidance:**
- When to use Keychain vs credmatch?
- How to rotate credentials safely?
- Best practices for master passwords?
- Multi-machine credential sync patterns?

**4. Sparse Examples:**
```bash
# Current help shows basic syntax
store-api-key KEY_NAME

# But doesn't show:
# - Complete workflows (store → retrieve → use)
# - Error handling
# - Migration between systems
# - Backup/restore procedures
# - Team collaboration patterns
```

**Impact:**
- Users avoid credential tools (security risk)
- Credentials stored insecurely in .env files
- Support questions about "how do I..."
- Under-utilization of secure storage features
- Confusion between different credential tools

## What Changes

### 1. Create Comprehensive Credential Guide

**New File:** `docs/guides/CREDENTIAL_MANAGEMENT.md`

**Structure:**
```markdown
# Credential Management Guide

## Overview
- Architecture: Keychain vs credmatch vs credfile
- Use cases for each tool
- Security model

## Quick Start
- First-time setup
- Store your first credential
- Retrieve and use
- Verify storage

## Tools Reference
### store-api-key / get-api-key
### credmatch
### credfile
### clear-secret-history

## Common Workflows
- Daily development
- Multi-machine setup
- Team collaboration
- Credential rotation
- Backup and restore

## Security Best Practices
- Master password management
- Encryption details
- Audit and monitoring
- Recovery procedures

## Troubleshooting
- Common errors
- Debugging steps
- Migration guides
```

### 2. Enhanced Script Help Text

**Update bin/credentials/store-api-key:**
```bash
usage() {
    cat << EOF
store-api-key - Securely store API keys and credentials

SECURITY: This tool prevents shell history exposure by prompting
for values interactively. Never pass secrets as positional arguments.

USAGE:
    store-api-key KEY_NAME              # Interactive (recommended)
    store-api-key KEY_NAME --stdin      # From pipe
    store-api-key KEY_NAME --from-file FILE  # From file

STORAGE:
    Credentials are stored in macOS Keychain and encrypted by the OS.
    Access requires your login password or Touch ID.

EXAMPLES:
    # Interactive mode (secure, no history exposure)
    $ store-api-key GITHUB_TOKEN
    Enter value for GITHUB_TOKEN (hidden): [type secret]
    Stored GITHUB_TOKEN in Keychain

    # From pipe (secure for scripts)
    $ echo "\$SECRET_VALUE" | store-api-key API_KEY --stdin
    Stored API_KEY in Keychain

    # From file (secure for bulk import)
    $ store-api-key DATABASE_PASSWORD --from-file ~/.secrets/db.txt
    Stored DATABASE_PASSWORD in Keychain

    # Retrieve stored credential
    $ get-api-key GITHUB_TOKEN
    ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    # Use in environment
    $ export GITHUB_TOKEN="\$(get-api-key GITHUB_TOKEN)"

SECURITY WARNINGS:
    [NO] INSECURE (deprecated):
    $ store-api-key KEY "plaintext"     # Exposed in history!

    [YES] SECURE (use these):
    $ store-api-key KEY                 # Prompts securely
    $ echo "value" | store-api-key KEY --stdin
    $ store-api-key KEY --from-file path

RELATED:
    get-api-key           - Retrieve stored credentials
    credmatch             - Encrypted credential storage
    credfile              - Encrypted file storage
    clear-secret-history  - Remove exposed secrets from history

PLATFORM: darwin (macOS Keychain required)

SEE ALSO:
    docs/guides/CREDENTIAL_MANAGEMENT.md - Complete guide
    man security                          - Keychain CLI reference
EOF
}
```

**Update bin/credentials/credmatch:**
```bash
usage() {
    cat << EOF
credmatch - Encrypted credential storage and search

OVERVIEW:
    credmatch provides encrypted storage for credentials with a master
    password. Unlike Keychain (store-api-key), credmatch credentials
    can be synced across machines via Git.

ARCHITECTURE:
    - Master password stored in Keychain (secure)
    - Credentials encrypted with AES-256-CBC
    - Storage file: ~/.credmatch (encrypted, Git-friendly)
    - Cross-platform: works on macOS and Linux

USAGE:
    credmatch list [MASTER_PASS]          # List all credentials
    credmatch store MASTER_PASS KEY VALUE # Store credential
    credmatch fetch MASTER_PASS KEY       # Retrieve credential
    credmatch delete MASTER_PASS KEY      # Delete credential
    credmatch search MASTER_PASS PATTERN  # Search by pattern

MASTER PASSWORD:
    The master password can be:
    1. Passed as argument (not recommended for interactive use)
    2. Retrieved from Keychain: \$(get-api-key CREDMATCH_MASTER_PASSWORD)
    3. Prompted interactively

EXAMPLES:
    # First-time setup
    $ store-api-key CREDMATCH_MASTER_PASSWORD
    Enter value: [create strong master password]

    # Store credentials
    $ credmatch store "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" \\
        "github.personal.token" "ghp_xxxxxxxxxxxx"
    Stored: github.personal.token

    $ credmatch store "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" \\
        "aws.staging.access_key" "AKIAIOSFODNN7EXAMPLE"
    Stored: aws.staging.access_key

    # List all credentials
    $ credmatch list "\$(get-api-key CREDMATCH_MASTER_PASSWORD)"
    aws.staging.access_key
    aws.staging.secret_key
    github.personal.token
    github.work.token

    # Retrieve specific credential
    $ credmatch fetch "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" \\
        "github.personal.token"
    ghp_xxxxxxxxxxxx

    # Search by pattern
    $ credmatch search "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" "github"
    github.personal.token
    github.work.token

    # Use in scripts (secure)
    $ export AWS_ACCESS_KEY="\$(credmatch fetch \\
        "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" \\
        "aws.staging.access_key")"

    # Delete credential
    $ credmatch delete "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" \\
        "old.api.key"
    Deleted: old.api.key

SYNC ACROSS MACHINES:
    credmatch storage (~/.credmatch) is encrypted and can be synced:

    # On machine 1
    $ cp ~/.credmatch ~/Dropbox/encrypted-credentials/

    # On machine 2 (with same master password)
    $ cp ~/Dropbox/encrypted-credentials/.credmatch ~/
    $ credmatch list "\$(get-api-key CREDMATCH_MASTER_PASSWORD)"
    [credentials available]

WHEN TO USE:
    - Use credmatch when: Need cross-platform sync
    - Use credmatch when: Multiple machines sharing credentials
    - Use credmatch when: Structured credential naming (dot notation)
    - Use store-api-key when: Single macOS machine
    - Use store-api-key when: OS-level encryption preferred
    - Use credfile when: Encrypting entire files (not just values)

SECURITY:
    - Master password NEVER stored in plaintext
    - AES-256-CBC encryption for all credentials
    - Encrypted storage file safe to sync via Git
    - Decryption only with correct master password

RELATED:
    store-api-key        - macOS Keychain storage (simpler)
    get-api-key          - Retrieve from Keychain
    credfile             - Encrypted file storage
    clear-secret-history - Remove exposed secrets

PLATFORM: darwin, linux

SEE ALSO:
    docs/guides/CREDENTIAL_MANAGEMENT.md
EOF
}
```

**Update bin/credentials/credfile:**
```bash
usage() {
    cat << EOF
credfile - Encrypted file storage

OVERVIEW:
    credfile encrypts entire files using your master password.
    Unlike store-api-key (single values) or credmatch (key-value pairs),
    credfile handles full files: certificates, SSH keys, config files.

ARCHITECTURE:
    - Files encrypted with OpenSSL AES-256-CBC
    - Storage: ~/.credfile/ directory (encrypted files)
    - Master password from Keychain
    - Original files never modified

USAGE:
    credfile put KEY FILE_PATH       # Encrypt and store file
    credfile get KEY OUTPUT_PATH     # Decrypt and retrieve file
    credfile list                    # List stored files
    credfile info KEY                # Show file metadata
    credfile delete KEY              # Remove stored file

MASTER PASSWORD:
    Uses CREDFILE_MASTER_PASSWORD from Keychain.
    Setup: store-api-key CREDFILE_MASTER_PASSWORD

EXAMPLES:
    # First-time setup
    $ store-api-key CREDFILE_MASTER_PASSWORD
    Enter value: [create strong master password]

    # Encrypt and store SSH private key
    $ credfile put github_ssh_key ~/.ssh/id_rsa
    Encrypted and stored: github_ssh_key
    Original file: ~/.ssh/id_rsa (not modified)

    # Store SSL certificate
    $ credfile put staging_ssl_cert /path/to/staging.crt
    Encrypted and stored: staging_ssl_cert

    # Store AWS credentials file
    $ credfile put aws_credentials ~/.aws/credentials
    Encrypted and stored: aws_credentials

    # List all stored files
    $ credfile list
    aws_credentials (encrypted, 412 bytes)
    github_ssh_key (encrypted, 1679 bytes)
    staging_ssl_cert (encrypted, 1289 bytes)

    # Get file information
    $ credfile info github_ssh_key
    Key: github_ssh_key
    Encrypted size: 1679 bytes
    Stored: 2024-01-15 10:30:45
    Decrypted size: ~1600 bytes

    # Retrieve and decrypt file
    $ credfile get github_ssh_key /tmp/recovered_key
    Decrypted to: /tmp/recovered_key

    # Direct use (decrypt to temp, use, cleanup)
    $ credfile get github_ssh_key /tmp/key && \\
        ssh -i /tmp/key git@github.com && \\
        rm /tmp/key

    # Restore to original location
    $ credfile get aws_credentials ~/.aws/credentials
    Decrypted to: ~/.aws/credentials

    # Delete stored file
    $ credfile delete old_certificate
    Deleted: old_certificate

COMMON USE CASES:
    1. SSH Keys:
       $ credfile put work_ssh_key ~/.ssh/id_rsa_work
       $ credfile get work_ssh_key ~/.ssh/id_rsa_work

    2. SSL Certificates:
       $ credfile put prod_ssl_cert /etc/ssl/prod.crt
       $ credfile get prod_ssl_cert /tmp/prod.crt

    3. Configuration Files:
       $ credfile put k8s_config ~/.kube/config
       $ credfile get k8s_config ~/.kube/config

    4. GPG Keys:
       $ credfile put gpg_private_key ~/.gnupg/secring.gpg
       $ credfile get gpg_private_key ~/.gnupg/secring.gpg

SYNC ACROSS MACHINES:
    ~/.credfile/ directory contains encrypted files (safe to sync):

    # On machine 1
    $ rsync -av ~/.credfile/ backup-server:/encrypted-files/

    # On machine 2 (with same master password)
    $ rsync -av backup-server:/encrypted-files/ ~/.credfile/
    $ credfile list
    [files available]

WHEN TO USE:
    - Use credfile when: Storing entire files (not just values)
    - Use credfile when: SSH keys, certificates, configs
    - Use credfile when: File structure must be preserved
    - Use store-api-key when: Storing API keys/tokens (simple values)
    - Use credmatch when: Key-value pairs with search

SECURITY:
    - Files encrypted with AES-256-CBC
    - Master password stored in Keychain
    - Original files unchanged
    - Encrypted storage safe to backup/sync

BACKUP STRATEGY:
    # Backup encrypted files (safe)
    $ tar -czf credfile-backup.tar.gz ~/.credfile/
    $ cp credfile-backup.tar.gz ~/Dropbox/

    # Restore
    $ tar -xzf credfile-backup.tar.gz -C ~/

RELATED:
    store-api-key - Store single credentials
    credmatch     - Key-value credential storage
    get-api-key   - Retrieve from Keychain

PLATFORM: darwin, linux (OpenSSL required)

SEE ALSO:
    docs/guides/CREDENTIAL_MANAGEMENT.md
    man openssl
EOF
}
```

### 3. Complete Credential Management Guide

**Create docs/guides/CREDENTIAL_MANAGEMENT.md** (comprehensive, ~1000 lines)

**Key Sections:**

**Architecture Overview:**
```
┌─────────────────────────────────────────────────────┐
│                  Credential Tools                    │
├─────────────────────────────────────────────────────┤
│                                                      │
│  store-api-key / get-api-key                        │
│  ├─ Storage: macOS Keychain                         │
│  ├─ Encryption: OS-level (FileVault)                │
│  ├─ Use case: Simple API keys, single machine       │
│  └─ Example: GITHUB_TOKEN, OPENAI_API_KEY           │
│                                                      │
│  credmatch                                           │
│  ├─ Storage: ~/.credmatch (encrypted file)          │
│  ├─ Encryption: AES-256-CBC (master password)       │
│  ├─ Use case: Multi-machine sync, search            │
│  └─ Example: aws.prod.key, github.team.token        │
│                                                      │
│  credfile                                            │
│  ├─ Storage: ~/.credfile/ (encrypted files)         │
│  ├─ Encryption: AES-256-CBC (master password)       │
│  ├─ Use case: Full files (SSH keys, certs)          │
│  └─ Example: id_rsa, ssl.crt, kubeconfig            │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Quick Start Workflow:**
```bash
# Day 1: Setup (one-time)
store-api-key CREDMATCH_MASTER_PASSWORD
store-api-key CREDFILE_MASTER_PASSWORD

# Day 2: Store credentials
store-api-key GITHUB_TOKEN                    # Simple API key
credmatch store "$(get-api-key CREDMATCH_MASTER_PASSWORD)" \
    "aws.prod.access_key" "AKIAIOSFODNN7EXAMPLE"
credfile put ssh_key ~/.ssh/id_rsa            # Full file

# Day 3: Use credentials
export GITHUB_TOKEN="$(get-api-key GITHUB_TOKEN)"
export AWS_KEY="$(credmatch fetch "$(get-api-key CREDMATCH_MASTER_PASSWORD)" \
    "aws.prod.access_key")"
credfile get ssh_key /tmp/key && ssh -i /tmp/key user@host
```

**Decision Tree:**
```
Need to store a credential?
│
├─ Single API key/token (no sync needed)?
│  → Use store-api-key (simplest)
│
├─ Multiple related credentials (need search/organization)?
│  → Use credmatch (structured storage)
│
└─ Entire file (SSH key, certificate, config)?
   → Use credfile (file encryption)
```

**Complete Examples:**

**Scenario 1: GitHub Token Management**
```bash
# Store GitHub personal token
$ store-api-key GITHUB_PERSONAL_TOKEN
Enter value: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Stored in Keychain

# Use in script
#!/bin/bash
TOKEN="$(get-api-key GITHUB_PERSONAL_TOKEN)"
curl -H "Authorization: token $TOKEN" https://api.github.com/user
```

**Scenario 2: AWS Multi-Environment Setup**
```bash
# Store all AWS credentials in credmatch
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"

credmatch store "$MASTER" "aws.dev.access_key" "AKIA..."
credmatch store "$MASTER" "aws.dev.secret_key" "secret..."
credmatch store "$MASTER" "aws.staging.access_key" "AKIA..."
credmatch store "$MASTER" "aws.staging.secret_key" "secret..."
credmatch store "$MASTER" "aws.prod.access_key" "AKIA..."
credmatch store "$MASTER" "aws.prod.secret_key" "secret..."

# Switch environments easily
switch_to_env() {
    local env="$1"
    MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
    export AWS_ACCESS_KEY_ID="$(credmatch fetch "$MASTER" "aws.$env.access_key")"
    export AWS_SECRET_ACCESS_KEY="$(credmatch fetch "$MASTER" "aws.$env.secret_key")"
    echo "Switched to AWS $env environment"
}

switch_to_env staging
aws s3 ls  # Uses staging credentials
```

**Scenario 3: SSH Key Management**
```bash
# Store SSH keys for different services
credfile put github_key ~/.ssh/id_rsa_github
credfile put gitlab_key ~/.ssh/id_rsa_gitlab
credfile put work_bastion_key ~/.ssh/id_rsa_bastion

# Use temporarily
use_ssh_key() {
    local key_name="$1"
    local temp_key="/tmp/ssh_key_$$"

    credfile get "$key_name" "$temp_key"
    chmod 600 "$temp_key"
    ssh-add "$temp_key"
    rm "$temp_key"
}

use_ssh_key github_key
git push  # Uses github key
```

**Security Best Practices:**
```markdown
## Master Password Guidelines

**Strength Requirements:**
- Minimum 16 characters
- Mix of uppercase, lowercase, numbers, symbols
- Not used anywhere else
- Not based on dictionary words

**Good Examples:**
[YES] `Tr0ub4dor&3-Symphony!2024`
[YES] `correct-horse-battery-staple-2024!`
[YES] Generated: `kJ#9mP@vL2$qR8nF`

**Bad Examples:**
[NO] `password123`
[NO] `MyName2024`
[NO] Same as GitHub/AWS password

## Rotation Strategy

**Frequency:**
- Master passwords: Annually
- API keys: Quarterly or on team change
- SSH keys: Annually or on laptop replacement

**Process:**
1. Generate new credential
2. Test in staging/dev
3. Update production
4. Store new version
5. Revoke old credential
6. Document rotation date
```

**Multi-Machine Setup:**
```bash
# Machine 1: Primary workstation
store-api-key CREDMATCH_MASTER_PASSWORD
credmatch store "$MASTER" "service.key" "value"

# Sync ~/.credmatch file to cloud
cp ~/.credmatch ~/Dropbox/secure/

# Machine 2: Laptop
# Copy encrypted file
cp ~/Dropbox/secure/.credmatch ~/

# Store same master password in Keychain
store-api-key CREDMATCH_MASTER_PASSWORD  # Enter same password

# Verify access
credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"
# Shows all credentials from machine 1
```

**Troubleshooting:**
```bash
# Problem: "Master password incorrect"
# Solution: Verify stored password
get-api-key CREDMATCH_MASTER_PASSWORD  # Should output password

# Problem: "Keychain locked"
# Solution: Unlock Keychain
security unlock-keychain

# Problem: "Credential not found"
# Solution: List all credentials
credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# Problem: "Permission denied on credfile"
# Solution: Check file permissions
ls -la ~/.credfile/
chmod 600 ~/.credfile/*

# Problem: "Can't decrypt credfile"
# Solution: Verify master password
get-api-key CREDFILE_MASTER_PASSWORD
```

### 4. Update Quick Reference

**Add to docs/scripts/quick-reference.md:**

```markdown
## Credential Management

**Decision Guide:**
| Use Case | Tool | Example |
|----------|------|---------|
| Simple API key (1 machine) | `store-api-key` | `store-api-key GITHUB_TOKEN` |
| Multiple keys (need search) | `credmatch` | `credmatch store ... aws.prod.key ...` |
| Full file (SSH key, cert) | `credfile` | `credfile put ssh_key ~/.ssh/id_rsa` |

**Quick Workflows:**

```bash
# Store and retrieve simple key
store-api-key OPENAI_API_KEY
export OPENAI_API_KEY="$(get-api-key OPENAI_API_KEY)"

# Store and search multiple keys
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
credmatch store "$MASTER" "github.token" "ghp_xxx"
credmatch search "$MASTER" "github"

# Store and retrieve file
credfile put ssh_key ~/.ssh/id_rsa
credfile get ssh_key /tmp/key
```
```

### 5. Interactive Examples in dotfiles-help

**Update bin/core/dotfiles-help:**

Add credential management examples to interactive menu:

```bash
show_credentials() {
    clear
    cat << EOF

${GREEN}=== Credential Management ===${NC}

${CYAN}Three Tools for Different Needs:${NC}

${YELLOW}1. store-api-key / get-api-key${NC} (Simplest)
   For: Single API keys on one machine
   Storage: macOS Keychain

   $ store-api-key GITHUB_TOKEN
   $ export TOKEN="\$(get-api-key GITHUB_TOKEN)"

${YELLOW}2. credmatch${NC} (Searchable)
   For: Multiple credentials with organization
   Storage: ~/.credmatch (encrypted, sync-friendly)

   $ credmatch store "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" \\
       "aws.prod.key" "AKIA..."
   $ credmatch search "\$(get-api-key CREDMATCH_MASTER_PASSWORD)" "aws"

${YELLOW}3. credfile${NC} (Full Files)
   For: SSH keys, certificates, config files
   Storage: ~/.credfile/ (encrypted)

   $ credfile put ssh_key ~/.ssh/id_rsa
   $ credfile get ssh_key /tmp/key

${CYAN}See Also:${NC}
   docs/guides/CREDENTIAL_MANAGEMENT.md - Complete guide

EOF
    read -p "Press Enter to continue..."
    show_menu
}
```

## Impact

### Files Created
- `docs/guides/CREDENTIAL_MANAGEMENT.md` (~1000 lines) - Comprehensive guide

### Files Modified
- `bin/credentials/store-api-key` - Enhanced help with examples
- `bin/credentials/credmatch` - Enhanced help with examples
- `bin/credentials/credfile` - Enhanced help with examples
- `bin/credentials/get-api-key` - Enhanced help
- `bin/credentials/clear-secret-history` - Enhanced help
- `docs/scripts/quick-reference.md` - Add credential decision guide
- `bin/core/dotfiles-help` - Add credential examples to menu
- `README.md` - Link to credential guide

### Breaking Changes
**None** - All changes are documentation additions

### New Capabilities
- Complete credential management guide
- Decision tree for tool selection
- End-to-end workflow examples
- Multi-machine setup patterns
- Troubleshooting procedures
- Security best practices

## Expected Benefits

### Discoverability
**Before:**
```bash
# User guesses
ls bin/credentials/
cat bin/credentials/credmatch | head -50
```

**After:**
```bash
# Multiple entry points
dotfiles-help            # Shows credential section
cat docs/guides/CREDENTIAL_MANAGEMENT.md
credmatch --help         # Comprehensive examples
```

### Reduced Errors
**Before:**
- Users store credentials in .env files (insecure)
- Confusion about which tool to use
- Missing master password setup
- Credentials exposed in shell history

**After:**
- Clear tool selection guide
- Security warnings in help text
- Step-by-step setup instructions
- Examples show secure patterns

### Time Savings
**Before:**
- 30 minutes reading source code to understand tools
- Trial and error with commands
- Support questions

**After:**
- 5 minutes reading guide
- Copy-paste examples
- Self-service troubleshooting

## Migration Path

### Phase 1: Documentation Creation (Week 1)
1. Create `docs/guides/CREDENTIAL_MANAGEMENT.md`
2. Write architecture overview
3. Document all three tools
4. Add workflow examples
5. Add troubleshooting section

### Phase 2: Script Help Enhancement (Week 1-2)
1. Update store-api-key help
2. Update credmatch help
3. Update credfile help
4. Add examples to each
5. Add security warnings

### Phase 3: Integration (Week 2)
1. Update quick-reference.md
2. Update dotfiles-help
3. Link from README.md
4. Link from ONBOARDING.md
5. Test all examples

### Phase 4: User Testing (Week 2-3)
1. Test with new users
2. Gather feedback
3. Refine examples
4. Add missing scenarios
5. Update based on questions

## Success Criteria

- All credential scripts have comprehensive --help
- docs/guides/CREDENTIAL_MANAGEMENT.md covers all tools
- Decision tree helps users choose correct tool
- All examples tested and working
- Troubleshooting covers common errors
- Zero broken links in documentation
- User testing: 80%+ find guide helpful

## Future Enhancements

- **Video tutorials**: Screencast demonstrating workflows
- **Interactive wizard**: `credential-setup` script for first-time users
- **Credential templates**: Pre-configured patterns for common services
- **Migration tool**: Move .env files to secure storage
- **Audit command**: List all stored credentials with metadata
- **Backup automation**: Scheduled encrypted backups
- **Web UI**: Browser-based credential viewer (read-only)
