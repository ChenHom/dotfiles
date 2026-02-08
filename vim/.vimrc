syntax on

" 初始化 vim-plug
call plug#begin('~/.vim/plugged')

" 安裝 vim-numbertoggle 插件
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" 結束插件區塊
call plug#end()

" 安裝 vim-numbertoggle 插件
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" 啟用 cursorline 和 cursorcolumn
set cursorline
set cursorcolumn

" color scheme

" highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" search
set incsearch

set ignorecase
set smartcase

set autoindent         " 自動縮排
set smartindent        " 智慧縮排
set tabstop=4          " 設定 tab 等於 4 個空格
set shiftwidth=4       " 設定縮排為 4 個空格
set expandtab          " 使用空格代替 tab
set softtabstop=4      " 設定刪除 tab 時也相當於 4 個空格
set textwidth=80       " 設定自動換行的行寬
set number             " 顯示行號
set showmatch          " 顯示括號匹配



autocmd FileType php setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120

" set color scheme
" colorscheme solarized
