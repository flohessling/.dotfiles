" set langmap=de
set path+=**

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*
set clipboard+=unnamedplus

syntax on
" colorscheme gruvbox

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set exrc
set guicursor=
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set nu
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
" set noshowmode
set signcolumn=yes
set colorcolumn=120

" Give more space for displaying messages.
set cmdheight=1

set updatetime=50

set shortmess+=c

call plug#begin('~/.vim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'edolphin-ydf/goimpl.nvim'
Plug 'gruvbox-community/gruvbox'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'golang/vscode-go'
Plug 'ThePrimeagen/vim-be-good'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'FooSoft/vim-argwrap'
Plug 'tpope/vim-commentary'
" Plug 'glepnir/lspsaga.nvim'
" Plug 'ray-x/lsp_signature.nvim'
call plug#end()

lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}

colorscheme gruvbox
highlight Normal guibg=none

let mapleader = " "
let loaded_matchparen = 1

" greatest remap ever
vnoremap <leader>p "_dP

" next greatest remap ever : asbjornHaland
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

nnoremap Y y$
nnoremap N Nzzzv
nnoremap n nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" inoremap <C-j> <esc>:m .+1<CR>==
" inoremap <C-k> <esc>:m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

nnoremap <leader>d "_d
vnoremap <leader>d "_d


nnoremap <leader>bs /<C-R>=escape(expand("<cWORD>"), "/")<CR><CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :Ex<CR>
nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>

" Go to the previous location
nnoremap [q :cprev<CR>

" Go to the next location
nnoremap ]q :cnext<CR>

" noremap <Up> <nop>
" noremap <Down> <nop>
" noremap <Left> <nop>
" noremap <Right> <nop>
"

let g:completion_enable_snippet = 'vsnip'
let g:airline_theme = 'base16_gruvbox_dark_hard'

autocmd BufReadPost *                                                       
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'     
        \ |   exe "normal! g`\""                                                  
        \ | endif   

function! Rooter() abort
	" https://vi.stackexchange.com/questions/20605/find-project-root-relative-to-the-active-buffer/20606
	let l:dir = finddir('.git/..', expand('%:p:h').';')
	echom 'cwd: ' . l:dir
	execute 'lcd ' . l:dir
endfunction

augroup rooter
	autocmd!
	autocmd BufRead * call Rooter()
augroup END

