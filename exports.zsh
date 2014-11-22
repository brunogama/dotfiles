#!/usr/bin/env zsh

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export ANDROID_HOME=/Applications/android-sdk
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:$HOMEBREW_HOME/bin:$HOMEBREW_HOME/sbin:$_BGDOTFILES/bin:${DEVELOPER_DIR}/usr/bin:$ANDROID_HOME:/usr/bin
export GRADLE_OPTS='-Dorg.gradle.daemon=true'
export EDITOR='subl'
export GIT_EDITOR='vim'

[ -d '/opt/local/share/man' ] && export MANPATH=/opt/local/share/man:$MANPATH
[ -d '/Library/Java/Home' ] && export JAVA_HOME=/Library/Java/Home
[ hash node 2>/dev/null ] && export NODE_PATH=`which node`
[ hash rvm 2>/dev/null ] && export PATH=$PATH:$HOME/.rvm/bin