"""Regression tests for the generated agent-repository QA command."""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

if __name__ == "__main__":
    sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from scripts.qa_repository import validate_repository


class RepositoryQaTest(unittest.TestCase):
    """Verify manifest, required-path, and text-file validation."""

    def test_ignores_local_generated_text_artifacts(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            self._write_required_files(repository_root)
            local_settings = repository_root / ".claude/settings.local.json"
            local_settings.parent.mkdir(parents=True)
            local_settings.write_text(str(Path.home()), encoding="utf-8")
            generated_file = repository_root / ".venv/lib/python/site.py"
            generated_file.parent.mkdir(parents=True)
            marker = f"{chr(123)}{chr(123)} generated {chr(125)}{chr(125)}\n"
            generated_file.write_text(marker, encoding="utf-8")

            failures = validate_repository(repository_root)

        self.assertFalse(failures, failures)

    def test_reports_missing_required_paths(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            repository_root = Path(temporary_directory)
            self._write_required_files(repository_root, harnesses=["codex"])
            # Create then remove a required codex path to trigger a failure.
            qa_agent = repository_root / ".agents/agents/qa.md"
            qa_agent.parent.mkdir(parents=True, exist_ok=True)
            qa_agent.write_text("placeholder\n", encoding="utf-8")
            qa_agent.unlink()

            failures = validate_repository(repository_root)

        self.assertIn("required: missing .agents/agents/qa.md", failures)

    def test_rejects_workflow_credential_contexts(self) -> None:
        expressions = [
            "secrets.NAME",
            "secrets['NAME']",
            "github.token",
            "github['token']",
        ]
        for expression in expressions:
            with self.subTest(expression=expression):
                with tempfile.TemporaryDirectory() as temporary_directory:
                    repository_root = Path(temporary_directory)
                    self._write_required_files(repository_root)
                    workflow = repository_root / ".depot/workflows/qa.yml"
                    workflow.write_text(
                        f"run: uv run scripts/qa_repository.py .\n"
                        f"env: ${{{{ {expression} }}}}\n",
                        encoding="utf-8",
                    )
                    failures = validate_repository(repository_root)

                self.assertIn("workflow: QA must not require secrets", failures)

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
        (repository_root / ".depot/workflows").mkdir(parents=True, exist_ok=True)
        (repository_root / ".depot/workflows/qa.yml").write_text(
            "run: uv run scripts/qa_repository.py .\n",
            encoding="utf-8",
        )


if __name__ == "__main__":
    unittest.main()
