#!/bin/sh

fancy_echo "Updating Homebrew formulae ..."
brew update
brew bundle --file=- <<EOF
cask "appcleaner"
cask "dropbox"
cask "firefox"
cask "font-source-code-pro"
cask "font-source-code-pro-for-powerline"
cask "fork"
cask "hammerspoon" # scriptable system wide key bindings
cask "intel-haxm"
cask "iterm2"
cask "karabiner-elements"
cask "lunar" # key bindings to external monitor brightness
cask "oversight" # Webcam notification
cask "qlmarkdown"
cask "quicklook-json"
cask "skype"
cask "sourcetree"
cask "sublime-text"
cask "the-unarchiver"
cask "toggl"
cask "tor-browser"
cask "virtualbox"
cask "virtualbox-extension-pack"
cask "vlc"
EOF