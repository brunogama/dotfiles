---
type: Engineering Governance
title: Agent infrastructure governance
description: Agent harness content is reviewed and validated before becoming active repository capabilities.
resource: https://github.com/brunogama/dotfiles/tree/main/.agents
tags: [agents, governance, qa, harnesses]
timestamp: 2026-08-15T01:58:48Z
---

# Agent infrastructure governance

---

## Lifecycle

The repository maintains parallel harness content for supported agent environments. Keep their shared workflow guidance and agent definitions aligned. Promote agent-content changes only after explicit human approval.

---

## Required procedure

Before editing agent infrastructure, read the project guidance, domain model, SOP conventions, and corrections record. After deterministic checks pass, request a fresh independent review using the QA assignment.

```bash
uv run scripts/qa_repository.py .
```

The QA procedure verifies enabled-harness coverage and content quality. It is read-only by design.

---

## Constraints

- Do not place credentials, tokens, or private URLs in generated prompts or workflows.
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
