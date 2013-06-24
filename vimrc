" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if has("win32") || has("win16")
	set guifont=Yahei_Mono:h11
	behave mswin
endif

" show line number
set nu

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
"else
"  set backup		" keep a backup file
"endif
set nobackup
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" not indent public/protected/private
set cinoptions=g0

" win style indentation
set softtabstop=4
set tabstop=4
set shiftwidth=4
set noexpandtab

""""""""""""""""""""""""""""""
"" encoding settings
""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,gbk,euc-jp,euc-kr,latin1
set termencoding=utf-8
set fileencoding=utf-8
let $LANG="zh_CN.UTF-8" 
if has("win32")
	set fileencoding=chinese
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
	language messages zh_CN.utf-8
endif


""""""""""""""""""""""""""""""
" FencView.vim
" """"""""""""""""""""""""""""
" :FencAutoDetect " 自动识别文件编码
" :FencView       " 提供文件编码列表,可以选择
let g:fencview_autodetect=1   " 启动vim时自动识别文件编码
let g:fencview_checklines=200 " 通过前N行来识别文件编码

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss setfiletype xml

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set copyindent   " copy the previous indentation on autoindenting
set ignorecase   " ignore search case
set smartcase    " case sensitive search only have higer cases alpha
set showmatch    " highlight match brackets
set noerrorbells " close error bell
set novisualbell
set t_vb=        " close visual bell

" ctags config
set tags+=,tags,../tags,../include/tags,./*/tags  ",../*/tags   " tags for current project
set tags+=,$VIM/linux_include/tags

" <C-]>       " 跳到:ts的第n个
" <C-T>       " 跳到:tags的第n个
" <C-W><C-]>  " 和<C-]>一样,但是在横向窗口打开
"
" 和<C-]>一样,但是在另一tab页打开关键字对应
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" 和<C-]>一样,但是在竖向窗口打开
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

nmap <silent> <F4> :TagbarToggle<CR>
map <F6> <plug>NERDTreeTabsToggle<CR>
map <F7> <Plug>ShowFunc
map! <F7> <Plug>ShowFunc
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

""""""""""""""""""""""""""""""
"" Omnicppcomplete
""""""""""""""""""""""""""""""
" :help omnicppcomplete
set completeopt=longest,menu      " I really HATE the preview window!!!
let OmniCpp_NameSpaceSearch=2     " 0: namespaces disabled
                                  " 1: search namespaces in the current buffer [default]
                                  " 2: search namespaces in the current buffer and in included files
let OmniCpp_GlobalScopeSearch=1   " 0: disabled 1:enabled
let OmniCpp_ShowAccess=1          " 1: show access
let OmniCpp_ShowPrototypeInAbbr=1 " 1: display prototype in abbreviation
let OmniCpp_MayCompleteArrow=1    " autocomplete after ->
let OmniCpp_MayCompleteDot=1      " autocomplete after .
let OmniCpp_MayCompleteScope=1    " autocomplete after ::
let OmniCpp_DefaultNamespaces=["std", "GLIBCXX_STD"]

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

""""""""""""""""""""""""""""""
"" vim-nerdtree-tabs.vim
""""""""""""""""""""""""""""""
let g:nerdtree_tabs_open_on_gui_startup=1     " Open NERDTree on gvim/macvim startup
let g:nerdtree_tabs_open_on_console_startup=1 " Open NERDTree on console vim startup
let g:nerdtree_tabs_open_on_new_tab=1         " Open NERDTree on new tab creation
let g:nerdtree_tabs_meaningful_tab_names=1    " Unfocus NERDTree when leaving a tab for descriptive tab names
let g:nerdtree_tabs_autoclose=1               " Close current tab if there is only one window in it and it's NERDTree
let g:nerdtree_tabs_synchronize_view=1        " Synchronize view of all NERDTree windows (scroll and cursor position)
" 当用vim-nerdtree-tabs新打开一个tab时,光标定位在新建的窗口,不定位在nerdtree窗口
let g:nerdtree_tabs_focus_on_files=1

""""""""""""""""""""""""""""""
"" show invisible character
""""""""""""""""""""""""""""""
" :set list!    " 显示不可见的字符
" invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" F9: 把当前行行末的空格去掉
nmap <F9> :s=\s\+$==<CR>

" <C-G>: 查找光标所在单词,用quickfix展示出来 (非常实用!!!!)
map <C-G> :execute "let g:word=expand(\"<cword>\")"<Bar>execute "vimgrep /\\<" . g:word ."\\>/g **/*.[ch] **/*.cpp"<Bar>execute "cc 1"<Bar>execute "cw"<CR>
" F10: quickfix下一行
map <silent> <F10> :cnext<CR>
" F11: quickfix上一行
map <silent> <F11> :cprevious<CR>
" 打开QuickFix
" :copen
" 关闭QuickFix窗口
" :cclose

""""""""""""""""""""""""""""""
"" tagbar setting
""""""""""""""""""""""""""""""
let g:tagbar_ctags_bin='ctags'
let g:tagbar_width=30

""""""""""""""""""""""""""""""
"" 在tab间跳转
""""""""""""""""""""""""""""""
" :gt  " 跳到上一个tab
" :gT  " 跳到下一个tab
" <C-t><C-t>: 新建一个tab
map <C-t><C-t> :tabnew<CR>
" <C-t><C-c>: 关闭当前tab
map <C-t><C-c> :tabclose<CR>
" <C-t><C-e>: 新建一个tab,并在新建的tab中打开命令后的参数(文件)
map <C-t><C-e> :tabedit

nmap <A-1> 1gt
nmap <A-2> 2gt
nmap <A-3> 3gt
nmap <A-4> 4gt
nmap <A-5> 5gt
nmap <A-6> 6gt
nmap <A-7> 7gt
nmap <A-8> 8gt
nmap <A-9> 9gt

vmap <A-1> 1gt
vmap <A-2> 2gt
vmap <A-3> 3gt
vmap <A-4> 4gt
vmap <A-5> 5gt
vmap <A-6> 6gt
vmap <A-7> 7gt
vmap <A-8> 8gt
vmap <A-9> 9gt

" for command mode
nmap <S-Tab> <<
" for insert mode
imap <S-Tab> <Esc><<i

""""""""""""""""""""""""""""""
"" misc.
""""""""""""""""""""""""""""""
" select all text
map <C-a> ggVG

nmap t V>
nmap T V<
vmap t >gv
vmap T <gv

map <C-h> <C-w>h
let g:C_Ctrl_j = 'off' " disabled c.vim map C-j
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

""""""""""""""""""""""""""""""
"" change windows size
""""""""""""""""""""""""""""""
" <C-w>(N)- " 当前窗口减小n行高度
" <C-w>(N)+ " 当前窗口增大n行高度
" <C-w>(N)< " 当前窗口减小n个字符大小的宽度
" <C-w>(N)> " 当前窗口增大n个字符大小的宽度

""""""""""""""""""""""""""""""
"" mark.vim settings
""""""""""""""""""""""""""""""
" Highlighting:
"    Normal ,m  高亮/取消高亮当前单词
"           ,n  取消所有高亮
" Searching:
"    Normal ,*  跳到当前单词的下一个匹配
"           ,#  跳到当前单词的上一个匹配
"           ,/  跳到下一个被高亮的单词
"           ,?  跳到上一个被高亮的单词

""""""""""""""""""""""""""""""
"" folden  settings
""""""""""""""""""""""""""""""
set foldenable           " 允许折叠
set foldmethod=syntax    " 根据语法折叠
set foldcolumn=3         " 折叠栏宽度
"setlocal foldlevel=100
set foldlevel=100        " 100: 不自动折叠
set foldopen-=search     " 搜索时不展示折叠
set foldopen-=undo       " undo时不展开折叠

"set foldclose=all
" 用空格来折叠
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

set t_Co=256
if has("gui_running")
	colorscheme desert
else
	colorscheme desertTerm
endif
