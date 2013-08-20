#!/usr/bin/env zsh
# install.zsh
# Author: Bruno Gama
# The basic setup script... may not work properly but it is the way to go :)
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
function setup_vim {
    curl https://j.mp/spf13-vim3 -L > ~/spf13-vim.sh && sh ~/spf13-vim.sh
}
setup_prezto
setup_custom_bg_dotfiles
setup_vim
# echo "Installing Homebrew"
# ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
# echo "Running Homebrew default system packages"
# sh brew.sh

# echo "Installing gems"
# gem cupertino liftoff

 
