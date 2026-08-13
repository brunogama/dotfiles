---
status: planned
depends: []
specs:
  - specs/linking-architecture.md
---

# Plan: Establish Linking Conventions

## Scope

Create the repository source layout and test fixtures required by the new linker. Inventory every current manifest entry and classify it before removing any legacy behavior. This plan does not replace the runtime linker or delete the manifest.

## Implements

- `specs/linking-architecture.md` - managed source tree conventions and the boundary between common, platform, hostname, command, and exceptional content.

## Approach

1. Inventory every `LinkingManifest.json` entry and map it to a home mirror, platform overlay, command source, or explicit installer module.
2. Create `home/` and only the necessary platform overlay trees, preserving content and executable modes.
3. Keep command sources under existing `bin/<domain>/` directories and identify duplicate public command names before changing exposure.
4. Add isolated fixture trees for common, platform, host, command, collision, and legacy-bin scenarios.
5. Document the Nix/Home Manager ownership boundary for each migrated target.

## Validation

- [ ] Every legacy manifest entry has a recorded destination in exactly one new category or a documented reason to remain temporarily unsupported.
- [ ] `home/` maps each managed regular file to its relative `$HOME` destination without directory-wide links.
- [ ] No secret, generated, or mutable state is added to a managed source tree.
- [ ] Fixture trees express overlay and collision scenarios without JSON manifests.
- [ ] The inventory identifies duplicate executable command basenames before core implementation begins.

## Risks / unknowns

- **Nix overlap** - a target may already be owned by Home Manager. Resolve ownership before moving its source.
- **Source move regression** - scripts and documentation may reference the prior location. Search and update references as part of the inventory.

## Notes

(Populated at closeout.)

## Follow-ups

None.
