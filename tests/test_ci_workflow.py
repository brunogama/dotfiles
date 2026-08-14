"""Regression tests for CI changed-path job gating."""

from __future__ import annotations

import re
import unittest
from pathlib import Path


WORKFLOW_PATH = Path(__file__).parents[1] / ".github/workflows/ci.yml"


class ScopedCiWorkflowTest(unittest.TestCase):
    """Ensure resource-intensive jobs run only for relevant changes."""

    def setUp(self) -> None:
        self.workflow = WORKFLOW_PATH.read_text(encoding="utf-8")

    def test_change_detection_exposes_all_scope_outputs(self) -> None:
        for scope in [
            "common",
            "validation",
            "nix",
            "installation",
            "home_sync",
            "integration",
            "documentation",
        ]:
            self.assertIn(f"steps.filter.outputs.{scope}", self.workflow)

    def test_push_change_detection_checks_out_the_repository_first(self) -> None:
        changes_job = re.search(
            r"^  changes:\n(?P<body>.*?)(?=^  \w[\w-]*:\n|\Z)",
            self.workflow,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertIsNotNone(changes_job)
        changes_body = changes_job.group("body") if changes_job else ""
        self.assertLess(
            changes_body.index("actions/checkout@"),
            changes_body.index("dorny/paths-filter@"),
        )
        self.assertIn("fetch-depth: 0", changes_body)

    def test_manual_dispatch_marks_all_scopes_as_changed(self) -> None:
        self.assertIn(
            "github.event_name == 'workflow_dispatch' && 'true'",
            self.workflow,
        )
        self.assertIn(
            "if: github.event_name != 'workflow_dispatch'",
            self.workflow,
        )

    def test_each_heavy_job_is_gated_by_changed_paths(self) -> None:
        expected_scopes = {
            "validate": "validation",
            "validate-nix": "nix",
            "install-nix-macos": "nix",
            "test-macos": "installation",
            "test-linux": "installation",
            "test-python": "home_sync",
            "mutation-testing": "home_sync",
            "test-integration-macos": "integration",
            "test-integration-linux": "integration",
            "documentation": "documentation",
        }

        for job, scope in expected_scopes.items():
            with self.subTest(job=job):
                match = re.search(
                    rf"^  {re.escape(job)}:\n(?P<body>.*?)(?=^  \w[\w-]*:\n|\Z)",
                    self.workflow,
                    flags=re.MULTILINE | re.DOTALL,
                )
                self.assertIsNotNone(match)
                job_body = match.group("body") if match else ""
                self.assertIn("github.event_name == 'workflow_dispatch'", job_body)
                self.assertIn(
                    f"needs.changes.outputs.{scope} == 'true'",
                    job_body,
                )

    def test_validate_runs_before_every_job_that_requires_it(self) -> None:
        validate_job = re.search(
            r"^  validate:\n(?P<body>.*?)(?=^  \w[\w-]*:\n|\Z)",
            self.workflow,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertIsNotNone(validate_job)
        validate_body = validate_job.group("body") if validate_job else ""
        for scope in ["nix", "installation", "home_sync", "integration"]:
            with self.subTest(scope=scope):
                self.assertIn(
                    f"needs.changes.outputs.{scope} == 'true'",
                    validate_body,
                )

    def test_nix_install_waits_for_all_required_validation(self) -> None:
        install_job = re.search(
            r"^  install-nix-macos:\n(?P<body>.*?)(?=^  \w[\w-]*:\n|\Z)",
            self.workflow,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertIsNotNone(install_job)
        install_body = install_job.group("body") if install_job else ""
        self.assertIn("needs: [changes, validate, validate-nix]", install_body)
        self.assertIn("needs.validate.result == 'success'", install_body)

    def test_scopes_include_workflow_configuration_and_relevant_sources(self) -> None:
        self.assertIn("- '.github/workflows/ci.yml'", self.workflow)
        self.assertIn("- 'nix/**'", self.workflow)
        self.assertIn("- 'flake.nix'", self.workflow)
        self.assertIn("- 'flake.lock'", self.workflow)
        self.assertIn("- 'bin/core/home_sync/**'", self.workflow)
        self.assertIn("- 'tests/integration/core/**'", self.workflow)
        self.assertIn("- '**/*.md'", self.workflow)
        self.assertIn("- 'tests/test_ci_workflow.py'", self.workflow)

    def test_validate_job_runs_the_ci_workflow_regression_test(self) -> None:
        validate_job = re.search(
            r"^  validate:\n(?P<body>.*?)(?=^  \w[\w-]*:\n|\Z)",
            self.workflow,
            flags=re.MULTILINE | re.DOTALL,
        )
        self.assertIsNotNone(validate_job)
        validate_body = validate_job.group("body") if validate_job else ""
        self.assertIn("python tests/test_ci_workflow.py", validate_body)


if __name__ == "__main__":
    unittest.main()
