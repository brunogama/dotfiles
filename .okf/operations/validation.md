---
type: Validation Playbook
title: Repository validation
description: Validation combines focused checks with an isolated local executor that mirrors locally reproducible macOS CI stages.
resource: https://github.com/brunogama/dotfiles/blob/main/scripts/local-ci.sh
tags: [testing, ci, shellcheck, nix, bats, pytest, quality]
timestamp: 2026-08-15T01:29:12Z
---

# Repository validation

---

## Focused validation

Choose checks based on the changed surface:

| Surface | Command |
| --- | --- |
| Installer shell syntax | `bash -n install` |
| Nix static validation | `nix-validate --static` |
| Nix evaluation | `nix-validate` |
| Link-plan safety | `uv run bin/core/link-dotfiles.py --dry-run` |
| Integration behavior | `bin/test/run-tests` |
| Git smart merge | `python3 tests/test_git_smart_merge.py` |
| UV resolver | `python3 tests/test_uv_resolver.py` |

---

## Pull-request gate

Before creating or updating a pull request, run:

```bash
scripts/local-ci.sh
```

The runner creates an isolated workspace and separate `HOME`, XDG configuration, cache, state, and temporary paths for each locally executable macOS stage. A failed locally executable stage blocks the pull request. GitHub-only stages are recorded as skips rather than passed locally.

When a macOS GitHub Actions workflow job changes, update `scripts/local-ci.sh` in the same change and rerun it. The local stage names, runtime pins, isolation, and destructive-stage policy must remain aligned with the workflow.

---

## Agent-infrastructure validation

For changes to agent scaffolding, candidate skills, or harness content, run the deterministic repository QA checker before a fresh independent review:

```bash
uv run scripts/qa_repository.py .
```

See [agent infrastructure governance](../governance/agent-infrastructure.md) for the skill lifecycle and review requirements.

---

## Citations

[1] [Validation guidance](../../README.md)
[2] [Local CI executor](../../scripts/local-ci.sh)
[3] [Repository QA checker](../../scripts/qa_repository.py)
[4] [Project instructions](../../AGENTS.md)
