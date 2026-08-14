---
type: Repository
title: Modern Dotfiles
description: Declarative macOS and Linux home-environment configuration with secure credential tools and automated validation.
resource: https://github.com/brunogama/dotfiles
tags: [dotfiles, nix, shell, credentials]
timestamp: 2026-08-14T10:12:42Z
---

# Overview

Modern Dotfiles configures a reproducible development environment for macOS and Linux. It provides shell configuration, package management, credential utilities, Git workflows, and synchronization tooling.

# Architecture

| Area | Source | Responsibility |
|---|---|---|
| Home configuration | `home/`, `home-darwin/` | Files linked or activated below the user home directory. |
| Commands | `bin/` | Public executable tools grouped by domain. |
| Declarative activation | `nix/`, `flake.nix` | Home Manager and optional nix-darwin configuration. |
| Package declarations | `packages/` | NPM, Homebrew, mise, and other package configuration. |
| Shell behavior | `zsh/`, `home/.config/zsh/` | Zsh profiles, completion, and interactive behavior. |
| Regression coverage | `tests/` | Bats integration tests and Python test coverage. |

# Operating guidance

Start setup and activation with `./install --nix --dry-run`. Public commands are linked from immediate executable files under `bin/<domain>/` into `~/.local/bin`; the convention linker protects existing targets unless explicitly forced.

Store credentials with `store-api-key` and retrieve a named credential with `get-api-key`. Do not place secrets in repository files or shell history.

# Validation

Use the repository's documented validation commands for the changed surface, including ShellCheck for shell scripts, Bats integration tests, and `pre-commit` hooks.

# Citations

[1] [Repository README](../README.md)
[2] [Project instructions](../AGENTS.md)
