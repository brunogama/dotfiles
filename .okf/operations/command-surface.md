---
type: CLI Surface
title: Dotfiles command surface
description: Executable tools are organized by operational domain and expose installation, Nix, linking, credential, Git, shell, and synchronization workflows.
resource: https://github.com/brunogama/dotfiles/tree/main/bin
tags: [cli, commands, operations, shell, credentials, synchronization]
timestamp: 2026-08-15T01:58:48Z
---

# Dotfiles command surface

---

## Command domains

Public executable commands live directly under `bin/<domain>/`:

| Domain | Responsibility |
| --- | --- |
| `core` | Installation routing, Nix operations, linking, shell profiles and maintenance, local synchronization, and general utilities. |
| `credentials` | macOS Keychain-backed API-key helpers and encrypted credential-file workflows. |
| `git` | Git workflows, hooks, worktree helpers, and commit support. |
| `ide` | Editor and IDE integrations. |
| `macos` | macOS-specific maintenance and preference tools. |
| `test` | Test execution helpers. |

Nested files are implementation details unless a wrapper intentionally exposes them as a public command.

---

## Safety rules

- Run dry-run variants before any installer, linker, Nix, or synchronization command that can mutate local state.
- Do not pass secrets as arguments. Credential commands should receive them through an interactive prompt, standard input, or a permission-restricted temporary file, such as mode `0600`, that is deleted after use.
- Treat forceful synchronization or replacement modes as destructive. Confirm their scope before use.
- Preserve the Nix/linker ownership boundary described in [configuration ownership and linking](../architecture/ownership-and-linking.md).

---

## Common operations

```bash
work-mode status
nix-validate
home-sync status
home-sync sync --dry-run
zsh-benchmark
```

After reviewing the dry-run output, run `home-sync sync` only when its pull-and-push effects are intended.

---

## Citations

[1] [Repository command map](../../README.md)
[2] [Core commands](../../bin/core/)
[3] [Credential commands](../../bin/credentials/)
[4] [Git commands](../../bin/git/)
