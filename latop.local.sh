#!/bin/sh

fancy_echo "Updating Homebrew formulae ..."
brew update
brew bundle --file=- <<EOF
cask "vlc"
cask "iterm2"
cask "dropbox"
cask "skype"
cask "the-unarchiver"
cask "tor-browser"
cask "google-chrome"

# Quicklook customizations
cask "qlcolorcode"
cask "qlstephen"
cask "qlmarkdown"
cask "quicklook"-json"
cask "qlprettypatch"
cask "quicklook"-csv"
cask "betterzipql"
cask "qlimagesize"
cask "webpquicklook"
cask "suspicious"-package"

brew "pyenv"
brew "pyenv-virtualenv"
EOF

pip_install_or_update() {
  if hash "$1" 2>/dev/null; then
    pip update "$@"
  else
    pip install "$@"
    pyenv rehash
  fi
}

# Setting up latest Python
find_latest_python() {
    printf '%s' "$(pyenv install -l | awk '{$1=$1;print}' | tail -n +2)" | grep -oE '^(\d+\.)+\d+$' | tail -1
}
python_version="$(find_latest_python)"
pyenv install "$python_version"
pyenv global "$python_version"
pip_install_or_update "bpython"
