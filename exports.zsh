export JAVA_HOME=$(/usr/libexec/java_home)
path=(
	"${HOMEBREW_HOME}"/{bin,sbin}
    /usr/local/{bin,sbin}
    "${JAVA_HOME}"/bin
    "${_BGDOTFILES}"/bin
    $path
)
export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"
export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"
EDITOR=editor.sh
export EDITOR
export GIT_EDITOR='vim'
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

[ -d '/opt/local/share/man' ] && export MANPATH=/opt/local/share/man:$MANPATH
