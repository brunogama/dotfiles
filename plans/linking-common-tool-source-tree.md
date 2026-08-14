---
status: done
depends: [linking-shell-support-source-tree]
specs:
  - specs/linking-architecture.md
---

# Plan: Migrate Common Git and Tool Source Tree

## Scope

Migrate common Git, Mise, and home-sync configuration into `home/` after confirming their ownership boundary. This plan does not migrate Darwin-only files, expose commands, or change runtime linking.

## Implements

- `specs/linking-architecture.md` - common managed files live below `home/`; Home Manager and Nix retain their existing ownership.

## Approach

1. Move the common Git configuration files, Mise configuration, and home-sync configuration to their destination-equivalent `home/` paths.
2. Reconcile each target against existing Nix and Home Manager declarations before moving it.
3. Update repository references that must follow the source moves.

## Validation

- [x] Each migrated common tool file maps one-for-one from `home/` to its intended `$HOME` destination.
- [x] No target owned by existing Nix or Home Manager declarations is duplicated.
- [x] Git and tool configuration references resolve to the migrated paths.
- [x] The focused source-layout checks pass.

## Risks / unknowns

- **Configuration ownership** - Home Manager declarations may overlap with existing source files; do not create competing ownership.

## Notes

(Populated at closeout.)

## Follow-ups

None.
