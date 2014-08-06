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

ifValidAppendToPath "/usr/bin"
ifValidAppendToPath "/usr/local/sbin"
ifValidAppendToPath "/usr/local/share/python"
ifValidAppendToPath "/opt/local/bin"
ifValidAppendToPath "/opt/local/sbin"
ifValidAppendToPath "/usr/local/git/bin"
ifValidAppendToPath "${HOME}/.local/bin"
ifValidAppendToPath "/usr/local/include"
ifValidAppendToPath "/Applications/Xcode.app/Contents/Developer/usr/bin"
# ifValidAppendToPath "/Library/Frameworks/Mono.framework/Versions/Current/bin/"
# ifValidAppendToPath "/Applications/Unity/MonoDevelop.app/Contents/MacOS"
# ifValidAppendToPath "/Applications/Unity/MonoDevelop.app/Contents/Frameworks/Mono.framework/Commands/"
ifValidAppendToPath "$_BGDOTFILES/bin"
ifValidAppendToPath "${HOMEBREW_HOME}/bin"
ifValidAppendToPath "${HOMEBREW_HOME}/sbin"
ifValidPrependToPath "/usr/local/bin"
ifValidPrependToPath "/usr/local/share/npm/bin"
ifValidPrependToPath "/Applications/ADT/sdk/platform-tools"


# export PATH
export PATH

# Python
export PYTHONSTARTUP="${HOME}/.pythonrc.py"

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
export GRADLE_OPTS="-Dorg.gradle.daemon=true"

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

export GIT_EDITOR="vim"
[ -d "/opt/local/share/man" ] && export MANPATH="/opt/local/share/man":$MANPATH


# Java Stuff
[ -d "/Library/Java/Home" ]                      && export JAVA_HOME="/Library/Java/Home"
[ -f "/Users/windu/.local/apache-ant-1.8.2" ]    && export ANT_HOME="/Users/windu/.local/apache-ant-1.8.2"

# Node.js
export NODE_PATH="/usr/local/lib/node"

# Xcode Path
# export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
# export CC=/usr/local/bin/gcc-4.9
# export CPP=/usr/local/bin/cpp-4.9
# export CXX=/usr/local/bin/g++-4.9
