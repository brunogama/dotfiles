#!/usr/bin/env zsh
# install.zsh
# Author: Bruno Gama
# The basic setup script... may not work properly but it is the way to go :)


zsh
setopt EXTENDED_GLOB
function setup_prezto {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      ln -s -f  "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
}

function setup_custom_bg_dotfiles {
    for bg_dotfile in "${ZDOTDIR:-$HOME}"/.dotfiles/link/^README.md(.N); do
      ln -f -s "$bg_dotfile" "${ZDOTDIR:-$HOME}/.${bg_dotfile:t}"
    done
}
function setup_zsh_theme {
   ln -s "${ZDOTDIR:-$HOME}"/.dotfiles/source/extra-packages/prompt_agnoster_setup  "${ZDOTDIR:-$HOME}"/.zprezto/modules/prompt/functions/
}

function setup_vim {
    curl https://j.mp/spf13-vim3 -L > ~/spf13-vim.sh && sh ~/spf13-vim.sh
}

function setup_slate {
  cd /Applications && curl http://www.ninjamonkeysoftware.com/slate/versions/slate-latest.tar.gz | tar -xz
}

setup_prezto
setup_custom_bg_dotfiles
setup_zsh_theme
setup_vim
setup_slate
cd ~
