#!/usr/bin/env zsh

setopt interactivecomments  # enable "#" in the shell

export _BGDOTFILES="${ZDOTDIR:-$HOME}/.dotfiles"
source $_BGDOTFILES/checks.zsh
source $_BGDOTFILES/exports.zsh
source $_BGDOTFILES/aliases.zsh
source $_BGDOTFILES/functions.sh

if (( $IS_OSX )); then
    export HOMEBREW_HOME=$(brew --prefix)
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi
