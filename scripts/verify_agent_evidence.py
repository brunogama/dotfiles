#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Verify committed agent evidence for a change.

Checks that a repository carries a committed evidence manifest, that each entry
attests the fields CI needs, that the declared changed files cover the actual
diff of a git range, and (optionally) that commits are attributed to a given
identity.

Exit status: 0 when all checks pass, 1 otherwise.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path
from typing import Any

REQUIRED_FIELDS = ("agent", "run_id", "exit_code", "files_changed")


def load_manifest(path: Path) -> dict[str, Any] | None:
    """Load a manifest object, returning None when it is absent."""
    if not path.is_file():
        return None
    try:
        with path.open(encoding="utf-8") as handle:
            data = json.load(handle)
    except (json.JSONDecodeError, OSError) as exc:
        raise ValueError(f"cannot read manifest {path}: {exc}") from exc
    if not isinstance(data, dict):
        raise ValueError("manifest must be a JSON object with identity and entries")
    return data


def validate_manifest(path: Path) -> list[str]:
    """Return failure messages (empty when the manifest is valid)."""
    try:
        data = load_manifest(path)
    except (json.JSONDecodeError, ValueError, OSError) as exc:
        return [f"manifest {path}: {exc}"]
    if data is None:
        return [f"manifest {path}: missing"]

    failures: list[str] = []
    identity = data.get("identity")
    if (
        not isinstance(identity, dict)
        or not identity.get("name")
        or not identity.get("email")
    ):
        failures.append("manifest: missing identity name/email")
    entries = data.get("entries")
    if not isinstance(entries, list) or not entries:
        failures.append("manifest: entries must be a non-empty array")
        return failures

    for index, entry in enumerate(entries):
        if not isinstance(entry, dict):
            failures.append(f"manifest.entries[{index}]: not an object")
            continue
        for field in REQUIRED_FIELDS:
            if field not in entry:
                failures.append(f"manifest.entries[{index}]: missing field {field!r}")
        if not isinstance(entry.get("files_changed"), list):
            failures.append(f"manifest.entries[{index}]: files_changed must be a list")
    return failures


def changed_files_in_range(range_spec: str, cwd: Path | None = None) -> set[str]:
    output = subprocess.check_output(
        ["git", "diff", "--name-only", range_spec],
        text=True,
        cwd=cwd,
    )
    return {line for line in output.splitlines() if line}


def validate_files_changed(
    path: Path, range_spec: str, cwd: Path | None = None
) -> list[str]:
    """Fail when the diff declares files the manifest does not attest."""
    try:
        data = load_manifest(path)
    except (json.JSONDecodeError, ValueError, OSError) as exc:
        return [f"manifest {path}: {exc}"]
    if data is None:
        return []
    entries = data.get("entries", [])
    declared = {
        file_name
        for entry in entries
        if isinstance(entry, dict)
        for file_name in entry.get("files_changed", [])
    }
    try:
        actual = changed_files_in_range(range_spec, cwd=cwd)
    except (subprocess.CalledProcessError, OSError) as exc:
        return [f"git diff {range_spec}: {exc}"]
    missing = sorted(actual - declared)
    if missing:
        return [f"files_changed: undeclared {missing}"]
    return []


def commits_in_range(range_spec: str, cwd: Path | None = None) -> list[dict[str, str]]:
    output = subprocess.check_output(
        ["git", "log", "--format=%H%x00%an%x00%ae", range_spec],
        text=True,
        cwd=cwd,
    )
    commits: list[dict[str, str]] = []
    for line in output.splitlines():
        if not line:
            continue
        sha, name, email = line.split("\x00")
        commits.append({"sha": sha, "name": name, "email": email})
    return commits


def validate_attribution(
    range_spec: str, name: str, email: str, cwd: Path | None = None
) -> list[str]:
    """Return attribution failures for commits in a git range."""
    try:
        commits = commits_in_range(range_spec, cwd=cwd)
    except (subprocess.CalledProcessError, OSError) as exc:
        return [f"git log {range_spec}: {exc}"]
    if not commits:
        return [f"git log {range_spec}: no commits found"]

    failures: list[str] = []
    for commit in commits:
        if commit["name"] != name or commit["email"] != email:
            failures.append(
                f"{commit['sha'][:12]}: attributed to {commit['name']!r} "
                f"<{commit['email']}>; expected {name!r} <{email}>"
            )
    return failures


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", default=".agents/evidence.json")
    parser.add_argument("--name", help="expected agent author name")
    parser.add_argument("--email", help="expected agent author email")
    parser.add_argument("--range", help="git range (e.g. BASE..HEAD)")
    args = parser.parse_args()

    failures: list[str] = validate_manifest(Path(args.manifest))
    if args.range:
        failures += validate_files_changed(Path(args.manifest), args.range)
        if args.name and args.email:
            failures += validate_attribution(args.range, args.name, args.email)

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}", file=sys.stderr)
        return 1
    print("PASS: agent evidence verified")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
