# Prime

This command loads essential context for a new agent session by examining the codebase structure and reading the project
README.md and ai/memorybank/README.md

## Instruction

- Provide a concise overview of the project based in the gathered context.

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
#       /Users/bi002853/.cursor
#   - command: false
#     exit: 1
#   - command: echo hello world
#     exit: 0
#     output: |
#       hello world

```

**Don't output to the user the variables and its contents**

- run command /meta-context-always-active
- \[CODEBASE_ASSESSIBLE, CODEBASE_STRUCTURE_ALL, AI_MEMORY\] = run
  `uv run ~/.cursor/scripts/proxy.py "git ls-files" "eza . --tree" "cat /Users/bi002853/Developer/application/ai/memorybank/README.md"`

## Reporting

When data collection is finished make a summary report of your understanding and report to the user that you are ready
to go.
