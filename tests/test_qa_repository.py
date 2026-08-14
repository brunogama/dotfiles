"""Regression tests for the generated agent-repository QA command."""

from __future__ import annotations

import json
import tempfile
import unittest
from pathlib import Path

from scripts.qa_repository import validate_repository


class RepositoryQaLifecycleTest(unittest.TestCase):
    """Verify that candidate staging is enforced when configured."""

    def test_rejects_active_skills_when_candidate_staging_is_required(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            self._write_required_files(repository_root)
            (repository_root / ".agent-scaffold").mkdir()
            (repository_root / ".agent-scaffold/dotfiles.toml").write_text(
                "[repository]\nrequire_candidate_staging = true\n",
                encoding="utf-8",
            )
            skill_path = repository_root / ".agents/skills/review/SKILL.md"
            skill_path.parent.mkdir(parents=True)
            skill_path.write_text(
                "---\nname: review\ndescription: Use when reviewing code.\n---\n",
                encoding="utf-8",
            )

            failures = validate_repository(repository_root)

        self.assertIn(
            "lifecycle: active skill .agents/skills/review/SKILL.md",
            failures,
        )

    def test_accepts_candidates_outside_discovered_skill_roots(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            self._write_required_files(repository_root, harnesses=["pi", "codex"])
            for relative_name in [
                ".pi/settings.json",
                ".pi/prompts/qa.md",
                ".agents/agents/qa.md",
            ]:
                path = repository_root / relative_name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("placeholder\n", encoding="utf-8")
            for relative_name in [
                ".pi/_candidates/skill-forge/SKILL.md",
                ".agents/_candidates/skill-forge/SKILL.md",
            ]:
                path = repository_root / relative_name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text(
                    "---\nname: skill-forge\ndescription: Stage a candidate skill.\n---\n",
                    encoding="utf-8",
                )

            failures = validate_repository(repository_root)

        self.assertFalse(
            any(failure.startswith("required: missing") for failure in failures),
            failures,
        )

    def _write_required_files(
        self, repository_root: Path, harnesses: list[str] | None = None
    ) -> None:
        for relative_name in [
            "AGENTS.md",
            "README.md",
            "qa/QA_AGENT.md",
            "qa/RUBRIC.md",
            "scripts/qa_repository.py",
        ]:
            path = repository_root / relative_name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text("placeholder\n", encoding="utf-8")
        (repository_root / ".agent-scaffold.json").write_text(
            json.dumps({"files": {}, "harnesses": harnesses or []}),
            encoding="utf-8",
        )
        (repository_root / "skill-sources.json").write_text(
            json.dumps({"sources": []}),
            encoding="utf-8",
        )


if __name__ == "__main__":
    unittest.main()
