#!/usr/bin/env zsh

alias dotfiles='e ~/.dotfiles'
alias sudo='sudo'
alias emptytrash='sudo -v; rm -rfv /Volumes/*/.Trashes 2> /dev/null;rm -rfv ~/.Trash 2> /dev/null;rm -rfv /private/var/log/asl/*.asl 2> /dev/null'
alias update='sudo softwareupdate -ia; /usr/libexec/XProtectUpdater; brew update; brew upgrade'

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'

alias k='pkill -9 -fi'
alias flushdns='sudo killall -HUP mDNSResponder;say flushed'

alias g="git"
alias ggo="git checkout -B"
alias gco="git clone --recursive"
alias gpr="git pull --rebase"

alias oo="o ."

alias ttl='ping -s 1 www.google.com'
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="python -c \"import socket;s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM);s.connect(('8.8.8.8',80));print(s.getsockname()[0]);s.close()\""

# File size
alias fs="stat -f \"%z bytes\""

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1]);"'

# tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s $(basename $(pwd))'
alias tml='tmux list-sessions'
alias mux='tmuxinator'