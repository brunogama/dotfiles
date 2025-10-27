# Credential Management Guide

Complete guide to secure credential storage and management in the dotfiles system.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Quick Start](#quick-start)
- [Tools Reference](#tools-reference)
- [Common Workflows](#common-workflows)
- [Security Best Practices](#security-best-practices)
- [Multi-Machine Setup](#multi-machine-setup)
- [Troubleshooting](#troubleshooting)

---

## Overview

This dotfiles system provides three complementary tools for secure credential management:

1. **store-api-key / get-api-key** - Simple API key storage in macOS Keychain
2. **credmatch** - Encrypted key-value storage with search and sync
3. **credfile** - Full file encryption for SSH keys and certificates

### When to Use Each Tool

**Use store-api-key when:**
- Storing simple API keys or tokens
- Working on a single macOS machine
- Want OS-level encryption (FileVault)
- Need simplest solution

**Use credmatch when:**
- Managing multiple related credentials
- Need structured naming (aws.prod.key, github.team.token)
- Syncing credentials across machines
- Want to search/organize credentials

**Use credfile when:**
- Storing entire files (not just values)
- Managing SSH private keys
- Handling SSL certificates
- Need to preserve file structure

---

## Architecture

### Storage Comparison

```
+------------------------------------------------------------------+
|                      Credential Storage                          |
+------------------------------------------------------------------+
|                                                                  |
| store-api-key / get-api-key                                     |
| +-------------------------------------------------------------+  |
| | Storage:    macOS Keychain                                 |  |
| | Encryption: OS-level (FileVault + Keychain encryption)     |  |
| | Sync:       iCloud Keychain (automatic)                    |  |
| | Platform:   macOS only                                      |  |
| | Use case:   Simple API keys, single values                 |  |
| | Example:    GITHUB_TOKEN, OPENAI_API_KEY                   |  |
| +-------------------------------------------------------------+  |
|                                                                  |
| credmatch                                                        |
| +-------------------------------------------------------------+  |
| | Storage:    ~/.credmatch (encrypted file)                  |  |
| | Encryption: AES-256-CBC with master password               |  |
| | Sync:       Manual (Dropbox, rsync, Git)                   |  |
| | Platform:   macOS, Linux                                    |  |
| | Use case:   Multiple credentials with organization         |  |
| | Example:    aws.prod.key, github.team.token                |  |
| +-------------------------------------------------------------+  |
|                                                                  |
| credfile                                                         |
| +-------------------------------------------------------------+  |
| | Storage:    ~/.credfile/ (directory of encrypted files)    |  |
| | Encryption: AES-256-CBC via OpenSSL                        |  |
| | Sync:       Manual (tar + Dropbox, rsync)                  |  |
| | Platform:   macOS, Linux                                    |  |
| | Use case:   Full files (SSH keys, certificates, configs)   |  |
| | Example:    id_rsa, ssl.crt, kubeconfig                    |  |
| +-------------------------------------------------------------+  |
|                                                                  |
+------------------------------------------------------------------+
```

### Decision Tree

```
Need to store a credential?
|
+-- Is it a single API key/token?
|   |
|   +-- Only need on one macOS machine?
|   |   |
|   |   +-- YES: Use store-api-key (simplest)
|   |   |
|   |   +-- NO: Continue to next question
|   |
|   +-- Need to sync across machines?
|       |
|       +-- YES: Use credmatch
|       |
|       +-- NO: Use store-api-key
|
+-- Is it an entire file (SSH key, certificate)?
|   |
|   +-- YES: Use credfile
|   |
|   +-- NO: Continue
|
+-- Do you have multiple related credentials?
    |
    +-- YES: Use credmatch (structured storage)
    |
    +-- NO: Use store-api-key (simplest)
```

---

## Quick Start

### First-Time Setup (5 minutes)

**Step 1: Set up master passwords (one-time)**

```bash
# For credmatch
store-api-key CREDMATCH_MASTER_PASSWORD
# Enter a strong master password when prompted (hidden input)

# For credfile
store-api-key CREDFILE_MASTER_PASSWORD
# Enter another strong master password (can be same or different)
```

**Step 2: Store your first credential**

```bash
# Simple API key (easiest)
store-api-key GITHUB_TOKEN
# Enter token when prompted: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Or use credmatch for structured storage
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
credmatch store "$MASTER" "github.personal.token" "ghp_xxxxxxxxxxxx"

# Or store an SSH key with credfile
credfile put github_ssh_key ~/.ssh/id_rsa
```

**Step 3: Retrieve and use**

```bash
# Get simple API key
get-api-key GITHUB_TOKEN

# Use in environment variable
export GITHUB_TOKEN="$(get-api-key GITHUB_TOKEN)"

# Get from credmatch
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
credmatch fetch "$MASTER" "github.personal.token"

# Get file from credfile
credfile get github_ssh_key /tmp/ssh_key
```

**Step 4: Verify storage**

```bash
# List credentials in Keychain
security find-generic-password -s "dotfiles-GITHUB_TOKEN"

# List credmatch credentials
credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# List credfile files
credfile list
```

---

## Tools Reference

### store-api-key / get-api-key

**Purpose:** Store simple API keys and tokens in macOS Keychain

**Storage:** macOS Keychain (encrypted by FileVault)

**Platform:** macOS only

#### store-api-key

**Syntax:**
```bash
store-api-key KEY_NAME                    # Interactive (recommended)
store-api-key KEY_NAME --stdin            # From pipe
store-api-key KEY_NAME --from-file FILE   # From file
```

**Examples:**

```bash
# Interactive mode (secure, no history exposure)
$ store-api-key GITHUB_TOKEN
Enter value for GITHUB_TOKEN (hidden): [type secret]
Stored GITHUB_TOKEN in Keychain

# From pipe (secure for scripts)
$ echo "$SECRET_VALUE" | store-api-key API_KEY --stdin
Stored API_KEY in Keychain

# From file (secure for bulk import)
$ store-api-key DATABASE_PASSWORD --from-file ~/.secrets/db.txt
Stored DATABASE_PASSWORD in Keychain

# Update existing key
$ store-api-key GITHUB_TOKEN --force
Enter value for GITHUB_TOKEN (hidden): [new value]
Updated GITHUB_TOKEN in Keychain
```

**Security Notes:**

NEVER do this (exposed in shell history):
```bash
# INSECURE - DON'T DO THIS
store-api-key KEY "plaintext_value"
```

ALWAYS do this instead:
```bash
# SECURE - Interactive prompt
store-api-key KEY

# SECURE - From stdin
echo "value" | store-api-key KEY --stdin
```

#### get-api-key

**Syntax:**
```bash
get-api-key KEY_NAME
```

**Examples:**

```bash
# Retrieve and display
$ get-api-key GITHUB_TOKEN
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Use in environment variable
$ export GITHUB_TOKEN="$(get-api-key GITHUB_TOKEN)"
$ echo $GITHUB_TOKEN
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Use in script
#!/bin/bash
TOKEN="$(get-api-key GITHUB_TOKEN)"
curl -H "Authorization: token $TOKEN" https://api.github.com/user

# Use inline
$ curl -H "Authorization: token $(get-api-key GITHUB_TOKEN)" \
    https://api.github.com/user
```

---

### credmatch

**Purpose:** Encrypted credential storage with search and organization

**Storage:** ~/.credmatch (encrypted file, safe to sync)

**Encryption:** AES-256-CBC with master password

**Platform:** macOS, Linux

#### Commands

```bash
credmatch list [MASTER_PASS]              # List all credentials
credmatch store MASTER_PASS KEY VALUE     # Store credential
credmatch fetch MASTER_PASS KEY           # Retrieve credential
credmatch delete MASTER_PASS KEY          # Delete credential
credmatch search MASTER_PASS PATTERN      # Search by pattern
```

#### Setup

```bash
# First time: store master password in Keychain
$ store-api-key CREDMATCH_MASTER_PASSWORD
Enter value: [create strong password]
Stored in Keychain

# Verify
$ get-api-key CREDMATCH_MASTER_PASSWORD
your-master-password-here
```

#### Examples

**Basic Usage:**

```bash
# Store credentials (using master password from Keychain)
$ MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
$ credmatch store "$MASTER" "github.personal.token" "ghp_xxxxxxxxxxxx"
Stored: github.personal.token

$ credmatch store "$MASTER" "github.work.token" "ghp_yyyyyyyyyyyy"
Stored: github.work.token

# List all credentials
$ credmatch list "$MASTER"
aws.prod.access_key
aws.prod.secret_key
github.personal.token
github.work.token

# Retrieve specific credential
$ credmatch fetch "$MASTER" "github.personal.token"
ghp_xxxxxxxxxxxx

# Search by pattern
$ credmatch search "$MASTER" "github"
github.personal.token
github.work.token

# Delete credential
$ credmatch delete "$MASTER" "old.api.key"
Deleted: old.api.key
```

**Structured Naming:**

Use dot notation for organization:

```bash
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# AWS credentials by environment
credmatch store "$MASTER" "aws.dev.access_key" "AKIAIOSFODNN7EXAMPLE"
credmatch store "$MASTER" "aws.dev.secret_key" "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
credmatch store "$MASTER" "aws.staging.access_key" "AKIAIOSFODNN8EXAMPLE"
credmatch store "$MASTER" "aws.staging.secret_key" "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
credmatch store "$MASTER" "aws.prod.access_key" "AKIAIOSFODNN9EXAMPLE"
credmatch store "$MASTER" "aws.prod.secret_key" "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# GitHub tokens by purpose
credmatch store "$MASTER" "github.personal.api" "ghp_personal_xxxxxx"
credmatch store "$MASTER" "github.work.api" "ghp_work_yyyyyyyy"
credmatch store "$MASTER" "github.ci.token" "ghp_ci_zzzzzzz"

# Database credentials by instance
credmatch store "$MASTER" "db.local.password" "local_pass"
credmatch store "$MASTER" "db.staging.password" "staging_pass"
credmatch store "$MASTER" "db.prod.password" "prod_pass"
```

**Using in Scripts:**

```bash
#!/bin/bash
# Example: AWS environment switcher

set -euo pipefail

MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"

switch_to_env() {
    local env="$1"

    export AWS_ACCESS_KEY_ID="$(credmatch fetch "$MASTER" "aws.$env.access_key")"
    export AWS_SECRET_ACCESS_KEY="$(credmatch fetch "$MASTER" "aws.$env.secret_key")"

    echo "Switched to AWS $env environment"
    echo "Access Key: ${AWS_ACCESS_KEY_ID:0:10}..."
}

# Usage
switch_to_env staging
aws s3 ls  # Uses staging credentials

switch_to_env prod
aws s3 ls  # Uses prod credentials
```

---

### credfile

**Purpose:** Encrypt and store entire files

**Storage:** ~/.credfile/ directory (encrypted files)

**Encryption:** AES-256-CBC via OpenSSL

**Platform:** macOS, Linux (OpenSSL required)

#### Commands

```bash
credfile put KEY FILE_PATH       # Encrypt and store file
credfile get KEY OUTPUT_PATH     # Decrypt and retrieve file
credfile list                    # List stored files
credfile info KEY                # Show file metadata
credfile delete KEY              # Remove stored file
```

#### Setup

```bash
# First time: store master password in Keychain
$ store-api-key CREDFILE_MASTER_PASSWORD
Enter value: [create strong password]
Stored in Keychain

# Verify
$ get-api-key CREDFILE_MASTER_PASSWORD
your-master-password-here
```

#### Examples

**SSH Keys:**

```bash
# Store SSH private key
$ credfile put github_ssh_key ~/.ssh/id_rsa
Encrypted and stored: github_ssh_key
Original file: ~/.ssh/id_rsa (not modified)

# Store multiple SSH keys
$ credfile put gitlab_key ~/.ssh/id_rsa_gitlab
$ credfile put work_bastion_key ~/.ssh/id_rsa_bastion

# List all stored files
$ credfile list
github_ssh_key (encrypted, 1679 bytes)
gitlab_key (encrypted, 1702 bytes)
work_bastion_key (encrypted, 1650 bytes)

# Get file information
$ credfile info github_ssh_key
Key: github_ssh_key
Encrypted size: 1679 bytes
Stored: 2024-01-15 10:30:45
Decrypted size: ~1600 bytes

# Retrieve to temporary location
$ credfile get github_ssh_key /tmp/github_key
Decrypted to: /tmp/github_key

# Use and cleanup
$ chmod 600 /tmp/github_key
$ ssh -i /tmp/github_key git@github.com
$ rm /tmp/github_key

# Restore to original location
$ credfile get github_ssh_key ~/.ssh/id_rsa
Decrypted to: ~/.ssh/id_rsa
```

**SSL Certificates:**

```bash
# Store SSL certificate
$ credfile put prod_ssl_cert /etc/ssl/certs/production.crt
Encrypted and stored: prod_ssl_cert

# Store private key
$ credfile put prod_ssl_key /etc/ssl/private/production.key
Encrypted and stored: prod_ssl_key

# Retrieve for deployment
$ credfile get prod_ssl_cert /deploy/certs/production.crt
$ credfile get prod_ssl_key /deploy/certs/production.key
```

**Configuration Files:**

```bash
# Store Kubernetes config
$ credfile put k8s_prod_config ~/.kube/config
Encrypted and stored: k8s_prod_config

# Store AWS credentials file
$ credfile put aws_credentials ~/.aws/credentials
Encrypted and stored: aws_credentials

# Retrieve on new machine
$ credfile get k8s_prod_config ~/.kube/config
$ credfile get aws_credentials ~/.aws/credentials
```

---

## Common Workflows

### Workflow 1: GitHub Token Management

**Scenario:** Store and use GitHub personal access token

```bash
# Store token
$ store-api-key GITHUB_TOKEN
Enter value: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Stored in Keychain

# Use in script
#!/bin/bash
TOKEN="$(get-api-key GITHUB_TOKEN)"

# Clone private repo
git clone https://$TOKEN@github.com/username/private-repo.git

# Use GitHub API
curl -H "Authorization: token $TOKEN" \
    https://api.github.com/user/repos
```

### Workflow 2: Multi-Environment AWS Setup

**Scenario:** Manage AWS credentials for dev, staging, production

```bash
# Setup (one time)
$ store-api-key CREDMATCH_MASTER_PASSWORD
Enter master password: [hidden]

# Store all AWS credentials
$ MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"

$ credmatch store "$MASTER" "aws.dev.access_key" "AKIA_DEV_KEY"
$ credmatch store "$MASTER" "aws.dev.secret_key" "dev_secret_key"

$ credmatch store "$MASTER" "aws.staging.access_key" "AKIA_STAGING_KEY"
$ credmatch store "$MASTER" "aws.staging.secret_key" "staging_secret_key"

$ credmatch store "$MASTER" "aws.prod.access_key" "AKIA_PROD_KEY"
$ credmatch store "$MASTER" "aws.prod.secret_key" "prod_secret_key"

# Create environment switcher
$ cat > ~/bin/aws-env << 'EOF'
#!/bin/bash
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
ENV="${1:-dev}"

export AWS_ACCESS_KEY_ID="$(credmatch fetch "$MASTER" "aws.$ENV.access_key")"
export AWS_SECRET_ACCESS_KEY="$(credmatch fetch "$MASTER" "aws.$ENV.secret_key")"

echo "Using AWS $ENV credentials"
EOF

$ chmod +x ~/bin/aws-env

# Usage
$ source ~/bin/aws-env staging
Using AWS staging credentials

$ aws s3 ls
[staging buckets]

$ source ~/bin/aws-env prod
Using AWS prod credentials

$ aws s3 ls
[production buckets]
```

### Workflow 3: SSH Key Management

**Scenario:** Manage multiple SSH keys for different services

```bash
# Store SSH keys
$ credfile put github_key ~/.ssh/id_rsa_github
$ credfile put gitlab_key ~/.ssh/id_rsa_gitlab
$ credfile put bastion_key ~/.ssh/id_rsa_bastion

# Create SSH key helper
$ cat > ~/bin/use-ssh-key << 'EOF'
#!/bin/bash
KEY_NAME="$1"
TEMP_KEY="/tmp/ssh_key_$$"

# Retrieve key
credfile get "$KEY_NAME" "$TEMP_KEY"
chmod 600 "$TEMP_KEY"

# Add to ssh-agent
ssh-add "$TEMP_KEY"

# Cleanup
rm "$TEMP_KEY"

echo "Loaded $KEY_NAME into ssh-agent"
EOF

$ chmod +x ~/bin/use-ssh-key

# Usage
$ use-ssh-key github_key
Loaded github_key into ssh-agent

$ git push
[uses github key]

$ use-ssh-key bastion_key
Loaded bastion_key into ssh-agent

$ ssh user@bastion.example.com
[uses bastion key]
```

### Workflow 4: Database Password Rotation

**Scenario:** Rotate database password safely

```bash
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# Store initial password
credmatch store "$MASTER" "db.prod.password" "old_password_123"

# Generate new password
NEW_PASS="$(openssl rand -base64 32)"

# Update database
mysql -h prod-db.example.com -u admin -p"$(credmatch fetch "$MASTER" "db.prod.password")" \
    -e "ALTER USER 'app'@'%' IDENTIFIED BY '$NEW_PASS';"

# Test new password
mysql -h prod-db.example.com -u app -p"$NEW_PASS" -e "SELECT 1;"

# Update credmatch
credmatch store "$MASTER" "db.prod.password" "$NEW_PASS"

# Verify
credmatch fetch "$MASTER" "db.prod.password"

echo "Database password rotated successfully"
```

---

## Security Best Practices

### Master Password Guidelines

**Strength Requirements:**
- Minimum 16 characters
- Mix of uppercase, lowercase, numbers, symbols
- Not used anywhere else
- Not based on dictionary words
- Not personal information (names, dates)

**Good Examples:**
```
Tr0ub4dor&3-Symphony!2024
correct-horse-battery-staple-2024!
kJ#9mP@vL2$qR8nF!xY4wZ7
```

**Bad Examples:**
```
password123            (too simple)
MyName2024            (personal info)
SameAsGitHub          (reused password)
qwerty123             (common pattern)
```

**Generation:**
```bash
# Generate strong random password
$ openssl rand -base64 24
kJ9mP2vL8qR4nF6xY1wZ3aT5bU7cV9

# Generate memorable passphrase
$ shuf -n 4 /usr/share/dict/words | tr '\n' '-'
correct-horse-battery-staple
```

### Rotation Strategy

**Frequency:**
- Master passwords: Annually (or immediately if compromised)
- API keys: Quarterly or on team member departure
- SSH keys: Annually or on device change
- Database passwords: Quarterly for production

**Rotation Process:**

1. Generate new credential
2. Test in staging/development
3. Update production systems
4. Store new credential
5. Verify access with new credential
6. Revoke old credential
7. Document rotation date

**Example Rotation:**
```bash
MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# Rotate API key
OLD_KEY="$(credmatch fetch "$MASTER" "service.api.key")"
NEW_KEY="$(generate_new_key)"  # Service-specific generation

# Test new key
test_api_key "$NEW_KEY"

# Update service
update_service_key "$NEW_KEY"

# Store new key
credmatch store "$MASTER" "service.api.key" "$NEW_KEY"

# Revoke old key
revoke_api_key "$OLD_KEY"

# Document
echo "$(date): Rotated service.api.key" >> ~/.credential-rotations.log
```

### Secure Input Methods

**ALWAYS use secure input methods:**

[SECURE] Interactive prompt (hidden input):
```bash
store-api-key GITHUB_TOKEN
# Prompts securely, no shell history exposure
```

[SECURE] Stdin (for automation):
```bash
echo "$SECRET" | store-api-key KEY --stdin
cat secret.txt | store-api-key KEY --stdin
```

[SECURE] File (for batch operations):
```bash
store-api-key KEY --from-file ~/.secrets/key.txt
```

**NEVER use these insecure methods:**

[INSECURE] Positional arguments:
```bash
# DON'T DO THIS - exposed in shell history and ps
store-api-key KEY "plaintext_secret"
```

**If you've exposed secrets:**
```bash
# Clean shell history
clear-secret-history

# Rotate compromised credentials immediately
```

### Audit and Monitoring

**Regular Audits:**

```bash
# List all credentials in Keychain
security dump-keychain | grep dotfiles

# List all credmatch credentials
credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# List all credfile files
credfile list

# Check for exposed secrets in history
grep -i "password\|secret\|key\|token" ~/.zsh_history
```

**Audit Checklist (Quarterly):**

- [ ] Review all stored credentials
- [ ] Remove unused credentials
- [ ] Rotate high-value credentials
- [ ] Verify master passwords are strong
- [ ] Check for exposed secrets in shell history
- [ ] Test credential retrieval
- [ ] Verify backup procedures
- [ ] Document audit completion

---

## Multi-Machine Setup

### Syncing credmatch Across Machines

**credmatch storage (~/.credmatch) is encrypted and safe to sync**

**Method 1: Dropbox**

```bash
# Machine 1: Copy to Dropbox
$ cp ~/.credmatch ~/Dropbox/secure-credentials/

# Machine 2: Copy from Dropbox
$ cp ~/Dropbox/secure-credentials/.credmatch ~/

# Store same master password on Machine 2
$ store-api-key CREDMATCH_MASTER_PASSWORD
Enter value: [same password as Machine 1]

# Verify access
$ credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"
[shows all credentials from Machine 1]
```

**Method 2: rsync**

```bash
# Machine 1: Sync to remote server
$ rsync -av ~/.credmatch backup-server:/encrypted-files/credmatch

# Machine 2: Sync from remote server
$ rsync -av backup-server:/encrypted-files/credmatch ~/.credmatch

# Store master password
$ store-api-key CREDMATCH_MASTER_PASSWORD

# Verify
$ credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"
```

**Method 3: Git (Private Repo)**

```bash
# Machine 1: Initialize Git repo
$ cd ~
$ git init ~/.credmatch-repo
$ cp ~/.credmatch ~/.credmatch-repo/
$ cd ~/.credmatch-repo
$ git add .credmatch
$ git commit -m "Update credentials"
$ git remote add origin git@github.com:username/private-creds.git
$ git push -u origin main

# Machine 2: Clone
$ git clone git@github.com:username/private-creds.git ~/.credmatch-repo
$ cp ~/.credmatch-repo/.credmatch ~/
$ store-api-key CREDMATCH_MASTER_PASSWORD
```

### Syncing credfile Across Machines

**credfile directory (~/.credfile/) contains encrypted files**

**Method 1: Tar + Dropbox**

```bash
# Machine 1: Create encrypted archive
$ tar -czf credfile-backup.tar.gz ~/.credfile/
$ cp credfile-backup.tar.gz ~/Dropbox/secure-files/

# Machine 2: Extract
$ cp ~/Dropbox/secure-files/credfile-backup.tar.gz ~
$ tar -xzf credfile-backup.tar.gz -C ~/

# Store master password
$ store-api-key CREDFILE_MASTER_PASSWORD

# Verify
$ credfile list
```

**Method 2: rsync**

```bash
# Machine 1: Sync directory
$ rsync -av ~/.credfile/ backup-server:/encrypted-files/credfile/

# Machine 2: Sync from server
$ mkdir -p ~/.credfile
$ rsync -av backup-server:/encrypted-files/credfile/ ~/.credfile/

# Store master password
$ store-api-key CREDFILE_MASTER_PASSWORD

# Verify
$ credfile list
```

### Keychain Sync (macOS)

**iCloud Keychain (Automatic):**

```bash
# Enable on Machine 1
# System Preferences > Apple ID > iCloud > Keychain: ON

# Enable on Machine 2
# System Preferences > Apple ID > iCloud > Keychain: ON

# Credentials sync automatically
# Test:
$ get-api-key GITHUB_TOKEN
[works on both machines]
```

**Manual Export/Import:**

```bash
# Machine 1: Export
$ security export -k login.keychain -t identities -f pkcs12 \
    -o ~/keychain-export.p12
Enter password for export: [create password]

# Machine 2: Import
$ security import ~/keychain-export.p12 -k ~/Library/Keychains/login.keychain
Enter password: [password from export]

# Securely delete export file
$ srm ~/keychain-export.p12
```

---

## Troubleshooting

### Master Password Issues

**Problem: "Master password incorrect"**

```bash
# Verify stored password
$ get-api-key CREDMATCH_MASTER_PASSWORD
your-master-password

# Test manually
$ MASTER="$(get-api-key CREDMATCH_MASTER_PASSWORD)"
$ echo "$MASTER"
[should show password]

# Try listing with explicit password
$ credmatch list "your-master-password"

# If password is wrong, update it
$ store-api-key CREDMATCH_MASTER_PASSWORD --force
Enter new value: [correct password]
```

**Problem: "Master password not found in Keychain"**

```bash
# Store master password
$ store-api-key CREDMATCH_MASTER_PASSWORD
Enter value: [your master password]

# Verify
$ get-api-key CREDMATCH_MASTER_PASSWORD
```

### Keychain Access Issues

**Problem: "Keychain locked"**

```bash
# Unlock default keychain
$ security unlock-keychain ~/Library/Keychains/login.keychain
Enter password: [your login password]

# Verify
$ security show-keychain-info ~/Library/Keychains/login.keychain
```

**Problem: "Permission denied accessing Keychain"**

```bash
# Check Keychain permissions
$ ls -la ~/Library/Keychains/

# Reset Keychain permissions
$ chmod 600 ~/Library/Keychains/login.keychain-db
```

**Problem: "Touch ID not working for credentials"**

```bash
# Configure Touch ID for Keychain
# System Preferences > Touch ID > Use Touch ID for: Keychain

# Or allow specific app
$ security set-key-partition-list -S apple-tool:,apple: \
    -s -k [password] ~/Library/Keychains/login.keychain
```

### credmatch Issues

**Problem: "Cannot decrypt credentials file"**

```bash
# Verify file exists
$ ls -la ~/.credmatch

# Verify master password
$ get-api-key CREDMATCH_MASTER_PASSWORD

# Check file permissions
$ chmod 600 ~/.credmatch

# Test with explicit password
$ credmatch list "your-password"
```

**Problem: "Credential not found"**

```bash
# List all credentials
$ credmatch list "$(get-api-key CREDMATCH_MASTER_PASSWORD)"

# Check exact key name (case-sensitive)
$ credmatch search "$(get-api-key CREDMATCH_MASTER_PASSWORD)" "partial-name"
```

### credfile Issues

**Problem: "Permission denied on ~/.credfile/"**

```bash
# Check directory permissions
$ ls -lad ~/.credfile/

# Fix directory permissions
$ chmod 700 ~/.credfile/

# Fix file permissions
$ chmod 600 ~/.credfile/*
```

**Problem: "Cannot decrypt file"**

```bash
# Verify master password
$ get-api-key CREDFILE_MASTER_PASSWORD

# Check file exists
$ credfile list

# Try manual decryption (debug)
$ openssl enc -d -aes-256-cbc -in ~/.credfile/[key].enc \
    -pass pass:"$(get-api-key CREDFILE_MASTER_PASSWORD)"
```

**Problem: "File corrupted"**

```bash
# Check if backup exists
$ ls -la ~/.credfile/*.bak

# Restore from backup if available
$ cp ~/.credfile/[key].enc.bak ~/.credfile/[key].enc

# Or restore from sync location
$ cp ~/Dropbox/credfile-backup/[key].enc ~/.credfile/
```

### Sync Conflicts

**Problem: "credmatch file conflicts on sync"**

```bash
# On machine with newest data
$ cp ~/.credmatch ~/.credmatch.primary

# On other machine
$ cp ~/.credmatch ~/.credmatch.backup
$ cp [sync-location]/.credmatch ~/.credmatch

# Merge if needed (requires manual credmatch commands)
# List both and re-add missing items
```

**Problem: "credfile sync incomplete"**

```bash
# Verify all files synced
$ credfile list > /tmp/expected_files.txt

# On other machine
$ credfile list > /tmp/actual_files.txt

# Compare
$ diff /tmp/expected_files.txt /tmp/actual_files.txt

# Re-sync missing files
$ rsync -av ~/.credfile/ other-machine:~/.credfile/
```

### General Issues

**Problem: "Command not found: store-api-key"**

```bash
# Verify bin/ in PATH
$ echo $PATH | grep -q "$(pwd)/bin" || echo "Not in PATH"

# Add to PATH
$ export PATH="$HOME/.dotfiles/bin/core:$PATH"

# Or reload shell
$ exec zsh
```

**Problem: "OpenSSL not found (credfile)"**

```bash
# Install OpenSSL
# macOS:
$ brew install openssl

# Linux:
$ sudo apt-get install openssl

# Verify
$ openssl version
```

---

## Additional Resources

### Related Documentation
- [Script Quick Reference](../scripts/quick-reference.md) - Quick command reference
- [ONBOARDING.md](../../ONBOARDING.md) - Complete system onboarding
- [Security Best Practices](../../MINDSET.MD) - Project security guidelines

### External Resources
- [macOS Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
- [OpenSSL Encryption](https://www.openssl.org/docs/man1.1.1/man1/openssl-enc.html)
- [Password Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)

### Getting Help
- Interactive help: `dotfiles-help`
- Script help: `store-api-key --help`, `credmatch --help`, `credfile --help`
- Troubleshooting: See section above
- Issues: Open GitHub issue with details
