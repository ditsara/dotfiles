"=============================================================================
" init.vim --- Entry file for neovim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'

" kj exits insert mode
inoremap kj <Esc>
vnoremap kj <Esc>
tnoremap kj <C-\><C-n>

" Ctrl-J inserts newline
nnoremap <C-J> a<CR><Esc>

" alt-direction moves cursor between windows
noremap <m-l> :wincmd l<CR>
noremap <m-h> :wincmd h<CR>
noremap <m-j> :wincmd j<CR>
noremap <m-k> :wincmd k<CR>
" alt-m and alt-n switches buffers
noremap <m-m> :bnext<CR>
noremap <m-n> :bprev<CR>
" alt-[ and alt-] switches tab pages
noremap <m-u> :tabp<CR>
noremap <m-i> :tabn<CR>
" send current filename to clipboard
command! FileName let @+=@%
