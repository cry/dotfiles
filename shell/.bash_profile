#!/usr/bin/env bash

DIRCOLOR_COMMAND="dircolors"

if [[ "${OSTYPE}" =~ "darwin" ]]; then
    alias ls="gls --color=always"
    DIRCOLOR_COMMAND="gdircolors"
fi

alias vim=nvim

alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"

export EDITOR=$(which nvim)
export PAGER=$(which less)

eval "$(${DIRCOLOR_COMMAND} ~/.dir_colors)"
