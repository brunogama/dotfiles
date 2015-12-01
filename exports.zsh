#!/usr/bin/env zsh

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export JAVA_HOME=`/usr/libexec/java_home`
export ANDROID_HOME=/Applications/android-sdk
# export PATH=$PATH:/usr/local/bin:/usr/local/sbin:$HOMEBREW_HOME/bin:$HOMEBREW_HOME/sbin:$_BGDOTFILES/bin:${DEVELOPER_DIR}/usr/bin:$ANDROID_HOME:/usr/bin
path=(
    /usr/local/{bin:,sbin}
    $HOMEBREW_HOME/{bin,sbin}
    $JAVA_HOME/bin
    $_BGDOTFILES/bin
    ${DEVELOPER_DIR}/usr/bin
    $ANDROID_HOME/platform-tools
    /usr/bin
    $path
)
export GRADLE_OPTS='-Dorg.gradle.daemon=true'
export EDITOR=`which subl`
export GIT_EDITOR='vim'
# export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/etc/Caskroom"

[ -d '/opt/local/share/man' ] && export MANPATH=/opt/local/share/man:$MANPATH

[ hash node 2>/dev/null ] && export NODE_PATH=`which node`

export DEFAULT_USER='bruno'
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'