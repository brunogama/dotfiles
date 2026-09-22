#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Validate a generated agent repository without network or LLM access."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Any

JINJA_OPEN_BRACE = re.escape(chr(123))
JINJA_MARKER = re.compile(
    "(?<![$"
    + chr(123)
    + "])(?:"
    + JINJA_OPEN_BRACE
    + JINJA_OPEN_BRACE
    + "(?!"
    + JINJA_OPEN_BRACE
    + ")|"
    + JINJA_OPEN_BRACE
    + "%|"
    + JINJA_OPEN_BRACE
    + "#)"
)
TEXT_SUFFIXES = {".json", ".md", ".py", ".toml", ".txt", ".yml", ".yaml"}
TEMPLATE_DIRS = {".genesis"}  # project-ritual templates with intentional Jinja markers
SKIPPED_TEXT_PARTS = {
    ".git",
    ".venv",
    "node_modules",
}
SKIPPED_TEXT_FILES = {Path(".claude/settings.local.json")}


class RepositoryQaError(RuntimeError):
    """Reports one or more generated repository validation failures."""


def validate_repository(repository_root: Path) -> list[str]:
    """Return all deterministic QA failures for a generated repository."""
    failures: list[str] = []
    manifest_path = repository_root / ".agent-scaffold.json"
    try:
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        return [f"manifest: {error}"]

    failures.extend(_validate_manifest_hashes(repository_root, manifest))
    failures.extend(_validate_required_paths(repository_root, manifest))
    failures.extend(_validate_text_files(repository_root))
    failures.extend(_validate_workflow(repository_root))
    return failures


def _validate_manifest_hashes(
    repository_root: Path, manifest: dict[str, Any]
) -> list[str]:
    failures: list[str] = []
    files = manifest.get("files")
    if not isinstance(files, dict):
        return ["manifest: files must be an object"]
    for relative_name, expected_hash in files.items():
        path = repository_root / relative_name
        if not path.is_file():
            failures.append(f"manifest: missing {relative_name}")
            continue
        actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual_hash != expected_hash:
            failures.append(f"manifest: changed {relative_name}")
    return failures


def _validate_required_paths(
    repository_root: Path, manifest: dict[str, Any]
) -> list[str]:
    required = [
        "AGENTS.md",
        "README.md",
        "qa/QA_AGENT.md",
        "qa/RUBRIC.md",
        "scripts/qa_repository.py",
    ]
    harnesses = set(manifest.get("harnesses", []))
    if "claude" in harnesses:
        required.extend(["CLAUDE.md", ".claude/agents/qa.md", ".claude/commands/qa.md"])
    if "codex" in harnesses:
        required.extend([".agents/agents/qa.md"])
    return [
        f"required: missing {name}"
        for name in required
        if not (repository_root / name).is_file()
    ]


def _should_validate_text_path(repository_root: Path, path: Path) -> bool:
    relative_path = path.relative_to(repository_root)
    if relative_path in SKIPPED_TEXT_FILES:
        return False
    return not any(part in SKIPPED_TEXT_PARTS for part in relative_path.parts)


def _validate_text_files(repository_root: Path) -> list[str]:
    failures: list[str] = []
    for path in sorted(
        item
        for item in repository_root.rglob("*")
        if item.is_file()
        and item.suffix in TEXT_SUFFIXES
        and _should_validate_text_path(repository_root, item)
    ):
        text = path.read_text(encoding="utf-8")
        is_template = path.relative_to(repository_root).parts[0] in TEMPLATE_DIRS
        if not is_template and JINJA_MARKER.search(text):
            failures.append(
                f"template: unresolved marker in {path.relative_to(repository_root)}"
            )
        if str(Path.home()) in text:
            failures.append(
                f"path: author-machine home path in {path.relative_to(repository_root)}"
            )
    return failures


def _validate_workflow(repository_root: Path) -> list[str]:
    workflow_path = repository_root / ".depot/workflows/qa.yml"
    if not workflow_path.exists():
        return []
    workflow = workflow_path.read_text(encoding="utf-8")
    failures: list[str] = []
    if "qa_repository.py" not in workflow:
        failures.append("workflow: deterministic QA command missing")
    if "secrets." in workflow or "api_key" in workflow.lower():
        failures.append("workflow: QA must not require secrets")
    return failures


def main(argv: list[str] | None = None) -> int:
    """Run repository QA and print a concise agent-friendly result."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("repository", nargs="?", type=Path, default=Path.cwd())
    arguments = parser.parse_args(argv or sys.argv[1:])
    failures = validate_repository(arguments.repository.resolve())
    if failures:
        print("Agent repository QA: FAIL", file=sys.stderr)
        for failure in failures:
            print(f"- {failure}", file=sys.stderr)
        return 1
    print("Agent repository QA: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
