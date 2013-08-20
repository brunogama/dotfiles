#!/usr/bin/env zsh
# bg_aliases.zsh

alias dotfiles='e ~/.dotfiles'
if (( $IS_MAC )); then
    # Empty the Trash on all mounted volumes and the main HDD
    # Also, clear Apple’s System Logs to improve shell startup speed
    alias emptytrash='sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl'
    # Get OS X Software Updates, update Homebrew itself, and upgrade installed Homebrew packages
    # /usr/libexec/XProtectUpdater forces update for the malware defintions list by apple
    alias update='sudo softwareupdate -i -a; /usr/libexec/XProtectUpdater; brew update; brew upgrade'
    # Show/hide hidden files in Finder
    alias show='defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder'
    alias hide='defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder'
    # Hide/show all desktop icons (useful when presenting)
    alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
    alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'
    alias o='open'
    alias k='pkill -9 -fi'
fi

if (( $IS_LINUX )); then
    alias o='xdg-open'
    alias k='kill'
fi

alias g="git"
alias oo="o ."
alias s=$EDITOR
alias e=s
# alias ls='ls -p'
# alias lsd='ls -l -p | grep "^d"'   # List only directories
alias open-connections="lsof -i | grep -E '(LISTEN|ESTABLISHED)'"
alias p="python"
alias lsusb='system_profiler SPUSBDataType'
alias tu='top -o cpu'
alias tm='top -o rsize'

alias ggo="git checkout -B"
alias ttl='ping -s 1 www.google.com'     # my time to live
alias octal="cat ~/Dropbox/_/Personal/Documents/octal-help.txt"
alias rules="cat /Users/windu/Dropbox/_/Personal/Documents/rules-of-the-internet.txt"
# http://www.jukie.net/~bart/blog/pimping-out-git-log
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%an %cr)%Creset' --abbrev-commit --date=relative"

# python and django syncdb command
alias syncdb='python manage.py syncdb'
alias wipe_pyc='find . -type f \( -name \*\.pyc -or -name \*\.pyo \) -exec rm -v {} \;'

alias sudo='sudo '
# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="python -c \"import socket;s=socket.socket(socket.AF_INET, socket.SOCK_DGRAM);s.connect(('8.8.8.8',80));print(s.getsockname()[0]);s.close()\""
alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# File size
alias fs="stat -f \"%z bytes\""

alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias urldecode='python -c "import sys, urllib as ul; print ul.unquote_plus(sys.argv[1]);"'
