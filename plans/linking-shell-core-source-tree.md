---
status: planned
depends: [linking-conventions-foundation]
specs:
  - specs/linking-architecture.md
---

# Plan: Migrate Shell Core Source Tree

## Scope

Create the common `home/` layout and migrate the shell files required to bootstrap Zsh and its primary prompt configuration. This plan does not migrate shell support files, Git/tool configuration, platform overlays, or change runtime linking.

## Implements

- `specs/linking-architecture.md` - `home/` maps managed regular files one-for-one below `$HOME`.

## Approach

1. Move `.zshenv`, `.zshrc`, `.zprofile`, `.zpreztorc`, and `starship.toml` into their equivalent `home/` paths.
2. Update repository references that must follow these source moves.
3. Preserve file modes and avoid adding generated, secret, or machine-specific state to `home/`.

## Validation

- [ ] Every migrated file maps one-for-one from `home/` to its intended `$HOME` destination.
- [ ] Shell bootstrap references resolve to the migrated paths.
- [ ] No secret, generated, or mutable state is added to `home/`.
- [ ] The focused source-layout checks pass.

## Risks / unknowns

- **Shell bootstrap** - `.zshenv` must remain usable before `ZDOTDIR` is configured.

## Notes

(Populated at closeout.)

## Follow-ups

None.
