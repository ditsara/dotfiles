set backspace=2         " backspace in insert mode works like normal editor
syntax on               " syntax highlighting
filetype on
filetype plugin on
filetype indent on      " activates indenting for files
set autoindent          " auto indenting
set number              " line numbers
set colorcolumn=80
colorscheme desert      " colorscheme desert
set nobackup            " get rid of annoying ~file

set ttyfast             " Send more characters for redraws
set mouse=a             " Enable mouse use in all modes

set tabstop=2           " 2-space tabs
set shiftwidth=2        " size of an indent
set expandtab           " always uses spaces instead of tab characters
let mapleader = "\<Space>"

noremap <Leader>s :set hlsearch! hlsearch?<CR>

set nocompatible              " be iMproved, required
filetype off                  " required

" enter command mode with semicolon
map ; :
noremap ;; ;

" close buffer with <Leader>+X
map <Leader>x :Bdelete<CR>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

Plugin 'ctrlpvim/ctrlp.vim'
" Treat spaces as underscores when searching
let g:ctrlp_abbrev = {
    \ 'gmode': 't',
    \ 'abbrevs': [
        \ {
        \ 'pattern': '\(^@.\+\|\\\@<!:.\+\)\@<! ',
        \ 'expanded': '_',
        \ 'mode': 'pfrz',
        \ },
        \ ]
    \ }

Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'slim-template/vim-slim.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary.git'
Plugin 'Raimondi/delimitMate'
Plugin 'skwp/greplace.vim'
Plugin 'moll/vim-bbye'

Plugin 'bronson/vim-trailing-whitespace'
map <Leader>w :FixWhitespace<CR>

Plugin 'kana/vim-arpeggio'
Plugin 'flazz/vim-colorschemes'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-scripts/vim-auto-save'
map <Leader>a :AutoSaveToggle<CR>

" JS and JSX
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

Plugin 'scrooloose/nerdtree.git'
map <C-T> :NERDTreeToggle<CR>

Plugin 'ap/vim-buftabline'
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-M> :bprev<CR>

" Snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Map simultaneous 'jk' to ESC in Insert mode
call arpeggio#map('iv', '', 0, 'jk', '<Esc>')
" set t_Co=256
" colorscheme solarized
