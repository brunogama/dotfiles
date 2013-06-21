#!/usr/bin/env zsh

setopt interactivecomments  # enable "#" in the shell
unsetopt correctall # i don't misstype because I use the tab so it is useless.

export HOMEBREW_HOME=$(brew --prefix)
export __BG_PLUGIN_PATH=$(dirname $0)


source $__BG_PLUGIN_PATH/bg_env.sh

# source $__BG_PLUGIN_PATH/pip_completion.zsh
source $__BG_PLUGIN_PATH/bg_aliases.sh
source $__BG_PLUGIN_PATH/bg_functions.sh

## OTHER FILES TO SOURCE

# Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Pythonbrew
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"