#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["jinja2>=3.1,<4"]
# ///
"""Regenerate the two project QA files and their scaffold hashes."""

from __future__ import annotations

import hashlib
import json
import tomllib
from pathlib import Path

from jinja2 import Environment, FileSystemLoader, StrictUndefined


SCAFFOLD_ROOT = Path(__file__).resolve().parent
REPOSITORY_ROOT = SCAFFOLD_ROOT.parent
MANAGED_PATHS = (
    ".depot/workflows/qa.yml",
    "scripts/qa_repository.py",
)


def main() -> None:
    with (SCAFFOLD_ROOT / "dotfiles.toml").open("rb") as config_file:
        repository = tomllib.load(config_file)["repository"]
    manifest_path = REPOSITORY_ROOT / ".agent-scaffold.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    hashes = manifest["files"]

    for relative_path, expected_hash in hashes.items():
        if relative_path in MANAGED_PATHS:
            continue
        actual_hash = hashlib.sha256(
            (REPOSITORY_ROOT / relative_path).read_bytes()
        ).hexdigest()
        if actual_hash != expected_hash:
            raise RuntimeError(f"Managed file changed: {relative_path}")

    environment = Environment(
        loader=FileSystemLoader(SCAFFOLD_ROOT / "templates"),
        undefined=StrictUndefined,
        autoescape=False,
        keep_trailing_newline=True,
    )
    for relative_path in MANAGED_PATHS:
        if relative_path not in hashes:
            raise RuntimeError(f"Not in scaffold manifest: {relative_path}")
        rendered = environment.get_template(f"{relative_path}.j2").render(
            repository=repository
        )
        content = rendered.encode("utf-8")
        (REPOSITORY_ROOT / relative_path).write_bytes(content)
        hashes[relative_path] = hashlib.sha256(content).hexdigest()

    manifest_path.write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


if __name__ == "__main__":
    main()
