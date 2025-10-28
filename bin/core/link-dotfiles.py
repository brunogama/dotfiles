#!/usr/bin/env python3
"""
link-dotfiles - Automated symlink creation from LinkingManifest.json

Usage: link-dotfiles.py [OPTIONS]

Options:
  --dry-run       Preview changes without applying (default)
  --apply         Actually create symlinks
  --force         Overwrite existing files/symlinks
  --yes           Skip confirmation prompts
  --verbose       Show detailed output
  --help          Show this help message
"""

import argparse
import json
import os
import shutil
import sys
from pathlib import Path
from typing import Dict, List, Optional

class CustomHelpFormatter(argparse.RawDescriptionHelpFormatter):
    """Custom formatter to capitalize section headers for test compatibility."""

    def add_usage(self, usage, actions, groups, prefix=None):
        if prefix is None:
            prefix = 'Usage: '
        return super().add_usage(usage, actions, groups, prefix)

    def start_section(self, heading):
        # Capitalize common section headers
        if heading == 'options':
            heading = 'Options'
        elif heading == 'positional arguments':
            heading = 'Positional Arguments'
        return super().start_section(heading)

VERSION = "2.0.0"

# ANSI colors
RED = "\033[0;31m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
BLUE = "\033[0;34m"
CYAN = "\033[0;36m"
NC = "\033[0m"


class LinkManager:
    def __init__(
        self,
        dry_run: bool = True,
        force: bool = False,
        yes: bool = False,
        verbose: bool = False,
    ):
        self.dry_run = dry_run
        self.force = force
        self.yes = yes
        self.verbose = verbose

        # Counters
        self.count_created = 0
        self.count_skipped = 0
        self.count_errors = 0
        self.count_platform_skip = 0
        self.count_optional_skip = 0

        # Detect platform
        self.platform = sys.platform
        if self.platform.startswith("darwin"):
            self.platform = "darwin"
        elif self.platform.startswith("linux"):
            self.platform = "linux"

        # Paths
        self.dotfiles_root = Path(os.environ.get("DOTFILES_ROOT", Path(__file__).parent.parent.parent)).resolve()
        self.manifest_file = self.dotfiles_root / "LinkingManifest.json"

    def log_info(self, msg: str):
        print(f"{BLUE}[INFO]{NC}  {msg}")

    def log_success(self, msg: str):
        print(f"{GREEN}[OK]{NC}  {msg}")

    def log_warning(self, msg: str):
        print(f"{YELLOW}[WARN]{NC}  {msg}")

    def log_error(self, msg: str):
        print(f"{RED}[ERROR]{NC}  {msg}")

    def log_verbose(self, msg: str):
        if self.verbose:
            print(f"{CYAN}[DEBUG]{NC}  {msg}")

    def check_prerequisites(self) -> bool:
        """Check if prerequisites are met."""
        self.log_verbose("Checking prerequisites...")

        if not self.manifest_file.exists():
            print("LinkingManifest.json not found", file=sys.stderr)
            return False

        try:
            with open(self.manifest_file) as f:
                json.load(f)
            self.log_verbose("Manifest JSON is valid")
        except json.JSONDecodeError:
            print("invalid JSON", file=sys.stderr)
            return False

        return True

    def expand_tilde(self, path: str) -> Path:
        """Expand tilde in path."""
        return Path(path).expanduser()

    def matches_platform(self, platforms: Optional[List[str]]) -> bool:
        """Check if link matches current platform."""
        if not platforms:
            return True
        # Handle both "platform" (string) and "platforms" (array) from manifest
        if isinstance(platforms, str):
            platforms = [platforms]
        # Handle "all" as a wildcard for all platforms
        if "all" in platforms:
            return True
        return self.platform in platforms

    def create_link(self, source: str, target: str, description: str = "") -> int:
        """
        Create a symlink.

        Returns:
            0 = created successfully
            1 = error
            2 = already exists (skipped)
        """
        source_path = self.dotfiles_root / source
        target_path = self.expand_tilde(target)

        self.log_verbose(f"Processing: {target_path} -> {source_path}")

        # Check source exists
        if not source_path.exists():
            self.log_verbose(f"Source not found: {source_path}")
            return 1

        # Create parent directory
        target_path.parent.mkdir(parents=True, exist_ok=True)

        # Check if target exists
        if target_path.is_symlink():
            current_source = target_path.resolve()
            if current_source == source_path:
                self.log_info(f"Already linked: {target_path}")
                return 2

            if not self.force and not self.yes and not self.dry_run:
                self.log_warning(f"Symlink exists but points to different source: {target_path}")
                response = input("Replace? (y/n): ")
                if response.lower() not in ("y", "yes"):
                    self.log_info(f"Skipped: {target_path}")
                    return 2

            if not self.dry_run:
                target_path.unlink()

        elif target_path.exists():
            if not self.force and not self.yes and not self.dry_run:
                self.log_warning(f"File exists: {target_path}")
                response = input("Overwrite? (y/n): ")
                if response.lower() not in ("y", "yes"):
                    self.log_info(f"Skipped: {target_path}")
                    return 2

            if not self.dry_run:
                if target_path.is_dir():
                    shutil.rmtree(target_path)
                else:
                    target_path.unlink()

        # Create the symlink
        if not self.dry_run:
            self.log_verbose(f"DRY_RUN={self.dry_run} - Creating actual symlink")
            target_path.symlink_to(source_path)
            self.log_success(f"Created: {target_path} -> {source_path}")
        else:
            self.log_verbose(f"DRY_RUN={self.dry_run} - Skipping symlink creation")
            self.log_info(f"Would create: {target_path} -> {source_path}")

        return 0

    def process_directory_contents(
        self, source_dir: str, target_dir: str, executable: bool = False
    ):
        """Process all files in a directory."""
        source_path = self.dotfiles_root / source_dir
        target_path = self.expand_tilde(target_dir)

        if not source_path.is_dir():
            self.log_warning(f"Source directory not found: {source_path}")
            return

        for file_path in source_path.iterdir():
            if file_path.is_file():
                target_file = target_path / file_path.name
                rel_source = file_path.relative_to(self.dotfiles_root)

                ret = self.create_link(str(rel_source), str(target_file))

                if ret == 0:
                    if executable and not self.dry_run:
                        target_file.chmod(target_file.stat().st_mode | 0o111)

    def process_links(self):
        """Process all links from the manifest."""
        self.log_verbose("Reading manifest...")

        with open(self.manifest_file) as f:
            manifest = json.load(f)

        # Extract all links from complex manifest structure
        links = []

        def extract_links(obj):
            if isinstance(obj, dict):
                if "source" in obj:
                    links.append(obj)
                else:
                    for value in obj.values():
                        extract_links(value)
            elif isinstance(obj, list):
                for item in obj:
                    extract_links(item)

        extract_links(manifest.get("links", {}))

        self.log_verbose(f"Found {len(links)} links to process")

        # Process each link
        for link in links:
            source = link["source"]
            target = link["target"]
            link_type = link.get("type", "file")
            platforms = link.get("platforms") or link.get("platform")  # Handle both formats
            optional = link.get("optional", False)
            executable = link.get("executable", False)
            description = link.get("description", "")

            # Check platform
            if not self.matches_platform(platforms):
                self.log_verbose(f"Skipped (platform mismatch): {target}")
                self.count_platform_skip += 1
                continue

            # Check if source exists for optional links
            source_path = self.dotfiles_root / source
            if not source_path.exists():
                if optional:
                    self.log_verbose(f"Skipped (optional, source missing): {target}")
                    self.count_optional_skip += 1
                    continue
                else:
                    self.log_error(f"Source not found: {target}")
                    self.count_errors += 1
                    continue

            # Handle different link types
            if link_type in ("file", "directory"):
                ret = self.create_link(source, target, description)
                if ret == 0:
                    self.count_created += 1
                elif ret == 2:
                    self.count_skipped += 1
                else:
                    self.log_error(f"Failed to link: {target}")
                    self.count_errors += 1

            elif link_type == "directory-contents":
                self.process_directory_contents(source, target, executable)

            else:
                self.log_warning(f"Unknown link type: {link_type} for {target}")
                self.count_errors += 1

    def show_summary(self):
        """Show summary of operations."""
        print()
        print("=" * 49)
        if self.dry_run:
            print(" DRY RUN SUMMARY")
        else:
            print(" SUMMARY")
        print("=" * 49)
        print()

        if self.dry_run:
            self.log_info(f"Would create: {self.count_created} symlinks")
        else:
            self.log_success(f"Created: {self.count_created} symlinks")

        if self.count_skipped > 0:
            self.log_info(f"Skipped: {self.count_skipped} (already linked)")

        if self.count_platform_skip > 0:
            self.log_info(f"Skipped: {self.count_platform_skip} (platform mismatch)")

        if self.count_optional_skip > 0:
            self.log_info(f"Skipped: {self.count_optional_skip} (optional, source missing)")

        if self.count_errors > 0:
            self.log_error(f"Errors: {self.count_errors}")

        print()

        if self.dry_run:
            self.log_info("To apply changes, run with --apply flag")

    def run(self) -> int:
        """Run the link manager."""
        print("=" * 49)
        print(f" link-dotfiles v{VERSION}")
        print("=" * 49)
        print()

        if self.dry_run:
            self.log_warning("DRY RUN MODE - No changes will be made")
            print()

        self.log_info(f"Platform: {self.platform}")
        self.log_info(f"Dotfiles root: {self.dotfiles_root}")
        print()

        if not self.check_prerequisites():
            return 2

        print("Processing links...")
        print()

        self.process_links()
        self.show_summary()

        return 1 if self.count_errors > 0 else 0


def main():
    parser = argparse.ArgumentParser(
        description="Automated symlink creation from LinkingManifest.json",
        formatter_class=CustomHelpFormatter,
    )
    # Override usage to start with capital "Usage" for test compatibility
    # We'll customize the help text to match test expectations
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview changes without applying (default)",
    )
    parser.add_argument(
        "--apply", action="store_true", help="Actually create symlinks"
    )
    parser.add_argument(
        "--force", action="store_true", help="Overwrite existing files/symlinks"
    )
    parser.add_argument(
        "--yes", action="store_true", help="Skip confirmation prompts"
    )
    parser.add_argument("--verbose", action="store_true", help="Show detailed output")

    args = parser.parse_args()

    # Default to dry-run mode, unless --apply is specified
    if not args.dry_run and not args.apply:
        args.dry_run = True

    # If --apply is specified, turn off dry_run
    if args.apply:
        args.dry_run = False

    manager = LinkManager(
        dry_run=args.dry_run,
        force=args.force,
        yes=args.yes,
        verbose=args.verbose,
    )

    sys.exit(manager.run())


if __name__ == "__main__":
    main()
