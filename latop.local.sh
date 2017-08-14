#!/bin/sh

# Personal customizations for the awesome
# Mobile Development Laptop Environment


fancy_echo "Updating Homebrew formulae ..."
brew update
brew bundle --file=- <<EOF

# Programming languages and package managers
brew kylef/formulae/swiftenv

# Mac utilities
brew "mackup"

# Applications
cask "vlc"
cask "transmission"
cask "iterm2"
cask "firefox"
cask "sip"
cask "1password"
cask "dropbox"
cask "github-desktop"
cask "slack"
cask "spotify"
cask "skype"
cask "docker"
cask "docker-toolbox"
cask "the-unarchiver"
cask "tor-browser"

# Enhancing Quicklookd
cask "qlcolorcode"
cask "qlstephen"
cask "qlmarkdown"
cask "quicklook-json"
cask "qlprettypatch"
cask "quicklook-csv"
cask "betterzipql"
cask "webp-quicklook"
cask "suspicious-package"

# Quicklook customizations
cask "qlcolorcode"    # Preview source code files with syntax highlighting
cask "qlstephen"      # Preview plain text files without a file extension. Example: README, CHANGELOG, etc.
cask "qlmarkdown"     # Preview Markdown files
cask "quicklook"-json # Preview JSON files
cask "qlprettypatch"  # Preview .patch files
cask "quicklook"-csv  # Preview CSV files
cask "betterzipql"    # Preview archives
cask "qlimagesize"    # Display image size and resolution
cask "webpquicklook"  # Preview WebP images
cask "suspicious"-package # Preview the contents of a standard Apple installer package
EOF

# Install npm packages
npm install spoof -g --silent # Because spoofing Mac-address using ifconfig is painful
