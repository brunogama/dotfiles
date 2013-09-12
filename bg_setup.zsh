#!/usr/bin/env zsh
setopt interactivecomments  # enable "#" in the shell

export __BG_PLUGIN_PATH="${ZDOTDIR:-$HOME}/.dotfiles"
source $__BG_PLUGIN_PATH/source/bg_checks.zsh
source $__BG_PLUGIN_PATH/source/bg_env.zsh
source $__BG_PLUGIN_PATH/source/extra-packages/pip_completion.zsh
source $__BG_PLUGIN_PATH/source/bg_aliases.zsh
source $__BG_PLUGIN_PATH/source/bg_functions.sh
# source $__BG_PLUGIN_PATH/source/extra-packages/get-short-path.zsh # Only needed fot the prompt theme Agnoster
# source $__BG_PLUGIN_PATH/source/extra-packages/git.zsh  # Only needed fot the prompt theme Agnoster
source $__BG_PLUGIN_PATH/source/bg_keybindings.zsh  # Only needed fot the prompt theme Agnoster
if (( $IS_LINUX )); then
    [[ -s /usr/share/autojump/autojump.sh  ]] && source /usr/share/autojump/autojump.sh
    [[ -s /usr/local/bin/virtualenvwrapper.sh  ]] && source /usr/local/bin/virtualenvwrapper.sh
fi


if (( $IS_OSX )); then
    export HOMEBREW_HOME=$(brew --prefix)
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
    eval "$(pyenv init -)"
fi
