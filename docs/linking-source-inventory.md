# Convention Linker Source Inventory

## Managed Home Trees

| Legacy source | Destination | Convention destination | Current Nix/Home Manager ownership |
| --- | --- | --- | --- |
| `zsh/.zshenv` | `~/.zshenv` | `home/.zshenv` | Home Manager `legacyLinks` and `programs.zsh.envExtra` |
| `zsh/.zshrc` | `~/.config/zsh/.zshrc` | `home/.config/zsh/.zshrc` | Home Manager `legacyLinks` and `programs.zsh.initContent` |
| `zsh/.zprofile` | `~/.config/zsh/.zprofile` | `home/.config/zsh/.zprofile` | Home Manager `legacyLinks` and `programs.zsh.profileExtra` |
| `zsh/.zpreztorc` | `~/.config/zsh/.zpreztorc` | `home/.config/zsh/.zpreztorc` | Home Manager `legacyLinks` and `home.file` |
| `zsh/starship.toml` | `~/.config/starship.toml` | `home/.config/starship.toml` | Home Manager `legacyLinks` and `home.file` |
| `zsh/work-config.zsh` | `~/.config/zsh/work-config.zsh` | `home/.config/zsh/work-config.zsh` | Home Manager `legacyLinks` and `home.file` |
| `zsh/personal-config.zsh` | `~/.config/zsh/personal-config.zsh` | `home/.config/zsh/personal-config.zsh` | Home Manager `legacyLinks` and `home.file` |
| `zsh/lib/lazy-load.zsh` | `~/.config/zsh/lib/lazy-load.zsh` | `home/.config/zsh/lib/lazy-load.zsh` | Home Manager `legacyLinks` and recursive `home.file` |
| `zsh/completion/_pi` | `~/.config/zsh/completion/_pi` | `home/.config/zsh/completion/_pi` | Home Manager `legacyLinks` and recursive `home.file` |
| `zsh/completion/git-ignore-completion` | `~/.config/zsh/completion/git-ignore-completion` | `home/.config/zsh/completion/git-ignore-completion` | Home Manager `legacyLinks` and recursive `home.file` |
| `git/.gitconfig` | `~/.gitconfig` | `home/.gitconfig` | Home Manager `legacyLinks`; Git settings also own generated configuration |
| `git/.gitignore_global` | `~/.gitignore_global` | `home/.gitignore_global` | Home Manager `legacyLinks` and `home.file` |
| `git/conventional-commits-gitmessage` | `~/.config/git/conventional-commits-gitmessage` | `home/.config/git/conventional-commits-gitmessage` | Home Manager `legacyLinks` and `home.file` |
| `git/github-flow-aliases.gitconfig` | `~/.config/git/github-flow-aliases.gitconfig` | `home/.config/git/github-flow-aliases.gitconfig` | Home Manager `legacyLinks` and `home.file` |
| `packages/mise/config.toml` | `~/.config/mise/config.toml` | `home/.config/mise/config.toml` | Convention linker after migration |
| `packages/syncservice/config.yml` | `~/.config/home-sync/config.yml` | `home/.config/home-sync/config.yml` | Convention linker after migration |
| `git/ios.gitattributes` | `~/.config/git/ios.gitattributes` | `home-darwin/.config/git/ios.gitattributes` | Home Manager `legacyLinks` and `home.file`; Darwin-only source tree |
| `packages/homebrew/Brewfile` | `~/Brewfile` | `home-darwin/Brewfile` | Convention linker after migration; nix-darwin owns Homebrew packages, not this file |
| `packages/syncservice/com.brunogama.home-sync.plist` | `~/Library/LaunchAgents/com.brunogama.home-sync.plist` | `home-darwin/Library/LaunchAgents/com.brunogama.home-sync.plist` | Convention linker after migration |

Source moves preserve existing Home Manager and Nix target ownership.

## Public Commands

Each immediate executable regular file in these directories becomes one
`~/.local/bin/<basename>` link. Nested files are internal and are not public
commands.

| Legacy source directory | Convention category | Notes |
| --- | --- | --- |
| `bin/core/` | public commands | Immediate executable files only |
| `bin/credentials/` | public commands | Immediate executable files only |
| `bin/git/` | public commands | Immediate executable files only; `git-hooks/` and `lib/` stay internal |
| `bin/ide/` | public commands | Immediate executable files only |
| `bin/macos/` | public commands | Darwin-only immediate executable files |
| `bin/git/lib/` | internal support | Remove legacy manifest exposure; no public links |
| `bin/lib/` | internal support | Remove legacy manifest exposure; no public links |

The checked executable basenames are unique across the public command
directories. Home Manager currently adds both `~/local/bin` and `~/.local/bin`
to `PATH`; the lifecycle plan owns the explicit legacy-directory migration.

## Exceptional Installer Input

| Legacy source | Legacy destination | Convention category | Notes |
| --- | --- | --- | --- |
| `bin/folder-action-scripts/compress-video-automation.scpt` | `~/Library/Scripts/Folder Action Scripts/compress-video-automation.scptn` | Darwin installer module | Preserve outside home mirroring and validate the legacy extension mismatch before implementation. |

## Unsupported Trees

No current mapping requires `home-linux/` or `home-host-<hostname>/`.
