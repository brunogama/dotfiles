# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Set default editor to VS Code
export EDITOR="code"
export VISUAL="code"

unalias g
unalias o
unalias e

alias zs='source .zshrc'
alias config='code ~/.config'
alias gitconfig='code ~/.gitconfig'
alias mkdir="mkdir -p"
alias commit="git commit"
alias ppulls="git pull || true; git submodule foreach 'git pull || true'" 
alias ppush="git push || true; git submodule foreach 'git push || true'"
alias reset-hard="git reset --hard || true"
alias reset-hard-all="reset-hard; git submodule foreach 'git reset --hard'"
alias gs-all="git status; git submodule foreach 'git status'"
alias gdinit="rm -rf .git; git submodule deinit -f .; fd -e .git -t f; fd -e .gitignore -x cp {} .gitignore; git add .gitignore; git commit -m 'Initial commit'"
alias new-main-with-one-commit="git checkout -b main && git commit --allow-empty -m 'Initial commit' && git push -u origin main"
alias delete-main="git branch -D main && git push origin --delete main; git checkout -b main; new-main-with-one-commit"
alias delete-branch="git branch -D"
alias delete-remote-branch="git push origin --delete"
alias delete-tag="git tag -d"
alias delete-remote-tag="git push origin --delete"
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

deadcode() {
    local folder_name="$(basename "$(pwd)")"

    xcodebuild \
      -scheme "$folder_name" \
      -destination 'platform=iOS Simulator,OS=16.4,name=iPhone 14' \
      -derivedDataPath ~/Desktop/dd \
      clean build

    periphery scan \
      --skip-build \
      --index-store-path ~/Desktop/dd/Index.noindex/DataStore/ \
      --retain-public true \
      --targets "$folder_name"

    rm -rf ~/Desktop/dd
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

batdiff() {
    git diff --name-only --relative --diff-filter=d | xargs bat --diff
}

# Word navigation key bindings
# Multiple bindings to cover different terminal emulators
bindkey "^[[1;3D" backward-word  # Option+Left Arrow (xterm)
bindkey "^[[1;3C" forward-word   # Option+Right Arrow (xterm)
bindkey "^[b" backward-word      # Option+Left Arrow (alternative)
bindkey "^[f" forward-word       # Option+Right Arrow (alternative)
bindkey "\e[1;3D" backward-word  # Option+Left Arrow (escape sequence)
bindkey "\e[1;3C" forward-word   # Option+Right Arrow (escape sequence)
bindkey "\eb" backward-word      # Option+b
bindkey "\ef" forward-word       # Option+f

# Initialize completion
# fpath+=${ZDOTDIR:-$HOME}/.zsh_functions
autoload -U compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bruno/.cache/lm-studio/bin"


export PATH="$PATH:/Users/bruno/.config/bin"

# Set up fzf key bindings and fuzzy completion

source <(fzf --zsh)

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# SDKMAN initialization
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && {
    setopt LOCAL_OPTIONS SH_WORD_SPLIT 2>/dev/null
    source "$HOME/.sdkman/bin/sdkman-init.sh" 2>/dev/null
}
. "$HOME/.local/bin/env"
eval "$(/Users/bruno/.local/bin/mise activate zsh)"
eval "$(rbenv init -)"
eval "$(zoxide init zsh)"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/bruno/.docker/completions $fpath)
autoload -Uz compinit
compinit

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
