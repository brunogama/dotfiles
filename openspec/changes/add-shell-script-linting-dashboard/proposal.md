# Shell Script Linting Dashboard

## Why

Shell script quality issues are scattered across individual shellcheck runs. There is no unified view of code quality across all 50+ scripts. Developers lack visibility into quality trends and most common issues.

## What Changes

- Add unified linting dashboard for all shell scripts
- Create quality metrics aggregation and reporting
- Implement trend tracking for code quality over time
- Add CI integration with quality gates
- Generate HTML reports with detailed issue breakdowns

## Impact

- Affected specs: New capability `linting-dashboard`
- Affected code:
  - New: `bin/core/lint-dashboard` unified linting tool
  - New: `scripts/generate-lint-report.sh` HTML report generator
  - New: `.github/workflows/linting-dashboard.yml` CI workflow
  - New: `tests/quality-metrics.json` metrics storage
  - Modified: Root Makefile with lint-all target
