# Brew → Nix Migration Guide

## Overview

This migration replaces Homebrew with Nix for reproducible, version-locked binary management. Your Forgejo instance becomes the canonical source for builds and distribution.

## Strategy

### Phase 1: Local Setup (Your Machine)
1. Install Nix (already done as Thaline)
2. Replace brew with `nix flake` environment
3. Test all tools work identically to brew versions

### Phase 2: Repository Integration
1. Create flake.nix in your Forgejo repo with all packages pinned
2. Document each package's purpose and why it's needed
3. Set up CI/CD in Forgejo to pre-build binaries

### Phase 3: Distribution
1. Forgejo builds binaries for macOS (x86_64 + arm64) and Linux
2. Binary cache served from your VPS at production
3. Pull cache from production on-demand (eliminates brew dependency)

### Phase 4: Maintenance
1. Version bumps: update flake.lock
2. New tools: add to appropriate category in pkgs/default.nix
3. Remove deprecated tools: clean up flake.nix

---

## Current Brew Packages Analysis

### [READY] Unix-Compliant (Direct Nix Migration)
No macOS-specific quirks. These can be distributed as standard Unix binaries:
- `bat, coreutils, curl, wget, tree, unzip, zip`
- `fd, fzf, ripgrep, jq, sd, grex`
- `git, gh, git-delta, git-flow, git-lfs, git-secrets, gitleaks`
- `neovim, tmux, shellcheck, clang-format`
- `python@3.13, python@3.9, node, ruby`
- `eza, dust, procs, htop, ncdu, zoxide, choose`
- `httpie, hyperfine, binwalk`
- `docker, gnupg, watchman, stow`

**Action:** [READY] All of these can be packaged via nixpkgs or custom derivations

### [WARNING] macOS-Specific (Conditional Packaging)
These exist in nixpkgs but may need platform-specific handling:
- `swiftformat, swiftlint` - Works on macOS, also Linux
- `xcodegen, xcbeautify` - Xcode build tools
- `cocoapods, carthage, fastlane` - iOS development (needs Swift, Xcode)
- `ios-deploy, ios-app-signer` - iOS deployment tools
- `xcodes-app` - Xcode version manager (macOS only)

**Action:** Create conditional derivations for macOS in flake.nix

### [NOT_RECOMMENDED] App Casks (GUI Applications)
These are mostly macOS-specific and harder to distribute via Nix:
- Browsers: `brave-browser, google-chrome@canary`
- IDEs: `github, xcode, visual-studio-code, warp`
- Utilities: `imageoptim, postman, protonvpn, rectangle`
- Specialized: `qlab, qlc+, netnewswire, anaconda`

**Action:** Keep these on Homebrew or use declarative macOS management (nix-darwin)

### [PACKAGE] VSCode Extensions
Not managed by Nix directly—keep as-is or use VSCode settings.json

**Action:** Document in ./vscode-extensions.json, manage separately

---

## Local Usage After Migration

### Before (Homebrew)
```bash
brew install bat ripgrep neovim
brew upgrade
brew cleanup
```

### After (Nix)
```bash
# One-time: clone the repo, enter the flake
nix flake clone file://$REPO
cd nix-binaries
nix flake update  # Updates all packages to latest

# Daily usage: activate the environment
nix flake develop

# Or: run a specific tool
nix run .#bat -- --version
```

### With Binary Cache (From Forgejo)
```bash
# Add to ~/.config/nix/nix.conf:
# substituters = https://production/nix-cache/
# trusted-public-keys = production-1:...

# Then builds are downloaded instead of compiled locally
nix flake develop  # Pulls pre-built binaries from production
```

---

## Forgejo CI/CD Setup

### Workflow: .forgejo/workflows/build.yml
```yaml
name: Build and cache binaries

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: cachix/install-nix-action@v22

      - name: Build all packages
        run: nix build .#bundle

      - name: Upload to cache
        run: nix copy --to 's3://production/nix-cache/' ./result
```

### Push Binaries to Production
```bash
# From your local machine or Forgejo CI:
nix build .#bundle
nix copy --to ssh-ng://root@production/nix-cache ./result
```

---

## File Structure

```
your-forgejo-repo/
├── flake.nix                 # Main entry point
├── flake.lock               # Locked versions (commit this)
├── pkgs/
│   └── default.nix          # Package definitions by category
├── modules/
│   ├── macos.nix            # macOS-specific packages
│   ├── linux.nix            # Linux-specific packages
│   └── shared.nix           # Cross-platform packages
├── scripts/
│   ├── build-all.sh         # Local build script
│   └── sync-cache.sh        # Sync binaries to production
├── MIGRATION.md             # This file
└── docs/
    ├── PACKAGES.md          # List & why for each package
    └── TROUBLESHOOTING.md   # Common issues
```

---

## Key Advantages Over Brew

| Feature | Brew | Nix |
|---------|------|-----|
| **Reproducibility** | Best-effort | Guaranteed (hash-based) |
| **Version pinning** | Per-formula | Flake.lock (all packages) |
| **Binary caching** | Bintray (centralized) | Your production VPS |
| **Cross-platform** | Per OS | Single flake, multi-target |
| **Rollback** | Manual | `git revert flake.lock` |
| **Offline installs** | Not well-supported | Pre-cache entire env |
| **Self-hosting** | Not designed for it | Built-in support |

---

## Migration Steps

### Step 1: Initial Setup (Today)
- [ ] Create `nix-binaries` directory in Forgejo
- [ ] Commit flake.nix and pkgs/default.nix
- [ ] Test locally: `nix flake develop`

### Step 2: Validate (This week)
- [ ] Run all 88 packages
- [ ] Verify functionality matches brew versions
- [ ] Document any behavior differences

### Step 3: CI/CD (Next week)
- [ ] Set up Forgejo Actions for builds
- [ ] Configure binary cache on production
- [ ] Test cache hits locally

### Step 4: Deprecate Brew (Month 2)
- [ ] Uninstall brew
- [ ] Add Nix to git-credential-oauth setup
- [ ] Archive Brewfile in git history

---

## Handling git-credential-oauth

This is already well-suited to Nix:
- Pure Rust, no runtime dependencies
- Cross-platform (x86_64, arm64)
- Works via Unix credential helper protocol

Add to `pkgs/default.nix`:
```nix
git-credential-oauth = pkgs.rustPlatform.buildRustPackage rec {
  pname = "git-credential-oauth";
  version = "0.12.0";
  src = pkgs.fetchFromGitHub {
    owner = "hickford";
    repo = "git-credential-oauth";
    rev = "v${version}";
    sha256 = "...";
  };
  cargoSha256 = "...";
};
```

---

## References

- Nix Manual: https://nixos.org/manual/nix/
- Nixpkgs docs: https://github.com/NixOS/nixpkgs
- Binary caching: https://nixos.wiki/wiki/Binary_Cache
- Flakes: https://nixos.wiki/wiki/Flakes
