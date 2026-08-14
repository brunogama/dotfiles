---
name: review
description: Use when reviewing Modern Dotfiles changes to shell, Python, Nix, configuration, workflows, or agent infrastructure before merge.
candidate: true
---

# Review Modern Dotfiles Changes

Review the immediate diff and its documented intent. Do not edit files or approve your own changes.

## Verify scope

---

- Confirm the change solves its stated problem without unrelated churn.
- Compare the change against `AGENTS.md`, relevant specs, and existing command behavior.
- For user-facing commands, inspect help text, failure modes, dry-run behavior, and recoverability.

## Verify implementation

---

- Shell: require `set -euo pipefail`, portable quoted expansions, and zero ShellCheck diagnostics.
- Python: require PEP 8, `uv` usage, explicit filesystem and subprocess errors, and targeted tests.
- Nix, launch agents, and installation scripts: verify idempotency, macOS boundaries, and safe no-op behavior.
- Linking, credentials, sync, and Git tooling: protect unmanaged data and never expose secret material.
- Agent infrastructure: keep skills under `_candidates` until documented lifecycle evidence and human approval permit promotion.

## Verify evidence

---

- Run or inspect the smallest relevant deterministic validation first, then required repository checks.
- For behavior changes, require a regression test that fails against prior behavior and passes with the change.
- Report findings by severity with file and line references, validation evidence, residual risk, and excluded work.

## Report format

---

```markdown
# Review: [change]

## Findings
- [severity] `path:line` - issue and required correction

## Validation
- [command]: PASS | FAIL

## Verdict
APPROVE | REQUEST CHANGES
```
