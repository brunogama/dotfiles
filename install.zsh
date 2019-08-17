#!/usr/bin/env zsh

zsh

setopt EXTENDED_GLOB

git clone --recursive https://github.com/brunogama/dotfiles.git "${ZDOTDIR:-$HOME}/.dotfiles}"

for bg_dotfile in "${ZDOTDIR:-$HOME}"/.dotfiles/link/^README.md(.N); do
  ln -s "$bg_dotfile" "${ZDOTDIR:-$HOME}/.${bg_dotfile:t}"
done
