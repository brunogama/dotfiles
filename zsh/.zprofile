#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ -z "$BROWSER" && "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

if [[ -z "$EDITOR" ]]; then
  export EDITOR='nano'
fi
if [[ -z "$VISUAL" ]]; then
  export VISUAL='nano'
fi
if [[ -z "$PAGER" ]]; then
  export PAGER='less'
fi

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
# Keep inherited Nix profile paths ahead of Homebrew and /usr/local fallbacks.
path=(
  $HOME/{,s}bin(N)
  $path
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
)

# Legacy version managers remain available as an explicit migration fallback.
if [[ "${DOTFILES_ENABLE_LEGACY_VERSION_MANAGERS:-0}" == "1" ]]; then
  path=(
    $PYENV_ROOT/shims(N)
    $PYENV_ROOT/bin(N)
    $path
  )
fi

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
if [[ -z "$LESS" ]]; then
  export LESS='-g -i -M -R -S -w -X -z-4'
fi

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Do not source .zshrc here.
#
# Zsh automatically reads $ZDOTDIR/.zshrc for interactive shells after .zprofile.
# Sourcing it manually here makes login shells load the full interactive config twice.
