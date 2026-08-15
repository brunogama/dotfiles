# CLAUDE.md

READ AGENTS.md

---

## Scaffolded agent workflow

Follow `AGENTS.md` as the shared project and agent-infrastructure policy.

### Permissions

- Read repository files freely.
- Write candidate skills only under `.claude/_candidates/`.
- Promote candidates only after explicit human approval.
- Do not edit `learnings/SKILLS-LOG.md` for an unapproved candidate.

### Commands

- `/forge-skill` stages a candidate skill.
- `/qa` runs the repository QA procedure.
- `/peer-review` prepares a bounded peer review request.

## Local CI/CD quality gate

- Before creating or updating a pull request, run `scripts/local-ci.sh` and require every locally executable stage to pass.
- Treat a failed stage as a pull-request blocker. GitHub-only stages are recorded as skips in the results table.
- The runner isolates each macOS stage in a temporary workspace with its own `HOME`, XDG configuration, cache, state, and temporary paths. It must not write to the developer environment.
- The GitHub-only script help-message probe is intentionally skipped locally because arbitrary `--help` handlers may access host credentials or services.
- When changing macOS jobs in `.github/workflows/`, update `scripts/local-ci.sh` in the same change so its stage names, runtime pins, filesystem isolation, and destructive-stage handling match the workflow.
- Re-run the local CI executor after macOS workflow changes and require the updated executable stages to pass before creating or updating the pull request.
