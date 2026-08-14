---
status: done
depends: [linking-common-tool-source-tree]
specs:
  - specs/linking-architecture.md
---

# Plan: Migrate Platform Source Tree

## Scope

Migrate Darwin-only managed files into `home-darwin/` and classify the Folder Action as an explicit installer-module input. This plan does not implement the installer or change runtime linking.

## Implements

- `specs/linking-architecture.md` - platform overlays and exceptional targets use explicit source trees and installer modules.

## Approach

1. Move the Darwin Git attributes, Brewfile, and home-sync launch-agent source into destination-equivalent `home-darwin/` paths.
2. Record the Folder Action script as input to a future explicit Darwin installer module.
3. Update references that must follow the source moves without taking ownership from Nix or Home Manager.

## Validation

- [x] Each Darwin-only managed file maps one-for-one from `home-darwin/` to its intended `$HOME` destination.
- [x] The Folder Action remains outside home mirroring and command exposure.
- [x] No target owned by existing Nix or Home Manager declarations is duplicated.
- [x] The focused source-layout checks pass.

## Risks / unknowns

- **Folder Action target** - resolved by the explicit Darwin installer, which links the source using the canonical `.scpt` extension and is covered by Darwin-only integration tests.

## Notes

- The Folder Action remains an exceptional installer input. The completed Darwin installer delegates to the main linker and uses the source's canonical `.scpt` destination extension.
- The Darwin Git attributes, Brewfile, and home-sync launch agent now map from `home-darwin/` to their destination-equivalent paths.

## Follow-ups

None.
