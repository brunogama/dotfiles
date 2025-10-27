"""Command-line interface for home-sync using Click.

Provides user-facing commands for syncing dotfiles and credentials,
running as a daemon, and checking status.
"""

from pathlib import Path
from typing import Optional

import click

from home_sync.config import load_config
from home_sync.daemon import run_daemon
from home_sync.dotfiles import DotfilesSync, DotfilesSyncError, SyncConfig
from home_sync.logger import LogLevel, setup_logger

# Version from package
__version__ = "2.0.0"

logger = setup_logger(__name__)


# Main CLI group
@click.group()
@click.version_option(version=__version__, prog_name="home-sync")
@click.option(
    "-v",
    "--verbose",
    count=True,
    help="Increase verbosity (can be repeated: -v, -vv, -vvv)",
)
@click.option(
    "--config",
    type=click.Path(exists=True, dir_okay=False, path_type=Path),
    help="Path to configuration file",
)
@click.pass_context
def cli(ctx: click.Context, verbose: int, config: Optional[Path]) -> None:
    """Home environment and credentials synchronization tool.

    Synchronizes dotfiles and credentials across machines using git.
    Can run as a one-shot sync or as a background daemon.
    """
    # Set up logging level based on verbosity
    if verbose == 0:
        log_level = LogLevel.INFO
    elif verbose == 1:
        log_level = LogLevel.DEBUG
    else:  # 2 or more
        log_level = LogLevel.DEBUG

    # Store in context for subcommands
    ctx.ensure_object(dict)
    ctx.obj["verbose"] = verbose
    ctx.obj["log_level"] = log_level
    ctx.obj["config_path"] = config


@cli.command()
@click.option(
    "--dry-run",
    is_flag=True,
    help="Show what would be done without making changes",
)
@click.option(
    "--force",
    is_flag=True,
    help="Auto-commit uncommitted changes before syncing",
)
@click.option(
    "--skip-pull",
    is_flag=True,
    help="Skip pulling changes from remote",
)
@click.option(
    "--skip-push",
    is_flag=True,
    help="Skip pushing changes to remote",
)
@click.option(
    "--repo",
    type=click.Path(exists=True, file_okay=False, path_type=Path),
    help="Path to dotfiles repository (default: ~/.dotfiles)",
)
@click.pass_context
def sync(
    ctx: click.Context,
    dry_run: bool,
    force: bool,
    skip_pull: bool,
    skip_push: bool,
    repo: Optional[Path],
) -> None:
    """Sync dotfiles repository once.

    Performs a one-shot synchronization:
    1. Auto-commits uncommitted changes (if --force)
    2. Pulls changes from remote (unless --skip-pull)
    3. Pushes changes to remote (unless --skip-push)

    Examples:
        home-sync sync
        home-sync sync --dry-run
        home-sync sync --force
        home-sync sync --skip-pull
    """
    log_level: LogLevel = ctx.obj["log_level"]
    setup_logger("home_sync", level=log_level)

    # Determine repo path
    if repo is None:
        repo = Path.home() / ".dotfiles"

    if not repo.exists():
        click.secho(f"Error: Repository not found: {repo}", fg="red", err=True)
        ctx.exit(1)

    # Create sync config
    config = SyncConfig(
        repo_path=repo,
        dry_run=dry_run,
        force_commit=force,
        skip_pull=skip_pull,
        skip_push=skip_push,
    )

    # Perform sync
    try:
        sync_obj = DotfilesSync(config)
        metrics = sync_obj.sync()

        if dry_run:
            click.secho("Dry-run: Sync would succeed", fg="green")
        else:
            click.secho("Sync completed successfully", fg="green")

        # Show metrics
        if metrics.commits_created > 0:
            click.echo(f"  Commits created: {metrics.commits_created}")
        if metrics.duration_seconds:
            click.echo(f"  Duration: {metrics.duration_seconds:.2f}s")

        ctx.exit(0)

    except DotfilesSyncError as e:
        click.secho(f"Error: {e}", fg="red", err=True)
        ctx.exit(1)

    except KeyboardInterrupt:
        click.echo("\nSync interrupted")
        ctx.exit(130)


@cli.command()
@click.option(
    "--interval",
    type=int,
    default=3600,
    help="Sync interval in seconds (default: 3600 = 1 hour)",
)
@click.option(
    "--force",
    is_flag=True,
    help="Auto-commit uncommitted changes before each sync",
)
@click.option(
    "--repo",
    type=click.Path(exists=True, file_okay=False, path_type=Path),
    help="Path to dotfiles repository (default: ~/.dotfiles)",
)
@click.pass_context
def daemon(
    ctx: click.Context,
    interval: int,
    force: bool,
    repo: Optional[Path],
) -> None:
    """Run as a background daemon.

    Runs continuously, syncing at the specified interval.

    Examples:
        home-sync daemon
        home-sync daemon --interval 1800
        home-sync daemon --force
    """
    log_level: LogLevel = ctx.obj["log_level"]
    setup_logger("home_sync", level=log_level)

    # Determine repo path
    if repo is None:
        repo = Path.home() / ".dotfiles"

    if not repo.exists():
        click.secho(f"Error: Repository not found: {repo}", fg="red", err=True)
        ctx.exit(1)

    click.echo(f"Starting daemon (sync every {interval}s)")
    click.echo(f"Repository: {repo}")
    click.echo("Press Ctrl+C to stop")

    try:
        run_daemon(
            repo_path=repo,
            interval=interval,
            force_commit=force,
        )

    except KeyboardInterrupt:
        click.echo("\nDaemon stopped")
        ctx.exit(0)

    except Exception as e:
        click.secho(f"Error: {e}", fg="red", err=True)
        ctx.exit(1)


@cli.command()
@click.option(
    "--repo",
    type=click.Path(exists=True, file_okay=False, path_type=Path),
    help="Path to dotfiles repository (default: ~/.dotfiles)",
)
@click.pass_context
def status(
    ctx: click.Context,
    repo: Optional[Path],
) -> None:
    """Show repository status.

    Displays current branch, uncommitted changes, and remote status.

    Examples:
        home-sync status
        home-sync status --repo ~/my-dotfiles
    """
    from home_sync.git import (
        check_dirty,
        get_branch_status,
        get_current_branch,
        is_git_repo,
    )

    log_level: LogLevel = ctx.obj["log_level"]
    setup_logger("home_sync", level=log_level)

    # Determine repo path
    if repo is None:
        repo = Path.home() / ".dotfiles"

    if not repo.exists():
        click.secho(f"Error: Repository not found: {repo}", fg="red", err=True)
        ctx.exit(1)

    if not is_git_repo(repo):
        click.secho(f"Error: Not a git repository: {repo}", fg="red", err=True)
        ctx.exit(1)

    # Get status
    try:
        branch = get_current_branch(repo)
        is_dirty = check_dirty(repo)

        click.echo(f"Repository: {repo}")
        click.echo(f"Branch: {branch}")

        if is_dirty:
            click.secho("Status: Uncommitted changes", fg="yellow")
        else:
            click.secho("Status: Clean", fg="green")

        # Try to get branch status
        try:
            branch_status = get_branch_status(repo)
            click.echo(f"Remote: {branch_status.value}")
        except Exception:
            click.echo("Remote: Unknown (no upstream configured)")

        ctx.exit(0)

    except Exception as e:
        click.secho(f"Error: {e}", fg="red", err=True)
        ctx.exit(1)


@cli.command()
@click.pass_context
def version(ctx: click.Context) -> None:
    """Show version information.

    Examples:
        home-sync version
    """
    click.echo(f"home-sync version {__version__}")
    ctx.exit(0)


def main() -> None:
    """Entry point for the CLI."""
    cli(obj={})


if __name__ == "__main__":
    main()
