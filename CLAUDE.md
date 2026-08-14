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

### Local CI/CD quality gate

- Before creating or updating a pull request, run `scripts/local-ci.sh --skip-remote-only` and require every locally executable stage to pass.
- Treat a failed stage as a pull-request blocker. Remote-only stages may be skipped only when the results table identifies them as remote-only.
- When changing `.github/workflows/`, update `scripts/local-ci.sh` in the same change so its job graph, declared matrix values, runtime pins, environment variables, and remote-only handling match the workflow.
- Re-run the local CI executor after workflow changes and require the updated executable stages to pass before creating or updating the pull request.
