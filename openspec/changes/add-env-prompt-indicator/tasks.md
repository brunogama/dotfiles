# Implementation Tasks

## 1. Add Environment Detection to .zshrc
- [x] 1.1 Add environment variable check (e.g., `DOTFILES_ENV`) to determine which config to load
- [x] 1.2 Add logic to source work-config.zsh when `DOTFILES_ENV=work`
- [x] 1.3 Add logic to source personal-config.zsh when `DOTFILES_ENV=personal` or by default
- [x] 1.4 Add comments explaining how to switch between environments

## 2. Update work-config.zsh
- [x] 2.1 Uncomment and set `export WORK_ENV="work"` by default
- [x] 2.2 Update echo message to indicate work environment is active

## 3. Testing
- [x] 3.1 Test with `DOTFILES_ENV=work` - shows "WORK" in environment [OK]
- [x] 3.2 Test with `DOTFILES_ENV=personal` - shows "HOME:PERSONAL" in environment [OK]
- [x] 3.3 Test work-profile function (dev/prod/staging) - updates WORK_ENV to "development" [OK]
- [x] 3.4 Verify prompt colors (orange for work, blue for home) - implemented in .p10k.zsh [OK]

## 4. Documentation
- [x] 4.1 Add instructions to README on how to set environment preference
- [x] 4.2 Document the DOTFILES_ENV variable usage
