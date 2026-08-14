#!/usr/bin/env python3
"""
link-dotfiles - Convention-based symlink creation

Usage: link-dotfiles.py [OPTIONS]

Options:
  --dry-run       Preview changes without applying (default)
  --apply         Actually create symlinks
  --force         Overwrite existing files/symlinks
  --yes           Skip confirmation prompts
  --verbose       Show detailed output
  --commands-only Link only public commands to ~/.local/bin
  --folder-actions Install Darwin Folder Actions scripts
  --help          Show this help message
"""

import argparse
import hashlib
import json
import os
import shutil
import socket
import stat
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

VERSION = "3.0.0"

# ANSI colors
RED = "\033[0;31m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
BLUE = "\033[0;34m"
CYAN = "\033[0;36m"
NC = "\033[0m"


def find_project_root(start_path: Optional[Path] = None) -> Optional[Path]:
    """
    Find the project root from the convention-linker layout.

    A checkout contains the linker and either a managed home tree or repository marker.
    
    Args:
        start_path: Path to start searching from (default: current working directory)
        
    Returns:
        Path to project root if found, None otherwise
    """
    if start_path is None:
        start_path = Path.cwd()
    else:
        start_path = Path(start_path).resolve()
    
    for current in (start_path, *start_path.parents):
        linker = current / "bin/core/link-dotfiles.py"
        if linker.is_file() and ((current / "home").is_dir() or (current / ".git").exists()):
            return current
    return None


class LinkManager:
    def __init__(
        self,
        dry_run: bool = True,
        force: bool = False,
        yes: bool = False,
        verbose: bool = False,
        prune: bool = False,
        migrate_legacy_bin: bool = False,
        commands_only: bool = False,
        folder_actions: bool = False,
    ):
        self.dry_run = dry_run
        self.force = force
        self.yes = yes
        self.verbose = verbose
        self.prune_mode = prune
        self.migrate_legacy_bin = migrate_legacy_bin
        self.commands_only = commands_only
        self.folder_actions = folder_actions

        # Counters
        self.count_created = 0
        self.count_skipped = 0
        self.count_errors = 0
        self.count_platform_skip = 0
        self.count_optional_skip = 0
        self.applied_links: List[Tuple[Path, Path]] = []

        # Detect platform
        self.platform = sys.platform
        if self.platform.startswith("darwin"):
            self.platform = "darwin"
        elif self.platform.startswith("linux"):
            self.platform = "linux"

        # Find project root
        # Priority: 1. DOTFILES_ROOT env var, 2. Auto-detect from current location
        env_root = os.environ.get("DOTFILES_ROOT")
        if env_root:
            self.dotfiles_root = Path(env_root).resolve()
        else:
            # Try to find project root automatically
            project_root = find_project_root()
            if project_root:
                self.dotfiles_root = project_root
            else:
                # Fallback to old behavior (3 levels up from script)
                self.dotfiles_root = Path(__file__).parent.parent.parent.resolve()
        
        self.hostname = os.environ.get("DOTFILES_HOSTNAME", socket.gethostname())

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

        return True

    def expand_tilde(self, path: str) -> Path:
        """Expand tilde in path."""
        return Path(path).expanduser()

    def matches_platform(self, platforms: Optional[List[str]]) -> bool:
        """Check if link matches current platform."""
        if not platforms:
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
        source_path = Path(source)
        if not source_path.is_absolute():
            source_path = self.dotfiles_root / source_path
        target_path = self.expand_tilde(target)

        self.log_verbose(f"Processing: {target_path} -> {source_path}")

        # Check source exists
        if not source_path.exists():
            self.log_verbose(f"Source not found: {source_path}")
            return 1

        # Check if target exists
        if target_path.is_symlink():
            current_source = target_path.resolve()
            if current_source == source_path:
                self.log_verbose(f"Already linked correctly: {target_path}")
                return 2

            if not self.force:
                self.log_error(f"Collision at {target_path}; rerun with --force --yes to replace it")
                return 1
            if not self.yes:
                self.log_error("--force requires --yes for non-interactive replacement")
                return 1
            if not self.dry_run:
                target_path.unlink()

        elif target_path.exists():
            if not self.force:
                self.log_error(f"Collision at {target_path}; rerun with --force --yes to replace it")
                return 1
            if not self.yes:
                self.log_error("--force requires --yes for non-interactive replacement")
                return 1
            if not self.dry_run:
                if target_path.is_dir():
                    shutil.rmtree(target_path)
                else:
                    target_path.unlink()

        # Create the symlink
        if not self.dry_run:
            target_path.parent.mkdir(parents=True, exist_ok=True)
            target_path.symlink_to(source_path)
            self.log_success(f"Created: {target_path} -> {source_path}")
        else:
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

    def repository_id(self) -> str:
        """Use the Git origin as a relocation-stable repository identity."""
        try:
            origin = subprocess.check_output(
                ["git", "-C", str(self.dotfiles_root), "config", "--get", "remote.origin.url"],
                text=True,
                stderr=subprocess.DEVNULL,
            ).strip()
        except (OSError, subprocess.CalledProcessError):
            origin = ""
        return hashlib.sha256((origin or str(self.dotfiles_root)).encode()).hexdigest()

    def write_state(self, preserve_existing: bool = False) -> None:
        """Atomically persist confirmed links, preserving prior ownership when requested."""
        state_file = Path.home() / ".local/state/dotfiles/links.json"
        links = {
            str(target): {"source": str(source), "target": str(target)}
            for source, target in self.applied_links
        }
        if preserve_existing:
            try:
                previous = json.loads(state_file.read_text())
                if previous.get("repository_id") == self.repository_id():
                    for link in previous.get("links", []):
                        target = link.get("target")
                        if isinstance(target, str) and target not in links:
                            links[target] = link
            except (FileNotFoundError, json.JSONDecodeError, AttributeError):
                pass
        payload = {
            "version": 1,
            "repository_id": self.repository_id(),
            "links": list(links.values()),
        }
        state_file.parent.mkdir(parents=True, exist_ok=True)
        temporary = state_file.with_suffix(".tmp")
        temporary.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        temporary.replace(state_file)

    def desired_targets(self) -> Dict[Path, Path]:
        """Return the current home-tree targets without consulting legacy metadata."""
        targets: Dict[Path, Path] = {}
        home = Path.home()
        for tree_name in ("home", f"home-{self.platform}", f"home-host-{self.hostname}"):
            tree = self.dotfiles_root / tree_name
            if tree.is_dir():
                for source in tree.rglob("*"):
                    if stat.S_ISREG(source.lstat().st_mode):
                        targets[home / source.relative_to(tree)] = source
        return targets

    def prune(self) -> None:
        """Remove only stale symlinks whose ownership the ledger proves."""
        state_file = Path.home() / ".local/state/dotfiles/links.json"
        try:
            state = json.loads(state_file.read_text())
            if state.get("version") != 1 or not isinstance(state.get("repository_id"), str):
                raise ValueError("unsupported ownership state")
            links = state["links"]
        except (FileNotFoundError, ValueError, json.JSONDecodeError, KeyError, TypeError):
            self.log_error(f"Invalid or missing ownership ledger: {state_file}")
            self.count_errors += 1
            return

        desired = self.desired_targets()
        for recorded in links:
            try:
                target = Path(recorded["target"])
                source = Path(recorded["source"])
            except (KeyError, TypeError):
                self.log_error("Invalid ownership ledger entry")
                self.count_errors += 1
                return
            current_source = target.resolve() if target.is_symlink() else None
            desired_source = desired.get(target)
            stale = desired_source is None or current_source != desired_source.resolve()
            if not stale:
                continue
            if not target.is_symlink() or current_source != source.resolve():
                self.log_warning(f"Refusing unproven stale target: {target}")
                self.count_skipped += 1
                continue
            if self.dry_run:
                self.log_info(f"Would prune: {target}")
            else:
                target.unlink()
                self.log_success(f"Pruned: {target}")
            self.count_created += 1

    def public_commands(self) -> Dict[str, Path]:
        """Discover unique executable commands exposed from immediate domain entries."""
        commands: Dict[str, Path] = {}
        bin_root = self.dotfiles_root / "bin"
        if not bin_root.is_dir():
            return commands
        for domain in sorted(bin_root.iterdir()):
            if not domain.is_dir():
                continue
            for source in sorted(domain.iterdir()):
                if not stat.S_ISREG(source.lstat().st_mode) or not os.access(source, os.X_OK):
                    continue
                if source.name in commands:
                    raise ValueError(f"Duplicate command name: {source.name}")
                commands[source.name] = source
        return commands

    def migrate_legacy_commands(self) -> None:
        """Move only legacy symlinks proven to point at current public commands."""
        legacy_bin = Path.home() / "local/bin"
        try:
            commands = self.public_commands()
        except ValueError as error:
            self.log_error(str(error))
            self.count_errors += 1
            return
        if not legacy_bin.is_dir():
            self.log_info(f"No legacy command directory: {legacy_bin}")
            return

        migrations: List[Tuple[Path, Path, Path]] = []
        for legacy in sorted(legacy_bin.iterdir()):
            source = commands.get(legacy.name)
            if source is None:
                self.log_info(f"Preserving unmanaged legacy entry: {legacy}")
                self.count_skipped += 1
                continue
            if not legacy.is_symlink() or legacy.resolve() != source.resolve():
                self.log_info(f"Preserving unproven legacy entry: {legacy}")
                self.count_skipped += 1
                continue
            migrations.append((legacy, Path.home() / ".local/bin" / legacy.name, source))

        for legacy, target, source in migrations:
            if target.exists() or target.is_symlink():
                correct = target.is_symlink() and target.resolve() == source.resolve()
                if not correct:
                    self.log_error(f"Collision at {target}; migration left {legacy} unchanged")
                    self.count_errors += 1
                    return

        for legacy, target, source in migrations:
            if self.dry_run:
                self.log_info(f"Would migrate: {legacy} -> {target}")
                continue
            target.parent.mkdir(parents=True, exist_ok=True)
            if not target.exists() and not target.is_symlink():
                target.symlink_to(source)
            legacy.unlink()
            self.log_success(f"Migrated: {legacy} -> {target}")
            self.count_created += 1

    def install_folder_actions(self) -> None:
        """Install the Darwin Folder Actions scripts under the user's Library."""
        if self.platform != "darwin":
            self.log_info("Skipping Folder Actions (not on macOS)")
            return
        source = self.dotfiles_root / "bin/folder-action-scripts/compress-video-automation.scpt"
        target = Path.home() / "Library/Scripts/Folder Action Scripts/compress-video-automation.scpt"
        if not source.is_file():
            self.log_error(f"Folder Actions source not found: {source}")
            self.count_errors += 1
            return
        ret = self.create_link(str(source), str(target))
        if ret == 0:
            self.count_created += 1
            self.applied_links.append((source, target))
        elif ret == 2:
            self.count_skipped += 1
            self.applied_links.append((source, target))
        else:
            self.count_errors += 1
            return
        if not self.dry_run:
            self.write_state(preserve_existing=True)

    def process_links(self):
        """Discover and apply the convention-based link plan."""
        plan: Dict[Path, Tuple[Path, str]] = {}
        home = Path.home()
        if not self.commands_only:
            tree_names = ("home", f"home-{self.platform}", f"home-host-{self.hostname}")
            for tree_name in tree_names:
                tree = self.dotfiles_root / tree_name
                if not tree.is_dir():
                    continue
                for source in sorted(tree.rglob("*")):
                    if stat.S_ISREG(source.lstat().st_mode):
                        plan[home / source.relative_to(tree)] = (source, tree_name)

        try:
            commands = self.public_commands()
        except ValueError as error:
            self.log_error(str(error))
            self.count_errors += 1
            return
        for name, source in commands.items():
            target = home / ".local/bin" / name
            if target in plan:
                self.log_error(f"Target collision: {target}")
                self.count_errors += 1
                return
            plan[target] = (source, f"bin/{source.parent.name}")

        # Validate the entire plan before creating directories or links.
        for target, (source, _) in plan.items():
            correct = target.is_symlink() and target.resolve() == source.resolve()
            if (target.exists() or target.is_symlink()) and not correct and not self.force:
                self.log_error(f"Collision at {target}; rerun with --force --yes to replace it")
                self.count_errors += 1
                return
            if (target.exists() or target.is_symlink()) and not correct and not self.yes:
                self.log_error("--force requires --yes for non-interactive replacement")
                self.count_errors += 1
                return
            parent = target.parent
            while parent != home.parent:
                if parent.exists() and not parent.is_dir():
                    self.log_error(f"Parent path is not a directory: {parent}")
                    self.count_errors += 1
                    return
                parent = parent.parent

        for target, (source, provenance) in sorted(plan.items()):
            self.log_verbose(f"Processing: {target} -> {source} ({provenance})")
            ret = self.create_link(str(source), str(target))
            if ret == 0:
                self.count_created += 1
                self.applied_links.append((source, target))
            elif ret == 2:
                self.count_skipped += 1
                self.applied_links.append((source, target))
            else:
                self.count_errors += 1
                if not self.dry_run:
                    self.write_state()
                return

        if not self.dry_run:
            self.write_state(preserve_existing=self.commands_only)

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

        if self.prune_mode:
            self.prune()
        elif self.migrate_legacy_bin:
            self.migrate_legacy_commands()
        elif self.folder_actions:
            self.install_folder_actions()
        else:
            self.process_links()
        self.show_summary()

        return 1 if self.count_errors > 0 else 0


def main():
    parser = argparse.ArgumentParser(
        description="Convention-based dotfile symlink creation",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        default=True,
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
    parser.add_argument("--prune", action="store_true", help="Remove stale links proven by ownership state")
    parser.add_argument("--migrate-legacy-bin", action="store_true", help="Migrate proven legacy ~/local/bin command links")
    parser.add_argument("--commands-only", action="store_true", help="Link only public commands to ~/.local/bin")
    parser.add_argument("--folder-actions", action="store_true", help="Install Darwin Folder Actions scripts")

    args = parser.parse_args()

    # If --apply is specified, turn off dry_run
    if args.apply:
        args.dry_run = False

    manager = LinkManager(
        dry_run=args.dry_run,
        force=args.force,
        yes=args.yes,
        verbose=args.verbose,
        prune=args.prune,
        migrate_legacy_bin=args.migrate_legacy_bin,
        commands_only=args.commands_only,
        folder_actions=args.folder_actions,
    )

    sys.exit(manager.run())


if __name__ == "__main__":
    main()
