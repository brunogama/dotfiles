---
status: done
depends: []
specs:
  - specs/linking-architecture.md
---

# Plan: Establish Linking Conventions

## Scope

Record a complete, reviewable inventory of the legacy manifest and its destination in the convention-based architecture. Repair the existing link-dotfiles integration-test assertions so the suite can serve as a reliable baseline. This plan does not move managed sources, replace the runtime linker, or remove the manifest.

## Implements

- `specs/linking-architecture.md` - managed-source-tree conventions, the boundary between managed files, public commands, internal support files, and exceptional installer modules.

## Approach

1. Inventory every `LinkingManifest.json` entry in one document, mapping it to `home/`, a platform tree, public command discovery, an explicit installer module, or an intentional non-migration.
2. Document the Nix/Home Manager ownership boundary for each mapped target.
3. Identify duplicate executable command basenames before source-tree migration begins.
4. Correct the existing Bats assertions to use the loaded bats-file API and a supported broken-link assertion.

## Validation

- [x] Every legacy manifest entry has a recorded destination in exactly one new category or a documented reason to remain temporarily unsupported.
- [x] The inventory identifies duplicate executable command basenames before source-tree migration begins.
- [x] The inventory records the Nix/Home Manager ownership boundary for each migrated target.
- [x] `bats tests/integration/core/test_link_dotfiles.bats` passes.

## Risks / unknowns

- **Nix overlap** - a target may already be owned by Home Manager. Resolve ownership before moving its source.
- **Historical test drift** - Bats helper APIs can shadow project helpers; preserve the intended integration assertions rather than weakening them.

## Notes

(Populated at closeout.)

## Follow-ups

None.
