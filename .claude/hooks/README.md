# Claude Code Hooks for SwiftFormat and SwiftLint

This directory contains Claude Code hooks that automatically run SwiftFormat and SwiftLint on Swift files after edit operations.

## Setup

The hooks are configured to run automatically on `PostToolUse` events for the following operations:
- `Edit` - Single file edits
- `MultiEdit` - Multiple file edits  
- `Write` - File writes

## Hook Scripts

### `swiftformat_hook.py`
- Automatically formats Swift files using `swift-format --in-place`
- Only processes `.swift` files
- Provides clear success/error messages
- Times out after 30 seconds

### `swiftlint_hook.py`
- Automatically lints and fixes Swift files using `swiftlint --fix`
- Looks for SwiftLint configuration files (`.swiftlint.yml`, etc.)
- Only processes `.swift` files
- Handles both successful fixes and violations
- Times out after 30 seconds

## Configuration

The hooks are configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|MultiEdit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "uv run .claude/hooks/swiftformat_hook.py",
            "timeout": 30
          },
          {
            "type": "command",
            "command": "uv run .claude/hooks/swiftlint_hook.py",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## Requirements

- Python 3.11+ with `uv` package manager
- `swift-format` installed (via `brew install swift-format`)
- `swiftlint` installed (via `brew install swiftlint`)

## How It Works

1. When you edit, multi-edit, or write a Swift file using Claude Code
2. The `PostToolUse` hook fires after the operation completes
3. Both SwiftFormat and SwiftLint run automatically on the modified file
4. Success/error messages are shown in the transcript (Ctrl-R to view)

## Error Handling

- If tools are not installed, clear error messages are shown
- File not found errors are handled gracefully
- Non-Swift files are ignored
- Timeouts prevent hanging operations
- Non-blocking errors allow work to continue

## Testing

To test the hooks:

1. Edit a Swift file with some formatting issues
2. Check the transcript (Ctrl-R) for hook execution messages
3. Verify that the file was formatted and linted

## Troubleshooting

- Use `claude --debug` to see detailed hook execution logs
- Check that scripts are executable: `chmod +x .claude/hooks/*.py`
- Verify tools are installed: `which swift-format && which swiftlint`
- Ensure `uv` is available: `which uv`
