#!/usr/bin/env zsh
# bg_env.zsh

# Pre-functions to help $PATH handling.
# Source: What is the most elegant way to remove a path from the $PATH variable in Bash?
# Link: http://stackoverflow.com/q/370047
path_append ()  { path_remove $1; PATH="$PATH:$1"; }
path_prepend () { path_remove $1; PATH="$1:$PATH"; }
path_remove ()  { PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

ifValidAppendToPath() { [ -d "$1" ] && path_append "$1" }
ifValidPrependToPath() { [ -d "$1" ] && path_prepend "$1" }

path_append "/usr/bin"
path_append "/usr/local/sbin"
path_append "/usr/local/share/python"
path_append "/opt/local/bin"
path_append "/opt/local/sbin"
path_append "/usr/local/git/bin"
path_append "${HOME}/.local/bin"
path_append "${HOME}/.local/share"
path_append "/usr/local/include"
path_append "/Applications/Xcode.app/Contents/Developer/usr/bin"
# path_append "/Library/Frameworks/Mono.framework/Versions/Current/bin/"
# path_append "/Applications/Unity/MonoDevelop.app/Contents/MacOS"
# path_append "/Applications/Unity/MonoDevelop.app/Contents/Frameworks/Mono.framework/Commands/"
path_append "$_BGDOTFILES/bin"
path_append "${HOMEBREW_HOME}/bin"
path_append "${HOMEBREW_HOME}/sbin"
path_prepend "/usr/local/bin"
path_prepend "/usr/local/share/npm/bin"


# export PATH
export PATH

# Python
export PYTHONSTARTUP="${HOME}/.pythonrc.py"



# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# MISC
# Build monodevelop stuff
# export ACLOCAL_FLAGS="-I /Library/Frameworks/Mono.framework/Versions/Current/share/aclocal"
# export DYLD_FALLBACK_LIBRARY_PATH="/Library/Frameworks/Mono.framework/Versions/Current/lib:/lib:/usr/lib"
export WORDCHARS=''

export ARCHFLAGS="-arch i386 -arch x86_64"
export HISTIGNORE="${HISTIGNORE}:&:ls:[bf]g:exit:ls *:cd:cd -:pwd;exit:date:* --help"
export HISTCONTROL="${HISTCONTROL}:erasedups:ignoreboth"  # Erase duplicates
export HISTTIMEFORMAT="%h/%D - %H:%M:%S "
export HISTSIZE=15000 # resize history size


if hash subl 2>/dev/null; then
    export EDITOR="subl"
elif hash mvim 2>/dev/null; then
    export EDITOR="mvim"
elif hash gvim 2>/dev/null; then
    export EDITOR="gvim"
elif hash vim 2>/dev/null; then
    export EDITOR="vim"
elif hash vi 2>/dev/null; then
    export EDITOR='vi'
else
    export EDITOR='nano'
fi;

export GIT_EDITOR=$EDITOR

[ -d "/opt/local/share/man" ] && export MANPATH="/opt/local/share/man":$MANPATH


# Java Stuff
[ -d "/Library/Java/Home" ]                      && export JAVA_HOME="/Library/Java/Home"
[ -f "/Users/windu/.local/apache-ant-1.8.2" ]    && export ANT_HOME="/Users/windu/.local/apache-ant-1.8.2"

# Node JSe
export NODE_PATH="/usr/local/lib/node"
