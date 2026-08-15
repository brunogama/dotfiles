---
type: Repository
title: Modern Dotfiles
description: Nix-first, macOS-oriented home-environment configuration with safe linking, credential tooling, and automated validation.
resource: https://github.com/brunogama/dotfiles
tags: [dotfiles, macos, nix, home-manager, shell, credentials]
timestamp: 2026-08-15T01:29:12Z
---

# Modern Dotfiles

---

## Purpose

Modern Dotfiles configures a reproducible macOS developer environment. Its primary activation path is Nix flakes with Home Manager and optional nix-darwin system settings. It retains a legacy imperative installer where appropriate and provides shell, credential, Git, synchronization, and maintenance tooling.

---

## Knowledge map

| Area | Concept | Responsibility |
| --- | --- | --- |
| Declarative setup | [Nix activation](architecture/activation.md) | Flake inputs, shared Home Manager configuration, optional nix-darwin, and host-local settings. |
| Filesystem safety | [Configuration ownership and linking](architecture/ownership-and-linking.md) | The separation of Nix-managed paths from safe convention-managed links. |
| User-facing tools | [Command surface](operations/command-surface.md) | Commands for environment, credentials, Git, synchronization, and shell maintenance. |
| Quality | [Repository validation](operations/validation.md) | Focused checks and the locally reproducible CI executor. |
| Agent lifecycle | [Agent infrastructure governance](governance/agent-infrastructure.md) | Candidate-skill promotion and agent-content QA. |

---

## Repository boundaries

| Area | Primary locations |
| --- | --- |
| Activation | `flake.nix`, `nix/`, `install` |
| Home configuration | `home/`, `home-darwin/`, `zsh/` |
| Public commands | `bin/<domain>/` |
| Package configuration | `packages/`, `nix/packages.nix` |
| Tests and quality checks | `tests/`, `scripts/`, `.github/workflows/` |
| Documentation and governance | `docs/`, `AGENTS.md`, `qa/` |

---

## Operating guidance

Preview installation, activation, linking, and other mutating operations before applying them. Keep Nix and convention-linker ownership separate. Keep mutable environment state and credential values outside Nix-managed configuration. Never pass secret values as command arguments.

---

## Citations

[1] [Repository README](../README.md)
[2] [Repository architecture](../docs/architecture.md)
[3] [Nix flake](../flake.nix)
[4] [Project instructions](../AGENTS.md)
