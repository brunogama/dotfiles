# Pi harness

Pi reads shared `AGENTS.md` and `CLAUDE.md` context and discovers trusted project skills under `.pi/skills/`. Prompt commands live directly under `.pi/prompts/` because discovery is non-recursive.

Pi has no built-in project subagent directory. Use reusable delegation prompts and available peer-session tooling instead.
