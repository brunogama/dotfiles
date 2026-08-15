---
type: Configuration Architecture
title: Nix activation
description: Flake-based configuration provides standalone Home Manager activation and optional privileged nix-darwin activation from shared modules.
resource: https://github.com/brunogama/dotfiles/tree/main/nix
tags: [nix, flakes, home-manager, nix-darwin, macos, activation]
timestamp: 2026-08-15T01:58:48Z
---

# Nix activation

---

## Activation model

The flake is the declarative entry point. It imports a host-local configuration and creates:

- a standalone Home Manager configuration for user-level activation;
- a nix-darwin configuration for optional system-level macOS activation; and
- a development shell with validation and maintenance tooling.

Both activation routes use the same Home Manager module, so user configuration is shared rather than duplicated. The host module is the intentionally small machine-specific boundary. Before activation on another machine, update its account, host, architecture, Git identity, and Nix-daemon ownership (`manageNix`) values. Set `manageNix = false` when using Determinate Nix, which owns its own daemon.

---

## Operating modes

`./install` selects the supported backend for the platform. On macOS, the default is the user-level Nix and Home Manager flow. `./install --system` selects the privileged nix-darwin path. The legacy imperative installer remains available, but mixed legacy and Home Manager ownership on macOS requires explicit acknowledgement.

Preview any activation before applying it:

```bash
./install --dry-run
./install --system --dry-run
nix-validate --static
nix-validate
```

---

## Ownership

Nix is responsible only for the paths declared in its Home Manager and nix-darwin modules. The complementary convention linker manages eligible targets outside that set. See [configuration ownership and linking](ownership-and-linking.md) before adding a home-directory target.

---

## Citations

[1] [Flake entry point](../../flake.nix)
[2] [Home Manager module](../../nix/home.nix)
[3] [nix-darwin module](../../nix/darwin.nix)
[4] [Host configuration](../../nix/host.nix)
[5] [Installation and activation guidance](../../README.md)
