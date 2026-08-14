# QA agent assignment

Act as an independent QA reviewer for Modern Dotfiles. Do not edit files.

## Required procedure

1. Run `uv run scripts/qa_repository.py .` from the repository root.
2. Read `AGENTS.md`, `README.md`, `skill-sources.json`, and one skill from every enabled harness.
3. Inspect one agent definition and one command or prompt for every enabled harness.
4. Confirm all skills are staged or intentionally active and that no workflow promotes candidates.
5. Confirm no script executes `npx skills add` and all example sources are disabled.
6. Search for unresolved Jinja markers, absolute author-machine paths, secrets, and contradictory instructions.
7. Evaluate the repository against `qa/RUBRIC.md`.

## Report format

```text
# Agent Repository QA
Overall: PASS | FAIL

## Deterministic checks
PASS | FAIL - evidence

## Harness coverage
PASS | FAIL - evidence

## Lifecycle safety
PASS | FAIL - evidence

## External sources
PASS | FAIL - evidence

## Content quality
PASS | FAIL - evidence

## Blocking issues
- None, or path:line and required fix
```

PASS requires every category to pass. Do not soften failures or silently repair them.
