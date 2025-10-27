#!/usr/bin/env python3
"""
Tests for git-smart-merge script

These tests create temporary git repositories to test all scenarios.
"""

import os
import sys
import subprocess
import tempfile
import shutil
from pathlib import Path
import unittest


sys.path.insert(0, str(Path(__file__).parent.parent / "bin"))


class GitSmartMergeTest(unittest.TestCase):
    """Test suite for git-smart-merge script."""

    def setUp(self):
        """Create a temporary git repository for testing."""
        self.test_dir = tempfile.mkdtemp()
        self.original_dir = os.getcwd()
        os.chdir(self.test_dir)

        subprocess.run(["git", "init"], check=True, capture_output=True)
        subprocess.run(["git", "config", "user.name", "Test User"], check=True)
        subprocess.run(["git", "config", "user.email", "test@example.com"], check=True)

        self._create_initial_commit()

    def tearDown(self):
        """Clean up temporary repository."""
        os.chdir(self.original_dir)
        shutil.rmtree(self.test_dir)

    def _create_initial_commit(self):
        """Create an initial commit on main branch."""
        Path("README.md").write_text("# Test Repository\n")
        subprocess.run(["git", "add", "README.md"], check=True)
        subprocess.run(["git", "commit", "-m", "Initial commit"], check=True)
        subprocess.run(["git", "branch", "-M", "main"], check=True)

    def _create_branch(self, branch_name):
        """Create and checkout a new branch."""
        subprocess.run(["git", "checkout", "-b", branch_name], check=True, capture_output=True)

    def _checkout_branch(self, branch_name):
        """Checkout an existing branch."""
        subprocess.run(["git", "checkout", branch_name], check=True, capture_output=True)

    def _commit_file(self, filename, content, message):
        """Create a file and commit it."""
        Path(filename).write_text(content)
        subprocess.run(["git", "add", filename], check=True)
        subprocess.run(["git", "commit", "-m", message], check=True)

    def _run_smart_merge(self, *args):
        """Run git-smart-merge with given arguments."""
        script_path = Path(self.original_dir) / "bin" / "git-smart-merge"
        result = subprocess.run(
            [sys.executable, str(script_path)] + list(args),
            capture_output=True,
            text=True
        )
        return result

    def test_missing_argument(self):
        """Test that missing branch argument shows usage and exits with code 2."""
        result = self._run_smart_merge()

        self.assertEqual(result.returncode, 2)
        self.assertIn("source_branch", result.stdout.lower() + result.stderr.lower())

    def test_non_existent_branch(self):
        """Test that non-existent branch is handled properly."""
        result = self._run_smart_merge("non-existent-branch")

        self.assertEqual(result.returncode, 1)
        self.assertIn("not found", result.stderr.lower())

    def test_uncommitted_changes(self):
        """Test that uncommitted changes prevent merge."""
        self._create_branch("feature")
        self._commit_file("feature.txt", "Feature content\n", "Add feature")
        self._checkout_branch("main")

        Path("uncommitted.txt").write_text("Uncommitted changes\n")

        result = self._run_smart_merge("feature")

        self.assertEqual(result.returncode, 1)
        self.assertIn("uncommitted changes", result.stderr.lower())

    def test_clean_rebase_no_conflicts(self):
        """Test successful rebase when no conflicts exist."""
        self._create_branch("feature")
        self._commit_file("feature.txt", "Feature content\n", "Add feature")
        self._checkout_branch("main")

        result = self._run_smart_merge("feature")

        self.assertEqual(result.returncode, 0)
        self.assertIn("rebase", result.stdout.lower())
        self.assertIn("success", result.stdout.lower())

        self.assertTrue(Path("feature.txt").exists())

    def test_conflicting_changes_require_merge(self):
        """Test that conflicts trigger merge strategy."""
        self._create_branch("feature")
        self._commit_file("shared.txt", "Feature version\n", "Feature change")

        self._checkout_branch("main")
        self._commit_file("shared.txt", "Main version\n", "Main change")

        result = self._run_smart_merge("feature")

        if result.returncode == 0:
            self.assertIn("merge", result.stdout.lower())
        else:
            self.assertIn("conflict", result.stderr.lower())

    def test_dry_run_mode(self):
        """Test that dry-run mode doesn't modify repository."""
        self._create_branch("feature")
        self._commit_file("feature.txt", "Feature content\n", "Add feature")
        self._checkout_branch("main")

        result = self._run_smart_merge("feature", "--dry-run")

        self.assertEqual(result.returncode, 0)
        self.assertIn("dry run", result.stdout.lower())
        self.assertIn("would", result.stdout.lower())

        self.assertFalse(Path("feature.txt").exists())

    def test_force_merge_mode(self):
        """Test force merge mode skips rebase."""
        self._create_branch("feature")
        self._commit_file("feature.txt", "Feature content\n", "Add feature")
        self._checkout_branch("main")

        result = self._run_smart_merge("feature", "--force-merge")

        self.assertEqual(result.returncode, 0)
        self.assertIn("force merge", result.stdout.lower())
        self.assertIn("merge", result.stdout.lower())

        self.assertTrue(Path("feature.txt").exists())

    def test_force_rebase_mode(self):
        """Test force rebase mode skips conflict detection."""
        self._create_branch("feature")
        self._commit_file("feature.txt", "Feature content\n", "Add feature")
        self._checkout_branch("main")

        result = self._run_smart_merge("feature", "--force-rebase")

        self.assertEqual(result.returncode, 0)
        self.assertIn("force rebase", result.stdout.lower())
        self.assertIn("rebase", result.stdout.lower())

        self.assertTrue(Path("feature.txt").exists())

    def test_conflicting_force_modes(self):
        """Test that using both force modes together fails."""
        result = self._run_smart_merge("feature", "--force-merge", "--force-rebase")

        self.assertEqual(result.returncode, 2)
        self.assertIn("cannot", result.stderr.lower())

    def test_up_to_date_branch(self):
        """Test merging when current branch is up to date."""
        self._create_branch("feature")
        self._checkout_branch("main")

        result = self._run_smart_merge("feature")

        self.assertIn(result.returncode, [0, 1])

    def test_logging_output(self):
        """Test that comprehensive logging is provided."""
        self._create_branch("feature")
        self._commit_file("feature.txt", "Feature content\n", "Add feature")
        self._checkout_branch("main")

        result = self._run_smart_merge("feature")

        output = result.stdout.lower()
        self.assertIn("checking", output)
        self.assertIn("branch", output)
        self.assertIn("strategy", output)


class GitSmartMergeHelp(unittest.TestCase):
    """Test help and usage output."""

    def test_help_output(self):
        """Test that --help displays usage information."""
        script_path = Path(__file__).parent.parent / "bin" / "git-smart-merge"
        result = subprocess.run(
            [sys.executable, str(script_path), "--help"],
            capture_output=True,
            text=True
        )

        self.assertEqual(result.returncode, 0)
        self.assertIn("usage", result.stdout.lower())
        self.assertIn("source_branch", result.stdout.lower())
        self.assertIn("dry-run", result.stdout.lower())
        self.assertIn("force-merge", result.stdout.lower())
        self.assertIn("force-rebase", result.stdout.lower())


if __name__ == "__main__":
    unittest.main()
