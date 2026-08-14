---
type: Repository
title: Modern Dotfiles
description: Nix-first, macOS-oriented home-environment configuration with safe linking, credential tooling, and automated validation.
resource: https://github.com/brunogama/dotfiles
tags: [dotfiles, macos, nix, home-manager, shell, credentials]
timestamp: 2026-08-14T12:54:47Z
---

# Modern Dotfiles

## Overview

Modern Dotfiles configures a reproducible macOS developer environment. Its primary activation path uses Nix flakes and Home Manager, with optional nix-darwin system settings. A legacy Homebrew-based installer remains available for imperative setup.

## Architecture

| Area | Source | Responsibility |
| --- | --- | --- |
| Host configuration | `nix/host.nix` | Defines the macOS account, host, architecture, and Git identity used by Nix activation. |
| Declarative activation | `flake.nix`, `nix/` | Home Manager user configuration and optional privileged nix-darwin system configuration. |
| Convention linker | `home/`, `home-darwin/`, `bin/<domain>/` | Links unmanaged eligible home files and public commands while protecting collisions. |
| Commands | `bin/` | Core, credential, Git, IDE, and macOS utilities. |
| Package declarations | `packages/` | Homebrew, NPM, macOS, and iOS package configuration. |
| Shell behavior | `zsh/`, `home/.config/zsh/` | Zsh profiles, completion, interactive behavior, and shell maintenance. |
| Regression coverage | `tests/` | Bats integration coverage and focused Python test suites. |

## Operating guidance

Start with `./install --nix --dry-run`, then apply `./install --nix` after reviewing the plan. `./install --nix --system` activates optional privileged macOS settings. The legacy `./install` flow performs Homebrew-based setup.

Home Manager owns explicitly declared targets. For remaining eligible paths, preview `uv run bin/core/link-dotfiles.py --dry-run` before applying links. The linker sends immediate executable files in `bin/<domain>/` to `~/.local/bin` and does not overwrite unmanaged collisions without `--force`.

Credential commands prompt for secrets rather than accepting secret values as arguments. Use `store-api-key` and `get-api-key` for macOS Keychain-backed keys, or `credfile` and `credmatch` for encrypted credential workflows.

## Validation

| Surface | Command |
| --- | --- |
| Installer syntax | `bash -n install` |
| Static Nix checks | `nix-validate --static` |
| Nix evaluation | `nix-validate` |
| Link safety | `uv run bin/core/link-dotfiles.py --dry-run` |
| Integration tests | `bin/test/run-tests` |
| Git smart-merge behavior | `python3 tests/test_git_smart_merge.py` |
| UV resolver behavior | `python3 tests/test_uv_resolver.py` |

## Citations

[1] [Repository README](../README.md)
[2] [Repository architecture](../docs/architecture.md)
