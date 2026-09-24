# Mise and Nix migration

The [Homebrew inventory](homebrew-migration-inventory.tsv) is a snapshot of this Mac on 2026-09-24. It lists 285 installed formulae and 45 casks with their observed versions. Fifty formulae were selected for `nix/packages.nix`. The selection covers Swift build tools available in the pinned Nixpkgs revision, commands used by installation and shell configuration, and modern CLI utilities used instead of basic macOS commands. Dependency formulae are left to Nix's dependency graph. GUI casks and unrelated direct installs are outside the dotfiles CLI installation.

`flake.lock` pins one Nixpkgs revision for the whole set. Fifteen selected formulae have the same version as Homebrew on the source Mac; the other 35 use the version resolved by that lock. The inventory records both values. Updating the lock changes the set together and requires the Nix validation and local CI gate.

The unused `packages/nix-binaries` subflake was removed. It had a separate unpinned Nixpkgs input and incomplete package hashes; the root flake is the only Nix installation source.

Node 26.10.0, Python 3.14.7, and Ruby 4.0.7 are pinned in `home/.config/mise/config.toml`. Home Manager installs that file as `~/.config/mise/conf.d/dotfiles.toml`. Mise's writable `~/.config/mise/config.toml` has higher precedence, so `nvm alias default`, `pyenv global`, and `rbenv global` compatibility commands can still change a personal default. Those commands warn that the old manager interface is deprecated. Interactive shell changes use Zsh functions because a child process cannot update its parent shell.

The installer no longer installs Homebrew or initializes nvm, pyenv, rbenv, or SDKMAN. It does not uninstall existing Homebrew packages or delete the old runtime stores. Homebrew may still exist on a machine, and macOS CI uses it to provision test dependencies. `./install` selects the Nix backend on macOS and uses mise for the three managed runtimes.

For an existing installation, Home Manager adds the pinned mise config in `conf.d` without replacing the personal `config.toml`. Even a dangling symlink left by an old dotfiles checkout does not prevent mise from reading the managed defaults. The login and interactive shell put mise shims and the Nix-provided compatibility commands ahead of older `~/.local/bin` runtime links. Those older links and runtime directories remain available for recovery; installation does not delete them.

Home Manager leaves `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` under personal control. Existing installations may already have both files and `.pre-nix` backups, which would otherwise block activation. Project instructions remain in this repository's `AGENTS.md` and `CLAUDE.md`.

Some previously installed Swift tools have no suitable package in the pinned Nixpkgs revision. Carthage, Periphery, SourceKitten, Sourcery, xcinfo, xcode-build-server, and xcv remain visible as `not selected` in the inventory. The optional `dead-code` and Sourcery hook commands report a missing dependency if those tools are absent. They are not silently fetched from Homebrew.
