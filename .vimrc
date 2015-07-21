execute pathogen#infect()
syntax on
filetype plugin indent on
syntax enable

" base16 color
set background=dark
let base16colorspace=256
colorscheme base16-default
" enable ctrlp
set runtimepath^=~/.vim/bundle/ctrlp
" helps activete vim-airline
set laststatus=2
" make insert mode pop instantly
set ttimeoutlen=50
" vim-indent-guides
let g:indent_guides_start_level=1
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_auto_colors=0
let g:indent_guides_guide_size=1
hi IndentGuidesOdd   ctermbg=black
hi IndentGuidesEven  ctermbg=black
let g:js_indent_log = 0
