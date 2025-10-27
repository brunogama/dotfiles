#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# ///

"""
SwiftLint Hook for Claude Code
Automatically lints and fixes Swift files after edit operations using the intelligent proxy system.
"""

import json
import sys
import subprocess
import os
from pathlib import Path


def is_swift_file(file_path: str) -> bool:
    """Check if the file is a Swift file."""
    return file_path.endswith('.swift')


def find_proxy_script() -> Path | None:
    """Find the SwiftLint proxy script."""
    # Look for the proxy script in common locations
    possible_paths = [
        Path('scripts/swiftlint-proxy.py'),
        Path('../scripts/swiftlint-proxy.py'),
        Path('../../scripts/swiftlint-proxy.py'),
    ]

    for proxy_path in possible_paths:
        if proxy_path.exists():
            return proxy_path.resolve()

    # Try to find it relative to the project root
    cwd = Path.cwd()
    while cwd != cwd.parent:
        proxy_path = cwd / 'scripts' / 'swiftlint-proxy.py'
        if proxy_path.exists():
            return proxy_path.resolve()
        cwd = cwd.parent

    return None


def run_swiftlint_proxy(file_path: str) -> tuple[bool, str]:
    """
    Run SwiftLint Proxy on the specified file for intelligent fixes.

    Returns:
        tuple: (success: bool, message: str)
    """
    try:
        # Find the proxy script
        proxy_script = find_proxy_script()
        if not proxy_script:
            # Fallback to direct SwiftLint if proxy not found
            return run_swiftlint_fallback(file_path)

        # Run the proxy with fix operation using uv
        cmd = ['uv', 'run', str(proxy_script), 'fix', '--no-backup', file_path]

        # Run SwiftLint proxy with intelligent fixes
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30,
            cwd=os.getcwd()
        )

        # Parse output to determine success and extract violations
        output = result.stdout.strip()
        violations_info = ""
        remaining_violations_info = ""

        # Parse violations from output
        if "VIOLATIONS_START:" in output and "VIOLATIONS_END" in output:
            lines = output.split('\n')
            violation_count = 0
            violations = []

            in_violations = False
            for line in lines:
                if line.startswith("VIOLATIONS_START:"):
                    violation_count = int(line.split(':')[1])
                    in_violations = True
                elif line == "VIOLATIONS_END":
                    in_violations = False
                elif in_violations and line.startswith("VIOLATION:"):
                    violations.append(line[10:])  # Remove "VIOLATION:" prefix

            if violations:
                violations_info = f"\n Found {violation_count} violations:\n"
                for violation in violations[:5]:  # Show first 5
                    violations_info += f"  • {violation}\n"
                if violation_count > 5:
                    violations_info += f"  ... and {violation_count - 5} more\n"

        # Parse remaining violations (after fix attempts)
        if "REMAINING_VIOLATIONS:" in output:
            remaining_parts = output.split("REMAINING_VIOLATIONS:", 1)
            if len(remaining_parts) > 1:
                remaining_violations = remaining_parts[1].strip()
                if remaining_violations:
                    remaining_lines = remaining_violations.split('\n')[:3]  # Show first 3
                    remaining_violations_info = f"\n Remaining violations:\n"
                    for line in remaining_lines:
                        if line.strip():
                            remaining_violations_info += f"  • {line.strip()}\n"

        # Check for success indicators in proxy output
        # Determine if we should return success or failure based on remaining violations
        has_remaining_violations = bool(remaining_violations_info.strip())

        if result.returncode == 0:
            if "Applied 0 intelligent fixes" in output:
                if violations_info:
                    # If there were violations found but no fixes applied, this is a failure
                    return False, f" SwiftLint Proxy: {Path(file_path).name} (violations found but no fixes applied){violations_info}{remaining_violations_info}"
                else:
                    return True, f" SwiftLint Proxy: {Path(file_path).name} (no violations)"
            elif "Applied" in output and "intelligent fixes" in output:
                # Extract number of fixes
                import re
                match = re.search(r'Applied (\d+) intelligent fixes', output)
                if match:
                    fixes = match.group(1)
                    if has_remaining_violations:
                        return False, f" SwiftLint Proxy: {Path(file_path).name} ({fixes} fixes applied, violations remain){violations_info}{remaining_violations_info}"
                    else:
                        return True, f" SwiftLint Proxy: {Path(file_path).name} ({fixes} fixes applied){violations_info}{remaining_violations_info}"
            elif "Total fixes applied:" in output:
                # Handle comprehensive fixes
                import re
                match = re.search(r'Total fixes applied: (\d+)', output)
                if match:
                    total_fixes = match.group(1)
                    if has_remaining_violations:
                        return False, f" SwiftLint Proxy: {Path(file_path).name} ({total_fixes} total fixes applied, violations remain){violations_info}{remaining_violations_info}"
                    else:
                        return True, f" SwiftLint Proxy: {Path(file_path).name} ({total_fixes} total fixes applied){violations_info}{remaining_violations_info}"

            # If we reach here and have remaining violations, it's a failure
            if has_remaining_violations:
                return False, f" SwiftLint Proxy: {Path(file_path).name} (violations remain){violations_info}{remaining_violations_info}"
            else:
                return True, f" SwiftLint Proxy applied to {Path(file_path).name}{violations_info}{remaining_violations_info}"
        else:
            # Non-zero return code from proxy indicates failure
            stderr_output = result.stderr.strip()
            error_msg = stderr_output or "Check failed with violations"
            return False, f" SwiftLint Proxy: {error_msg}{violations_info}{remaining_violations_info}"

    except subprocess.TimeoutExpired:
        return False, " SwiftLint Proxy timed out"
    except Exception as e:
        return False, f" SwiftLint Proxy error: {str(e)}"


def run_swiftlint_fallback(file_path: str) -> tuple[bool, str]:
    """
    Fallback to direct SwiftLint if proxy is not available.

    Returns:
        tuple: (success: bool, message: str)
    """
    try:
        # Check if SwiftLint is available
        result = subprocess.run(
            ['which', 'swiftlint'],
            capture_output=True,
            text=True,
            timeout=5
        )

        if result.returncode != 0:
            return False, "SwiftLint not found. Install with: brew install swiftlint"

        # Build SwiftLint command
        cmd = ['swiftlint', 'lint', '--fix', '--no-backup', file_path]

        # Run SwiftLint with auto-fix
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=30,
            cwd=os.getcwd()
        )

        # SwiftLint returns 0 for success, 2 for violations found but corrected
        if result.returncode in [0, 2]:
            violations_fixed = "violations found and fixed" if result.returncode == 2 else "no violations"
            return True, f" SwiftLint (fallback) applied to {Path(file_path).name} ({violations_fixed})"
        else:
            stderr_output = result.stderr.strip()
            stdout_output = result.stdout.strip()
            error_msg = stderr_output or stdout_output or "Unknown error"
            return False, f" SwiftLint (fallback) failed: {error_msg}"

    except subprocess.TimeoutExpired:
        return False, " SwiftLint (fallback) timed out"
    except Exception as e:
        return False, f" SwiftLint (fallback) error: {str(e)}"


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

        # Run SwiftLint Proxy (with fallback to direct SwiftLint)
        success, message = run_swiftlint_proxy(file_path)

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
        print(f" SwiftLint hook error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
