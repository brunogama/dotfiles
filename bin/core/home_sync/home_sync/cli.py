"""Command-line interface for home-sync."""

import sys
from typing import List, Optional


def main(argv: Optional[List[str]] = None) -> int:
    """
    Main entry point for home-sync CLI.

    Args:
        argv: Command-line arguments (defaults to sys.argv[1:])

    Returns:
        Exit code (0 for success, 1 for error)
    """
    if argv is None:
        argv = sys.argv[1:]

    # TODO: Implement CLI argument parsing
    print("home-sync v2.0.0 (stub)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
