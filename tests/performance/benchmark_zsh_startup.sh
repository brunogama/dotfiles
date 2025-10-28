#!/usr/bin/env bash
set -euo pipefail

# Benchmark zsh startup performance

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
readonly PROJECT_ROOT

# Number of runs for statistical analysis
readonly NUM_RUNS="${1:-10}"
readonly THRESHOLD_MS="${2:-550}"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

echo -e "${BLUE}Benchmarking zsh startup performance...${NC}"
echo -e "Runs: ${NUM_RUNS}, Threshold: ${THRESHOLD_MS}ms\n"

# Array to store results
declare -a results

# Perform benchmark runs
for i in $(seq 1 "${NUM_RUNS}"); do
    echo -n "Run $i/${NUM_RUNS}... "

    # Measure startup time
    # Use non-interactive mode in CI, interactive mode locally
    start_time=$(date +%s%N)
    if [[ -n "${CI:-}" ]]; then
        # CI environment - use non-interactive mode
        zsh -c exit 2>/dev/null || true
    else
        # Local environment - use interactive mode for realistic measurement
        zsh -i -c exit 2>/dev/null || true
    fi
    end_time=$(date +%s%N)

    # Calculate duration in milliseconds
    duration=$(( (end_time - start_time) / 1000000 ))
    results+=("${duration}")

    echo "${duration}ms"
done

# Calculate statistics
echo -e "\n${BLUE}Statistical Analysis:${NC}"

# Sort results (bash 3.2 compatible)
IFS=$'\n'
# shellcheck disable=SC2207  # Intentional word splitting for sorting
sorted=($(printf '%s\n' "${results[@]}" | sort -n))
unset IFS

# Calculate mean
sum=0
for val in "${results[@]}"; do
    sum=$((sum + val))
done
mean=$((sum / NUM_RUNS))

# Calculate median
if (( NUM_RUNS % 2 == 0 )); then
    median=$(( (sorted[NUM_RUNS/2 - 1] + sorted[NUM_RUNS/2]) / 2 ))
else
    median="${sorted[NUM_RUNS/2]}"
fi

# Calculate p95 and p99
p95_idx=$(( NUM_RUNS * 95 / 100 ))
p99_idx=$(( NUM_RUNS * 99 / 100 ))
p95="${sorted[p95_idx]}"
p99="${sorted[p99_idx]}"

# Display results
# Calculate last index (bash 3.2 doesn't support negative indices)
last_idx=$((NUM_RUNS - 1))
echo -e "  Mean:     ${mean}ms"
echo -e "  Median:   ${median}ms"
echo -e "  Min:      ${sorted[0]}ms"
echo -e "  Max:      ${sorted[last_idx]}ms"
echo -e "  P95:      ${p95}ms"
echo -e "  P99:      ${p99}ms"

# Check against threshold
echo -e "\n${BLUE}Threshold Check:${NC}"
if (( mean > THRESHOLD_MS )); then
    echo -e "  ${RED}[ERROR] FAILED${NC} - Mean startup time (${mean}ms) exceeds threshold (${THRESHOLD_MS}ms)"
    exit 1
else
    echo -e "  ${GREEN}[OK] PASSED${NC} - Mean startup time (${mean}ms) within threshold (${THRESHOLD_MS}ms)"
fi

# Record baseline if requested
if [[ "${3:-}" == "--record" ]]; then
    echo -e "\n${YELLOW}Recording baseline...${NC}"
    "${PROJECT_ROOT}/bin/core/performance-baseline" record --metric zsh-startup --value "${mean}"
fi

exit 0
