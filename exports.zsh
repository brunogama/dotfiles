#!/usr/bin/env zsh

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export JAVA_HOME=`/usr/libexec/java_home`
path=(
	$HOMEBREW_HOME/{bin,sbin}
    /usr/local/{bin:,sbin}
    $JAVA_HOME/bin
    $_BGDOTFILES/bin
    ${DEVELOPER_DIR}/usr/bin
    /usr/bin
    $path
    /Users/bruno/.android-sdk-macosx/platform-tools
)
export GRADLE_OPTS='-Dorg.gradle.daemon=true'
export EDITOR=`which subl`
export GIT_EDITOR='vim'
export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=/etc/Caskroom"

[ -d '/opt/local/share/man' ] && export MANPATH=/opt/local/share/man:$MANPATH

[ hash node 2>/dev/null ] && export NODE_PATH=`which node`

export DEFAULT_USER='bruno'

export SWIFTENV_ROOT=/usr/local/var/swiftenv