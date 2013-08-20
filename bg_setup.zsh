#!/usr/bin/env zsh
setopt interactivecomments  # enable "#" in the shell

export __BG_PLUGIN_PATH="${ZDOTDIR:-$HOME}/.dotfiles"

# function {
#     local BG_LOGS=1
#     local BG_LOGS_VERBOSE=1
#     function dlog {
#         if (( $BG_LOGS ));then
#             [[ ! -d $__BG_PLUGIN_PATH/logs ]] && mkdir -p $__BG_PLUGIN_PATH/logs
#             local NOW=$(date +"%F")
#             local bg_log_file=$__BG_PLUGIN_PATH/logs/"log-$NOW.log"
#             [[ -f $bg_log_file ]] || { touch $bg_log_file }
#             echo "[$(date +"%T")] $@" >> $bg_log_file
#          fi
#     }

#     function logsource {
#         dlog "Loading $@"
#         source $@
#     }
#     logsource $__BG_PLUGIN_PATH/source/bg_checks.zsh
#     logsource $__BG_PLUGIN_PATH/source/bg_env.zsh
#     logsource $__BG_PLUGIN_PATH/source/extra-packages/pip_completion.zsh
#     logsource $__BG_PLUGIN_PATH/source/bg_aliases.zsh
#     logsource $__BG_PLUGIN_PATH/source/bg_functions.sh
#     # logsource $__BG_PLUGIN_PATH/source/extra-packages/get-short-path.zsh # Only needed fot the prompt theme Agnoster
#     # logsource $__BG_PLUGIN_PATH/source/extra-packages/git.zsh  # Only needed fot the prompt theme Agnoster
#     logsource $__BG_PLUGIN_PATH/source/bg_keybindings.zsh  # Only needed fot the prompt theme Agnoster
#     unset logsource dlog
# }

    source $__BG_PLUGIN_PATH/source/bg_checks.zsh
    source $__BG_PLUGIN_PATH/source/bg_env.zsh
    source $__BG_PLUGIN_PATH/source/extra-packages/pip_completion.zsh
    source $__BG_PLUGIN_PATH/source/bg_aliases.zsh
    source $__BG_PLUGIN_PATH/source/bg_functions.sh
    source $__BG_PLUGIN_PATH/source/bg_keybindings.zsh  # Only needed fot the prompt theme Agnoster

if (( $IS_LINUX )); then
    [[ -s /usr/share/autojump/autojump.sh  ]] && source /usr/share/autojump/autojump.sh
    [[ -s /usr/local/bin/virtualenvwrapper.sh  ]] && source /usr/local/bin/virtualenvwrapper.sh
fi


if (( $IS_OSX )); then
    export HOMEBREW_HOME=$(brew --prefix)
    [[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh
fi
