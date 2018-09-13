#!/bin/bash

### Prompt Colors
# Modified version of @gf3’s Sexy Bash Prompt
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM=gnome-256color
elif [[ ! -z "${TMUX}" ]]; then
    export TERM=screen-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

BASH_PROFILE=true source ~/.bashrc

### Self updater

bash ~/.dotfiles/self_update.sh > ~/.dotfiles/update.log 2>&1 &

# Ensure that the self update process isn't tied to this terminal

disown $!

### Aliases

# Color LS
[[ $(uname) == "Darwin" ]] \
    && colorflag="-G" \
    || colorflag="--color=yes"

if which gls > /dev/null 2>&1; then
    alias ls="command gls --color=yes"
else
    alias ls="command ls ${colorflag}"
fi
alias l="ls -lF ${colorflag}" # all files, in long format
alias la="ls -laF ${colorflag}" # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} | grep "^d"' # only directories

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Colored up cat!
# You must install Pygments first - "sudo easy_install Pygments"
alias c='pygmentize -O style=monokai -f console256 -g'

# Git
# You must install Git first
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias grm='git rm $(git ls-files --deleted)'

if tput setaf 1 &> /dev/null; then
	tput sgr0
	if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
		MAGENTA=$(tput setaf 9)
		ORANGE=$(tput setaf 172)
		GREEN=$(tput setaf 190)
		PURPLE=$(tput setaf 141)
	else
		MAGENTA=$(tput setaf 5)
		ORANGE=$(tput setaf 4)
		GREEN=$(tput setaf 2)
		PURPLE=$(tput setaf 1)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	MAGENTA="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
	BOLD=""
	RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export BOLD
export RESET

# Git branch details
function parse_git_dirty() {
	[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# Change this symbol to something sweet.
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="> "

export PS1="\[${MAGENTA}\]\u@\[$RESET\]\[$PURPLE\]\h \[$RESET\]in \[$GREEN\]\w\[$RESET\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$RESET\]\n$symbol\[$RESET\]"
export PS2="\[$ORANGE\]→ \[$RESET\]"


### Misc

# Only show the current directory's name in the tab
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# init z! (https://github.com/rupa/z)
. ~/.dotfiles/bash/z.sh

if which dircolors > /dev/null 2>&1; then
    eval $(dircolors ~/.dircolors.256dark)
fi

# Change tmux terminal name on ssh

if which tmux > /dev/null 2>&1; then
    # Make short hostname only if its not an IP address
    __tm_get_hostname(){
        local HOST="$(echo $* | rev | cut -d ' ' -f 1 | rev)"
        if echo $HOST | grep -P "^([0-9]+\.){3}[0-9]+" -q; then
            echo $HOST
        else
            echo $HOST| cut -d . -f 1
        fi
    }

    __tm_get_current_window(){
        tmux list-windows| awk -F : '/\(active\)$/{print $1}'
    }

    # Rename window according to __tm_get_hostname and then restore it after the command
    __tm_command() {
        if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=| cut -d : -f 1)" = "tmux" ]; then
            __tm_window=$(__tm_get_current_window)
            # Use current window to change back the setting. If not it will be applied to the active window
            trap "tmux set-window-option -t $__tm_window automatic-rename on 1>/dev/null" RETURN
            tmux rename-window "$(__tm_get_hostname $*)"
        fi
        command "$@"
    }

    ssh() {
        __tm_command ssh "$@"
    }
fi

# Enable ssh completion

complete -W "$(grep -oP 'Host\s\K[^*]+$' ~/.ssh/config)" ssh

# Disable empty completion
shopt -s no_empty_cmd_completion