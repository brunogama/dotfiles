# Linking Architecture

## Purpose

The dotfiles repository manages selected home-directory configuration and repository commands through filesystem conventions. The repository tree, not a link manifest, is the source of truth.

## Principles

- **Filesystem layout beats repeated metadata.** A managed file's destination is evident from its source path.
- **Safety beats convenience.** The linker never overwrites or deletes an existing filesystem object unless the user explicitly selects and confirms that operation.
- **Managed ownership must be provable.** Cleanup only affects links the linker has recorded as its own.
- **Local state stays local.** Secrets, runtime state, and machine-specific configuration are never copied into the repository merely to make linking convenient.

## Managed Source Trees

The linker uses these source trees, when present:

```text
home/                         # common files below $HOME
home-darwin/                  # macOS overrides
home-linux/                   # Linux overrides
home-host-<hostname>/         # optional machine-specific overrides
bin/<domain>/<command>        # executable command sources
install/                      # exceptional platform installation modules
```

Files in `home/` map one-for-one to the same relative location below `$HOME`. Only regular files are managed. A containing directory is never linked as a whole.

The linker applies `home/`, then the current platform tree, then the current hostname tree. A later tree may deliberately override a lower-precedence source with the same relative path. Sources at the same precedence that resolve to the same destination are invalid and must fail before any mutation.

## Repository Commands

Each executable regular file immediately within `bin/<domain>/` is linked to `~/.local/bin/<command-name>`. Command names must be unique across domains. Nested files are not public commands by default.

Normal linking never changes the legacy `~/local/bin` directory. Legacy migration is a separate, explicit operation.

## Safety and Ownership

A normal apply operation reports correct links as no-ops and fails on collisions. Replacing a conflicting object requires an explicit replace or backup mode plus confirmation, unless a non-interactive confirmation flag is supplied.

The linker stores generated ownership state at `~/.local/state/dotfiles/links.json`. The state contains a format version, a stable repository identifier, and the managed target/source relationships. It is operational metadata, is not committed, and may be rebuilt by a successful apply.

Apply validates the complete plan before changing the filesystem. If a subsequent filesystem error still causes partial completion, the linker records exactly the successful operations atomically, reports the incomplete outcome, and exits non-zero. A later apply must converge safely without guessing about unrecorded objects.

Pruning is an explicit operation. It removes only a tracked target that is still a symlink and is no longer desired or still points to a prior recorded checkout after relocation. It never removes a regular file, directory, unknown symlink, or untracked path.

## Exceptional Targets

A target outside `$HOME` mirroring or `~/.local/bin` command exposure belongs in a small, explicit platform installer module under `install/`. These modules use the same dry-run, collision, backup/replace confirmation, and ownership-recording rules as the main linker.

## Scope Boundary

Home Manager and Nix retain ownership of their existing declared configuration. This architecture covers the convention-based linker, its legacy script migration, and exceptional installer modules only.
