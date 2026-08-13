---
status: planned
depends: [linking-platform-source-tree]
specs:
  - specs/linking-architecture.md
---

# Plan: Implement Convention-Based Apply

## Scope

Replace manifest parsing in `bin/core/link-dotfiles.py` with deterministic discovery and safe application of home trees and public commands. This plan establishes state tracking but does not yet ship legacy-bin migration, pruning, or final manifest retirement.

## Implements

- `specs/linking-architecture.md` - overlay precedence, one-file-per-link behavior, command uniqueness, collision safety, and ownership state.

## Approach

1. Add isolated convention-tree fixtures for common, platform, hostname, command, collision, and legacy-bin scenarios.
2. Change project-root detection to recognize the convention layout.
3. Build a deterministic plan from common, platform, and hostname trees, with later overlay sources winning and equal-precedence conflicts failing before mutation.
4. Discover executable regular files immediately under `bin/<domain>/`; reject duplicate command names before any filesystem mutation.
5. Preflight parent paths and target collisions. Correct links are no-ops; conflicts require explicit backup or replacement confirmation.
6. Persist a versioned ownership ledger with a stable repository identity and exactly the successfully applied entries. If a filesystem failure occurs after preflight, record completed operations atomically, report partial completion, and exit non-zero.

## Validation

- [ ] Fixture trees express common, platform, hostname, command, collision, and legacy-bin scenarios without JSON manifests.
- [ ] Common, platform, and hostname overlays produce the documented target precedence and verbose provenance.
- [ ] Equal-precedence target conflicts and duplicate command names fail before mutation.
- [ ] `apply` never overwrites an unexpected link, file, or directory without explicit confirmed backup or replacement.
- [ ] Correct existing links are idempotent no-ops.
- [ ] Public executable commands resolve through `~/.local/bin`.
- [ ] The ownership ledger includes repository identity and remains valid after partial-apply failure handling.

## Risks / unknowns

- **Partial mutation** - no portable filesystem transaction exists. Test failure recovery and rerun convergence with fault-injection seams where feasible.
- **State corruption** - fail safely and require explicit reconstruction rather than inferring ownership.

## Notes

(Populated at closeout.)

## Follow-ups

None.
