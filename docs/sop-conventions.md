# SOP and skill conventions

## Create a skill when

- The work involves repeatable tool calls, commands, or API interactions.
- An agent can follow the instructions to reproduce a technical outcome.
- The skill has a clear activation trigger and ownership boundary.

## Create an SOP when

- The content is a governance or process rule.
- The rule applies across several tools or skills.

## Lifecycle

1. Collect evidence from a completed task.
2. Induce a candidate under `_candidates/`.
3. Deductively verify from a fresh context.
4. Check overlap with active skills.
5. Request explicit human approval.
6. Promote and log only after approval.
