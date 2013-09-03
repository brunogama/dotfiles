#!/usr/bin/env zsh
setopt interactivecomments  # enable "#" in the shell

export _BGDOTFILES="${ZDOTDIR:-$HOME}/.dotfiles"
source $_BGDOTFILES/source/bg_checks.zsh
source $_BGDOTFILES/source/bg_env.zsh
source $_BGDOTFILES/source/extra-packages/pip_completion.zsh
source $_BGDOTFILES/source/bg_aliases.zsh
source $_BGDOTFILES/source/bg_functions.sh
# source $_BGDOTFILES/source/extra-packages/get-short-path.zsh # Only needed fot the prompt theme Agnoster
# source $_BGDOTFILES/source/extra-packages/git.zsh  # Only needed fot the prompt theme Agnoster
source $_BGDOTFILES/source/bg_keybindings.zsh  # Only needed fot the prompt theme Agnoster
if (( $IS_LINUX )); then
    [[ -s /usr/share/autojump/autojump.sh  ]] && source /usr/share/autojump/autojump.sh
    [[ -s /usr/local/bin/virtualenvwrapper.sh  ]] && source /usr/local/bin/virtualenvwrapper.sh
fi


if (( $IS_OSX )); then
    export HOMEBREW_HOME=$(brew --prefix)
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi
