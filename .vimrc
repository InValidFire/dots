"tmux color compatibility.	
if $TERM == 'tmux-256color'
	let &t_8f = "\033[38;2;%lu;%lu;%lum"
	let &t_8b = "\033[48;2;%lu;%lu;%lum"
endif

set background=dark
syntax enable

"automatically install plugin manager if needed

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

"splitting confiig
set splitbelow
set splitright

"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

let mapleader = ","

nnoremap <Leader>o o<Esc>0"_D
nnoremap <Leader>O O<Esc>0"_D

"formatting
set tabstop=2
set softtabstop=0 noexpandtab
set shiftwidth=4
set wrap linebreak

"folding config
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

"line numbers
set number

"NERDTree shortcuts
nnoremap <C-t> :NERDTreeToggle<CR>

"Language server junk
let g:lsc_server_commands = {'py': 'pyls', 'xsh': 'pyls'}

let g:lsc_auto_map = v:true

"plugins
call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'sheerun/vim-polyglot'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'davidhalter/jedi-vim'
Plug 'vim-scripts/indentpython.vim'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'PhilRunninger/nerdtree-visual-selection'
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
call plug#end()
