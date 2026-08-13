---
status: in-progress
depends: [convention-linker-apply]
specs:
  - specs/linking-architecture.md
---

# Plan: Add Link Lifecycle and Legacy Migration

## Scope

Add explicit stale-link pruning and one-time `~/local/bin` migration on top of the convention-based apply engine. Normal apply must remain non-destructive to the legacy directory.

## Implements

- `specs/linking-architecture.md` - proven ownership, relocation-safe pruning, and explicit legacy command migration.

## Approach

1. Implement `prune` using ownership state, current desired targets, and verified symlink identity.
2. Treat a link pointing to a prior recorded checkout after relocation as stale only when the ledger proves ownership.
3. Implement `migrate-legacy-bin` as a dry-run-capable, confirmed workflow.
4. Remove only demonstrably legacy managed links automatically; require confirmation before backing up unmanaged legacy objects.
5. Install new command links only after migration succeeds, and leave the legacy directory in place.

## Validation

- [ ] `prune` refuses untracked symlinks, regular files, and directories.
- [ ] `prune` handles a repository relocation using recorded ownership identity.
- [ ] Normal `apply` makes no change beneath `~/local/bin`.
- [ ] Legacy managed links migrate to `~/.local/bin` without affecting unmanaged entries.
- [ ] Unmanaged legacy entries require confirmation and are preserved in a timestamped backup when accepted.
- [ ] All migration and prune paths are safe in dry-run mode.

## Risks / unknowns

- **Ambiguous historical links** - never infer ownership from path names alone; leave uncertain entries unchanged.
- **Interrupted migration** - apply state changes incrementally and make retry behavior explicit and testable.

## Notes

- First lifecycle slice adds a dry-run-capable `--prune` operation. It deletes only a target that remains a symlink to the exact source recorded in valid ownership state.
- Repository identity now prefers the Git origin URL so newly written state remains stable when the checkout relocates.
- Explicit legacy `~/local/bin` migration remains the next slice.

## Follow-ups

None.
