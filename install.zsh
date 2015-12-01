#!/usr/bin/env zsh
# The basic setup script... may not work properly but it is the way to go :)


zsh
setopt EXTENDED_GLOB
git clone --recursive https://github.com/brunogama/dotfiles.git "${ZDOTDIR:-$HOME}/.dotfiles}"
ln -s "${ZDOTDIR:-$HOME}/.dotfiles/prezto}" "${ZDOTDIR:-$HOME}/.zprezto}"

for bg_dotfile in "${ZDOTDIR:-$HOME}"/.dotfiles/link/^README.md(.N); do
  ln -s "$bg_dotfile" "${ZDOTDIR:-$HOME}/.${bg_dotfile:t}"
done

# Setup vIM stack
curl https://j.mp/spf13-vim3 -L > ~/spf13-vim.sh && sh ~/spf13-vim.sh
cd ~
