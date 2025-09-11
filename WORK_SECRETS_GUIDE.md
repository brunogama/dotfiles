# Work Secrets Management Guide

## 🎉 Setup Complete!

Your daily work secrets management system is now installed and ready to use. This system provides secure, convenient access to your work credentials using macOS Keychain integration.

## 🚀 Quick Start

### 1. Store Your First Work Secret
```bash
# Store an API key
ws-store COMPANY_API_KEY "your-secret-api-key-here"

# Store a database URL
ws-store DATABASE_URL "postgresql://user:pass@host:5432/dbname"

# Store any work credential
ws-store SLACK_TOKEN "xoxb-your-slack-bot-token"
```

### 2. Load Work Secrets Into Your Environment
```bash
# Load all work secrets
ws

# Or use the full command
load-work-secrets

# Load secrets matching a specific pattern
load-work-secrets ".*COMPANY.*"
```

### 3. Use Your Secrets
```bash
# After loading, your secrets are available as environment variables
echo $COMPANY_API_KEY
curl -H "Authorization: Bearer $COMPANY_API_KEY" https://api.company.com/data
```

## 📋 Available Commands

| Command | Alias | Description |
|---------|-------|-------------|
| `load-work-secrets` | `ws` | Load work secrets into environment |
| `list-work-secrets` | `ws-list` | Show available work secrets |
| `store-work-secret` | `ws-store` | Store a new work secret |
| `get-work-secret` | `ws-get` | Get a specific secret value |
| `work-profile` | - | Switch between work environments |
| `backup-work-secrets` | `ws-backup` | Backup secrets to credmatch |
| `sync-work-secrets` | `ws-sync` | Sync secrets from credmatch |

## 🔄 Environment Profiles

Switch between different work environments:

```bash
# Load development secrets
work-profile dev

# Load production secrets  
work-profile prod

# Load staging secrets
work-profile staging

# Load all work secrets (default)
work-profile default
```

## 🔐 Security Features

### Local Storage (Primary)
- **Keychain Integration**: Secrets stored in macOS Keychain with OS-level encryption
- **Biometric Access**: Use Touch ID/Face ID for secure access
- **No Plaintext**: Secrets never stored in plaintext files

### Backup/Sync (Secondary)
- **Encrypted Git Storage**: Use `credmatch` for encrypted backup to private Git repos
- **AES-256 Encryption**: Military-grade encryption with your master password
- **Version Control**: Track changes to your secrets over time

## 📖 Usage Examples

### Daily Workflow
```bash
# Start your day - load work secrets
ws

# Your secrets are now available
echo "API Key: $COMPANY_API_KEY"
echo "Database: $DATABASE_URL"

# Use in scripts
psql "$DATABASE_URL" -c "SELECT * FROM users LIMIT 5;"
```

### Storing Different Types of Secrets
```bash
# API Keys
ws-store GITHUB_API_KEY "ghp_xxxxxxxxxxxx"
ws-store OPENAI_API_KEY "sk-xxxxxxxxxxxx"

# Database URLs
ws-store PROD_DATABASE_URL "postgresql://..."
ws-store DEV_DATABASE_URL "postgresql://..."

# Service Tokens
ws-store SLACK_BOT_TOKEN "xoxb-xxxxxxxxxxxx"
ws-store DISCORD_TOKEN "xxxxxxxxxxxx"

# Custom Secrets
ws-store ENCRYPTION_KEY "your-encryption-key"
ws-store JWT_SECRET "your-jwt-secret"
```

### Environment-Specific Secrets
```bash
# Store environment-specific secrets
ws-store COMPANY_DEV_API_KEY "dev-key-here"
ws-store COMPANY_PROD_API_KEY "prod-key-here"

# Load only development secrets
work-profile dev
echo $COMPANY_DEV_API_KEY

# Switch to production
work-profile prod  
echo $COMPANY_PROD_API_KEY
```

### Backup and Sync
```bash
# Set up credmatch for backup (one-time setup)
credmatch init git@gitlab.com:yourusername/work-secrets.git

# Backup your Keychain secrets to encrypted git storage
ws-backup "your-master-password"

# On a new machine, sync secrets from credmatch to Keychain
ws-sync "your-master-password"

# Then load them into your environment
ws
```

## 🔧 Configuration

### Auto-Load on Shell Startup
To automatically load work secrets when you start a new terminal:

1. Edit `~/.config/zsh/work-config.zsh`
2. Uncomment this line:
   ```bash
   # load-work-secrets "" "true" &>/dev/null
   ```

### Custom Secret Patterns
Modify the default pattern in `work-config.zsh`:
```bash
# Current default pattern matches:
# - *API_KEY, *_TOKEN, *_URL, *_SECRET

# You can customize it for your needs
load-work-secrets ".*COMPANY.*|.*DATABASE.*|.*SLACK.*"
```

## 🚨 Security Best Practices

### ✅ DO
- Use strong, unique passwords for your master password (credmatch)
- Regularly rotate your API keys and secrets
- Use environment-specific secrets (dev/staging/prod)
- Keep your macOS and Keychain updated
- Use biometric authentication when available

### ❌ DON'T
- Store secrets in plaintext files
- Commit secrets to Git repositories (even private ones)
- Share your master password
- Use the same secrets across environments
- Store secrets in browser password managers for work

## 🆘 Troubleshooting

### Command Not Found
```bash
# Make sure ~/bin is in your PATH
echo $PATH | grep -o "$HOME/bin"

# If not found, restart your terminal or run:
source ~/.zshrc
```

### Access Denied
```bash
# Keychain access might be locked
# You'll be prompted for your macOS password or Touch ID
ws-list
```

### No Secrets Found
```bash
# Check if you have any secrets stored
security dump-keychain | grep -i api_key

# Store your first secret
ws-store TEST_API_KEY "test-value"
```

## 🔄 Migration from Other Systems

### From Environment Files (.env)
```bash
# If you have a .env file, migrate like this:
while IFS='=' read -r key value; do
    [[ $key =~ ^[A-Z_]+$ ]] && ws-store "$key" "$value"
done < .env
```

### From 1Password CLI
```bash
# If you use 1Password CLI, you can migrate:
op item list --categories Login | while read item; do
    # Extract and store secrets
    # (customize based on your 1Password structure)
done
```

## 📞 Support

If you encounter issues:

1. Check the functions are loaded: `type ws`
2. Verify PATH includes ~/bin: `echo $PATH`
3. Test Keychain access: `security find-generic-password -s "test"`
4. Restart your terminal and try again

---

**🎉 You're all set!** Start by storing your first work secret:
```bash
ws-store COMPANY_API_KEY "your-api-key-here"
```

Then load it into your environment:
```bash
ws
echo $COMPANY_API_KEY
```
