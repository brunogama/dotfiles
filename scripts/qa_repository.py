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
import tomllib
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
SKILL_NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
TEXT_SUFFIXES = {".json", ".md", ".py", ".toml", ".txt", ".yml", ".yaml"}


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
    failures.extend(_validate_skill_frontmatter(repository_root))
    failures.extend(_validate_skill_lifecycle(repository_root))
    failures.extend(_validate_text_files(repository_root))
    failures.extend(_validate_external_sources(repository_root))
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
        "skill-sources.json",
    ]
    harnesses = set(manifest.get("harnesses", []))
    if "claude" in harnesses:
        required.extend(["CLAUDE.md", ".claude/agents/qa.md", ".claude/commands/qa.md"])
    if "pi" in harnesses:
        required.extend(
            [
                ".pi/settings.json",
                ".pi/prompts/qa.md",
                ".pi/_candidates/skill-forge/SKILL.md",
            ]
        )
    if "codex" in harnesses:
        required.extend(
            [
                ".agents/agents/qa.md",
                ".agents/_candidates/skill-forge/SKILL.md",
            ]
        )
    return [
        f"required: missing {name}"
        for name in required
        if not (repository_root / name).is_file()
    ]


def _validate_skill_frontmatter(repository_root: Path) -> list[str]:
    failures: list[str] = []
    skill_roots = [
        repository_root / ".claude/skills",
        repository_root / ".pi/skills",
        repository_root / ".agents/skills",
        repository_root / ".claude/_candidates",
        repository_root / ".pi/_candidates",
        repository_root / ".agents/_candidates",
    ]
    for skill_path in sorted(
        path
        for root in skill_roots
        if root.is_dir()
        for path in root.rglob("SKILL.md")
    ):
        text = skill_path.read_text(encoding="utf-8")
        if not text.startswith("---\n"):
            failures.append(
                f"skill: missing frontmatter {skill_path.relative_to(repository_root)}"
            )
            continue
        frontmatter = text.split("---\n", 2)[1]
        name_match = re.search(r"^name:\s*([^\n]+)$", frontmatter, re.MULTILINE)
        description_match = re.search(
            r"^description:\s*([^\n]+)$", frontmatter, re.MULTILINE
        )
        if not name_match or not SKILL_NAME.fullmatch(name_match.group(1).strip()):
            failures.append(
                f"skill: invalid name {skill_path.relative_to(repository_root)}"
            )
        if not description_match or not description_match.group(1).strip():
            failures.append(
                f"skill: missing description {skill_path.relative_to(repository_root)}"
            )
    return failures


def _validate_skill_lifecycle(repository_root: Path) -> list[str]:
    """Reject active skills when repository policy requires candidate staging."""
    configuration_path = repository_root / ".agent-scaffold/dotfiles.toml"
    if not configuration_path.is_file():
        return []
    try:
        configuration = tomllib.loads(configuration_path.read_text(encoding="utf-8"))
    except (OSError, tomllib.TOMLDecodeError) as error:
        return [f"lifecycle: invalid scaffold configuration: {error}"]
    repository = configuration.get("repository", {})
    if not isinstance(repository, dict) or not repository.get(
        "require_candidate_staging", False
    ):
        return []

    approved_active_skills = repository.get("approved_active_skills", [])
    if not isinstance(approved_active_skills, list) or not all(
        isinstance(skill_name, str) and SKILL_NAME.fullmatch(skill_name)
        for skill_name in approved_active_skills
    ):
        return ["lifecycle: approved_active_skills must contain valid skill names"]

    approved_names = set(approved_active_skills)
    skill_roots = [
        repository_root / ".claude/skills",
        repository_root / ".pi/skills",
        repository_root / ".agents/skills",
    ]
    active_skills = [
        skill_path
        for root in skill_roots
        if root.is_dir()
        for skill_path in sorted(root.glob("*/SKILL.md"))
    ]
    failures: list[str] = []
    for skill_path in active_skills:
        relative_path = skill_path.relative_to(repository_root)
        text = skill_path.read_text(encoding="utf-8")
        name_match = re.search(r"^name:\s*([^\n]+)$", text, re.MULTILINE)
        declared_name = name_match.group(1).strip() if name_match else None
        if declared_name != skill_path.parent.name:
            failures.append(
                f"lifecycle: active skill {relative_path} name must match its directory"
            )
            continue
        if declared_name not in approved_names:
            failures.append(f"lifecycle: active skill {relative_path}")
            continue
        if re.search(r"^candidate:\s*true\s*$", text, re.MULTILINE):
            failures.append(
                f"lifecycle: active skill {relative_path} is marked as candidate"
            )
    return failures


def _validate_text_files(repository_root: Path) -> list[str]:
    failures: list[str] = []
    for path in sorted(
        item
        for item in repository_root.rglob("*")
        if item.is_file() and item.suffix in TEXT_SUFFIXES
    ):
        text = path.read_text(encoding="utf-8")
        if JINJA_MARKER.search(text):
            failures.append(
                f"template: unresolved marker in {path.relative_to(repository_root)}"
            )
        if str(Path.home()) in text:
            failures.append(
                f"path: author-machine home path in {path.relative_to(repository_root)}"
            )
    return failures


def _validate_external_sources(repository_root: Path) -> list[str]:
    failures: list[str] = []
    source_path = repository_root / "skill-sources.json"
    try:
        manifest = json.loads(source_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        return [f"external sources: {error}"]
    for source in manifest.get("sources", []):
        argv = source.get("install_argv", [])
        if argv[:3] != ["npx", "skills", "add"]:
            failures.append(
                f"external sources: invalid argv for {source.get('name', '<unnamed>')}"
            )
        if source.get("enabled") and source.get("repository") == "owner/repository":
            failures.append(
                "external sources: placeholder repository cannot be enabled"
            )
    for script_path in (repository_root / "scripts").glob("*.py"):
        if script_path.name == "qa_repository.py":
            continue
        script = script_path.read_text(encoding="utf-8")
        if "subprocess" in script and "skills" in script and "add" in script:
            failures.append(
                f"external sources: automatic installer in {script_path.name}"
            )
    return failures


def _validate_workflow(repository_root: Path) -> list[str]:
    workflow_path = repository_root / ".github/workflows/qa.yml"
    if not workflow_path.exists():
        return []
    workflow = workflow_path.read_text(encoding="utf-8")
    failures: list[str] = []
    if "qa_repository.py" not in workflow:
        failures.append("workflow: deterministic QA command missing")
    if "secrets." in workflow or "api_key" in workflow.lower():
        failures.append("workflow: QA must not require secrets")
    if "_candidates" in workflow and ("mv " in workflow or "move" in workflow):
        failures.append("workflow: candidate promotion automation is forbidden")
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
