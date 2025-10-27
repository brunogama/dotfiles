# Add Environment Indicator to Shell Prompt

## Why
Currently, the shell prompt doesn't show whether you're using the work or home environment configuration. The `prompt_env_context` function exists in `.p10k.zsh` but is never activated because `.zshrc` doesn't source either `work-config.zsh` or `personal-config.zsh`. This makes it hard to know which environment context you're working in.

## What Changes
- Add automatic environment detection logic to `.zshrc`
- Source the appropriate environment config file (work or personal)
- Set `WORK_ENV` variable in `work-config.zsh` to activate the prompt indicator
- Add configuration option to choose between work and personal environments

## Impact
- Affected specs: `shell-environment`
- Affected files:
  - `config/zsh/.zshrc` - Add environment detection and sourcing logic
  - `config/zsh/work-config.zsh` - Uncomment and set WORK_ENV variable
  - `config/zsh/personal-config.zsh` - Already sets HOME_ENV correctly
  - `config/zsh/.p10k.zsh` - Already has prompt_env_context function (no changes needed)
