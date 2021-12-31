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

plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'
call plug#end()

" the glaive#Install() should go after the "call vundle#end()"
call glaive#Install()
" Optional: Enable codefmt's default mappings on the <Leader>= prefix.
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar /path/to/google-java-format-VERSION-all-deps.jar"

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END


" shiftwidth
set sw=2
" tabstop
set ts=2
set expandtab

" The char : should not be counted when search for a whole word.
set iskeyword-=:

set showcmd

