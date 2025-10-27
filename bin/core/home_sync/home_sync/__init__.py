"""Home Sync - Dotfiles and credentials synchronization daemon."""

__version__ = "2.0.0"
__author__ = "Bruno Gama"

from home_sync.cli import main

__all__ = ["main", "__version__"]
