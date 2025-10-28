# Performance Regression Testing

## Why

Zsh startup performance has been optimized to <500ms, but there is no automated tracking to prevent performance regressions. Manual benchmarking is inconsistent and regressions can go unnoticed until users complain.

## What Changes

- Add automated performance baseline tracking system
- Implement CI enforcement for performance thresholds
- Create performance benchmarking utilities
- Add automated alerts for performance degradation
- Track metrics: zsh startup time, script execution time, lazy-load overhead

## Impact

- Affected specs: New capability `performance-testing`
- Affected code:
  - New: `tests/performance/` directory with benchmark scripts
  - New: `bin/core/performance-baseline` tracking utility
  - Modified: `.github/workflows/` for CI performance checks
  - Modified: `bin/core/zsh-benchmark` enhanced with baseline comparison
  - New: `.performance-baselines.json` for storing baseline metrics
