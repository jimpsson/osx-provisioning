" dein settings {{{
if ! &compatible | set nocompatible | endif
"if has('nvim') | let $NVIM_TUI_ENABLE_TRUE_COLOR=1 | endif

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
