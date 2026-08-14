---
status: done
depends: [linking-shell-core-source-tree]
specs:
  - specs/linking-architecture.md
---

# Plan: Migrate Shell Support Source Tree

## Scope

Migrate the remaining common shell configuration, library, and completion files into `home/`. This plan does not change runtime linking or migrate Git, tool, or platform-specific files.

## Implements

- `specs/linking-architecture.md` - managed regular files map one-for-one below `$HOME`; source layout is the configuration contract.

## Approach

1. Move work and personal shell configuration, `lib/lazy-load.zsh`, and the custom completion files to their `home/` paths.
2. Update repository references that must follow these source moves.
3. Preserve executable modes where they already apply and do not link directories as units.

## Validation

- [x] Each migrated support file maps one-for-one from `home/` to its intended `$HOME` destination.
- [x] Shell references to libraries and completions resolve to the migrated paths.
- [x] No directory-wide managed link is introduced.
- [x] The focused source-layout checks pass.

## Risks / unknowns

- **Lazy loading** - relative references in shell support files may depend on their current source layout.

## Notes

- Support files retain destination-equivalent paths so relative Zsh library and completion references continue to resolve after linking.
- Home Manager-owned support targets are excluded from convention linking; `nix/home.nix` remains their authority.

## Follow-ups

None.
