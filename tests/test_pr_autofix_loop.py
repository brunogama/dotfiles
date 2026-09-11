"""Regression tests for the PR autofix observer script."""

from __future__ import annotations

import importlib.machinery
import importlib.util
import sys
import unittest
from pathlib import Path

REPO = Path(__file__).parents[1]
SCRIPT = REPO / "scripts/pr-autofix-loop"


def _load_script_module():
    loader = importlib.machinery.SourceFileLoader("pr_autofix_loop", str(SCRIPT))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError("unable to load pr-autofix-loop")
    module = importlib.util.module_from_spec(spec)
    sys.modules[loader.name] = module
    loader.exec_module(module)
    return module


class PrAutofixLoopTest(unittest.TestCase):
    """Check blocker classification without touching GitHub."""

    def setUp(self) -> None:
        self.module = _load_script_module()

    def test_failed_check_requires_fix(self) -> None:
        blockers = self.module.classify_pull_request(
            {
                "reviewDecision": "",
                "statusCheckRollup": [
                    {
                        "name": "Validate",
                        "status": "COMPLETED",
                        "conclusion": "FAILURE",
                    }
                ],
            },
            [],
        )

        self.assertTrue(blockers.needs_fix)
        self.assertFalse(blockers.is_green)
        self.assertEqual(["Validate: FAILURE"], blockers.failing_checks)

    def test_pending_check_waits_without_fixing(self) -> None:
        blockers = self.module.classify_pull_request(
            {
                "reviewDecision": "",
                "statusCheckRollup": [
                    {"name": "Validate", "status": "IN_PROGRESS", "conclusion": ""}
                ],
            },
            [],
        )

        self.assertFalse(blockers.needs_fix)
        self.assertFalse(blockers.is_green)
        self.assertEqual(["Validate: IN_PROGRESS"], blockers.pending_checks)

    def test_unresolved_review_thread_requires_fix(self) -> None:
        blockers = self.module.classify_pull_request(
            {"reviewDecision": "", "statusCheckRollup": []},
            [
                {
                    "isResolved": False,
                    "path": "scripts/local-ci.sh",
                    "line": 42,
                    "comments": [
                        {
                            "author": {"login": "reviewer"},
                            "body": "Please handle this failure.",
                            "url": "https://example.invalid/comment",
                        }
                    ],
                }
            ],
        )

        self.assertTrue(blockers.needs_fix)
        self.assertIn("scripts/local-ci.sh:42", blockers.unresolved_threads[0])

    def test_prompt_includes_required_fixer_contract(self) -> None:
        blockers = self.module.classify_pull_request(
            {
                "number": 78,
                "title": "ci: gate agent PRs",
                "url": "https://example.invalid/pr/78",
                "headRefName": "feat/ci-failfast-pr-gate",
                "reviewDecision": "CHANGES_REQUESTED",
                "statusCheckRollup": [],
            },
            [],
        )

        prompt = self.module.build_fix_prompt(
            {
                "number": 78,
                "title": "ci: gate agent PRs",
                "url": "https://example.invalid/pr/78",
                "headRefName": "feat/ci-failfast-pr-gate",
            },
            blockers,
            local_check="scripts/local-ci.sh",
        )

        self.assertIn("PR #78", prompt)
        self.assertIn("CHANGES_REQUESTED", prompt)
        self.assertIn("scripts/local-ci.sh", prompt)
        self.assertIn("Commit only intentional fixes", prompt)


if __name__ == "__main__":
    unittest.main()
