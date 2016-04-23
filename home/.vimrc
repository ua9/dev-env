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
"Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/yajs.vim', { 'for': 'javascript' }
Plugin 'facebook/vim-flow', { 'for': 'javascript' }
Plugin 'othree/es.next.syntax.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plugin 'Valloric/YouCompleteMe'
Plugin 'nathanaelkane/vim-indent-guides'
" shows nothing:
" Plugin 'bigfish/vim-js-context-coloring'

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

" show line numbers
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
set relativenumber

" cursor lines
set cursorline
" set cursorcolumn
set colorcolumn=120

" highlight search result
set hlsearch

" make cursorlines brighter in insert mode
" autocmd InsertEnter * hi CursorLine ctermbg=230 guibg=#ffffdf
" autocmd InsertLeave * hi CursorLine ctermbg=231 guibg=#ffffff

" powerline setup
if has('python')
  python from powerline.vim import setup as powerline_setup
  python powerline_setup()
  python del powerline_setup
endif
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
"nnoremap <esc> :noh<return><esc>
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

" On F8 disable autoindent and comments
nnoremap <F8> :setl formatoptions-=c formatoptions-=r formatoptions-=o noai nocin nosi inde=<CR>

