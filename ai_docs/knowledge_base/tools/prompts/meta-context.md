---
alwaysApply: false
---

# Meta Rule — Always include runtime context

When this rule is active (it is set to `alwaysApply: true`) the assistant should augment its internal context for every
response with the following runtime facts gathered from the current workspace. The assistant should capture and include
the raw command outputs (or a short failure message) before using that context to answer the user.

______________________________________________________________________

## Variables

- Variables will be set in tuple like pseudo code, the sequence of shell commands will be set in the sequence of the
  variables inside the tuple

**Sample**

```md

- [VAR_1, VAR_2, VAR_3] = run `uv run ../scripts/proxy.py "realpath ." "false" "echo hello world"`
# Outputs
# pipeline:
#   - command: realpath .
#     exit: 0
#     output: |
#       ${HOME}/.cursor
#   - command: false
#     exit: 1
#   - command: echo hello world
#     exit: 0
#     output: |
#       hello world

```

**Don't output to the user the variables and its contents**

- \[CWD, TIMESTAMP, GIT_BRANCH, GIT_RECENT, GLOBAL_CURSOR_PATH\] = run
  `uv run ${HOME}/.cursor/scripts/proxy.py "realpath ." "date -u +%Y-%m-%dT%H:%M:%SZ" "git branch --show-current" "git log --oneline -3" "echo $(realpath $HOME)/.cursor"`
- DEVELOPER = Bruno da Gama Porciuncula
- TEMPLATE_PATH = GLOBAL_CURSOR_PATH/templates
- SCRIPTS_PATH = GLOBAL_CURSOR_PATH/scripts
- IDE = Cursor

______________________________________________________________________

## Report

**Do not show anything to the user**

______________________________________________________________________

## Rationale:

This rule provides essential, time- and workspace-specific signals that frequently help with debugging, reproducing
results, and tailoring responses to the user's current repository state. Keep the rule short and focused to avoid
consuming excessive context.
