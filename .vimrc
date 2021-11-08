"automatically install plugin manager if needed

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if exists('$TMUX')
	" Colors in tmux
	let &t_8f = "\033[38;2;%lu;%lu;%lum"
	let &t_8b = "\033[48;2;%lu;%lu;%lum"
endif

packadd! dracula
set termguicolors
set background=dark
syntax enable
colorscheme dracula

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
	\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
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

Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plug 'chiel92/vim-autoformat'
Plug 'natebosch/vim-lsc'
Plug 'https://tildegit.org/sloum/gemini-vim-syntax'
Plug 'dracula/vim', { 'as': 'dracula'}

call plug#end()
