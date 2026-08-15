---
type: Engineering Governance
title: Agent infrastructure governance
description: Agent skills and harness content are staged, reviewed, and validated before becoming active repository capabilities.
resource: https://github.com/brunogama/dotfiles/tree/main/.agents
tags: [agents, skills, governance, qa, harnesses]
timestamp: 2026-08-15T01:58:48Z
---

# Agent infrastructure governance

---

## Lifecycle

New or changed skills begin as candidates in the appropriate harness-specific `_candidates/` directory. No candidate becomes active until collection, induction, deduction, de-duplication, and explicit human approval are complete. Do not promote candidates or record them as active without that approval.

The repository maintains parallel harness content for supported agent environments. Keep their shared workflow guidance and active skill state aligned.

---

## Required procedure

Before editing agent infrastructure, read the project guidance, domain model, SOP conventions, and corrections record. After deterministic checks pass, request a fresh independent review using the QA assignment.

```bash
uv run scripts/qa_repository.py .
```

The QA procedure verifies enabled-harness coverage, candidate lifecycle safety, external skill-source safety, and content quality. It is read-only by design.

---

## Constraints

- Do not enable or execute an external skill source before review.
- Do not place credentials, tokens, or private URLs in generated prompts or workflows.
- Do not edit the skills log for an unapproved candidate.
- Changes to this area also follow the [repository validation](../operations/validation.md) pull-request gate.

---

## Citations

[1] [Project instructions](../../AGENTS.md)
[2] [Shared agent instructions](../../docs/agents/AGENTS.md)
[3] [QA assignment](../../qa/QA_AGENT.md)
[4] [Claude harness workflow](../../CLAUDE.md)
[5] [Domain model](../../docs/domain.md)
[6] [SOP conventions](../../docs/sop-conventions.md)
[7] [Corrections record](../../learnings/CORRECTIONS.md)
