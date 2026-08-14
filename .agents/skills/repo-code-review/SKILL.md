---
name: repo-code-review
description: Use when completing recurring Modern Dotfiles audits. Owns exhaustive severity-tagged repository checks. Do not use for initial diff reviews or CodeRabbit execution.
tags: [code-review, dotfiles, nix, shell, security]
date: 2026-08-14
candidate: true
triggers:
  - recurring full-codebase audit
  - post-review repository audit
  - installer or Nix activation standards update
  - shell, credential, Git, or synchronization standards update
---

# Audit Modern Dotfiles Review Standards

Apply this candidate checklist during recurring full-codebase audits of this Nix-first, macOS-oriented dotfiles repository.

## When to use

Use for recurring audits of `install`, `nix/`, `home*/`, `bin/`, `tests/`, `.github/`, or agent-harness directories.

Use after the `review` candidate establishes scope and evidence when an audit follows a specific diff.

Do not use for initial diff-review procedure or CodeRabbit execution.

---

## How to apply

1. Map audited modules to the relevant checklist sections.
2. Treat every Blocking item as merge-blocking until resolved or explicitly accepted.
3. Run the narrowest matching check from `.github/workflows/ci.yml` or `.github/workflows/qa.yml`.
4. Report findings with affected paths, impact, evidence, and required remediation.

---

## Tailored checklist

### Architecture & structure

- [ ] (Blocking) Verify `link-dotfiles.py` preserves Nix-owned target exclusions defined in `nix/home.nix`.
- [ ] (Blocking) Ensure installer changes retain `--nix` activation and `--scripts-only` command-linking behavior.
- [ ] (Blocking) Confirm public commands remain directly below `bin/<domain>/` for convention-based linking.
- [ ] (Warning) Check home-file changes distinguish `home/`, `home-darwin/`, and host-specific source roots.
- [ ] (Warning) Verify Nix activation and convention linking never manage the same target.
- [ ] (Nice-to-have) Flag new cross-domain scripts lacking a clear ownership boundary.

### Correctness & safety

- [ ] (Blocking) Verify link plans validate all collisions before creating directories or symlinks.
- [ ] (Blocking) Ensure pruning removes only ledger-proven links from `$XDG_STATE_HOME/dotfiles/links.json`.
- [ ] (Blocking) Confirm `home_sync` failures preserve Git savepoint rollback and non-fast-forward protections.
- [ ] (Blocking) Verify CLI `--config` behavior matches whether `load_config` is actually used.
- [ ] (Warning) Check daemon changes retain SIGTERM, SIGINT, and SIGHUP handling.
- [ ] (Warning) Ensure work-mode changes update `environment.zsh` atomically.

### Security & credentials

- [ ] (Blocking) Flag new credential storage outside Keychain, `credfile`, or `credmatch` workflows.
- [ ] (Blocking) Verify credential changes retain secret-safe logging and error messages.
- [ ] (Blocking) Confirm OpenSSL credential flows retain AES-256-CBC and PBKDF2 protections.
- [ ] (Blocking) Check linker changes require `--force --yes` before replacing collisions.
- [ ] (Blocking) Ensure pre-commit Gitleaks coverage remains enabled for maintained source files.
- [ ] (Blocking) Ensure `home-sync` rejects diverged repositories and requires `--force` for dirty repositories.

### Performance & reliability

- [ ] (Warning) Check sync loops avoid duplicate Git status, fetch, pull, or push operations.
- [ ] (Warning) Verify daemon interval changes retain interruptible sleep and metrics reporting.
- [ ] (Warning) Flag unbounded metrics-history growth in `home_sync` daemon changes.
- [ ] (Warning) Flag unbounded directory traversal in linker discovery or installer scanning.

### Testing

- [ ] (Blocking) Ensure Bats coverage exists under `tests/integration/` for changed user-facing shell behavior.
- [ ] (Blocking) Ensure pytest coverage exists under `bin/core/home_sync/tests/` for changed package behavior.
- [ ] (Blocking) Ensure `home_sync` coverage meets the CI-enforced 91% threshold.
- [ ] (Blocking) Ensure mutation score meets 80% when changing `bin/core/home_sync/home_sync/metrics.py`.
- [ ] (Warning) Verify `bin/test/run-tests` passes for shell changes across integration suites.
- [ ] (Warning) Verify macOS and Linux installer paths when modifying `install`.
- [ ] (Warning) Flag untested changes to credential, Git restore, worktree, or linker commands.
- [ ] (Blocking) Ensure regression tests cover every fixed destructive-operation defect.

### Style & conventions

- [ ] (Blocking) Ensure maintained Bash scripts use `set -euo pipefail`.
- [ ] (Warning) Check Bash conditionals prefer `[[ ... ]]` where Bash-specific syntax is appropriate.
- [ ] (Blocking) Flag any added ShellCheck suppression comments.
- [ ] (Blocking) Ensure `home_sync` Python remains typed and compatible with strict mypy.
- [ ] (Blocking) Ensure standalone Python scripts use `uv run` and PEP 723 metadata.
- [ ] (Warning) Ensure `.zshenv` initializes XDG paths and `.zshrc` contains interactive setup.
- [ ] (Nice-to-have) Ensure operational command output remains concise, deterministic, and scriptable.

### Dependencies & supply chain

- [ ] (Blocking) Check new Nix, npm, and pre-commit dependencies follow `MINDSET.MD` versioning policy.
- [ ] (Warning) Check GitHub Action version changes match existing workflow conventions.
- [ ] (Blocking) Confirm `flake.lock` changes accompany intentional Nix Flake input changes.
- [ ] (Warning) Ensure npm agent-tool dependencies remain compatible with Node.js `>=24`.
- [ ] (Warning) Ensure packages belong in `nix/packages.nix` unless Nix packaging is impractical.
- [ ] (Warning) Ensure Homebrew additions remain limited to declared macOS exceptions.
- [ ] (Blocking) Verify CI actions do not execute untrusted pull-request content with secrets.

### CI, automation & documentation

- [ ] (Blocking) Ensure workflow changes retain push and pull-request validation coverage.
- [ ] (Blocking) Verify `uv run scripts/qa_repository.py .` passes after agent-harness or scaffold changes.
- [ ] (Warning) Ensure CI retains `test_install.bats` and `test_work_mode.bats` installation coverage.
- [ ] (Warning) Ensure `README.md` documents installer, activation, linker, credential, or sync changes.
- [ ] (Warning) Ensure `docs/scripts/quick-reference.md` documents new public commands.
- [ ] (Nice-to-have) Ensure intentional Nix-first ownership deviations are documented in code and documentation.

---

## Integration

- `review` - Use first for generic diff scope, evidence collection, and review reporting.

---

## Evaluation

After each audit, record false positives, missed defects, and unchecked Blocking items with paths and evidence.

Revise a criterion only after three comparable audit outcomes establish a recurring gap.

Keep revisions staged as candidates and require deterministic QA plus independent review before promotion.
