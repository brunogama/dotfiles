#!/usr/bin/env zsh

case "$OSTYPE" in
  darwin*)  IS_OSX=1 ;;
  solaris*) IS_SOLARIS=1 ;;
  linux*)   IS_LINUX=1 ;;
  bsd*)     IS_BSD=1 ;;
  *)        ;;
esac


if (( $IS_MAC )); then
    [[ -x `which brew` ]] &&  HAS_BREW=1
fi

if (( $IS_LINUX )); then
    [[ -x `which apt-get` ]] && HAS_APT=1
    [[ -x `which yum` ]] && HAS_YUM=1
fi

