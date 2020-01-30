" This is the vim initialzer file from R.Mertens.
" It is my first time creating it from scratch. Please take it easy on me ;)



" ------- Plugin installer(Vim Plug) -------

call plug#begin('~/.config/plugged')

" language servers etc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

" adds language specific styling errors
  Plug 'dense-analysis/ale'

" control p fuzzy finder
  Plug 'ctrlpvim/ctrlp.vim'

" statusline/tabline plugin, dependent on the onedark.vim theme
  Plug 'itchyny/lightline.vim'

  "Plug 'Yggdroot/indentLine'
  Plug 'thaerkh/vim-indentguides'

" shortcuts to toggle/add comments
  Plug 'scrooloose/nerdcommenter'

" file system explorer
  Plug 'scrooloose/nerdtree'
  " Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" adds git functionality to nerdtree
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }

 "the current color theme
  Plug 'joshdick/onedark.vim'

" adds a way to togglebetween one liners and multi line if statements
  Plug 'AndrewRadev/splitjoin.vim'

" adds sidepanel that shows what is in the register"
  Plug 'junegunn/vim-peekaboo'

" adds git functionality to vim
  Plug 'tpope/vim-fugitive'
  Plug 'mhinz/vim-signify'

" adds the option to have multiple cursors, like in subltext
  Plug 'terryma/vim-multiple-cursors'

" vim plugin for editing rails, example: :A for switching to and from spec file
  Plug 'tpope/vim-rails'

" adds the fast fuzzy finder, use with :Rg searchterm
  Plug 'jremmen/vim-ripgrep'

call plug#end()



" ------- Basic settings -------

" enable syntax highlighting
syntax on

" enable mouse
set mouse=a

" Mapping leader to space
map <SPACE> <leader>

" space h to dismiss search result highlighting until next search or press of 'n'
nmap <silent> <leader>h :noh<CR>

" space comma for running the spec if in specfile
map <Leader>, :wa\|:!rspec %<CR>

" Turn on line numbers with a hybrid of relative and absolute numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Change number of spaces that a <Tab> counts for during editing ops
 "set softtabstop=2
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab

" Highlight trailing whitespace
highlight RedundantSpaces term=standout ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/ "\ze sets end of match so only spaces highlighted

" Show matching brackets
set showmatch

" ways to copy the filepath
nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>



" ------- Ruby on Rails settings -------

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



" ------- Vim theme settings -------

" lightline statusline plugin
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

"change the gui hex value to change the background color
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#142222", "cterm": "145", "cterm16" : "7"}
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "bg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END
endif

"Load the color scheme as the last line when it comes to style
colorscheme onedark



" ------- NerdTree -------

" keybindings settings
map <silent> <Leader>f :NERDTreeFind<CR>
nmap <silent> <Leader>m :NERDTreeToggle<CR>

" close nerdtree when it is the last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



" ------- NerdCommenter -------
let NERDSpaceDelims=1


" ------- CtrlP -------
"
" optimizing the runspeed
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


" ------- Running language servers with COC -------

" the global language servers
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-rls',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ 'coc-tsserver',
  \ 'coc-css',
  \ 'coc-html',
  \ 'coc-ember',
  \ 'coc-git',
  \ 'coc-svg',
  \ 'coc-xml',
  \ 'coc-yaml'
  \ ]

" CocInstall coc-snippets coc-solargraph coc-rls coc-eslint coc-prettier coc-json coc-tsserver coc-css coc-html coc-ember coc-git coc-svg coc-xml coc-yaml


" install snippets :CocInstall coc-snippetname
" edit snippets :CocCommand snippets.editSnippets

" if hidden is not set, TextEdit might fail.
set hidden

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap for rename current word
nmap <silent> gc <Plug>(coc-rename)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" complete"
inoremap <silent><expr> <c-space> coc#refresh()

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" setting the error line icons"
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign guifg=red guibg=none ctermbg=none ctermfg=red
highlight ALEWarningSign guifg=yellow ctermbg=none ctermfg=yellow



