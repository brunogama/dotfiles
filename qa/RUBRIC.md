# Agent repository QA rubric

| Category | Pass condition |
|---|---|
| Determinism | The local QA command passes and managed hashes are valid. |
| Harness coverage | Every enabled harness has instructions, skills, commands or documented fallbacks, and QA access. |
| Lifecycle | Candidate staging exists and promotion requires explicit approval. |
| External sources | Sources are reviewable, disabled by default, and never auto-installed. |
| Content quality | Files are coherent, project-specific, and free of unresolved template markers. |
| CI safety | GitHub Actions runs deterministic checks without LLM credentials. |
