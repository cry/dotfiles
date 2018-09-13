#!/bin/bash

# If a global bashrc exists, source that first
# Usually exists on CentOS systems, etc

[[ -f /etc/bashrc ]] && source /etc/bashrc

if [[ -n "${PS1}" ]]; then
    [[ -z ${BASH_PROFILE} ]] && . ~/.bash_profile || :
    source ~/.bash_extras
    [[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion || :
    [[ -f /usr/local/etc/bash_completion ]] && . /usr/local/etc/bash_completion || :
fi