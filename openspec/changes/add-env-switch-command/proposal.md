# Add Environment Switch Command

## Why
Users need an easy way to switch between work and home environments without manually editing `~/.zshenv`. While a `work-mode` script exists, it uses a marker file approach that's incompatible with the new `DOTFILES_ENV` variable system we just implemented.

## What Changes
- Update existing `work-mode` script to use `DOTFILES_ENV` variable instead of marker file
- Rename script to `dotfiles-env` (or keep as `work-mode` with enhanced functionality)
- Add support for switching between work, personal, and checking current environment
- Make it work seamlessly with the environment detection in `.zshrc`

## Impact
- Affected specs: `environment-management`
- Affected files:
  - `scripts/core/work-mode` - Refactor to use DOTFILES_ENV variable
  - `config/zsh/.zshrc` - Already supports DOTFILES_ENV (no changes needed)
  - `~/.zshenv` - Script will edit this file to set/unset DOTFILES_ENV
