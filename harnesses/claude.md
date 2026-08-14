# Claude harness

Claude reads `CLAUDE.md`, discovers project skills under `.claude/skills/`, project agents under `.claude/agents/`, and commands under `.claude/commands/`.

Stage new skills in `.claude/_candidates/` until approval; this keeps them outside the recursively discovered skill root.
