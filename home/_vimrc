set hlsearch

" Key mapping for tabs.
nmap th :tabprev
nmap tl :tabnext
nmap tn :tabnew:FZF

" Checking/Install vim-plug for plugin management.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Begin a plugin session.
" Avoid using standard Vim directory names like 'plugin'.
call plug#begin('~/.vim/plugged')

" Plugin outside ~/.vim/plugged with post-update hook
" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'nvie/vim-flake8'

Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }

call plug#end()

" shiftwidth
set sw=2
" tabstop
set ts=2
set expandtab

" The char : should not be counted when search for a whole word.
set iskeyword-=:

set showcmd
