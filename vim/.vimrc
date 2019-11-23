call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" Source system-specific .vimrc first.
if filereadable(expand('~/.local/dotfiles/.vimrc'))
    source ~/.local/dotfiles/.vimrc
endif

colorscheme nord
syntax on

set expandtab
set autoindent
set smartindent
set softtabstop=4
set tabstop=4
set shiftwidth=4
set showmatch
set ruler
set nohls
set number
set wrap
set linebreak
set mouse=a

"strip trailing whitespace from certain files
autocmd BufWritePre *.conf :%s/\s\+$//e
autocmd BufWritePre *.py :%s/\s\+$//e
autocmd BufWritePre *.css :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e

set timeoutlen=1000 ttimeoutlen=0

" Folds
set foldmethod=indent
set foldnestmax=2
nnoremap <space> za
vnoremap <space> zf
