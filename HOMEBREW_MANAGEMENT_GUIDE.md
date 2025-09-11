# 🍺 Homebrew Package Management Guide

Your Homebrew packages are now fully managed through your Stow-based dotfiles system!

## 🎉 **What's Been Set Up**

### ✅ **Homebrew Stow Package**

- **Location:** `stow-packages/homebrew/`
- **Brewfile:** `~/.config/homebrew/Brewfile` (170+ packages synced)
- **Management Script:** `brew-sync` (available in PATH)

### ✅ **Current System Status**

- **Packages in Brewfile:** 170+ (taps, brews, casks, vscode extensions)
- **System Status:** ✅ **IN SYNC** - Brewfile matches installed packages
- **Backup System:** Automatic backups in `~/.homebrew-backups/`

## 🚀 **How to Use**

### **Daily Commands**

```bash
# Quick aliases (available after sourcing work-config)
brew-install        # Install packages from Brewfile
brew-update         # Update Brewfile from system
brew-full-sync      # Full sync (update + install)

# Full commands
brew-sync install   # Install from Brewfile
brew-sync update    # Update Brewfile from system
brew-sync sync      # Full bidirectional sync
brew-sync diff      # Show differences
brew-sync clean     # Remove unlisted packages
brew-sync doctor    # System health check
```

### **Workflow Examples**

#### **On This Machine (Adding New Software)**

```bash
# Install something new
brew install new-package

# Update your Brewfile to include it
brew-update

# Commit the change
cd ~/.config && git add . && git commit -m "feat: add new-package"
```

#### **On a New Machine**

```bash
# Clone your dotfiles
git clone <your-repo> ~/.config
cd ~/.config

# Install the homebrew package
./install.sh homebrew

# Install all your software
brew-install

# You now have all 170+ packages installed!
```

#### **Team Synchronization**

```bash
# Pull latest changes from team
cd ~/.config && git pull

# Install any new packages others added
brew-install

# Add your own packages
brew install my-new-tool
brew-update

# Share with team
git add . && git commit -m "feat: add my-new-tool"
git push
```

## 📦 **What's in Your Brewfile**

### **Package Categories (170+ total)**

- **Core Tools:** git, curl, zsh, coreutils
- **Development:** python, node, swift tools, xcode utilities
- **File Processing:** bat, eza, ripgrep, fzf, jq
- **Git Tools:** git-extras, git-flow, git-secrets, gitleaks
- **GUI Apps:** VSCode, Fork, Postman, Rectangle, Raycast
- **Fonts:** JetBrains Mono, IA Writer Mono
- **VSCode Extensions:** 30+ extensions for development

### **Organized Structure**

Your Brewfile includes:

- **Taps:** Custom repositories
- **Brews:** Command-line tools
- **Casks:** GUI applications
- **VSCode Extensions:** Editor extensions

## 🔄 **Maintenance Workflows**

### **Weekly Maintenance**

```bash
# Check system health
brew-sync doctor

# Update packages
brew upgrade

# Sync any changes
brew-full-sync
```

### **Before Major Changes**

```bash
# Check current status
brew-sync diff

# Create explicit backup
brew-sync backup

# Make changes...
brew install lots-of-new-stuff

# Update Brewfile
brew-update
```

### **Cleanup Unused Packages**

```bash
# See what would be removed
brew-sync diff

# Remove packages not in Brewfile (careful!)
brew-sync clean
```

## 🛠️ **Advanced Usage**

### **Machine-Specific Brewfiles**

Create different Brewfiles for different machine types:

```bash
# Copy base Brewfile
cp ~/.config/homebrew/Brewfile ~/.config/homebrew/Brewfile.work
cp ~/.config/homebrew/Brewfile ~/.config/homebrew/Brewfile.personal

# Edit for specific needs
# Work machine - remove games, add enterprise tools
# Personal machine - remove work-specific tools

# Install specific version
brew bundle install --file ~/.config/homebrew/Brewfile.work
```

### **Selective Installation**

```bash
# Install only specific categories
brew bundle install --file ~/.config/homebrew/Brewfile --no-lock --cask
brew bundle install --file ~/.config/homebrew/Brewfile --no-lock --brew
```

## 🚨 **Troubleshooting**

### **Conflicts During Installation**

```bash
# Check what's different
brew-sync diff

# Force update Brewfile to match system
brew-sync update

# Or force install from Brewfile
brew bundle install --file ~/.config/homebrew/Brewfile --force
```

### **Brewfile Not Found**

```bash
# Make sure homebrew package is installed
./install.sh homebrew

# Check if symlink exists
ls -la ~/.config/homebrew/Brewfile
```

### **brew-sync Command Not Found**

```bash
# Check if bin package is installed
./install.sh bin

# Or install homebrew package which includes brew-sync
./install.sh homebrew

# Reload shell
source ~/.zshrc
```

## 📊 **System Overview**

### **Current Status**

- ✅ **170+ packages** managed in Brewfile
- ✅ **System in sync** - no differences between Brewfile and installed
- ✅ **Automatic backups** enabled
- ✅ **Integration** with Stow-based dotfiles
- ✅ **Team sharing** ready via Git

### **Key Benefits**

1. **🎯 Reproducible Environments** - Same software on all machines
2. **👥 Team Synchronization** - Share package lists via Git
3. **🔄 Easy Maintenance** - One command to sync everything
4. **💾 Backup Protection** - Never lose your package configuration
5. **🏗️ New Machine Setup** - Install 170+ packages with one command

## 🎯 **Next Steps**

1. **✅ Test on this machine** - Try `brew-sync diff` and `brew-install`
2. **📝 Customize** - Edit the Brewfile to add/remove packages as needed
3. **🔄 Set up routine** - Weekly `brew upgrade && brew-full-sync`
4. **👥 Share with team** - Push your Brewfile to help others
5. **🖥️ Test on new machine** - Ultimate validation of your setup

---

**🎉 Your Homebrew packages are now as organized as your dotfiles!**

No more manually tracking what's installed where - everything is code, versioned, and reproducible. 🚀
