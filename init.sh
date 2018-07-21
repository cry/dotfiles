#!/bin/bash

# Source support functions
. support.sh

DOTFILES_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

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

# Disabled for now as I don't need italics; and it breaks SSH on systems without this change
## Install xterm-italics if on darwin; unsure if this is needed on non darwin
#
#tic term/xterm-256color-italic.terminfo
#
#if [[ $? == 0 ]]; then
#    info "Successfully installed italics!"
#
#    export TERM="xterm-256color-italic"
#
#    info "`tput sitm`This should be in italics!`tput ritm`"
#
#    # Verify that any bash profiles don't contain any TERM overrides
#    NEW_SHELL_TERM=$(unset TERM && bash -lc 'echo $TERM')
#
#    if [[ ! $NEW_SHELL_TERM =~ "xterm-256color-italic" ]]; then
#        warning "Your profile settings export TERM to be $NEW_SHELL_TERM, make sure you replace it with xterm-256color-italic!"
#    fi
#fi

# Touch .hushlogin to disable banners where applicable

info "Creating ~/.hushlogin"
touch ~/.hushlogin

# Initialise bashstrap stuff - I'm unsure if this shit actually works well in non Darwin but who knows

info "Copying across bashstrap base"
mkdir -p ~/.dotfiles/bash

success "Copying z.sh: $(cp -v bash/z.sh ~/.dotfiles/bash)"
success "Copying .bash_profile: $(cp -v bash/bash_profile ~/.bash_profile)"
success "Copying .bashrc: $(cp -v bash/bashrc ~/.bashrc)"

# Only overwrite if existing extras don't exist
[[ ! -f ~/.bash_extras ]] && cp -v bash/bash_extras ~/.bash_extras

info "Copying across dotfiles requirements"

if [[ ! -L ~/.dotfiles/self_update.sh ]]; then
    success "Symlinking ${DOTFILES_DIRECTORY}/self_update.sh -> ~/.dotfiles/self_update.sh"
    ln -s "${DOTFILES_DIRECTORY}/self_update.sh" ~/.dotfiles/self_update.sh
fi

##########
# Git 
##########

# Initialize git config

# Only bother initialiizing if git is actually installed
if [[ ! -z $(which git) ]]; then
    success "Copying .gitconfig: $(cp -v git/gitconfig ~/.gitconfig)"
    success "Copying .gitignore: $(cp -v git/gitignore ~/.gitignore)"

    [[ ! -f ~/.gitconfig_extras ]] && success "Copying .gitconfig_extras: $(cp -v git/gitconfig_extras ~/.gitconfig_extras)"

    warning "GPG autosigning is not enabled in this init.sh, you'll need to set that up like so:"
    warning "  git config --global user.signingkey <GPG_PUBKEY_ID>"
    warning "  git config --global commit.gpgsign true"
else
    warning "git is not installed, or not in path, skipping git config files"
fi

##########
# Vim 
##########

# Install vim stuff & populate vimrc

# Only bother initialiizing if git is actually installed
if [[ ! -z $(which git) ]]; then
    if [[ -z $(which vim)  ]]; then
        warning "Vim is not installed, skipping"
    else
        VIM_VER=$(vim --version | head -1)

        info "Detected vim, version header: ${VIM_VER}"

        mkdir -p ~/.vim/bundle

        info "Cloning vundle repo (will not clone if repo exists)"

        [[ ! -d ~/.vim/bundle/Vundle.vim ]] \
            && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
            || warning "Vundle is already cloned, not recloning.."  # Don't clone repo if folder exists

        if [[ $? != 0 ]]; then
            error "Failed to clone vundle repo! Exiting.."
            exit
        fi

        success  "Copying vimrc: $(cp -v vim/vimrc ~/.vimrc)"

        # Verify that we have Vim8
        if [[ ! $VIM_VER =~ "Vi IMproved 8." ]]; then
            error "Your Vim version does not meet the base requirement of 8+, theme version is being removed to avoid conflicts!"

            if [[ $(uname) == "Darwin" ]]; then
                sed -i '' -n '1,/" THEME START/p;/" THEME END/,$p' ~/.vimrc
            else
                sed -i -n '1,/" THEME START/p;/" THEME END/,$p' ~/.vimrc
            fi
        fi

        info "Performing Vim plugin install"

        if tty > /dev/null; then
            vim -c "PluginInstall" -c "q" -c "q"

            if [[ $? != 0 ]]; then
                error "Encountered a problem installing vim plugins, should probably investigate that."
                exit
            else
                info "Successfully updated vim plugins!"
            fi
        else
            error "No tty available, not opening Vim"
        fi
    fi
else
    warning "Git is not installed, skipping install of Vundle and vim stuff"
fi

# Only add tmux stuff if we have tmux installed

if which -s tmux; then
    cp tmux/.tmux.conf ~/.tmux.conf
fi

success "Finished init script! Enjoy your new bash"
