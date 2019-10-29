" This is the vim initialzer file from R.Mertens.
" It is my first time creating it from scratch. Please take it easy on me ;)

" plugin installer
call plug#begin('~/.config/plugged')

" control p fuzzy finder
  Plug 'ctrlpvim/ctrlp.vim'

" auto completion framework
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" statusline/tabline plugin, dependent on the onedark.vim theme
  Plug 'itchyny/lightline.vim'

" file system explorer
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" shortcuts to toggle/add comments
  Plug 'scrooloose/nerdcommenter'

" adds git functionality to nerdtree
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

" the current color theme
  Plug 'joshdick/onedark.vim'

" adds a way to togglebetween one liners and multi line if statements
  Plug 'AndrewRadev/splitjoin.vim'

" adds git functionality to vim
  Plug 'tpope/vim-fugitive'
  Plug 'mhinz/vim-signify'

" visualises the indentation
  Plug 'nathanaelkane/vim-indent-guides'

" adds the option to have multiple cursors, like in subltext
  Plug 'terryma/vim-multiple-cursors'

" adds language packs to vim, example: .rb, .scss, .js, .erb
  Plug 'sheerun/vim-polyglot'

" adds language specific styling errors
  Plug 'dense-analysis/ale'

" vim plugin for editing rails, example: :A for swithing to and from spec file
  Plug 'tpope/vim-rails'

" adds the fast fuzzy finder, use with :Rg searchterm
  Plug 'jremmen/vim-ripgrep'

" add vim solargraph ruby language protocol, in the terminal run the following command for linking with the server: solargraph socket
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

call plug#end()


" enable mouse
set mouse=a

" Mapping leader to space
map <SPACE> <leader>

" Turn on line numbers with a hybrid of relative and absolute numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Change number of spaces that a <Tab> counts for during editing ops
" set softtabstop=2
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

" Highlight trailing whitespace
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted

" === Bracket settings === "
" Show matching brackets
set showmatch

" treat scss files as css
au BufRead,BufNewFile *.scss set filetype=css

" true colors on 
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" have indentation styling enabled on startup
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#262626  ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3B4048   ctermbg=4

let g:onedark_terminal_italics = 1
let g:onedark_hide_endofbuffer = 1
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'relativepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" remove standard mode message (because we use lightline now)
set noshowmode

syntax on

"Load the color scheme as the last line when it comes to style
colorscheme onedark

" === navigation ===
" using tab to autocomplete :e
set wildmode=longest,list,full
set wildmenu

" space h to dismiss search result highlighting until next search or press of 'n'
nmap <silent> <leader>h :noh<CR>

" nerdtree settings
map <silent> <Leader>f :NERDTreeFind<CR>
nmap <silent> <Leader>m :NERDTreeToggle<CR>
" open nerdtree by default when starting vim
function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction
autocmd VimEnter * call StartUp()

" close nerdtree when it is the last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"CtrlP
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 40
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = '\v[\/](\.git|bower_components|log|node_modules|tmp|vendor)$'
set runtimepath^=~/.vim/bundle/ctrlp.vim
map <leader>t :CtrlP<cr>
map <leader>g :CtrlPModified<cr>
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" space comma for running the spec if in specfile
map <Leader>, :wa\|:!rspec %<CR>


" turning on autocmoplete on startup
let g:deoplete#enable_at_startup = 1
" map autocomplete to tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" setting up language server for ruby

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = { 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'] }
let g:LanguageClient_autoStop = 0

let g:ale_fix_on_save = 1
let b:ale_fixers = ['rubocop']

call deoplete#custom#option('sources', {
\ '_': ['ale', 'solargraph'],
\})

" Configure ruby omni-completion to use the language client:
autocmd FileType ruby setlocal omnifunc=LanguageClient#complete

" show errors in the statusline 
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

set statusline=%{LinterStatus()}

