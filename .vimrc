set background=dark
"colorscheme habamax
"colorscheme slate
set number relativenumber
nnoremap <esc><esc> :noh<return><esc>
nnoremap - :Ex<return>
nnoremap ]q :cnext<return>
nnoremap [q :cprev<return>
set mouse=a
set belloff=all
set noerrorbells
set novisualbell
set t_vb=

" Use system clipboard when provider support exists
if has('clipboard') || has('clipboard_provider')
  set clipboard=unnamed,unnamedplus
endif


"let g:netrw_banner=0        " disable annoying banner
"let g:netrw_browse_split=0  " open in prior window
"let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
"let g:netrw_list_hide=netrw_gitignore#Hide()
"let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'


set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
augroup vimrc_autoread
  autocmd!
  autocmd FocusGained,BufEnter * silent! checktime
augroup END

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "

" Fast saving
nnoremap <silent> <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!


" Set 8 lines to the cursor - when moving vertically using j/k
set so=8

" Turn on the Wild menu
set wildmenu
set wildmode=longest:full,full

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1
set splitbelow
set splitright

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase
set smartcase

set hlsearch
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

syntax enable

" Set regular expression engine automatically
set regexpengine=0


" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8


set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

set smarttab

set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=0

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Return to last edit position when opening files
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


set laststatus=2

" Use recursive grep with line numbers
set grepprg=grep\ -rIn

" Auto-open quickfix after grep
augroup vimrc_quickfix
  autocmd!
  autocmd QuickFixCmdPost grep copen
augroup END

" Make :grep silent by default
cnoreabbrev <expr> grep
  \ (getcmdtype() == ':' && getcmdline() ==# 'grep')
  \ ? 'silent grep'
  \ : 'grep'
