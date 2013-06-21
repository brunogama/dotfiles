# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="sorin"


plugins=(urltools torrent vagrant heroku gradle andt compleat dirpersist django osx autojump zsh-syntax-highlighting brew extract git github pip python)

alias ohmyzsh="subl -n ~/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

source ~/.dotfiles/bg_setup.zsh
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"