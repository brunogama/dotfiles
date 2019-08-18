#!/usr/bin/env zsh

alias k='pkill -9 -fi'

alias flushdns='sudo killall -HUP mDNSResponder;say flushed'

alias degit="find . -name '.git' -exec rm -rf {} \;"

alias oo="o ."

alias ttl='ping www.google.com'

# tmux
alias tma='tmux attach -d -t'
alias tmn='tmux new -s $(basename $(pwd))'
alias tml='tmux list-sessions'
alias mux='tmuxinator'

alias cask='brew cask'
alias gitk='/usr/bin/wish $(which gitk)'

# Adds colors to cat
alias ccat='pygmentize -g'