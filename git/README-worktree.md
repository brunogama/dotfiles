# Git Worktree Quality of Life Tools

A comprehensive suite of tools and scripts to enhance the developer experience when working with Git worktrees. These tools provide seamless worktree management, intelligent workflow automation, and advanced productivity features.

## 🌟 Key Features

### 🚀 **Enhanced Worktree Management**
- **Rich Status Display**: Shows commit info, tracking status, author, and age
- **Recent History**: Frecency-based access to recently used worktrees
- **Workspace State Persistence**: Automatically saves and restores working directory context
- **Smart Safety Checks**: Prevents data loss with comprehensive validation

### 🎯 **Interactive User Interface**
- **FZF Integration**: Fuzzy finding with live previews and batch operations
- **Colorized Output**: Clear visual indicators for status and actions
- **Progress Feedback**: Real-time updates during operations
- **Contextual Help**: Built-in guidance and error messages

### 🔧 **Advanced Automation**
- **Tmux Integration**: Automatic session management with project-specific layouts
- **Git Hooks**: Quality checks, environment setup, and lifecycle management
- **Resource Management**: Port allocation and conflict detection
- **Bulk Operations**: Multi-worktree cleanup and synchronization

### 🌐 **Workflow Integration**
- **Shell Enhancement**: Aliases, functions, and prompt integration
- **IDE Support**: VS Code, Vim, and terminal optimization
- **Team Collaboration**: Shared configurations and conventions
- **Analytics**: Usage insights and productivity metrics

## 🚀 Quick Start

1. **Install the hooks and configuration:**
   ```bash
   chmod +x scripts/install-worktree-hooks.sh
   ./scripts/install-worktree-hooks.sh
   ```

2. **Source the configuration:**
   ```bash
   source ~/.gitconfig-worktree
   source ~/.git-worktree-integration
   ```

3. **Initialize worktree structure:**
   ```bash
   ./scripts/git-worktree-manager.sh init
   ```

4. **Create your first worktree:**
   ```bash
   ./scripts/git-worktree-manager.sh create feature/my-awesome-feature
   ```

## 📁 Directory Structure

```
scripts/
├── git-worktree-manager.sh     # Core worktree management script
├── git-aliases.sh              # Enhanced Git aliases and functions
├── worktree-fzf.sh            # Interactive fuzzy finder integration
├── worktree-tmux.sh           # Tmux session management
├── install-worktree-hooks.sh  # Installation and setup script
└── git-hooks/
    ├── post-checkout           # Enhanced checkout experience
    └── pre-commit             # Quality checks before commits
```

## 🛠️ Core Tools

### Git Worktree Manager (`git-worktree-manager.sh`)

The core worktree management script with advanced productivity features:

```bash
# Create new worktree with automatic history tracking
./scripts/git-worktree-manager.sh create feature/auth-system

# Switch with workspace state persistence
./scripts/git-worktree-manager.sh switch feature/auth-system

# Enhanced list with rich information
./scripts/git-worktree-manager.sh list

# Show recent worktrees with frecency-based sorting
./scripts/git-worktree-manager.sh recent

# Safe removal with comprehensive checks
./scripts/git-worktree-manager.sh remove feature/auth-system

# Intelligent cleanup of merged branches
./scripts/git-worktree-manager.sh clean
```

**Enhanced Features:**
- 📊 **Rich Status Display**: Shows commit hash, message, author, age, and tracking status
- 🕒 **Recent History**: Tracks and displays recently accessed worktrees
- 💾 **State Persistence**: Saves/restores working directory and context
- 🎨 **Enhanced UI**: Colorized output with clear visual hierarchy
- 🔒 **Advanced Safety**: Multi-level validation and rollback capabilities
- ⚡ **Performance**: Optimized operations with intelligent caching

### Interactive FZF Integration (`worktree-fzf.sh`)

Fuzzy finder integration for interactive worktree management:

```bash
# Interactive worktree switcher
./scripts/worktree-fzf.sh switch

# Interactive worktree creator
./scripts/worktree-fzf.sh create

# Interactive menu
./scripts/worktree-fzf.sh menu
```

**Features:**
- 🔍 Fuzzy search through worktrees and branches
- 👁️ Live preview with git status and history
- ⚡ Fast navigation and selection
- 🎯 Multi-select support for batch operations

### Tmux Integration (`worktree-tmux.sh`)

Automatic tmux session management for worktrees:

```bash
# Create tmux session for worktree
./scripts/worktree-tmux.sh create feature/auth-system

# Attach to existing session
./scripts/worktree-tmux.sh attach feature/auth-system

# Interactive session selector
./scripts/worktree-tmux.sh interactive
```

**Features:**
- 🖥️ Automatic session creation with project-specific windows
- 🔧 Smart project detection (Node.js, Rust, Python, etc.)
- 🧹 Cleanup of stale sessions
- 📋 Session listing and management

## 🎣 Git Hooks

### Post-Checkout Hook

Automatically runs after checking out a branch in a worktree:

- 🏷️ Updates terminal title with branch name
- 📊 Shows worktree status
- 📦 Suggests dependency installation if needed
- 📜 Displays recent commits and working directory status

### Pre-Commit Hook

Quality checks before each commit:

- 🔍 Detects merge conflict markers
- ⚠️ Warns about debug statements (console.log, TODO, etc.)
- 🧹 Optional linting integration
- ✅ Optional test execution
- 📝 Conventional commit format checking

## 🎯 Aliases and Functions

### Core Aliases

```bash
# Worktree manager shortcuts
alias wt='./scripts/git-worktree-manager.sh'
alias wtc='./scripts/git-worktree-manager.sh create'
alias wts='./scripts/git-worktree-manager.sh switch'
alias wtl='./scripts/git-worktree-manager.sh list'

# Enhanced Git aliases
alias gs='git status --short'
alias gst='git status'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
```

### Enhanced Functions

```bash
# Switch or create worktree
wtswitch <branch>

# Create feature branch worktree
wtfeature <feature-name>

# Create hotfix branch worktree
wthotfix <hotfix-name>

# Quick commit and push
wtpush <commit-message>

# Sync all worktrees
wtsyncall

# Show worktree summary
wtsummary
```

## ⚙️ Configuration

### Environment Variables

```bash
# Core Configuration
export WORKTREE_BASE_DIR="$(git rev-parse --show-toplevel)/../worktrees"
export DEFAULT_BRANCH="main"

# Enhanced Features
export WORKTREE_HISTORY_SIZE=20        # Recent worktrees to remember
export WORKTREE_STATE_ENABLED=true     # Enable workspace state persistence

# Hook Behavior
export WORKTREE_HOOKS_ENABLED=true
export WORKTREE_LINT_ENABLED=true
export WORKTREE_TEST_ENABLED=false

# Tmux Integration
export TMUX_SESSION_PREFIX="wt"
export TMUX_WINDOW_LAYOUT="main-vertical"

# Debug and Development
export WORKTREE_DEBUG=false            # Enable verbose output
```

### Git Configuration

The installation script automatically adds these git aliases:

```bash
git config --global alias.wt-list 'worktree list'
git config --global alias.wt-add 'worktree add'
git config --global alias.wt-remove 'worktree remove'
git config --global alias.wt-prune 'worktree prune'
```

## 🔧 Advanced Usage

### Enhanced Status Display

The enhanced `list` command shows comprehensive worktree information:

```bash
./scripts/git-worktree-manager.sh list
```

**Output includes:**
- 📊 Git status (changes, ahead/behind counts)
- 💬 Last commit hash and message
- 👤 Last commit author
- 📅 Age of last commit
- 🎯 Current worktree indicator

### Recent Worktrees History

Access recently used worktrees with frecency-based sorting:

```bash
# Show recent worktrees
./scripts/git-worktree-manager.sh recent

# Quick switch using FZF integration
./scripts/worktree-fzf.sh switch
```

**Features:**
- Tracks last 20 worktrees by default (configurable)
- Shows last access time
- Filters by current repository
- Automatic cleanup of stale entries

### Workspace State Persistence

Automatically saves and restores workspace context:

```bash
# State is automatically saved when switching
./scripts/git-worktree-manager.sh switch feature/other-branch

# Context restored when switching back
./scripts/git-worktree-manager.sh switch feature/auth-system
```

**Saved State Includes:**
- Working directory path
- Git status snapshot
- Timestamp information
- Shell environment

### Custom Worktree Structure

Customize worktree organization:

```bash
export WORKTREE_BASE_DIR="/path/to/your/worktrees"
```

### IDE Integration

**VS Code Integration:**
```bash
# Open worktree in VS Code
code $(./scripts/git-worktree-manager.sh cd feature/auth-system)

# Create VS Code workspace file
cat > .vscode/workspace.json << EOF
{
  "folders": [
    { "path": "../worktrees/myproject/feature-auth" },
    { "path": "../worktrees/myproject/feature-api" }
  ]
}
EOF
```

**Vim/Neovim Integration:**
```bash
# Save session state
vim -c "mksession! ~/.vim/sessions/worktree-$(git branch --show-current).vim"
```

### Shell Integration

Enhanced shell integration with context awareness:

```bash
# Load worktree configuration
source ~/.gitconfig-worktree
source ~/.git-worktree-integration

# Enhanced prompt with worktree info
PS1='${PS1}$(worktree_prompt_info)'

# Quick navigation with state restoration
wtcd() {
    eval "$(./scripts/git-worktree-manager.sh cd "$1")"
}

# Recent worktree quick access
wtr() {
    local branch
    branch=$(./scripts/git-worktree-manager.sh recent | fzf | awk '{print $1}')
    if [[ -n "$branch" ]]; then
        ./scripts/git-worktree-manager.sh switch "$branch"
    fi
}
```

## 🎨 Customization

### Hook Customization

Disable specific hook features:

```bash
export WORKTREE_HOOKS_ENABLED=false        # Disable all hooks
export WORKTREE_LINT_ENABLED=false         # Disable linting
export WORKTREE_TEST_ENABLED=true          # Enable testing
```

### Project-Specific Setup

The tmux integration automatically detects project types and sets up appropriate windows:

- **Node.js**: Development server, test runner
- **Rust**: Build window, test runner
- **Python**: Virtual environment, test runner

## 🐛 Troubleshooting

### Common Issues

1. **Permission denied errors**
   ```bash
   chmod +x scripts/*.sh
   ```

2. **FZF not found**
   ```bash
   # Install fzf
   git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
   ```

3. **Tmux sessions not created**
   ```bash
   # Check tmux installation
   tmux -V
   ```

4. **Hooks not running**
   ```bash
   # Check hook permissions
   ls -la .git/hooks/
   chmod +x .git/hooks/*
   ```

### Debug Mode

Enable verbose output for troubleshooting:

```bash
export WORKTREE_DEBUG=true
./scripts/git-worktree-manager.sh status
```

### Performance Optimization

**History Management:**
```bash
# Adjust history size for performance
export WORKTREE_HISTORY_SIZE=10  # Fewer entries = faster lookups

# Disable state persistence for speed
export WORKTREE_STATE_ENABLED=false
```

**Bulk Operations:**
```bash
# Clean multiple worktrees efficiently
./scripts/git-worktree-manager.sh clean

# Use FZF for multi-select operations
./scripts/worktree-fzf.sh remove  # Supports multi-select
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature worktree: `./scripts/git-worktree-manager.sh create feature/your-feature`
3. Make your changes
4. Test with different project types
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Git team for the excellent worktree feature
- [fzf](https://github.com/junegunn/fzf) for the amazing fuzzy finder
- [tmux](https://github.com/tmux/tmux) for terminal multiplexing
- The open source community for inspiration and best practices

---

**Happy coding with Git worktrees! 🌳✨**
