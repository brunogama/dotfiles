#!/usr/bin/env zsh

alias dotfiles='e ~/.dotfiles'
alias sudo='sudo'
alias emptytrash='sudo -v; rm -rfv /Volumes/*/.Trashes 2> /dev/null;rm -rfv ~/.Trash 2> /dev/null;rm -rfv /private/var/log/asl/*.asl 2> /dev/null'

alias k='pkill -9 -fi'

alias flushdns='sudo killall -HUP mDNSResponder;say flushed'

alias g="git"
alias ggo="git checkout -B"
alias gco="git clone --recursive"
alias gpr="git pull --rebase"
# Remove all traces of git from a folder
alias degit="find . -name '.git' -exec rm -rf {} \;"

alias oo="o ."

alias ttl='ping www.google.com'
# IP addresses
alias ip="curl canihazip.com"
alias localip="python -c \"import socket;s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM);s.connect(('8.8.8.8',80));print(s.getsockname()[0]);s.close()\""

# File size
alias fs="stat -f \"%z bytes\""

# tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s $(basename $(pwd))'
alias tml='tmux list-sessions'
alias mux='tmuxinator'

alias cask='brew cask'

# top
alias cpu='top -o cpu'
alias mem='top -o rsize' # memory

alias gitk='/usr/bin/wish $(which gitk)'