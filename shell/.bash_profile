#!/usr/bin/env bash

DIRCOLOR_COMMAND="dircolors"

export EDITOR=vim
export PAGER=less

if [[ "${OSTYPE}" =~ "darwin" ]]; then
    alias ls="gls --color=always"
    DIRCOLOR_COMMAND="gdircolors"
fi

eval "$(${DIRCOLOR_COMMAND} ~/.dir_colors)"

if command -v nvim > /dev/null 2>&1; then
    alias vim=nvim
    export EDITOR=nvim
fi

alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
