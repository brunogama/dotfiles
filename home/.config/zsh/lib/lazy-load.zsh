# shellcheck shell=bash

if [[ -o interactive ]] && command -v fzf &>/dev/null; then
    export FZF_COMPLETION_TRIGGER=''
    export FZF_CTRL_R_OPTS="${FZF_CTRL_R_OPTS-} --height=60% --layout=reverse --border"
    export FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS-} --height=60% --layout=reverse --border --walker=file,follow,hidden --walker-skip=.git,node_modules,target,.direnv"

    if command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="${FZF_CTRL_T_OPTS} --preview='bat --color=always --style=numbers --line-range=:200 {}'"
    fi

    eval "$(fzf --zsh)" 2>/dev/null
fi
