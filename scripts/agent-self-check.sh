#!/usr/bin/env bash
# Agent pre-push self-check. Runs the same evidence verification and
# deterministic repository QA that CI's agent-evidence and deterministic-qa
# jobs run, so an agent can fail fast locally instead of red-lighting a PR.
#
# Usage: scripts/agent-self-check.sh [BASE_REF]

set -euo pipefail
IFS=$'\n\t'

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
base="${1:-main}"

cd "$root"

printf 'agent-self-check: verifying evidence against %s\n' "$base"
uv run scripts/verify_agent_evidence.py \
    --manifest .agents/evidence.json \
    --range "$base"

printf 'agent-self-check: running deterministic QA\n'
uv run scripts/qa_repository.py .
