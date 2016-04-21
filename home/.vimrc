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
Plugin 'flowtype/vim-flow'
Plugin 'elzr/vim-json'
Plugin 'pangloss/vim-javascript'
Plugin 'junegunn/seoul256.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'evanmiller/nginx-vim-syntax'

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
  colorscheme stonewashed-gui
else
  colorscheme seoul256
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
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
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
