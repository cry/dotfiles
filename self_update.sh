#!/bin/bash

# Updates dotfiles when called
# NOTE: Should always be in the root directory of the dotfiles location

# FFS, why are BSD tools so potato
if [[ $(uname) == "Darwin" ]]; then
    DOTFILES_DIRECTORY=$(cd "$(dirname "$(readlink ${BASH_SOURCE[0]})")" && pwd)
else
    DOTFILES_DIRECTORY=$(cd "$(dirname "$(readlink -f ${BASH_SOURCE[0]})")" && pwd)
fi

cd ${DOTFILES_DIRECTORY}

. support.sh

info "Detected install directory ${DOTFILES_DIRECTORY}"

info "Updating repo with updates from remote"

git remote update

if [[ ! $? == 0 ]]; then
    error "Failed to update from remote! Exiting."
    exit
fi

# Ensure that the upstream is set correctly

info "Setting upstream to $(git rev-parse --abbrev-ref HEAD) (ensures we can check if updates are needed)"

git branch --set-upstream-to origin/$(git rev-parse --abbrev-ref HEAD) > /dev/null 2>&1 

if [[ ! $? == 0 ]]; then
    # We're probably dealing with an old git version

    git branch --set-upstream origin/$(git rev-parse --abbrev-ref HEAD) > /dev/null 2>&1

    warning "Trying to set upstream with alternate approach."

    if [[ ! $? == 0 ]]; then
        error "Failed to set upstream to $(git rev-parse --abbrev-ref HEAD), exiting."
        exit
    fi
fi

if [[ ! $(git status) =~ "Your branch is behind" ]]; then
    info "Already up to date with remote, exiting."
    exit
fi

info "Updates detected! Updating.."
git pull origin $(git rev-parse --abbrev-ref HEAD)

if [[ ! $? == 0 ]]; then
    error "Failed to merge in remote changes (what)"
    exit
fi

info "Reapplying init.sh"
bash init.sh

if [[ ! $? == 0 ]]; then
    error "Failed to apply new dotfile changes!"
    exit
fi
