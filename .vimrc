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

if $SUDO_USER == ''
    Bundle 'Shougo/neocomplcache'
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

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = 'utf-8,'. s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

" 改行コード自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif


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

" zencoding
let g:user_zen_settings = { 'indentation': '  ' }

" unite
nnoremap <C-o> :Unite outline<Return>
