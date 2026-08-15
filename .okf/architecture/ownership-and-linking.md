---
type: Filesystem Ownership Model
title: Configuration ownership and linking
description: Home Manager owns declared targets while the convention linker safely manages remaining eligible home files and public commands.
resource: https://github.com/brunogama/dotfiles/blob/main/bin/core/link-dotfiles.py
tags: [home-manager, linking, symlinks, filesystem, safety]
timestamp: 2026-08-15T01:29:12Z
---

# Configuration ownership and linking

---

## Ownership boundary

The repository has two non-overlapping configuration owners:

| Owner | Scope |
| --- | --- |
| Home Manager and nix-darwin | Paths explicitly declared in the Nix modules. |
| Convention linker | Eligible files under `home/` and `home-darwin/`, plus immediate executable files in `bin/<domain>/` that are not Nix-managed. |

This separation avoids competing mutations of the same target. Do not introduce a linker target for a path already declared in `nix/home.nix` or `nix/darwin.nix`.

---

## Linker contract

The linker derives home-file destinations from the source-tree layout and puts public commands in `~/.local/bin`. It previews by default, validates the complete plan before mutating the filesystem, and rejects unmanaged collisions unless `--force` is explicitly supplied. It records links it owns in local state and prunes only those recorded targets.

Use the narrowest operation that meets the need:

```bash
uv run bin/core/link-dotfiles.py --dry-run
uv run bin/core/link-dotfiles.py --apply --yes
uv run bin/core/link-dotfiles.py --commands-only --apply --yes
```

`--force` is a destructive acknowledgement, not a routine repair option. Review the dry-run plan first.

---

## Related concepts

The ownership boundary constrains [Nix activation](activation.md) and is exercised by the [command surface](../operations/command-surface.md).

---

## Citations

[1] [Linker implementation](../../bin/core/link-dotfiles.py)
[2] [Home Manager targets](../../nix/home.nix)
[3] [Configuration ownership guidance](../../README.md)
[4] [Linking source inventory](../../docs/linking-source-inventory.md)
