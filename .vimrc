" vim-plug configuration
set nocompatible	
let mapleader=";"
"let g:is_posix = 1

filetype plugin on

" Install vim-plug with: https://github.com/junegunn/vim-plug
call plug#begin()

" All plugins
Plug 'altercation/vim-colors-solarized'
Plug 'kchmck/vim-coffee-script'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'derekwyatt/vim-fswitch'
Plug 'vim-airline/vim-airline'
Plug 'mustache/vim-mustache-handlebars'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'flazz/vim-colorschemes'
Plug 'terryma/vim-multiple-cursors'
Plug 'leafgarland/typescript-vim'
Plug 'hashivim/vim-terraform'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

filetype plugin indent on

" Set the tree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set backspace=2		" more powerful backspacing

" hate beeps!
set noerrorbells	" No beeps!
set novisualbell
set t_vb=
set tm=500
set ignorecase  " search regardless search.

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

set completeopt=preview,menu 

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

syntax on
syntax enable
set encoding=utf8	" Set default encoding to UTF-8

set incsearch		" Shows the match while typing
set hlsearch		" Highlight found searches
set laststatus=2

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
set background=dark
"let base16colorspace=256
"let g:solarized_termcolors=256
"colorscheme Solarized
colorscheme darkblack
"colorscheme Monokai 
"colorscheme hacked_ayu
set t_Co=256

"set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*

" config of fzf.vim
" Initialize configuration dictionary
let g:fzf_vim = {}
"let g:fzf_vim['ag'] = 'ag --nocolor --nogroup --ignore-case'
command! -nargs=* Ag call fzf#vim#grep('ag --nocolor --nogroup --column '.shellescape(<q-args>), 1, {'dir': getcwd()})
" This is the default option:
"   - Preview window on the right with 50% width
"   - CTRL-/ will toggle preview window.
" - Note that this array is passed as arguments to fzf#vim#with_preview function.
" - To learn more about preview window options, see `--preview-window` section of `man fzf`.
let g:fzf_vim.preview_window = ['right,50%', 'ctrl-/']
nnoremap <C-p> :Files<CR>
nnoremap <C-S-p> :GFiles<CR>

set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
"set ts=2 sw=2 et

let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup nobackup

" always have clipboard work with yy to copy lines
set clipboard=unnamed

" By default, JSX syntax highlighting and indenting will be enabled only for
" files with the .jsx extension. If you would like JSX in .js files, add
let g:jsx_ext_required = 0

set number            " show line numbers
set norelativenumber  " show numbers relative to current line

noremap <F2> :set invnumber<CR>
inoremap <F2> <C-O>:set invnumber<CR>

vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" set for vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1
let g:terraform_binary_path='tofu'

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif
