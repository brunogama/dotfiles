#!/usr/bin/env zsh
setopt interactivecomments  # enable "#" in the shell
unsetopt correctall # i don't misstype because I use the tab so it is useless.


export __BG_PLUGIN_PATH=$(dirname $0)
export __BG_LOGS=0
function dlog(){
    if [[ $__BG_LOGS -eq 1 ]];then
        [[ ! -d $__BG_PLUGIN_PATH/logs ]] && mkdir -p $__BG_PLUGIN_PATH/logs
        NOW=$(date +"%F")
        bg_log_file=$__BG_PLUGIN_PATH/logs/"log-$NOW.log"
        [[ -f $bg_log_file ]] || { touch $bg_log_file }
        echo "[$(date +"%T")] $@" >> $bg_log_file
     fi
}

dlog 'loading bg_env.sh'
source $__BG_PLUGIN_PATH/bg_env.sh
dlog 'loading bg_pip_completion'
source $__BG_PLUGIN_PATH/pip_completion.zsh
dlog 'loding bg_aliases.zsh'
source $__BG_PLUGIN_PATH/bg_aliases.zsh
dlog 'loading bg_functions.sh'
source $__BG_PLUGIN_PATH/bg_functions.sh
# dlog 'loading get-short-path.zsh'
# source $__BG_PLUGIN_PATH/get-short-path.zsh # Only needed fot the prompt theme Agnoster
# dlog 'loading git.zsh'
# source $__BG_PLUGIN_PATH/git.zsh  # Only needed fot the prompt theme Agnoster
dlog 'loading keybindings.zsh'
source $__BG_PLUGIN_PATH/keybindings.zsh  # Only needed fot the prompt theme Agnoster



DEFAULT_MODULES=('terminal' 'editor' 'history' 'directory' \
    'spectrum' 'utility' 'completion' 'prompt');
BG_MODULES_SETUP=('git' 'prompt' 'archive' 'completion' \
    'history-substring-search' 'history' 'python' 'ruby' 'node' \
    'rsync' 'ssh' 'mkcd');

BG_MAC_MODULES=();
BG_LINUX_MODULES=();

if [[ $IS_LINUX -eq 1 ]];then
    BG_LINUX_MODULES=('dpkg' 'command-not-found');
    [[ -s /usr/share/autojump/autojump.sh  ]] && source /usr/share/autojump/autojump.sh
    source /usr/local/bin/virtualenvwrapper.sh
fi

if [[ $IS_MAC -eq 1 ]];then
    export HOMEBREW_HOME=$(brew --prefix) 
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
    BG_MAC_MODULES=('osx' 'homebrew');
fi


# My Modules setup for prezto
PREZTO_MODULES_SETUP=(${DEFAULT_MODULES[@]} \
                      ${BG_MAC_MODULES[@]} \
                      ${BG_LINUX_MODULES[@]});

zstyle ':prezto:load' pmodule \
  'environment' $PREZTO_MODULES_SETUP


