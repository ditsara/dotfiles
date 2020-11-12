" GENERAL
set backspace=2         " backspace in insert mode works like normal editor
syntax on               " syntax highlighting

set autoindent          " auto indenting
set number              " line numbers
set colorcolumn=80      " highlight 80th character
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use
set nobackup            " get rid of annoying ~file
set ttyfast             " Send more characters for redraws
set tabstop=2           " 2-space tabs
set shiftwidth=2        " size of an indent
set expandtab           " always uses spaces instead of tab characters
set mouse=a             " Enable mouse use in all modes
set path+=**
set wildmenu
set shell=/bin/bash

" turn hybrid line numbers on
set number relativenumber
set nu rnu

" turn hybrid line numbers off
" :set nonumber norelativenumber
" :set nonu nornu

" function LineNumberToggle()
"   set number! relativenumber!
"   set nu! rnu!
" endfunction

" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END

" KEYBINDINGS

let mapleader = "\<Space>" " use Space as leader key
" toggle search highlighting
noremap <Leader>s :set hlsearch! hlsearch?<CR>
" split pane vertically / horizontally
noremap <Leader>wv :vsp<CR>
noremap <Leader>wh :sp<CR>

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
" ctrl-w closes buffer w/o losing split
noremap <C-w> :bp\|bd #<CR>
" kj exits insert mode
inoremap kj <Esc>
vnoremap kj <Esc>
tnoremap kj <C-\><C-n>
" Ctrl-J inserts newline
nnoremap <C-J> a<CR><Esc>
" search for visual selection with //
vnoremap // y/<C-R>"<CR>
vnoremap /* y:FuzzyGrep <C-R>"

nnoremap <Leader>p :find<space>
command! FileName let @+=@%

" enter command mode with semicolon
map ; :
noremap ;; ;

" use system clipboard
set clipboard+=unnamedplus

" regenerate tags function and shortcut
" nnoremap <C-[> :tselect<CR>
" nnoremap <M-]> :tnext<CR>
" nnoremap <M-[> :tprev<CR>
" set notagrelative

" create a scratch buffer
function! Scratch()
    split
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file __scratch__
endfunction
command! Scratch call Scratch()<CR>


" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/buffet.vim'
noremap <Leader>l :Bufferlist<CR>

Plug 'cloudhead/neovim-fuzzy'
nnoremap <C-p> :FuzzyOpen<CR>

Plug 'tpope/vim-rails'
Plug 'tpope/vim-fugitive'
Plug 'vim-ruby/vim-ruby'
Plug 'ngmy/vim-rubocop'
Plug 'jgdavey/vim-blockle'
Plug 'scrooloose/syntastic'
Plug 'slim-template/vim-slim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'
Plug 'skwp/greplace.vim'
Plug 'moll/vim-bbye'

Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

Plug 'bronson/vim-trailing-whitespace'
noremap <Leader>w :FixWhitespace<CR>

Plug 'flazz/vim-colorschemes'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'

Plug 'vim-scripts/vim-auto-save'
map <Leader>a :AutoSaveToggle<CR>

Plug 'Yggdroot/indentLine'
let g:indentLine_enabled = 0
map <Leader>i :IndentLinesToggle<CR>

" JS and JSX
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'ianks/vim-tsx'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }

Plug 'scrooloose/nerdtree'
silent! map <f3> :NERDTreeToggle<CR>
map <Leader><f3> :NERDTreeFind<CR>

" Toggle quickfix and location lists
Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<Leader>9'
let g:lt_quickfix_list_toggle_map = '<Leader>0'

" HTML editing
" - insert a CSS-like expresson + <C-y>,
Plug 'mattn/emmet-vim'

Plug 'ap/vim-buftabline'
set hidden

" Snippets
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

" Tags
Plug 'majutsushi/tagbar'
let g:tagbar_left = 1

Plug 'neoclide/coc.nvim', {'branch': 'release'}
au BufNewFile,BufRead *.ts setlocal filetype=typescript
au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx

" set signcolumn=yes
" autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
" autocmd FileType ruby setlocal omnifunc=LanguageClient#complete
" let g:LanguageClient_autoStop = 0
" let g:LanguageClient_loggingFile = '~/.languageclient.log'

" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" nnoremap <Leader><F5> :pclose<CR>

" nginx config file syntax highlighting
Plug 'chr4/nginx.vim'

" Initialize plugin system
call plug#end()

" PACKAGE CONFIG

" =============== COC
inoremap <silent><expr> <c-space> coc#refresh()
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" =============== /COC

" Disable unicode arrows for ChromeOS compatibility
let g:NERDTreeDirArrowExpandable = '>'
let g:NERDTreeDirArrowCollapsible = '<'
let g:NERDTreeWinPos = "right"

" Use git for faster indexing of Ctrl-P
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard']
" let g:tagbar_ctags_bin = 'uctags'
silent! map <f2> :TagbarToggle<CR>
map <Leader><f2> :TagbarOpenAutoClose<CR>

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
" colorscheme ubaryd
colorscheme up

" These colorschemes might work with some adjustments to background
" colorscheme bluez
" colorscheme borland
" colorscheme brogrammer
" colorscheme maroloccio
