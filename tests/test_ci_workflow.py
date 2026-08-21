"""Regression tests for the serial, fail-fast CI pipeline across the split workflows."""

from __future__ import annotations

import re
import unittest
from pathlib import Path

REPO = Path(__file__).parents[1]

# Each workflow file and its jobs in serial (fail-fast) execution order.
SERIAL_CHAINS: dict[str, list[str]] = {
    ".depot/workflows/ci.yml": [
        "validate",
        "test-linux",
        "test-python",
        "mutation-testing",
        "test-integration-linux",
        "documentation",
    ],
    ".github/workflows/ci.yml": [
        "validate",
        "validate-nix",
        "test-macos",
        "test-integration-macos",
        "install-nix-macos",
    ],
}


def _job_body(workflow: str, job: str) -> str | None:
    match = re.search(
        rf"^  {re.escape(job)}:\n(?P<body>.*?)(?=^  \w[\w-]*:\n|\Z)",
        workflow,
        flags=re.MULTILINE | re.DOTALL,
    )
    return match.group("body") if match else None


class SerialPipelineTest(unittest.TestCase):
    """Ensure jobs run one-at-a-time and fail fast (downstream skipped on failure)."""

    def _workflow(self, name: str) -> str:
        return (REPO / name).read_text(encoding="utf-8")

    def test_first_job_is_the_validation_gate(self) -> None:
        for name, chain in SERIAL_CHAINS.items():
            with self.subTest(workflow=name):
                workflow = self._workflow(name)
                first = chain[0]
                body = _job_body(workflow, first)
                self.assertIsNotNone(body, f"{first} job missing")
                self.assertNotIn("needs:", body, f"{first} must be the entry point")

    def test_jobs_form_a_serial_chain(self) -> None:
        for name, chain in SERIAL_CHAINS.items():
            with self.subTest(workflow=name):
                workflow = self._workflow(name)
                for previous, current in zip(chain, chain[1:]):
                    with self.subTest(job=current):
                        body = _job_body(workflow, current)
                        self.assertIsNotNone(body, f"{current} job missing")
                        self.assertRegex(
                            body,
                            rf"(?m)^    needs: {re.escape(previous)}$",
                            f"{current} must depend on {previous}",
                        )

    def test_validate_runs_the_ci_workflow_regression_test(self) -> None:
        for name in SERIAL_CHAINS:
            with self.subTest(workflow=name):
                workflow = self._workflow(name)
                validate_body = _job_body(workflow, "validate") or ""
                self.assertIn("python tests/test_ci_workflow.py", validate_body)

    def test_no_path_gating_left_in_heavy_jobs(self) -> None:
        for name in SERIAL_CHAINS:
            with self.subTest(workflow=name):
                workflow = self._workflow(name)
                self.assertNotIn("dorny/paths-filter", workflow)
                self.assertNotIn("needs.changes", workflow)


if __name__ == "__main__":
    unittest.main()
