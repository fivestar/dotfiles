scriptencoding utf-8

if has('vim_starting')
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Align'
NeoBundle 'sudo.vim'
NeoBundle 'desert256.vim'
NeoBundle 'molokai'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'groenewege/vim-less'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'nginx.vim'
NeoBundle 'othree/html5.vim'
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'fatih/vim-go'

if $SUDO_USER == ''
    NeoBundle 'Shougo/neocomplcache'
    NeoBundle 'Shougo/neosnippet'
    NeoBundle 'Shougo/vimproc.vim', {
          \ 'build' : {
          \     'windows' : 'tools\\update-dll-mingw',
          \     'cygwin' : 'make -f make_cygwin.mak',
          \     'mac' : 'make -f make_mac.mak',
          \     'unix' : 'make -f make_unix.mak',
          \    },
          \ }
    NeoBundle 'Shougo/vimfiler'
    NeoBundle 'Shougo/unite.vim'
    NeoBundle 'Shougo/unite-outline'
endif

call neobundle#end()

" Required:
" filetype plugin indent on

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
"set fileencodings=utf-8,cp932,euc-jp,iso-2022-jp " list of character encodings considered when starting to edit an existing file.
set fileencodings=utf-8

set ambiwidth=double " Use twice the width of ASCII characters.

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

augroup vimrc
    autocmd FileType yaml set expandtab
    autocmd BufNewFile,BufRead *.ru setfiletype ruby
    autocmd BufNewFile,BufRead *.flow setfiletype yaml
    autocmd BufNewFile,BufRead *.twig set softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html.twig set syntax=htmldjango
    autocmd BufNewFile,BufRead *.xml.twig set syntax=xml
    autocmd BufNewFile,BufRead *.js.twig set syntax=javascript
    autocmd BufNewFile,BufRead *.html set softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.rst.inc setfiletype rst
    autocmd BufNewFile,BufRead *.yml set softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js set softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css set softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.less set softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.less setfiletype less
    autocmd BufNewFile,BufRead *.go set noexpandtab
augroup END

" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_auto_completion_start_length = 2
let g:neosnippet#snippets_directory = '~/.vim/snippets,~/.vim/bundle/snipmate-snippets/snippets'

" emmet
let g:user_emmet_settings = { 'indentation': '  ' }

" vim-go
let g:go_play_open_browser = 0
let g:go_fmt_command = "gofmt"
let g:go_fmt_fail_silently = 1
let g:go_snippet_engine = "neosnippet"

if $SUDO_USER == ''
    " バッファ一覧
    noremap <C-P> :Unite buffer<CR>
    " ファイル一覧
    noremap <C-N> :Unite -buffer-name=file file<CR>
    " 最近使ったファイルの一覧
    noremap <C-Z> :Unite file_mru<CR>
    "" ウィンドウを分割して開く
    au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    " ウィンドウを縦に分割して開く
    au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    " ESCキーを2回押すと終了する
    au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
    au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
    " 初期設定関数を起動する
    au FileType unite call s:unite_my_settings()
    function! s:unite_my_settings()
      " Overwrite settings.
    endfunction

    " unite-outline
    nnoremap <C-o> :Unite outline<Return>
endif

"set spell
"set spelllang=en,cjk
"
"fun! s:SpellConf()
"  redir! => syntax
"  silent syntax
"  redir END
"
"  set spell
"
"  if syntax =~? '/<comment\>'
"    syntax spell default
"    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent containedin=Comment contained
"  else
"    syntax spell toplevel
"    syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent
"  endif
"
"  syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
"endfunc
"
"augroup spell_check
"  autocmd!
"  autocmd BufReadPost,BufNewFile,Syntax * call s:SpellConf()
"augroup END


" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
