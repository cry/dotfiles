#!/usr/bin/env bash

# Source any user settings, if applicable
if [[ -f ~/.local/dotfiles/.bash_profile ]]; then
    . ~/.local/dotfiles/.bash_profile
fi

DIRCOLOR_COMMAND="dircolors"
LS_COMMAND=ls

export EDITOR=vim
export PAGER=less

export PATH=~/go/bin:${PATH}
export PATH=~/.local/bin:${PATH}

if [[ "${OSTYPE}" =~ "darwin" ]]; then
    LS_COMMAND=gls
    DIRCOLOR_COMMAND="gdircolors"
fi

alias sudo='sudo '
alias ls="${LS_COMMAND} --color=always"

eval "$(${DIRCOLOR_COMMAND} ~/.dir_colors)"

if command -v nvim > /dev/null 2>&1; then
    alias vim=nvim
    export EDITOR=nvim
fi

alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

alias sl="ls"

function parse_git_dirty() {
	[[ $(git status 2> /dev/null | tail -n1) != *"working tree clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

PS1="┌─[\`if [ \$? = 0 ]; then echo \[\e[32m\]\$?\[\e[0m\]; else echo \[\e[31m\]\$?\[\e[0m\]; fi\`]───[\[\e[01;49;39m\]\u\[\e[00m\]\[\e[01;49;39m\]@\H\[\e[00m\]]───[\[\e[1;49;34m\]\w\[\e[0m\]]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \"───[\$(echo \$(parse_git_branch))]\")\n└───▶ "

# Stolen from https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
SSH_ENV="$HOME/.ssh/env"

function start_agent {(
    # Refuse to start a new agent if we're already in a ssh session
    [[ -n "${SSH_CLIENT}" ]] && return

    set -o pipefail
    echo -ne "[+] Initialising new SSH agent... "
    if /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"; then
        echo "success"

        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null

        /usr/bin/ssh-add;
    else
        echo "failed"
    fi
)}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# Initialize z.sh
. ~/.z.sh
