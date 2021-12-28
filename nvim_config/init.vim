set hlsearch

" Key mapping for tabs.
nmap th :tabprev
nmap tl :tabnext
nmap tn :tabnew:FZF

let xdg_data_dir = "~/.local/share"

" Begin a plugin session.
" Avoid using standard Vim directory names like 'plugin'.
call plug#begin(xdg_data_dir . '/nvim/site/plugged')

" Plugin outside ~/.vim/plugged with post-update hook
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'nvie/vim-flake8'

Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }

call plug#end()

command! -range=% YAPF <line1>,<line2>call yapf#YAPF()

" shiftwidth
set sw=2
" tabstop
set ts=2
set expandtab

" The char : should not be counted when search for a whole word.
set iskeyword-=:

set showcmd

