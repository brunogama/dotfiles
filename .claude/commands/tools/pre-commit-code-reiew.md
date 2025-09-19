Code review

Delegate to ios-fp agent

Goal:
1) Gather repo change context from Git first.
2) Read repository context from `@ONBOARDING.md`.
3) Detect and name architecture and file-organization patterns.
4) Review only files with changes (added/modified) in the current Git status and produce a focused code review.

Inputs:
- Repo onboarding: @ONBOARDING.md
- Changed files and diffs: Git working tree

Tools:
- Shell access for `git` commands (read-only)
- Your normal reasoning

Procedure:
1) Collect change context:
   - List changes: `git status --porcelain=v1`
   - For each changed path (statuses A, AM, M, R, C): fetch diff `git diff --unified=2 -- <path>`
   - If a new file: `git show :<path> || git show HEAD:<path> || cat <path>`
   - Optional context: `git log --oneline -n 20 -- <path>` to see recent intent
2) Read `@ONBOARDING.md` and extract intended architecture, module boundaries, naming, dependency rules, CI/lint standards, and review criteria.
3) Enumerate detected architecture patterns in the live codebase. Map them to the intended architecture. Flag mismatches.
4) Perform code review on only these diffs:
   - Correctness, safety, concurrency
   - iOS APIs, lifecycle, memory, threading
   - Architecture adherence, dependency direction, testability
   - Naming, style, access control, error handling
   - Performance, main-thread usage, async/await
   - Security, PII, secrets, network timeouts
   - Build settings, SPM/CocoaPods integration
5) Produce output as a single report.

Deliverables (in order):
A. **Architecture Patterns Detected**
   - Intended (from onboarding) vs Observed (from code), per module
   - Anti-patterns and drift

B. **File/Organization Patterns**
   - Folder conventions, file naming, test placement, resources

C. **Changed Files Review**
   - Table: `File | Change Type | Summary | Issues (H/M/L) | Suggested Fix`
   - Cite line ranges from the diff (e.g., `FooViewModel.swift:L42–L58`)
   - Provide Swift patches when feasible

D. **Cross-Cutting Risks**
   - Threading, retain cycles, error propagation, DI violations, feature flags

E. **Actionable Recommendations**
   - 5–10 prioritized items with owner hint and expected impact

Constraints:
- Stay within the changed diffs for comments; pull minimal context only as needed
- Be evidence-based; cite onboarding or diff lines
- Prefer Swift examples; use `// PATCH:` blocks for fixes
- If information is missing, state the assumption explicitly

Command snippets:
- List changes: `git status --porcelain=v1`
- Diff one file: `git diff --unified=2 -- <path>`
- Show added file: `git show :<path> || git show HEAD:<path> || cat <path>`
- Recent history for a path: `git log --oneline -n 20 -- <path>`

Now execute:
1) Run Git commands to collect changes and diffs.
2) Read `@ONBOARDING.md`.
3) Detect patterns and drift.
4) Review only added/modified files from Git status.
5) Output the full report using sections A–E.
