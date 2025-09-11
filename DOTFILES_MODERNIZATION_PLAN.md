# Dotfiles Modernization Plan

## 🎯 **Current vs. Recommended Setup**

### **Current Setup (Basic Git Repo)**
```
~/.config/
├── zsh/
├── git/
├── bin/
└── ... (all mixed together)
```

### **Recommended Setup (GNU Stow)**
```
~/dotfiles/
├── zsh/
│   └── .config/
│       └── zsh/
│           ├── .zshrc -> ../../../zsh/.config/zsh/.zshrc
│           └── work-config.zsh
├── git/
│   └── .config/
│       └── git/
│           └── .gitconfig
├── bin/
│   └── .local/
│       └── bin/
│           ├── credmatch
│           └── dump-api-keys
└── scripts/
    ├── install.sh
    └── sync.sh
```

## 🚀 **Why GNU Stow is Superior**

### **1. Organization by Purpose**
```bash
# Install only what you need per machine
stow zsh          # Just shell config
stow git          # Just git config  
stow bin          # Just scripts
stow work         # Work-specific configs
```

### **2. Clean Symlinks**
- No bare repo complexity
- Clear what's managed vs. not managed
- Easy to see what's linked: `ls -la ~/.zshrc`

### **3. Machine-Specific Configs**
```bash
# Different configs per machine
stow zsh-personal    # Personal machine
stow zsh-work       # Work machine
stow zsh-server     # Server configs
```

### **4. Easy Maintenance**
```bash
# Add new config
mkdir -p new-app/.config/new-app
echo "config" > new-app/.config/new-app/config.yml
stow new-app

# Remove config
stow -D old-app
```

## 🔄 **Migration Strategy**

### **Option A: Restructure Current Repo (RECOMMENDED)**
1. Reorganize your current `.config` repo with Stow structure
2. Keep all your existing configs and scripts
3. Add Stow-based installation scripts
4. Maintain backward compatibility

### **Option B: Fresh Start**
1. Create new `~/dotfiles` repo with Stow structure
2. Migrate configs selectively
3. More work but cleaner result

## 🛠️ **Implementation Plan**

### **Phase 1: Restructure Current Repo**
```bash
cd ~/.config
mkdir -p stow-packages/{zsh,git,bin,scripts}

# Move configs to Stow packages
mv zsh/ stow-packages/zsh/.config/
mv git/ stow-packages/git/.config/
mv bin/ stow-packages/bin/.local/
```

### **Phase 2: Create Installation Scripts**
- `install.sh` - One-command setup for new machines
- `sync.sh` - Update configs across machines
- `bootstrap.sh` - Install dependencies

### **Phase 3: Add Machine Profiles**
- Personal machine profile
- Work machine profile  
- Server profile

## 📋 **Alternative Options**

### **2. Chezmoi (Good for Complex Setups)**
- ✅ **Template system** - Different configs per machine
- ✅ **Encrypted secrets** - Built-in secret management
- ✅ **Cross-platform** - Works on Windows/Linux/macOS
- ❌ **More complex** - Steeper learning curve

### **3. Dotbot (Automation Focus)**
- ✅ **Declarative config** - YAML-based setup
- ✅ **Plugin system** - Extensible
- ❌ **Less popular** - Smaller community

### **4. Home Manager (Nix Users)**
- ✅ **Reproducible** - Nix-based declarative configs
- ✅ **Rollbacks** - Easy to revert changes
- ❌ **Nix required** - Need to learn Nix

## 🎯 **Recommendation: Stick with GNU Stow**

**For your use case, GNU Stow is perfect because:**

1. ✅ **You already have it installed**
2. ✅ **Simple and reliable**
3. ✅ **Great for your organized configs**
4. ✅ **Easy to understand and maintain**
5. ✅ **Works perfectly with your existing scripts**

## 🚀 **Next Steps**

1. **Restructure** your current repo with Stow packages
2. **Create** installation and sync scripts
3. **Test** on a secondary machine
4. **Document** the new workflow

Would you like me to implement this restructuring for you?
