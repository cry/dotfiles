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

function parse_git_dirty() {
	[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

PS1="┌─[\`if [ \$? = 0 ]; then echo \[\e[32m\]\$?\[\e[0m\]; else echo \[\e[31m\]\$?\[\e[0m\]; fi\`]───[\[\e[01;49;39m\]\u\[\e[00m\]\[\e[01;49;39m\]@\H\[\e[00m\]]───[\[\e[1;49;34m\]\w\[\e[0m\]]\$([[ -n \$(git branch 2> /dev/null) ]] && echo "───\[`parse_git_branch`\]")\n└───▶ "
