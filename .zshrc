autoload promptinit; promptinit

autoload -Uz colors; colors

fpath+=~/.zfunc

# completion
autoload -Uz bashcompinit && bashcompinit
autoload -Uz compinit; compinit

zstyle ':completion:*:default' menu select true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:sudo:*' command-path /opt/homebrew/sbin /opt/homebrew/bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

autoload -Uz zmv
alias zmv='noglob zmv -W'

setopt append_history
setopt auto_list
setopt auto_menu
setopt auto_resume
setopt NO_beep
setopt brace_ccl
setopt correct
setopt NO_flow_control
setopt NO_hup
setopt ignore_eof
setopt list_types
setopt long_list_jobs
setopt mark_dirs
setopt numeric_glob_sort
setopt print_eightbit
setopt prompt_subst
setopt hist_no_store

HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space

TZ='Asia/Tokyo'; export TZ
export LANG=en_US.UTF-8

if [ -s "/opt/homebrew/bin/brew" ]; then
    HOMEBREW_DIR="/opt/homebrew"
else
    HOMEBREW_DIR="/usr/local"
fi

if [ `uname` = 'Linux' ] && [ `lsb_release -si` = 'Debian' ]; then
    alias sudo='PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/sbin:$PATH sudo -E '
fi

case ${OSTYPE} in
    darwin*)
        alias ls='gls'
        alias dircolors='gdircolors'
        export LESSPIPE="$HOMEBREW_DIR/bin/src-hilite-lesspipe.sh"
        ;;
    linux*)
        export LESSPIPE="/usr/share/source-highlight/src-hilite-lesspipe.sh"
        ;;
esac

alias ls='ls -hAF --color'
alias ll='ls -lshAF'
alias grep='grep --color'

## completion colors
eval `dircolors`
export ZLS_COLORS=$LS_COLORS

export LESS='-g -i -M -R -W -z-4 -x4'
export LESSOPEN="| $LESSPIPE %s"
export PAGER=less
export PATH=$HOME/bin:$HOMEBREW_DIR/sbin:$HOMEBREW_DIR/bin:$PATH:/usr/sbin
export WORDCHARS='*?_.[]~-=&;!#$%^(){}<>'

[[ -s "$HOMEBREW_DIR/bin/brew" ]] && eval "$($HOMEBREW_DIR/bin/brew shellenv)"
[[ -s "$HOMEBREW_DIR/opt/coreutils/libexec/gnubin" ]] && export PATH="$HOMEBREW_DIR/opt/coreutils/libexec/gnubin:$PATH"
[[ -s "$HOMEBREW_DIR/opt/curl/bin" ]] && export PATH="$HOMEBREW_DIR/opt/curl/bin:$PATH"

[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

export VOLTA_HOME="$HOME/.volta"
[[ -s "$VOLTA_HOME/bin" ]] && export PATH="$VOLTA_HOME/bin:$PATH"

export GOPATH=$HOME
export GOROOT=$HOMEBREW_DIR/opt/go/libexec
export PATH=$PATH:$GOPATH/bin:$GOROOT/bin

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
eval "$(rbenv init - zsh)"

function git_prompt_info {
    local ref st color

    ref=$(git symbolic-ref HEAD 2> /dev/null) || return

    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
        color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
        color=${fg_bold[red]}
    else
        color=${fg[red]}
    fi

    echo " on %{$color%}${ref#refs/heads/}%{$reset_color%}"
}

source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

source "$HOMEBREW_DIR/opt/kube-ps1/share/kube-ps1.sh"

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info) $(kube_ps1)
%% '

function find-files () {
    find . -type d -name '.git' -prune -o -type f
}

function find-cd () {
    local DIR=$(find-files | peco)

    if [ -n "$DIR" ] ; then
        DIR=${DIR%/*}
        echo "pushd \"$DIR\""
        pushd "$DIR"
    fi
}

function find-vim () {
    vim $(find-files | peco)
}

function peco-pkill() {
    for pid in `ps aux | peco | awk '{ print $2 }'`
    do
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
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

function peco-src () {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

function rg-peco () {
    rg $@ | peco --query "$LBUFFER"
}

function rg-vim () {
    vim $(rg $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}

zle -N peco-select-history
bindkey '^r' peco-select-history
bindkey "\e[Z" reverse-menu-complete

zle -N peco-src
bindkey '^]' peco-src

alias fv="find-vim"
alias fd="find-cd"
alias gp="rg-peco"
alias gv="rg-vim"
alias pk="peco-pkill"
alias vi="vim"

alias ga="gcloud auth login --update-adc"

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

eval "$(direnv hook zsh)"

[ -f "$HOME/.zshrc.local" ] && source ~/.zshrc.local
