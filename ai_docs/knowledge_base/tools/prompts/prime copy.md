---
description: Context collecting command to add information to the LLM. Use before starting any development activity
inputs: [[OPTIONAL PARAMETER "--verbose, -v"]]
---

# Prime

Context collecting command to add information to the LLM. Use before starting any development activity

______________________________________________________________________

## Instruction

- Provide a concise overview of the project based in the gathered context.

______________________________________________________________________

## Variables

- Variables will be set in tuple like pseudo code, the sequence of shell commands will be set in the sequence of the
  variables inside the tuple

**Sample**

```md

- [VAR_1, VAR_2, VAR_3] = run `uv run $(realpath .)/scripts/proxy.py "realpath ." "false" "echo hello world"`
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

- DEVELOPER = "Bruno da Gama Porciuncula"
- TEMPLATE_PATH = "${HOME}/.cursor/templates"
- SCRIPTS_PATH = "${HOME}/.cursor/scripts"
- IDE = "Cursor"

\*\*DYNAMIC VARS COMMAND TO BE EXECUTED BY PROXY

- \[CMD_DICTIONARY\] = "TIME_STAMP": "date -u +%Y-%m-%dT%H:%M:%SZ" "CWD_TREE": "eza . --tree || tree .",
  "MEMORY_BANK_README": "test -f CWD/ai/memorybank/README.md && cat CWD/ai/memorybank/README.md", "LAST_LOGS":
  "git last-commits 5", "GIT_BRANCH": "git branch --show-current" \]

- Dynamic vars cretion \[\[ MAPS CMD_DICTIONARY KEYS INTO VARIABLES COMMA SEPARATED\]\] = run
  `uv run CWD/.cursor/scripts/proxy.py [[ FOR EACH CMD_DICTIONARY VALUE ]].map({ [[ GET VALUE AND ADD SUFFIX " || true && && echo 'NULL" ]] }).JOINED([[ BLANK SPACE ]])`

______________________________________________________________________

## Reporting

When data collection is finished make a summary report in ten lines, project name and core modules.
