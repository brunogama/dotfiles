# Development Constitution

**Version**: 2.1.0 • **Last Updated**: 2025-10-26

Core principles and non-negotiable standards for all code in this repository.

---

## Constitutional Rules

### Rule 1: All Directories MUST Be Lowercase

All directories must use lowercase names:
- Configuration directories (`git/`, `zsh/`, `fish/`)
- Script directories (`bin/`, `packages/`)
- Documentation directories (`ai_docs/`, `openspec/`)

**Rationale**: Consistency, cross-platform compatibility, Unix convention

### Rule 2: No Emojis in Documentation or Code

No emojis allowed in:
- Documentation (`.md` files)
- Script output
- Commit messages
- Code comments
- Help text

**Rationale**: Accessibility, terminal compatibility, professionalism, searchability

---

## Core Principles

- **KISS**: Clarity over cleverness. No premature abstractions.
- **SOLID**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
- **DRY**: Remove duplication without premature generalization.
- **YAGNI**: Build only what's required. No speculative features.

---

## Universal Bugfix Policy

Every bugfix MUST include:

1. **Red-First Testing**: Reproduce failure with failing test before fix
2. **Regression Suite**: Minimum 5 tests:
   - Original failing case
   - Input variants
   - Boundary conditions
   - Error paths
   - Happy path
3. **Zero-Failure**: All tests must pass before proceeding

---

## Swift Standards

**Type System**
- `struct`/`enum` by default
- `class` only for identity or ObjC interop
- Wrap all primitives in Domain Layers (String, Int, Double, Date, URL)
- Enforce invariants at initialization

**Code Style**
- One indent level maximum
- No `else` clauses - use `guard` and early return
- No getters (`getX()`)
- ≤200 lines per file
- ≤10 cyclomatic complexity
- ≤7 stored properties per type

---

## Shell Script Standards

**Header Template**
```sh
#!/usr/bin/env sh
set -euo pipefail
IFS=$'\n\t'
```

**Rules**
- POSIX-first (`/usr/bin/env sh`)
- Zero `shellcheck` errors
- Functions ≤40 lines
- Files ≤400 lines
- Never `eval` untrusted input
- Use `getopts` for arguments
- Trap cleanup on EXIT
- Idempotent operations
- Small, composable scripts

**Structure**
- Large tasks: separate directory
- Break down into smaller composable scripts

### Python Scripts

- PEP8 compliant
- UV header for external dependencies
- Scripts >500 lines become pip package

---

## Git Workflow

**Commit Format**: Conventional Commits
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`

**Rules**
- Subject ≤50 chars, imperative mood
- Body wraps at 72 chars
- Sign commits on protected branches
- PRs ≤400 lines (≤800 with justification)

---

## Security Requirements

**Mandatory Scanning**
- `shellcheck` for shell scripts
- `swiftlint` security rules
- Secret detection (trufflehog, git-secrets)
- Dependency scanning

**Rules**
- No secrets in code, comments, or history
- Input validation at all boundaries
- Mask secrets in CI logs
- Security review for auth/crypto/PII changes

---

## Testing Standards

**Coverage**
- Domain logic: ≥95%
- Tests deterministic, parallelizable, ≤1s runtime

**Property Tests**
- Add for value types (equality, hashing, associativity)

**Regression**
- Every bug generates ≥5 tests exploring vulnerabilities

---

## Documentation

**Required**
- README.md: Quickstart, examples
- CHANGELOG.md: Version history
- Per-feature README for complex modules

**Code Comments**
- Document WHY, not WHAT
- Explain invariants and constraints
- No commented-out code

---

## Dependency Management

**Version Ranges**
- Critical deps: Exact pin (`1.2.3`)
- Stable libs: Patch updates (`~1.2.3`)
- Most deps: Minor updates (`^1.2.3`)

**Approved Licenses**: MIT, Apache 2.0, BSD, ISC
**Blocked**: GPL, AGPL, proprietary

---

## Observability

**Logging**
- Structured JSON format
- Levels: DEBUG, INFO, WARN, ERROR, FATAL
- Include `trace_id` for distributed tracing
- No PII in logs

**Metrics**
- Latency (p50, p95, p99)
- Error rate
- Traffic (requests/sec)
- Saturation (queue depth)

---

## LLMs Guide

- Store task reports in `ai_docs/reports/{code-review,session-summaries,task-summaries}`
- Summarize with bullet points of key accomplishments
- Enumerate multiple-choice questions for easier response
