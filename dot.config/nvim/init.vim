" dein settings {{{
if ! &compatible | set nocompatible | endif
if has('nvim') | let $NVIM_TUI_ENABLE_TRUE_COLOR=1 | endif

augroup MyAutoCmd
  autocmd!
augroup END

" dein.vimのディレクトリ
let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
let s:dein_dir = s:cache_home . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  let s:toml = '~/.config/dein/plugins.toml'
  let s:lazy_toml = '~/.config/dein/plugins_lazy.toml'

  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml, s:lazy_toml])
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
" }}}
"

" TODO: hack for filetype
" let g:did_load_filetypes = 1


filetype plugin indent on " これをonにしておかないとインデントやプラグインが上手く動かないので必須
syntax on " シンタックスハイライトを有効化
scriptencoding utf-8
" 表示系
set fileformats=unix,dos,mac " 改行コードの自動認識
set ambiwidth=single " ■とか※とかの一部文字を半角として扱うようにする（本音は全角扱いが良いがそれによる不具合も多いのでsingleが無難という結論、iTermの設定とかもambigous widthはシングルにすることにした）
set showmatch " 括弧入力時の対応する括弧を表示
set foldmethod=marker " ファイルを開いた時にマーカーがフォルディングされた状態になるようにする
set nospell " スペルチェックは必要な時に手動で有効化するのでデフォはoffにしておく
set spelllang+=cjk " 日本語はスペルチェック対象から外す
" 装飾系
set number " 行番号を表示
set cursorline " カーソル行の強調表示
set list listchars=tab:▸\ ,trail:-,extends:»,precedes:«,eol:¬,nbsp:% " 非表示文字を見えるようにする
function! s:HilightUnnecessaryWhiteSpace() " 非表示文字をハイライト {{{
  " on ColorScheme
  highlight CopipeMissTab ctermbg=52 guibg=red
  highlight CopipeMissEol ctermbg=52 guibg=red
  highlight TabString ctermbg=52 guibg=red
  highlight ZenkakuSpace ctermbg=52 guibg=red
  " on VimEnter,WinEntercall
  call matchadd("CopipeMissTab", '▸ ')
  call matchadd("CopipeMissEol", '¬ *$')
  " call matchadd("TabString", '\t')
  call matchadd("ZenkakuSpace", '　')
endfunction
autocmd MyAutoCmd ColorScheme,VimEnter,WinEnter * call s:HilightUnnecessaryWhiteSpace() "}}}
" 編集系
set backspace=indent,eol,start " バックスペースで改行やインデントも削除出来るようにする
set autoindent " オートインデントを有効化
autocmd FileType * setlocal formatoptions-=ro "コメント行で改行すると次の行もコメントになってしまうのを防止する
set softtabstop=2 " タブ幅を2タブスペースにする {{{
set shiftwidth=2
set tabstop=2
set expandtab " }}}
" 検索系
set ignorecase " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set smartcase " 検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan " 検索時に最後まで行ったら最初に戻る
set incsearch " 検索文字列入力時に順次対象文字列にヒットさる
set hlsearch " 検索結果文字列のハイライトを有効にする
set wildmenu " コマンドラインウィンドウの補完強化。候補の順番表示で横スクロールメニューみたいなのが表示されるようになるやつ。
set wildmode=longest,list,full " コマンドラインウィンドウのTAB補完で最長一致まで保管した後、一覧表示して、更に順番に選択出来るようにする
" 操作系
set hidden " 編集のままバッファ切り替えができるようにする
set mouse=a " マウスモード有効
set scrolloff=10 " カーソル位置を画面中央に保つ(画面上下10行より先のカーソル移動は画面の方がスクロールする)
" クリップボードからの貼り付け時に自動インデントを無効にする http://bit.ly/IhAnBe {{{
if &term =~# 'xterm' && !has('nvim')
  " nvim は何もしなくても自動でpaste/nopasteしてくれるっぽい？
  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"
  function! XTermPasteBegin(ret) abort
    setlocal paste
    return a:ret
  endfunction
  " mappings
  noremap <special> <expr> <Esc>[200~ XTermPasteBegin('0i')
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin('')
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>
endif " }}}
" マップ定義 {{{
" F2,F3でバッファ切り替え、F4でバッファ削除 {{{
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
" }}}
" 表示行単位で行移動する {{{
nnoremap j gj
onoremap j gj
xnoremap j gj
nnoremap k gk
onoremap k gk
xnoremap k gk
nnoremap <Down> gj
onoremap <Down> gj
xnoremap <Down> gj
nnoremap <Up> gk
onoremap <Up> gk
xnoremap <Up> gk
" }}}
" C-a, C-eで行頭行末に移動する {{{
inoremap <C-a> <ESC>^i
inoremap <C-e> <ESC>$i
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
" }}}
" VISUALモードでインデント操作後に選択範囲を保つ {{{
vnoremap = =gv
vnoremap > >gv
vnoremap < <gv
" }}}
" C-c でMacのクリップボードにコピーする {{{
if dein#util#_is_mac()
  " 無名レジスタ""の内容をpbcopyに渡す
  nmap <C-c> :call system('pbcopy', getreg('"'))<CR>
  " 選択範囲をyankして、更にヤンク内容が入りたての無名レジスタをpbcopyに渡す
  vmap <C-c> y:call system('pbcopy', getreg('"'))<CR>
endif " }}}
" }}} マップ定義

" }}}
