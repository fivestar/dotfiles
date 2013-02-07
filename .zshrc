autoload promptinit; promptinit

autoload -Uz colors; colors

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

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)
%% '

## completion colors
eval `dircolors`
export ZLS_COLORS=$LS_COLORS

# completion
autoload -Uz compinit; compinit -u
zstyle ':completion:*:default' menu select true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

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

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

alias ls='ls -hF --color'
alias ll='ls -l'
alias grep='grep --color'

export LESS='-R'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'
export PATH=$HOME/bin:/usr/local/sbin:/usr/local/bin:$PATH:/usr/sbin

[[ -s "/usr/local/opt/coreutils/libexec/gnubin" ]] && export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

bindkey "\e[Z" reverse-menu-complete
