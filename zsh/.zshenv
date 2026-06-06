#
# Sets ZDOTDIR for organized zsh configuration
#
# This file MUST be at ~/.zshenv (in $HOME) to bootstrap the config directory.
# All other zsh config files will be in $ZDOTDIR (~/.config/zsh/)
#

# Set XDG base directory and config directory without filesystem checks.
# .zshenv runs for every zsh process, so keep it as small as possible.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}"
