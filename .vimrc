" GENERAL

set backspace=2         " backspace in insert mode works like normal editor
syntax on               " syntax highlighting
" au BufReadPost *.es6 set syntax=jsx
au BufNewFile,BufRead,BufReadPost *.es6 setf javascript
filetype on
filetype plugin on
filetype indent on      " activates indenting for files
set autoindent          " auto indenting
set number              " line numbers
set colorcolumn=80      " highlight 80th character
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
set nobackup            " get rid of annoying ~file
set ttyfast             " Send more characters for redraws
set mouse=a             " Enable mouse use in all modes

set tabstop=2           " 2-space tabs
set shiftwidth=2        " size of an indent
set expandtab           " always uses spaces instead of tab characters
set path+=**
set wildmenu


" KEYBINDINGS

let mapleader = "\<Space>" " use Space as leader key
" toggle search highlighting
noremap <Leader>s :set hlsearch! hlsearch?<CR>
" split pane vertically / horizontally
noremap <Leader>wv :vsp<CR>
noremap <Leader>wh :sp<CR>

" alt-direction moves cursor between windows
set <m-l>=l
set <m-h>=h
set <m-j>=j
set <m-k>=k
noremap <m-l> :wincmd l<CR>
noremap <m-h> :wincmd h<CR>
noremap <m-j> :wincmd j<CR>
noremap <m-k> :wincmd k<CR>
" alt-m and alt-n switches buffers
set <m-m>=m
set <m-n>=n
noremap <m-m> :bnext<CR>
noremap <m-n> :bprev<CR>
" alt-[ and alt-] switches tab pages
set <m-u>=u
set <m-i>=i
noremap <m-u> :tabp<CR>
noremap <m-i> :tabn<CR>
" kj exits insert mode
inoremap kj <Esc>
vnoremap kj <Esc>

" toggle current pane
noremap <Leader>ww :wincmd w<CR>
" Ctrl-J inserts newline
nnoremap <C-J> a<CR><Esc>

" search for visual selection with //
vnoremap // y/<C-R>"<CR>
vnoremap /* y:grep -rIn '<C-R>"'

nnoremap <Leader>] :!ctags -R .<CR>
nnoremap <Leader>p :find<space>
command! Debug norm! Obinding.pry<Esc>
command! FileName let @+=@%

set clipboard=unnamedplus
" No longer using this (use vim-gtk to get system clipboard option).
" Just keeping it around for future reference
"
" <Leader>+c copies to system clipboard in visual mode
" OS detection here maps it either to xsel (Linux) or pbcopy (Mac)
" let g:os = substitute(system('uname'), '\n', '', '')
" if g:os == "Linux"
"   vmap <Leader>c :w !xsel -ib<CR><CR>
"   map <Leader>v :read !xsel -ob<CR>
" elseif g:os == "Darwin"
"   vmap <Leader>c :w !pbcopy<CR><CR>
"   map <Leader>v :read !pbpaste<CR>
" endif

set nocompatible              " be iMproved, required
filetype off                  " required

" enter command mode with semicolon
map ; :
noremap ;; ;

" close buffer with <Leader>+q
map <Leader>q :Bdelete<CR>


" PACKAGES W VUNDLE

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

Plugin 'buffet.vim'
noremap <Leader>l :Bufferlist<CR>

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
Plugin 'ngmy/vim-rubocop'
Plugin 'jgdavey/vim-blockle'
Plugin 'scrooloose/syntastic'

Plugin 'slim-template/vim-slim.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary.git'
Plugin 'Raimondi/delimitMate'
Plugin 'skwp/greplace.vim'
Plugin 'moll/vim-bbye'

Plugin 'bronson/vim-trailing-whitespace'
noremap <Leader>w :FixWhitespace<CR>

Plugin 'flazz/vim-colorschemes'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-colorscheme-switcher'

Plugin 'vim-scripts/vim-auto-save'
map <Leader>a :AutoSaveToggle<CR>

Plugin 'Yggdroot/indentLine'
let g:indentLine_enabled = 0
map <Leader>i :IndentLinesToggle<CR>

" JS and JSX
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

Plugin 'scrooloose/nerdtree.git'
map <Leader>t :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>

" Toggle quickfix and location lists
Plugin 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<Leader>9'
let g:lt_quickfix_list_toggle_map = '<Leader>0'


Plugin 'ap/vim-buftabline'
set hidden

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


" PACKAGE CONFIG

" Disable unicode arrows for ChromeOS compatibility
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '<'

" Use git for faster indexing of Ctrl-P
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard']

" Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

noremap <Leader>c :SyntasticCheck<CR>
let g:syntastic_mode_map = { "mode": "passive" }
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_loc_list_height = 5
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_error_symbol = 'E'
let g:syntastic_style_error_symbol = 'e'
let g:syntastic_warning_symbol = 'W'
let g:syntastic_style_warning_symbol = 'w'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn


" COLORS
" (NOTE: this section needs to come after vim-colorschemes is loaded)

" These colorschemes seem to work well without any other adjustments
" colorscheme anderson
" colorscheme blacklight
" colorscheme blink
" colorscheme candyman
" colorscheme cobalt2
" colorscheme gryffin
" colorscheme synic
" colorscheme gotham256
" colorscheme termschool
" colorscheme umber-green
colorscheme ubaryd

" These colorschemes might work with some adjustments to background
" colorscheme bluez
" colorscheme borland
" colorscheme brogrammer
" colorscheme maroloccio

set t_Co=256
" clear t_ut so vim bg color doesn't conflict with term bg (tmux)
" set t_ut=
" set background=dark
" highlight Normal ctermbg=NONE
" highlight nonText ctermbg=NONE
