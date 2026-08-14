---
status: planned
depends: [linker-lifecycle-and-migration]
specs:
  - specs/linking-architecture.md
---

# Plan: Integrate and Retire Manifest Linking

## Scope

Wire the completed linker into installation and user-facing workflows, add exceptional platform modules, migrate integration tests and documentation, then remove the JSON manifest system. This plan does not expand Home Manager or Nix ownership.

## Implements

- `specs/linking-architecture.md` - exceptional installer consistency and the declared scope boundary.

## Approach

1. Update `install`, script-only behavior, help output, and PATH guidance to use `link-dotfiles apply` and `~/.local/bin`.
2. Add the Darwin Folder Actions installer module using the main linker's dry-run, collision, confirmation, and ownership rules.
3. Replace manifest fixtures and tests with convention-tree integration tests.
4. Remove manifest validation hooks and all active manifest references from documentation.
5. Delete `LinkingManifest.json`, manifest parser paths, schema references, and obsolete fixtures only after all preceding validation passes.

## Validation

- [ ] Installer and help flows invoke the convention linker and document explicit legacy migration.
- [ ] Exceptional installer modules follow the main linker's safety and ownership contract.
- [ ] Integration tests cover clean install, collision handling, overlay resolution, migration, pruning, and partial-failure recovery.
- [ ] ShellCheck passes for every changed shell script and Python compilation passes for the linker.
- [ ] Repository search finds no active manifest workflow or `~/local/bin` guidance outside intentional migration history.
- [ ] A clean temporary HOME and an isolated XDG state directory complete an end-to-end apply successfully.

## Risks / unknowns

- **Documentation drift** - broad historical documentation may mention the manifest. Search globally and distinguish intentional history from active instructions.
- **Platform exception drift** - keep exceptional installation modules small and test them through the same safety contract.

## Notes

- First integration slice routes `install --scripts-only` through the convention linker with a commands-only plan, making `~/.local/bin` the sole command target.
- Commands-only state updates preserve prior ownership records so a later prune can still clean stale home-tree links.
- The obsolete `~/.local` to `~/local` migration is no longer invoked during full installation; its implementation and broader documentation remain a follow-up slice.
- Second integration slice adds `bin/macos/install-folder-actions`, which delegates to the main linker and corrects the legacy `.scptn` destination mismatch to the source's `.scpt` extension.
- Third integration slice retires the manifest validation hook, its pre-commit and CI registrations, and corresponding hook tests. Manifest content remains until the dedicated retirement slice.
- Fourth integration slice retires the unused manifest fixture and replaces the new-machine manifest-presence assertion with convention-linker source-tree coverage.
- Fifth integration slice updates the README, quick start guide, and interactive help to describe convention-based linking and `~/.local/bin` command exposure.
- Sixth integration slice updates IDE repository discovery and script-reference documentation to use convention-linker markers instead of the manifest.

## Follow-ups

None.
