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

    if (( $+commands[pyenv] )); then
        eval "$(pyenv init -)";
    fi

    grep -q 'virtualenv-init' <(pyenv commands)

    if (( $?==0 )); then
        eval "$(pyenv virtualenv-init -)";
    fi
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*


if (( $+commands[gibo] )) ; then
    source $HOME/.dotfiles/gibo-completion.zsh
fi
