"""Regression tests for the agent-evidence verifier."""

from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

if __name__ == "__main__":
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.verify_agent_evidence import (  # noqa: E402
    validate_attribution,
    validate_files_changed,
    validate_manifest,
)


def _valid_entry() -> dict:
    return {
        "agent": "pi",
        "run_id": "r1",
        "started_at": "t0",
        "ended_at": "t1",
        "exit_code": 0,
        "files_changed": ["a.txt"],
    }


def _valid_manifest(entries: list[dict] | None = None) -> dict:
    return {
        "identity": {"name": "agent", "email": "agent@example.com"},
        "entries": entries if entries is not None else [_valid_entry()],
    }


def _write_manifest(path: Path, manifest: dict) -> None:
    path.write_text(json.dumps(manifest), encoding="utf-8")


class ManifestValidationTest(unittest.TestCase):
    def test_valid_manifest_passes(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            _write_manifest(path, _valid_manifest())
            self.assertEqual(validate_manifest(path), [])

    def test_missing_manifest_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            failures = validate_manifest(Path(tmp) / "evidence.json")
        self.assertTrue(any("missing" in failure for failure in failures))

    def test_invalid_json_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            path.write_text("{not json", encoding="utf-8")
            self.assertTrue(validate_manifest(path))

    def test_array_manifest_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            _write_manifest(path, [_valid_entry()])  # type: ignore[arg-type]
            self.assertTrue(validate_manifest(path))

    def test_empty_entries_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            _write_manifest(path, _valid_manifest(entries=[]))
            self.assertTrue(validate_manifest(path))

    def test_missing_identity_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            manifest = _valid_manifest()
            del manifest["identity"]
            _write_manifest(path, manifest)
            failures = validate_manifest(path)
        self.assertTrue(any("identity" in failure for failure in failures))

    def test_missing_field_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            entry = _valid_entry()
            del entry["run_id"]
            _write_manifest(path, _valid_manifest(entries=[entry]))
            failures = validate_manifest(path)
        self.assertTrue(any("missing field" in failure for failure in failures))

    def test_files_changed_not_list_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "evidence.json"
            entry = _valid_entry()
            entry["files_changed"] = "a.txt"
            _write_manifest(path, _valid_manifest(entries=[entry]))
            failures = validate_manifest(path)
        self.assertTrue(
            any("files_changed must be a list" in failure for failure in failures)
        )


class GitRepoTest(unittest.TestCase):
    def _init_repo(self, tmp: Path) -> Path:
        repo = tmp / "repo"
        repo.mkdir()
        subprocess.run(["git", "init", "-q"], cwd=repo, check=True)
        return repo

    def _commit(self, repo: Path, message: str) -> None:
        (repo / "f.txt").write_text(message, encoding="utf-8")
        subprocess.run(["git", "add", "-A"], cwd=repo, check=True)
        subprocess.run(
            [
                "git",
                "-c",
                "user.name=agent",
                "-c",
                "user.email=agent@example.com",
                "commit",
                "-q",
                "-m",
                message,
            ],
            cwd=repo,
            check=True,
        )


class AttributionValidationTest(GitRepoTest):
    def test_attribution_passes_when_identity_matches(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            repo = self._init_repo(Path(tmp))
            self._commit(repo, "one")
            failures = validate_attribution(
                "HEAD", "agent", "agent@example.com", cwd=repo
            )
        self.assertEqual(failures, [])

    def test_attribution_fails_when_identity_differs(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            repo = self._init_repo(Path(tmp))
            self._commit(repo, "one")
            failures = validate_attribution(
                "HEAD", "someone-else", "other@example.com", cwd=repo
            )
        self.assertTrue(failures)


class FilesChangedValidationTest(GitRepoTest):
    def test_files_changed_matches(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            repo = self._init_repo(Path(tmp))
            self._commit(repo, "one")
            (repo / "f.txt").write_text("two", encoding="utf-8")
            manifest = repo / ".agents" / "evidence.json"
            manifest.parent.mkdir(parents=True)
            entry = _valid_entry()
            entry["files_changed"] = ["f.txt"]
            _write_manifest(manifest, _valid_manifest(entries=[entry]))
            failures = validate_files_changed(manifest, "HEAD", cwd=repo)
        self.assertEqual(failures, [])

    def test_files_changed_undeclared_fails(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            repo = self._init_repo(Path(tmp))
            self._commit(repo, "one")
            (repo / "f.txt").write_text("two", encoding="utf-8")
            manifest = repo / ".agents" / "evidence.json"
            manifest.parent.mkdir(parents=True)
            entry = _valid_entry()
            entry["files_changed"] = ["other.txt"]
            _write_manifest(manifest, _valid_manifest(entries=[entry]))
            failures = validate_files_changed(manifest, "HEAD", cwd=repo)
        self.assertTrue(any("undeclared" in failure for failure in failures))


if __name__ == "__main__":
    unittest.main()
