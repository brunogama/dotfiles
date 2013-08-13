#!/usr/bin/env zsh
# setopt interactivecomments  # enable "#" in the shell
# unsetopt correctall # i don't misstype because I use the tab so it is useless.

export __BG_PLUGIN_PATH=$(dirname $0)

 . $__BG_PLUGIN_PATH/bg_checks.zsh

. $__BG_PLUGIN_PATH/bg_env.sh
# source $__BG_PLUGIN_PATH/pip_completion.zsh
. $__BG_PLUGIN_PATH/bg_aliases.sh
. $__BG_PLUGIN_PATH/bg_functions.sh
. $__BG_PLUGIN_PATH/get-short-path.zsh
## OTHER FILES TO SOURCE

# Autojump
if [[ $IS_MAC -eq 1 ]];then
    export HOMEBREW_HOME=$(brew --prefix)
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi

if [[ $IS_LINUX -eq 1 ]];then
    # [[ -s /usr/bin/autojump ]] && . /usr/bin/autojump
fi
# Pythonbrew
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"


# My Modules setup for prezto
zstyle ':prezto:load' pmodule \
  'environment' \
    'git' \
    'archive' \
    'completion' \
    '# setopt interactivecomments  # enable "#" in the shell
# unsetopt correctall # i don't misstype because I use the tab so it is useless.

export __BG_PLUGIN_PATH=$(dirname $0)

 . $__BG_PLUGIN_PATH/bg_checks.zsh

. $__BG_PLUGIN_PATH/bg_env.sh
# source $__BG_PLUGIN_PATH/pip_completion.zsh
. $__BG_PLUGIN_PATH/bg_aliases.sh
. $__BG_PLUGIN_PATH/bg_functions.sh
. $__BG_PLUGIN_PATH/get-short-path.zsh
## OTHER FILES TO SOURCE

# Autojump
if [[ $IS_MAC -eq 1 ]];then
    export HOMEBREW_HOME=$(brew --prefix)
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi

if [[ $IS_LINUX -eq 1 ]];then
    # [[ -s /usr/bin/autojump ]] && . /usr/bin/autojump
fi
# Pythonbrew
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"


# My Modules setup for prezto
zstyle ':prezto:load' pmodule \
  'environment' \
    'git' \
    'prompt' \
    'archive' \
    'completion' \
    'history-substring-search' \
    'history' \
    'python' \
    'ruby' \
    'node' \
    'rsync' \
    'ssh' \
    'mkcd'


if [[ $IS_LINUX -eq 1 ]];then
zstyle ':prezto:load' pmodule \
  'environment' \
    'dpkg' \
    'command-not-found' 

    
fi

if [[ $IS_MAC -eq 1 ]];then
zstyle ':prezto:load' pmodule \
  'environment' \
    'osx' \
    'homebrew'
fi

