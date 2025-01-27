autoload -Uz promptinit colors bashcompinit compinit zmv
promptinit
colors
bashcompinit
compinit

fpath+=~/.zfunc

# Completion settings
zstyle ':completion:*:default' menu select true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:sudo:*' command-path /opt/homebrew/sbin /opt/homebrew/bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# zmv alias
alias zmv='noglob zmv -W'

# Set options
setopt append_history auto_list auto_menu auto_resume NO_beep brace_ccl correct \
       NO_flow_control NO_hup ignore_eof list_types long_list_jobs mark_dirs \
       numeric_glob_sort print_eightbit prompt_subst hist_no_store extended_history \
       inc_append_history share_history hist_ignore_all_dups hist_ignore_dups hist_ignore_space

# History settings
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

# Locale and timezone
export LANG=en_US.UTF-8
TZ='Asia/Tokyo'; export TZ

# Homebrew setup
if [ -s "/opt/homebrew/bin/brew" ]; then
    HOMEBREW_DIR="/opt/homebrew"
else
    HOMEBREW_DIR="/usr/local"
fi

export PATH="$HOME/bin:$HOMEBREW_DIR/sbin:$HOMEBREW_DIR/bin:/usr/sbin:$PATH"
[[ -s "$HOMEBREW_DIR/bin/brew" ]] && eval "$($HOMEBREW_DIR/bin/brew shellenv)"
[[ -s "$HOMEBREW_DIR/opt/coreutils/libexec/gnubin" ]] && export PATH="$HOMEBREW_DIR/opt/coreutils/libexec/gnubin:$PATH"
[[ -s "$HOMEBREW_DIR/opt/curl/bin" ]] && export PATH="$HOMEBREW_DIR/opt/curl/bin:$PATH"

# Darwin and Linux specific settings
case ${OSTYPE} in
    darwin*) export LESSPIPE="$HOMEBREW_DIR/bin/lesspipe.sh" ;;
esac

# Check if inside a screen session
if [ -n "$STY" ]; then
    # Function to set window title
    set_window_title() {
        local TITLE=""
        if [[ -n "$1" ]]; then
            TITLE="$1"
        else
            TITLE="$(basename "$PWD")"
        fi
        if [[ ${#TITLE} -gt 25 ]]; then
            TITLE="${TITLE:0:22}..."
        fi
        echo -ne "\033k$TITLE\033\\"
    }

    # Update title when a command is executed
    preexec() {
        set_window_title "$1"
    }

    # Update title when returning to prompt (not executing a command)
    precmd() {
        set_window_title
    }
fi

# Aliases
alias ls='ls -hAF --color'
alias ll='ls -lshAF'
alias grep='grep --color'

# Completion colors
eval `dircolors`
export ZLS_COLORS=$LS_COLORS

# Less options
export LESS='-g -i -M -R -W -z-4 -x4'
export LESSOPEN="| $LESSPIPE %s"
export PAGER=less
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'

# Node Version Manager
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

# Volta
export VOLTA_HOME="$HOME/.volta"
[[ -s "$VOLTA_HOME/bin" ]] && export PATH="$VOLTA_HOME/bin:$PATH"

# Go
export GOPATH=$HOME
export GOROOT=$HOMEBREW_DIR/opt/go/libexec
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# https://github.com/golang/go/issues/61229
export GOFLAGS=-ldflags=-linkmode=internal

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [ -s "$PYENV_ROOT/bin" ]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Rbenv
export RBENV_ROOT="$HOME/.rbenv"
if [ -s "$RBENV_ROOT/bin" ]; then
    export PATH="$RBENV_ROOT/bin:$PATH"
    eval "$(rbenv init - zsh)"
fi

# Git prompt info function
function git_prompt_info {
    local ref st color

    ref=$(git symbolic-ref HEAD 2> /dev/null) || return

    st=$(git status 2> /dev/null)
    if [[ -n $(echo "$st" | grep "^nothing to") ]]; then
        color=${fg[green]}
    elif [[ -n $(echo "$st" | grep "^nothing added") ]]; then
        color=${fg[yellow]}
    elif [[ -n $(echo "$st" | grep "^# Untracked") ]]; then
        color=${fg_bold[red]}
    else
        color=${fg[red]}
    fi

    echo " on %{$color%}${ref#refs/heads/}%{$reset_color%}"
}

# Kubectl completion
source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

source "$HOMEBREW_DIR/opt/kube-ps1/share/kube-ps1.sh"
if type "kube_ps1" > /dev/null 2>&1; then
    PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info) $(kube_ps1)
%% '
else
    PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)
%% '
fi

# Peco functions
function find-files() {
    find . -type d -name '.git' -prune -o -type f
}

function find-cd() {
    local DIR=$(find-files | peco)
    [ -n "$DIR" ] && DIR=${DIR%/*} && echo "pushd \"$DIR\"" && pushd "$DIR"
}

function find-vim() {
    vim $(find-files | peco)
}

function peco-pkill() {
    for pid in $(ps aux | peco | awk '{ print $2 }'); do
        kill $pid
        echo "Killed ${pid}"
    done
}

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | eval $tac | peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    [ -n "$selected_dir" ] && BUFFER="cd ${selected_dir}" && zle accept-line
    zle clear-screen
}

function rg-peco() {
    rg "$@" | peco --query "$LBUFFER"
}

function rg-vim() {
    vim $(rg "$@" | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

# Peco key bindings
zle -N peco-select-history
bindkey '^r' peco-select-history
bindkey "\e[Z" reverse-menu-complete

zle -N peco-src
bindkey '^]' peco-src

# Aliases for functions
alias fv="find-vim"
alias fd="find-cd"
alias gp="rg-peco"
alias gv="rg-vim"
alias pk="peco-pkill"
alias vi="vim"
alias ga="gcloud auth login --update-adc"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Direnv
eval "$(direnv hook zsh)"

# Local zshrc
[ -f "$HOME/.zshrc.local" ] && source ~/.zshrc.local
