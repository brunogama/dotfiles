#!/usr/bin/env zsh

setopt interactivecomments  # enable "#" in the shell

export _BGDOTFILES="${ZDOTDIR:-$HOME}/Developer/dotfiles"
source $_BGDOTFILES/checks.zsh
source $_BGDOTFILES/aliases.zsh
source $_BGDOTFILES/exports.zsh
source $_BGDOTFILES/functions.sh

if (( $IS_OSX )); then
    export HOMEBREW_HOME=$(brew --prefix)

	source ${HOMEBREW_HOME}/opt/asdf/asdf.sh
	source ${HOMEBREW_HOME}/opt/autojump/etc/autojump.sh
fi


if (( $+commands[gibo] )) ; then
    source $_BGDOTFILES/gibo-completion.zsh 2>/dev/null
fi

