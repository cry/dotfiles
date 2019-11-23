#!/usr/bin/env bash

INIT_FLAG=~/.local/dotfiles/nvim_initialized 

# Initializes vim if not already done

if [[ ! -f ${INIT_FLAG} ]]; then
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    mkdir -p ~/.config/nvim

    touch ${INIT_FLAG} 
fi

cp -a init.vim ~/.config/nvim/init.vim
