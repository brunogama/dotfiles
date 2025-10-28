# Performance Testing

Automated performance regression testing framework for tracking and enforcing performance budgets.

## Overview

The performance testing system provides:

- **Baseline tracking** - Record and compare performance metrics over time
- **Automated benchmarking** - Measure zsh startup, script execution, and lazy-loading
- **CI enforcement** - Block merges that degrade performance beyond thresholds
- **Statistical analysis** - Mean, median, P95, P99 metrics
- **Historical tracking** - Performance trends over time

## Performance Budgets

### Zsh Startup
- **Budget**: 550ms (mean over 10 runs)
- **Threshold**: 10% degradation allowed
- **Target**: <500ms

### Script Execution
- **Budget**: Varies by script
- **Threshold**: 15% degradation allowed

### Lazy-Load Overhead
- **Budget**: 50ms per component
- **Threshold**: 20% degradation allowed

## Tools

### performance-baseline

Baseline tracking and comparison utility.

```bash
# Record current performance as baseline
performance-baseline record --metric zsh-startup --value 450

# Compare current performance against baseline
performance-baseline compare --metric zsh-startup --value 480

# Update baseline with new value
performance-baseline update --metric zsh-startup --value 420

# Show all baselines
performance-baseline show
```

### benchmark_zsh_startup.sh

Measure zsh startup performance.

```bash
# Run 10 iterations with 550ms threshold
tests/performance/benchmark_zsh_startup.sh 10 550

# Run and record as baseline
tests/performance/benchmark_zsh_startup.sh 10 550 --record
```

## Running Performance Tests

### Locally

```bash
# Zsh startup benchmark
tests/performance/benchmark_zsh_startup.sh

# With custom runs and threshold
tests/performance/benchmark_zsh_startup.sh 20 600

# Record baseline
tests/performance/benchmark_zsh_startup.sh 10 550 --record
```

### In CI

Performance tests run automatically on:
- Push to main or feature/** branches
- Pull requests to main
- Daily at 9 AM UTC (scheduled)

## Baseline File Format

Performance baselines are stored in `.performance-baselines.json`:

```json
{
  "version": "1.0",
  "updated": "2025-10-27T12:00:00Z",
  "metrics": {
    "zsh-startup": {
      "baseline_ms": 450,
      "threshold_pct": 10,
      "last_measured": 460,
      "history": [
        {"timestamp": "2025-10-27T12:00:00Z", "value": 450}
      ]
    }
  }
}
```

## Statistical Analysis

Each benchmark provides:

- **Mean**: Average across all runs
- **Median**: Middle value (50th percentile)
- **Min/Max**: Best and worst times
- **P95**: 95th percentile (worst 5% excluded)
- **P99**: 99th percentile (worst 1% excluded)

## Threshold Checks

Performance checks fail if:

1. **Absolute threshold exceeded**: Mean > budget (e.g., 550ms)
2. **Relative degradation**: Current > baseline × (1 + threshold%)

Example:
- Baseline: 450ms
- Threshold: 10%
- Max allowed: 495ms (450 × 1.10)
- Current: 480ms → PASS
- Current: 510ms → FAIL

## CI Integration

### Workflow Steps

1. **Checkout code**
2. **Install dependencies** (jq, bc)
3. **Run benchmarks**
4. **Compare against baselines**
5. **Upload results** as artifacts
6. **Generate report** in PR summary
7. **Fail build** on regression

### Performance Report

Each PR gets a performance summary showing:
- Current measurements
- Baseline comparisons
- Pass/fail status
- Historical trends

## Troubleshooting

### Benchmark fails inconsistently

**Cause**: Environmental noise (background processes, disk I/O)

**Solution**:
- Close unnecessary applications
- Increase number of runs for better statistical averaging
- Run during low system activity

### No baseline to compare against

**Cause**: First run or missing `.performance-baselines.json`

**Solution**:
```bash
# Record initial baseline
tests/performance/benchmark_zsh_startup.sh 10 550 --record
```

### Threshold too strict

**Cause**: Baseline recorded during optimal conditions

**Solution**:
```bash
# Update baseline with more realistic value
performance-baseline update --metric zsh-startup --value 480
```

## Best Practices

1. **Consistent environment** - Run benchmarks in similar conditions
2. **Warmup runs** - Discard first run to warm caches
3. **Statistical samples** - Use 10+ runs for reliability
4. **Reasonable thresholds** - Allow 10-20% variance for stability
5. **Track trends** - Monitor history for gradual degradation

## Adding New Metrics

1. **Define metric** in `.performance-baselines.json`:
```json
"my-metric": {
  "baseline_ms": 0,
  "threshold_pct": 15,
  "last_measured": 0,
  "history": []
}
```

2. **Create benchmark script**:
```bash
#!/usr/bin/env bash
# Measure your metric
# ...
# Record result
performance-baseline record --metric my-metric --value "${duration}"
```

3. **Add to CI workflow**:
```yaml
- name: Run my benchmark
  run: tests/performance/benchmark_my_metric.sh
```

## Performance Optimization Tips

If benchmarks fail due to genuine performance regression:

### Zsh Startup

1. **Profile startup**: Use `zsh-benchmark --detailed`
2. **Lazy-load more**: Defer expensive initializations
3. **Reduce plugins**: Remove unused plugins
4. **Compile configs**: Run `zsh-compile`

### Script Execution

1. **Profile scripts**: Add timing output
2. **Reduce external calls**: Minimize subprocess spawning
3. **Optimize loops**: Use built-in commands
4. **Cache results**: Store expensive computations

## Resources

- Baseline tracking: `bin/core/performance-baseline`
- Benchmarks: `tests/performance/benchmark_*.sh`
- CI workflow: `.github/workflows/performance-tests.yml`
- Baselines file: `.performance-baselines.json`
