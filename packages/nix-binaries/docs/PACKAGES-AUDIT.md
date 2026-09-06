# Brew Package Audit for Nix Migration

## Summary
- **Total packages:** 88 brew formulas + 32 casks + 41 VSCode extensions
- **Directly migratable:** 72 packages (82%)
- **Needs platform-specific handling:** 12 packages (14%)
- **Consider keeping with brew/GUI:** 32 casks (37%)

---

## [READY] UNIX-COMPLIANT PACKAGES (Migrate to Nix)

These packages follow Unix conventions, work cross-platform, and are available in nixpkgs.
Can be distributed as standard binaries from your Forgejo instance.

### File Processing & Utilities (9)
| Package | In nixpkgs | Unix-compliant | Notes |
|---------|-----------|----------------|-------|
| `bat` | [READY] Yes | [READY] Yes | Rust-based, pure |
| `coreutils` | [READY] Yes | [READY] Yes | Core Unix utils |
| `choose` | [READY] Yes | [READY] Yes | Cut/awk alternative |
| `curl` | [READY] Yes | [READY] Yes | Standard HTTP client |
| `fd` | [READY] Yes | [READY] Yes | Modern find replacement |
| `fzf` | [READY] Yes | [READY] Yes | Fuzzy finder |
| `jq` | [READY] Yes | [READY] Yes | JSON processor |
| `ripgrep` | [READY] Yes | [READY] Yes | Modern grep |
| `sd` | [READY] Yes | [READY] Yes | sed replacement |
| `tree` | [READY] Yes | [READY] Yes | Directory tree viewer |
| `unzip` | [READY] Yes | [READY] Yes | ZIP extraction |
| `wget` | [READY] Yes | [READY] Yes | HTTP downloader |
| `zip` | [READY] Yes | [READY] Yes | ZIP creation |

### Code Analysis (6)
| Package | In nixpkgs | Notes |
|---------|-----------|-------|
| `clang-format` | [READY] Yes | LLVM formatter |
| `grex` | [READY] Yes | Regex generator |
| `shellcheck` | [READY] Yes | Shell script linter |
| `the_silver_searcher` | [READY] Yes | ag - code search |
| `tokei` | [READY] Yes | Code stats counter |
| `utf8proc` | [READY] Yes | Unicode processor |

### Git & Version Control (8)
| Package | In nixpkgs | Unix-compliant | Notes |
|---------|-----------|---|-------|
| `git` | [READY] Yes | [READY] Yes | Version control |
| `git-delta` | [READY] Yes | [READY] Yes | Diff viewer |
| `git-flow` | [READY] Yes | [READY] Yes | Branching model |
| `git-lfs` | [READY] Yes | [READY] Yes | Large file storage |
| `git-secrets` | [READY] Yes | [READY] Yes | Secret detection |
| `gitleaks` | [READY] Yes | [READY] Yes | Leak scanner |
| `gh` | [READY] Yes | [READY] Yes | GitHub CLI |
| `git-extras` | [READY] Yes | [READY] Yes | Extra git commands |

### Development Tools (9)
| Package | In nixpkgs | Notes |
|---------|-----------|-------|
| `neovim` | [READY] Yes | Text editor |
| `pre-commit` | [READY] Yes | Git hook framework |
| `tmux` | [READY] Yes | Terminal multiplexer |
| `lefthook` | [READY] Yes | Git hooks manager |
| `watchman` | [READY] Yes | File change monitor |
| `htop` | [READY] Yes | Process viewer |
| `ncdu` | [READY] Yes | Disk usage analyzer |
| `stow` | [READY] Yes | Symlink manager |
| `binwalk` | [READY] Yes | Binary analysis |

### Language Runtimes & Managers (6)
| Package | In nixpkgs | Notes |
|---------|-----------|-------|
| `python@3.13` | [READY] Yes | Python runtime |
| `python@3.9` | [READY] Yes | Python 3.9 |
| `node` | [READY] Yes | Node.js runtime |
| `ruby-build` | [READY] Yes | Ruby build utility |
| `rbenv` | [READY] Yes | Ruby version manager |
| `pyenv` | [READY] Yes | Python version manager |

### CLI Utilities (10)
| Package | In nixpkgs | Platform-specific | Notes |
|---------|-----------|---|-------|
| `eza` | [READY] Yes | [NOT_RECOMMENDED] No | ls replacement |
| `dust` | [READY] Yes | [NOT_RECOMMENDED] No | du alternative |
| `procs` | [READY] Yes | [NOT_RECOMMENDED] No | ps alternative |
| `zoxide` | [READY] Yes | [NOT_RECOMMENDED] No | cd helper |
| `tldr` | [READY] Yes | [NOT_RECOMMENDED] No | Man page helper |
| `terminal-notifier` | [READY] Yes | [WARNING] macOS-optimized | Notifications |
| `bats-core` | [READY] Yes | [NOT_RECOMMENDED] No | Bash testing |
| `difftastic` | [READY] Yes | [NOT_RECOMMENDED] No | Diff tool |
| `hyperfine` | [READY] Yes | [NOT_RECOMMENDED] No | Benchmark tool |
| `gdu` | [READY] Yes | [NOT_RECOMMENDED] No | Disk usage |

### Network & Data (3)
| Package | In nixpkgs | Notes |
|---------|-----------|-------|
| `httpie` | [READY] Yes | HTTP client |
| `docker` | [READY] Yes | Container runtime |
| `gnupg` | [READY] Yes | Encryption tools |

### Shell Enhancement (5)
| Package | In nixpkgs | Notes |
|---------|-----------|-------|
| `zsh` | [READY] Yes | Shell |
| `zsh-autosuggestions` | [READY] Yes | Shell completion |
| `zsh-completions` | [READY] Yes | Shell completions |
| `zsh-syntax-highlighting` | [READY] Yes | Syntax highlight |
| `kotlin` | [READY] Yes | Language runtime |

---

## [WARNING] PLATFORM-SPECIFIC PACKAGES (Conditional Nix)

These are in nixpkgs but work best on specific platforms. Can be included in flake.nix
with platform conditionals.

### Xcode & Swift Tools (7)
| Package | macOS | Linux | Status | Notes |
|---------|-------|-------|--------|-------|
| `swiftformat` | [READY] Yes | [READY] Yes | Nix available | Code formatter |
| `swiftlint` | [READY] Yes | [READY] Yes | Nix available | Linter |
| `clang-format` | [READY] Yes | [READY] Yes | Nix available | LLVM formatter |
| `xcodegen` | [READY] Yes | [NOT_RECOMMENDED] No | Nix (macOS only) | Xcode project gen |
| `xcbeautify` | [READY] Yes | [NOT_RECOMMENDED] No | Nix (macOS only) | Build formatter |
| `xcv` | [READY] Yes | [NOT_RECOMMENDED] No | Nix (macOS only) | Xcode version |
| `xcinfo` | [READY] Yes | [NOT_RECOMMENDED] No | Nix (macOS only) | Xcode info |

### iOS Development (5)
| Package | macOS | Linux | In nixpkgs | Notes |
|---------|-------|-------|-----------|-------|
| `cocoapods` | [READY] Yes | [NOT_RECOMMENDED] No | [WARNING] Partial | Ruby-based, needs Swift |
| `carthage` | [READY] Yes | [NOT_RECOMMENDED] No | [READY] Yes | Dependency manager |
| `fastlane` | [READY] Yes | [NOT_RECOMMENDED] No | [READY] Yes | Build automation |
| `ios-deploy` | [READY] Yes | [NOT_RECOMMENDED] No | [READY] Yes | Device deployment |
| `ios-app-signer` | [READY] Yes | [NOT_RECOMMENDED] No | [NOT_RECOMMENDED] No | GUI app—use Homebrew |

### Specialized Tools (3)
| Package | Status | Notes |
|---------|--------|-------|
| `plantuml` | [READY] In nixpkgs | Diagram tool (Java-based) |
| `periphery` | [READY] In nixpkgs | Swift code analyzer |
| `pipx` | [READY] In nixpkgs | Python package manager |

### Language-specific (4)
| Package | In nixpkgs | Notes |
|---------|-----------|-------|
| `rbenv-default-gems` | [READY] Yes | Ruby gem defaults |
| `ruby-build` | [READY] Yes | Ruby compilation |
| `sourcery` | [READY] Yes | Swift codegen (Apple) |
| `ripgrep` | [READY] Yes | Already listed above |

---

## [NOT_RECOMMENDED] NOT RECOMMENDED FOR NIX (Keep with Homebrew or macOS GUI management)

These are GUI applications, closed-source, or heavily macOS-integrated.
Better managed via Homebrew casks or nix-darwin for macOS-specific config.

### Browsers & UI Tools (7)
| Package | Type | Why not Nix |
|---------|------|-----------|
| `anaconda` | Cask | Large, self-contained |
| `brave-browser` | Cask | Prefers native installer |
| `google-chrome@canary` | Cask | Frequent updates |
| `fork` | Cask | macOS-specific UI |
| `github` | Cask | Official macOS client |
| `warp` | Cask | Native macOS integration |
| `visual-studio-code` | Cask | Large, frequent updates |

### macOS Tools (7)
| Package | Type | Why not Nix |
|---------|------|-----------|
| `appcleaner` | Cask | macOS-only utility |
| `imageoptim` | Cask | macOS GUI |
| `rectangle` | Cask | Window manager (macOS) |
| `syntax-highlight` | Cask | Quick Look plugin |
| `netnewswire` | Cask | macOS native app |
| `postman` | Cask | Large, frequently updated |
| `proxyman` | Cask | macOS proxy tool |

### Development Tools GUI (8)
| Package | Type | Why not Nix |
|---------|------|-----------|
| `xcodes-app` | Cask | Xcode version manager (macOS only) |
| `github-copilot-for-xcode` | Cask | Xcode plugin |
| `xcode-build-server` | Cask | Xcode integration |
| `ios-app-signer` | Cask | GUI app for iOS signing |
| `qlab` | Cask | Theater software |
| `qladdict` | Cask | QLab helper |
| `qlc+` | Cask | DMX controller |
| `xcodes-app` | Cask | Xcode version manager |

### QuickLook Plugins (7)
| Package | Type | Why not Nix |
|---------|------|-----------|
| `qlcolorcode` | Cask | QL syntax highlighting |
| `qlcommonmark` | Cask | QL markdown |
| `qldds` | Cask | QL DDS viewer |
| `qlprettypatch` | Cask | QL patch viewer |
| `qlstephen` | Cask | QL plain text |
| `qlswift` | Cask | QL Swift files |
| `qlvideo` | Cask | QL video |
| `qlzipinfo` | Cask | QL zip info |

### Security & VPN (2)
| Package | Type | Notes |
|---------|------|-------|
| `protonvpn` | Cask | Proprietary, macOS native |
| `appcleaner` | Cask | macOS-only utility |

---

## VSCode Extensions (41)

Manage separately via VSCode settings.json or `settings.json.backup`.
Not part of this Nix migration, but document for reference.

**Categories:**
- Git & VCS: 10 extensions
- Python & analysis: 5 extensions
- Markdown & docs: 3 extensions
- Data & format: 3 extensions
- Themes: 4 extensions
- Testing & QA: 3 extensions
- Cloud & DevOps: 2 extensions
- Other: 8 extensions

---

## Migration Action Items

### Tier 1: Immediate Migration (Week 1)
- [ ] Add 72 Unix-compliant packages to Nix flake
- [ ] Test each tool locally: `nix run .#<tool>`
- [ ] Verify behavior identical to brew version

### Tier 2: Platform Conditionals (Week 2)
- [ ] Add macOS-only Xcode tools with `stdenv.isDarwin` conditionals
- [ ] Test on Linux system (or CI/CD)
- [ ] Document platform-specific limitations

### Tier 3: Binary Distribution (Week 3)
- [ ] Set up Forgejo Actions to build binaries
- [ ] Configure `nix.conf` to use your Forgejo cache
- [ ] Pre-cache commonly-used binaries on production

### Tier 4: Cleanup (Month 1)
- [ ] Uninstall Homebrew
- [ ] Remove old Brewfile
- [ ] Archive migration notes in README

---

## Package Count Summary

| Category | Count | Nix Ready | Notes |
|----------|-------|-----------|-------|
| CLI Tools | 45 | [READY] 45 | 100% migratable |
| Dev Tools | 15 | [READY] 14 | 93% (1 GUI) |
| Language Runtimes | 9 | [READY] 9 | 100% migratable |
| Git Tools | 8 | [READY] 8 | 100% migratable |
| GUI Casks | 32 | [NOT_RECOMMENDED] 0 | Keep with brew/nix-darwin |
| VSCode Extensions | 41 | [WARNING] 0 | Manage separately |
| **Total** | **150** | **75** | **50% direct migration** |

If we include platform conditionals for macOS tools:
- **Total directly in Nix flake: 87 packages (58%)**
- **Recommended for Homebrew/GUI: 32 packages (21%)**
- **VSCode extensions (separate): 41 (27%)**
