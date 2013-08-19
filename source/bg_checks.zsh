# checks (stolen from zshuery)
# if [[ $(uname) = 'Linux' ]]; then
#     IS_LINUX=1
# fi

# if [[ $(uname) = 'Darwin' ]]; then
#     IS_MAC=1
# fi
case "$OSTYPE" in
  darwin*)  IS_OSX=1 ;;
  solaris*) IS_SOLARIS=1 ;;
  linux*)   IS_LINUX=1 ;;
  bsd*)     IS_BSD=1 ;;
  *)        ;;
esac

if [[ -x `which brew` ]]; then
    HAS_BREW=1
fi

if [[ -x `which apt-get` ]]; then
    HAS_APT=1
fi

if [[ -x `which yum` ]]; then
    HAS_YUM=1
fi


