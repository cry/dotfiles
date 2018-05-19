#!/bin/bash

# Source support functions
. support.sh

##########
# Bash
##########

# Get current bash version
if [[ ! -z ${BASH_VERSION} ]]; then
    info "Running on Bash ${BASH_VERSION}"

    if [[ ! ${BASH_VERSION} =~ ^4. ]]; then
        warning "Your version of bash is kinda very old, consider upgrading."
        warning "Continue with old version of bash? [Yy|Nn]"

        read ans

        if [[ ${ans} == "${ans#[Yy]}" ]]; then
            error "Exiting on bash version check.."
            exit
        fi
    fi
else
    error "Only available on Bash shells!"
    exit
fi

# Install xterm-italics if on darwin; unsure if this is needed on non darwin

if [[ $(uname) == "Darwin" ]]; then
    tic term/xterm-256color-italic.terminfo
    
    if [[ $? == 0 ]]; then
        info "Successfully installed italics!"

        export TERM="xterm-256color-italic"

        info "`tput sitm`This should be in italics!`tput ritm`"

        # Verify that any bash profiles don't contain any TERM overrides
        NEW_SHELL_TERM=$(unset TERM && bash -lc 'echo $TERM')

        if [[ ! $NEW_SHELL_TERM =~ "xterm-256color-italic" ]]; then
            warning "Your profile settings export TERM to be $NEW_SHELL_TERM, make sure you replace it with xterm-256color-italic!"
        fi
    fi
else
    info "Not enabling italic fonts on non Darwin platform"
fi

# Touch .hushlogin to disable banners where applicable

info "Creating ~/.hushlogin"
touch ~/.hushlogin

# Initialise bashstrap stuff - I'm unsure if this shit actually works well in non Darwin but who knows

info "Copying across bashstrap base"
mkdir -p ~/.dotfiles/bash

cp -v bash/z.sh ~/.dotfiles/bash
cp -v bash/bash_profile ~/.bash_profile
cp -v bash/bashrc ~/.bashrc

# Only overwrite if existing extras don't exist
[[ ! -f ~/.bash_extras ]] && cp -v bash/bash_extras ~/.bash_extras

# Initialize git config

# Only bother initialiizing if git is actually installed
if [[ ! -z $(which git) ]]; then
    info "Copying across git files"
    cp -v git/gitconfig ~/.gitconfig
    cp -v git/gitignore ~/.gitignore

    [[ ! -f ~/.gitconfig_extras ]] && cp -v git/gitconfig_extras ~/.gitconfig_extras

    info "GPG autosigning is not enabled in this init.sh, you'll need to set that up like so:"
    info "  git config --global user.signingkey <GPG_PUBKEY_ID>"
    info "  git config --global commit.gpgsign true"
else
    warning "git is not installed, or not in path, skipping git config files"
fi

success "Finished init script! Enjoy your new bash"
