set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'moll/vim-node'
Plugin 'adampasz/stonewashed-themes'
Plugin 'ekalinin/Dockerfile.vim'
Plugin 'elzr/vim-json'
Plugin 'pangloss/vim-javascript'
Plugin 'junegunn/seoul256.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'othree/yajs.vim', { 'for': 'javascript' }
Plugin 'facebook/vim-flow', { 'for': 'javascript' }
Plugin 'othree/es.next.syntax.vim'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'ternjs/tern_for_vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'bigfish/vim-js-context-coloring'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'kien/ctrlp.vim'
Plugin 'janko-m/vim-test'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'bling/vim-bufferline'
Plugin 'mbbill/undotree'
Plugin 'edkolev/promptline.vim'
Plugin 'edkolev/tmuxline.vim'

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

" load color scheme
if has("gui_running")
  silent! colorscheme stonewashed-gui
else
  silent! colorscheme seoul256
endif

" turn on syntax highlighting
syntax on

" cursor lines
set cursorline
" set cursorcolumn
set colorcolumn=120

" highlight search result
set hlsearch

" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

" Set tab policy
set tabstop=2
set shiftwidth=2
set expandtab

" associate .babelrs with json filetype
au BufRead,BufNewFile .babelrc setfiletype json
au BufRead,BufNewFile .bash_aliases setfiletype sh
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/*,nginx.conf setfiletype sh
au BufRead,BufNewFile *.docker set syntax=Dockerfile

" Disable removing quotes in json
let g:vim_json_syntax_conceal = 0

" Persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000
set hidden

" Allow indent color guides
au VimEnter * IndentGuidesToggle

" Clear search highlight
nnoremap <silent> <C-L> :noh<CR>

" Save buffer on Ctr-S
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>
inoremap <c-s> <c-o>:Update<CR>

" On F8 disable autoindent and comments
nnoremap <F8> :setl formatoptions-=c formatoptions-=r formatoptions-=o noai nocin nosi inde=<CR>

" Close flow windows if there is no errors
let g:flow#autoclose = 1

" Toggle JS Coloring
nnoremap <F9> :JSContextColorToggle<CR>
let g:js_context_colors_usemaps=0

" Line Numbers on F2
let g:NumberToggleTrigger="<F2>"
set relativenumber

" CtrlP config
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]((\.(git|hg|svn))|node_modules)$',
  \ 'file': '\v\.(exe|so|dll)$'
  \ }

" Allow per project settings
set exrc
set secure

" Configure Tests
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" show the 80 line limit
set colorcolumn=80

set showbreak=
set incsearch

" ignore case on search
set ignorecase

" Mini Buf Explorer
let g:miniBufExplStatusLineText=''
let g:miniBufExplVSplit=40
let g:miniBufExplBRSplit = 1
nnoremap <F10> :MBEToggleAll<CR>

" NerdTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
function! ToggleNERDTreeFind()
  if g:NERDTree.IsOpen()
    execute ':NERDTreeClose'
  else
    execute ':NERDTreeFind'
  endif
endfunction
map <F3> :call ToggleNERDTreeFind()<CR>
let NERDTreeQuitOnOpen=1

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'


" Undotree
nnoremap <F5> :UndotreeToggle<cr>
if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

" Tmuxline
let g:airline#extensions#tmuxline#enabled = 0

"
