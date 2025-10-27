# Add Comprehensive Script Documentation

## Why

**DISCOVERABILITY & USABILITY ISSUE**: 50+ scripts lack centralized documentation, making it difficult for users to discover and use available functionality.

### Current Problems

**1. No Central Documentation:**
- Scripts scattered across bin/core/, bin/credentials/, bin/git/, bin/macos/
- Users must grep or browse directories to discover functionality
- No quick reference guide
- Help text inconsistent across scripts

**2. Incomplete Help Messages:**
- Some scripts lack --help flags
- Help text format inconsistent
- Missing usage examples
- No cross-references to related scripts

**3. Poor Discoverability:**
```bash
# Current state - how do I find credential scripts?
$ ls bin/credentials/  # Must know directory structure
$ grep -r "credential" bin/  # Must know what to search for
```

**4. Learning Curve:**
- New users don't know what scripts exist
- No categorized listing
- Can't find script for specific task
- No quick reference card

**Impact:**
- Under-utilization of available tools
- Users reinvent functionality that exists
- Support questions about "how do I..."
- Time wasted discovering capabilities

## What Changes

### 1. Create Central Documentation Structure

```
docs/
├── scripts/
│   ├── README.md                 # Overview and usage guide
│   ├── core.md                   # Core utilities documentation
│   ├── credentials.md            # Credential management
│   ├── git.md                    # Git utilities
│   ├── macos.md                  # macOS-specific tools
│   ├── ios.md                    # iOS development tools
│   ├── ide.md                    # IDE integration
│   └── quick-reference.md        # One-page cheat sheet
```

### 2. Documentation Format

Each script documented with:
- **Name** - Script name
- **Purpose** - One-line description
- **Category** - Core, Credentials, Git, etc.
- **Usage** - Syntax and arguments
- **Examples** - Common use cases
- **Related** - Cross-references to similar scripts
- **Requirements** - Dependencies (jq, homebrew, etc.)
- **Platform** - darwin, linux, or all

**Example Entry:**

```markdown
## zsh-benchmark

**Purpose:** Measure and analyze zsh shell startup performance

**Category:** Core / Performance

**Usage:**
```bash
zsh-benchmark [options]

Options:
  --detailed, -d    Show detailed profiling with zprof
  --help, -h        Show help message
```

**Examples:**
```bash
# Quick 10-run benchmark
zsh-benchmark

# Detailed function-by-function profiling
zsh-benchmark --detailed

# Expected output:
# Average: 450ms
# Min: 420ms
# Max: 480ms
# Performance: Good (200-500ms)
```

**Related Scripts:**
- `zsh-compile` - Compile configs for faster startup
- `zsh-trim-history` - Reduce history size

**Requirements:**
- zsh shell
- perl (for timing on macOS)

**Platform:** darwin, linux
```

### 3. Auto-generated Documentation

Create `bin/core/generate-script-docs`:

```bash
#!/usr/bin/env bash
# Generate documentation from script help messages

set -euo pipefail

OUTPUT_DIR="docs/scripts"
mkdir -p "$OUTPUT_DIR"

# Extract help text from script
extract_help() {
    local script="$1"
    local category="$2"
    local name=$(basename "$script")
    
    # Try to extract from usage() function or --help
    if "$script" --help 2>&1 | head -50; then
        return 0
    fi
    
    # Or parse script header comments
    grep -A 20 "^# " "$script" | head -20 || echo "No help available"
}

# Generate category documentation
generate_category_doc() {
    local category="$1"
    local dir="bin/$category"
    local output="$OUTPUT_DIR/$category.md"
    
    cat > "$output" << EOF
# ${category^} Scripts

Utilities in \`bin/$category/\`

EOF
    
    for script in "$dir"/*; do
        if [[ -x "$script" && -f "$script" ]]; then
            {
                echo "## $(basename "$script")"
                echo ""
                extract_help "$script" "$category"
                echo ""
                echo "---"
                echo ""
            } >> "$output"
        fi
    done
}

# Generate for each category
for category in core credentials git macos ios ide; do
    if [[ -d "bin/$category" ]]; then
        echo "Generating docs for: $category"
        generate_category_doc "$category"
    fi
done

echo "Documentation generated in $OUTPUT_DIR/"
```

### 4. Quick Reference Card

Create `docs/scripts/quick-reference.md`:

```markdown
# Script Quick Reference

One-page guide to all available scripts.

## Core Utilities

| Script | Purpose | Example |
|--------|---------|---------|
| `work-mode` | Switch environment | `work-mode work` |
| `home-sync` | Sync dotfiles | `home-sync` |
| `link-dotfiles` | Manage symlinks | `link-dotfiles --apply` |
| `zsh-benchmark` | Measure startup | `zsh-benchmark` |
| `zsh-compile` | Compile configs | `zsh-compile` |
| `update-dotfiles-scripts` | Update scripts | `update-dotfiles-scripts` |

## Credential Management

| Script | Purpose | Example |
|--------|---------|---------|
| `store-api-key` | Store key securely | `store-api-key OPENAI_API_KEY` |
| `get-api-key` | Retrieve key | `get-api-key OPENAI_API_KEY` |
| `credfile` | Encrypt files | `credfile put secret file.txt` |
| `credmatch` | Search credentials | `credmatch list` |
| `clear-secret-history` | Clean history | `clear-secret-history` |

## Git Utilities

| Script | Purpose | Example |
|--------|---------|---------|
| `conventional-commit` | Guided commits | `conventional-commit` |
| `git-wip` | Quick WIP | `git-wip` |
| `git-save-all` | Create savepoint | `git-save-all` |
| `git-restore-last-savepoint` | Restore | `git-restore-last-savepoint` |

## By Task

### "I want to..."

**...sync dotfiles across machines**
- `syncenv` or `home-sync`

**...store a secret securely**
- `store-api-key KEY_NAME` (interactive prompt)

**...speed up shell startup**
- `zsh-benchmark` → identify issues
- `zsh-compile` → compile configs
- `zsh-trim-history` → reduce history

**...make a proper git commit**
- `conventional-commit` → guided format

**...switch between work and personal**
- `work-mode work` or `work-mode personal`

**...manage Homebrew packages**
- `brew-sync update`

**...find a credential**
- `credmatch list` → see all
- `get-api-key NAME` → retrieve specific

### By Frequency

**Daily Use:**
- `work-mode` - Environment switching
- `syncenv` - Dotfiles sync
- `conventional-commit` - Git commits
- `get-api-key` - Credential retrieval

**Weekly Use:**
- `brew-sync update` - Update packages
- `zsh-benchmark` - Check performance
- `clear-secret-history` - Security hygiene

**One-time Setup:**
- `link-dotfiles --apply` - Initial symlinks
- `store-api-key` - Store credentials
- `zsh-compile` - Compile configs
```

### 5. Interactive Help Command

Create `bin/core/dotfiles-help`:

```bash
#!/usr/bin/env bash
# Interactive help for dotfiles scripts

set -euo pipefail

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_menu() {
    cat << EOF
${BLUE}Dotfiles Scripts Help${NC}

Select a category to see available scripts:

  1) Core Utilities
  2) Credential Management
  3) Git Utilities
  4) macOS Tools
  5) Performance Tools
  6) Search by keyword
  7) Show all scripts
  0) Exit

EOF
    read -p "Choice: " choice
    
    case "$choice" in
        1) show_category "core" ;;
        2) show_category "credentials" ;;
        3) show_category "git" ;;
        4) show_category "macos" ;;
        5) show_performance ;;
        6) search_scripts ;;
        7) show_all ;;
        0) exit 0 ;;
        *) echo "Invalid choice" ; show_menu ;;
    esac
}

show_category() {
    local category="$1"
    
    echo ""
    echo "${GREEN}=== ${category^} Scripts ===${NC}"
    echo ""
    
    for script in bin/"$category"/*; do
        if [[ -x "$script" ]]; then
            local name=$(basename "$script")
            local desc=$("$script" --help 2>&1 | head -1 || echo "No description")
            printf "  ${YELLOW}%-25s${NC} %s\n" "$name" "$desc"
        fi
    done
    
    echo ""
    read -p "Press Enter to continue..."
    show_menu
}

search_scripts() {
    read -p "Search keyword: " keyword
    
    echo ""
    echo "${GREEN}=== Results for '$keyword' ===${NC}"
    echo ""
    
    grep -r "$keyword" bin/ --include="*" -l 2>/dev/null | while read script; do
        if [[ -x "$script" ]]; then
            echo "  - $(basename "$script")"
        fi
    done
    
    echo ""
    read -p "Press Enter to continue..."
    show_menu
}

show_all() {
    echo ""
    echo "${GREEN}=== All Scripts ===${NC}"
    echo ""
    
    find bin/ -type f -executable -exec basename {} \; | sort | column
    
    echo ""
    read -p "Press Enter to continue..."
    show_menu
}

show_performance() {
    cat << EOF

${GREEN}=== Performance Tools ===${NC}

${YELLOW}zsh-benchmark${NC}
  Measure shell startup time
  Usage: zsh-benchmark [--detailed]

${YELLOW}zsh-compile${NC}
  Compile configs to bytecode (.zwc)
  Usage: zsh-compile

${YELLOW}zsh-trim-history${NC}
  Reduce history from 100k to 10k entries
  Usage: zsh-trim-history

${YELLOW}update-dotfiles-scripts${NC}
  Update scripts from dotfiles repo
  Usage: update-dotfiles-scripts

EOF
    read -p "Press Enter to continue..."
    show_menu
}

# Main
if [[ $# -eq 0 ]]; then
    show_menu
else
    # Direct help for specific script
    script="$1"
    if [[ -x "bin/core/$script" ]]; then
        "bin/core/$script" --help
    elif [[ -x "bin/credentials/$script" ]]; then
        "bin/credentials/$script" --help
    elif [[ -x "bin/git/$script" ]]; then
        "bin/git/$script" --help
    else
        echo "Script not found: $script"
        echo "Run 'dotfiles-help' for interactive menu"
    fi
fi
```

### 6. Man Pages (Optional)

Create man pages for key scripts:

```bash
# bin/core/generate-man-pages
#!/usr/bin/env bash
# Generate man pages from script documentation

set -euo pipefail

MAN_DIR="docs/man/man1"
mkdir -p "$MAN_DIR"

generate_man() {
    local script="$1"
    local name=$(basename "$script")
    
    cat > "$MAN_DIR/$name.1" << EOF
.TH ${name^^} 1 "$(date +%Y-%m-%d)" "Dotfiles Scripts"
.SH NAME
$name \- [description from script]
.SH SYNOPSIS
.B $name
[\fIOPTIONS\fR]
.SH DESCRIPTION
[Full description from script help]
.SH OPTIONS
[Options from --help]
.SH EXAMPLES
[Examples from documentation]
.SH SEE ALSO
[Related scripts]
EOF
}

# Generate for all scripts
find bin/ -type f -executable | while read script; do
    generate_man "$script"
done

# Install man pages
sudo cp -r "$MAN_DIR" /usr/local/share/man/ 2>/dev/null || \
    echo "Man pages generated in $MAN_DIR (install manually)"
```

### 7. README Integration

Update main README.md:

```markdown
## Scripts

This repository includes 50+ utility scripts. See [docs/scripts/](docs/scripts/) for complete documentation.

**Quick help:**
```bash
dotfiles-help           # Interactive menu
dotfiles-help script    # Help for specific script
```

**Categories:**
- [Core Utilities](docs/scripts/core.md) - 25+ general-purpose tools
- [Credential Management](docs/scripts/credentials.md) - Secure secret storage
- [Git Utilities](docs/scripts/git.md) - Git workflow enhancements
- [macOS Tools](docs/scripts/macos.md) - macOS-specific utilities
- [Performance](docs/scripts/core.md#performance) - Shell optimization

**Most used:**
- `work-mode` - Switch work/personal environments
- `syncenv` - Sync dotfiles across machines
- `store-api-key` / `get-api-key` - Secure credentials
- `zsh-benchmark` - Measure performance
- `conventional-commit` - Guided git commits

See [Quick Reference](docs/scripts/quick-reference.md) for one-page guide.
```

## Impact

### Files Created
- `docs/scripts/README.md` - Documentation overview
- `docs/scripts/core.md` - Core utilities docs
- `docs/scripts/credentials.md` - Credential management docs
- `docs/scripts/git.md` - Git utilities docs
- `docs/scripts/macos.md` - macOS tools docs
- `docs/scripts/ios.md` - iOS development docs
- `docs/scripts/ide.md` - IDE integration docs
- `docs/scripts/quick-reference.md` - One-page cheat sheet
- `bin/core/generate-script-docs` - Auto-doc generator
- `bin/core/dotfiles-help` - Interactive help
- `bin/core/generate-man-pages` - Man page generator (optional)

### Files Modified
- `README.md` - Add scripts section with links
- `ONBOARDING.md` - Update script catalog section
- All scripts in `bin/` - Add consistent --help

### Breaking Changes
**None** - All changes are additive:
- Documentation adds value without changing behavior
- Scripts work the same with or without docs
- Existing workflows unaffected

### New Capabilities
- Centralized script documentation
- Interactive help system
- Quick reference card
- Auto-generated docs from help text
- Man pages (optional)
- Task-based index ("I want to...")
- Frequency-based grouping

## Expected Benefits

### Discoverability
**Before:**
```bash
# User must explore manually
ls bin/
cat bin/core/script | grep "^#"
```

**After:**
```bash
# Multiple discovery methods
dotfiles-help          # Interactive menu
cat docs/scripts/quick-reference.md  # Quick scan
grep "sync" docs/scripts/core.md     # Search by keyword
```

### Time Savings
- **New users**: Find scripts 5x faster
- **Existing users**: Refresh memory without reading code
- **Contributors**: Understand what exists before adding duplicates

### Quality Improvements
- Consistent help messages across all scripts
- Examples for every script
- Cross-references show related tools
- Platform/requirement info prevents errors

### Support Reduction
- Self-service documentation
- Common questions answered
- Task-based index guides users
- Less "how do I..." questions

## Migration Path

### Phase 1: Structure (Week 1)
1. Create `docs/scripts/` directory structure
2. Create template for script documentation
3. Define documentation standards

### Phase 2: Core Documentation (Week 1-2)
1. Document core utilities (highest value)
2. Document credential management (security critical)
3. Document git utilities (frequently used)
4. Create quick reference card

### Phase 3: Automation (Week 2)
1. Create `generate-script-docs` tool
2. Create `dotfiles-help` interactive menu
3. Test auto-generation

### Phase 4: Remaining Categories (Week 2-3)
1. Document macOS tools
2. Document iOS tools
3. Document IDE integration
4. Complete coverage

### Phase 5: Enhancement (Week 3)
1. Add man pages (optional)
2. Add searchable index
3. Add examples for all scripts
4. User testing and feedback

### Phase 6: Integration (Week 3-4)
1. Update README.md
2. Update ONBOARDING.md
3. Add to installation flow
4. Announce to users

## Documentation Standards

### Script Help Format

All scripts MUST include --help:

```bash
#!/usr/bin/env bash
# script-name - One-line description
# Category: core/credentials/git/macos/ios/ide

usage() {
    cat << EOF
script-name - One-line description

USAGE:
    script-name [OPTIONS] [ARGUMENTS]

OPTIONS:
    --flag          Description
    --help, -h      Show this help

EXAMPLES:
    # Example 1
    script-name --flag value

    # Example 2
    script-name argument

REQUIREMENTS:
    - dependency1
    - dependency2

PLATFORM: darwin | linux | all

SEE ALSO:
    related-script1, related-script2
EOF
}

# Parse --help
case "${1:-}" in
    --help|-h) usage; exit 0 ;;
esac
```

### Documentation File Format

Each category doc MUST include:
- Table of contents
- Alphabetical script listing
- Script entries with all fields
- Related scripts cross-linked
- Platform badges (macOS, Linux, All)

### Quick Reference Format

- Grouped by category
- Tabular format for scanning
- Most common use case shown
- Task-based index
- Frequency-based grouping

## Testing Strategy

### Documentation Completeness
```bash
# Check all scripts documented
find bin/ -type f -executable > scripts.txt
grep "^## " docs/scripts/*.md | cut -d: -f2 | sort > documented.txt
diff scripts.txt documented.txt  # Should be empty
```

### Help Message Consistency
```bash
# Check all scripts have --help
for script in bin/**/*; do
    if [[ -x "$script" ]]; then
        "$script" --help &>/dev/null || echo "Missing: $script"
    fi
done
```

### Documentation Accuracy
```bash
# Verify examples work
grep -A3 "# Example" docs/scripts/*.md | \
    grep "^script-name" | \
    while read cmd; do
        eval "$cmd --dry-run" || echo "Broken: $cmd"
    done
```

### Link Validation
```bash
# Check cross-references
grep "\[.*\](" docs/scripts/*.md | \
    grep -v "^#" | \
    while read link; do
        # Validate link target exists
    done
```

## Success Criteria

- All 50+ scripts documented
- Consistent --help in every script
- Quick reference card complete
- Interactive help working
- Auto-generator functional
- README.md updated
- Zero broken links
- User testing positive
- Reduced "how do I" questions

## Future Enhancements

- **Web version**: GitHub Pages site with search
- **Video tutorials**: Asciinema recordings for complex workflows
- **API documentation**: If scripts are importable
- **Translations**: i18n support for docs
- **Interactive tutorials**: Step-by-step walkthroughs
- **Cheat sheet PDF**: Printable reference card
- **Shell completion**: Tab completion for script names and args
- **fzf integration**: Fuzzy finder for script selection
