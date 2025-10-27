#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///

"""
SwiftFormat Hook for Claude Code
Automatically formats Swift files after edit operations.
"""

import json
import sys
import subprocess
import os
from pathlib import Path


def is_swift_file(file_path: str) -> bool:
    """Check if the file is a Swift file."""
    return file_path.endswith('.swift')


def run_swiftformat(file_path: str) -> tuple[bool, str]:
    """
    Run SwiftFormat on the specified file.

    Returns:
        tuple: (success: bool, message: str)
    """
    try:
        # Check if SwiftFormat is available
        result = subprocess.run(
            ['which', 'swift-format'],
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode != 0:
            return False, "SwiftFormat not found. Install with: brew install swift-format"

        # Run SwiftFormat with in-place formatting
        result = subprocess.run(
            ['swift-format', '--in-place', file_path],
            capture_output=True,
            text=True,
            timeout=30,
            cwd=os.getcwd()
        )

        if result.returncode == 0:
            return True, f" SwiftFormat applied to {Path(file_path).name}"
        else:
            return False, f" SwiftFormat failed: {result.stderr.strip()}"

    except subprocess.TimeoutExpired:
        return False, " SwiftFormat timed out"
    except Exception as e:
        return False, f" SwiftFormat error: {str(e)}"


def main():
    try:
        # Read input from stdin
        input_data = json.loads(sys.stdin.read())

        # Extract relevant information
        tool_name = input_data.get('tool_name', '')
        tool_input = input_data.get('tool_input', {})
        hook_event_name = input_data.get('hook_event_name', '')

        # Only process PostToolUse events for edit operations
        if hook_event_name != 'PostToolUse':
            sys.exit(0)

        # Only process Edit, MultiEdit, and Write operations
        if tool_name not in ['Edit', 'MultiEdit', 'Write']:
            sys.exit(0)

        # Extract file path based on tool type
        file_path = None
        if tool_name in ['Edit', 'Write']:
            file_path = tool_input.get('file_path')
        elif tool_name == 'MultiEdit':
            file_path = tool_input.get('file_path')

        if not file_path:
            sys.exit(0)

        # Only process Swift files
        if not is_swift_file(file_path):
            sys.exit(0)

        # Check if file exists
        if not Path(file_path).exists():
            print(f"  File not found: {file_path}", file=sys.stderr)
            sys.exit(0)

        # Run SwiftFormat
        success, message = run_swiftformat(file_path)

        if success:
            print(message)  # Success message to stdout
            sys.exit(0)
        else:
            print(message, file=sys.stderr)
            sys.exit(2)  # Non-blocking error

    except json.JSONDecodeError as e:
        print(f" Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f" SwiftFormat hook error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
