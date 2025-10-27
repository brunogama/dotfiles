# /staged-files

Shows all files staged with its full path

## Variables

- STAGED_FILES = Run `git diff HEAD --name-only | sed "s|^|$(pwd)/|"`

## Workflow

- Run `git diff HEAD --name-only | sed "s|^|$(pwd)/|"`

## Report

- Present the list of STAGED_FILES
