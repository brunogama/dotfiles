#
# Sets ZDOTDIR for organized zsh configuration
#
# This file MUST be at ~/.zshenv (in $HOME) to bootstrap the config directory.
# All other zsh config files will be in $ZDOTDIR (~/.config/zsh/)
#

# Set XDG base directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Set ZDOTDIR to organize zsh configs
if [[ -d "$XDG_CONFIG_HOME/zsh" ]]; then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
