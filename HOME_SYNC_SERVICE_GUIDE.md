# 🔄 Home Environment & Credentials Sync Service

Your home environment now has a comprehensive sync service that automatically keeps your dotfiles, credentials, and environment settings synchronized across all your machines!

## 🎉 **What's Been Created**

### ✅ **Home Sync Service**

- **Main Command:** `home-sync` - Complete environment synchronization
- **Service Manager:** `home-sync-service` - macOS LaunchAgent management
- **Configuration:** `~/.config/sync-service/config.yml`
- **Logs:** `~/.config/sync-service/logs/`

### ✅ **Automatic Synchronization**

- **Dotfiles:** Stow packages, configurations, scripts
- **Credentials:** Keychain secrets via credmatch encrypted backup
- **Homebrew:** Package lists and installations
- **Environment:** Shell configurations and work settings

## 🚀 **Quick Start**

### **1. Configure Your Master Password**

```bash
# Edit the configuration file
nano ~/.config/sync-service/config.yml

# Set your credential master password (required for credential sync)
# credential_master_password: "your-secure-master-password-here"
```

### **2. Test the Sync (Dry Run)**

```bash
# Test what would be synced
home-sync sync --dry-run

# Test credential sync
home-sync credentials --dry-run
```

### **3. Perform Your First Sync**

```bash
# Full sync (dotfiles + credentials)
home-sync sync

# Or use the convenient alias
home-sync-up
```

### **4. Install as Background Service**

```bash
# Install the macOS LaunchAgent
home-sync-service install

# Check service status
sync-status
```

## 🛠️ **Available Commands**

### **Main Sync Commands**

```bash
# Core operations
home-sync sync          # Full sync (dotfiles + credentials)
home-sync dotfiles      # Sync only dotfiles
home-sync credentials   # Sync only credentials
home-sync push          # Push local changes to remote
home-sync pull          # Pull remote changes
home-sync status        # Show sync status

# Convenient aliases (available after installing zsh package)
home-sync-up           # Same as: home-sync sync
home-push              # Same as: home-sync push
home-pull              # Same as: home-sync pull
home-status            # Same as: home-sync status
```

### **Service Management**

```bash
# Service control
home-sync-service install    # Install background service
home-sync-service start      # Start service
home-sync-service stop       # Stop service
home-sync-service restart    # Restart service
home-sync-service status     # Service status
home-sync-service logs       # View logs

# Convenient aliases
sync-start             # Start service
sync-stop              # Stop service
sync-status            # Service status
```

### **Options & Flags**

```bash
# Common options
--dry-run              # Show what would be done
--force                # Force sync even with conflicts
--quiet, -q            # Suppress output
--verbose, -v          # Verbose output

# Examples
home-sync sync --dry-run     # Preview sync
home-sync push --force       # Force push changes
home-sync pull --quiet       # Silent pull
```

## 🔄 **How It Works**

### **Sync Components**

#### **1. Dotfiles Sync**

- Pulls latest changes from your dotfiles Git repository
- Re-stows Stow packages to update symlinks
- Commits any local changes before syncing
- Handles conflicts intelligently

#### **2. Credentials Sync**

- Uses your existing `credmatch` encrypted storage system
- Syncs secrets between macOS Keychain and Git storage
- Requires master password for encryption/decryption
- Maintains security through encrypted transport

#### **3. Environment Sync**

- Synchronizes shell configurations
- Updates Homebrew package lists
- Syncs work environment settings
- Maintains machine-specific profiles

### **Background Service**

- Runs as macOS LaunchAgent
- Automatic sync every hour (configurable)
- Low priority to avoid interfering with work
- Comprehensive logging for troubleshooting

## 📋 **Configuration**

### **Configuration File: `~/.config/sync-service/config.yml`**

```yaml
# Sync interval in seconds (default: 3600 = 1 hour)
sync_interval: 3600

# Backup retention in days (default: 30)
backup_retention: 30

# Credential master password (REQUIRED for credential sync)
credential_master_password: "your-secure-master-password"

# Enable remote backup of credentials
remote_backup_enabled: true

# Auto-push changes after sync
auto_push_enabled: true

# Notification settings
notifications_enabled: true

# Sync filters (what to sync)
sync_dotfiles: true
sync_credentials: true
sync_homebrew: true

# Machine-specific settings
machine_profile: "default" # default, work, personal, server
```

### **Key Settings**

- **`credential_master_password`** - Required for credential synchronization
- **`sync_interval`** - How often the background service syncs (seconds)
- **`auto_push_enabled`** - Whether to automatically push changes
- **`machine_profile`** - Different sync behavior per machine type

## 🖥️ **Multi-Machine Workflow**

### **Setting Up a New Machine**

```bash
# 1. Clone your dotfiles
git clone https://github.com/brunogama/dotfiles.git ~/.config
cd ~/.config

# 2. Install essential packages
./install.sh zsh git bin sync-service

# 3. Configure sync service
home-sync setup
# Edit ~/.config/sync-service/config.yml (set master password)

# 4. Perform initial sync
home-sync sync

# 5. Install background service
home-sync-service install

# 6. Install remaining packages as needed
./install.sh homebrew shell-tools development macos
```

### **Daily Workflow**

```bash
# Morning: Pull latest changes
home-pull

# Work with your environment...

# Evening: Push your changes
home-push

# Or just let the background service handle it automatically!
```

### **Machine-Specific Configurations**

```bash
# Work machine
echo 'machine_profile: "work"' >> ~/.config/sync-service/config.yml

# Personal machine
echo 'machine_profile: "personal"' >> ~/.config/sync-service/config.yml

# Server
echo 'machine_profile: "server"' >> ~/.config/sync-service/config.yml
```

## 🔐 **Security Features**

### **Credential Protection**

- ✅ **Encrypted Storage** - All credentials encrypted with AES-256-CBC
- ✅ **Master Password** - Single password protects all secrets
- ✅ **Keychain Integration** - Uses macOS Keychain for local storage
- ✅ **Secure Transport** - Git over SSH for credential backup
- ✅ **No Plaintext** - Secrets never stored in plaintext

### **Access Control**

- ✅ **Process Locking** - Prevents concurrent sync operations
- ✅ **Permission Checks** - Validates file permissions
- ✅ **Secure Defaults** - Conservative security settings
- ✅ **Audit Logging** - Complete operation logging

## 📊 **Monitoring & Troubleshooting**

### **Check Service Health**

```bash
# Overall status
home-sync status

# Service status
sync-status

# View logs
home-sync-service logs

# Manual sync test
home-sync sync --dry-run --verbose
```

### **Common Issues**

#### **Credential Sync Fails**

```bash
# Check master password is set
cat ~/.config/sync-service/config.yml | grep credential_master_password

# Test credential commands manually
ws-list                    # List stored secrets
credmatch status          # Check credmatch repository
```

#### **Service Won't Start**

```bash
# Check service status
home-sync-service status

# Reinstall service
home-sync-service uninstall
home-sync-service install

# Check logs for errors
home-sync-service logs
```

#### **Sync Conflicts**

```bash
# Force sync (careful!)
home-sync sync --force

# Check git status
cd ~/.config && git status

# Manual resolution
cd ~/.config && git pull --rebase
```

## 🎯 **Advanced Usage**

### **Custom Sync Intervals**

```bash
# Edit config for different intervals
nano ~/.config/sync-service/config.yml

# 15 minutes: sync_interval: 900
# 30 minutes: sync_interval: 1800
# 2 hours: sync_interval: 7200
# Daily: sync_interval: 86400
```

### **Selective Syncing**

```bash
# Disable credential sync for this machine
sed -i 's/sync_credentials: true/sync_credentials: false/' ~/.config/sync-service/config.yml

# Disable auto-push
sed -i 's/auto_push_enabled: true/auto_push_enabled: false/' ~/.config/sync-service/config.yml
```

### **Manual Credential Operations**

```bash
# Backup credentials manually
ws-backup "your-master-password"

# Sync credentials manually
ws-sync "your-master-password"

# List current secrets
ws-list
```

## 📈 **Benefits**

### **🎯 Consistency**

- Same environment on all machines
- Synchronized credentials and settings
- Consistent package installations
- Unified development setup

### **🔄 Automation**

- Background synchronization
- Automatic conflict resolution
- Self-healing configurations
- Hands-off maintenance

### **🛡️ Security**

- Encrypted credential storage
- Secure transport protocols
- Audit trails and logging
- Access control mechanisms

### **⚡ Efficiency**

- One-command setup for new machines
- Automatic environment updates
- Centralized configuration management
- Reduced manual synchronization

## 🚀 **Next Steps**

1. **✅ Configure Master Password** - Edit `~/.config/sync-service/config.yml`
2. **🧪 Test Sync** - Run `home-sync sync --dry-run`
3. **🔄 First Sync** - Run `home-sync sync`
4. **⚙️ Install Service** - Run `home-sync-service install`
5. **📱 Test New Machine** - Clone and sync on another machine

---

**🎉 Your home environment is now fully automated and synchronized!**

No more manual copying of configurations or losing track of credentials across machines. Everything is automated, secure, and reliable. 🏠✨
