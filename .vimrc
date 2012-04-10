set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'vundle'

Bundle 'Align'
Bundle 'sudo.vim'
Bundle 'desert256.vim'
Bundle 'molokai'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ZenCoding.vim'
"Bundle 'hallison/vim-markdown'
Bundle 'groenewege/vim-less'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-scripts/php.vim--Garvin'
Bundle 'nginx.vim'
Bundle 'othree/html5.vim'

if $SUDO_USER == ''
    Bundle 'Shougo/neocomplcache'
    Bundle 'Shougo/neocomplcache-snippets-complete'
    Bundle 'Shougo/vimproc'
    Bundle 'Shougo/vimfiler'
    Bundle 'Shougo/unite.vim'
    Bundle 'h1mesuke/unite-outline'
endif

"filetype plugin on
syntax on

set backspace=2
set autoindent
set nosmartindent
set nocindent
set nobackup
set backupdir=~/tmp
set history=3284
set incsearch
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set shortmess+=I
set list
set listchars=tab:>-,extends:>,precedes:<,trail:-
set number
set showcmd
set showmatch
set showmode
set ruler
set whichwrap=b,s,h,l,<,>,[,]
set ignorecase
set smartcase
set wrapscan
set hlsearch
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ft.']['.&ff.']'}%=%l,%c%V%8P
set hidden
set autoread
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set formatoptions+=rm
set noswapfile

set foldmethod=marker

nnoremap j gj
onoremap j gj
xnoremap j gj
nnoremap k gk
onoremap k gk
xnoremap k gk

map <C-L>  <C-W>W
map <C-H>  <C-W>w

highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

set fileformats=unix,dos,mac                     " trying EOL formats
set termencoding=utf-8                           " Encoding used for the terminal.
set encoding=utf-8                               " character encoding used inside Vim.
set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp " list of character encodings considered when starting to edit an existing file.

set ambiwidth=double " Use twice the width of ASCII characters.

"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin ファイルを開くと発動します）
augroup BinaryXXD
  autocmd!
  autocmd BufReadPre  *.bin let &binary =1
  autocmd BufReadPost * if &binary | silent %!xxd -g 1
  autocmd BufReadPost * set ft=xxd | endif
  autocmd BufWritePre * if &binary | %!xxd -r | endif
  autocmd BufWritePost * if &binary | silent %!xxd -g 1
  autocmd BufWritePost * set nomod | endif
augroup END

if &term =~ "xterm-256color"
  "colorscheme desert256
  colorscheme molokai
endif

"行頭のスペースの連続をハイライトさせる
"Tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に
"設定する必要がある。
function! SOLSpaceHilight()
    syntax match SOLSpace "^\t\+" display containedin=ALL
    "highlight SOLSpace cterm=underline ctermfg=DarkGray
endf

"全角スペースをハイライトさせる。
function! JISX0208SpaceHilight()
    syntax match JISX0208Space "　" display containedin=ALL
    highlight JISX0208Space cterm=underline ctermfg=LightCyan
endf
"highlight IdeographicSpace term=underline ctermbg=LightCyan guibg=LightCyan
"autocmd VimEnter,WinEnter * match IdeographicSpace /　/

"syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
if has("syntax")
    syntax on
        augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call SOLSpaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif

autocmd FileType yaml set expandtab
autocmd BufNewFile,BufRead *.ru setfiletype ruby
autocmd BufNewFile,BufRead *.flow setfiletype yaml
autocmd BufNewFile,BufRead *.twig setfiletype htmldjango
autocmd BufNewFile,BufRead *.twig set softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.xml.twig setfiletype xml
autocmd BufNewFile,BufRead *.html set softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.rst.inc setfiletype rst
autocmd BufNewFile,BufRead *.css set softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.less set softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.less setfiletype less

" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_snippets_dir = '~/.vim/snippets,~/.vim/bundle/snipmate-snippets/snippets'

" zencoding
let g:user_zen_settings = { 'indentation': '  ' }

" unite
nnoremap <C-o> :Unite outline<Return>
