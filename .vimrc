execute pathogen#infect()
syntax on
filetype plugin indent on
syntax enable
set background=dark
let base16colorspace=256
colorscheme base16-default
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
set runtimepath^=~/.vim/bundle/ctrlp
set laststatus=2
set ttimeoutlen=50
